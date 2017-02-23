unit UAI;

interface

uses
  System.SysUtils, UBoard, UMove;

type
  TAI = class
  private
    MaxDepth: integer;
    AIColour: boolean;
    BestValue: TObjectArray;
    NextBoard: TObjectArray;
  public
    constructor Create(ADifficulty: integer; AAIColour: boolean);
    function ManualDepth(ADepth: integer): boolean;
    function Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer)
      : TObjectArray;
    function Max(a, b: TObjectArray): TObjectArray;
    function Min(a, b: TObjectArray): TObjectArray;
    function BoardVal(Board: TObjectArray): real;
    function AIMove(Board: TObjectArray): TObjectArray;
  end;

implementation

{ TAI }

function TAI.AIMove(Board: TObjectArray): TObjectArray;
begin
  Minimax(Board, true, MaxDepth);
  result := NextBoard;
end;

function TAI.BoardVal(Board: TObjectArray): real;
var
  i, j, k: integer;
begin // sticking to basic each counter = +-1
  k := 0;
  for i := Low(Board) to High(Board) do
  begin
    for j := Low(Board[i]) to High(Board[i]) do
      if Board[i, j].GetColour = AIColour then
        inc(k)
      else
        dec(k);
  end;
  result := k;
end;

constructor TAI.Create(ADifficulty: integer; AAIColour: boolean);
begin
  case ADifficulty of
    0:
      MaxDepth := 1;
    1:
      MaxDepth := 2;
    2:
      MaxDepth := 3;
  end;
  AIColour := AAIColour;
end;

function TAI.ManualDepth(ADepth: integer): boolean;
begin
  if ADepth > 0 then
    MaxDepth := ADepth;
  result := true;
end;

function TAI.Max(a, b: TObjectArray): TObjectArray;
var
  i, j: integer;
  n: boolean;
begin
  n := true;
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        if assigned(a[i, j]) then
          n := false;
    end;
  if n then
    result := b;
  n := true;
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        if assigned(b[i, j]) then
          n := false;
    end;
  if n then
    result := a
  else
  begin
    if BoardVal(a) > BoardVal(b) then
      result := a;
    if BoardVal(b) > BoardVal(a) then
      result := b;
    if BoardVal(a) = BoardVal(b) then
      result := a;
  end;
end;

function TAI.Min(a, b: TObjectArray): TObjectArray;
var
  i, j: integer;
  n: boolean;
begin
  n := true;
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        if assigned(a[i, j]) then
          n := false;
    end;
  if n then
    result := b;
  n := true;
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        if assigned(b[i, j]) then
          n := false;
    end;
  if n then
    result := a
  else
  begin
    if BoardVal(a) < BoardVal(b) then
      result := a;
    if BoardVal(b) < BoardVal(a) then
      result := b;
    if BoardVal(a) = BoardVal(b) then
      result := a;
  end;
end;

function TAI.Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer)
  : TObjectArray;
var
  b: TObjectArray;
  CMove: TMove;
  i, j, k: integer;
  v: boolean;
begin
  CMove := TMove.Create();
  if Depth <> 0 then
  begin
    if MaxPlayer then
    begin
      for i := 0 to length(CMove.AllPossibleLegalMoves(Board, AIColour)) do
      begin
        b := Minimax(CMove.MakeMove(Board, CMove.AllPossibleLegalMoves(Board,
          AIColour)[i]), false, Depth - 1);
        BestValue := Max(BestValue, b);
        result := BestValue;
        if (Depth = MaxDepth - 1) then
          begin
            v := true;
            for j := Low(Board) to High(Board) do
              begin
                for k := Low(Board) to High(Board) do
                  begin
                    if BestValue[j, k] <> b[j, k] then
                      v := false;
                  end;
              end;
            if v then NextBoard := Board;
          end;
      end;
    end;
    if (not MaxPlayer) then
    begin
      for i := 0 to length(CMove.AllPossibleLegalMoves(Board, AIColour)) do
      begin
        b := Minimax(CMove.MakeMove(Board, CMove.AllPossibleLegalMoves(Board,
          AIColour)[i]), true, Depth - 1);
        BestValue := Min(BestValue, b);
        result := BestValue;
        if (Depth = MaxDepth - 1) then
          begin
            v := true;
            for j := Low(Board) to High(Board) do
              begin
                for k := Low(Board) to High(Board) do
                  begin
                    if BestValue[j, k] <> b[j, k] then
                      v := false;
                  end;
              end;
            if v then NextBoard := Board;
          end;
      end;
    end;
  end;
  CMove.Free;
end;

end.
