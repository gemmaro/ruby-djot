require "test_helper"

class DjotTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Djot.const_defined?(:VERSION)
    end
  end

  test "render_html" do
    assert_respond_to(Djot, :render_html)
  end

  test "render_matches" do
    assert_respond_to(Djot, :render_matches)
  end

  test "render_ast" do
    assert_respond_to(Djot, :render_ast)
  end
end
