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
    GridBoard: TDrawGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CForm: TCForm;
  Board: array of array of array of bool;


implementation

{$R *.dfm}

{ TCForm }

end.
