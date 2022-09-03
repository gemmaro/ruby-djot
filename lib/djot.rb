# frozen_string_literal: true

require_relative "djot/version"
require "language/lua"

module Djot
  class Error < StandardError; end

  LUA = Language::Lua.new.tap do |lua|
    lua.eval(<<~END_LUA)
      function djot_parser(input)
        local parser = require("djot").Parser:new(input)
        parser:parse()
        return parser
      end

      function djot_render_html(input)
        return djot_parser(input):render_html()
      end

      function djot_render_matches(input)
        return djot_parser(input):render_matches()
      end

      function djot_render_ast(input)
        return djot_parser(input):render_ast()
      end
    END_LUA
  end

  def self.render_html(input)
    LUA.djot_render_html(input)
  end

  def self.render_matches(input)
    LUA.djot_render_matches(input)
  end

  def self.render_ast(input)
    LUA.djot_render_ast(input)
  end
end
