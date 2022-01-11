system"S ",string "j"$.z.t;
UTF_MODE:(.Q.def[(enlist`utf)!enlist 0b].Q.opt .z.x)`utf;
WORDS:read0`:words.txt
MAX_ATTEMPTS:6;
LINES:0;
green:{"\033[38;05;10m",x,"\033[0m"};
yellow:{"\033[38;05;11m",x,"\033[0m"};
red:{"\033[38;05;9m",x,"\033[0m"};
rem:{[x] X,::x};
corr:{[x] C,::x};
inc:{[x] I,::x};
clear:{[x] do[x;1"\033[1A";1"\033[2K"]};
print0:{[x;y] LINES+::$[10h=type x;1+sum x="\n";count[x]+sum "\n"=raze x];y x};
print:{[x] print0[x;-1]};
printX:{[x] print0[x;1]};
read:{[] printX "\n[",string[ATTEMPT],"]: ";guess read0 0};
ask:{[] printX  "\nNew game? [y/Y]: ";ans:first read0 0; $[ans in "yY"; new_game[]; exit 0]}

set_title:{[x]
  if[UTF_MODE;
    TITLE::enlist "        ┌───────────────────┐";
    TITLE,::      "        │       Wordle      │";
    :();
    ];
  TITLE::enlist "        +-------------------+";
  TITLE,::      "        |       Wordle      |";
  };

set_board:{[]
  if[UTF_MODE;
    BOARD::enlist "        ├───┬───┬───┬───┬───┤";
    BOARD,::      "        │   │   │   │   │   │";
    BOARD,::      "        ├───┼───┼───┼───┼───┤";
    BOARD,::      "        │   │   │   │   │   │";
    BOARD,::      "        ├───┼───┼───┼───┼───┤";
    BOARD,::      "        │   │   │   │   │   │";
    BOARD,::      "        ├───┼───┼───┼───┼───┤";
    BOARD,::      "        │   │   │   │   │   │";
    BOARD,::      "        ├───┼───┼───┼───┼───┤";
    BOARD,::      "        │   │   │   │   │   │";
    BOARD,::      "        ├───┼───┼───┼───┼───┤";
    BOARD,::      "        │   │   │   │   │   │";
    BOARD,::      "        └───┴───┴───┴───┴───┘";
    :();
    ];
  BOARD::12#(L:"        +---|---|---|---|---+";"        |   |   |   |   |   |");
  BOARD,::L;
  };

set_keys:{[]
  if[UTF_MODE;
    KEYS::enlist "┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐";
    KEYS,::      "│ Q │ W │ E │ R │ T │ Y │ U │ I │ O │ P │";
    KEYS,::      "└─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┘";
    KEYS,::      "  │ A │ S │ D │ F │ G │ H │ J │ K │ L │";
    KEYS,::      "  └─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴───┘";
    KEYS,::      "    │ Z │ X │ C │ V │ B │ N │ M │";
    KEYS,::      "    └───┴───┴───┴───┴───┴───┴───┘";
    :();
    ];
  KEYS::enlist "+---+---+---+---+---+---+---+---+---+---+";
  KEYS,::      "| Q | W | E | R | T | Y | U | I | O | P |";
  KEYS,::      "+----+---+---+---+---+---+---+---+---+--+";
  KEYS,::      " | A | S | D | F | G | H | J | K | L |";
  KEYS,::      " +-+---+---+---+---+---+---+---+-----+";
  KEYS,::      "   | Z | X | C | V | B | N | M |";
  KEYS,::      "   +---+---+---+---+---+---+---+";
  };

draw_keys:{[f;x]
  print raze each {$[not x in .Q.A;x;x in C;green x;x in I;yellow x;x in X;red x;x]}each/:KEYS;
  if[not 10h=type x;x:""]; print x;
  f[]; 
  };

draw_board:{[x]
  clear LINES;
  LINES::0;
  print TITLE;
  print BOARD;
  draw_keys[;x] $[GAME_OVER;ask;read]
  };

new_game:{[x]
  GAME_OVER::0b;
  ATTEMPT::1;
  WORD::rand WORDS;
  C::X::I::"";
  set_title[];
  set_board[];
  set_keys[];
  draw_board x;
  };

guess:{[x]
  if[x~"\\\\"; exit 0];
  x:trim upper x;
  if[5 <> count x;
    :draw_board red "Guess can only be 5 characters!";
    ];
  if[not all x in .Q.A;
    :draw_board red "Guess can only contain letters!";
    ];
  check x;
  };

check:{[x]
  str:{[x;y]$[x~WORD y;[corr x;green];x in WORD;[inc x;yellow];[rem x;red]] x}'[x;til 5];
  char:$[UTF_MODE;"│";"|"];
  str:("        ",raze{x," ",y," "}[char]each str),char;
  BOARD[-1+2*ATTEMPT]:str;
  ATTEMPT+::1;
  if[x~WORD;
    GAME_OVER::1b;
    :draw_board "Correct! The word was: ",green WORD; 
    ];
  if[ATTEMPT > MAX_ATTEMPTS;
    GAME_OVER::1b;
    :draw_board "You lose. The word was: ",red WORD;
    ];
  draw_board[];
  };

new_game[];
