unit UBoard;

interface

type
  TArray = array[0..7] of array[0..7] of integer;
  TArrayList = array of TArray;
  TBoard = class(TObject)
    private
    public
      constructor Create();
        { initialises variables }
      function InitDraughts(var Board: TArray): boolean;
        { places counters in a checkered pattern, with centre rows empty }
      function AddCounter(ARow, ACol, PlayerVal: integer; Board: TArray): boolean;
        { places a counter on selected tile of the board }
      function RemoveCounter(ARow, ACol: integer; Board: TArray): boolean;
        { removes a counter on selected tile of the board }
      function ClearBoard(Board: TArray): boolean;
        { Removes all counters from the board }
      function WhatPlayer(ARow, ACol: integer; Board: TArray): boolean;
  end;

implementation

{ TBoard }

constructor TBoard.Create();
begin
end;

function TBoard.InitDraughts(var Board:TArray): boolean;
var
  i, j: integer;
  t, z: boolean;
begin
  z := false;   // inital state
  t := true;

  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        Board[i, j] := -1;
    end;

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
                        if t then
                          Board[i, j] := 1
                        else
                          Board[i, j] := 0;
                      end;
                    1: begin
                          if t then
                            Board[i, 7 - j] := 1
                          else
                            Board[i, 7 - j] := 0;
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

function TBoard.AddCounter(ARow, ACol, PlayerVal: integer; Board: TArray): boolean;
begin
  Board[ARow, ACol] := PlayerVal;
  result := true;
end;

function TBoard.RemoveCounter(ARow, ACol: integer; Board: TArray): boolean;
begin
  Board[ARow, ACol] := -1;
  result := true;
end;

function TBoard.WhatPlayer(ARow, ACol: integer; Board: TArray): boolean;
begin
if (Board[ARow, ACol] = 0) or (Board[ARow, ACol] = 2) then result := false;
if (Board[ARow, ACol] = 1) or (Board[ARow, ACol] = 3) then result := true;
end;

function TBoard.ClearBoard(Board: TArray): boolean;
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

end.
