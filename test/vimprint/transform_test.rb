require "minitest/autorun"
require "vimprint"

describe Vimprint::Transform do

  def transform tree
    transformer = Vimprint::Transform.new
    transformer.apply tree
  end

  def assert_operation expected_name, obj
    got_name = obj.class.name.split("::").last.intern
    assert_equal expected_name, got_name
  end

  # MiniTest::Expectations.module_eval do
  #   infect_an_assertion :assert_operation, :must_be_operation
  # end

  it "is a no-op for empty tree" do
    transform([]).must_equal []
  end

  it "generates an ex command" do
    cmd = {
      :prompt => ':',
      :typing => 'cq',
      :enter  => "\r",
    }
    assert_operation :ExCommand, transform(cmd)
  end

  it "generates an insertion" do
    cmd = {
      :switch => 'i',
      :typing => 'Hello, World!',
      :escape => "\e",
    }
    assert_operation :Insertion, transform(cmd)
  end

  it "generates a motion" do
    cmd = { :motion => 'j' }
    assert_operation :Motion, transform(cmd)
  end

end
