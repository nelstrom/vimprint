require "parslet"

module Vimprint
  class Parser < Parslet::Parser
    rule(:start) { match('[iIaAoOsS]').as(:switch) }
    rule(:typing) { match('[^\e]').repeat.as(:typing) }
    rule(:terminate) { match('\e').as(:escape) }
    rule(:insertion) { start >> typing >> terminate }

    rule(:ex_start) { match(':').as(:prompt) }
    rule(:ex_typing) { match('[^\r]').repeat.as(:ex_typing) }
    rule(:enter) { match('\r').as(:enter) }
    rule(:ex_command) { ex_start >> ex_typing >> enter }

    rule(:normal) { (insertion | ex_command).repeat }
    root(:normal)
  end
end
