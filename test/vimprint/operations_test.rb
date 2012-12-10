require 'minitest/autorun'
require 'vimprint'

describe Vimprint::Operations do

  def generate name, dict
    Vimprint::Operations.const_get(name).new(dict)
  end

  def text
    generate(name, dict).to_s
  end

  def markup
    generate(name, dict).to_html
  end

  describe "Insertion" do
    let(:name) { :Insertion }
    let(:dict) {
      { :switch => 'I',
        :text => 'Hello, World!',
      }
    }

    it "has string representation" do
      text.must_equal "I{Hello, World!}"
    end

    it "gets marked up" do
      skip
      markup.must_equal ""
    end
  end

  describe "ExCommand" do
    let(:name) { :ExCommand }
    let(:dict) {
      { :prompt => ':',
        :text => 'cq',
      }
    }

    it "has string representation" do
      text.must_equal ":cq"
    end

    it "gets marked up" do
      skip
      markup.must_equal ""
    end
  end

end
