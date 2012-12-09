require 'minitest/autorun'
require 'vimprint'

describe Vimprint::Parser do

  before do
    @parser = Vimprint::Parser.new
  end

  it "matches text insertion" do
    tree = @parser.parse("IHello, World!\e").first
    tree.keys.must_equal [:switch, :typing, :escape]
    tree[:switch].must_equal "I"
    tree[:typing].must_equal "Hello, World!"
  end

  it "matches insertion of nothing" do
    tree = @parser.parse("i\e").first
    tree.keys.must_equal [:switch, :typing, :escape]
    tree[:switch].must_equal "i"
    tree[:typing].must_equal []
  end

  it "matches an Ex command" do
    tree = @parser.parse(":write\r").first
    tree.keys.must_equal [:prompt, :ex_typing, :enter]
    tree[:prompt].must_equal ":"
    tree[:ex_typing].must_equal "write"
  end

end
