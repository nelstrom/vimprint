require 'minitest/autorun'
require 'vimprint'

describe Vimprint::Operations do

  describe "Insertion" do

    before do
      @insertion = Vimprint::Operations::Insertion.new({
        :switch => 'I',
        :text => 'Hello, World!'
      })
    end

    it "has string representation" do
      @insertion.to_s.must_equal "I{Hello, World!}"
    end

    it "gets marked up" do
      skip
      @insertion.to_html.must_equal ""
    end
  end

  describe "ExCommand" do

    before do
      @ex_cmd = Vimprint::Operations::ExCommand.new({
        :prompt => ':',
        :text => 'cq',
      })
    end

    it "has string representation" do
      @ex_cmd.to_s.must_equal ":cq"
    end

    it "gets marked up" do
      skip
      @ex_cmd.to_html.must_equal ""
    end
  end

  describe "Bare Motion" do

    before do
      @motion = Vimprint::Operations::Motion.new({
        :motion => "gj"
      })
    end

    it "has string representation" do
      @motion.to_s.must_equal "gj"
    end

    it "gets marked up" do
      skip
      @motion.to_html.must_equal ""
    end

  end

  describe "Motion with count" do

    before do
      @motion = Vimprint::Operations::Motion.new({
        :motion => "gj",
        :count  => 42
      })
    end

    it "has string representation" do
      @motion.to_s.must_equal "42gj"
    end

    it "gets marked up" do
      skip
      @motion.to_html.must_equal ""
    end

  end

  describe "Operation with simple motion" do

    before do
      @operation = Vimprint::Operations::Operation.new({
        :operator => "d",
        :motion   => "w"
      })
    end

    it "represents the motion as a Motion object" do
      @operation.motion.must_be_instance_of Vimprint::Operations::Motion
    end

    it "has string representation" do
      @operation.to_s.must_equal "dw"
    end

    it "gets marked up" do
      skip
      @operation.to_html.must_equal ""
    end

  end

end
