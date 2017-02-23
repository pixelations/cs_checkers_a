unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, UBoard, UMove, UAI;

type
  TCheckersForm = class(TForm)
    ListBoxModeSelect: TListBox;
    BtnStart: TButton;
    BtnRestart: TButton;
    BtnSave: TButton;
    BtnLoad: TButton;
    DrawGrid: TDrawGrid;
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    CBoard: TBoard;
    CCounter: TCounter;
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

{$R *.dfm}                                  //init draughts error

{ TCForm }

procedure TCheckersForm.FormCreate(Sender: TObject);
var
  CAI: TAI;
  i, j: integer;
begin
  CBoard := TBoard.Create();
  CBoard.InitDraughts(Board);
  CAI := TAI.Create(1, true);
  for i := 0 to 7 do
    begin
      for j := 0 to 7 do
        Board[i, j] := CAI.AIMove(Board)[i, j];
    end;
end;

procedure TCheckersForm.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
with DrawGrid do                       // Set scope to DrawGrid
  begin
    if assigned(Board[ARow, ACol]) then
      begin   // Select colour based on cell array

        if Board[ARow, ACol].GetColour then
            Canvas.Brush.Color := clBlack
        else
            Canvas.Brush.Color := clWhite;
      end
    else
      Canvas.Brush.Color := clInfoBk;

    Canvas.FillRect(Rect);               // Fill cell with selected colour
  end;
end;

end.
