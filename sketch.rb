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

  rule(:one_key_motion) { match('[hjklwbe$0^]').as(:motion) }
  rule(:two_key_motion) { (str('g') >> match('[hjkle$0^]')).as(:motion) }
  rule(:find_char_motion) { (match('[fFtT]') >> match('[^\e]') ).as(:motion) }
  rule(:motion) { one_key_motion | two_key_motion | find_char_motion }

  rule(:operator) { match('[dcy]').as(:operator) }
  rule(:l_operation) { (operator.as(:op1) >> operator.as(:op2)).as(:l_operation) }
  rule(:operation) { (operator >> motion).as(:operation) }

  rule(:normal) { (insertion | ex_command | ex_command_aborted | motion | operation | l_operation).repeat }
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
  ) { nil }
  rule(
    :motion => simple(:m)
  ) { m }

  rule(
    :operator => simple(:o),
    :motion => simple(:m)
  ) { o+m }
  rule(
    :op1 => simple(:o1),
    :op2 => simple(:o2)
  ) { o1+o2 }
  rule(
    :operator => simple(:o)
  ) { o }
  rule(
    :l_operation => simple(:o)
  ) { o }
  rule(
    :operation => simple(:o)
  ) { o }

  rule(
    :prompt => simple(:p),
    :ex_typing => simple(:t),
    :enter => simple(:carriage_return)
  ) { p+t }
end

begin
  tree = Parser.new.parse("IHello, World!\e0$g0f,0dwyy:write\e:q!\r")
  puts tree
  result = Trans.new.apply(tree)
  puts result.compact
rescue Parslet::ParseFailed => error
  puts error.cause.ascii_tree
end
