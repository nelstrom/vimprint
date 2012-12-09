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

    # Simple insertion
    rule(:begin_insert) { match('[iIaAoOsS]').as(:switch) }
    rule(:insertion) {
      begin_insert >> type_into_document >> escape
    }

    # Simple motion
    ONE_KEY_MOTIONS = 'hHjklLMwbeWBEnNG$0^%*#'
    rule(:one_key_motion) {
      match("[#{ONE_KEY_MOTIONS}]").as(:motion)
    }
    G_KEY_MOTIONS = 'geEhjklm*#0^$'
    rule(:g_key_motion) {
      (str('g') >> match("[#{G_KEY_MOTIONS}]")).as(:motion)
    }
    rule(:motion) { one_key_motion | g_key_motion }

    # Ex Command
    rule(:begin_ex_cmd) { match(':').as(:prompt) }
    rule(:run_ex_cmd) {
      begin_ex_cmd >> type_into_cmdline >> enter
    }
    rule(:abort_ex_cmd) {
      begin_ex_cmd >> type_into_cmdline >> escape
    }
    rule(:ex_command) { (run_ex_cmd | abort_ex_cmd) }

    rule(:normal) { (insertion | ex_command | motion).repeat }
    root(:normal)
  end
end
