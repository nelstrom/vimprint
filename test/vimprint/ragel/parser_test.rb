require 'vimprint/ragel/parser'

module Vimprint

  describe Parser do

    def scan(keystrokes)
      Parser.new.process(keystrokes)
    end

    it 'accepts a simple "x" command' do
      assert_equal [NormalCommand.new({trigger: "x", count: nil, raw_keystrokes: "x"})], scan("x")
    end

    it 'accepts "2x" command' do
      assert_equal [NormalCommand.new({trigger: 'x', count: 2, raw_keystrokes: "2x"})], scan("2x")
    end

  end

end
