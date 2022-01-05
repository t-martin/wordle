system"S ",string "j"$.z.t;
words:read0`:words.txt
max_attempt:6;

green:{"\033[38;05;10m",x,"\033[0m"};
yellow:{"\033[38;05;11m",x,"\033[0m"};

new_game:{[]
  avail::.Q.A;
  attempt::1;
  word::rand words;
  board::12#(L:"+---|---|---|---|---+";"|   |   |   |   |   |");
  board,::L;
  -1"\n",K:"-----------------------";
  -1"      New Game";
  -1 K;
  -1 board;
  read[]
  };

guess:{[x]
  if[x~"\\\\"; exit 0];
  x:trim upper x;
  if[5 <> count x;
    -1"Guess can only be 5 characters";
    :read[]
    ];
  if[not all x in .Q.A;
    -1"Guess can only contain letters";
    :read[];
    ];
  check x;
  };

rem:{[x] avail::avail except x};

check:{[x]
  str:{[x;y]$[x~word y;green;x in word;yellow;[rem x;::]] x}'[x;til 5];
  str:(raze{"| ",x," "}each str),"|";
  board[-1+2*attempt]:str;
  -1 board;
  attempt+::1;
  if[x~word;
    -1"Correct! The word was: ",green word;
    :new_game[]; 
    ];
  if[attempt > max_attempt;
    -1 "You lose. The word was: ",green word;
    :new_game[];
    ];
  -1"\nAvailable letters: ",raze avail,\:" ";  
  read[];  
  };

read:{[] 1"\nAttempt ",string[attempt],": ";guess read0 0};

new_game[];
