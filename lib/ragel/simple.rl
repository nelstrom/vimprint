%%{
  machine vim_print;
  action return { fret; }
  action push_insert_mode { fcall insert_mode; }

  escape = 27;
  input = (any - escape);
  motion = [hjklbwe0];
  switch = [iIaAsSoO];

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

  attr_accessor :data

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

end

VimParser.new([]).process("ihello\e")
