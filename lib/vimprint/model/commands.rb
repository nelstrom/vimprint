module Vimprint

  class BaseCommand
    attr_reader :trigger, :count, :raw_keystrokes, :register, :mark

    def initialize(config={})
      @trigger        = config[:trigger]
      @count          = config[:count]
      @register       = config[:register]
      @mark           = config[:mark]
      @raw_keystrokes = config[:raw_keystrokes]
    end

    def ==(other)
      @trigger == other.trigger &&
      @count == other.count &&
      @raw_keystrokes == other.raw_keystrokes
    end

    def signature
      {
        trigger: @trigger,
        number:  plurality,
        register: register_description,
        mark: @mark
      }
    end

    def plurality
      return 'singular' if @count.nil?
      @count > 1 ? 'plural' : 'singular'
    end

    def register_description
      return 'default' if (@register.nil? || @register.empty?)
      "named"
    end

  end

  class NormalCommand < BaseCommand
  end

  class RegisterCommand < NormalCommand
    def signature
      {
        trigger: @trigger,
        number:  plurality,
        register: register_description
      }
    end
  end

  class MarkCommand < NormalCommand
    def signature
      {
        trigger: @trigger,
        mark: @mark
      }
    end

  end

end
