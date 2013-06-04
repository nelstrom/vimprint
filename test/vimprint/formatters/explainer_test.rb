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
      assert_equal "h - move 1 character to the left\nj - move 1 line down", formatter.print
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
      assert_equal "3j - move 3 lines down", formatter.print
    end

  end
end
