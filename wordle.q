system"S ",string "j"$.z.t;
WORDS:read0`:words.txt
MAX_ATTEMPTS:6;
LINES:0;

green:{"\033[38;05;10m",x,"\033[0m"};
yellow:{"\033[38;05;11m",x,"\033[0m"};
rem:{[x] AVAIL::AVAIL except x};
clear:{[x] do[x;1"\033[1A";1"\033[2K"]};
print0:{[x;y] LINES+::$[10h=type x;1+sum x="\n";count[x]+sum "\n"=raze x];y x};
print:{[x] print0[x;-1]};
printX:{[x] print0[x;1]};
read:{[] printX "\nAttempt ",string[ATTEMPT],": ";guess read0 0};
ask:{[] printX  "\nNew game? [y/Y]: ";ans:first read0 0; $[ans in "yY"; new_game[]; exit0]}

new_game:{[x]
  GAME_OVER::0b;
  AVAIL::.Q.A;
  ATTEMPT::1;
  WORD::rand WORDS;
  BOARD::12#(L:"+---|---|---|---|---+";"|   |   |   |   |   |");
  BOARD,::L;
  draw_board x;
  };

draw_board:{[x]
  clear LINES;
  LINES::0;
  print "\n",K:"---------------------";
  print "      Wordle";
  print K;
  print BOARD;
  if[10h=type x; print x];
  $[GAME_OVER;
    ask[];
    [print "\nAvailable letters: ",raze AVAIL,\:" ";read[]]
    ];
  };

guess:{[x]
  if[x~"\\\\"; exit 0];
  x:trim upper x;
  if[5 <> count x;
    :draw_board "Guess can only be 5 characters";
    ];
  if[not all x in .Q.A;
    :draw_board "Guess can only contain letters";
    ];
  check x;
  };

check:{[x]
  str:{[x;y]$[x~WORD y;green;x in WORD;yellow;[rem x;::]] x}'[x;til 5];
  str:(raze{"| ",x," "}each str),"|";
  BOARD[-1+2*ATTEMPT]:str;
  ATTEMPT+::1;
  if[x~WORD;
    GAME_OVER::1b;
    :draw_board "Correct! The word was: ",green WORD; 
    ];
  if[ATTEMPT > MAX_ATTEMPTS;
    GAME_OVER::1b;
    :draw_board "You lose. The word was: ",green WORD;
    ];
  draw_board[];
  };

new_game[];
