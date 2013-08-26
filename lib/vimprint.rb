require "vimprint/version"
require "vimprint/formatters/printer"
require "vimprint/formatters/explainer"
require "vimprint/ragel/parser"

module Vimprint

  def self.explain(keystrokes)
    Explainer.new(process(keystrokes)).explain
  end

  def self.pp(keystrokes)
    Printer.new(process(keystrokes)).print
  end

  private

  def self.process(keystrokes)
    NormalMode.new.tap do |eventlist|
      Parser.new(eventlist).process(keystrokes)
    end
  end

end
