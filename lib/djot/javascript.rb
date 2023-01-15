require "pathname"
require "execjs"

module Djot
  module JavaScript
    PATH = Pathname(__dir__) / ".." / "js" / "djot.js"

    def self.source
      @source ||= PATH.read
    end

    def self.context
      @context ||= ExecJS.compile(source)
    end

    def self.parse(input)
      context.call("djot.parse", input)
    end
  end
end
