class Formatter
  attr_reader :commands
  def initialize(commands)
    @commands = commands
  end

  def print
    commands.map(&:plain_print).join
  end
end
class NormalMode < Array
end
class InsertMode < Array
  def plain_print
    map(&:plain_print).join
  end
end

Motion = Struct.new(:keystroke) do
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
