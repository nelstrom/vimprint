require 'minitest/autorun'
require 'vimprint/ragel/insert_parser'
require 'vimprint/event_list'

describe InsertParser do

  before do
    @recorder = InsertMode.new
  end

  def scan(text)
    InsertParser.new(@recorder).process(text)
  end

  def ctrl_R
    "\x12" # Ruby string notation for ctrl_R
  end

  it 'parses hjkl as input' do
    scan("hjkl")
    @recorder.must_equal [
      Input.new('h'),
      Input.new('j'),
      Input.new('k'),
      Input.new('l')
    ]
  end

  it 'parses hjkl as input' do
    scan("a#{ctrl_R}az#{ctrl_R}z")
    @recorder.must_equal [
      Input.new('a'),
      InputRegister.new('a'),
      Input.new('z'),
      InputRegister.new('z'),
    ]
  end

end
