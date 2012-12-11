require "vimprint/version"
require "vimprint/parser"
require "vimprint/transform"
require "vimprint/html_presenter"

module Vimprint
  def self.parse(input)
    parser = Parser.new
    transformer = Transform.new

    tree = parser.parse(input)
    transformer.apply(tree).map {|o| o.to_s }
  end
end
