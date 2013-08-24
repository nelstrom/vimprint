module Vimprint

  class BaseCommand < Struct.new(:keystrokes)
  end

  class NormalCommand < BaseCommand
  end

end
