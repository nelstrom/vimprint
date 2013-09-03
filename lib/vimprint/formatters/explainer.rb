require 'vimprint/formatters/base_formatter'

module Vimprint
  class Explainer < BaseFormatter
    def explain
      commands.explain
    end
  end

  class NormalMode
    def explain
      map { |o| o.explain("normal") }
    end
  end

  class BaseCommand
    def explain(context)
      [raw_keystrokes, lookup(context)]
    end

    def lookup(context)
      Registry.get_mode(context).get_command(signature).render(binding)
    end
  end

  class Motion
    def lookup(context)
      [
        verb,
        Registry.get_mode("normal").get_command(signature).render(binding).strip
      ].compact.join(" ")
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

end
