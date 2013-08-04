gem 'minitest'
require 'minitest/autorun'
require 'vimprint/ragel/vim_parser'
require 'vimprint/event_list'

describe VimParser do

  before do
    @normal = NormalMode.new
    @events = EventList.new(@normal)
  end

  def scan(text)
    VimParser.new(@events).process(text)
  end

  it 'parses hjkl as motions' do
    scan("hjklgj")
    @events.root.must_equal NormalMode[
      Motion.new('h'),
      Motion.new('j'),
      Motion.new('k'),
      Motion.new('l'),
      Motion.new('gj')
    ]
  end

  it 'parses i as a switch to InsertMode' do
    scan("hjihi\e")
    @events.root.must_equal NormalMode[
      Motion.new('h'),
      Motion.new('j'),
      Switch.new('i'),
      InsertMode[
        Input.new('h'),
        Input.new('i'),
        Terminator.new("\e")
      ]
    ]
  end

  it 'parses : as a switch to CmdlineMode' do
    scan("hj:write\r")
    @events.root.must_equal NormalMode[
      Motion.new('h'),
      Motion.new('j'),
      Prompt.new(':'),
      CmdlineMode[
        Input.new('w'),
        Input.new('r'),
        Input.new('i'),
        Input.new('t'),
        Input.new('e'),
        Terminator.new("\r")
      ]
    ]
  end

end
