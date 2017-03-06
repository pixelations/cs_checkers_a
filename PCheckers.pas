unit PCheckers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, UBoard, UMove, UAI, USaveLoad;

type
  TDraughtsForm = class(TForm)
    BtnRestart: TButton;
    DrawGrid: TDrawGrid;
    Label1: TLabel;
    btnEasy: TButton;
    btnInter: TButton;
    btnHard: TButton;
    btnSave: TButton;
    btnLoad: TButton;
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnRestartClick(Sender: TObject);
    procedure btnEasyClick(Sender: TObject);
    procedure btnInterClick(Sender: TObject);
    procedure btnHardClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
    CBoard : TBoard;
    CMove: TMove;
    CAI: TAI;
    Board: TArray;
    PlayerMoveFrom: TCoordinate;
    PlayerMove, startDiff, pwin, aiwin: Boolean;
    CounterHold, Difficulty: integer;
  public
    { Public declarations }
    procedure AIMove;
    procedure CheckWin;
  end;

var
  DraughtsForm: TDraughtsForm;



implementation

const
  C_P1 = 0;     //P1 counter
  C_P1_P = 2;   //promoted P1 counter
  C_AI = 1;     //AI counter
  C_AI_P = 3;   //promoted AI counter
  NC = -1;      //no counter
  EXCEPTION = -3; //if there is an exception
  HIGHLIGHT = -2;
  EMPTY = -4;
  EASY = 0;
  INTER = 1;
  HARD = 2;

{$R *.dfm}                                  //init draughts error

{ TCForm }

procedure TDraughtsForm.FormCreate(Sender: TObject);
begin
  pwin := false;
  aiwin := false;
  startDiff := false;
  PlayerMove := true;
  CounterHold := EMPTY;
  CBoard := TBoard.Create();
  CBoard.InitDraughts(Board);
  CBoard.Free;
end;


procedure TDraughtsForm.AIMove;
begin
  if (not pwin) and (not aiwin) then
    begin
      CAI := TAI.Create(Difficulty);   //implement diff. choice selection
      CAI.Minimax(Board, true, CAI.MaxDepth);
      Board := CAI.NextBoard;
      CAI.Free;
    end;
  CheckWin;
  if pwin then ShowMessage('Player wins!');
  if aiwin then ShowMessage('AI wins!');
end;

procedure TDraughtsForm.btnEasyClick(Sender: TObject);
begin
  startDiff := true;
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := EASY;
end;

procedure TDraughtsForm.btnHardClick(Sender: TObject);
begin
  startDiff := true;
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := HARD;
end;

procedure TDraughtsForm.btnInterClick(Sender: TObject);
begin
  startDiff := true;
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := INTER;
end;

procedure TDraughtsForm.btnLoadClick(Sender: TObject);
var
  CSaveLoad: TSaveLoad;
  LoadDialog: TOpenDialog;
begin
  BtnRestartClick(Sender);
  LoadDialog := TOpenDialog.Create(Self);
  LoadDialog.InitialDir := GetCurrentDir;
  LoadDialog.Options := [ofFileMustExist];
  LoadDialog.Filter := 'Text File|*.txt';
  LoadDialog.FilterIndex := 1;
  if LoadDialog.Execute then
    begin
      CSaveLoad := TSaveLoad.Create;
      Board := CSaveLoad.Load(LoadDialog.FileName, Difficulty);
      case Difficulty of
        EASY: begin
                btnEasyClick(Sender);
                ShowMessage('AI difficulty is: Easy.');
        end;
        INTER: begin
                btnInterClick(Sender);
                ShowMessage('AI difficulty is: Intermediate.');
        end;
        HARD: begin
                btnHardClick(Sender);
                ShowMessage('AI difficulty is: Hard.');
        end;
      end;
      CSaveLoad.Free;
    end;
  LoadDialog.Free;
  DrawGrid.Invalidate;
end;

procedure TDraughtsForm.BtnRestartClick(Sender: TObject);
begin
  pwin := false;
  aiwin := false;
  startDiff := false;
  CBoard := TBoard.Create();
  CBoard.InitDraughts(Board);
  DrawGrid.Invalidate; //forces the board to refresh
  CBoard.Free;
  PlayerMove := true;
  btnEasy.Enabled := true;
  btnInter.Enabled := true;
  btnHard.Enabled := true;
end;

procedure TDraughtsForm.btnSaveClick(Sender: TObject);
var
  CSaveLoad: TSaveLoad;
  SaveDialog: TSaveDialog;
