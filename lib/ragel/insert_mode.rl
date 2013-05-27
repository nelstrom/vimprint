%%{
  machine insert_mode;
  include characters "characters.rl";

  action return { fret; }
  action EmitInput { @listener << Input.new(strokes) }
  action EmitRegister { @listener << InputRegister.new(strokes) }
  action EmitEscape { @listener << Terminator.new(strokes) }

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

