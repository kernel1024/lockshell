object MainForm: TMainForm
  Left = 326
  Top = 237
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'LockShell'
  ClientHeight = 196
  ClientWidth = 121
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 105
    Height = 9
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 8
    Top = 176
    Width = 86
    Height = 13
    Caption = '(c) kernelonline, 2008'
  end
  object SetupBtn: TButton
    Left = 8
    Top = 8
    Width = 105
    Height = 25
    Caption = 'Setup...'
    TabOrder = 0
    OnClick = SetupBtnClick
  end
  object LogoutBtn: TButton
    Left = 8
    Top = 48
    Width = 105
    Height = 25
    Caption = 'Logout'
    TabOrder = 1
    OnClick = LogoutBtnClick
  end
  object RebootBtn: TButton
    Left = 8
    Top = 80
    Width = 105
    Height = 25
    Caption = 'Reboot'
    TabOrder = 2
    OnClick = RebootBtnClick
  end
  object ShutdownBtn: TButton
    Left = 8
    Top = 112
    Width = 105
    Height = 25
    Caption = 'Shutdown'
    TabOrder = 3
    OnClick = ShutdownBtnClick
  end
  object CloseBtn: TButton
    Left = 8
    Top = 144
    Width = 105
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = CloseBtnClick
  end
end
