module Vimprint

  # MODES
  class NormalMode < Array; end
  class VisualMode < Array; end
  class InsertMode < Array; end

  # COMMANDS
  class Motion < Struct.new(:raw_keystrokes, :trigger, :count); end
  class Switch < Struct.new(:keystroke, :count); end
  class Input < Struct.new(:keystroke); end
  class Terminator < Struct.new(:keystroke); end
  class NormalCommand < Struct.new(:trigger); end
  class VisualOperation < Struct.new(:keystroke); end
  class AbortedCommand < Struct.new(:raw_keystrokes); end

  module CommandBuilder
    def build(stage)
      new(stage.to_hash)
    end
  end

  class Stage < Struct.new(:trigger, :register)

    attr_reader :register, :trigger, :operator, :motion

    def initialize()
      @buffer = []
      @counts = []
    end

    def to_hash
      {
        raw_keystrokes: raw_keystrokes,
        effective_count: effective_count,
        counts: @counts,
        trigger: @trigger
      }
    end

    def raw_keystrokes
      @buffer.join
    end

    def effective_count
      @counts.inject(1) { |a,b| a*b }
    end

    def add_count(value)
      @counts << value
      @buffer << value
    end

    def add_register(address)
      @register = address
      @buffer << '"' + address
    end

    def add_trigger(keystrokes)
      @trigger = keystrokes
      @buffer << keystrokes
    end

    def add_operator(keystrokes)
      @operator = keystrokes
      @buffer << keystrokes
    end

    def add_motion(keystrokes)
      @motion = keystrokes
      @buffer << keystrokes
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
