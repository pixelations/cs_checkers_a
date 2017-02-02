unit USaveLoad;

interface

uses
  UBoard;

type
  TObjectRecord = Record
    Counter: TCounter;
  end;

  ObjectFile = file of TObjectRecord;

  TSaveLoad = class(Tobject)
    private
      BoardSave: Array of TObjectRecord;
      XLength: integer;
      YLength: integer;
      TheFile: ObjectFile;
      FileName: string;
    public
      constructor Create(AFileName: string; AXLength, AYLength: integer);
      function Save(Board: TObjectArray): boolean;
      function Load(): TObjectArray;
  end;

implementation

{ TSaveLoad }

constructor TSaveLoad.Create(AFileName: string; AXLength, AYLength: integer);
begin
  FileName := AFileName;
  XLength := AXLength;
  YLength := AYLength;
  assignfile(TheFile, FileName);
end;

function TSaveLoad.Load(): TObjectArray;
var
  i, j: integer;
  IsCounter: TObjectRecord;
begin
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
        
      closefile(TheFile);
    end else
      result := nil;
end;

function TSaveLoad.Save(Board: TObjectArray): boolean;
begin

end;

end.
