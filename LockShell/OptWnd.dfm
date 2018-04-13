object OptForm: TOptForm
  Left = 299
  Top = 215
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'LockShell options'
  ClientHeight = 362
  ClientWidth = 585
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
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 569
    Height = 305
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Shell mode'
      object ShellSelector: TRadioGroup
        Left = 8
        Top = 8
        Width = 545
        Height = 89
        Caption = ' System Shell '
        ItemIndex = 0
        Items.Strings = (
          'Default (Explorer.exe)'
          'LockShell program')
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Autorun list'
      ImageIndex = 1
      object ExecList: TListBox
        Left = 8
        Top = 8
        Width = 545
        Height = 209
        ItemHeight = 13
        TabOrder = 0
      end
      object AddBtn: TButton
        Left = 8
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Add...'
        TabOrder = 1
        OnClick = AddBtnClick
      end
      object DelBtn: TButton
        Left = 184
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 3
        OnClick = DelBtnClick
      end
      object ExecBtn: TButton
        Left = 416
        Top = 232
        Width = 139
        Height = 25
        Caption = 'Execute other...'
        TabOrder = 5
        OnClick = ExecBtnClick
      end
      object EditBtn: TButton
        Left = 96
        Top = 232
        Width = 73
        Height = 25
        Caption = 'Edit...'
        TabOrder = 2
        OnClick = EditBtnClick
      end
      object ExecSlctBtn: TButton
        Left = 272
        Top = 232
        Width = 129
        Height = 25
        Caption = 'Execute selected'
        TabOrder = 4
        OnClick = ExecSlctBtnClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Passwords'
      ImageIndex = 2
      object PassEdit1: TLabeledEdit
        Left = 16
        Top = 32
        Width = 225
        Height = 21
        EditLabel.Width = 71
        EditLabel.Height = 13
        EditLabel.Caption = 'Main password'
        PasswordChar = '*'
        TabOrder = 0
      end
      object PassEdit2: TLabeledEdit
        Left = 16
        Top = 80
        Width = 225
        Height = 21
        EditLabel.Width = 108
        EditLabel.Height = 13
        EditLabel.Caption = 'Confirm main password'
        PasswordChar = '*'
        TabOrder = 1
      end
      object ApplyPassBtn: TButton
        Left = 16
        Top = 128
        Width = 121
        Height = 25
        Caption = 'Apply password'
        TabOrder = 2
        OnClick = ApplyPassBtnClick
      end
    end
  end
  object Button1: TButton
    Left = 424
    Top = 328
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 504
    Top = 328
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OpenExecDlg: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'Executables (*.exe)|*.exe'
    Options = [ofEnableSizing]
    Left = 8
    Top = 320
  end
end
