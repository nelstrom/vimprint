require 'nokogiri'

module Vimprint
  class HtmlPresenter

    def initialize
      @h = Nokogiri::HTML::Builder.new
    end

    def visit_motion(motion)
      h.div do
        if motion.count
          span.count motion.count
        end
        span.motion motion.motion
        yield if block_given?
      end
    end

    def visit_operation(operation)
      # {operator}{motion}
      h.div do
        span.operator operation.operator
        yield if block_given?
      end
    end

    def to_html
      h.to_html
    end

    private
    attr_reader :h

  end
end
