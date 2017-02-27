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
  object BtnRestart: TButton
    Left = 848
    Top = 23
    Width = 136
    Height = 34
    Caption = 'Restart'
    TabOrder = 0
    OnClick = BtnRestartClick
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
end
