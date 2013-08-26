require 'vimprint/command_registry'

module Vimprint
  class BaseFormatter
    attr_reader :commands

    def initialize(commands)
      @commands = commands
    end
  end
end
