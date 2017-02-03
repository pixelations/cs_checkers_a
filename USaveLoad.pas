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
      function Save(Board: TObjectArray; FileName: string): ObjectFile;
      function Load(FileName: string): TObjectArray;
  end;

implementation

{ TSaveLoad }

constructor TSaveLoad.Create(AXLength, AYLength: integer);
begin
  XLength := AXLength;
  YLength := AYLength;
end;        

function TSaveLoad.Load(FileName: string): TObjectArray;
var
  i, j: integer;
  IsCounter: TObjectRecord;
  TheFile: ObjectFile;
begin
  assignfile(TheFile, FileName);
  if XLength*YLength = length(TheFile) then
  //if the file and array have the same dimensions
    begin
      j := 0;
      reset(TheFile);                    //makes the file ready to be read
      
      setlength(result, YLength);           //sets the array dimensions
      for i := 0 to YLength - 1 do
        setlength(result, XLength - 1);
        
      for i := 0 to (XLength*YLength - 1) do
        begin
          seek(TheFile, i);
          read(TheFile, IsCounter);
          //will loop through all n spaces, then return to 0
          result[j, (i mod XLength)] := IsCounter.Counter;
          //if it has populated one row the increment row value
          if ((i + 1) mod XLength) = 0 then           
            inc(j);
        end;
    end else
      result := nil;
    closefile(TheFile);
end;

function TSaveLoad.Save(Board: TObjectArray; FileName: string): ObjectFile;
var
  i, j: integer;
begin
  //if board spaces = filespaces
  j := 0;
  assignfile(result, FileName);
  rewrite(result);
  for i := 0 to (XLength*YLength - 1) do
    begin
      seek(result, i);
      result[i] := Board[j, (i mod XLength)];
      if ((i + 1) mod XLength) = 0 then           
            inc(j);
    end;
  closefile(result);
end;

end.
