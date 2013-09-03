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
        "r\e",
        "m\e",
        "3m\e",
        "`\e",
      ].join

      assert_equal [
        ['3<Esc>', explanation],
        ['"a<Esc>', explanation],
        ['2"x3<Esc>', explanation],
        ['r<Esc>', explanation],
        ['m<Esc>', explanation],
        ['3m<Esc>', explanation],
        ['`<Esc>', explanation],
      ], Vimprint.explain(bad_input)
    end

    it 'explains combinations of counts and registers' do
      weird_input = [
        '"a"b"cx',
        '2"a3"b4"cx',
        '"a3"b4"cx',
        '"a3"b4"cma',
        '"a3"b4"cu',
        '"a3"b4"crx',
      ].join

      assert_equal [
        ['"a"b"cx', 'cut character under cursor into register c'],
        ['2"a3"b4"cx', 'cut 24 characters into register c'],
        ['"a3"b4"cx', 'cut 12 characters into register c'],
        ['"a3"b4"cma', 'save current position with local mark a'],
        ['"a3"b4"cu', 'undo 12 changes'],
        ['"a3"b4"crx', 'replace next 12 characters with x'],
      ], Vimprint.explain(weird_input)
    end

    it 'explains motions used in Normal mode' do
      assert_equal [
        ['w', 'move forward to start of next word'],
        ['3w', 'move forward to start of 3rd word'],
        ['e', 'move forward to end of word'],
        ['2e', 'move forward to end of 2nd word'],
      ], Vimprint.explain('w3we2e')
    end

    it 'explains motions used after an operator' do
      assert_equal [
        ['dw', 'delete to start of next word'],
        ['2dw', 'delete to start of 2nd word'],
        ['d3w', 'delete to start of 3rd word'],
      ], Vimprint.explain('dw2dwd3w')
    end

    it 'explains linewise operations' do
      assert_equal [
        ['dd', 'delete a line'],
        ['2dd', 'delete 2 lines'],
        ['d3d', 'delete 3 lines'],
        ['3d2d', 'delete 6 lines'],
      ], Vimprint.explain('dd2ddd3d3d2d')
    end

      # consider the following:
      #   de - cut from cursor forward to end of word
      #   dw - cut from cursor forward to start of next word
      #   ce - cut from cursor forward to end of word
      #   cw - cut from cursor forward to end of word
      #
      #   de - cut from cursor forward to end of word, save text to default register
      #   dw - cut from cursor forward to start of next word, save text to default register
      #   ce - cut from cursor forward to end of word, save text to default register, start Insert mode
      #   cw - cut from cursor forward to end of word, save text to default register, start Insert mode
      #
      # cw breaks from convention!
      #
      # Also, think about how to explain all of the command!
      #   de - from cursor to end of word, cut text into default register
      #   dw - from cursor to start of next word, cut text into default register
      #   ce - from cursor to end of word, cut text into default register and start Insert mode
      #   cw - from cursor to end of word, cut text into default register and start Insert mode
      #
      # Also, think about different descriptions for charwise/linewise motions
      #  2dw - cut from cursor forward to start of 2nd word
      #   dd - cut 1 line
      #  2dd - cut 2 lines
      #   dj - cut this line and 1 below
      #  2dj - cut this line and 2 below
      #   dj - cut 2 lines
      #  2dj - cut 3 lines
      #  dvj - cut from cursor same position on line below

  end

end
