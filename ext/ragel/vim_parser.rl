%%{
  machine vim_parser;
  include characters "characters.rl";
  include insert_mode "insert_mode.rl";
  include command_line_mode "command_line_mode.rl";

  action EmitMotion { @listener << Motion.new(strokes) }
  action EmitSwitch {
    @listener << Switch.new(strokes)
    @listener << InsertMode.new
    fcall insert;
  }
  action EmitPrompt {
    @listener << Prompt.new(strokes)
    @listener << CmdlineMode.new
    fcall command_line_mode;
  }

  motion = ([hjklbwe0] | 'gj' | 'gk') >H@T @EmitMotion;
  switch = ([iIaAsSoO]) >H@T @EmitSwitch;
  prompt = ':' >H@T @EmitPrompt;

  normal  := (
    motion |
    switch |
    prompt
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
