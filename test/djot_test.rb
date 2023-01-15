require "test_helper"

class DjotTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Djot.const_defined?(:VERSION)
    end
  end

  # JavaScript

  test "parse" do
    expected = { "children" =>
                [{ "children" =>
                  [{ "tag" => "str", "text" => "This is " },
                   { "children" => [{ "tag" => "str", "text" => "djot" }], "tag" => "strong" }],
                   "tag" => "para" }],
                 "footnotes" => {},
                 "references" => {},
                 "tag" => "doc" }
    assert_equal(expected, Djot::JavaScript.parse("This is *djot*"))
  end

  # Lua

  test "render HTML" do
    assert_equal("<p>This is <strong>djot</strong></p>\n", Djot.render_html("This is *djot*"))
  end

  test "render matches" do
    assert_equal(<<~END_MATCHES.encode(Encoding::ASCII_8BIT), Djot.render_matches("This is *djot*"))
      +para 1-1
      str 1-8
      +strong 9-9
      str 10-13
      -strong 14-14
      -para 15-15
    END_MATCHES
  end

  test "render AST" do
    assert_equal(<<~END_MATCHES.encode(Encoding::ASCII_8BIT), Djot.render_ast("This is *djot*"))
      para
        str
          "This is "
        strong
          str
            "djot"
      references = {
      }
      footnotes = {
      }
    END_MATCHES
  end

  module States
    IGNORE = 0
    INPUT = 1
    OUTPUT = 2
  end

  Case = Struct.new(:ticks, :modifier, :input, :output, keyword_init: true)

  Dir["#{__dir__}/../vendor/djot/test/*"].each do |path|
    state = States::IGNORE
    current_case = Case.new
    current_case.input = ""
    current_case.output = ""
    index = 0
    File.foreach(path) do |line|
      line.force_encoding(Encoding::UTF_8)
      case state
      when States::IGNORE
        next unless (match = line.match(/\A(?<ticks>`+)\s*(?:\[(?<modifier>[^\s\]]*)\])?\n\Z/))

        current_case.ticks = match[:ticks]
        current_case.modifier = match[:modifier]
        current_case.modifier ||= :html
        current_case.modifier = current_case.modifier.intern
        state = States::INPUT
      when States::INPUT
        unless line == ".\n"
          current_case.input += line
          next
        end

        state = States::OUTPUT
      when States::OUTPUT
        unless line.match?(/\A#{current_case.ticks}\n\Z/)
          current_case.output += line
          next
        end

        test "#{File.basename(path)} > #{index}" do
          assert_equal(current_case.output, Djot.render_html(current_case.input))
        end
        current_case.input = ""
        current_case.output = ""
        current_case.ticks = nil
        current_case.modifier = nil
        index += 1
        state = States::IGNORE
      end
    end
  end
end
