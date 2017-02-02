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
      TheFile: ObjectFile;
      FileName: string;
    public
      constructor Create(AFileName: string; BoardLength: integer);
      function Save(Board: TObjectArray): boolean;
      function Load(): TObjectRecord;
  end;

implementation

{ TSaveLoad }

constructor TSaveLoad.Create(AFileName: string; BoardLength: integer);
begin
  FileName := AFileName;
  assignfile(TheFile, FileName);
  setlength(BoardSave, BoardLength);///////do tyhsi
end;

function TSaveLoad.Load(): TObjectRecord;
begin
reset(TheFile);

end;

function TSaveLoad.Save(Board: TObjectArray): boolean;
begin

end;

end.
