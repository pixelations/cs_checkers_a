unit UMove;

interface

uses
  UBoard;

type
  TMoveVector = array[0..1] of TCoordinate;
  TMoveList = Array of TMoveVector;
  TMove = class(TObject)
    public
      constructor Create();
      function MakeMove(Board: TObjectArray; Move: TMoveVector): TObjectArray;
      function CheckLegalMove(Board: TObjectArray; Move: TMoveVector): Boolean;
      function PossibleLegalMoves(Board: TObjectArray; Pos: TCoordinate): TMoveList;
      function AllPossibleLegalMoves(Board: TObjectArray; PlayerColour: Boolean): TMoveList;
  end;

implementation


{ TMove }

constructor TMove.Create;
begin
end;

function TMove.MakeMove(Board: TObjectArray; Move: TMoveVector): TObjectArray;
var
  i, j: integer;
  t: TObjectArray;
  //CBoard: TBoard;
begin
  //t := Board[Move[0, 0], Move[0, 1]];
  for i := Low(t) to High(t) do
    begin
      for j := Low(t[i]) to High(t[i]) do
        t[i, j] := Board[i, j];
    end;
  //CBoard.Create();
  //CBoard.RemoveCounter(Move[0, 0], Move[0, 1], t);
  //CBoard.AddCounter(Move[1, 0], Move[1, 1], Board[Move[0, 0], Move[0, 1]], result);
  t[Move[0, 0], Move[0, 1]] := nil;
  t[Move[1, 0], Move[1, 1]] := Board[Move[0, 0], Move[0, 1]];
  for i := Low(t) to High(t) do
    begin
      for j := Low(t[i]) to High(t[i]) do
        result[i, j] := t[i, j];
    end;
  //CBoard.Free;
end;

function TMove.AllPossibleLegalMoves(Board: TObjectArray;
  PlayerColour: Boolean): TMoveList;
var
  i, j, k: integer;
  p: TCoordinate;
  ml: TMoveList;
begin
  setlength(result, 0);
  setlength(ml, 8);
  for i := Low(Board) to High(Board) do
    begin
      for j := Low(Board[i]) to High(Board[i]) do
        begin
          if assigned(Board[i, j]) then
            begin
              if (Board[i, j].GetColour = PlayerColour) then
                begin
                  p[0] := i;
                  p[1] := j;
                  ml := PossibleLegalMoves(Board, p);
                  for k := Low(ml) to High(ml) do
                    begin
                      setlength(result, length(result) + 1);
                      result[length(result) - 1] := ml[k];
                    end;
                end;
            end;
        end;
    end;
end;

function TMove.CheckLegalMove(Board: TObjectArray; Move: TMoveVector): Boolean;
begin
  if (not (Move[1, 0] < 0)) and (not (Move[1, 0] > 8)) and   //not out of bounds
      (not (Move[1, 1] < 0)) and not (Move[1, 1] > 8) then
    begin
      if not assigned(Board[Move[1, 0], Move[1, 1]]) then
        begin
          if abs(Move[0, 0] - Move[1, 0]) = abs(Move[0, 1] - Move[1, 1]) then
            begin                                                        //is diagonal
              if (Board[Move[0, 0], Move[0, 1]].GetColour and ((Move[1, 1] - Move[0, 1]) > 0))
              xor ((not Board[Move[0, 0], Move[0, 1]].GetColour) and
              ((Move[1, 1] - Move[0, 1]) < 0 )) then
                //to move in correct dircetion, based on checker colour
                begin
                  if abs(Move[0, 0] - Move[1, 0]) = 2 then
                    begin
                      if assigned(Board[((Move[0, 0] + Move[1, 0]) div 2),
                      ((Move[0, 1] + Move[1, 1]) div 2)]) then
                      //checks for checker inbetween a 2 space move
                        result := true;
                    end
                  else
                    if abs(Move[0, 0] - Move[1, 0]) = 1 then
                      begin
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
    end
  else
    result := false;
end;

function TMove.PossibleLegalMoves(Board: TObjectArray;
  Pos: TCoordinate): TMoveList;
var
  i: integer;
  t: TMoveVector;
begin
  if assigned(Board[Pos[0], Pos[1]]) then
    begin
      t[0, 0] := Pos[0];
      t[0, 1] := Pos[1];
      setlength(result, 8);
      i := -1;
      if not Board[Pos[0], Pos[1]].IsPromoted then
        begin
          if Board[Pos[0], Pos[1]].GetColour then
            begin
              t[1, 0] := Pos[0] + 1;
              t[1, 1] := Pos[1] + 1;
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
              end;

              t[1, 0] := Pos[0] + 2;
              t[1, 1] := Pos[1] + 2;
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

              setlength(result, i + 1);
            end
          else
            begin
              t[1, 0] := Pos[0] - 1;
              t[1, 1] := Pos[1] - 1;
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

              t[1, 0] := Pos[0] - 2;
              t[1, 1] := Pos[1] - 2;
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

              setlength(result, i + 1);
            end;
        end
      else
        begin
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
end;

end.
