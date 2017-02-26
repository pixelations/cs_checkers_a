unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, UBoard, UMove, UAI;

type
  TCheckersForm = class(TForm)
    BtnStart: TButton;
    BtnRestart: TButton;
    DrawGrid: TDrawGrid;
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    CBoard : TBoard;
    CMove: TMove;
    CAI: TAI;
    Board: TArray;
    //p: TMoveVector;
    //CounterHold: integer;
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
begin
  CBoard := TBoard.Create();
  CBoard.InitDraughts(Board);
  {
  CMove := TMove.Create;
  //Board := CMove.MakeMove(Board, 3,2,5,0);
  //if Cmove.CheckLegalMove(Board, 4, 3, 2, 1) then Board := CMove.MakeMove(Board, 4,3,2,1);
  CMove.Free;
  {
  CAI := TAI.Create(1);
  CAI.Minimax(Board, true, CAI.MaxDepth);
  Board := CAI.WinningSeq[0];

  CAI.Free;
  }
  CBoard.Free;
end;


procedure TCheckersForm.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
with DrawGrid do                       // Set scope to DrawGrid
  begin
    if Board[ARow, ACol] <> -1 then
      begin   // Select colour based on cell array

        if (Board[ARow, ACol] = 1) or (Board[ARow, ACol] = 3) then
            Canvas.Brush.Color := clBlack
        else
            Canvas.Brush.Color := clSilver;
      end
    else
      Canvas.Brush.Color := clInfoBk;

    Canvas.FillRect(Rect);               // Fill cell with selected colour
  end;
end;

procedure TCheckersForm.DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  {if SelectState then
    begin
      CounterHold := Board[ARow, ACol];
      Board[ARow, ACol] := -1;
      p[0, 0] := ARow;
      p[0, 1] := ACol;
      SelectState := not SelectState;
    end
  else
    begin
     p[1, 0] := ARow;
      p[1, 1] := ACol;
      CMove := TMove.Create;
      if CMove.CheckLegalMove(Board, p) then
        begin
          Board[ARow, ACol] := CounterHold;
          SelectState := not SelectState;
        end
      else
       ShowMessage('Not a legal Move');
      CMove.Free;
    end; }
end;

end.
