module Vimprint
  module Operations
    class Base
      def initialize(dict)
        dict.each {|key, value| send("#{key}=", value) }
      end

      def self.to_proc
        lambda {|dict| self.new dict }
      end
    end

    class Insertion < Base
      attr_accessor :switch, :text
      attr_writer :escape

      def to_s
        '%s{%s}' % [ switch, text ]
      end

      def accept(visitor)
        visitor.visit_insertion(self)
      end

    end

    class ExCommand < Base
      attr_accessor :prompt, :text
      attr_writer :enter

      def to_s
        '%s%s' % [ prompt, text ]
      end

      def accept(visitor)
        visitor.visit_ex_command(self)
      end

    end

    class Motion < Base
      attr_accessor :motion, :count

      def to_s
        '%s%s' % [ count, motion ]
      end

      def accept(visitor)
        visitor.visit_motion(self)
      end

    end

    class Operation < Base
      attr_accessor :operator, :motion

      def initialize(options)
         @motion = Motion.new({:motion => options[:motion]})
         @operator = options[:operator]
      end

      def to_s
        '%s%s' % [ operator, motion ]
      end

      def accept(visitor)
        visitor.visit_operation(self) do
          motion.accept(visitor)
        end
      end

    end

  end
end
