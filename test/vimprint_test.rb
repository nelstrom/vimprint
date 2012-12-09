require 'minitest/autorun'
require 'vimprint'

class Test < MiniTest::Unit::TestCase
  def test_parse
    result = Vimprint.parse("IHello, World!\e")
    assert_equal "I{Hello, World!}", result
  end
end
