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
    {trigger: 'X', number: 'singular', register: 'default'},
    'cut 1 character before cursor into default register')
  @normal_mode.create_command(
    {trigger: 'X', number: 'plural', register: 'default'},
    'cut #{count} characters before cursor into default register')
  @normal_mode.create_command(
    {trigger: 'X', number: 'singular', register: 'named'},
    'cut 1 character before cursor into register #{register}')
  @normal_mode.create_command(
    {trigger: 'X', number: 'plural', register: 'named'},
    'cut #{count} characters before cursor into register #{register}')

  @normal_mode.create_command(
    {trigger: 'm', mark: 'lowercase'},
    'save current position with local mark #{mark}')
  @normal_mode.create_command(
    {trigger: 'm', mark: 'uppercase'},
    'save current position with global mark #{mark}')

  @normal_mode.create_command(
    {trigger: '`', mark: 'lowercase'},
    'jump to local mark #{mark}')
  @normal_mode.create_command(
    {trigger: '`', mark: 'uppercase'},
    'jump to global mark #{mark}')

  @normal_mode.create_command(
    {trigger: 'u', number: 'singular'},
    'undo 1 change')
  @normal_mode.create_command(
    {trigger: 'u', number: 'plural'},
    'undo #{count} changes')

  @normal_mode.create_command(
    {trigger: '<C-r>', number: 'singular'},
    'redo 1 change')
  @normal_mode.create_command(
    {trigger: '<C-r>', number: 'plural'},
    'redo #{count} changes')

  @normal_mode.create_command(
    {trigger: 'r', number: 'singular', printable_char: true},
    'replace current character with #{printable_char}')
  @normal_mode.create_command(
    {trigger: 'r', number: 'plural', printable_char: true},
    'replace next #{count} characters with #{printable_char}')

  @normal_mode.create_command(
    {aborted: true},
    '[aborted command]')

  @normal_mode.create_command(
    {motion: 'w'},
    'move forward to start of next word')
end
