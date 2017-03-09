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
var
  CBoard: TBoard;
begin
  //starting variables
  pwin := false;
  aiwin := false;
  startDiff := false;
  PlayerMove := true;
  CounterHold := EMPTY;
  btnEasy.Enabled := true;
  btnInter.Enabled := true;
  btnHard.Enabled := true;
  CBoard := TBoard.Create();
  CBoard.InitDraughts(Board);
  CBoard.Free;
  DrawGrid.Invalidate;    //forces the board to refresh
end;


procedure TDraughtsForm.AIMove;
  var
  CAI: TAI;
begin
  if (not pwin) and (not aiwin) then
    begin
      CAI := TAI.Create(Difficulty);  //send difficult to AI unit
      CAI.Minimax(Board, true, CAI.MaxDepth);
      Board := CAI.NextBoard;
      CAI.Free;
      DrawGrid.Invalidate;
    end;
  CheckWin;
  if pwin then ShowMessage('Player wins!');
  if aiwin then ShowMessage('AI wins!');
end;

procedure TDraughtsForm.btnEasyClick(Sender: TObject);
begin
  startDiff := true;  //player can make a move
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := EASY;
end;

procedure TDraughtsForm.btnHardClick(Sender: TObject);
begin
  startDiff := true;       //player can make a move
  btnEasy.Enabled := false;
  btnInter.Enabled := false;
  btnHard.Enabled := false;
  Difficulty := HARD;
end;

procedure TDraughtsForm.btnInterClick(Sender: TObject);
begin
  startDiff := true;       //player can make a move
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
  //settings for the laod dialog
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
                btnEasyClick(Sender); //simulates the clickig of btnEasy
                ShowMessage('AI difficulty is: Easy.');
        end;
        INTER: begin
                btnInterClick(Sender); //simulates the clickig of btnInter
                ShowMessage('AI difficulty is: Intermediate.');
        end;
        HARD: begin
                btnHardClick(Sender); //simulates the clickig of btnHard
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
  FormCreate(Sender);   //simulates form create
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
    //creates a checkerboard pattern
    if ARow mod 2 = 0 then
      begin
       if ACol mod 2 = 1 then
          Canvas.Brush.Color := clGray;
      end
    else
        if ACol mod 2 = 0 then
          Canvas.Brush.Color := clGray;
    Canvas.FillRect(Rect);
    //based on what counter there is, an ellipse is drawn
    //then the ellipse is filled with counter colour
        case Board[ARow, ACol] of
          C_AI: begin
                    Canvas.Brush.Color := clWhite;
                    Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
          end;
          C_AI_P: begin   //promoted counters have two ellipses
                    Canvas.Brush.Color := clBlack;
                    Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
                    Canvas.Brush.Color := clWhite;
                    Canvas.Ellipse(Rect.Left + 20, Rect.Top + 20, Rect.Left + 80, Rect.Top + 80);
          end;
          C_P1: begin
                  Canvas.Brush.Color := clRed;
                  Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
          end;
          C_P1_P: begin   //promoted counters have two ellipses
                    Canvas.Brush.Color := clBlack;
                    Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
                    Canvas.Brush.Color := clRed;
                    Canvas.Ellipse(Rect.Left + 20, Rect.Top + 20, Rect.Left + 80, Rect.Top + 80);
          end;
          HIGHLIGHT: begin
                      Canvas.Brush.Color := clHighlight;
                      Canvas.Ellipse(Rect.Left + 10, Rect.Top + 10, Rect.Left + 90, Rect.Top + 90);
          end;
          EXCEPTION: begin    //occurs when there is a loading error
                      ShowMessage('The save file you have loaded is erroneous.');
                      BtnRestartClick(Sender);
          end;
        end;

  end;
end;

procedure TDraughtsForm.DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  CMove: TMove;
begin
        //if the difficulty has been set and the player is not selecting an AI counter
      if startDiff and not ((Board[ARow, ACol] = C_AI) xor (Board[ARow, ACol] = C_AI_P)) then
        begin
          if PlayerMove then
            begin
              PlayerMove := not PlayerMove;
              PlayerMoveFrom[0] := ARow;  //saves coordinates
              PlayerMoveFrom[1] := ACol;
              CounterHold := Board[ARow, ACol]; //hold the counter temporarily
              Board[ARow, ACol] := HIGHLIGHT; //highlights counter
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
  CheckWin;                                       //possibly move above the stuuf
  if pwin then ShowMessage('Player wins!');
  if aiwin then ShowMessage('AI wins!');
end;

end.
