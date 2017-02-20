unit UAI;

interface

uses
  UBoard, UMove, System.SysUtils;

type
  TAI = class(TObject)
    private
      MaxDepth: integer;
      AIColour: boolean;
    public
      constructor Create(ADifficulty: string; AAIColour: boolean);
      function ManualDepth(ADepth: integer): boolean;
      function Minimax(Board: TObjectArray): TMove;
      function Max(a, b: real): real;
      function Min(a, b: real): real;
      function BoardVal(Board: TObjectArray): real;

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
begin
  //sticking to basic each counter = +-1
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

function TAI.Minimax(Board: TObjectArray): TMove;
var
  Depth: integer;
begin
  Depth := MaxDepth;
  if Depth = 0 then     //this


end;

end.
