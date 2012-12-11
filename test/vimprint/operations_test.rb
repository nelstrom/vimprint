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

end
