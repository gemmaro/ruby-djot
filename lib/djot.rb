# frozen_string_literal: true

require_relative "djot/version"
require "language/lua"

# Djot binding
module Djot
  class Error < StandardError; end

  LUA = Language::Lua.new.tap do |lua|
    lua.eval(<<~END_LUA)
      function render_html(input)
        local parser = require("djot").Parser:new(input)
        parser:parse()
        return parser:render_html()
      end
    END_LUA
  end

  def self.render_html(input)
    LUA.render_html(input)
  end
end
