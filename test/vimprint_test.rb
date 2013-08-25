require 'minitest/autorun'
require 'vimprint'

module Vimprint

  describe Vimprint do

    it 'explains consecutive commands: \'x2x"ax"zx\'' do
      assert_equal [
        ['x', 'cut 1 character into default register'],
        ['2x', 'cut 2 characters into default register'],
        ['"ax', 'cut 1 character into register a'],
        ['"zx', 'cut 1 character into register z'],
      ], Vimprint.explain('x2x"ax"zx')
    end

  end

end
