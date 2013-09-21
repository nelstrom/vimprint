module Vimprint
  class Stage

    attr_reader :register, :motion, :counts

    def initialize()
      reset
    end

    def reset
      @buffer = []
      @counts = []
      @operators = []
      string_instance_variables.each do |name|
        instance_variable_set("@#{name}", "")
      end
    end

    def commit
      to_hash.tap { reset }
    end

    def string_instance_variables
      [:register, :trigger, :mark, :switch, :motion, :printable_char]
    end

    def hash_of_string_instance_variables
      Hash[string_instance_variables.map { |name|
        [name, instance_variable_get("@#{name}")]
      }]
    end

    def to_hash
      hash_of_string_instance_variables.merge({
        raw_keystrokes: raw_keystrokes,
        count: effective_count,
        operator: operator,
        echo: echo,
      }).reject do |k,v|
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
