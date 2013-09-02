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
      ].join(" ")
    end
  end

end
