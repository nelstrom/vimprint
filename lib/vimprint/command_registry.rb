require_relative 'registry'

module Vimprint

  @normal_mode = Registry.create_mode("normal")

  @normal_mode.create_command(
    {trigger: 'x', number: 'singular', register: 'default'},
    'cut character under cursor into default register')
  @normal_mode.create_command(
    {trigger: 'x', number: 'plural', register: 'default'},
    'cut #{count} characters into default register')
  @normal_mode.create_command(
    {trigger: 'x', number: 'singular', register: 'named'},
    'cut character under cursor into register #{register}')
  @normal_mode.create_command(
    {trigger: 'x', number: 'plural', register: 'named'},
    'cut #{count} characters into register #{register}')

  @normal_mode.create_command(
    {trigger: 'X', number: 'singular', register: 'default'},
    'cut 1 character before cursor into default register'
  )

end
