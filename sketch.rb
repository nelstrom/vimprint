require 'parslet'

class Parser < Parslet::Parser
  rule(:start) { match('[iIaAoOsS]').as(:switch) }
  rule(:typing) { match('[^\e]').repeat.as(:typing) }
  rule(:terminate) { match('\e').as(:escape) }
  rule(:insertion) { start >> typing >> terminate }
  rule(:normal) { insertion.repeat }
  root(:normal)
end

class Trans < Parslet::Transform
  rule(
    :switch => simple(:s),
    :typing => simple(:t),
    :escape => simple(:term)
  ) { s+"{"+t+"}" }
end

begin
  tree = Parser.new.parse("IHello, World!\eoYou look great today!\e")
  puts tree
  result = Trans.new.apply(tree)
  puts result
rescue Parslet::ParseFailed => error
  puts error.cause.ascii_tree
end
