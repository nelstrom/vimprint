require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/model_vim'
require './lib/vimprint/formatters/plain_printer'

module Vimprint
  class ModelVimTest < MiniTest::Unit::TestCase

    def test_normal_mode_prints_each_member
      normal = NormalMode[
        Motion.new('h'),
        Motion.new('j'),
        Motion.new('k'),
        Motion.new('l'),
      ]
      formatter = Formatter.new(normal)
      assert_equal "h j k l ", formatter.print
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
      assert_equal "hello", formatter.print
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
      assert_equal "h \ni{hello}\nl ", formatter.print
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
      assert_equal "h \ni{hello}\nl ", formatter.print
    end

  end
end
