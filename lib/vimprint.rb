require "vimprint/version"
require "vimprint/parser"
require "vimprint/transform"

module Vimprint
  def self.parse(input)
    parser = Parser.new
    transformer = Transform.new

    tree = parser.parse(input)
    # puts; p tree; puts

    transformer.apply(tree)
  end
end
