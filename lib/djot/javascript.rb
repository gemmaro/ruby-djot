require "pathname"
require "mini_racer"

module Djot
  # Functionalities of djot.js
  module JavaScript
    PATH = Pathname(__dir__ || (raise Error)) / ".." / "js" / "djot.js"

    def self.source
      @source ||= PATH.read
    end

    # :nodoc:
    def self.context
      return @context if @context

      context = MiniRacer::Context.new
      context.eval(source)
      @context = context
    end

    # Correspond to +djot.parse+
    # (https://github.com/jgm/djot.js#parsing-djot-to-an-ast)
    #
    # TODO: support +warn+ option
    def self.parse(input, source_positions: false)
      call("parse", input, { "sourcePositions" => source_positions })
    end

    # TODO: support +djot.EventParser+
    # (https://github.com/jgm/djot.js#parsing-djot-to-a-stream-of-events)

    # Correspond to +djot.renderAST+
    # (https://github.com/jgm/djot.js#pretty-printing-the-djot-ast)
    def self.render_ast(doc)
      call("renderAST", doc)
    end

    # Correspond to +djot.renderHTML+
    # (https://github.com/jgm/djot.js#rendering-the-djot-ast-to-html)
    #
    # TODO: support +options+
    def self.render_html(doc)
      call("renderHTML", doc)
    end

    # Correspond to +djot.renderDjot+
    # (https://github.com/jgm/djot.js#rendering-djot)
    #
    # TODO: support options
    def self.render_djot(doc, wrap_width: nil)
      options = {}
      options["wrapWidth"] = wrap_width if wrap_width

      call("renderDjot", doc, options)
    end

    # Correspond to +djot.toPandoc+
    # (https://github.com/jgm/djot.js#pandoc-interoperability)
    #
    # TODO: support +warn+ and +smart_punctuation_map+ option
    def self.to_pandoc(doc)
      call("toPandoc", doc)
    end

    # Correspond to +djot.fromPandoc+
    # (https://github.com/jgm/djot.js#pandoc-interoperability)
    #
    # TODO: support options
    def self.from_pandoc(pandoc)
      call("fromPandoc", pandoc)
    end

    # TODO: support filters

    # Correspond to +djot.version+
    # (https://github.com/jgm/djot.js#getting-the-version)
    VERSION = context.eval("djot.version")

    # :nodoc:
    def self.call(name, *args)
      context.eval("djot.#{name}.apply(this, #{::JSON.generate(args)})")
    end
  end
end
