require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/formatters/explainer'

module Vimprint
  class ModelVimTest < MiniTest::Unit::TestCase

    def test_explain_simple_motions
      normal = NormalMode[
        Motion.new(raw_keystrokes: 'h', trigger: 'h'),
        Motion.new(raw_keystrokes: '5h', trigger: 'h', count: 5),
        Motion.new(raw_keystrokes: 'j', trigger: 'j'),
        Motion.new(raw_keystrokes: '5j', trigger: 'j', count: 5),
        Motion.new(raw_keystrokes: 'k', trigger: 'k'),
        Motion.new(raw_keystrokes: '5k', trigger: 'k', count: 5),
        Motion.new(raw_keystrokes: 'l', trigger: 'l'),
        Motion.new(raw_keystrokes: '5l', trigger: 'l', count: 5),
        Motion.new(raw_keystrokes: 'b', trigger: 'b'),
        Motion.new(raw_keystrokes: '5b', trigger: 'b', count: 5),
        Motion.new(raw_keystrokes: 'w', trigger: 'w'),
        Motion.new(raw_keystrokes: '5w', trigger: 'w', count: 5),
        Motion.new(raw_keystrokes: 'e', trigger: 'e'),
        Motion.new(raw_keystrokes: '5e', trigger: 'e', count: 5),
        Motion.new(raw_keystrokes: '0', trigger: '0'),
      ]
      explanations = [
        "h - move left 1 character",
        "5h - move left 5 characters",
        "j - move down 1 line",
        "5j - move down 5 lines",
        "k - move up 1 line",
        "5k - move up 5 lines",
        "l - move right 1 character",
        "5l - move right 5 characters",
        "b - move to start of current/previous word",
        "5b - move to start of current/previous word 5 times",
        "w - move to start of next word",
        "5w - move to start of next word 5 times",
        "e - move to end of current/next word",
        "5e - move to end of current/next word 5 times",
        "0 - move to start of current line",
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal explanations.join("\n"), formatter.print
    end

    def test_explain_simple_switches
      normal = NormalMode[
        Switch.new(raw_keystrokes: 'i', trigger: 'i'),
        Switch.new(raw_keystrokes: '5i', trigger: 'i', count: 5),
        Switch.new(raw_keystrokes: 'I', trigger: 'I'),
        Switch.new(raw_keystrokes: '5I', trigger: 'I', count: 5),
        Switch.new(raw_keystrokes: 'a', trigger: 'a'),
        Switch.new(raw_keystrokes: '5a', trigger: 'a', count: 5),
        Switch.new(raw_keystrokes: 'A', trigger: 'A'),
        Switch.new(raw_keystrokes: '5A', trigger: 'A', count: 5),
        Switch.new(raw_keystrokes: 's', trigger: 's'),
        Switch.new(raw_keystrokes: '5s', trigger: 's', count: 5),
        Switch.new(raw_keystrokes: 'S', trigger: 'S'),
        Switch.new(raw_keystrokes: '5S', trigger: 'S', count: 5),
        Switch.new(raw_keystrokes: 'o', trigger: 'o'),
        Switch.new(raw_keystrokes: '5o', trigger: 'o', count: 5),
        Switch.new(raw_keystrokes: 'O', trigger: 'O'),
      ]
      explanations = [
        "i - insert in front of cursor",
        "5i - insert 5 times in front of cursor",
        "I - insert at start of line",
        "5I - insert 5 times at start of line",
        "a - append after the cursor",
        "5a - append 5 times after the cursor",
        "A - append at end of line",
        "5A - append 5 times at end of line",
        "s - delete current character and switch to insert mode",
        "5s - delete 5 characters and switch to insert mode",
        "S - delete current line and switch to insert mode",
        "5S - delete 5 lines and switch to insert mode",
        "o - open a new line below the current line, switch to insert mode",
        "5o - 5 times open a new line below the current line",
        "O - open a new line above the current line, switch to insert mode",
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal explanations.join("\n"), formatter.print
    end

    def test_explain_the_u_command
      normal = NormalMode[
        NormalCommand.new(raw_keystrokes: 'u', trigger: 'u')
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal "u - undo the last change", formatter.print
    end

    def test_explain_the_visual_u_operator
      normal = NormalMode[
        VisualMode[
          VisualOperation.new(raw_keystrokes: 'u', trigger: 'u')
        ]
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal "u - downcase the selected text", formatter.print
    end

    def test_explain_motions_used_in_visual_mode
      visual_motion = visual_mode { create_motion("h") }
      assert_equal "h - select left 1 character", format(visual_motion)
    end

    def test_explain_an_aborted_command
      normal = NormalMode[
        AbortedCommand.new(raw_keystrokes: "2\e")
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal "2\e - [aborted command]", formatter.print
    end

    def test_explain_delete_word_operation
      deletion = normal_mode { create_operation("d w") }
      assert_equal "dw - delete to end of word", format(deletion)
    end

    def test_explain_delete_paragraph_operation
      deletion = normal_mode { create_operation("d }") }
      assert_equal "d} - delete to end of paragraph", format(deletion)
    end

    def test_explain_yank_word
      yank = normal_mode { create_operation("y w") }
      assert_equal "yw - yank to end of word", format(yank)
    end

    def test_explain_yank_paragraph
      yank = normal_mode { create_operation("y }") }
      assert_equal "y} - yank to end of paragraph", format(yank)
    end

    private

    def normal_mode
      NormalMode[ *yield ]
    end

    def visual_mode
      VisualMode[ *yield ]
    end

    def create_motion(keys)
      parts = keys.split(' ')
      count = parts.shift if parts.size > 1
      motion, = parts

      Motion.new(
        raw_keystrokes: motion,
        trigger: motion,
        counts: Array(count).map(&:to_i)
      )
    end

    def create_operation(keys)
      parts = keys.split(' ')
      count = parts.shift if parts.size > 2
      operator, motion = parts

      Operation.new(
        raw_keystrokes: keys.gsub(' ', ''),
        operator: operator,
        counts: Array(count).map(&:to_i),
        motion: Motion.new(raw_keystrokes: motion, trigger: motion)
      )
    end

    def format(commands)
      formatter = ExplainFormatter.new(commands)
      formatter.print
    end

  end
end
