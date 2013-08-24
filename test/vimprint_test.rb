require 'minitest/autorun'
require 'vimprint'

module Vimprint

  describe Vimprint do

    it 'explains the "x" command' do
      assert_equal [["x", "cut 1 character into default register"]], Vimprint.explain("x")
    end

    it 'explains the "2x" command' do
      assert_equal [["2x", "cut 2 characters into default register"]], Vimprint.explain("2x")
    end

  end

end
