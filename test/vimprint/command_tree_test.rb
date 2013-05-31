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

  end
end
