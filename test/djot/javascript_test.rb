require "test_helper"

module Djot
  class JavaScriptTest < Test::Unit::TestCase
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

    test "parser with source positions" do
      expected = { "children" =>
                   [{ "children" =>
                      [{ "pos" =>
                         { "end" => { "col" => 8, "line" => 1, "offset" => 7 },
                           "start" => { "col" => 1, "line" => 1, "offset" => 0 } },
                         "tag" => "str",
                         "text" => "This is " },
                       { "children" =>
                         [{ "pos" =>
                            { "end" => { "col" => 13, "line" => 1, "offset" => 12 },
                              "start" => { "col" => 10, "line" => 1, "offset" => 9 } },
                            "tag" => "str",
                            "text" => "djot" }],
                         "pos" =>
                            { "end" => { "col" => 14, "line" => 1, "offset" => 13 },
                              "start" => { "col" => 9, "line" => 1, "offset" => 8 } },
                         "tag" => "strong" }],
                      "pos" =>
                              { "end" => { "col" => 15, "line" => 1, "offset" => 14 },
                                "start" => { "col" => 1, "line" => 1, "offset" => 0 } },
                      "tag" => "para" }],
                   "footnotes" => {},
                   "references" => {},
                   "tag" => "doc" }
      assert_equal(expected, Djot::JavaScript.parse("This is *djot*", source_positions: true))
    end

    test "render AST" do
      expected = <<~END_TEXT
        doc
          para
            str text="This is "
            strong
              str text="djot"
      END_TEXT
      assert_equal(expected, Djot::JavaScript.render_ast(Djot::JavaScript.parse("This is *djot*")))
    end

    test "render HTML" do
      assert_equal("<p>This is <strong>djot</strong></p>\n",
                   Djot::JavaScript.render_html(Djot::JavaScript.parse("This is *djot*")))
    end

    test "render Djot from short example" do
      assert_equal("This is *djot*\n", Djot::JavaScript.render_djot(Djot::JavaScript.parse("This is *djot*")))
    end

    LONG_LINES = Array.new(3, Array.new(100, "word").join(" ")).join("\n")

    test "render Djot from long lines with default option" do
      expected = <<~END_TEXT
        word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word
      END_TEXT

      assert_equal(expected, Djot::JavaScript.render_djot(Djot::JavaScript.parse(LONG_LINES)))
    end

    test "render Djot from long lines with wrapped option" do
      expected = <<~END_TEXT
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word
      END_TEXT

      assert_equal(expected, Djot::JavaScript.render_djot(Djot::JavaScript.parse(LONG_LINES), wrap_width: 80))
    end

    test "render Djot from long lines with not wrapped and line breaked option" do
      expected = <<~END_TEXT
        word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word
        word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word
      END_TEXT

      assert_equal(expected, Djot::JavaScript.render_djot(Djot::JavaScript.parse(LONG_LINES), wrap_width: 0))
    end

    test "render Djot from long lines with not wrapped and spaced option" do
      expected = <<~END_TEXT
        word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word word
      END_TEXT

      assert_equal(expected, Djot::JavaScript.render_djot(Djot::JavaScript.parse(LONG_LINES), wrap_width: -1))
    end

    test "to Pandoc" do
      assert_equal({ "blocks" =>
                     [{ "c" =>
                        [{ "c" => "This", "t" => "Str" },
                         { "t" => "Space" },
                         { "c" => "is", "t" => "Str" },
                         { "t" => "Space" },
                         { "c" => [{ "c" => "djot", "t" => "Str" }], "t" => "Strong" }],
                        "t" => "Para" }],
                     "meta" => {},
                     "pandoc-api-version" => [1, 22, 2, 1] },
                   Djot::JavaScript.to_pandoc(Djot::JavaScript.parse("This is *djot*")))
    end

    test "from Pandoc" do
      assert_equal({ "children" =>
                     [{ "children" =>
                        [{ "tag" => "str", "text" => "This is " },
                         { "children" => [{ "tag" => "str", "text" => "djot" }], "tag" => "strong" }],
                        "tag" => "para" }],
                     "footnotes" => {},
                     "references" => {},
                     "tag" => "doc" },
                   Djot::JavaScript.from_pandoc({ "blocks" =>
                                                  [{ "c" =>
                                                     [{ "c" => "This", "t" => "Str" },
                                                      { "t" => "Space" },
                                                      { "c" => "is", "t" => "Str" },
                                                      { "t" => "Space" },
                                                      { "c" => [{ "c" => "djot", "t" => "Str" }],
                                                        "t" => "Strong" }],
                                                     "t" => "Para" }],
                                                  "meta" => {},
                                                  "pandoc-api-version" => [1, 22, 2, 1] }))
    end

    test "version" do
      assert_equal("0.2.1", Djot::JavaScript::VERSION)
    end
  end
end
