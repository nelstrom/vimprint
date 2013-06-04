require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/model_vim'
require './lib/vimprint/formatters/explainer'

module Vimprint
  class ModelVimTest < MiniTest::Unit::TestCase

    def test_explain_the_h_motion
      normal = NormalMode[
        Motion.new('h'),
        Motion.new('j'),
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal formatter.print, "h - move 1 character to the left\nj - move 1 line down"
    end

    def test_explain_the_u_command
      normal = NormalMode[
        NormalCommand.new('u')
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal formatter.print, "u - undo the last change"
    end

    def test_explain_the_visual_u_operator
      normal = NormalMode[
        VisualMode[
          VisualOperation.new('u')
        ]
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal formatter.print, "u - downcase the selected text"
    end

    def test_explain_a_motion_with_count
      normal = NormalMode[
        Motion.new('j', 3)
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal formatter.print, "3j - move 3 lines down"
    end

  end
end
