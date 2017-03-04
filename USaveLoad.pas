unit USaveLoad;

interface

uses
  UBoard;

type
  TSaveLoad = class(TObject)
    private
    public
      constructor Create();
      function Save(Board: TArray; FileName: string): Boolean;
        { function will save TArray to a file }
      function Load(FileName: string): TArray;
        { function will output an array according to file }
  end;

implementation

const
  C_P1 = 0;     //P1 counter
  C_P1_P = 2;   //promoted P1 counter
  C_AI = 1;     //AI counter
  C_AI_P = 3;   //promoted AI counter
  NC = -1;      //no counter
  EXCEPTION = -3; //if there is an exception
  EASY = 0;
  INTER = 1;
  HARD = 2;

{ TSaveLoad }

constructor TSaveLoad.Create;
begin
end;

function TSaveLoad.Load(FileName: string): TArray;
var
  AFile: TextFile;
  intg, i: integer;
begin
  assignfile(AFile, FileName);
  reset(AFile);
  i := -1;
  while not eof(AFile) do                                     /////TODO/////
    begin                                                {in proj, make it 'restart if encounter EXCEPTION and showmsg}
      inc(i);
      intg := EXCEPTION;
      try
        read(AFile, intg);
      finally
        if intg = EXCEPTION then
          result[(i div 7), (i mod 8)] := EXCEPTION
        else
          result[(i div 7), (i mod 8)] := intg;
      end;
    end;
  closefile(AFile);
end;

function TSaveLoad.Save(Board: TArray; FileName: string): Boolean;
var
  AFile: TextFile;
  i, j: integer;
begin
  result := false;
  assignfile(AFile, FileName);
  rewrite(AFile);
  try
  for i := Low(Board) to High(Board) do                    {if FALSE then showmessage}
    begin
      for j := Low(Board) to High(Board) do
        begin
          write(AFile, Board[i, j]:1);
        end;
      writeln(AFile);
    end;
  except
    result := false; //if exception occurs, the reult will be false
  end;
  closefile(AFile);
end;

end.

