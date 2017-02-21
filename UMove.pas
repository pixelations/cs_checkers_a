unit UMove;

interface

uses
  UBoard;

type
  TMoveVector = array[0..1] of TCoordinate;
  TMoveList = Array of TMoveVector;
  TMove = class
    private

    public
      function CheckLegalMove(Board: TObjectArray; Move: TMoveVector): Boolean;
      function PossibleLegalMoves(Board: TObjectArray; Pos: TCoordinate): TMoveList;
  end;

implementation


{ TMove }

function TMove.CheckLegalMove(Board: TObjectArray; Move: TMoveVector): Boolean;
begin
  if not assigned(Board[Move[1, 0], Move[1, 1]]) then
    begin
      if (not (Move[1, 0] < 0)) and (not (Move[1, 0] > 8)) and   //not out of bounds
      (not (Move[1, 1] < 0)) and not (Move[1, 1] > 8) then
        begin
          if abs(Move[0, 0] - Move[1, 0]) = abs(Move[0, 1] - Move[1, 1]) then
            begin                                        //is diagonal
              if abs(Move[0, 0] - Move[1, 0]) = 2 then
                begin
                  if assigned(Board[(Move[0, 0] + Move[1, 0])/2,
                  (Move[0, 1] + Move[1, 1])/2]) then
                    result := true;

                    //for non AI you still need to check if moving backwards unpromoted
                    //and implement 11 -11 1-1 -1-1 move result
                end;
            end;
        end;
    end
  else
    result := false;
end;

function TMove.PossibleLegalMoves(Board: TObjectArray;
  Pos: TCoordinate): TMoveList;
var
  i, j, k: integer;
  t: TMoveVector;
begin
  if assigned(Board[Pos[0], Pos[1]]) then
    begin
      t[0, 0] := Pos[0];
      t[0, 1] := Pos[1];
      if not Board[Pos[0], Pos[1]].IsPromoted then
        begin
          setlength(result, 4);
          k := 4;
          if Board[Pos[0], Pos[1]].GetColour then
            begin
              t[1, 0] := Pos[0] + 1;
              t[1, 1] := Pos[1] + 1;
              if CheckLegalMove(Board, t) then
                result[0] := t
              else dec(k);

              t[1, 0] := Pos[0] - 1;
              t[1, 1] := Pos[1] + 1;
              if CheckLegalMove(Board, t) then
                result[1] := t
              else dec(k);

              t[1, 0] := Pos[0] + 2;
              t[1, 1] := Pos[1] + 2;
              if CheckLegalMove(Board, t) then
                result[2] := t
              else dec(k);

              t[1, 0] := Pos[0] - 2;
              t[1, 1] := Pos[1] + 2;
              if CheckLegalMove(Board, t) then
                result[3] := t
              else dec(k);

            setlength(result, k);
            end
          else
            begin
              t[1, 0] := Pos[0] - 1;
              t[1, 1] := Pos[1] - 1;
              if CheckLegalMove(Board, t) then
                result[0] := t
              else dec(k);

              t[1, 0] := Pos[0] + 1;
              t[1, 1] := Pos[1] - 1;
              if CheckLegalMove(Board, t) then
                result[1] := t
              else dec(k);

              t[1, 0] := Pos[0] - 2;
              t[1, 1] := Pos[1] - 2;
              if CheckLegalMove(Board, t) then
                result[2] := t
              else dec(k);

              t[1, 0] := Pos[0] + 2;
              t[1, 1] := Pos[1] - 2;
              if CheckLegalMove(Board, t) then
                result[3] := t
              else dec(k);

            setlength(result, k);
            end;
        end
      else
        begin
          setlength(result, 8);
          k := 8;
          t[1, 0] := Pos[0] + 1;
          t[1, 1] := Pos[1] + 1;
          if CheckLegalMove(Board, t) then
          result[0] := t
          else dec(k);

          t[1, 0] := Pos[0] + 1;
          t[1, 1] := Pos[1] - 1;
          if CheckLegalMove(Board, t) then
            result[1] := t
          else dec(k);

          t[1, 0] := Pos[0] - 1;
          t[1, 1] := Pos[1] + 1;
          if CheckLegalMove(Board, t) then
            result[1] := t
          else dec(k);

          t[1, 0] := Pos[0] - 1;
          t[1, 1] := Pos[1] - 1;
          if CheckLegalMove(Board, t) then
            result[0] := t
          else dec(k);

          t[1, 0] := Pos[0] + 2;
          t[1, 1] := Pos[1] + 2;
          if CheckLegalMove(Board, t) then
            result[2] := t
          else dec(k);

          t[1, 0] := Pos[0] + 2;
          t[1, 1] := Pos[1] - 2;
          if CheckLegalMove(Board, t) then
            result[3] := t
          else dec(k);

          t[1, 0] := Pos[0] - 2;
          t[1, 1] := Pos[1] + 2;
          if CheckLegalMove(Board, t) then
            result[3] := t
          else dec(k);

          t[1, 0] := Pos[0] - 2;
          t[1, 1] := Pos[1] - 2;
          if CheckLegalMove(Board, t) then
            result[2] := t
          else dec(k);

          setlength(result, k);
        end;
    end
  else
    setlength(result, 0);
end;

end.
