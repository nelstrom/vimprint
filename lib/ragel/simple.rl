%%{
  machine vim_print;
  action H { @head = p }
  action T { @tail = p }
  action return { fret; }
  action push_insert_mode { fcall insert_mode; }

  escape = 27 >H@T;
  input = (any - escape) >H@T;
  motion = [hjklbwe0] >H@T;
  switch = [iIaAsSoO] >H@T;

  insert_mode  := (
    input*
    escape @return
  );

  normal_mode  := (
    motion |
    switch @push_insert_mode
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
