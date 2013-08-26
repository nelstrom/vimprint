require_relative 'registry'

module Vimprint

  @normal_mode = Registry.create_mode("normal")

  # Sample DSL for generating these explanations:
  # command {
  #   trigger 'x'
  #   explain {
  #     template 'cut {{number}} {{register}}'
  #     number {
  #       singular 'character under cursor'
  #       plural '#{count} characters'
  #     }
  #     register {
  #       default 'into default register'
  #       named 'into register #{register}'
  #       uppercase 'and append into register #{register}'
  #     }
  #   }
  # }
  @normal_mode.create_command(
    {trigger: 'x', number: 'singular', register: 'default', mark: ""},
    'cut character under cursor into default register')
  @normal_mode.create_command(
    {trigger: 'x', number: 'plural', register: 'default', mark: ""},
    'cut #{count} characters into default register')
  @normal_mode.create_command(
    {trigger: 'x', number: 'singular', register: 'named', mark: ""},
    'cut character under cursor into register #{register}')
  @normal_mode.create_command(
    {trigger: 'x', number: 'plural', register: 'named', mark: ""},
    'cut #{count} characters into register #{register}')

  # Sample DSL for generating these explanations:
  # command {
  #   trigger 'X'
  #   explain {
  #     template 'cut {{number}} {{register}}'
  #     number {
  #       singular '1 character before cursor'
  #       plural '#{count} characters before cursor'
  #     }
  #     register {
  #       default 'into default register'
  #       named 'into register #{register}'
  #       uppercase 'and append into register #{register}'
  #     }
  #   }
  # }
  @normal_mode.create_command(
    {trigger: 'X', number: 'singular', register: 'default', mark: ""},
    'cut 1 character before cursor into default register')
  @normal_mode.create_command(
    {trigger: 'X', number: 'plural', register: 'default', mark: ""},
    'cut #{count} characters before cursor into default register')
  @normal_mode.create_command(
    {trigger: 'X', number: 'singular', register: 'named', mark: ""},
    'cut 1 character before cursor into register #{register}')
  @normal_mode.create_command(
    {trigger: 'X', number: 'plural', register: 'named', mark: ""},
    'cut #{count} characters before cursor into register #{register}')

  @normal_mode.create_command(
    {trigger: 'm', number: 'singular', register: 'default', mark: 'a'},
    'save current position with local mark a')
end
