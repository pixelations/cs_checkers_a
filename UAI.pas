unit UAI;

interface

uses
  System.SysUtils, UBoard, UMove;

type
  TAI = class(TObject)
  private
    BestValue: TArray;
    MaxBoard: TArray;
    MinBoard: TArray;
  public
    NextBoard: TArray;
    MaxDepth: integer;
    constructor Create(ADifficulty: integer);
      { sets MaxDepth and defines best and worst board }
    function ManualDepth(ADepth: integer): boolean;
      { allows you to manually set the MaxDepth }
    function Minimax(Board: TArray; MaxPlayer: boolean; Depth: integer): TArray;
      { this will create a tree to decide the best move for a given depth }
    function Max(a, b: TArray): TArray;
      { compares two boards and outputs the board that has the hightest value }
    function Min(a, b: TArray): TArray;
      { compares two boards and outputs the board that has the lowest value }
    function BoardVal(Board: TArray): integer;
      { evaluates each board with an integer value }
  end;

implementation

const
  C_P1 = 0;     //P1 counter
  C_P1_P = 2;   //promoted P1 counter
  C_AI = 1;     //AI counter
  C_AI_P = 3;   //promoted AI counter
  NC = -1;      //no counter
  EASY = 0;
  INTER = 1;
  HARD = 2;

{ TAI }

function TAI.BoardVal(Board: TArray): integer;
var
  i, j, k: integer;
begin
  k := 0;    //zero-sum game
  for i := Low(Board) to High(Board) do
  begin
    for j := Low(Board[i]) to High(Board[i]) do
      begin
        if Board[i, j] <> NC then
          begin
            if (Board[i, j] = C_P1) then       // -1 if C_P1
              dec(k);
            if (Board[i, j] = C_P1_P) then     // -2 if C_P1_P
              dec(k, 2);
            if (Board[i, j] = C_AI) then      // +1 if C_AI
              inc(k);
            if (Board[i, j] = C_AI_P) then    // +2 if C_AI_P
              inc(k, 2);
          end;
      end;
  end;
  result := k;
end;

constructor TAI.Create(ADifficulty: integer);
var
  i, j: integer;
begin
  case ADifficulty of
    EASY:
      MaxDepth := 4;
    INTER:
      MaxDepth := 5;
    HARD:
      MaxDepth := 6;
  end;
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
      begin
        MaxBoard[i, j] := C_AI_P;       //Best value board
        MinBoard[i, j] := C_P1_P;       //Worst value board
      end;
    end;
end;

function TAI.ManualDepth(ADepth: integer): boolean;
begin
  if ADepth > 0 then
    MaxDepth := ADepth;
  result := true;
end;

function TAI.Max(a, b: TArray): TArray;     //best value board is result
begin
  if BoardVal(a) > BoardVal(b) then
    result := a
  else
    begin
      if BoardVal(b) > BoardVal(a) then
        result := b
      else
        begin
          if BoardVal(a) = BoardVal(b) then
            result := a;
        end;
    end;

end;

function TAI.Min(a, b: TArray): TArray;   //worst value board is result

begin
  if BoardVal(a) < BoardVal(b) then
    result := a
  else
    begin
      if BoardVal(b) < BoardVal(a) then
        result := b
      else
        begin
          if BoardVal(a) = BoardVal(b) then
            result := a;
        end;
    end;
end;

function TAI.Minimax(Board: TArray; MaxPlayer: boolean; Depth: integer): TArray;
var
  b: TArray;
  CMove: TMove;
  t: TArrayList;
  i, j, k: integer;
  v: boolean;
begin
  if Depth <> 0 then           //at depth 0 result is Board
  begin
    CMove := TMove.Create();
    t := CMove.AllPossibleLegalMoves(Board, true);

    if MaxPlayer then
    begin
      BestValue := MinBoard;
      for i := Low(t) to High(t)  do
      begin
        //implementation of Minimax algorithm
        b := Minimax(t[i], false, Depth - 1);
        BestValue := Max(BestValue, b);
        result := BestValue;

        if (Depth = MaxDepth - 1) then //picks which board is NextBoard
          begin
            v := true;
            for j := 0 to 7 do
              begin
                for k := 0 to 7 do
                  begin
                    if BestValue[j, k] <> b[j, k] then
                      v := false;
                  end;
              end;
            if v then nextboard := Board;
          end;

      end;
    end;
    if (not MaxPlayer) then
    begin
      BestValue := MaxBoard;
      for i := Low(t) to High(t) do
      begin
        //implementation of Minimax algorithm
        b := Minimax(t[i], true, Depth - 1);
        BestValue := Min(BestValue, b);
        result := BestValue;

        if (Depth = MaxDepth - 1) then       //picks which board is NextBoard
          begin
            v := true;
            for j := 0 to 7 do
              begin
                for k := 0 to 7 do
                  begin
                    if BestValue[j, k] <> b[j, k] then
                      v := false;
                  end;
              end;
            if v then nextboard := Board;
          end;

      end;

    end;
    CMove.Free;
  end
  else
    result := Board;
end;

end.
