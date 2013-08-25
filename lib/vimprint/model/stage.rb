module Vimprint
  class Stage

    attr_reader :register, :trigger, :operator, :motion, :counts

    def initialize()
      reset
    end

    def reset
      @buffer = []
      @counts = []
      @register = ""
    end

    def commit
      to_hash.tap { reset }
    end

    def to_hash
      {
        raw_keystrokes: raw_keystrokes,
        counts: @counts,
        count: effective_count,
        register: @register,
        trigger: @trigger
      }
    end

    def effective_count
      @counts.map { |digit| digit.to_i }.inject(:*)
    end

    alias_method :count, :effective_count

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
