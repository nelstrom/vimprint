require 'parslet'

class Parser < Parslet::Parser
  rule(:start) { match('[iIaAoOsS]').as(:switch) }
  rule(:typing) { match('[^\e]').repeat.as(:typing) }
  rule(:terminate) { match('\e').as(:escape) }
  rule(:insertion) { start >> typing >> terminate }
  root(:insertion)
end

class Trans < Parslet::Transform
  rule(
    :switch => simple(:s),
    :typing => simple(:t),
    :escape => simple(:term)
  ) { s+"{"+t+"}"+term }
end

begin
  tree = Parser.new.parse("OHello, World!\e")
  puts tree
  result = Trans.new.apply(tree)
  puts result
rescue Parslet::ParseFailed => error
  puts error.cause.ascii_tree
end
