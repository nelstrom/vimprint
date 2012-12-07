require 'parslet'

class Parser < Parslet::Parser
  rule(:start) { match('[iIaAoOsS]').as(:switch) }
  rule(:typing) { match('[^\e]').repeat.as(:typing) }
  rule(:terminate) { match('\e').as(:escape) }
  rule(:insertion) { start >> typing >> terminate }

  rule(:ex_start) { match(':').as(:prompt) }
  rule(:ex_typing) { match('[^\r\e]').repeat.as(:ex_typing) }
  rule(:enter) { match('\r').as(:enter) }
  rule(:ex_command) { ex_start >> ex_typing >> enter }
  rule(:ex_command_aborted) { ex_start >> ex_typing >> terminate }

  rule(:one_key_motion) { match('[hjklwbe]').as(:motion) }
  rule(:two_key_motion) { (str('g') >> match('[hjkl]')).as(:motion) }
  rule(:motion) { one_key_motion | two_key_motion }

  rule(:normal) { (insertion | ex_command | ex_command_aborted | motion).repeat }
  root(:normal)
end

class Trans < Parslet::Transform
  rule(
    :switch => simple(:s),
    :typing => simple(:t),
    :escape => simple(:esc)
  ) { s+"{"+t+"}" }
  rule(
    :prompt => simple(:p),
    :ex_typing => simple(:t),
    :escape => simple(:esc)
  ) { '' }
  rule(
    :motion => simple(:m)
  ) { m }
  rule(
    :prompt => simple(:p),
    :ex_typing => simple(:t),
    :enter => simple(:carriage_return)
  ) { p+t }
end

begin
  tree = Parser.new.parse("IHello, World!\ebbbegl:write\e:q!\r")
  puts tree
  result = Trans.new.apply(tree)
  puts result
rescue Parslet::ParseFailed => error
  puts error.cause.ascii_tree
end
