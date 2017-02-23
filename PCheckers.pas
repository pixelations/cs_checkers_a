unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, UBoard, UAI;

type
  TCheckersForm = class(TForm)
    ListBoxModeSelect: TListBox;
    BtnStart: TButton;
    BtnRestart: TButton;
    BtnSave: TButton;
    BtnLoad: TButton;
    DrawGrid: TDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    /// <link>aggregationByValue</link>
    CBoard: TBoard;
    Board: TObjectArray;
  public
    { Public declarations }
  end;

var
  CheckersForm: TCheckersForm;



implementation

const
  ROWS  = 8;
  COLUMNS = 8;

{$R *.dfm}

{ TCForm }

procedure TCheckersForm.FormCreate(Sender: TObject);
var
t : TCoordinate;
begin
  {CBoard := TBoard.Create(COLUMNS, ROWS);
  CBoard.InitArray(Board);
  CBoard.InitDraughts(Board);
  //GetPos Test
  Board[4,4] := TCounter.Create(true, false);
  //
  CBoard.RemoveCounter(4,4,Board); }
end;

procedure TCheckersForm.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
{with DrawGrid do                       // Set scope to DrawGrid
  begin
    if assigned(Board[ARow, ACol]) then
      begin   // Select colour based on cell array
        if Board[ARow, ACol].GetColour then
            Canvas.Brush.Color := clBlack
        else
            Canvas.Brush.Color := clWhite
      end
    else
      Canvas.Brush.Color := clInfoBk;

    Canvas.FillRect(Rect);               // Fill cell with selected colour
  end; }
end;

end.
