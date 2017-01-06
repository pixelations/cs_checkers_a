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
      function get_rows(var rows): integer;
        { "get rows" returns number of rows }
      function get_columns(var columns): integer;
        { "get columns" returns number of columns }
      function get_counters(var counters): integer;
        { "get counters" returns number of counters }
      function init_array(var board): boolean;
  end;


implementation

{ TBoard }

constructor TBoard.create(columns_, rows_, counters_ : integer);
begin
  columns := columns_;
  rows := rows_;
  counters := counters_;

end;

function TBoard.get_columns(): integer;
begin
  result := columns;
end;

function TBoard.get_counters(): integer;
begin
  result := counters;
end;

function TBoard.get_rows(): integer;
begin
  result := rows;
end;

function TBoard.init_array(var board): boolean;
begin

end;

end.
