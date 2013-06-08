require 'minitest/autorun'
require 'minitest/pride'
require './lib/vimprint/core_ext/fixnum'

describe 'Fixnum#ordinalize' do

  it 'uses -st suffix for numbers ending 1' do
    assert_equal   '1st', 1.ordinalize
    assert_equal  '21st', 21.ordinalize
    assert_equal '101st', 101.ordinalize
  end

  it 'uses -nd suffix for numbers ending 2' do
    assert_equal   '2nd', 2.ordinalize
    assert_equal  '22nd', 22.ordinalize
    assert_equal '102nd', 102.ordinalize
  end

  it 'uses -nd suffix for numbers ending 3' do
    assert_equal   '3rd', 3.ordinalize
    assert_equal  '23rd', 23.ordinalize
    assert_equal '103rd', 103.ordinalize
  end

  it 'uses -th suffix for 11 and 12' do
    assert_equal  '11th', 11.ordinalize
    assert_equal  '12th', 12.ordinalize
    assert_equal '511th', 511.ordinalize
    assert_equal '512th', 512.ordinalize
  end

end
