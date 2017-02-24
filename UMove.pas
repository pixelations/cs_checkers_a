unit UMove;

interface

uses
  UBoard;

type
  TCoordinate = array[0..1] of integer;
  TMoveVector = array[0..1] of TCoordinate;
  TMoveList = Array of TMoveVector;
  TMove = class(TObject)
    public
      constructor Create();
      function MakeMove(Board: TArray; Move: TMoveVector): TArray;
      function CheckLegalMove(Board: TArray; Move: TMoveVector): Boolean;
      function PossibleLegalMoves(Board: TArray; Pos: TCoordinate): TMoveList;
      function AllPossibleLegalMoves(Board: TArray; Player: Boolean): TArrayList;
  end;

implementation


{ TMove }

constructor TMove.Create;
begin
end;

function TMove.MakeMove(Board: TArray; Move: TMoveVector): TArray;
var
  i, j: integer;
begin
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        begin
          result[i, j] := Board[i, j];
        end;
    end;
  result[Move[0, 0], Move[0, 1]] := -1;
  result[Move[1, 0], Move[1, 1]] := Board[Move[0, 0], Move[0, 1]];
end;

function TMove.AllPossibleLegalMoves(Board: TArray;
  Player: Boolean): TArrayList;
var
  i, j, k: integer;
  p: TCoordinate;
  t: TMoveList;
  CBoard: TBoard;
begin
  setlength(result, 0);
  CBoard := TBoard.Create;
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        begin
          if CBoard.WhatPlayer(i, j, Board) = Player then
            begin
              p[0] := i;
              p[1] := j;
              t := PossibleLegalMoves(Board, p);
              for k := Low(t) to High(t) do
                begin
                  setlength(result, length(result) + 1);
                  result[length(result) - 1] := MakeMove(Board, t[k]);
                end;
            end;
        end;
    end;
  CBoard.Free
end;

function TMove.CheckLegalMove(Board: TArray; Move: TMoveVector): Boolean;
var
  CBoard: TBoard;
begin
  CBoard := TBoard.Create;
  if (not (Move[1, 0] < 0)) and (not (Move[1, 0] > 8)) and   //not out of bounds
      (not (Move[1, 1] < 0)) and not (Move[1, 1] > 8) then
    begin
      if Board[Move[1, 0], Move[1, 1]] <> -1 then
        begin
          if abs(Move[0, 0] - Move[1, 0]) = abs(Move[0, 1] - Move[1, 1]) then
            begin                                                        //is diagonal
              if (CBoard.WhatPlayer(Move[0, 0], Move[0, 1], Board) and ((Move[1, 1] - Move[0, 1]) > 0))
              xor ((not CBoard.WhatPlayer(Move[0, 0], Move[0, 1], Board)) and
              ((Move[1, 1] - Move[0, 1]) < 0 )) then
                //to move in correct direction, based on checker colour
                begin
                  if abs(Move[0, 0] - Move[1, 0]) = 2 then
                    begin
                      if CBoard.WhatPlayer(((Move[0, 0] + Move[1, 0]) div 2),
                      ((Move[0, 1] + Move[1, 1]) div 2), Board) <> CBoard.WhatPlayer(Move[0, 0], Move[0, 1], Board) then
                      //checks for checker inbetween a 2 space move
                        result := true;
                    end
                  else
                        result := true;
                end
              else
                result := false;
            end
          else
            result := false;
        end
      else
        result := false;
    end
  else
    result := false;
  CBoard.Free;
end;

function TMove.PossibleLegalMoves(Board: TArray;
  Pos: TCoordinate): TMoveList;
var
  i: integer;
  t: TMoveVector;
begin
  if Board[Pos[0], Pos[1]] <> -1 then
   begin
      t[0, 0] := Pos[0];
      t[0, 1] := Pos[1];
      setlength(result, 8);
      i := -1;
          t[1, 0] := Pos[0] + 1;
          t[1, 1] := Pos[1] + 1;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[1, 0] := Pos[0] + 1;
          t[1, 1] := Pos[1] - 1;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[1, 0] := Pos[0] - 1;
          t[1, 1] := Pos[1] + 1;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;;

          t[1, 0] := Pos[0] - 1;
          t[1, 1] := Pos[1] - 1;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[1, 0] := Pos[0] + 2;
          t[1, 1] := Pos[1] + 2;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[1, 0] := Pos[0] + 2;
          t[1, 1] := Pos[1] - 2;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[1, 0] := Pos[0] - 2;
          t[1, 1] := Pos[1] + 2;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[1, 0] := Pos[0] - 2;
          t[1, 1] := Pos[1] - 2;
          if CheckLegalMove(Board, t) then
            begin
              inc(i);
              result[i] := t;
            end;

            setlength(result, i + 1);
   end;
end;

end.
