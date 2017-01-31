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
      BoardSave: TObjectRecord;
      FileName: string;
    public
      constructor Create(AFileName: string);
      function Save(Board: TObjectArray): boolean;
      function Load(AFileName: string): TObjectRecord;
  end;

implementation

{ TSaveLoad }

constructor TSaveLoad.Create(AFileName: string);
begin
  FileName := AFileName;
end;

function TSaveLoad.Load(BoardFile): TObjectRecord;
begin

end;

function TSaveLoad.Save(Board: TObjectArray): boolean;
begin

end;

end.
