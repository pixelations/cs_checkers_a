unit UAI;

interface

uses
  UBoard, UMove, System.SysUtils;

type
  TMoveList = Array of  TObjectArray;
  TAI = class(TObject)
    private
      MaxDepth: integer;
      AIColour: boolean;
    public
      constructor Create(ADifficulty: string; AAIColour: boolean);
      function ManualDepth(ADepth: integer): boolean;
      function Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer):
       TObjectArray;
      function Max(a, b: real): real;
      function Min(a, b: real): real;
      function BoardVal(Board: TObjectArray): real;
      function PossibleLegalMoves(Board: TObjectArray): TMoveList;
  end;

const
  Random = 'RANDOM';
  Easy = 'EASY';
  Intermediate = 'INTERMEDIATE';
  Hard = 'HARD';

implementation

{ TAI }

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
constructor TAI.Create(ADifficulty: string;  AAIColour: boolean);
begin
  Uppercase(ADifficulty);
  case ADifficulty of
    Random: MaxDepth := 0;
    Easy: MaxDepth := 1;
    Intermediate: MaxDepth := 2;
    Hard: MaxDepth := 3;
  end;                            //add else case
  AIColour := AAIColour;
end;

function TAI.ManualDepth(ADepth: integer): boolean;
begin
  if ADepth > 0 then
    MaxDepth := ADepth;
  result := true;
end;

function TAI.Max(a, b: real): real;
begin
  case True of
    a > b: result := a;
    b > a: result := b;
    a = b: result := a;
  end;
end;

function TAI.Min(a, b: real): real;
begin
  case True of
    a < b: result := a;
    b < a: result := b;
    a = b: result := a;
  end;
end;

function TAI.Minimax(Board: TObjectArray; MaxPlayer: boolean; Depth: integer):
 TObjectArray;
var
  i, b: integer;
begin
  if Depth <> 0 then
    begin
      if MaxPlayer then                          ///////////////////////////////////
        begin
        // add in systematic legal move gen
        for {each legal move} do
          begin
          b := Minimax({move}, MaxPlayer, Depth - 1);
          if Depth - 1 <> 0 then
            result := Max(BoardVal(BestValue), BoardVal(b));
          end;
        end;
      if (not MaxPlayer) then
        begin
        for {each legal move} do
          begin
          b := Minimax({move}, MaxPlayer, Depth - 1);
          if Depth - 1 <> 0 then
            result := Min(BoardVal(BestValue), BoardVal(b));
          end;
        end;
    end;

end;

function TAI.PossibleLegalMoves(Board: TObjectArray): TMoveList;
var
  i, j: integer;
begin
  setlength(result, MaxDepth);
  for i := Low(result) to High(result) do
    setlength(Board[i], 8);//do this

  for i := Low(Board) to High(Board) do
    begin
      for j := Low(Board[i]) to High(Board[i]) do
        begin

        end;
    end;
end;

end.
