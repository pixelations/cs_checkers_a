unit UAI;

interface

uses
  System.SysUtils, UBoard, UMove;

type
  TAI = class
  private
    AIColour: boolean;

    BestValue: TObjectArray;
  public
    NextBoard: TObjectArray;
    MaxDepth: integer;
    constructor Create(ADifficulty: integer; AAIColour: boolean);
    function ManualDepth(ADepth: integer): boolean;
    function Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer)
      : TObjectArray;
    function Max(a, b: TObjectArray): TObjectArray;
    function Min(a, b: TObjectArray): TObjectArray;
    function BoardVal(Board: TObjectArray): real;
    //function AIMove(Board: TObjectArray): TObjectArray;
  end;

implementation

{ TAI }

{function TAI.AIMove(Board: TObjectArray): TObjectArray;
var
  i, j: integer;
begin
  Minimax(Board, true, MaxDepth);
  for i := Low(result) to High(result) do
    begin
      for j := Low(result) to High(result) do
        result[i, j] := NextBoard[i, j];
    end;

end;}

function TAI.BoardVal(Board: TObjectArray): real;
var
  i, j, k: integer;
begin // sticking to basic each counter = +-1
  k := 0;
  for i := Low(Board) to High(Board) do
  begin
    for j := Low(Board[i]) to High(Board[i]) do
      begin
        if assigned(Board[i, j]) then
          begin
            if Board[i, j].GetColour = AIColour then
              inc(k)
            else
              dec(k);
          end;
      end;
  end;
  result := k;
end;

constructor TAI.Create(ADifficulty: integer; AAIColour: boolean);
var
  i, j: integer;
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
  {for i := Low(BestValue) to High(BestValue) do
    begin
      for j := Low(BestValue[i]) to High(BestValue[i]) do
        begin
          BestValue[i, j] := nil;
        end;
    end;  }
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
          if BoardVal(a) > BoardVal(b) then
            begin
              for i := Low(a) to High(a) do
                begin
                  for j := Low(a[i]) to High(a[i]) do
                    result[i, j] := a[i, j];
                end;
            end
          else
          if BoardVal(b) > BoardVal(a) then
            begin
              for i := Low(b) to High(b) do
                begin
                  for j := Low(b[i]) to High(b[i]) do
                    result[i, j] := b[i, j];
                end;
            end
          else
          if BoardVal(a) = BoardVal(b) then
            begin
              for i := Low(a) to High(a) do
                begin
                  for j := Low(a[i]) to High(a[i]) do
                    result[i, j] := a[i, j];
                end;
            end;
end;

function TAI.Min(a, b: TObjectArray): TObjectArray;
var
  i, j: integer;
  n: boolean;
begin
          if BoardVal(a) < BoardVal(b) then
            begin
              for i := Low(a) to High(a) do
                begin
                  for j := Low(a[i]) to High(a[i]) do
                    result[i, j] := a[i, j];
                end;
            end
            else
          if BoardVal(b) < BoardVal(a) then
            begin
              for i := Low(b) to High(b) do
                begin
                  for j := Low(b[i]) to High(b[i]) do
                    result[i, j] := b[i, j];
                end;
            end
            else
          if BoardVal(a) = BoardVal(b) then
            begin
              for i := Low(a) to High(a) do
                begin
                  for j := Low(a[i]) to High(a[i]) do
                    result[i, j] := a[i, j];
                end;
            end;

end;

function TAI.Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer)
  : TObjectArray;
var
  b, c: TObjectArray;
  CMove: TMove;
  CCounter: TCounter;
  t: TMoveList;
  i, j, k: integer;
  v: boolean;
begin
  CMove := TMove.Create();
  setlength(t, length(CMove.AllPossibleLegalMoves(Board, AIColour)));
  for i := Low(t) to High(t) do
    t[i] := CMove.AllPossibleLegalMoves(Board, AIColour)[i];


  if Depth <> 0 then
  begin
    if MaxPlayer then
    begin

      if Depth = MaxDepth then
      begin
        CCounter := TCounter.Create(not AIColour, false);
        for i := 0 to 7 do
          begin
            for j := 0 to 7 do
              begin
                BestValue[i, j] := CCounter;
              end;
          end;
        CCounter.Free;
      end;

      for i := Low(t) to High(t)  do
      begin
        c := CMove.MakeMove(Board, t[i]);
        b := Minimax(c, false, Depth - 1);
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

      if Depth = MaxDepth then
      begin
        CCounter := TCounter.Create(AIColour, false);
        for i := 0 to 7 do
          begin
            for j := 0 to 7 do
              begin
                BestValue[i, j] := CCounter;
              end;
          end;
        CCounter.Free;
      end;

      for i := Low(t) to High(t) do
      begin
        c := CMove.MakeMove(Board, t[i]);
        b := Minimax(c, true, Depth - 1);
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
  end
  else result := Board;


  CMove.Free;
end;

end.
