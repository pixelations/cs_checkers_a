unit USaveLoad;

interface

uses
  UBoard;

type
  TObjectRecord = Record
    Counter: TCounter;
  end;
  ObjectFile = file of TObjectRecord;
  TSaveLoad = class(TObject)
    private
      XLength: integer;
      YLength: integer;
    public
      constructor Create(AXLength, AYLength: integer);
      function FileToArray(FileName: string): TObjectArray;
      function ArrayToFile(Board: TObjectArray; FileName: string): ObjectFile;
  end;

implementation

{ TSaveLoad }

constructor TSaveLoad.Create(AXLength, AYLength: integer);
begin
  XLength := AXLength;
  YLength := AYLength;
end;        

function TSaveLoad.FileToArray(FileName: string): TObjectArray;
var
  i, j: integer;
  IsCounter: TObjectRecord;
  TheFile: ObjectFile;
begin
  assignfile(TheFile, FileName);
  if XLength*YLength = length(TheFile) then
  //if the file and array have the same dimensions
    begin
      reset(TheFile);                    //makes the file ready to be read
      setlength(result, YLength);           //sets the array dimensions
      for i := 0 to YLength - 1 do
        setlength(result, XLength);
      for i := Low(result) to High(result) do
        begin
          for j := Low(result[i]) to High(result[i]) do
            begin
              //finds record corresponding to space on the board
              seek(TheFile, (j + i*XLength));
              read(TheFile, IsCounter);
              result[i, j] := IsCounter.Counter;
            end;
        end;
    end else
      result := nil;
  closefile(TheFile);
end;

function TSaveLoad.ArrayToFile(Board: TObjectArray; FileName: string): ObjectFile;
var
  i, j: integer;
begin
  assignfile(result, FileName);
  rewrite(result);
  for i := Low(Board) to High(Board) do
    begin
      for j := Low(Board[i]) to High(Board[i]) do
        begin
          seek(result, (j + i*XLength));
          write(result, Board[i, j]);  //written to the result file
        end;
    end;
  closefile(result);
end;

end.
