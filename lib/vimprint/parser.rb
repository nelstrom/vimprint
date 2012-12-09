require "parslet"

module Vimprint
  class Parser < Parslet::Parser
    rule(:escape) { match('\e').as(:escape) }
    rule(:enter) { match('\r').as(:enter) }

    # Insertion
    rule(:start) { match('[iIaAoOsS]').as(:switch) }
    rule(:typing) { match('[^\e]').repeat.as(:typing) }
    rule(:insertion) { start >> typing >> escape }

    # Ex Command
    rule(:ex_start) { match(':').as(:prompt) }
    rule(:ex_typing) { match('[^\r\e]').repeat.as(:ex_typing) }
    rule(:run_ex_cmd) { ex_start >> ex_typing >> enter }
    rule(:abort_ex_cmd) { ex_start >> ex_typing >> escape }
    rule(:ex_command) { (run_ex_cmd | abort_ex_cmd) }

    rule(:normal) { (insertion | ex_command).repeat }
    root(:normal)
  end
end
