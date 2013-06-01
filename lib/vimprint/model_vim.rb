class Formatter
  attr_reader :commands
  def initialize(commands)
    @commands = commands
  end

  def print
    commands.plain_print
  end
end

class ExplainFormatter < Formatter

  def print
    commands.explain
  end
end

class NormalMode < Array
  def explain
    map(&:explain).join("\n")
  end
  def plain_print
    map(&:plain_print).join
  end
end
class InsertMode < Array
  def plain_print
    map(&:plain_print).join
  end
end

class Dictionary
  def self.lookup(keystroke)
    {
      'h' => "move 1 character to the left",
      'j' => "move 1 line down"
    }[keystroke]
  end
end

Motion = Struct.new(:keystroke) do
  def explain
    "#{keystroke} - #{Dictionary.lookup(keystroke)}"
  end
  def plain_print
    "#{keystroke} "
  end
end

Switch  = Struct.new(:keystroke) do
  def plain_print
    "\n#{keystroke}{"
  end
end

Input  = Struct.new(:keystroke) do
  def plain_print
    keystroke
  end
end

Terminator = Struct.new(:keystroke) do
  def plain_print
    "}\n"
  end
end

# NormalMode[
#   Motion.new('j'),
#   'k',
#   'l',
#   InsertMode.new(Switch.new('i'), [
#     Input.new('h'),
#     'e',
#     'l',
#     'l',
#     'o',
#     ExpressionLineMode[
#       '4',
#       '0',
#       '+',
#       '2',
#       Terminator.new("\n"),
#     ]
#     Terminator.new("\e"),
#   ]),
#   'j',
# ]
