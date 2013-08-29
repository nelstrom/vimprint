require 'minitest/autorun'
require 'vimprint'

module Vimprint

  describe Vimprint do

    def ctrl_R
      "\x12" # Ruby string notation for ctrl_R
    end

    it 'prints consecutive commands with spaces to pad' do
      assert_equal 'x 2x "ax "zx 2"ax "a2x 3"a2x ', Vimprint.pp('x2x"ax"zx2"ax"a2x3"a2x')
    end

    it 'explains consecutive commands: \'x2x"ax"zx2"ax"a2x\'' do
      assert_equal [
        ['x', 'cut character under cursor into default register'],
        ['2x', 'cut 2 characters into default register'],
        ['"ax', 'cut character under cursor into register a'],
        ['"zx', 'cut character under cursor into register z'],
        ['2"ax', 'cut 2 characters into register a'],
        ['"a2x', 'cut 2 characters into register a'],
        ['3"a2x', 'cut 6 characters into register a']
      ], Vimprint.explain("x2x\"ax\"zx2\"ax\"a2x3\"a2x")
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

    it 'explains distroke commands' do
      assert_equal [
        ['ma', 'save current position with local mark a'],
        ['mZ', 'save current position with global mark Z'],
        ['`a', 'jump to local mark a'],
        ['2`Z', 'jump to global mark Z'],
      ], Vimprint.explain('mamZ`a2`Z')
    end

    it 'explains undo and redo commands' do
      assert_equal [
        ['u', 'undo 1 change'],
        ['2u', 'undo 2 changes'],
        ["3<C-r>", 'redo 3 changes'],
      ], Vimprint.explain("u2u3#{ctrl_R}")
    end

    it 'explains the r command' do
      assert_equal [
        ['ra', 'replace current character with a'],
        ['rZ', 'replace current character with Z'],
        ['r<Space>', 'replace current character with <Space>'],
        ['r<Tab>', 'replace current character with <Tab>'],
        ['r<Enter>', 'replace current character with <Enter>'],
        ['3rx', 'replace next 3 characters with x'],
      ], Vimprint.explain("rarZr r\tr\r3rx")
    end

    it 'explains aborted commands' do
      explanation = '[aborted command]'
      bad_input = [
        "3\e",
        "\"a\e",
        "2\"x3\e",
      ].join

      assert_equal [
        ['3<Esc>', explanation],
        ['"a<Esc>', explanation],
        ['2"x3<Esc>', explanation],
      ], Vimprint.explain(bad_input)
    end

  end

end
