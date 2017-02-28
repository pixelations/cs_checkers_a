unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, UBoard, UMove, UAI;

type
  TCheckersForm = class(TForm)
    BtnRestart: TButton;
    DrawGrid: TDrawGrid;
    Label1: TLabel;
    btnEasy: TButton;
    btnInter: TButton;
    btnHard: TButton;
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnRestartClick(Sender: TObject);
    procedure btnEasyClick(Sender: TObject);
    procedure btnInterClick(Sender: TObject);
    procedure btnHardClick(Sender: TObject);
  private
    { Private declarations }
    CBoard : TBoard;
    CMove: TMove;
    CAI: TAI;
    Board: TArray;
    PlayerMoveFrom: TCoordinate;
    PlayerMove: Boolean;
    CounterHold, Difficulty: integer;
  public
    { Public declarations }
    procedure AIMove;
  end;

var
  CheckersForm: TCheckersForm;



implementation

const
  C_P1 = 0;     //P1 counter
  C_P1_P = 2;   //promoted P1 counter
  C_AI = 1;     //AI counter
  C_AI_P = 3;   //promoted AI counter
  NC = -1;      //no counter
  EASY = 0;
  INTER = 1;
  HARD = 2;

{$R *.dfm}                                  //init draughts error

{ TCForm }

procedure TCheckersForm.FormCreate(Sender: TObject);
begin
  Difficulty := INTER;
  PlayerMove := true;
  CBoard := TBoard.Create();
  CBoard.InitDraughts(Board);
  CBoard.Free;
end;


procedure TCheckersForm.AIMove;
begin
  CAI := TAI.Create(Difficulty);   //implement diff. choice selection
  CAI.Minimax(Board, true, CAI.MaxDepth);
  Board := CAI.NextBoard;
  CAI.Free;
end;

procedure TCheckersForm.btnEasyClick(Sender: TObject);
begin
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := EASY;
end;

procedure TCheckersForm.btnHardClick(Sender: TObject);
begin
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := HARD;
end;

procedure TCheckersForm.btnInterClick(Sender: TObject);
begin
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := INTER;
end;

procedure TCheckersForm.BtnRestartClick(Sender: TObject);
begin
  CBoard := TBoard.Create();
  CBoard.InitDraughts(Board);
  DrawGrid.Invalidate; //forces the board to refresh
  CBoard.Free;
  PlayerMove := true;
  btnEasy.Enabled := true;
  btnInter.Enabled := true;
  btnHard.Enabled := true;
end;

procedure TCheckersForm.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
with DrawGrid do                       // Set scope to DrawGrid
  begin
    if Board[ARow, ACol] <> -1 then
      begin   // Select colour based on cell array

        if (Board[ARow, ACol] = 1) or (Board[ARow, ACol] = 3) then
            Canvas.Brush.Color := clBlack;
        if (Board[ARow, ACol] = 0) or (Board[ARow, ACol] = 2) then
            Canvas.Brush.Color := clSilver;
        if (Board[ARow, ACol] = -2) then
            Canvas.Brush.Color := clHighlight;
      end
    else
      Canvas.Brush.Color := clInfoBk;

    Canvas.FillRect(Rect);               // Fill cell with selected colour
  end;
end;

procedure TCheckersForm.DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if PlayerMove then
    begin
      PlayerMove := not PlayerMove;
      PlayerMoveFrom[0] := ARow;
      PlayerMoveFrom[1] := ACol;
      CounterHold := Board[ARow, ACol];
      Board[ARow, ACol] := -2;
      DrawGrid.Invalidate;
    end
  else
    begin
      CMove := TMove.Create;
      PlayerMove := not PlayerMove;
      Board[PlayerMoveFrom[0],PlayerMoveFrom[1]] := CounterHold;
      if CMove.CheckLegalMove(Board, ARow, ACol, PlayerMoveFrom[0], PlayerMoveFrom[1])  then
        begin
          Board := CMove.MakeMove(Board, ARow, ACol, PlayerMoveFrom[0], PlayerMoveFrom[1]);
          AIMove;
        end
      else
        ShowMessage('Not a legal move.');
      DrawGrid.Invalidate;
      CMove.Free;
    end;
end;

end.
