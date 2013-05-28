%%{
  machine vim_print;

  escape = 27;
  input = (any - escape);
  motion = [hjklbwe0];
  switch = [iIaAsSoO];

  insert  := (
    input*
    escape
  );

  normal  := (
    motion |
    switch
  )*;

}%%
