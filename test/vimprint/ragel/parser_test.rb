require 'vimprint/ragel/parser'

module Vimprint
  describe Parser do
    it 'accepts a simple "x" command' do
      events = []
      parser = Parser.new(events)
      parser.process("x")
      assert_equal ["x"], events
    end
  end
end
