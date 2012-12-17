require "minitest/autorun"
require "vimprint"

describe Vimprint::HtmlPresenter do

  def dom(fragment=presenter.to_html)
    Nokogiri::HTML.fragment(fragment)
  end

  def presenter
    @p ||= Vimprint::HtmlPresenter.new
  end

  describe "#visit_insertion" do

    it "displays the insertion" do
      insertion = Vimprint::Operations::Insertion.new({:switch => 'I', :text => 'Hello, World!'})
      insertion.accept(presenter)
      dom.at_css('div span.switch').text.must_equal 'I'
      dom.at_css('div span.text').text.must_equal 'Hello, World!'
      dom.at_css('div span.escape').text.must_equal '&lt;Esc&gt;'
    end

  end

  describe "#visit_motion" do

    it "displays the motion" do
      motion = Vimprint::Operations::Motion.new({:motion => 'j'})
      motion.accept(presenter)
      dom.at_css('div span.motion').text.must_equal 'j'
    end

    it "displays the motion with a count" do
      motion = Vimprint::Operations::Motion.new({:motion => 'j', :count => 42})
      motion.accept(presenter)
      dom.at_css('div span.motion').text.must_equal 'j'
      dom.at_css('div span.count').text.must_equal '42'
    end

  end

  describe "#visit_operation" do

    it "displays the operator" do
      operation = Vimprint::Operations::Operation.new({:operator => "d", :motion => "w"})
      operation.accept(presenter)
      dom.at_css('div span.operator').text.must_equal 'd'
    end

    it "displays the operator with the motion" do
      operation = Vimprint::Operations::Operation.new({:operator => "d", :motion => "w"})
      operation.accept(presenter)
      dom.at_css('div span.operator').text.must_equal 'd'
      dom.at_css('div span.motion').text.must_equal 'w'
    end

  end

end
