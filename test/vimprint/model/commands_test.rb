require 'minitest/autorun'
require 'vimprint/model/commands'

module Vimprint
  describe BaseCommand do
    it 'can describe its plurality' do
      assert_equal 'singular', BaseCommand.new.plurality
      assert_equal 'singular', BaseCommand.new({count: 1}).plurality
      assert_equal 'plural', BaseCommand.new({count: 2}).plurality
    end
  end
end
