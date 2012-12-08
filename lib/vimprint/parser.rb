require "parslet"

module Vimprint
  class Parser < Parslet::Parser
    rule(:start) { match('[iIaAoOsS]').as(:switch) }
    rule(:typing) { match('[^\e]').repeat.as(:typing) }
    rule(:terminate) { match('\e').as(:escape) }
    rule(:insertion) { start >> typing >> terminate }
    root(:insertion)
  end
end
