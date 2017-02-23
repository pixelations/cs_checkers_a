program ProjCheckers;

uses
  Vcl.Forms,
  PCheckers in 'PCheckers.pas' {CheckersForm},
  UBoard in 'UBoard.pas',
  UAI in 'UAI.pas',
  UMove in 'UMove.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCheckersForm, CheckersForm);
  Application.Run;
end.
