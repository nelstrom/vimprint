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

    describe '#keystrokes' do

      it 'returns simple characters unchanged' do
        assert_equal 'abcdef', Parser.new.keystrokes('abcdef')
      end

      it 'replaces " " with <Space>' do
        assert_equal 'r<Space>', Parser.new.keystrokes('r ')
      end

      it 'replaces "\t" with <Tab>' do
        assert_equal 'r<Tab>', Parser.new.keystrokes("r\t")
      end

    end

  end

end
