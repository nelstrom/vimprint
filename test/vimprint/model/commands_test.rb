require 'minitest/autorun'
require 'vimprint/model/commands'

module Vimprint

  describe BaseCommand do
    it 'can set/get :container' do
      command = BaseCommand.new
      assert_equal nil, command.container
      command.container = (list = [])
      assert_equal list, command.container
    end
  end

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

  describe MotionCommand do

    it 'assumes it\'s being called from Normal mode' do
      motion = NormalMode[
        MotionCommand.new({
          raw_keystrokes: 'w',
          motion: 'w'
        })
      ].first
      assert_equal 'normal', motion.invocation_context
      assert_equal 'move forward', motion.verb
    end

    it 'knows when it\'s being called from Visual mode' do
      motion = VisualMode[
        MotionCommand.new({
          raw_keystrokes: 'w',
          motion: 'w',
          invocation_context: 'visual'
        })
      ].first
      assert_equal 'visual', motion.invocation_context
      assert_equal 'select', motion.verb
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
      assert_equal BareMotion.new({motion: 'w', count: '2'}), extent
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
      assert_equal BareMotion.new({motion: 'w', count: '2'}), operation.extent
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

  describe VisualOperation do
    it '#selection is aware of the nature of the containing instance of VisualMode' do
      operation = VisualOperation.new
      commandlist = VisualMode.new
      commandlist << operation
      assert_equal 'selected characters', operation.selection
      commandlist.nature = 'linewise'
      assert_equal 'selected lines', operation.selection
    end
  end
end
