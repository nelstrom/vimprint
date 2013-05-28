%%{
  machine vim_print;

  escape = 27;
  motion = [hjklbwe0];
  switch = [iIaAsSoO];
  input = (any - escape);

  insert  := ( input* escape);

  normal  := (
    motion |
    switch
  )*;

}%%
