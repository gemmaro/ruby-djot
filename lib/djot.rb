# frozen_string_literal: true

require_relative "djot/version"
require "language/lua"

# Djot binding
module Djot
  class Error < StandardError; end

  LUA = Language::Lua.new.tap do |lua|
    lua.eval(<<~END_LUA)
      function djot_parser_instance(input)
        return require("djot").Parser:new(input)
      end

      function djot_render_html(input)
        local parser = djot_parser_instance(input)
        parser:parse()
        return parser:render_html()
      end

      -- TODO
      function djot_get_matches(input)
        local parser = djot_parser_instance(input)
        parser:parse()
        return parser:get_matches()
      end

      function djot_render_matches(input)
        local parser = djot_parser_instance(input)
        parser:parse()
        return parser:render_matches()
      end

      function djot_render_ast(input)
        local parser = djot_parser_instance(input)
        parser:parse()
        return parser:render_ast()
      end
    END_LUA
  end

  def self.render_html(input)
    LUA.djot_render_html(input)
  end

  # def self.matches(input)
  #   LUA.djot_get_matches
  # end

  def self.render_matches(input)
    LUA.djot_render_matches(input)
  end

  def self.render_ast(input)
    LUA.djot_render_ast(input)
  end
end
