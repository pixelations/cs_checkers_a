program ProjCheckers;

uses
  Vcl.Forms,
  PCheckers in 'PCheckers.pas' {CForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCForm, CForm);
  Application.Run;
end.
