require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/model_vim'

module Vimprint

  describe Stage do

    def test_stage_to_hash
      stage = Stage.new
      stage.add_register 'a'
      stage.add_count     4
      stage.add_trigger  'x'
      hashmap = {
        raw_keystrokes: '"a4x',
        effective_count: 4,
        counts: [4],
        trigger: 'x'
      }
      assert_equal hashmap, stage.to_hash
    end

    def test_stage_accumulates_raw_keystrokes
      stage = Stage.new
      stage.add_register 'a'
      stage.add_count     4
      stage.add_trigger  'x'
      assert_equal '"a4x', stage.raw_keystrokes
    end

    def test_counts_are_multiplied
      # Example:
      #   given buffer contents: 123456789012345678901234567890
      #   execute this command:  2"a3d4l
      # result:
      #   all 3 counts are multiplied, (2*3*4=) 24
      #   register a is set to: 123456789012345678901234
      stage = Stage.new
      stage.add_count 2
      stage.add_register 'a'
      stage.add_count 3
      stage.add_operator 'd'
      stage.add_count 4
      stage.add_motion 'l'
      assert_equal "a", stage.register
      assert_equal 24, stage.effective_count
      assert_equal '2"a3d4l', stage.raw_keystrokes
    end

    def test_register_is_overwritten
      # Example:
      #   given buffer contents: 123456789
      #   execute this command:  3"a2"bx
      # result:
      #   both counts are multiplied, (3*2=) 6
      #   register b is set to: 123456
      #   register a is unchanged
      stage = Stage.new
      stage.add_count     3
      stage.add_register 'a'
      stage.add_count     2
      stage.add_register 'b'
      stage.add_trigger  'x'
      assert_equal "b", stage.register
      assert_equal 6, stage.effective_count
      assert_equal '3"a2"bx', stage.raw_keystrokes
    end

  end

  describe CommandBuilder do

    def test_command_builder_uses_stage_attributes
      stage = Stage.new
      stage.add_trigger 'x'
      command = NormalCommand.build(stage)
      assert_equal 'x', command.trigger
    end

    def test_building_a_motion
      stage = Stage.new
      stage.add_count 2
      stage.add_trigger 'w'
      command = Motion.build(stage)
      assert_equal 'w', command.trigger
    end

  end

end
