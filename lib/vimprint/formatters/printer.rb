require 'vimprint/command_registry'

module Vimprint
  class Printer
    attr_reader :commands

    def initialize(commands)
      @commands = commands
    end

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
