class Object
  def add_to(command_tree)
    command_tree.push_command(self)
  end
end

module Vimprint

  module ModeOpener
    def add_to(command_tree)
      command_tree.push_mode(self)
    end
  end

  module ModeCloser
    def add_to(command_tree)
      command_tree.push_command(self)
      command_tree.pop_mode
    end
  end

  class CommandTree
    attr_reader :root, :stack

    def initialize(root=[])
      @root = root
      @stack = [@root]
    end

    def entry_point
      @stack.last
    end

    def <<(item)
      item.add_to(self)
    end

    def push_mode(mode=[])
      push_command(mode)
      @stack.push(mode)
    end

    def pop_mode()
      @stack.pop
    end

    def push_command(command)
      entry_point.push(command)
    end

  end
end
