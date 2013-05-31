module Vimprint
  class CommandTree
    attr_reader :root

    def initialize(root=[])
      @root = root
      @stack = [@root]
    end

    def entry_point
      @stack.last
    end

    def << (item)
      entry_point << item
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
