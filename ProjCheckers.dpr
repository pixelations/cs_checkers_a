program ProjCheckers;

uses
  Vcl.Forms,
  PCheckers in 'PCheckers.pas' {CheckersForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCheckersForm, CheckersForm);
  Application.Run;
end.
