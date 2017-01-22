unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, UBoard;

type
  TCForm = class(TForm)
    ListBoxModeSelect: TListBox;
    BtnStart: TButton;
    BtnRestart: TButton;
    BtnSave: TButton;
    BtnLoad: TButton;
    GridBoard: TDrawGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CForm: TCForm;
  CBoard: TBoard;
  Board: TObjectArray;


implementation

const
  ROWS  = 8;
  COLUMNS = 8;

{$R *.dfm}

{ TCForm }

procedure TCForm.FormCreate(Sender: TObject);
begin
  CBoard := TBoard.Create(COLUMNS, ROWS);


end;

end.
