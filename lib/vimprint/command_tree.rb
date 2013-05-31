module Vimprint

  module ModeOpener
    def add_to(list, modestack)
      list << self
      modestack << self
    end
  end

  module ModalCommand
  end

  module ModeCloser
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
        item.add_to(self.entry_point, self.stack)
      else
        entry_point << item
      end
    end

    def push_mode(mode=[])
      @stack.push(mode)
      @root.push(mode)
    end

    def pop_mode()
      @stack.pop
    end

  end
end
