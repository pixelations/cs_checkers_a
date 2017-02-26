unit UAI;

interface

uses
  System.SysUtils, UBoard, UMove;

type
  TAI = class(TObject)
  private
    BestValue: TArray;
  public
    NextBoard: TArray;
    WinningSeq: TArrayList;
    MaxDepth: integer;
    constructor Create(ADifficulty: integer);
    function ManualDepth(ADepth: integer): boolean;
    function Minimax(Board: TArray; MaxPlayer: boolean; Depth: integer): TArray;
    function Max(a, b: TArray): TArray;
    function Min(a, b: TArray): TArray;
    function BoardVal(Board: TArray): integer;
  end;

implementation

{ TAI }

function TAI.BoardVal(Board: TArray): integer;
var
  i, j, k: integer;
begin // sticking to basic each counter = +-1
  k := 0;
  for i := Low(Board) to High(Board) do
  begin
    for j := Low(Board[i]) to High(Board[i]) do
      begin
        if Board[i, j] <> -1 then
          begin
            if (Board[i, j] = 0) or (Board[i, j] = 2) then
              dec(k);
            if (Board[i, j] = 1) or (Board[i, j] = 3) then
              inc(k);
          end;
      end;
  end;
  result := k;
end;

constructor TAI.Create(ADifficulty: integer);
begin
  case ADifficulty of
    0:
      MaxDepth := 1;
    1:
      MaxDepth := 2;
    2:
      MaxDepth := 3;
  end;
  setlength(WinningSeq, MaxDepth);
end;

function TAI.ManualDepth(ADepth: integer): boolean;
begin
  if ADepth > 0 then
    MaxDepth := ADepth;
  result := true;
end;

function TAI.Max(a, b: TArray): TArray;
begin
          if a[0, 0] = -2 then
            result := b
          else
          if BoardVal(a) > BoardVal(b) then
            result := a
          else
          if BoardVal(b) > BoardVal(a) then
            result := b
          else
          if BoardVal(a) = BoardVal(b) then
            result := a;
end;

function TAI.Min(a, b: TArray): TArray;

begin
          if a[0, 0] = -2 then
            result := b
          else
          if BoardVal(a) < BoardVal(b) then
            result := a
          else
          if BoardVal(b) < BoardVal(a) then
            result := b
          else
          if BoardVal(a) = BoardVal(b) then
            result := a;

end;

function TAI.Minimax(Board: TArray; MaxPlayer: boolean; Depth: integer): TArray;
var
  b: TArray;
  CMove: TMove;
  t: TArrayList;
  i, j, k: integer;
  v: boolean;
begin
  if Depth <> 0 then
  begin
    CMove := TMove.Create();
    t := CMove.AllPossibleLegalMoves(Board, true);
    BestValue[0, 0] := -2;

    if MaxPlayer then
    begin

      for i := Low(t) to High(t)  do
      begin
      //bestvalue init here?
        b := Minimax(t[i], false, Depth - 1);
        BestValue := Max(BestValue, b);
        result := BestValue;

        if (Depth = MaxDepth - 1) then
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
            if v then nextboard  :=   b;
          end;
           //if v then WinningSeq[MaxDepth - Depth] := Board;
      end;

    end;
    if (not MaxPlayer) then
    begin
      //bestvalue init here?
      for i := Low(t) to High(t) do
      begin
        b := Minimax(t[i], true, Depth - 1);
        BestValue := Min(BestValue, b);
        result := BestValue;

        if (Depth = MaxDepth - 1) then
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
            if v then nextboard  :=   b;
          end;
         //   if v then WinningSeq[MaxDepth - Depth] := Board;
      end;

    end;
    CMove.Free;
  end
  else
result := Board;
end;

end.
