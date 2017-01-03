unit UBoard;

interface

const
  COLUMNS = 8;
  ROWS = 8;
  COUNTERS = 24;

type
  TBoard = class(TObject)
    private
      rows      : integer;
      columns   : integer;
      counters  : integer;
    public
      constructor create(columns, rows, counters : integer);
        { initialise variables }
      function getrows(rows: integer): integer;
        { "get rows" returns number of rows }
      function getcolumns(columns: integer): integer;
        { "get columns" returns number of columns }
      function getcounters(counters: integer): integer;
        { "get counters" returns number of counters }
  end;


implementation

{ TBoard }

constructor TBoard.create(columns, rows, counters: integer);
begin
  columns := COLUMNS;
  rows := ROWS;
  counters := COUNTERS;
end;

function TBoard.getcolumns(columns: integer): integer;
begin
  result := columns;
end;

function TBoard.getcounters(counters: integer): integer;
begin
  result := counters;
end;

function TBoard.getrows(rows: integer): integer;
begin
  result := rows;
end;

end.
