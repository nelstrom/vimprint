gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/formatters/explainer'

module Vimprint
  describe 'ModelVim' do

    it 'explains h motion' do
      motion = normal_mode { create_motion("h") }
      assert_equal "h - move left 1 character", format(motion)
    end

    it 'explains h motion with count' do
      motion = normal_mode { create_motion("5 h") }
      assert_equal "5h - move left 5 characters", format(motion)
    end

    it "explains j motion" do
      motion = normal_mode { create_motion('j') }
      assert_equal "j - move down 1 line", format(motion)
    end

    it "explains j motion with count" do
      motion = normal_mode { create_motion('5 j') }
      assert_equal "5j - move down 5 lines", format(motion)
    end

    it "explains k motion" do
      motion = normal_mode { create_motion('k') }
      assert_equal "k - move up 1 line", format(motion)
    end

    it "explains k motion with count" do
      motion = normal_mode { create_motion('5 k') }
      assert_equal "5k - move up 5 lines", format(motion)
    end

    it "explains l motion" do
      motion = normal_mode { create_motion('l') }
      assert_equal "l - move right 1 character", format(motion)
    end

    it "explains l motion with count" do
      motion = normal_mode { create_motion('5 l') }
      assert_equal "5l - move right 5 characters", format(motion)
    end

    it "explains w motion" do
      motion = normal_mode { create_motion('w') }
      assert_equal "w - move to start of next word", format(motion)
    end

    it "explains w motion with count" do
      motion = normal_mode { create_motion('5 w') }
      assert_equal "5w - move to start of next word 5 times", format(motion)
    end

    it "explains b motion" do
      motion = normal_mode { create_motion('b') }
      assert_equal "b - move to start of current/previous word", format(motion)
    end

    it "explains b motion with count" do
      motion = normal_mode { create_motion('5 b') }
      assert_equal "5b - move to start of current/previous word 5 times", format(motion)
    end

    it "explains e motion" do
      motion = normal_mode { create_motion('e') }
      assert_equal "e - move to end of current/next word", format(motion)
    end

    it "explains e motion with count" do
      motion = normal_mode { create_motion('5 e') }
      assert_equal "5e - move to end of current/next word 5 times", format(motion)
    end

    it "explains 0 motion" do
      motion = normal_mode { create_motion('0') }
      assert_equal "0 - move to start of current line", format(motion)
    end

    it 'explains i switch' do
      switch = normal_mode { create_switch("i") }
      assert_equal "i - insert in front of cursor", format(switch)
    end

    it 'explains i switch with count' do
      switch = normal_mode { create_switch("5 i") }
      assert_equal "5i - insert 5 times in front of cursor", format(switch)
    end

    it "explains I switch" do
      switch = normal_mode { create_switch('I') }
      assert_equal "I - insert at start of line", format(switch)
    end

    it "explains I switch with count" do
      switch = normal_mode { create_switch('5 I') }
      assert_equal "5I - insert 5 times at start of line", format(switch)
    end

    it "explains a switch" do
      switch = normal_mode { create_switch('a') }
      assert_equal "a - append after the cursor", format(switch)
    end

    it "explains a switch with count" do
      switch = normal_mode { create_switch('5 a') }
      assert_equal "5a - append 5 times after the cursor", format(switch)
    end

    it "explains A switch" do
      switch = normal_mode { create_switch('A') }
      assert_equal "A - append at end of line", format(switch)
    end

    it "explains A switch with count" do
      switch = normal_mode { create_switch('5 A') }
      assert_equal "5A - append 5 times at end of line", format(switch)
    end

    it "explains s switch" do
      switch = normal_mode { create_switch('s') }
      assert_equal "s - delete current character and switch to insert mode", format(switch)
    end

    it "explains s switch with count" do
      switch = normal_mode { create_switch('5 s') }
      assert_equal "5s - delete 5 characters and switch to insert mode", format(switch)
    end

    it "explains S switch" do
      switch = normal_mode { create_switch('S') }
      assert_equal "S - delete current line and switch to insert mode", format(switch)
    end

    it "explains S switch with count" do
      switch = normal_mode { create_switch('5 S') }
      assert_equal "5S - delete 5 lines and switch to insert mode", format(switch)
    end

    it "explains o switch" do
      switch = normal_mode { create_switch('o') }
      assert_equal "o - open a new line below the current line, switch to insert mode", format(switch)
    end

    it "explains o switch with count" do
      switch = normal_mode { create_switch('5 o') }
      assert_equal "5o - 5 times open a new line below the current line", format(switch)
    end

    it "explains O switch" do
      switch = normal_mode { create_switch('O') }
      assert_equal "O - open a new line above the current line, switch to insert mode", format(switch)
    end

    it 'explains the u command' do
      command = normal_mode { create_normal_command('u') }
      assert_equal "u - undo the last change", format(command)
    end

    it 'explains the visual u operator' do
      visual_operation = visual_mode { create_visual_operation('u') }
      assert_equal "u - downcase the selected text", format(visual_operation)
    end

    it 'explains motions used in visual mode' do
      visual_motion = visual_mode { create_motion("h") }
      assert_equal "h - select left 1 character", format(visual_motion)
    end

    it 'explains an aborted command' do
      normal = NormalMode[
        AbortedCommand.new(raw_keystrokes: "2\e")
      ]
      formatter = ExplainFormatter.new(normal)
      assert_equal "2\e - [aborted command]", formatter.print
    end

    it 'explains delete word operation' do
      deletion = normal_mode { create_operation("d w") }
      assert_equal "dw - delete to end of word", format(deletion)
    end

    it 'explains delete paragraph operation' do
      deletion = normal_mode { create_operation("d }") }
      assert_equal "d} - delete to end of paragraph", format(deletion)
    end

    it 'explains yank word operation' do
      yank = normal_mode { create_operation("y w") }
      assert_equal "yw - yank to end of word", format(yank)
    end

    it 'explains yank paragraph operation' do
      yank = normal_mode { create_operation("y }") }
      assert_equal "y} - yank to end of paragraph", format(yank)
    end

    def normal_mode
      NormalMode[ *yield ]
    end

    def visual_mode
      VisualMode[ *yield ]
    end

    def create_normal_command(keys)
      NormalCommand.new(raw_keystrokes: keys, trigger: keys)
    end

    def create_visual_operation(keys)
      VisualOperation.new(raw_keystrokes: keys, trigger: keys)
    end

    def create_switch(keys)
      parts = keys.split(' ')
      count = parts.shift if parts.size > 1
      switch, = parts

      Switch.new(
        raw_keystrokes: keys.gsub(' ', ''),
        trigger: switch,
        counts: Array(count).map(&:to_i)
      )
    end

    def create_motion(keys)
      parts = keys.split(' ')
      count = parts.shift if parts.size > 1
      motion, = parts

      Motion.new(
        raw_keystrokes: keys.gsub(' ', ''),
        trigger: motion,
        counts: Array(count).map(&:to_i)
      )
    end

    def create_operation(keys)
      parts = keys.split(' ')
      count = parts.shift if parts.size > 2
      operator, motion = parts

      Operation.new(
        raw_keystrokes: keys.gsub(' ', ''),
        operator: operator,
        counts: Array(count).map(&:to_i),
        motion: Motion.new(raw_keystrokes: motion, trigger: motion)
      )
    end

    def format(commands)
      formatter = ExplainFormatter.new(commands)
      formatter.print
    end

  end
end
