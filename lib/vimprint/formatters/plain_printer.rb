require_relative '../model_vim'

module Vimprint
  class Formatter
    attr_reader :commands
    def initialize(commands)
      @commands = commands
    end

    def print
      commands.plain_print
    end

  end

  class NormalMode
    def plain_print
      map(&:plain_print).join
    end
  end

  class VisualMode
  end

  class InsertMode
    def plain_print
      map(&:plain_print).join
    end
  end

  Motion = Struct.new(:keystroke, :count) do
    def plain_print
      "#{keystroke} "
    end
  end

  Switch  = Struct.new(:keystroke) do
    def plain_print
      "\n#{keystroke}{"
    end
  end

  Input  = Struct.new(:keystroke) do
    def plain_print
      keystroke
    end
  end

  Terminator = Struct.new(:keystroke) do
    def plain_print
      "}\n"
    end
  end

  NormalCommand = Struct.new(:keystroke) do
  end

  VisualOperation = Struct.new(:keystroke) do
  end

end
