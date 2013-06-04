module Vimprint

  class NormalMode < Array
    def explain
      map(&:explain).join("\n")
    end
  end

  class VisualMode < Array
    def explain
      map(&:explain).join("\n")
    end
  end

  class InsertMode < Array
  end

  class Motion < Struct.new(:keystroke, :count)
    def explain
      "#{count}#{keystroke} - #{Dictionary.lookup(keystroke, :normal, count)}"
    end
  end

  class Switch  < Struct.new(:keystroke)
  end

  class Input  < Struct.new(:keystroke)
  end

  class Terminator < Struct.new(:keystroke)
  end

  class NormalCommand < Struct.new(:keystroke)
    def explain
      "#{keystroke} - #{Dictionary.lookup(keystroke)}"
    end
  end

  class VisualOperation < Struct.new(:keystroke)
    def explain
      "#{keystroke} - #{Dictionary.lookup(keystroke, :visual)}"
    end
  end
end

# NormalMode[
#   Motion.new('j'),
#   'k',
#   'l',
#   InsertMode.new(Switch.new('i'), [
#     Input.new('h'),
#     'e',
#     'l',
#     'l',
#     'o',
#     ExpressionLineMode[
#       '4',
#       '0',
#       '+',
#       '2',
#       Terminator.new("\n"),
#     ]
#     Terminator.new("\e"),
#   ]),
#   'j',
# ]
