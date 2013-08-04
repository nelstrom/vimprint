require_relative 'registry'

module Vimprint
  class Config
    attr_reader :config

    def initialize(&block)
      @config = HashFromBlock.build(&block)
    end

    def signature
      { trigger: config[:trigger] }
    end

    def template
      config[:explain][:template]
    end

    def projected_templates
      config[:explain][:number].each.with_object({}) do |(key,value),hash|
        hash[key.to_sym] = template.sub('{{number}}', value)
      end
    end
  end

  class HashFromBlock
    attr_reader :hash

    def self.build(&block)
      self.new(&block).hash
    end

    def initialize(&block)
      @hash = {}
      instance_eval(&block)
    end

    def method_missing(name, *args, &block)
      args = args.shift if args.size == 1
      hash[name] = (block.nil?) ? args : self.class.build(&block)
    end
  end

  module Dsl
    class << self
      attr_accessor :current_mode
    end

    def self.parse(&block)
      self.current_mode = Registry.create_mode("normal")
      self.module_eval(&block)
    end

    def self.motion(&block)
      config = Config.new(&block)
      signature = config.signature

      config.projected_templates.each do |number,template|
        current_mode.create_command(
          signature.merge(number: number.to_s),
          template
        )
      end
    end
  end
end
