require_relative 'registry'

module Vimprint

  @normal_mode = Registry.create_mode("normal")

  @normal_mode.create_command(
    {trigger: 'x', number: 'singular'},
    'cut 1 character into default register'
  )

  @normal_mode.create_command(
    {trigger: 'x', number: 'plural'},
    'cut #{count} characters into default register'
  )

end
