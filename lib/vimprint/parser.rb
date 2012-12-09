require "parslet"

module Vimprint
  class Parser < Parslet::Parser
    rule(:escape) { match('\e').as(:escape) }
    rule(:enter) { match('\r').as(:enter) }

    # Ways of typing
    rule(:type_into_document) {
      match('[^\e]').repeat.as(:typing)
    }
    rule(:type_into_cmdline) {
      match('[^\r\e]').repeat.as(:typing)
    }

    # Insertion
    rule(:begin_insert) { match('[iIaAoOsS]').as(:switch) }
    rule(:insertion) {
      begin_insert >> type_into_document >> escape
    }

    # Ex Command
    rule(:begin_ex_cmd) { match(':').as(:prompt) }
    rule(:run_ex_cmd) {
      begin_ex_cmd >> type_into_cmdline >> enter
    }
    rule(:abort_ex_cmd) {
      begin_ex_cmd >> type_into_cmdline >> escape
    }
    rule(:ex_command) { (run_ex_cmd | abort_ex_cmd) }

    rule(:normal) { (insertion | ex_command).repeat }
    root(:normal)
  end
end
