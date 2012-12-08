require "parslet"

module Vimprint
  class Transform < Parslet::Transform
    rule(
      :switch => simple(:s),
      :typing => simple(:t),
      :escape => simple(:esc)
    ) { s+"{"+t+"}" }
  end
end
