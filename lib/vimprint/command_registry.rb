require_relative 'registry'

module Vimprint

  @normal_mode = Registry.create_mode("normal")

  @normal_mode.create_command(
    {trigger: 'x'},
    'cut 1 character into default register'
  )

end
