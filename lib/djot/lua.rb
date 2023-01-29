require "language/lua"
require "pathname"

module Djot
  module Lua
    LUA = Language::Lua.new
    LUA.eval(<<~END_LUA)
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

    ROOT = Pathname(__dir__) / ".." / "lua"

    def self.render_html(input)
      Dir.chdir(ROOT) do
        LUA.djot_render_html(input)
      end
    end

    def self.render_matches(input)
      Dir.chdir(ROOT) do
        LUA.djot_render_matches(input)
      end
    end

    def self.render_ast(input)
      Dir.chdir(ROOT) do
        LUA.djot_render_ast(input)
      end
    end
  end
end
