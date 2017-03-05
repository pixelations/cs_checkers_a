unit USaveLoad;

interface

uses
  SysUtils, UBoard;

type
  TSaveLoad = class(TObject)
    private
    public
      constructor Create();
      function Save(Board: TArray; ADifficulty: integer; FileName: string): Boolean;
        { function will save TArray to a file }
      function Load(FileName: string; var ADifficulty: integer): TArray;
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

function TSaveLoad.Load(FileName: string; var ADifficulty: integer): TArray;
var
  AFile: TextFile;
  i: integer;
  intg: string;
begin
  assignfile(AFile, FileName);
  reset(AFile);
  i := 0;
  while not eof(AFile) do
    begin
      inc(i);
      intg := inttostr(EXCEPTION);
      try
        readln(AFile, intg);
      finally
        if intg = inttostr(EXCEPTION) then
          begin
            result[(i div 8), ((i-1) mod 8)] := EXCEPTION ;
            seekEof(AFile);
          end
        else
          begin
            if (i div 8) = 8 then
              ADifficulty := strtoint(intg)
            else
              result[(i div 8), ((i-1) mod 8)] := strtoint(intg);
          end;
      end;
    end;
  closefile(AFile);
end;

function TSaveLoad.Save(Board: TArray; ADifficulty: integer; FileName: string): Boolean;
var
  AFile: TextFile;
  i, j: integer;
begin
  result := true;
  assignfile(AFile, FileName);
  rewrite(AFile);
  try
  for i := Low(Board) to High(Board) do
    begin
      for j := Low(Board) to High(Board) do
        begin
          write(AFile, Board[i, j]:1);
          writeln(AFile);
        end;
    end;
  except
    result := false; //if exception occurs, the reult will be false
  end;
  write(AFile, ADifficulty);
  closefile(AFile);
end;

end.

