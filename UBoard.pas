unit UBoard;

interface

type
  TBoard = class(TObject)
    private
      Columns   : integer;
      XRows     : integer;
      YRows     : integer;
    public
      constructor Create(ACol, AXRow, AYRow, ACount : integer);
        { initialise variables }
      function GetXRows(): integer;
      function GetYRows(): integer;
        { returns number of rows }
      function GetColumns(var Columns): integer;
        { returns number of columns }
      function GetCounters(var Counters): integer;
        { returns number of counters }
      function Init3DArray(var Board): boolean;
        { initialises a 3D array }
      function InitDraughts(var Board): boolean;
  end;


implementation

{ TBoard }

constructor TBoard.Create(ACol, AXRow, AYRow, ACount : integer);
begin
  Columns := ACol;
  XRows := AXRow;
  YRows := AYRow;
  counters := ACount;
end;

function TBoard.GetColumns(): integer;
begin
  result := Columns;
end;

function TBoard.GetCounters(): integer;
begin
  //result := Counters;
end;

function TBoard.GetXRows(): integer;
begin
  result := XRows;
end;

function TBoard.GetYRows(): integer;
begin
  result := YRows;
end;

function TBoard.Init3DArray(var Board): boolean;
var
  i, j, k  : integer;
begin
  setlength(Board, Columns);        //first dimension is length Columns
  for i := 0 to Columns do
  begin
    setlength(Board[i], XRows);     //second dimension is length XRows
    for j := 0 to XRows do
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

function TBoard.InitDraughts(var Board): boolean;
var
  i: integer;
begin
  if (Columns = XRows) and (Columns mod 2 = 0) then
  begin
    {begin the starting checker position}
    for i := 0 to ((Columns div 2) - 1) do
      begin
        //start here next
      end;
  end;

end;

end.
