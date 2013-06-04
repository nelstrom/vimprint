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
          'h' => ["move 1 character to the left"],
          'j' => ['move 1 line down', "move #{count} lines down"],
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
