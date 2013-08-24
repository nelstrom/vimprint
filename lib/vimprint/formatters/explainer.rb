require 'vimprint/command_registry'

module Vimprint
  module Explainer
    def self.process(eventlist)
      eventlist.map do |event|
        template = Registry.get_mode('normal').get_command(event.signature)
        count = event.count
        [
          event.raw_keystrokes,
          template.render(binding)
        ]
      end
    end
  end
end
