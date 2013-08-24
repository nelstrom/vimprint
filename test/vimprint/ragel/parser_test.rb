require 'vimprint/ragel/parser'

module Vimprint

  describe Parser do

    def scan(keystrokes)
      Parser.new.process(keystrokes)
    end

    it 'accepts a simple "x" command' do
      assert_equal [NormalCommand.new("x")], scan("x")
    end
  end

end
