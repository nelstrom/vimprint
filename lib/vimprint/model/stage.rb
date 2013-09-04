module Vimprint
  class Stage

    attr_reader :register, :trigger, :operator, :motion, :counts, :mark, :switch, :printable_char

    def initialize()
      reset
    end

    def reset
      @buffer = []
      @counts = []
      @operators = []
      @register = ""
      @operator = ""
      @motion = ""
      @mark = ""
      @switch = ""
      @trigger = ""
      @printable_char = ""
    end

    def commit
      to_hash.tap { reset }
    end

    def to_hash
      {
        raw_keystrokes: raw_keystrokes,
        count: effective_count,
        operator: operator,
        echo: echo,
        register: @register,
        trigger: @trigger,
        mark: @mark,
        switch: @switch,
        motion: @motion,
        printable_char: @printable_char
      }.reject do |k,v|
        v.nil? || v == [] || v == ""
      end
    end

    def echo
      @operators[1]
    end

    def operator
      @operators[0]
    end

    def echo_is_true?
      operator == echo || operator[-1] == echo
    end

    def effective_count
      @counts.map { |digit| digit.to_i }.inject(:*)
    end

    alias_method :count, :effective_count

    def raw_keystrokes
      @buffer.join
    end

    def add(name, value)
      case name
      when :register then @register = value.sub(/^"/, '')
      when :count then @counts << value
      when :operator then @operators << value
      else
        instance_variable_set("@#{name}", value)
      end
      @buffer << value
    end

  end

end
