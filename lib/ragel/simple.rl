%%{
  machine vim_print;

  escape = 27;
  input = (any - escape);
  motion = [hjklbwe0];
  switch = [iIaAsSoO];

  insert  := (
    input*
    escape
  );

  normal  := (
    motion |
    switch
  )*;

}%%

class VimParser

  attr_accessor :head, :tail, :data

  def initialize(listener)
    @listener = listener
    %% write data;
  end

  def process(input)
    @data = input.unpack("c*")
    eof = @data.length
    stack = []
    %% write init;
    %% write exec;
  end

  def strokes
    @data[@head..@tail].pack('c*')
  end

end

vi = VimParser.new([])
puts vi.process("ihello\e")
