require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/registry'

module Vimprint

  describe Explanation do

    it "can be a plain string" do
      explain = Explanation.new('undo the last change')
      assert_equal 'undo the last change', explain.render(binding)
    end

    it "can interpolate a local value into a string" do
      count = 5
      explain = Explanation.new(%q{undo the last #{count} changes})
      assert_equal 'undo the last 5 changes', explain.render(binding)
    end

    it "can interpolate many local values into a string" do
      verb = 'move'
      count = 5
      explain = Explanation.new(%q{#{verb} to the start of the #{count.ordinalize} word})
      assert_equal 'move to the start of the 5th word', explain.render(binding)
    end

  end

  describe Registry do

    describe "create_mode()" do

      it "doesn't create duplicates" do
        @normal_mode1 = Registry.create_mode("normal")
        @normal_mode2 = Registry.create_mode("normal")
        assert_same @normal_mode1, @normal_mode2
      end

    end

    describe "get_mode()" do

      before do
        @normal_mode = Registry.create_mode("normal")
        @insert_mode = Registry.create_mode("insert")
      end

      it 'returns the normal_mode registry' do
        mode = Registry.get_mode('normal')
        assert_equal @normal_mode, mode
      end

      it 'returns the insert_mode registry' do
        mode = Registry.get_mode('insert')
        assert_equal @insert_mode, mode
      end

      it 'explodes informatively when asked for a non-existant mode' do
        assert_raises(NoModeError) {Registry.get_mode('sparkles')}
      end

    end

    describe "#get_command" do

      before do
        @normal_mode = Registry.create_mode("normal")
        @normal_mode.create_command('w')
      end

      it 'explains the specified command' do
        explained_motion = @normal_mode.get_command('w')
        assert_equal "move to the start of the next word", explained_motion
      end

      it 'explodes informatively when asked for a non-existent command' do
        assert_raises(NoCommandError) {@normal_mode.get_command('sparkles')}
      end

    end

  end
end
