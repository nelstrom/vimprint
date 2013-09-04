require_relative 'core_ext/fixnum'
require_relative 'core_ext/string'

module Vimprint

  class NoModeError < NameError; end
  class NoCommandError < NameError; end
  class NoOperatorError < NameError; end
  class NoMotionError < NameError; end

  class Explanation < Struct.new(:template)
    def render(context)
      template.substitute(context)
    end
  end

  class Registry

    def self.lookup(mode, signature)
      Registry.get_mode(mode).get_command(signature)
    end

    def self.get_mode(name)
      @modes.fetch(name) {
        raise NoModeError.new("Vimprint doesn't know about #{name} mode")
      }
    end

    def self.create_mode(name)
      @modes       ||= {}
      @modes[name] ||= new
    end

    def self.get_operator(name)
      @operators.fetch(name) {
        raise NoOperatorError.new("no match found for operator: #{name}")
      }
    end

    def self.create_operator(name, verb)
      @operators       ||= {}
      @operators[name] = verb
    end

    def self.get_motion(signature)
      @motions.fetch(signature) {
        raise NoMotionError.new("no match found for motion: #{signature}")
      }
    end

    def self.create_motion(signature, template)
      @motions       ||= {}
      @motions[signature] = Explanation.new(template)
    end

    def create_command(signature, template)
      @commands ||= {}
      @commands[signature] = Explanation.new(template)
    end

    def get_command(signature)
      @commands.fetch(signature) {
        raise NoCommandError.new("no Explanation found for command signature: #{signature}")
      }
    end

  end

end
