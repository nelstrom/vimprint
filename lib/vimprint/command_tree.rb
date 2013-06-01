module Vimprint

  module ModeOpener
    def add_to(command_tree)
      command_tree.push_mode(self)
    end
  end

  module ModalCommand
    def add_to(command_tree)
      command_tree.entry_point << self
    end
  end

  module ModeCloser
    def add_to(command_tree)
      command_tree.entry_point << self
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

    def << (item)
      if item.respond_to?(:add_to)
        item.add_to(self)
      else
        entry_point << item
      end
    end

    def push_mode(mode=[])
      entry_point.push(mode)
      @stack.push(mode)
    end

    def pop_mode()
      @stack.pop
    end

  end
end
