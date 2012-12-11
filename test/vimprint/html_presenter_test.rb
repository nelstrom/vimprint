require "minitest/autorun"
require "vimprint"

describe Vimprint::HtmlPresenter do

  describe "#visit_motion" do

    it "displays the motion" do
      presenter = Vimprint::HtmlPresenter.new
      motion = Vimprint::Operations::Motion.new({:motion => 'j'})
      presenter.visit_motion(motion).must_equal "<div><span class='motion'>j</span><div>"
    end

    it "displays the motion with a count" do
      presenter = Vimprint::HtmlPresenter.new
      motion = Vimprint::Operations::Motion.new({:motion => 'j', :count => 42})
      presenter.visit_motion(motion).must_equal "<div><span class='count'>42</span><span class='motion'>j</span><div>"
    end

  end

end
