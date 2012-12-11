require 'nokogiri'

module Vimprint
  class HtmlPresenter

    def visit_motion(motion)
      h = Nokogiri::HTML::Builder.new
      h.div do
        if motion.count
          h.span.count motion.count
        end
        h.span.motion motion.motion
      end.to_html
    end

  end
end
