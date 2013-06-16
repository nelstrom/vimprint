# Roadmap for Vimprint

Vimprint is currently under construction. Here are some of the areas that need work, in approximate order of priority:

- [ ] create a Ruby API for building an AST that models Vim's commands
- [ ] create a formatter that prints each Vim command, with whitespace/newlines to separate them
- [ ] create a formatter that explains each Vim command (in the style of [Vimsplain][])
- [ ] build a Ragel parser for processing Vim keystrokes, turning them into an AST
- [ ] create a Ruby DSL for specifying Vim commands with metadata: start/end mode, trigger, explanation, etc.
- [ ] handle input - capture keystrokes and forward them to Vim and Vimprint
- [ ] handle output - make Vimprint a fullscreen terminal app, using [curses][]/[ncurses][]
- [ ] use the Ruby DSL to specify all of Vim's built-in commands

[curses]: http://www.ruby-doc.org/stdlib-2.0/libdoc/curses/rdoc/Curses.html
[ncurses]: http://ncurses-ruby.berlios.de/
[Vimsplain]: https://github.com/pafcu/Vimsplain
