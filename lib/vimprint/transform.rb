require "parslet"
require "vimprint/operations"

module Vimprint
  class Transform < Parslet::Transform
    def self.generate(operation_name, subtree)
      klass = Operations.const_get(operation_name)
      rule(subtree, &klass)
    end


    generate :Insertion,
      :switch => simple(:switch),
      :typing => simple(:text),
      :escape => simple(:escape)

    generate :ExCommand,
      :prompt => simple(:prompt),
      :typing => simple(:text),
      :enter => simple(:enter)

    generate :Motion,
      :motion => simple(:motion)

    generate :Motion,
      :motion => simple(:motion),
      :count  => simple(:count)

    rule(
      :operator => simple(:operator),
      :motion   => simple(:motion)
    ) { Operation.new(operator, motion) }

  end
end
