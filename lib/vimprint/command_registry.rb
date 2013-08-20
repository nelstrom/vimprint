require_relative 'registry'

@normal_mode  = Registry.create_mode("normal")
@insert_mode  = Registry.create_mode("insert")
@cmdline_mode = Registry.create_mode("cmdline")
@visual_mode  = Registry.create_mode("visual")

# MOTIONS
[
  [{trigger: 'h'},  '#{verb} left one column'],
  [{trigger: 'j'},  '#{verb} down one line'],
  [{trigger: 'k'},  '#{verb} up one line'],
  [{trigger: 'l'},  '#{verb} right one column'],
  [{trigger: 'w'},  '#{verb} forward to start of word'],
  [{trigger: 'b'},  '#{verb} backward to start of word'],
  [{trigger: 'e'},  '#{verb} forward to end of word'],
  [{trigger: 'ge'}, '#{verb} backward to end of word'],
  [{trigger: 'W'},  '#{verb} forward to start of WORD'],
  [{trigger: 'B'},  '#{verb} backward to start of WORD'],
  [{trigger: 'E'},  '#{verb} forward to end of WORD'],
  [{trigger: 'gE'}, '#{verb} backward to end of WORD'],
].map do |signature, description|
  @normal_mode.create_command(signature, description)
  @visual_mode.create_command(signature, description)
end

# Does it make sense to generate motion 'commands' for Normal+Visual modes?
# What about creating motions in their own space?
# TODO: create a Registry.create_motion() method
