require "vimprint/version"
require "vimprint/vim_parser"

module Vimprint
  def self.parse(input)
    normal = NormalMode.new
    parser = VimParser.new(EventList.new(normal))
    parser.process(input)
    normal.eval.map { |o| o.inspect }
  end
end
