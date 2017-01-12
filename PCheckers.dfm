object CForm: TCForm
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
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxModeSelect: TListBox
    Left = 848
    Top = 56
    Width = 136
    Height = 33
    ItemHeight = 13
    TabOrder = 0
  end
  object BtnStart: TButton
    Left = 848
    Top = 111
    Width = 136
    Height = 34
    Caption = 'Start'
    TabOrder = 1
  end
  object BtnRestart: TButton
    Left = 848
    Top = 167
    Width = 136
    Height = 34
    Caption = 'Restart'
    TabOrder = 2
  end
  object BtnSave: TButton
    Left = 848
    Top = 352
    Width = 136
    Height = 33
    Caption = 'Save'
    TabOrder = 3
  end
  object BtnLoad: TButton
    Left = 848
    Top = 408
    Width = 136
    Height = 33
    Caption = 'Load'
    TabOrder = 4
  end
  object GridBoard: TStringGrid
    Left = 1
    Top = 0
    Width = 825
    Height = 825
    Color = clActiveBorder
    ColCount = 8
    DefaultColWidth = 100
    DefaultRowHeight = 100
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 5
    OnDrawCell = GridBoardDrawCell
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
