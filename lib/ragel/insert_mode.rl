%%{
  machine insert_mode;
  include characters "characters.rl";

  input = (any - (escape|ctrl_R)) >H@T @EmitInput;
  input_register  = ctrl_R [a-z] >H@T @EmitRegister;

  insert  := (
    (
      input |
      input_register
    )*
    escape @EmitEscape
   ) @return;
}%%

