unit UBoard;

interface

type
  TBoard = class(TObject)
    private
      rows      : integer;
      columns   : integer;
      counters  : integer;
      board     : array of array of integer;
    public
      constructor create(columns_, rows_, counters_ : integer);
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

constructor TBoard.create(columns_, rows_, counters_ : integer);
begin
  columns := columns_;
  rows := rows_;
  counters := counters_;

end;

function TBoard.getcolumns(): integer;
begin
  result := columns;
end;

function TBoard.getcounters(): integer;
begin
  result := counters;
end;

function TBoard.getrows(): integer;
begin
  result := rows;
end;

end.
