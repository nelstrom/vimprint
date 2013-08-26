require 'vimprint/command_registry'

module Vimprint
  class Explainer
    attr_reader :commands

    def initialize(commands)
      @commands = commands
    end

    def explain
      commands.explain
    end
  end

  class NormalMode
    def explain
      map(&:explain)
    end
  end

  class NormalCommand
    def explain
      [
        raw_keystrokes,
        Registry.get_mode('normal').get_command(signature).render(binding)
      ]
    end
  end
end
