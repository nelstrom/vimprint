require 'minitest/autorun'
require 'vimprint'

describe Vimprint::Parser do

  before do
    @parser = Vimprint::Parser.new
  end

  it "matches an insertion" do
    tree = @parser.parse("IHello, World!\e")
    tree.keys.must_equal [:switch, :typing, :escape]
    tree[:switch].must_equal "I"
    tree[:typing].must_equal "Hello, World!"
  end

end
