module Vimprint
  class Stage

    attr_reader :register, :trigger, :operator, :motion, :counts, :mark, :printable_char

    def initialize()
      reset
    end

    def reset
      @buffer = []
      @counts = []
      @register = ""
      @mark = ""
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
        register: @register,
        trigger: @trigger,
        mark: @mark,
        printable_char: @printable_char
      }.reject do |k,v|
        v.nil? || v == [] || v == ""
      end
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
      else
        instance_variable_set("@#{name}", value)
      end
      @buffer << value
    end

  end

end
