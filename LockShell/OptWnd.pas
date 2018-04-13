unit OptWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TExecItem=record
    ProgTitle:string[255];  // Title
    ProgName:string[255];   // Executable file
    Params:string;    // Command line params
    wndMode:word;
  end;

  TOptForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    ShellSelector: TRadioGroup;
    PassEdit1: TLabeledEdit;
    PassEdit2: TLabeledEdit;
    ApplyPassBtn: TButton;
    ExecList: TListBox;
    AddBtn: TButton;
    DelBtn: TButton;
    ExecBtn: TButton;
    OpenExecDlg: TOpenDialog;
    EditBtn: TButton;
    ExecSlctBtn: TButton;
    procedure ExecBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure ApplyPassBtnClick(Sender: TObject);
    procedure ExecSlctBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateExecList;
  end;

var
  OptForm: TOptForm;
  ExecItems: array of TExecItem;

implementation

uses MainWnd, AutoWnd;

{$R *.dfm}

procedure TOptForm.ExecBtnClick(Sender: TObject);
begin
  if OpenExecDlg.Execute then
    MainForm.ExecuteProgram(OpenExecDlg.FileName,'',sw_ShowNormal);
end;

procedure TOptForm.AddBtnClick(Sender: TObject);
begin
  AutoForm.TitleEdt.Text:='';
  AutoForm.ProgramEdt.Text:='';
  AutoForm.ParamsEdt.Text:='';
  AutoForm.WindowModeLst.ItemIndex:=0;
  if AutoForm.ShowModal=mrOk then
  begin
    SetLength(ExecItems,Length(ExecItems)+1);
    with ExecItems[High(ExecItems)] do
    begin
      ProgTitle:=AutoForm.TitleEdt.Text;
      ProgName:=AutoForm.ProgramEdt.Text;
      Params:=AutoForm.ParamsEdt.Text;
      wndMode:=SW_SHOWNORMAL;
      case AutoForm.WindowModeLst.ItemIndex of
        0: wndMode:=SW_SHOWNORMAL;
        1: wndMode:=SW_SHOWMINIMIZED;
        2: wndMode:=SW_SHOWMAXIMIZED;
        3: wndMode:=SW_HIDE;
        4: wndMode:=SW_SHOWNOACTIVATE;
        5: wndMode:=SW_SHOWNA;
      end;
    end;
  end;
  UpdateExecList;
end;

procedure TOptForm.UpdateExecList;
var
  i:integer;
begin
  ExecList.Clear;
  if Length(ExecItems)<1 then Exit;
  for i:=Low(ExecItems) to High(ExecItems) do
    ExecList.Items.Add(ExecItems[i].ProgTitle+' ["'+ExecItems[i].ProgName+'" '+
      ExecItems[i].Params+']');
end;

procedure TOptForm.DelBtnClick(Sender: TObject);
var
  i:integer;
begin
  if Length(ExecItems)<1 then Exit;
  if ExecList.ItemIndex<0 then Exit;
  if ExecList.ItemIndex>=Length(ExecItems) then Exit;
  for i:=ExecList.ItemIndex to Length(ExecItems)-2 do
    ExecItems[i]:=ExecItems[i+1];
  SetLength(ExecItems,Length(ExecItems)-1);
  UpdateExecList;
end;

procedure TOptForm.EditBtnClick(Sender: TObject);
begin
  if Length(ExecItems)<1 then Exit;
  if ExecList.ItemIndex<0 then Exit;
  if ExecList.ItemIndex>=Length(ExecItems) then Exit;
  AutoForm.TitleEdt.Text:=ExecItems[ExecList.ItemIndex].ProgTitle;
  AutoForm.ProgramEdt.Text:=ExecItems[ExecList.ItemIndex].ProgName;
  AutoForm.ParamsEdt.Text:=ExecItems[ExecList.ItemIndex].Params;
  AutoForm.WindowModeLst.ItemIndex:=0;
  case ExecItems[ExecList.ItemIndex].wndMode of
    SW_SHOWNORMAL: AutoForm.WindowModeLst.ItemIndex:=0;
    SW_SHOWMINIMIZED: AutoForm.WindowModeLst.ItemIndex:=1;
    SW_SHOWMAXIMIZED: AutoForm.WindowModeLst.ItemIndex:=2;
    SW_HIDE: AutoForm.WindowModeLst.ItemIndex:=3;
    SW_SHOWNOACTIVATE: AutoForm.WindowModeLst.ItemIndex:=4;
    SW_SHOWNA: AutoForm.WindowModeLst.ItemIndex:=5;
  end;
  if AutoForm.ShowModal=mrOk then
  begin
    with ExecItems[ExecList.ItemIndex] do
    begin
      ProgTitle:=AutoForm.TitleEdt.Text;
      ProgName:=AutoForm.ProgramEdt.Text;
      Params:=AutoForm.ParamsEdt.Text;
      wndMode:=SW_SHOWNORMAL;
      case AutoForm.WindowModeLst.ItemIndex of
        0: wndMode:=SW_SHOWNORMAL;
        1: wndMode:=SW_SHOWMINIMIZED;
        2: wndMode:=SW_SHOWMAXIMIZED;
        3: wndMode:=SW_HIDE;
        4: wndMode:=SW_SHOWNOACTIVATE;
        5: wndMode:=SW_SHOWNA;
      end;
    end;
  end;
  UpdateExecList;
end;

procedure TOptForm.ApplyPassBtnClick(Sender: TObject);
begin
  if PassEdit1.Text=PassEdit2.Text then
  begin
    MainForm.SetMasterPassword(PassEdit1.Text);
    MessageBox(Handle,'Password successfully changed.','LockShell',mb_Ok or mb_IconInformation);
  end else
    MessageBox(Handle,'Passwords are not equal. Check your input.','LockShell',mb_Ok or mb_IconStop);
end;

procedure TOptForm.ExecSlctBtnClick(Sender: TObject);
begin
  if Length(ExecItems)<1 then Exit;
  if ExecList.ItemIndex<0 then Exit;
  if ExecList.ItemIndex>=Length(ExecItems) then Exit;
  MainForm.ExecuteProgram(ExecItems[ExecList.ItemIndex].ProgName,
    ExecItems[ExecList.ItemIndex].Params,ExecItems[ExecList.ItemIndex].wndMode);
end;

end.
