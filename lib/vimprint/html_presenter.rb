module Vimprint
  class HtmlPresenter

    def visit_motion(motion)
      count_span = motion.count ? "<span class='count'>#{motion.count}</span>" : ""
      "<div>#{count_span}<span class='motion'>#{motion.motion}</span><div>"
    end

  end
end
