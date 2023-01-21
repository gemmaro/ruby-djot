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

    # TODO: support +djot.EventParser+
    # (https://github.com/jgm/djot.js#parsing-djot-to-a-stream-of-events)

    # Correspond to +djot.renderAST+ of djot.js
    # (https://github.com/jgm/djot.js#pretty-printing-the-djot-ast)
    def self.render_ast(doc)
      context.call("djot.renderAST", doc)
    end

    # Correspond to +djot.renderHTML+
    # (https://github.com/jgm/djot.js#rendering-the-djot-ast-to-html)
    # TODO: support +options+
    def self.render_html(doc)
      context.call("djot.renderHTML", doc)
    end

    # Correspond to +djot.renderDjot+
    # (https://github.com/jgm/djot.js#rendering-djot)
    # TODO: support options
    def self.render_djot(doc)
      context.call("djot.renderDjot", doc)
    end

    # Correspond to +djot.toPandoc+
    # (https://github.com/jgm/djot.js#pandoc-interoperability)
    # TODO: support options
    def self.to_pandoc(doc)
      context.call("djot.toPandoc", doc)
    end

    # TODO
  end
end
