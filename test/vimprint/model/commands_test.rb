require 'minitest/autorun'
require 'vimprint/model/commands'

module Vimprint

  describe NormalCommand do
    it 'can describe its plurality' do
      assert_equal 'singular', NormalCommand.new.plurality
      assert_equal 'singular', NormalCommand.new({count: 1}).plurality
      assert_equal 'plural', NormalCommand.new({count: 2}).plurality
    end
  end

  describe RegisterCommand do
    it 'can describe its register' do
      assert_equal 'default', RegisterCommand.new.register_description
      assert_equal 'named', RegisterCommand.new({register: 'a'}).register_description
    end
  end

  describe Motion do
    it 'assumes it\'s being called from Normal mode' do
      assert_equal 'move', Motion.new.verb
    end
  end
end
