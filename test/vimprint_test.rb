require 'minitest/autorun'
require 'vimprint'

describe Vimprint do
  it "parses input and transforms into output" do
    Vimprint.parse("IHello, World!\e").must_equal "I{Hello, World!}"
  end
end
