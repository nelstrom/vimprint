%%{
  machine command_line_mode;
  include characters "characters.rl";

  cmdline_input = (any - (escape|enter|ctrl_R)) >H@T @EmitInput;
  cmdline_input_register  = ctrl_R [a-z] >H@T @EmitRegister;

  command_line_mode  := (
    (
      cmdline_input |
      cmdline_input_register
    )*
    (enter  @EmitEnter | escape @EmitEscape)
   ) @return;
}%%

