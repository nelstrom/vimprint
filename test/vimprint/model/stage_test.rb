gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/model/stage'

module Vimprint

  describe Stage do

    def test_reset_clears_state
      stage = Stage.new
      stage.add :register, '"a'
      stage.add :count,     4
      stage.add :trigger,  'x'
      stage.reset
      assert_equal({}, stage.to_hash)
    end

    def test_stage_to_hash
      stage = Stage.new
      stage.add :register, '"a'
      stage.add :count,     4
      stage.add :trigger,  'x'
      hashmap = {
        raw_keystrokes: '"a4x',
        count: 4,
        register: 'a',
        trigger: 'x',
      }
      assert_equal hashmap, stage.to_hash
    end

    def test_commit_returns_hash_and_clears_state
      stage = Stage.new
      stage.add :register, '"a'
      stage.add :count,     4
      stage.add :trigger,  'x'
      hashmap = {
        raw_keystrokes: '"a4x',
        count: 4,
        register: 'a',
        trigger: 'x',
      }
      assert_equal hashmap, stage.commit
      assert_equal({}, stage.to_hash)
    end

    def test_stage_accumulates_raw_keystrokes
      stage = Stage.new
      stage.add :register, '"a'
      stage.add :count,     4
      stage.add :trigger,  'x'
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
      stage.add :count, 2
      stage.add :register, '"a'
      stage.add :count, 3
      stage.add :operator, 'd'
      stage.add :count, 4
      stage.add :motion, 'l'
      assert_equal "a", stage.register
      assert_equal [2,3,4], stage.counts
      assert_equal '2"a3d4l', stage.raw_keystrokes
      assert_equal 24, stage.count
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
      stage.add :count,     3
      stage.add :register, '"a'
      stage.add :count,     2
      stage.add :register, '"b'
      stage.add :trigger,  'x'
      assert_equal "b", stage.register
      assert_equal [3,2], stage.counts
      assert_equal '3"a2"bx', stage.raw_keystrokes
    end

    def test_staging_r_space
      stage = Stage.new
      stage.add :trigger, 'r'
      stage.add :printable_char, '<Space>'
      assert_equal({trigger: 'r', printable_char: '<Space>', raw_keystrokes: 'r<Space>'}, stage.to_hash)
    end

    def test_staging_operator_echo
      stage = Stage.new
      stage.add :operator, 'd'
      stage.add :operator, 'd'
      assert_equal({raw_keystrokes: 'dd', operator: 'd', echo: 'd'}, stage.to_hash)
    end

  end

end
