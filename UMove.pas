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
      function MakeMove(Board: TArray; NewRow, NewCol, OldRow, OldCol: integer)
      : TArray;
        { moves a counter from one cell to another }
      function CheckLegalMove(Board: TArray; NewRow, NewCol, OldRow,
       OldCol: integer): Boolean;
        { checks the move agianst the ruleset }
      function PossibleLegalMoves(Board: TArray; ARow, ACol: integer):
       TCoordArray;
        { list the result coordinates of legal moves from a given coordinate }
      function AllPossibleLegalMoves(Board: TArray; Player: Boolean):
       TArrayList;
        { uses PossibleLegalMoves to output all boards that a player can do }
  end;

implementation

const
  C_P1 = 0;     //P1 counter
  C_P1_P = 2;   //promoted P1 counter
  C_AI = 1;     //AI counter
  C_AI_P = 3;   //promoted AI counter
  NC = -1;      //no counter

{ TMove }

constructor TMove.Create;
begin
end;

function TMove.MakeMove(Board: TArray; NewRow, NewCol, OldRow, OldCol: integer):
 TArray;
var
  CBoard: TBoard;
begin
  result := Board;
  if abs(NewCol - OldCol) = 2 then      //removes piece that is taken by player
    result[((OldRow + NewRow) div 2), ((OldCol + NewCol) div 2)] := NC;
  result[NewRow, NewCol] := result[OldRow, OldCol];
  result[OldRow, OldCol] := NC;

  //for counter promotion
  CBoard := TBoard.Create;
  if ((CBoard.WhatPlayer(NewRow, NewCol, result)) and (NewRow = 7)) then
    result[NewRow, NewCol] := C_AI_P;
  if (not ((CBoard.WhatPlayer(NewRow, NewCol, result))) and (NewRow = 0)) then
    result[NewRow, NewCol] := C_P1_P;
  CBoard.Free;
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
          //for every player counter it will output the resultant moves
          //each counter can do
          if CBoard.WhatPlayer(i, j, Board) = Player then
            begin
              t := PossibleLegalMoves(Board, i, j);
              for k := Low(t) to High(t) do
                begin
                  setlength(result, length(result) + 1);
                  result[length(result) - 1] := MakeMove(Board, t[k, 0],
                   t[k, 1], i, j);
                end;
            end;
        end;
    end;
  CBoard.Free
end;

function TMove.CheckLegalMove(Board: TArray; NewRow, NewCol, OldRow,
 OldCol: integer): Boolean;
var
  CBoard: TBoard;
begin
  result := false;
  CBoard := TBoard.Create;
  if (not (NewRow < 0)) and (not (NewRow > 7)) and   //not out of bounds
      (not (NewCol < 0)) and not (NewCol > 7) then
    begin
      if (Board[NewRow, NewCol] = NC) and (Board[OldRow, OldCol] <> NC) then
        begin
          if abs(NewRow - OldRow) = abs(NewCol - OldCol) then     //is diagonal
            begin
              // moves 1 or 2 spaces, but not both
              if (abs(OldRow - NewRow) = 1) xor (abs(OldRow - NewRow) = 2) then
                begin
                  if (CBoard.WhatPlayer(OldRow, OldCol, Board) and
                   ((NewRow - OldRow) > 0)) xor
                   ((not CBoard.WhatPlayer(OldRow, OldCol, Board)) and
                    ((NewRow - OldRow) < 0 )) then
                    //to move in correct direction, based on checker colour
                    begin
                      if abs(OldRow - NewRow) = 2 then
                        begin
                          if CBoard.WhatPlayer(((OldRow + NewRow) div 2),
                           ((OldCol + NewCol) div 2), Board)
                          <> CBoard.WhatPlayer(OldRow, OldCol, Board) then
                          //checks for checker inbetween a 2 space move
                              result := true;
                        end
                      else
                        result := true;
                    end
                  else
                    begin
                      if (Board[OldRow, OldCol] = C_AI_P) xor (Board[OldRow,
                       OldCol] = C_P1_P) then
                        //if promoted, no directional check
                        begin
                          if abs(OldRow - NewRow) = 2 then
                            begin
                              if CBoard.WhatPlayer(((OldRow + NewRow) div 2),
                               ((OldCol + NewCol) div 2), Board)
                              <> CBoard.WhatPlayer(OldRow, OldCol, Board) then
                              //checks for checker inbetween a 2 space move
                                result := true;
                            end
                          else
                            result := true;
                        end;
                    end;
                end;
            end;
        end;
    end;
  CBoard.Free;
end;

function TMove.PossibleLegalMoves(Board: TArray; ARow, ACol: integer):
 TCoordArray;
var
  i: integer;
  t: TCoordinate;
begin
  if Board[ARow, ACol] <> NC then
   begin
      setlength(result, 8);         //out of the 8 possible moves, the result
      i := 0;                       //is reduced down to the legal moves
          t[0] := ARow + 1;
          t[1] := ACol + 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          t[0] := ARow + 1;
          t[1] := ACol - 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          t[0] := ARow - 1;
          t[1] := ACol + 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          t[0] := ARow - 1;
          t[1] := ACol - 1;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          t[0] := ARow + 2;
          t[1] := ACol + 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          t[0] := ARow + 2;
          t[1] := ACol - 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          t[0] := ARow - 2;
          t[1] := ACol + 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          t[0] := ARow - 2;
          t[1] := ACol - 2;
          if CheckLegalMove(Board, t[0], t[1], ARow, ACol) then
            begin
              result[i] := t;
              inc(i);
            end;

          setlength(result, i);
   end;
end;

end.
