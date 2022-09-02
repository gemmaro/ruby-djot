# frozen_string_literal: true

require "test_helper"

class DjotTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Djot.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
