gem 'minitest'
require_relative '../../lib/vimprint/command_tree'
require 'minitest/autorun'
require 'minitest/pride'

module Vimprint
  describe CommandTree do

    describe '#entry_point' do

      it 'references the root node' do
        tree = CommandTree.new
        assert_equal tree.root, tree.entry_point
      end

      it 'can be set in the constructor' do
        normal_mode = []
        tree = CommandTree.new(normal_mode)
        assert_equal tree.entry_point, normal_mode
      end

    end

    describe '#<<' do

      before do
        @tree = CommandTree.new
      end

      it 'appends to the root-level entry point' do
        @tree << 'a'
        @tree << 'b'
        assert_equal ['a','b'], @tree.root
      end

      it 'appends to the top-most entry point' do
        @tree << 'a'
        @tree.push_mode
        @tree << 'b'
        @tree << 'c'
        @tree.pop_mode
        @tree << 'd'
        assert_equal ['a',['b','c'],'d'], @tree.root
      end

      it 'pushes a new mode when receiving a ModeOpener' do
        @tree.<<(['a'].extend Vimprint::ModeOpener)
        @tree.<<(['b'].extend Vimprint::ModeOpener)
        assert_equal [['a',['b']]], @tree.root
      end

      it 'pops the modestack when receiving a ModeCloser' do
        @tree.<<('a')
        @tree.push_mode
        @tree.<<('b')
        @tree.<<('c'.extend Vimprint::ModeCloser)
        @tree.<<('d')
        assert_equal ['a',['b', 'c'], 'd'], @tree.root
      end

      it 'pops the modestack for each ModeCloser received' do
        @tree.<<('a')
        @tree.push_mode
        @tree.<<('b')
        @tree.push_mode
        @tree.<<('c'.extend Vimprint::ModeCloser)
        @tree.<<('d')
        @tree.<<('e'.extend Vimprint::ModeCloser)
        @tree.<<('f')
        assert_equal ['a',['b', ['c'], 'd', 'e'], 'f'], @tree.root
      end

    end


  end
end
