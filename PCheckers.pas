unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls;

type
  TCForm = class(TForm)
    ListBoxModeSelect: TListBox;
    BtnStart: TButton;
    BtnRestart: TButton;
    BtnSave: TButton;
    BtnLoad: TButton;
    GridBoard: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure populate();
  public
    { Public declarations }
  end;

var
  CForm: TCForm;

implementation

{$R *.dfm}

{ TCForm }

procedure TCForm.FormCreate(Sender: TObject);
begin
populate;
end;

procedure TCForm.populate;
begin
GridBoard.Cells[0,0]:= 'O';
end;

end.
