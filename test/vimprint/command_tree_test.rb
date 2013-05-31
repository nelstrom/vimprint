require_relative '../../lib/vimprint/command_tree'
require 'minitest/autorun'

module Vimprint
  describe CommandTree do

    describe '#entry_point' do

      it 'references the root node' do
        tree = CommandTree.new
        tree.entry_point.must_equal tree.root
      end

      it 'can be set in the constructor' do
        normal_mode = []
        tree = CommandTree.new(normal_mode)
        tree.entry_point.must_equal normal_mode
      end

    end

    describe '#<<' do

      before do
        @tree = CommandTree.new
      end

      it 'appends to the root-level entry point' do
        @tree << 'a'
        @tree << 'b'
        @tree.root.must_equal ['a','b']
      end

      it 'appends to the top-most entry point' do
        @tree << 'a'
        @tree.push_mode
        @tree << 'b'
        @tree << 'c'
        @tree.pop_mode
        @tree << 'd'
        @tree.root.must_equal ['a',['b','c'],'d']
      end

      it 'pushes a new mode when receiving a ModeOpener' do
        @tree.<<(['a'].extend Vimprint::ModeOpener)
        @tree.<<(['b'].extend Vimprint::ModeOpener)
        @tree.root.must_equal [['a',['b']]]
      end

      it 'pops the modestack when receiving a ModeCloser' do
        @tree.<<('a')
        @tree.push_mode
        @tree.<<('b')
        @tree.<<('c'.extend Vimprint::ModeCloser)
        @tree.<<('d')
        @tree.root.must_equal ['a',['b', 'c'], 'd']
      end

      it 'pops the modestack for each ModeCloser received' do
        @tree.<<('a')
        @tree.push_mode
        @tree.<<('b')
        @tree.push_mode
        @tree.<<('c'.extend Vimprint::ModeCloser)
        @tree.<<('d')
        @tree.<<('e')
        @tree.root.must_equal ['a',['b', ['c'], 'd'], 'e']
      end

      it 'appends ModalCommands to the current entry_point'
    end


  end
end
