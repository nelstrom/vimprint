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
          'h' => [
            "move left 1 character",
            "move left #{count} characters"
          ],
          'j' => [
            "move down 1 line",
            "move down #{count} lines"
          ],
          'k' => [
            "move up 1 line",
            "move up #{count} lines"
          ],
          'l' => [
            "move right 1 character",
            "move right #{count} characters"
          ],
          'b' => [
            "move to start of current/previous word",
            "move to start of current/previous word #{count} times"
          ],
          'w' => [
            "move to start of next word",
            "move to start of next word #{count} times"
          ],
          'e' => [
            "move to end of current/next word",
            "move to end of current/next word #{count} times"
          ],
          '0' => ["move to start of current line"],
          # switches
          'i' => [
            "insert in front of cursor",
            "insert #{count} times in front of cursor"
          ],
          'I' => [
            "insert at start of line",
            "insert #{count} times at start of line"
          ],
          'a' => [
            "append after the cursor",
            "append #{count} times after the cursor"
          ],
          'A' => [
            "append at end of line",
            "append #{count} times at end of line"
          ],
          's' => [
            "delete current character and switch to insert mode",
            "delete #{count} characters and switch to insert mode"
          ],
          'S' => [
            "delete current line and switch to insert mode",
            "delete #{count} lines and switch to insert mode"
          ],
          'o' => [
            "open a new line below the current line, switch to insert mode",
            "#{count} times open a new line below the current line"
          ],
          'O' => [
            "open a new line above the current line, switch to insert mode"
          ],
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
      "#{raw_keystrokes} - #{Dictionary.lookup(trigger, :normal, count)}"
    end
  end

  class Switch
    def explain
      "#{raw_keystrokes} - #{Dictionary.lookup(trigger, :normal, count)}"
    end
  end

  class NormalCommand
    def explain
      "#{trigger} - #{Dictionary.lookup(trigger)}"
    end
  end

  class VisualOperation
    def explain
      "#{keystroke} - #{Dictionary.lookup(keystroke, :visual)}"
    end
  end

  class AbortedCommand
    def explain
      "#{raw_keystrokes} - [aborted command]"
    end
  end

end
