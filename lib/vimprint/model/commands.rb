module Vimprint

  module ReceivesCount
    def plurality
      return 'singular' if @count.nil?
      @count > 1 ? 'plural' : 'singular'
    end
  end

  class BaseCommand
    attr_accessor :container
    attr_reader :trigger, :count, :raw_keystrokes, :register, :mark

    def initialize(config={})
      @trigger        = config[:trigger]
      @count          = config[:count]
      @register       = config[:register]
      @motion         = config[:motion]
      @mark           = config[:mark]
      @switch         = config[:switch]
      @operator       = config[:operator]
      @raw_keystrokes = config[:raw_keystrokes]
      @printable_char = config[:printable_char]
    end

    def ==(other)
      @trigger == other.trigger &&
      @count == other.count &&
      @raw_keystrokes == other.raw_keystrokes
    end

    def signature
      {}
    end

  end

  class NormalCommand < BaseCommand
    include ReceivesCount
    def signature
      super.merge({
        number: plurality,
        trigger: trigger
      })
    end
  end

  class RegisterCommand < NormalCommand
    def signature
      super.merge({register: register_description})
    end

    def register_description
      return 'default' if (@register.nil? || @register.empty?)
      "named"
    end
  end

  class MarkCommand < BaseCommand
    def signature
      super.merge({
        mark: mark_description,
        trigger: trigger
      })
    end

    def mark_description
      /[[:upper:]]/.match(@mark) ? "uppercase" : "lowercase"
    end
  end

  class ReplaceCommand < NormalCommand
    attr_accessor :printable_char
    def signature
      super.merge({printable_char: true})
    end
  end

  class AbortedCommand < BaseCommand
    def signature
      { aborted: true }
    end
  end

  class BareMotion < BaseCommand
    include ReceivesCount
    attr_accessor :motion, :invocation_context
    def initialize(config={})
      super
      @invocation_context = config[:invocation_context] || 'normal'
    end
    def signature
      super.merge({
        number: plurality,
        motion: motion
      })
    end
  end

  class MotionCommand < BareMotion
    def verb
      case @invocation_context
      when "visual" then "select"
      when "normal" then "move forward"
      end
    end
  end

  class Operator
    attr_accessor :trigger, :register
    def initialize(config={})
      @trigger = config[:trigger]
      @register = config[:register]
    end
    def signature
      {trigger: @trigger}
    end
    def ==(other)
      @trigger == other.trigger &&
      @register == other.register
    end
  end

  class Extent
    def self.build(config)
      if config.has_key?(:echo) && config[:echo] != ''
        Echo.new({
          trigger: config[:echo],
          count: config[:count]
        })
      else
        BareMotion.new({
          motion: config[:motion],
          count: config[:count],
          invocation_context: 'operator_pending'
        })
      end
    end
  end

  class Echo
    attr_reader :trigger, :count
    def initialize(config={})
      @trigger = config[:trigger]
      @count = config.fetch(:count, 1).to_i
    end
    def ==(other)
      @trigger == other.trigger
    end
  end

  class Operation < BaseCommand
    attr_accessor :operator, :extent

    def self.build(stage)
      if stage.echo_is_true? || stage.motion != ''
        Operation.new(stage.commit)
      else
        AbortedCommand.new(stage.commit)
      end
    end

    def initialize(config={})
      @raw_keystrokes = config[:raw_keystrokes]
      @operator = Operator.new({
        trigger:    config[:operator],
        register:   config[:register]
      })
      @extent = Extent.build(config)
    end
  end

  class VisualSwitch < BaseCommand
    attr_reader :switch, :commands
    def initialize(config={})
      super
      @commands = VisualMode.new
    end
    def signature
      super.merge({ switch: switch })
    end
  end

  class Terminator < BaseCommand
    def signature
      super.merge({ pop: true })
    end
  end

  class VisualOperation < Terminator
    attr_accessor :operator
    def initialize(config={})
      super
      @operator = Operator.new({
        trigger:    config[:operator],
      })
    end
    def signature
      super.merge({operator: operator})
    end
    def selection
      case container.nature
      when 'charwise' then 'selected characters'
      when 'linewise' then 'selected lines'
      else "selection"
      end
    end
  end

end
