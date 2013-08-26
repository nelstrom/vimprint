require "vimprint/version"
require "vimprint/formatters/printer"
require "vimprint/formatters/explainer"
require "vimprint/ragel/parser"

module Vimprint
  def self.explain(keystrokes)
    eventlist = []
    parser = Parser.new(eventlist)

    parser.process(keystrokes)
    Explainer.process(eventlist)
  end

  def self.pp(keystrokes)
    eventlist = NormalMode.new
    parser = Parser.new(eventlist)

    parser.process(keystrokes)
    printer = Printer.new(eventlist)
    printer.print
  end

end
