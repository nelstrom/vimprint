require 'vimprint/formatters/base_formatter'
require 'vimprint/model/modes'
require 'vimprint/model/commands'

module Vimprint

  class Couple < Struct.new(:keystrokes, :explanation)
    def to_a
      [keystrokes, explanation]
    end
  end

  class Explainer < BaseFormatter
    def explain
      commands.explain
    end
  end

  class NormalMode
    def explain
      map { |o| o.explain("normal") }.flatten.map(&:to_a)
    end
  end

  class VisualMode
    def explain(context)
      map { |o| o.explain("visual") }
    end
  end

  class BaseCommand
    def explain(context)
      Couple.new(raw_keystrokes, lookup(context))
    end

    def lookup(context)
      Registry.lookup(context, signature).render(binding)
    end
  end

  class BareMotion
    def lookup(context)
      Registry.get_motion(signature).render(binding).strip
    end
  end

  class MotionCommand
    def lookup(context)
      [verb, super].compact.join(" ")
    end
  end

  class Echo
    def lookup(context)
      count > 1 ? "#{count} lines" : "a line"
    end
  end

  class Operator
    def lookup(context)
      Registry.get_operator(signature)
    end
  end

  class Operation
    def lookup(context)
      [operator.lookup(context), extent.lookup(context)].join(" ")
    end
  end

  class VisualSwitch
    def explain(context)
      [
        super,
        [commands.explain(context)].flatten
      ]
    end
  end

  class Terminator
    def lookup(context)
      Registry.lookup(context, signature).render(binding).strip
    end
  end

end
