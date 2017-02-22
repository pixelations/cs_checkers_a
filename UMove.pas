unit UMove;

interface

uses
  UBoard;

type
  TMoveVector = array[0..1] of TCoordinate;
  TMoveList = Array of TMoveVector;
  TMove = class
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
  t: TCounter;
  CBoard: TBoard;
begin
  t := Board[Move[0, 0], Move[0, 1]];
  result := Board;
  CBoard.Create(8, 8);
  CBoard.RemoveCounter(Move[0, 0], Move[0, 1], result);
  CBoard.AddCounter(Move[1, 0], Move[1, 1], t, result);
  CBoard.Free;
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
          if Board[i, j].GetColour = PlayerColour then
            begin
              p[0] := i;
              p[1] := j;
              ml := PossibleLegalMoves(Board, p);
              for k := Low(ml) to High(ml) do
                begin
                  setlength(result, length(result) + 1);
                  result[length(result) - 1] = ml[k];
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
              if (Board[Move[0, 0], Move[0, 1]].GetColour and (Move[1, 1] - Move[0, 1]) > 0)
              xor ((not Board[Move[0, 0], Move[0, 1]].GetColour) and
              (Move[1, 1] - Move[0, 1]) < 0 ) then
                //to move in correct dircetion, based on checker colour
                begin
                  if abs(Move[0, 0] - Move[1, 0]) = 2 then
                    begin
                      if assigned(Board[(Move[0, 0] + Move[1, 0])/2,
                      (Move[0, 1] + Move[1, 1])/2]) then
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
