%%{
  machine characters;
  action H { @head = p }
  action T { @tail = p }

  action return { fret; }
  action EmitInput { @listener << Input.new(strokes) }
  action EmitRegister { @listener << InputRegister.new(strokes) }
  action EmitEscape { @listener << Terminator.new(strokes) }
  action EmitEnter  { @listener << Terminator.new(strokes) }

  ctrl_M = 13;
  ctrl_R = 18;
  ctrl_open_bracket = 27;

  enter  = ctrl_M >H@T;
  escape = ctrl_open_bracket >H@T;
}%%
