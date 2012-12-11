require 'nokogiri'

module Vimprint
  class HtmlPresenter

    def initialize
      @h = Nokogiri::HTML::Builder.new
    end

    def visit_motion(motion)
      h.div do
        if motion.count
          h.span.count motion.count
        end
        h.span.motion motion.motion
      end
    end

    def to_html
      h.to_html
    end

    private
    attr_reader :h

  end
end
