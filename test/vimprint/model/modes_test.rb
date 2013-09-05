require 'minitest/autorun'
require 'vimprint/model/modes'

module Vimprint

  describe BaseMode do
    it '#<<(element) creates two-way reference between list and listitems' do
      class Element < Struct.new(:container); end
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
      visual = VisualMode.new("linewise")
      assert_equal visual.nature, "linewise"
    end

  end
end
