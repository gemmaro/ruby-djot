# frozen_string_literal: true

require "test_helper"

class DjotTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Djot.const_defined?(:VERSION)
    end
  end

  test "quick start" do
    assert_equal("<p>This is <strong>djot</strong></p>\n", Djot.render_html("This is *djot*"))
  end
end
