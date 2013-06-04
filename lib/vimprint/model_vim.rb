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

  Motion = Struct.new(:keystroke, :count) do
    def explain
      "#{count}#{keystroke} - #{Dictionary.lookup(keystroke, :normal, count)}"
    end
  end

  Switch  = Struct.new(:keystroke) do
  end

  Input  = Struct.new(:keystroke) do
  end

  Terminator = Struct.new(:keystroke) do
  end

  NormalCommand = Struct.new(:keystroke) do
    def explain
      "#{keystroke} - #{Dictionary.lookup(keystroke)}"
    end
  end

  VisualOperation = Struct.new(:keystroke) do
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
