require 'vimprint/formatters/base_formatter'

module Vimprint
  class Explainer < BaseFormatter
    def explain
      commands.explain
    end
  end

  class NormalMode
    def explain
      map { |o| o.explain(self) }
    end
  end

  class BaseCommand
    def explain(context)
      [
        raw_keystrokes,
        Registry.get_mode('normal').get_command(signature).render(binding)
      ]
    end
  end

end
