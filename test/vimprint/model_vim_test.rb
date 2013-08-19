gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/model_vim'

module Vimprint

  describe CommandBuilder do

    def test_building_a_normal_command
      command = NormalCommand.build({trigger: 'x'})
      assert_equal 'x', command.trigger
    end

    def test_building_a_motion
      command = Motion.build({
        raw_keystrokes: "2w",
        trigger: 'w'
      })
      assert_equal 'w', command.trigger
    end

    def test_building_an_aborted_command
      command = AbortedCommand.build({
        raw_keystrokes: "3\"a2\"b\e"
      })
      assert_equal "3\"a2\"b\e", command.raw_keystrokes
    end

    def test_building_a_switch_command
      command = Switch.build({
        raw_keystrokes: '3a',
      })
      assert_equal "3a", command.raw_keystrokes
    end

    def test_building_a_visual_operator
      command = VisualOperation.build({
        raw_keystrokes: 'c'
      })
      assert_equal "c", command.raw_keystrokes
    end

  end

end
