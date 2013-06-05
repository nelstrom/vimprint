require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/formatters/explainer'

module Vimprint
  class ModelVimTest < MiniTest::Unit::TestCase

    def test_explain_simple_motions
      normal = NormalMode[
        Motion.new('h'),
        Motion.new('h', 5),
        Motion.new('j'),
        Motion.new('j', 5),
        Motion.new('k'),
        Motion.new('k', 5),
        Motion.new('l'),
        Motion.new('l', 5),
        Motion.new('b'),
        Motion.new('b', 5),
        Motion.new('w'),
        Motion.new('w', 5),
        Motion.new('e'),
        Motion.new('e', 5),
        Motion.new('0'),
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
        Switch.new('i'),
        Switch.new('I'),
        Switch.new('a'),
        Switch.new('A'),
        Switch.new('s'),
        Switch.new('S'),
        Switch.new('o'),
        Switch.new('O'),
      ]
      explanations = [
        "i - insert in front of cursor",
        "I - insert at start of line",
        "a - append after the cursor",
        "A - append at end of line",
        "s - delete current character and switch to insert mode",
        "S - delete current line and switch to insert mode",
        "o - open a new line below the current line, switch to insert mode",
        "O - open a new line above the current line, switch to insert mode",
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal explanations.join("\n"), formatter.print
    end

    def test_explain_the_u_command
      normal = NormalMode[
        NormalCommand.new('u')
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal "u - undo the last change", formatter.print
    end

    def test_explain_the_visual_u_operator
      normal = NormalMode[
        VisualMode[
          VisualOperation.new('u')
        ]
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal "u - downcase the selected text", formatter.print
    end

  end
end
