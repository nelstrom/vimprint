module Vimprint

  class BaseCommand
    attr_reader :trigger, :count, :raw_keystrokes

    def initialize(config={})
      @trigger        = config[:trigger]
      @count          = config[:count]
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
        number:  plurality
      }
    end

    def plurality
      return 'singular' if @count.nil?
      @count > 1 ? 'plural' : 'singular'
    end

  end

  class NormalCommand < BaseCommand
  end

end
