require "vimprint/version"
require "vimprint/formatters/printer"
require "vimprint/formatters/explainer"
require "vimprint/ragel/parser"

module Vimprint
  def self.explain(keystrokes)
    eventlist = NormalMode.new
    parser = Parser.new(eventlist)
    parser.process(keystrokes)
    explainer = Explainer.new(eventlist)
    explainer.explain
  end

  def self.pp(keystrokes)
    eventlist = NormalMode.new
    parser = Parser.new(eventlist)
    parser.process(keystrokes)
    printer = Printer.new(eventlist)
    printer.print
  end

end
