require 'ostruct'

module Vimprint

  # MODES
  class NormalMode < Array
    def mode
      :normal
    end
    def verb
      "move"
    end
  end
  class VisualMode < Array
    def mode
      :visual
    end
    def verb
      "select"
    end
  end
  class InsertMode < Array; end

  module CommandBuilder
    def build(stage)
      new(stage)
    end
  end

  # COMMANDS
  class BaseCommand
    extend CommandBuilder
    def initialize(options={})
      stage = OpenStruct.new(options)
      @raw_keystrokes = stage.raw_keystrokes
      @trigger = stage.trigger
      @counts = stage.counts || Array(stage.count)
      @operator = stage.operator
      @motion = stage.motion
    end

    def effective_count
      @counts.inject(1) { |a,b| a*b }
    end
  end

  class Motion < BaseCommand
    attr_reader :trigger, :raw_keystrokes

    # 1. attr_reader :context
    # 2. SpecificMotion < Motion
    # 3. motion.explain(context)
  end

  class Switch < BaseCommand
    attr_reader :raw_keystrokes, :trigger
  end

  class Input < Struct.new(:keystroke); end
  class Terminator < Struct.new(:keystroke); end

  class NormalCommand < BaseCommand
    attr_reader :trigger
  end

  class Operation < BaseCommand
    attr_reader :raw_keystrokes, :operator, :motion
    def mode
      verb
    end
    def verb
      case operator
      when 'd' then 'delete'
      when 'y' then 'yank'
      end
    end
  end

  class VisualOperation < BaseCommand
    attr_reader :raw_keystrokes, :trigger
  end

  class AbortedCommand < BaseCommand
    attr_reader :raw_keystrokes
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
