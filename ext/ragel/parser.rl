require 'vimprint/model/modes'
require 'vimprint/model/stage'
require 'vimprint/model/commands'

module Vimprint

  %%{
    machine parser;
    action H { @head = p; }
    action T { @tail = p; }

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
      mark
      (small_letter | big_letter) @{ @eventlist << MarkCommand.new(@stage.commit) };

    normal  := (cut_command | mark_command)*;

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
