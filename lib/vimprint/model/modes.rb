module Vimprint

  class BaseMode < Array
    def <<(element)
      if element.respond_to?(:container=)
        element.container = self
      end
      super
    end
  end

  class NormalMode < BaseMode
  end

  class VisualMode < BaseMode
    attr_accessor :nature
    def initialize(nature="charwise")
      super()
      @nature = nature
    end
  end

end
