program ProjCheckers;

uses
  Vcl.Forms,
  PCheckers in 'PCheckers.pas' {DraughtsForm},
  UBoard in 'UBoard.pas',
  UAI in 'UAI.pas',
  UMove in 'UMove.pas',
  USaveLoad in 'USaveLoad.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDraughtsForm, DraughtsForm);
  Application.Run;
end.
