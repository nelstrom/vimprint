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
      }).extent
      assert_equal 'operator_pending', motion.invocation_context
    end

  end

  describe Operator do
    it 'has a trigger value' do
      operator = Operator.new({trigger: 'd'})
      assert_equal 'd', operator.trigger
    end
  end

  describe Extent do
    it 'creates a motion from config' do
      extent = Extent.build({motion: 'w', count: '2'})
      assert_equal Motion.new({motion: 'w', count: '2'}), extent
    end
    it 'creates an echo from config' do
      extent = Extent.build({echo: 'd'})
      assert_equal Echo.new({trigger: 'd'}), extent
    end
    it 'creates a text object from config' do
      skip "FILL THIS OUT WHEN IMPLEMENTING TEXT OBJECTS"
    end
  end

  describe Operation do

    it 'can be constructed from operator + motion' do
      operation = Operation.new({
        raw_keystrokes: 'd2w',
        operator: 'd',
        motion: 'w',
        count: '2'
      })
      assert_equal Operator.new({trigger:'d'}), operation.operator
      assert_equal Motion.new({motion: 'w', count: '2'}), operation.extent
    end

    it 'can be constructed from operator + operator' do
      operation = Operation.new({
        raw_keystrokes: 'dd',
        operator: 'd',
        echo: 'd',
      })
      assert_equal Operator.new({trigger: 'd'}), operation.operator
      assert_equal Echo.new({trigger: 'd'}), operation.extent
    end

  end
end
