require 'vimprint/model/modes'
require 'vimprint/model/stage'
require 'vimprint/model/commands'

module Vimprint

  %%{
    machine parser;
    action H { @head = p; }
    action T { @tail = p; }

    tabkey = 9;
    enter  = 13;
    ctrl_r = 18;
    escape = 27;

    abort = escape >H @T @{ @stage.add(:trigger, strokes) };
    count = [1-9] >H @T @{ @stage.add(:count, strokes) };
    register = ('"' [a-z])  >H @T @{ @stage.add(:register, strokes) };
    count_register_prefix = (count? register)* count?;

    cut   = [xX]   >H @T @{ @stage.add(:trigger, strokes) };
    cut_command =
      count_register_prefix
      (
        cut @{ @eventlist << RegisterCommand.new(@stage.commit) }
        | abort @{ @eventlist << AbortedCommand.new(@stage.commit) }
      );

    small_letter = [a-z] >H @T @{ @stage.add(:mark, strokes) };
    big_letter = [A-Z] >H @T @{ @stage.add(:mark, strokes) };
    mark = [m`] >H @T @{ @stage.add(:trigger, strokes) };
    mark_command =
      count_register_prefix
      mark
      (
        small_letter @{ @eventlist << MarkCommand.new(@stage.commit) }
        | big_letter @{ @eventlist << MarkCommand.new(@stage.commit) }
        | abort @{ @eventlist << AbortedCommand.new(@stage.commit) }
      );

    undo = 'u' >H @T @{ @stage.add(:trigger, strokes) };
    redo = ctrl_r >H @T @{ @stage.add(:trigger, '<C-r>') };
    history_command =
      count_register_prefix
      (undo | redo) @{ @eventlist << NormalCommand.new(@stage.commit) };

    replace = 'r'  >H @T @{ @stage.add(:trigger, strokes) };
    printable_chars = (print | tabkey | enter)  >H @T @{ @stage.add(:printable_char, strokes) };
    replace_command =
      count_register_prefix
      replace
      (
        printable_chars @{ @eventlist << ReplaceCommand.new(@stage.commit) }
        | abort @{ @eventlist << AbortedCommand.new(@stage.commit) }
      );

    motion = [we] >H @T @{ @stage.add(:motion, strokes) };
    motion_command =
      count_register_prefix
      motion @{ @eventlist << MotionCommand.new(@stage.commit) };

    onestroke_operator = [d>];
    prefixed_operator = [?U];
    twostroke_operator = 'g' prefixed_operator;
    operator = (onestroke_operator | twostroke_operator) >H @T @{ @stage.add(:operator, strokes) };
    operator_echo = (onestroke_operator | twostroke_operator | prefixed_operator) >H @T @{ @stage.add(:operator, strokes) };

    disallowed_in_operator_pending = (escape| tabkey | '"') >H @T @{ @stage.add(:trigger, strokes) };
    operation =
      count_register_prefix
      operator
      count?
      (
        motion @{ @eventlist << Operation.build(@stage) }
        | operator_echo @{ @eventlist << Operation.build(@stage) }
        | disallowed_in_operator_pending @{ @eventlist << AbortedCommand.new(@stage.commit) }
      );

    normal  := (
      cut_command |
      mark_command |
      history_command |
      replace_command |
      motion_command |
      operation
    )*;

  }%%

  class Parser

    attr_accessor :data

    def initialize(listener=[])
      @eventlist = listener
      @stage = Stage.new
      %% write data;
    end

    def process(input)
      @data = input.unpack("c*")
      stack = []
      %% write init;
      %% write exec;
      @eventlist
    end

    def strokes
      keystrokes(@data[@head..@tail].pack('c*'))
    end

    def keystrokes(input)
      input
      .gsub(/ /, '<Space>')
      .gsub(/\t/, '<Tab>')
      .gsub(/\r/, '<Enter>')
      .gsub(/\e/, '<Esc>')
    end

  end
end
