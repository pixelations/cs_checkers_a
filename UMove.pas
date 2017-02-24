unit UMove;

interface

uses
  UBoard;

type
  TCoordinate = array[0..1] of integer;
  TCoordArray = Array of TCoordinate;
  TMove = class(TObject)
  public
    constructor Create();
      function MakeMove(Board: TArray; NewRow, NewCol, OldRow, OldCol: integer): TArray;
      function CheckLegalMove(Board: TArray; NewRow, NewCol, OldRow, OldCol: integer): Boolean;
      function PossibleLegalMoves(Board: TArray; ARow, ACol: integer): TCoordArray;
      function AllPossibleLegalMoves(Board: TArray; Player: Boolean): TArrayList;
  end;

implementation


{ TMove }

constructor TMove.Create;
begin
end;

function TMove.MakeMove(Board: TArray; NewRow, NewCol, OldRow, OldCol: integer): TArray;
var
  i, j: integer;
begin
  result := Board;
  result[OldRow, OldCol] := -1;
  result[NewRow, NewCol] := Board[OldRow, OldCol];
end;


function TMove.AllPossibleLegalMoves(Board: TArray;
  Player: Boolean): TArrayList;
var
  i, j, k: integer;
  t: TCoordArray;
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
              t := PossibleLegalMoves(Board, i, j);
              for k := Low(t) to High(t) do
                begin
                  setlength(result, length(result) + 1);
                  result[length(result) - 1] := MakeMove(Board, t[k, 0], t[k, 1], i, j);
                end;
            end;
        end;
    end;
  CBoard.Free
end;

function TMove.CheckLegalMove(Board: TArray; NewRow, NewCol, OldRow, OldCol: integer): Boolean;
var
  CBoard: TBoard;
begin
  CBoard := TBoard.Create;
  if (not (NewRow < 0)) and (not (NewRow > 8)) and   //not out of bounds
      (not (NewCol < 0)) and not (NewCol > 8) then
    begin
      if Board[NewRow, NewCol] <> -1 then
        begin
          if abs(NewRow - OldRow) = abs(NewCol - OldCol) then
            begin                                                        //is diagonal
              if (CBoard.WhatPlayer(OldRow, OldCol, Board) and ((NewRow - OldRow) > 0))
              xor ((not CBoard.WhatPlayer(OldRow, OldCol, Board)) and
              ((NewRow - OldRow) < 0 )) then
                //to move in correct direction, based on checker colour
                begin
                  if abs(OldRow - NewRow) = 2 then
                    begin
                      if CBoard.WhatPlayer(((OldRow + NewRow) div 2),
                      ((OldCol + NewCol) div 2), Board) <> CBoard.WhatPlayer(OldRow, OldCol, Board) then
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

function TMove.PossibleLegalMoves(Board: TArray; ARow, ACol: integer): TCoordArray;
var
  i: integer;
  t: TCoordinate;
begin
  if Board[ARow, ACol] <> -1 then
   begin
      setlength(result, 8);
      i := -1;
          t[0] := ARow + 1;
          t[1] := ACol + 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[0] := ARow + 1;
          t[1] := ACol - 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[0] := ARow - 1;
          t[1] := ACol + 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[0] := ARow - 1;
          t[1] := ACol - 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[0] := ARow + 2;
          t[1] := ACol + 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[0] := ARow + 2;
          t[1] := ACol - 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[0] := ARow - 2;
          t[1] := ACol + 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

          t[0] := ARow - 2;
          t[1] := ACol - 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              inc(i);
              result[i] := t;
            end;

            setlength(result, i + 1);
   end;
end;

end.