begin
  if startDiff and (CounterHold = EMPTY) then
    begin
      SaveDialog := TSaveDialog.Create(Self);
      SaveDialog.Title := 'Save as...';
      SaveDialog.InitialDir := GetCurrentDir;
      SaveDialog.Filter := 'Text file|*.txt';
      SaveDialog.DefaultExt := 'txt';
      SaveDialog.FilterIndex := 1;
      if SaveDialog.Execute then
        begin
          CSaveLoad := TSaveLoad.Create;
          if not(CSaveLoad.Save(Board, Difficulty, SaveDialog.FileName)) then
            ShowMessage('An error occured while saving the game.');
          CSaveload.Free;
        end;
      SaveDialog.Free;
    end
  else
    begin
      if not startDiff then ShowMessage('The game must have a difficulty to be saved.');
      if not(CounterHold = EMPTY) then ShowMessage('You are not allowed to save the game while making a move.');
    end;
end;

procedure TDraughtsForm.CheckWin;
var
  i, j: integer;
  CMove: TMove;
begin
  if (not pwin) and (not aiwin) then
    begin
      for i := Low(Board) to High(Board) do
        begin
          for j := Low(Board) to High(Board) do
            begin
              if (Board[i, j] = C_P1) or (Board[i, j] = C_P1_P) then
                pwin := true;
              if (Board[i, j] = C_AI) or (Board[i, j] = C_AI_P) then
                aiwin := true;
            end;
        end;
      if pwin and aiwin then
        begin
          pwin := false;
          aiwin := false;
          CMove := TMove.Create;
          if length(CMove.AllPossibleLegalMoves(Board, false)) = 0 then
            aiwin := true;
          if length(CMove.AllPossibleLegalMoves(Board, true)) = 0 then
            pwin := true;
          CMove.Free;
          if pwin and aiwin then
            begin
              pwin := false;
              aiwin := false;
            end;
        end;
    end;
end;

procedure TDraughtsForm.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
with DrawGrid do                       // Set scope to DrawGrid
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clInfoBk;
    if ARow mod 2 = 0 then
      begin
       if ACol mod 2 = 1 then
          Canvas.Brush.Color := clGray;
      end
    else
        if ACol mod 2 = 0 then
          Canvas.Brush.Color := clGray;
    Canvas.FillRect(Rect);
        case Board[ARow, ACol] of
          C_AI: begin
                    Canvas.Brush.Color := clWhite;
                    Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
          end;
          C_AI_P: begin
                    Canvas.Brush.Color := clBlack;
                    Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
                    Canvas.Brush.Color := clWhite;
                    Canvas.Ellipse(Rect.Left + 20, Rect.Top + 20, Rect.Left + 80, Rect.Top + 80);
          end;
          C_P1: begin
                  Canvas.Brush.Color := clRed;
                  Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
          end;
          C_P1_P: begin
                    Canvas.Brush.Color := clBlack;
                    Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
                    Canvas.Brush.Color := clRed;
                    Canvas.Ellipse(Rect.Left + 20, Rect.Top + 20, Rect.Left + 80, Rect.Top + 80);
          end;
          HIGHLIGHT: begin
                      Canvas.Brush.Color := clHighlight;
                      Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
          end;
          EXCEPTION: begin
                      ShowMessage('The save file you have loaded is erroneous.');
                      BtnRestartClick(Sender);
          end;
        end;

  end;
end;

procedure TDraughtsForm.DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  //if (not pwin) and (not aiwin) then
    //begin
      if startDiff and not ((Board[ARow, ACol] = C_AI) xor (Board[ARow, ACol] = C_AI_P)) then
        begin
          if PlayerMove then
            begin
              PlayerMove := not PlayerMove;
              PlayerMoveFrom[0] := ARow;
              PlayerMoveFrom[1] := ACol;
              CounterHold := Board[ARow, ACol];
              Board[ARow, ACol] := HIGHLIGHT;
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
              CounterHold := EMPTY;
            end;
        end
      else
        begin
          if not startDiff then
            ShowMessage('Pick AI difficulty');
          if ((Board[ARow, ACol] = C_AI) xor (Board[ARow, ACol] = C_AI_P)) then
            ShowMessage('Not a legal move');
        end;
    //end;
  CheckWin;                                       //possibly move above the stuuf
  if pwin then ShowMessage('Player wins!');
  if aiwin then ShowMessage('AI wins!');
end;

end.
