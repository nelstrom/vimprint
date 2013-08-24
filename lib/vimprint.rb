require "vimprint/version"
require "vimprint/formatters/explainer"
require "vimprint/ragel/parser"

module Vimprint
  def self.explain(keystrokes)
    eventlist = []
    parser = Parser.new(eventlist)

    parser.process(keystrokes)
    Explainer.process(eventlist)
  end
end
