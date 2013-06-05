require_relative '../model_vim'
require_relative 'plain_printer'
module Vimprint

  class ExplainFormatter < Formatter
    def print
      commands.explain
    end
  end

  class Dictionary
    SINGULAR = 0
    PLURAL   = 1

    def self.lookup(keystroke, mode=:normal, count=1)
      count ||=1
      plurality = (count == 1) ? SINGULAR : PLURAL

      {
        :normal => {
          # motions
          'h' => ["move left 1 character","move left #{count} characters"],
          'j' => ['move down 1 line', "move down #{count} lines"],
          'k' => ["move up 1 line", "move up #{count} lines"],
          'l' => ["move right 1 character", "move right #{count} characters"],
          'b' => ["move to start of current/previous word"],
          'w' => ["move to start of next word"],
          'e' => ["move to end of current/next word"],
          '0' => ["move to start of current line"],
          # switches
          'i' => [],
          'I' => [],
          'a' => [],
          'A' => [],
          's' => [],
          'S' => [],
          'o' => [],
          'O' => [],
          # misc
          'u' => ["undo the last change"],
        },
        :visual => {
          'u' => ["downcase the selected text"],
        }
      }[mode][keystroke][plurality]
    end

  end

  class NormalMode
    def explain
      map(&:explain).join("\n")
    end
  end

  class VisualMode
    def explain
      map(&:explain).join("\n")
    end
  end

  class Motion
    def explain
      "#{count}#{keystroke} - #{Dictionary.lookup(keystroke, :normal, count)}"
    end
  end

  class NormalCommand
    def explain
      "#{keystroke} - #{Dictionary.lookup(keystroke)}"
    end
  end

  class VisualOperation
    def explain
      "#{keystroke} - #{Dictionary.lookup(keystroke, :visual)}"
    end
  end

end
