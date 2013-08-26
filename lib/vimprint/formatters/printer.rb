require 'vimprint/formatters/base_formatter'

module Vimprint
  class Printer < BaseFormatter
    def print
      commands.print
    end
  end

  class NormalMode
    def print
      map(&:print).join
    end
  end

  class NormalCommand
    def print
      raw_keystrokes + " "
    end
  end

end
