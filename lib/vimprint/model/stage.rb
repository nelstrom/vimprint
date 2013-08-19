module Vimprint
  class Stage

    attr_reader :register, :trigger, :operator, :motion, :counts

    def initialize()
      @buffer = []
      @counts = []
    end

    def to_hash
      {
        raw_keystrokes: raw_keystrokes,
        counts: @counts,
        trigger: @trigger
      }
    end

    def raw_keystrokes
      @buffer.join
    end

    def add_count(value)
      @counts << value
      @buffer << value
    end

    def add_register(address)
      @register = address
      @buffer << '"' + address
    end

    def add_trigger(keystrokes)
      @trigger = keystrokes
      @buffer << keystrokes
    end

    def add_operator(keystrokes)
      @operator = keystrokes
      @buffer << keystrokes
    end

    def add_motion(keystrokes)
      @motion = keystrokes
      @buffer << keystrokes
    end

    def escape
      @buffer << "\e"
    end

  end

end
