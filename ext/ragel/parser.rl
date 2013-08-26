require 'vimprint/model/modes'
require 'vimprint/model/stage'
require 'vimprint/model/commands'

module Vimprint

  %%{
    machine parser;
    action H { @head = p; }
    action T { @tail = p; }

    ctrl_r = 18;

    count = [1-9] >H @T @{ @stage.add_count(strokes) };
    register = '"' [a-z]  >H @T @{ @stage.add_register(strokes) };
    cut   = [xX]   >H @T @{ @stage.add_trigger(strokes) };
    cut_command =
      (
        count?
        register
      )?
      count?
      cut @{ @eventlist << RegisterCommand.new(@stage.commit) };

    small_letter = [a-z] >H @T @{ @stage.add_mark(strokes) };
    big_letter = [A-Z] >H @T @{ @stage.add_mark(strokes) };
    mark = [m`] >H @T @{ @stage.add_trigger(strokes) };
    mark_command =
      count?
      mark
      (small_letter | big_letter) @{ @eventlist << MarkCommand.new(@stage.commit) };

    undo = 'u' >H @T @{ @stage.add_trigger(strokes) };
    redo = ctrl_r >H @T @{ @stage.add_trigger('<C-r>') };
    history_command =
      count?
      (undo | redo) @{ @eventlist << NormalCommand.new(@stage.commit) };

    normal  := (cut_command | mark_command | history_command)*;

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
      @data[@head..@tail].pack('c*')
    end

  end
end
