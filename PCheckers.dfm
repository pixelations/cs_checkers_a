object CheckersForm: TCheckersForm
  Left = 0
  Top = 0
  Caption = 'Checkers'
  ClientHeight = 900
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 872
    Top = 152
    Width = 60
    Height = 13
    Caption = 'AI Difficulty:'
  end
  object DrawGrid: TDrawGrid
    Left = 0
    Top = 0
    Width = 825
    Height = 825
    ColCount = 8
    DefaultColWidth = 100
    DefaultRowHeight = 100
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 1
    OnDrawCell = DrawGridDrawCell
    OnSelectCell = DrawGridSelectCell
    ColWidths = (
      100
      100
      100
      100
      100
      100
      100
      100)
    RowHeights = (
      100
      100
      100
      100
      100
      100
      100
      100)
  end
  object BtnRestart: TButton
    Left = 848
    Top = 23
    Width = 136
    Height = 34
    Caption = 'Restart'
    TabOrder = 0
    OnClick = BtnRestartClick
  end
  object btnEasy: TButton
    Left = 872
    Top = 171
    Width = 75
    Height = 25
    Caption = 'Easy'
    TabOrder = 2
    OnClick = btnEasyClick
  end
  object btnInter: TButton
    Left = 872
    Top = 202
    Width = 75
    Height = 25
    Caption = 'Intermediate'
    TabOrder = 3
    OnClick = btnInterClick
  end
  object btnHard: TButton
    Left = 872
    Top = 233
    Width = 75
    Height = 25
    Caption = 'Hard'
    TabOrder = 4
    OnClick = btnHardClick
  end
end
