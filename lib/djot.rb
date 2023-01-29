require_relative "djot/version"
require_relative "djot/javascript"
require_relative "djot/lua"

# Provides Djot parsing functionalities.
# +Djot.*+ methods are pointing to Lua implementation now.
# See also Djot::JavaScript for ones pointing to JavaScript implementation.
module Djot
  class Error < StandardError; end

  def self.render_html(input)
    Lua.render_html(input)
  end

  def self.render_matches(input)
    Lua.render_matches(input)
  end

  def self.render_ast(input)
    Lua.render_ast(input)
  end
end
