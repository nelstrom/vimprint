require_relative '../../lib/vimprint/event_list'
require 'minitest/autorun'

describe BaseCommand do
  describe "#eval" do

    it "returns the keystrokes" do
      motion = Motion.new('h')
      motion.eval.must_equal 'h '
    end

  end
end

describe BaseMode do

  it "has an eventlist" do
    root = BaseMode.new
    root.must_equal []
  end

  it "can add events" do
    root = BaseMode.new
    root << BaseMode.new
    root.size.must_equal 1
  end

  describe '#eval' do

    before do
      @normal = NormalMode.new
      @normal << (@motion = MiniTest::Mock.new)
      @normal << (@insertion = MiniTest::Mock.new)
    end

    it 'calls #eval for each event' do
      @motion.expect :eval, nil
      @insertion.expect :eval, nil
      @normal.eval
      assert @motion.verify
      assert @insertion.verify
    end

    it 'generates an array of keystrokes' do
      normal = NormalMode[
        Motion.new('h'),
        Motion.new('j'),
        InsertMode[
          Input.new('h'),
          Input.new('i'),
          Terminator.new("\e")
        ]
      ]

      normal.eval.must_equal [
        "h ",
        "j ",
        [
          "h",
          "i",
          "\e",
        ]
      ]

    end

  end

end

describe EventList do

  describe '#entry_point' do

    it "#entry_point returns a list" do
      events = EventList.new
      events.entry_point.must_equal []
    end

    it "#entry_point can be set on initiation" do
      normal = BaseMode.new()
      events = EventList.new(normal)
      events.entry_point.must_equal normal
    end

  end

  describe '#<<' do

    before do
      @normal          = NormalMode.new()
      @insert          = InsertMode.new()
      @visual          = VisualMode.new()
      @charwise_visual = VisualMode.new()
      @linewise_visual = VisualMode.new()
      @visual_switch   = Terminator.new()
      @visual_motion   = Motion.new()
      @visual_operator = Terminator.new()
      @motion          = Motion.new()
      @input           = Input.new()
      @escape          = Terminator.new()
      @events          = EventList.new(@normal)
    end

    it "appending BaseCommand doesn't change entry_point" do
      @events << @motion
      @events.entry_point.must_equal @normal
    end

    it "appending BaseMode changes entry point" do
      @events << @insert
      @events.entry_point.must_equal(@insert)
    end

    it "appending BaseCommand to sub-mode" do
      @events << @insert
      @events << @input
      @events.entry_point.must_equal [@input]
    end

    it "appending escape pops to Normal mode" do
      @events << @insert
      @events << @input
      @events << @escape
      @events.entry_point.must_equal(@normal)

      @normal.must_equal [@insert]
      @insert.must_equal [@input, @escape]
    end

    it "appending visual_operator (>) pops to Normal mode" do
      @events = EventList.new(@normal)
      @events << @visual                      # v
      @events << @visual_motion               # }
      @events.entry_point.must_equal(@visual)
      @events << @visual_operator             # >
      @events.entry_point.must_equal(@normal)
      @events << @motion                      # j

      @normal.must_equal [@visual, @motion]
      @visual.must_equal [@visual_motion, @visual_operator]
    end

    it "appending visual_operator (c) switches to Insert mode" do
      @events = EventList.new(@normal)
      @events << @visual                      # v
      @events << @visual_motion               # j
      @events.entry_point.must_equal(@visual)
      @events << @visual_operator             # c
      @events << @insert
      @events << @input                       # 1
      @events.entry_point.must_equal(@insert)
      @events << @escape                      # \e
      @events.entry_point.must_equal(@normal)

      @normal.must_equal [@visual, @insert]
      @visual.must_equal [@visual_motion, @visual_operator]
      @insert.must_equal [@input, @escape]
    end

    it "appending visual_switch (V) switches between Visual char/line modes" do
      @events << @charwise_visual                      # v
      @events << @visual_motion                        # }
      @events.entry_point.must_equal(@charwise_visual)
      @events << @visual_switch                        # } V
      @events << @linewise_visual                      # } V
      @events.entry_point.must_equal(@linewise_visual)
      @events << @visual_operator                      # >
      @events.entry_point.must_equal(@normal)
      @events << @motion                               # j

      @normal.must_equal [
        @charwise_visual,
        @linewise_visual,
        @motion
      ]
      @charwise_visual.must_equal [
        @visual_motion,
        @visual_switch
      ]
      @linewise_visual.must_equal [
        @visual_operator
      ]
    end
  end

end
