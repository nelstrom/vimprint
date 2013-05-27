require 'minitest/autorun'
require_relative '../../lib/vimprint/vim_parser'

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

  it 'parses i as a switch' do
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

end
