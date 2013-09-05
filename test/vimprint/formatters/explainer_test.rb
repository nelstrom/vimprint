require 'minitest/autorun'
require 'vimprint/formatters/explainer'

module Vimprint

  describe Couple do
    it 'returns array: [keystrokes, explanation]' do
      pair = Couple.new('k', 'move up')
      assert_equal ['k', 'move up'], pair.to_a
    end
  end

end
