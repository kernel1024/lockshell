object AutoForm: TAutoForm
  Left = 391
  Top = 214
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Autostart entry'
  ClientHeight = 251
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 144
    Width = 68
    Height = 13
    Caption = 'Window mode'
  end
  object TitleEdt: TLabeledEdit
    Left = 16
    Top = 32
    Width = 377
    Height = 21
    EditLabel.Width = 20
    EditLabel.Height = 13
    EditLabel.Caption = 'Title'
    TabOrder = 0
  end
  object ProgramEdt: TLabeledEdit
    Left = 16
    Top = 72
    Width = 329
    Height = 21
    EditLabel.Width = 55
    EditLabel.Height = 13
    EditLabel.Caption = 'Program file'
    TabOrder = 1
  end
  object ParamsEdt: TLabeledEdit
    Left = 16
    Top = 112
    Width = 377
    Height = 21
    EditLabel.Width = 103
    EditLabel.Height = 13
    EditLabel.Caption = 'Command line params'
    TabOrder = 3
  end
  object WindowModeLst: TComboBox
    Left = 16
    Top = 160
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = 'Normal window'
    Items.Strings = (
      'Normal window'
      'Minimize window'
      'Maximize window'
      'Hide window'
      'Minimize and unfocus window'
      'Normal unfocused window')
  end
  object Button1: TButton
    Left = 232
    Top = 208
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Button2: TButton
    Left = 320
    Top = 208
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object OpenProgDlg: TButton
    Left = 352
    Top = 72
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 2
    OnClick = OpenProgDlgClick
  end
  object OpenExecDlg: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'Executables (*.exe)|*.exe'
    Options = [ofEnableSizing]
    Left = 16
    Top = 192
  end
end
