unit UBoard;

interface

type
  TBoard = class(TObject)
    private
      rows      : integer;
      columns   : integer;
      counters  : integer;
    public
      constructor create(columns, rows : integer);
        { initialise variables }
      function getrows(rows: integer): integer;
        { "get rows" returns number of rows }
      function getcolumns(columns: integer): integer;
        { "get columns" returns number of columns }
      function getcounters(counters: integer): integer;
        { "get counters" returns number of counters }
  end;


implementation

end.
