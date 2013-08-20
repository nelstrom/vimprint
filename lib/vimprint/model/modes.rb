require './lib/vimprint/model/command_tree'

module Vimprint

  class BaseMode < Array
    extend Vimprint::ModeOpener
  end

  class NormalMode < BaseMode
  end

  class InsertMode < BaseMode
  end

  class VisualMode < BaseMode
  end

  class CmdlineMode < BaseMode
  end

end

# Rationale:
#       the `i` switch opens Normal mode
#       from POV of Normal mode, the Insertion is one event, triggered by the switch
# NormalMode[
#   Motion.new('j'),
#   Motion.new('k'),
#   Motion.new('l'),
#   InsertMode.new(Switch.new('i'), [
#     Input.new('h'),
#     Input.new('e'),
#     Input.new('l'),
#     Input.new('l'),
#     Input.new('o'),
#     ExpressionLineMode.new(Switch.new('<C-r>='), [
#       Input.new('4'),
#       Input.new('0'),
#       Input.new('+'),
#       Input.new('2'),
#       Terminator.new("\n"),
#     ]
#     Terminator.new("\e"),
#   ]),
#   Motion.new('j'),
# ]

# Rationale:
#       the `i` switch is a Normal mode command, so doesn't belong in Insert mode
#       the switch event *owns* the Insertion, by association/proximity
# NormalMode[
#   Motion.new('j'),
#   Motion.new('k'),
#   Motion.new('l'),
#   Switch.new('i'),
#   InsertMode.new([
#     Input.new('h'),
#     Input.new('e'),
#     Input.new('l'),
#     Input.new('l'),
#     Input.new('o'),
#     Switch.new('<C-r>='),
#     ExpressionLineMode[
#       Input.new('4'),
#       Input.new('0'),
#       Input.new('+'),
#       Input.new('2'),
#       Terminator.new("\n"),
#     ]
#     Terminator.new("\e"),
#   ]),
#   Motion.new('j'),
# ]
