unit UBoard;

interface

type
  TBoard = class(TObject)
    private
      Columns   : integer;
      XRows     : integer;
      YRows     : integer;
      Counters  : integer;
    function GetRows: integer;
    public
      constructor Create(ACol, AXRow, AYRow, ACount : integer);
        { initialise variables }
      function GetXRows(): integer;
      function GetYRows(): integer;
        { "get rows" returns number of rows }
      function GetColumns(var Columns): integer;
        { "get columns" returns number of columns }
      function GetCounters(var Counters): integer;
        { "get counters" returns number of counters }
      function Init3DArray(var Board): boolean;
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
  result := Counters;
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
  i : integer;
  j: Integer;
begin
  setlength(Board, Columns);
  for i := 0 to Columns do
  begin
    setlength(Board[i], XRows);
    for j := 0 to XRows do
      setlength(Board[i,j], YRows);
  end;
end;

end.
