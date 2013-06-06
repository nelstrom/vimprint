require_relative '../model_vim'

module Vimprint
  class Formatter
    attr_reader :commands
    def initialize(commands)
      @commands = commands
    end

    def print
      commands.plain_print
    end

  end

  class NormalMode
    def plain_print
      map(&:plain_print).join
    end
  end

  class VisualMode
  end

  class InsertMode
    def plain_print
      map(&:plain_print).join
    end
  end

  class Motion
    def plain_print
      "#{raw_keystrokes} "
    end
  end

  class Switch
    def plain_print
      "\n#{keystroke}{"
    end
  end

  class Input
    def plain_print
      keystroke
    end
  end

  class Terminator
    def plain_print
      "}\n"
    end
  end

  class NormalCommand
  end

  class VisualOperation
  end

end
