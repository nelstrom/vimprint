require 'minitest/autorun'
require 'vimprint/model/modes'

class Element < Struct.new(:container); end

module Vimprint

  describe BaseMode do

    it '#new sets element.container=self for each element' do
      one, two = [Element.new, Element.new]
      list = BaseMode.new(one, two)
      assert_equal [one, two], list.events
      assert_equal list, one.container
      assert_equal list, two.container
    end

    it '#<<(element) creates two-way reference between list and listitems' do
      (list = BaseMode.new) << (element = Element.new)
      assert_equal list, element.container
    end
  end

  describe VisualMode do

    it 'assumes charwise nature by default' do
      visual = VisualMode.new
      assert_equal visual.nature, "charwise"
    end

    it 'allows nature to be changed dynamically' do
      visual = VisualMode.new
      visual.nature = "linewise"
      assert_equal visual.nature, "linewise"
    end

    it 'allows nature to be set on creation' do
      one, two = [Element.new, Element.new]
      visual = VisualMode.new("linewise", one, two)
      assert_equal visual.nature, "linewise"
      # everything else works as it should...?
      assert_equal [one, two], visual.events
      assert_equal visual, one.container
      assert_equal visual, two.container
    end

  end
end
