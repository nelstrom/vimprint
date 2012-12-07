require 'parslet'

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

class Trans < Parslet::Transform
  rule(
    :switch => simple(:s),
    :typing => simple(:t),
    :escape => simple(:term)
  ) { s+"{"+t+"}" }
  rule(
    :prompt => simple(:p),
    :ex_typing => simple(:t),
    :enter => simple(:cr)
  ) { p+t }
end

begin
  tree = Parser.new.parse("IHello, World!oYou look great today!:write:quit!")
  puts tree
  result = Trans.new.apply(tree)
  puts result
rescue Parslet::ParseFailed => error
  puts error.cause.ascii_tree
end
