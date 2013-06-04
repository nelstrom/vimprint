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

end
