require 'minitest/autorun'
require 'vimprint'

module Vimprint

  describe Vimprint do

    it 'explains consecutive commands: \'x2x"ax"zx2"ax"a2x\'' do
      assert_equal [
        ['x', 'cut character under cursor into default register'],
        ['2x', 'cut 2 characters into default register'],
        ['"ax', 'cut character under cursor into register a'],
        ['"zx', 'cut character under cursor into register z'],
        ['2"ax', 'cut 2 characters into register a'],
        ['"a2x', 'cut 2 characters into register a'],
        ['3"a2x', 'cut 6 characters into register a']
      ], Vimprint.explain('x2x"ax"zx2"ax"a2x3"a2x')
    end

    it 'explains both x and X commands' do
      assert_equal [
        ['x', 'cut character under cursor into default register'],
        ['X', 'cut 1 character before cursor into default register'],
        ['2X', 'cut 2 characters before cursor into default register'],
        ['"aX', 'cut 1 character before cursor into register a'],
        ['"z3X', 'cut 3 characters before cursor into register z'],
      ], Vimprint.explain('xX2X"aX"z3X')
    end

  end

end
