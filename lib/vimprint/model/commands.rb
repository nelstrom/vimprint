module Vimprint

  class Terminator < Struct.new(:keystrokes)
    extend Vimprint::ModeCloser
  end

  class BaseCommand < Struct.new(:keystrokes)
  end

  class Motion < BaseCommand
  end

  class Switch < BaseCommand
  end

  class Prompt < BaseCommand
  end

  class InputRegister < BaseCommand
  end

end
