# frozen_string_literal: true

require "test_helper"

class DjotTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Djot.const_defined?(:VERSION)
    end
  end

  test "render_html" do
    assert_equal("<p>This is <strong>djot</strong></p>\n", Djot.render_html("This is *djot*"))
  end

  test "render_matches" do
    assert_equal(<<~END_MATCHES.encode(Encoding::ASCII_8BIT), Djot.render_matches("This is *djot*"))
      +para 1-1
      str 1-8
      +strong 9-9
      str 10-13
      -strong 14-14
      -para 15-15
    END_MATCHES
  end
end
