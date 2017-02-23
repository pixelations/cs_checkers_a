unit UBoard;

interface

type
  TCoordinate = array[0..1] of integer;
  TCounter = class(TObject)
    private
      Colour: boolean;
      Promoted: boolean;
    public
      constructor Create(AColour, APromoted: boolean);
        { initialises variables }
      function GetColour(): boolean;
        { returns colour of the counter }
      function IsPromoted(): boolean;
        { returns boolean dependent on if the counter is promoted }
      function PromoteCounter(): boolean;
        { changes promoted value of the counter }
  end;
  TObjectArray = array[0..7] of array[0..7] of TCounter;
  TBoard = class(TObject)
    private
    public
      constructor Create();
        { initialises variables }
      function GetCounters(Board: TObjectArray): integer;
        { returns number of counters }
      function InitDraughts(var Board: TObjectArray): boolean;
        { places counters in a checkered pattern, with centre rows empty }
      function AddCounter(ARow, ACol: integer; ACounter: TCounter; Board: TObjectArray): boolean;
        { places a counter on selected tile of the board }
      function RemoveCounter(ARow, ACol: integer; Board: TObjectArray): boolean;
        { removes a counter on selected tile of the board }
      function ClearBoard(Board: TObjectArray): boolean;
        { Removes all counters from the board }
  end;

implementation

{ TBoard }

constructor TBoard.Create();
begin
end;

function TBoard.GetCounters(Board: TObjectArray): integer;
var
  i, j, t: Integer;
begin
  t := 0;
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
      begin
        if Board[i, j] <> nil then
          inc(t);          //variable t stores the number of counters on the board
      end;
  end;

  result := t;
end;

function TBoard.InitDraughts(var Board:TObjectArray): boolean;
var
  i, j: integer;
  t, z: boolean;
begin
  z := false;   // inital state
  t := true;

  for i := 0 to 7 do
    begin
    //does not populate middle rows
      if (i <> 3) and (i <> 4) then
        begin
          for j := 0 to 7 do
            begin
              if z then
                begin
                  case i mod 2 of
                    0: begin
                         Board[i, j] := TCounter.Create(t, false);
                      end;
                    1: begin
                         Board[i, 7 - j] := TCounter.Create(t, false);
                      end;
                  end;
                end;
              z := not z;
            end;
        end
      else
        if (i = 3) or (i = 4) then
          t := false;    // t = false for opponent
      end;

  result := true;

end;

function TBoard.AddCounter(ARow, ACol: integer; ACounter: TCounter; Board: TObjectArray): boolean;
begin
  Board[ARow, ACol] := ACounter;
  result := true;
end;

function TBoard.RemoveCounter(ARow, ACol: integer; Board: TObjectArray): boolean;
begin
  Board[ARow, ACol].Free;
  Board[ARow, ACol] := nil;
  result := true;
end;

function TBoard.ClearBoard(Board: TObjectArray): boolean;
var
  i: Integer;
  j: Integer;
begin
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        RemoveCounter(i, j, Board);
    end;
  result := true;
end;

{ TCounter }

constructor TCounter.Create(AColour, APromoted: boolean);
begin
  Colour := AColour;
  Promoted := APromoted;
end;

function TCounter.GetColour(): boolean;
begin
  result := Colour;
end;

function TCounter.IsPromoted(): boolean;
begin
  result := Promoted;
end;

function TCounter.PromoteCounter: boolean;
begin
  Promoted := true;
  result := true;
end;

end.
