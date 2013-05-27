require "vimprint/version"
require "vimprint/parser"

module Vimprint
  def self.parse(input)
    normal = NormalMode.new
    parser = VimParser.new(EventList.new(normal))
    parser.process(input)
    normal.eval
  end
end
