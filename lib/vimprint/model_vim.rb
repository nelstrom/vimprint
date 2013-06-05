module Vimprint

  class NormalMode < Array; end

  class VisualMode < Array; end

  class InsertMode < Array; end

  class Motion < Struct.new(:keystroke, :count); end

  class Switch < Struct.new(:keystroke, :count); end

  class Input < Struct.new(:keystroke); end

  class Terminator < Struct.new(:keystroke); end

  class NormalCommand < Struct.new(:keystroke); end

  class VisualOperation < Struct.new(:keystroke); end

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
