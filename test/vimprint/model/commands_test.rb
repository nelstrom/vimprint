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
      motion = NormalMode[
        Motion.new({
          raw_keystrokes: 'w',
          motion: 'w'
        })
      ].first
      assert_equal 'normal', motion.invocation_context
    end

    it 'knows when it\'s being called after an operation' do
      motion = Operation.new({
        raw_keystrokes: 'dw',
        operator: 'd',
        motion: 'w'
      }).motion
      assert_equal 'operator_pending', motion.invocation_context
    end

  end
end
