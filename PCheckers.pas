unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, UBoard;

type
  TCheckersForm = class(TForm)
    ListBoxModeSelect: TListBox;
    BtnStart: TButton;
    BtnRestart: TButton;
    BtnSave: TButton;
    BtnLoad: TButton;
    GridBoard: TDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure GridBoardDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckersForm: TCheckersForm;
  CBoard: TBoard;
  Board: TObjectArray;


implementation

const
  ROWS  = 8;
  COLUMNS = 8;

{$R *.dfm}

{ TCForm }

procedure TCheckersForm.FormCreate(Sender: TObject);
var t :TCoordinate;
begin
  CBoard := TBoard.Create(COLUMNS, ROWS);
  CBoard.InitArray(Board);
  CBoard.InitDraughts(Board);
  //Get Counters Test
  showmessage(inttostr(CBoard.GetCounters(Board)));
  //GetPos Test
  Board[4,4] := TCounter.Create(4, 4, true);
  t := (Board[4, 4].GetPos);
  showmessage(inttostr(t[0]));
  showmessage(inttostr(t[1]));
  //
  CBoard.RemoveCounter(4,4,Board);
end;

procedure TCheckersForm.GridBoardDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  i: Integer;
  j: Integer;
begin
with GridBoard do                       // Set scope to DrawGrid
  begin
    if assigned(Board[ARow, ACol]) then   // Select colour based on cell array
      Canvas.Brush.Color := clBlack
    else
      Canvas.Brush.Color := clWhite;

    Canvas.FillRect(Rect);               // Fill cell with selected colour
  end;
end;

end.
