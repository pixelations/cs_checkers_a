unit UBoard;

interface

type
  TCubeArray = array of array of array of boolean;
  TBoard = class(TObject)
    private
      Columns   : integer;
      XRows     : integer;
      YRows     : integer;
    public
      constructor Create(ACol, AXRow, AYRow: integer);
        { initialise variables }
      function GetXRows(): integer;
      function GetYRows(): integer;
        { returns number of rows }
      function GetColumns(): integer;
        { returns number of columns }
      function GetCounters(var Board:TCubeArray): integer;
        { returns number of counters }
      function Init3DArray(var Board:TCubeArray): boolean;
        { initialises a 3D array }
      function InitDraughts(var Board:TCubeArray): boolean;
  end;


implementation

{ TBoard }

constructor TBoard.Create(ACol, AXRow, AYRow: integer);
begin
  Columns := ACol - 1;       //converts from "counting numbers" to 0, 1, 2, 3..
  XRows := AXRow - 1;
  YRows := AYRow - 1;
end;

function TBoard.GetColumns(): integer;
begin
  result := Columns + 1;
end;

function TBoard.GetCounters(var Board:TCubeArray): integer;
var
  i, j, t: Integer;
begin
  t := 0;
  for i := 0 to XRows do
  begin
    for j := 0 to Columns do
    begin
      if Board[i, j, 0] = true then
        inc(t);          //variable t stores the number of checkers on the board
    end;
  end;

  result := t;
end;

function TBoard.GetXRows(): integer;
begin
  result := XRows + 1;
end;

function TBoard.GetYRows(): integer;
begin
  result := YRows + 1;
end;

function TBoard.Init3DArray(var Board:TCubeArray): boolean;
var
  i, j, k  : integer;
begin
  setlength(Board, XRows + 1);        //first dimension is length XRows
  for i := 0 to XRows do
  begin
    setlength(Board[i], Columns + 1);     //second dimension is length Columns
    for j := 0 to Columns do
      setlength(Board[i,j], YRows); //third dimension is lenghth YRows
  end;

  for i := 0 to Columns do
  begin
    for j := 0 to XRows do
    begin
      for k := 0 to YRows do
        Board[i, j, k] := false;   //sets all the values in the array to false
    end;
  end;

  result := true;
end;

function TBoard.InitDraughts(var Board:TCubeArray): boolean;
var
  i, j: integer;
  z: boolean;
begin
  z := false;   // inital state
  if (Columns = XRows) and ((Columns + 1) mod 2 = 0) then
  begin                                //if board has equal sides, that are even
    for i := 0 to ((XRows div 2) - 1) do //ignores the two rows down the center
      begin
        for j := 0 to Columns do
        begin
          if z and (i mod 2 = 0) then
          begin
            Board[i, j, 0] := true;         //places counter on board (true)
            Board[XRows - i, Columns - j, 0] := true; //places opponent's
          end else if z then
          begin
            Board[i, Columns - j, 0] := true;    //places counters by 'snaking'
            Board[XRows - i, Columns, 0] := true;
          end;
            //uses symmetry to place opponents checker
          z := not z;            //creates a checker-board pattern
        end;
      end;

  end;

end;

end.
