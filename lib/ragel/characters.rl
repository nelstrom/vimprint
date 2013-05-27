%%{
  machine characters;
  action H { @head = p }
  action T { @tail = p }

  ctrl_M = 13;
  ctrl_R = 18;
  ctrl_open_bracket = 27;

  enter  = ctrl_M;
  escape = ctrl_open_bracket >H@T;
}%%
