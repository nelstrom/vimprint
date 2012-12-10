require 'minitest/autorun'
require 'vimprint'

describe Vimprint do
  it "parses simple insertion and transforms into output" do
    Vimprint.parse("IHello, World!\e").must_equal ["I{Hello, World!}"]
  end

  it "parses insertion plus Ex command and transforms into output" do
    Vimprint.parse("IHello, World!\e:q\r").must_equal ["I{Hello, World!}", ":q"]
  end
end
