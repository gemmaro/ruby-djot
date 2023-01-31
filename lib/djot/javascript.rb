require "pathname"
require "mini_racer"

module Djot
  # Functionalities of djot.js
  module JavaScript
    def self.path # :nodoc:
      @path ||= Pathname(__dir__ || (raise Error)) / ".." / "js" / "djot.js"
    end

    PATH = path # :nodoc:

    deprecate_constant :PATH

    def self.source # :nodoc:
      @source ||= PATH.read
    end

    def self.context # :nodoc:
      return @context if @context

      context = MiniRacer::Context.new
      context.eval("let args, result")
      context.eval(source)
      @context = context
    end

    # Correspond to +djot.parse+
    # (https://github.com/jgm/djot.js#parsing-djot-to-an-ast)
    def self.parse(input, source_positions: nil, warn: nil)
      args = [input]
      options = {}
      options["sourcePositions"] = source_positions if source_positions
      args << options
      context.eval("args = #{JSON.generate(args)}")
      if warn
        context.attach("warn", warn)
        context.eval('args[1]["warn"] = warn')
      end
      context.eval("djot.parse.apply(this, args)")
    end

    # Correspond to +djot.parseEvents+
    # (https://github.com/jgm/djot.js#parsing-djot-to-a-stream-of-events)
    def self.parse_events(input, warn: nil, &block)
      context.eval("args = #{JSON.generate([input, {}])}")
      if warn
        context.attach("warn", warn)
        context.eval('args[1]["warn"] = warn')
      end
      source = if block_given?
                 context.attach("fun", block)
                 <<~END_JAVASCRIPT
                   for (let event of djot.parseEvents(...args)) {
                     fun(event)
                   }
                 END_JAVASCRIPT
               else
                 # TODO: Use enum_for
                 <<~END_JAVASCRIPT
                   events = []
                   for (let event of djot.parseEvents(...args)) {
                     events.push(event)
                   }
                   events
                 END_JAVASCRIPT
               end
      context.eval(source)
    end

    # Correspond to +djot.renderAST+
    # (https://github.com/jgm/djot.js#pretty-printing-the-djot-ast)
    def self.render_ast(doc)
      call("renderAST", doc)
    end

    # Correspond to +djot.renderHTML+
    # (https://github.com/jgm/djot.js#rendering-the-djot-ast-to-html)
    #
    # TODO: support +overrides+ option
    def self.render_html(doc, warn: nil)
      context.eval("args = #{JSON.generate([doc, {}])}")
      if warn
        context.attach("warn", warn)
        context.eval('args[1]["warn"] = warn')
      end
      context.eval("djot.renderHTML.apply(this, args)")
    end

    # Correspond to +djot.renderDjot+
    # (https://github.com/jgm/djot.js#rendering-djot)
    def self.render_djot(doc, wrap_width: nil)
      options = {}
      options["wrapWidth"] = wrap_width if wrap_width

      call("renderDjot", doc, options)
    end

    # Correspond to +djot.toPandoc+
    # (https://github.com/jgm/djot.js#pandoc-interoperability)
    #
    # CAUTION: +warn+ option hasn't yet tested.
    # There may be bugs.
    def self.to_pandoc(doc, warn: nil, smart_punctuation_map: nil)
      options = {}
      options["smartPunctuationMap"] = smart_punctuation_map if smart_punctuation_map
      context.eval("args = #{JSON.generate([doc, options])}")
      if warn
        context.attach("warn", warn)
        context.eval('args[1]["warn"] = warn')
      end
      context.eval("djot.toPandoc.apply(this, args)")
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
    def self.version
      @version ||= context.eval("djot.version")
    end

    VERSION = version # :nodoc:

    deprecate_constant :VERSION

    def self.call(name, *args) # :nodoc:
      context.eval("djot.#{name}.apply(this, #{::JSON.generate(args)})")
    end
  end
end
