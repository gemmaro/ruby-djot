require "pathname"
require "execjs"

module Djot
  # Functionalities of djot.js
  module JavaScript
    PATH = Pathname(__dir__) / ".." / "js" / "djot.js"

    def self.source
      @source ||= PATH.read
    end

    def self.context
      @context ||= ExecJS.compile(source)
    end

    # Correspond to +djot.parse+
    # (https://github.com/jgm/djot.js#parsing-djot-to-an-ast)
    #
    # TODO: support +warn+ option
    def self.parse(input, source_positions: false)
      context.call("djot.parse", input, { "sourcePositions" => source_positions })
    end

    # TODO: support +djot.EventParser+
    # (https://github.com/jgm/djot.js#parsing-djot-to-a-stream-of-events)

    # Correspond to +djot.renderAST+
    # (https://github.com/jgm/djot.js#pretty-printing-the-djot-ast)
    def self.render_ast(doc)
      context.call("djot.renderAST", doc)
    end

    # Correspond to +djot.renderHTML+
    # (https://github.com/jgm/djot.js#rendering-the-djot-ast-to-html)
    #
    # TODO: support +options+
    def self.render_html(doc)
      context.call("djot.renderHTML", doc)
    end

    # Correspond to +djot.renderDjot+
    # (https://github.com/jgm/djot.js#rendering-djot)
    #
    # TODO: support options
    def self.render_djot(doc, wrap_width: nil)
      options = {}
      options["wrapWidth"] = wrap_width if wrap_width

      context.call("djot.renderDjot", doc, options)
    end

    # Correspond to +djot.toPandoc+
    # (https://github.com/jgm/djot.js#pandoc-interoperability)
    #
    # TODO: support +warn+ and +smart_punctuation_map+ option
    def self.to_pandoc(doc)
      context.call("djot.toPandoc", doc)
    end

    # Correspond to +djot.fromPandoc+
    # (https://github.com/jgm/djot.js#pandoc-interoperability)
    #
    # TODO: support options
    def self.from_pandoc(pandoc)
      context.call("djot.fromPandoc", pandoc)
    end

    # TODO: support filters

    # Correspond to +djot.version+
    # (https://github.com/jgm/djot.js#getting-the-version)
    VERSION = context.eval("djot.version")
  end
end
