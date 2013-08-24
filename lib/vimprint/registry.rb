require_relative 'core_ext/fixnum'
require_relative 'core_ext/string'

module Vimprint

  class NoModeError < NameError; end
  class NoCommandError < NameError; end

  class Explanation < Struct.new(:template)
    def render(context)
      template.substitute(context)
    end
  end

  class Registry

    def self.get_mode(name)
      @modes.fetch(name) {
        raise NoModeError.new("Vimprint doesn't know about #{name} mode")
      }
    end

    def self.create_mode(name)
      @modes       ||= {}
      @modes[name] ||= new
    end

    def create_command(signature, template)
      @commands ||= {}
      @commands[signature] = Explanation.new(template)
    end

    def get_command(signature)
      @commands.fetch(signature) {
        raise NoCommandError.new("Vimprint doesn't know about #{signature} command")
      }
    end

  end

end
