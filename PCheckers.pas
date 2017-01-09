unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids;

type
  TCForm = class(TForm)
    GridBoard: TDrawGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CForm: TCForm;

implementation

{$R *.dfm}

end.
