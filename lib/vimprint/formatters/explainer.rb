require 'vimprint/formatters/base_formatter'

module Vimprint
  class Explainer < BaseFormatter
    def explain
      commands.explain
    end
  end

  class NormalMode
    def explain
      map(&:explain)
    end
  end

  class BaseCommand
    def explain
      [
        raw_keystrokes,
        Registry.get_mode('normal').get_command(signature).render(binding)
      ]
    end
  end
end
