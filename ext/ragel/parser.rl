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
    ctrl_v = 22;
    escape = 27;

    abort = escape >H @T @{ @stage.add(:trigger, strokes) };
    count = [1-9] >H @T @{ @stage.add(:count, strokes) };
    register = ('"' [a-z])  >H @T @{ @stage.add(:register, strokes) };
    count_register_prefix = (count? register)* count?;

    cut   = [xX]   >H @T @{ @stage.add(:trigger, strokes) };
    cut_command =
      count_register_prefix
      (
        cut @{ entry_point << RegisterCommand.new(@stage.commit) }
        | abort @{ entry_point << AbortedCommand.new(@stage.commit) }
      );

    small_letter = [a-z] >H @T @{ @stage.add(:mark, strokes) };
    big_letter = [A-Z] >H @T @{ @stage.add(:mark, strokes) };
    mark = [m`] >H @T @{ @stage.add(:trigger, strokes) };
    mark_command =
      count_register_prefix
      mark
      (
        small_letter @{ entry_point << MarkCommand.new(@stage.commit) }
        | big_letter @{ entry_point << MarkCommand.new(@stage.commit) }
        | abort @{ entry_point << AbortedCommand.new(@stage.commit) }
      );

    undo = 'u' >H @T @{ @stage.add(:trigger, strokes) };
    redo = ctrl_r >H @T @{ @stage.add(:trigger, '<C-r>') };
    history_command =
      count_register_prefix
      (undo | redo) @{ entry_point << NormalCommand.new(@stage.commit) };

    replace = 'r'  >H @T @{ @stage.add(:trigger, strokes) };
    printable_chars = (print | tabkey | enter)  >H @T @{ @stage.add(:printable_char, strokes) };
    replace_command =
      count_register_prefix
      replace
      (
        printable_chars @{ entry_point << ReplaceCommand.new(@stage.commit) }
        | abort @{ entry_point << AbortedCommand.new(@stage.commit) }
      );

    motion = [we] >H @T @{ @stage.add(:motion, strokes) };
    motion_command =
      count_register_prefix
      motion @{ entry_point << MotionCommand.new(@stage.commit) };

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
        motion @{ entry_point << Operation.build(@stage) }
        | operator_echo @{ entry_point << Operation.build(@stage) }
        | disallowed_in_operator_pending @{ entry_point << AbortedCommand.new(@stage.commit) }
      );

    charwise_visual = 'v' >H @T @{ @stage.add(:switch, strokes) };
    linewise_visual = 'V' >H @T @{ @stage.add(:switch, strokes) };
    blockwise_visual = ctrl_v >H @T @{ @stage.add(:switch, strokes) };
    lastwise_visual = 'gv' >H @T @{ @stage.add(:switch, strokes) };

    start_charwise_visual_mode =
      charwise_visual @{
        entry_point << (switch = VisualSwitch.new(@stage.commit))
        @modestack.push(switch.commands)
        lastvisual = fentry(visual_charwise_mode);
        fcall visual_charwise_mode;
      };

    start_linewise_visual_mode =
      linewise_visual @{
        entry_point << (switch = VisualSwitch.new(@stage.commit))
        @modestack.push(switch.commands)
        lastvisual = fentry(visual_linewise_mode);
        fcall visual_linewise_mode;
      };

    start_blockwise_visual_mode =
      blockwise_visual @{
        entry_point << (switch = VisualSwitch.new(@stage.commit))
        @modestack.push(switch.commands)
        lastvisual = fentry(visual_blockwise_mode);
        fcall visual_blockwise_mode;
      };

    start_lastwise_visual_mode =
      lastwise_visual @{
        entry_point << (switch = VisualSwitch.new(@stage.commit))
        @modestack.push(switch.commands)
        fcall *lastvisual;
      };

    visual_charwise_mode := (
      (
        motion @{
          entry_point << MotionCommand.new(@stage.commit.merge(invocation_context: 'visual'))
        }
      )*
      (abort | charwise_visual)  @{
        entry_point << Terminator.new(@stage.commit)
        @modestack.pop
        fret;
      }
    );

    visual_linewise_mode := (
      (abort | linewise_visual)  @{
        entry_point << Terminator.new(@stage.commit)
        @modestack.pop
        fret;
      }
    )*;

    visual_blockwise_mode := (
      (abort | blockwise_visual)  @{
        entry_point << Terminator.new(@stage.commit)
        @modestack.pop
        fret;
      }
    )*;

    normal  := (
      cut_command |
      mark_command |
      history_command |
      replace_command |
      motion_command |
      operation |
      start_charwise_visual_mode |
      start_linewise_visual_mode |
      start_blockwise_visual_mode |
      start_lastwise_visual_mode
    )*;

  }%%

  class Parser

    attr_accessor :data

    def initialize(listener=[])
      @eventlist = listener
      @modestack = [@eventlist]
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

    def entry_point
      @modestack.last
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
      .gsub(/\x16/, '<C-v>')
    end

  end
end
