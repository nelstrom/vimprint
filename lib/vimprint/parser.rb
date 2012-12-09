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

    # Catch aborted 2-keystroke commands (a.k.a. 'distrokes')
    # e.g. g* and ]m commands require 2 keystrokes
    #      pressing <Esc> after g or ] aborts the command
    rule(:aborted_distroke) {
      ( match('[gz\]\[]') >> match('[\e]') ).as(:aborted_distroke)
    }
    rule(:motion) { one_key_motion | g_key_motion | aborted_distroke }

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
