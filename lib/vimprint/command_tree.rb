module Vimprint
  class CommandTree
    attr_reader :root

    def initialize(root=[])
      @root = root
    end

    def entry_point
      root
    end

    def << (item)
      root << item
    end

  end
end
