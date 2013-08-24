require 'vimprint/command_registry'

module Vimprint
  module Explainer
    def self.process(eventlist)
      eventlist.map do |event|
        [event.keystrokes, Registry.get_mode('normal').get_command({trigger: event.keystrokes}).template]
      end
    end
  end
end
