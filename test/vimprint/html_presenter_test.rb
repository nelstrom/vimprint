require "minitest/autorun"
require "vimprint"

describe Vimprint::HtmlPresenter do

  def dom(fragment)
    Nokogiri::HTML.fragment(fragment)
  end

  def presenter
    @p ||= Vimprint::HtmlPresenter.new 
  end

  describe "#visit_motion" do

    it "displays the motion" do
      motion = Vimprint::Operations::Motion.new({:motion => 'j'})
      html = presenter.visit_motion(motion)
      dom(html).at_css('div .motion').text.must_equal 'j'
    end

    it "displays the motion with a count" do
      motion = Vimprint::Operations::Motion.new({:motion => 'j', :count => 42})
      html = presenter.visit_motion(motion)
      dom(html).at_css('div .motion').text.must_equal 'j'
      dom(html).at_css('div .count').text.must_equal '42'
    end

  end

end
