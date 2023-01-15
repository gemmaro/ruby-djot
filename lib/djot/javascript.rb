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

    # Correspond to +djot.parse+ of djot.js
    # (https://github.com/jgm/djot.js#parsing-djot-to-an-ast)
    #
    # TODO: support +warn+ option
    def self.parse(input, source_positions: false)
      context.call("djot.parse", input, { "sourcePositions" => source_positions })
    end
    end
  end
end
