module Vimprint

  %%{
    machine parser;
    action H { @head = p; }
    action T { @tail = p; }

    cut = 'x' >H @T @{ @eventlist << strokes };
    normal  := cut*;

  }%%

  class Parser

    attr_accessor :data

    def initialize(listener=[])
      @eventlist = listener
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
