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
      function Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer):
       TObjectArray;
      function Max(a, b: TObjectArray): TObjectArray;
      function Min(a, b: TObjectArray): TObjectArray;
      function BoardVal(Board: TObjectArray): real;
      function AIMove(Board:TObjectArray): TObjectArray;
  end;

implementation

{ TAI }

function TAI.AIMove(Board: TObjectArray): TObjectArray;
begin
  Minimax(Board, true, MaxDepth);
  result := NextBoard;
  NextBoard := nil;
  BestValue := nil;
end;

function TAI.BoardVal(Board: TObjectArray): real;
var
  i, j: integer;
begin  //sticking to basic each counter = +-1
  result := 0;
  for i := Low(Board) to High(Board) do
    begin
      for j := Low(Board[i]) to High(Board[i]) do
        if Board[i, j].GetColour = AIColour then
          inc(result)
        else
          dec(result);
    end;
end;
constructor TAI.Create(ADifficulty: integer;  AAIColour: boolean);
begin
  case ADifficulty of
    0: MaxDepth := 1;
    1: MaxDepth := 2;
    2: MaxDepth := 3;
  end;
  AIColour := AAIColour;
  BestValue := nil;
end;

function TAI.ManualDepth(ADepth: integer): boolean;
begin
  if ADepth > 0 then
    MaxDepth := ADepth;
  result := true;
end;

function TAI.Max(a, b: TObjectArray): TObjectArray;
begin
  if a = nil then result := b
  else
    if b = nil then result := a
    else
      begin
        case True of
          BoardVal(a) > BoardVal(b): result := a;
          BoardVal(b) > BoardVal(a): result := b;
          BoardVal(a) = BoardVal(b): result := a;
        end;
      end;
end;

function TAI.Min(a, b: TObjectArray): TObjectArray;
begin
  if a = nil then result := b
  else
    if b = nil then result := a
    else
      begin
        case True of
          BoardVal(a) < BoardVal(b): result := a;
          BoardVal(b) < BoardVal(a): result := b;
          BoardVal(a) = BoardVal(b): result := a;
        end;
      end;
end;

function TAI.Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer):
 TObjectArray;
var
  b: integer;
  CMove: TMove;
  i: TMoveVector;
begin
  CMove := TMove.Create();
  if Depth <> 0 then
    begin
      if MaxPlayer then
        begin
        for i := Low(CMove.AllPossibleLegalMoves(Board, AIColour)) to
        High(CMove.AllPossibleLegalMoves(Board, AIColour)) do
          begin
            b := Minimax(CMove.MakeMove(Board, i), false, Depth - 1);
            BestValue := Max(BestValue, b);
            result := BestValue;
            if (b = BestValue) and (Depth = MaxDepth - 1) then
              NextBoard := Board;
          end;
        end;
      if (not MaxPlayer) then
        begin
        for i := Low(CMove.AllPossibleLegalMoves(Board, AIColour)) to
        High(CMove.AllPossibleLegalMoves(Board, AIColour)) do
          begin
            b := Minimax(CMove.MakeMove(Board, i), true, Depth - 1);
            BestValue := Min(BestValue, b);
            result := BestValue;
            if (b = BestValue) and (Depth = MaxDepth - 1) then
              NextBoard := Board;
          end;
        end;
    end;
  CMove.Free;
end;

end.
