class Terminator < Struct.new(:keystrokes)
  def add_to(list, modestack=nil)
    list << self
    modestack.pop
  end

  def eval
    keystrokes
  end

end

class BaseCommand < Struct.new(:keystrokes)

  def add_to(list, modestack=nil)
    list << self
  end

  def eval
    keystrokes + " "
  end

end

class Motion < BaseCommand
end

class Switch < BaseCommand
end

class InputRegister < BaseCommand
end

class Input < BaseCommand

  def eval
    keystrokes
  end

end

class BaseMode < Array

  def add_to(list, modestack)
    list << self
    modestack << self
  end

  def eval
    map(&:eval)
  end

end

class NormalMode < BaseMode
end

class InsertMode < BaseMode
end

class VisualMode < BaseMode
end

class CmdlineMode < BaseMode
end

class EventList

  attr_accessor :stack, :root

  def initialize(root=[])
    @root = root
    @stack = [@root]
  end

  def entry_point
    @stack.last
  end

  def << (item)
    item.add_to(self.entry_point, self.stack)
  end

end

