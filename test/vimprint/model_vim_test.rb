require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/model_vim'

class ModelVimTest < MiniTest::Unit::TestCase

  def test_normal_mode_prints_each_member
    normal = NormalMode[
      Motion.new('h'),
      Motion.new('j'),
      Motion.new('k'),
      Motion.new('l'),
    ]
    formatter = Formatter.new(normal)
    assert_equal formatter.print, "h j k l "
  end

  def test_insert_mode_prints_each_member
    insertion = InsertMode[
      Input.new('h'),
      Input.new('e'),
      Input.new('l'),
      Input.new('l'),
      Input.new('o'),
    ]
    formatter = Formatter.new(insertion)
    assert_equal formatter.print, "hello"
  end

  def test_switching_from_normal_to_insert_mode_and_back_again
    normal = NormalMode[
      Motion.new('h'),
      Switch.new('i'),
      InsertMode[
        Input.new('h'),
        Input.new('e'),
        Input.new('l'),
        Input.new('l'),
        Input.new('o'),
        Terminator.new("\e")
      ],
      Motion.new('l')
    ]
    formatter = Formatter.new(normal)
    assert_equal formatter.print, "h \ni{hello}\nl "
  end

  def test_switching_from_normal_mode_to_insert_mode_to_normal_mode
    # Home > Category > Subcat > Article
    # Normal > Insert
    normal = NormalMode[
      Motion.new('h'),
      Switch.new('i'),
      InsertMode[
        Input.new('h'),
        Input.new('e'),
        Input.new('l'),
        Input.new('l'),
        Input.new('o'),
        Terminator.new("\e")
      ],
      Motion.new('l')
    ]
    formatter = Formatter.new(normal)
    assert_equal formatter.print, "h \ni{hello}\nl "
  end

  def test_explain_the_h_motion
    normal = NormalMode[
      Motion.new('h'),
      Motion.new('j'),
    ]
    formatter = ExplainFormatter.new(normal)
    assert_equal formatter.print, "h - move 1 character to the left\nj - move 1 line down"
  end

end
