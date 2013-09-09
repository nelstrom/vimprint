module Vimprint

  class BaseMode

    extend Forwardable
    def_delegators :@events, :size, :map
    attr_accessor :events

    def initialize(*events)
      events.each { |e| reciprocate(e) }
      @events = events
    end

    def <<(event)
      reciprocate(event)
      @events << event
    end

    private

    def reciprocate(event)
      if event.respond_to?(:container=)
        event.container = self
      end
    end

  end

  class NormalMode < BaseMode
  end

  class VisualMode < BaseMode
    attr_accessor :nature
    def initialize(nature="charwise", *events)
      super(*events)
      @nature = nature
    end
  end

end
