require 'nokogiri'

module Vimprint
  class HtmlPresenter

    def initialize
      @body = Nokogiri::HTML::Builder.new { |html| html.body }
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
      # {operator}{motion}
      h.div do
        span.operator operation.operator
        yield if block_given?
      end
    end

    def visit_insertion(insertion)
      h.div do
        span.switch insertion.switch
        span.text insertion.text
        yield if block_given?
        span.escape "&lt;Esc&gt;"
      end
    end

    def to_html
      h.to_html
    end

    private
    attr_reader :body

    def h
      Nokogiri::HTML::Builder.with(body.doc.at('body'))
    end

  end
end
