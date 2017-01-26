unit UBoard;

interface

type
  TCoordinate = array[0..1] of integer;
  TCounter = class(TObject)
    private
      XPos: integer;
      YPos: integer;
      Colour: boolean;
      Promoted: boolean;
    public
      constructor Create(YPosition, XPosition: integer; CColour: boolean);
      function GetPos(): TCoordinate;
      function GetColour(): boolean;
      function IsPromoted(): boolean;
      function ChangePos(NewY, NewX: integer): boolean;
      function PromoteCounter(): boolean;
  end;
  TObjectArray = array of array of TCounter;
  TBoard = class(TObject)
    private
      Columns: integer;
      Rows: integer;
    public
      constructor Create(ACol, ARow: integer);
        { initialise variables }
      function GetRows(): integer;
        { returns number of rows }
      function GetColumns(): integer;
        { returns number of columns }
      function GetCounters(Board: TObjectArray): integer;
        { returns number of counters }
      function InitArray(var Board: TObjectArray): boolean;
        { initialises an array }
      function InitDraughts(Board: TObjectArray): boolean;
        { places counters in a checkered pattern, with centre rows empty }
      function AddCounter(ARow, ACol: integer; AColour: boolean): TCounter;
        { places a counter on selected tile of the board }
      function RemoveCounter(ARow, ACol: integer; Board: TObjectArray): boolean;
        { removes a counter on selected tile of the board }
      function ClearBoard(Board: TObjectArray): boolean;////do thuis
      {
      Other possibilities:
        function
          free all counters on the board
          //if implementing keyboard controls
          move counter
          //for select and move
          select/deselect counter
          //would enter a sub-routine that hights the cell?
          place counter
      }
  end;

implementation

{ TBoard }

constructor TBoard.Create(ACol, ARow: integer);
begin
  Columns := ACol - 1;       //converts from "counting numbers" to 0, 1, 2, 3..
  Rows := ARow - 1;
end;

function TBoard.GetColumns(): integer;
begin
  result := Columns + 1;
end;

function TBoard.GetCounters(Board: TObjectArray): integer;
var
  i, j, t: Integer;
begin
  t := 0;
  for i := 0 to Rows do
  begin
    for j := 0 to Columns do
      begin
        if Board[i, j] <> nil then
          inc(t);          //variable t stores the number of counters on the board
      end;
  end;

  result := t;
end;

function TBoard.GetRows(): integer;
begin
  result := Rows + 1;
end;

function TBoard.InitArray(var Board:TObjectArray): boolean;
var
  i: integer;
begin
  setlength(Board, Rows + 1);        //first dimension is length XRows
  for i := 0 to Rows do
    setlength(Board[i], Columns + 1);     //second dimension is length Columns
  result := true;
end;

function TBoard.InitDraughts(Board:TObjectArray): boolean;
var
  i, j: integer;
  z, t: boolean;
begin
  z := false;   // inital state
  t := true;
  if (Columns = Rows) and (Columns mod 2 = 1) then
  begin                                //if board has equal sides, that are even
    for i := 0 to Rows do
      begin
        //does not populate middle rows
        if (i <> Rows div 2) and (i <> (Rows div 2) + 1) then
          begin
            for j := 0 to Columns do
              begin
                if z and (i mod 2 = 0) then
                  Board[i, j] := AddCounter(i, j, t) // t = false for opponent
                else if z then
                  Board[i, Columns - j] := AddCounter(i, j, t);
                z := not z;
              end;
          end else
            t := false;
      end;



  end;
  result := true;
end;

function TBoard.AddCounter(ARow, ACol: integer; AColour: boolean): TCounter;
var
  ACounter: TCounter;
begin
  ACounter := TCounter.Create(ARow, ACol, AColour);
  result := ACounter;
end;

function TBoard.RemoveCounter(ARow, ACol: integer;
  Board: TObjectArray): boolean;
begin
  Board[ARow, ACol].Free;
  Board[ARow, ACol] := nil;
end;

{ TCounter }

constructor TCounter.Create(YPosition, XPosition: integer; CColour: boolean);
begin
  YPos := YPosition;
  XPos := XPosition;
  Colour := CColour;
end;

function TCounter.ChangePos(NewY, NewX: integer): boolean;
begin
  YPos := NewY;
  XPos := NewX;
  result := true;
end;

function TCounter.GetColour(): boolean;
begin
  result := Colour;
end;

function TCounter.GetPos(): TCoordinate;
begin
  result[0] := YPos;
  result[1] := XPos;
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
