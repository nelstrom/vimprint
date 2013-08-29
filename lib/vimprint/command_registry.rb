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
    {motion: 'w', number: 'singular'},
    '#{verb} forward to start of next word')
  @normal_mode.create_command(
    {motion: 'w', number: 'plural'},
    '#{verb} forward to start of #{count.ordinalize} word')
  @normal_mode.create_command(
    {motion: 'e', number: 'singular'},
    '#{verb} forward to end of word')
  @normal_mode.create_command(
    {motion: 'e', number: 'plural'},
    '#{verb} forward to end of #{count.ordinalize} word')

  @normal_mode.create_command(
    {operator: 'd', motion: 'w'},
    'delete from cursor to start of next word')

  # e.g. dw
  @normal_mode.create_command(
    {
      operator: 'd',
      register: 'default',
      modifier: {
        kind: 'motion',
        number: 'singular',
        typewise: 'charwise',
      }
    },
    'cut {from cursor to start of next word}, save text to default register')
  # e.g. 2dw or d2w
  @normal_mode.create_command(
    {
      operator: 'd',
      register: 'default',
      modifier: {
        kind: 'motion',
        number: 'plural',
        typewise: 'charwise',
      }
    },
    'cut {from cursor to start of #{count.ordinalize} word}, save text to default register')
  # e.g. "adw
  @normal_mode.create_command(
    {
      operator: 'd',
      register: 'named',
      modifier: {
        kind: 'motion',
        number: 'plural',
        typewise: 'charwise',
      }
    },
    'cut {from cursor to start of #{count.ordinalize} word}, save text to register #{register}')
  # e.g. dd
  @normal_mode.create_command(
    {
      operator: 'd',
      register: 'named',
      modifier: {
        kind: 'operator',
        number: 'plural',
        typewise: 'linewise',
      }
    },
    'cut {#{count} lines}, save text to register #{register}')
  # e.g. "a2cw
  @normal_mode.create_command(
    {
      operator: 'c',
      register: 'named',
      modifier: {
        kind: 'motion',
        number: 'plural',
        typewise: 'charwise',
      }
    },
    'cut {from cursor to start of #{count.ordinalize} word}, save text to register #{register}, start Insert mode')

  # Operator:
  #     template: "delete {{motion}}"
  # Motion
  #
  # Two possibilities:
  #     1) Operater asks Motion to explain itself
  #     2) Motion asks Operator to fill in the 'verb'
  #
  # 1) Definitions take this form:
  #    operator: 'cut #{motion.explain(self)}, save text to default register'
  #    motion:   '#{verb} forward to end of word'
  #
  # 2) Definitions take this form:
  #    motion: '#{verb.context} forward to end of word'
  #    operator: 'cut'

end
