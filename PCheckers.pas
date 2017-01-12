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
    procedure GridBoardDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CForm: TCForm;

implementation

{$R *.dfm}

{ TCForm }

procedure TCForm.GridBoardDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  GridBoard.Canvas.Pen.Color := clBlack;
  GridBoard.Canvas.Brush.Color := clGray;
  GridBoard.Canvas.Ellipse(
  Rect.Left+10,
  Rect.Top+10,
  Rect.Left+90,
  Rect.Top+90
  );
end;

end.
