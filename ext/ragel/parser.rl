module Vimprint

  %%{
    machine parser;

    normal  := ('x')*;

  }%%

  class Parser

    attr_accessor :data

    def initialize(listener)
      @listener = listener
      %% write data;
    end

    def process(input)
      @data = input.unpack("c*")
      stack = []
      %% write init;
      %% write exec;
    end

    def strokes
      @data[@head..@tail].pack('c*')
    end

  end
end
