require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/formatters/explainer'

module Vimprint
  class ModelVimTest < MiniTest::Unit::TestCase

    def test_explain_simple_motions
      normal = NormalMode[
        Motion.new('h'),
        Motion.new('j'),
        Motion.new('k'),
        Motion.new('l'),
        Motion.new('b'),
        Motion.new('w'),
        Motion.new('e'),
        Motion.new('0'),
      ]
      formatter = ExplainFormatter.new(normal)
      explanations = [
        "h - move left 1 character",
        "j - move down 1 line",
        "k - move up 1 line",
        "l - move right 1 character",
        "b - move to start of current/previous word",
        "w - move to start of next word",
        "e - move to end of current/next word",
        "0 - move to start of current line",
      ]
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

    def test_explain_a_motion_with_count
      normal = NormalMode[
        Motion.new('j', 3)
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal "3j - move down 3 lines", formatter.print
    end

  end
end
