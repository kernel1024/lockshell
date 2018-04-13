unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Registry;

type
  TExitType=(etLogoff,etReboot,etShutdown);

  TMainForm = class(TForm)
    SetupBtn: TButton;
    LogoutBtn: TButton;
    RebootBtn: TButton;
    ShutdownBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    CloseBtn: TButton;
    procedure CloseBtnClick(Sender: TObject);
    procedure SetupBtnClick(Sender: TObject);
    procedure LogoutBtnClick(Sender: TObject);
    procedure RebootBtnClick(Sender: TObject);
    procedure ShutdownBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function CheckPass:boolean;
    procedure ExitWindowsPriv(et:TExitType);
  public
    { Public declarations }
    procedure ExecuteProgram(fname,params:string;wShowWindow:word);
    procedure SetMasterPassword(s:string);
    procedure LoadSettings;
    procedure SaveSettings;
    procedure DoAutostart;
  end;

var
  MainForm: TMainForm;

const
  DefaultPass='secret';
  SysPassword:string=DefaultPass;
  ForceClose:boolean=false;
  ShellProfile:(spExplorer,spLockShell)=spExplorer;

implementation

uses OptWnd, PassWnd;

{$R *.dfm}


procedure TMainForm.ExecuteProgram(fname,params:string;wShowWindow:word);
var
  si:STARTUPINFO;
  pi:PROCESS_INFORMATION;
  p:string;
begin
  FillChar(si,SizeOf(si),0);
  FillChar(pi,SizeOf(pi),0);
  si.cb:=SizeOf(si);
  si.wShowWindow:=wShowWindow;
  p:=fname;
  if Pos(' ',p)>0 then p:='"'+p+'"';
  p:=p+' '+params+#0;
  CreateProcess(nil,@p[1],nil,nil,False,CREATE_DEFAULT_ERROR_MODE or
    CREATE_NEW_PROCESS_GROUP or NORMAL_PRIORITY_CLASS,nil,nil,si,pi);
end;

function TMainForm.CheckPass:boolean;
begin
  PassForm.PassEdit.Text:='';
  CheckPass:=false;
  if PassForm.ShowModal=mrOk then
  begin
    if PassForm.PassEdit.Text=SysPassword then
    begin
      CheckPass:=true;
      Exit;
    end else
      MessageBox(Handle,'Invalid password','LockShell',mb_Ok or mb_IconExclamation);
  end;
end;

procedure TMainForm.ExitWindowsPriv(et:TExitType);
var
  hToken:cardinal;
  tkp:TOKEN_PRIVILEGES;
  a,b:cardinal;
begin
  if not CheckPass then Exit;
  b:=EWX_REBOOT;
  case et of
    etLogoff: b:=EWX_LOGOFF;
    etReboot: b:=EWX_REBOOT;
    etShutdown: b:=EWX_SHUTDOWN;
  end;
  b:=b or EWX_FORCEIFHUNG;

  // Get a token for this process.
  if not OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,hToken) then
  begin
    MessageBox(Handle,'Unable to get shutdown privileges.','LockShell',mb_Ok or mb_IconExclamation);
    Exit;
  end;

  // Get the LUID for the shutdown privilege.
  LookupPrivilegeValue(nil,'SeShutdownPrivilege',tkp.Privileges[0].Luid);

  tkp.PrivilegeCount:=1;  // one privilege to set
  tkp.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;

  // Get the shutdown privilege for this process.
  AdjustTokenPrivileges(hToken,FALSE,tkp,0,nil,a);
  // Cannot test the return value of AdjustTokenPrivileges.
  if GetLastError<>ERROR_SUCCESS then
  begin
    MessageBox(Handle,'Unable to adjust shutdown privileges.','LockShell',mb_Ok or mb_IconExclamation);
    Exit;
  end;

  // Shut down the system and force all applications to close.
  ForceClose:=true;
  ExitWindowsEx(b,0);
end;

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  if CheckPass then
  begin
    ForceClose:=true;
    Close;
  end;
end;

procedure TMainForm.SetupBtnClick(Sender: TObject);
begin
  if not CheckPass then Exit;
  if ShellProfile=spExplorer then
    OptForm.ShellSelector.ItemIndex:=0
  else
    OptForm.ShellSelector.ItemIndex:=1;
  OptForm.UpdateExecList;
  OptForm.PassEdit1.Text:='';
  OptForm.PassEdit2.Text:='';
  if OptForm.ShowModal=mrOk then
  begin
    if OptForm.ShellSelector.ItemIndex=0 then
      ShellProfile:=spExplorer
    else
      ShellProfile:=spLockShell;
    SaveSettings;
  end;
end;

procedure TMainForm.LogoutBtnClick(Sender: TObject);
begin
  ExitWindowsPriv(etLogoff);
end;

procedure TMainForm.RebootBtnClick(Sender: TObject);
begin
  ExitWindowsPriv(etReboot);
end;

procedure TMainForm.ShutdownBtnClick(Sender: TObject);
begin
  ExitWindowsPriv(etShutdown);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ForceClose;
end;

procedure TMainForm.SetMasterPassword(s: string);
begin
  SysPassword:=s;
end;

procedure TMainForm.LoadSettings;
var
  R:TRegistry;
  s:string;
  i,cnt:integer;
begin
  // Load shell path and password
  R:=TRegistry.Create;
  s:='explorer.exe';
  try
    R.Access:=KEY_READ;
    R.RootKey:=HKEY_LOCAL_MACHINE;
    if R.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',False) then
    begin
      s:=LowerCase(R.ReadString('Shell'));
      SysPassword:=R.ReadString('LockShellPs');
      if SysPassword='' then SysPassword:=DefaultPass;
    end;
  finally
    R.Free;
  end;
  if ('"'+LowerCase(ParamStr(0))+'" -s')=s then
    ShellProfile:=spLockShell
  else
    ShellProfile:=spExplorer;

  // Load executable list
  SetLength(ExecItems,0);
  R:=TRegistry.Create;
  try
    R.Access:=KEY_READ;
    R.RootKey:=HKEY_CURRENT_USER;
    if R.OpenKey('\SOFTWARE\TScorp\LockShell\ExecList',False) then
    begin
      cnt:=R.ReadInteger('Count');
      SetLength(ExecItems,cnt);
      for i:=0 to cnt-1 do
      begin
        Str(i,s);
        s:=Trim(s);
        ExecItems[i].ProgTitle:=R.ReadString('Title_'+s);
        ExecItems[i].ProgName:=R.ReadString('Name_'+s);
        ExecItems[i].Params:=R.ReadString('Params_'+s);
        ExecItems[i].wndMode:=R.ReadInteger('Mode_'+s);
      end;
    end;
  finally
    R.Free;
  end;
end;

procedure TMainForm.SaveSettings;
var
  R:TRegistry;
  s:string;
  i,cnt:integer;
begin
  // Save shell path and password
  R:=TRegistry.Create;
  try
    R.Access:=KEY_READ or KEY_WRITE;
    R.RootKey:=HKEY_LOCAL_MACHINE;
    if R.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',False) then
    begin
      if ShellProfile=spLockShell then
        R.WriteString('Shell','"'+ParamStr(0)+'" -s')
      else
        R.WriteString('Shell','explorer.exe');
      R.WriteString('LockShellPs',SysPassword);
    end;
  finally
    R.Free;
  end;

  // Save executable list
  R:=TRegistry.Create;
  try
    R.Access:=KEY_READ or KEY_WRITE;
    R.RootKey:=HKEY_CURRENT_USER;
    if R.OpenKey('\SOFTWARE\TScorp\LockShell\ExecList',True) then
    begin
      cnt:=Length(ExecItems);
      R.WriteInteger('Count',cnt);
      for i:=0 to cnt-1 do
      begin
        Str(i,s);
        s:=Trim(s);
        R.WriteString('Title_'+s,ExecItems[i].ProgTitle);
        R.WriteString('Name_'+s,ExecItems[i].ProgName);
        R.WriteString('Params_'+s,ExecItems[i].Params);
        R.WriteInteger('Mode_'+s,ExecItems[i].wndMode);
      end;
    end;
    if R.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',True) then
      if ShellProfile=spLockShell then
        R.WriteInteger('DisableTaskMgr',1)
      else
        R.WriteInteger('DisableTaskMgr',0);
  finally
    R.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadSettings;
  if ParamStr(1)='-s' then
  begin
    // Executed in shell mode - activate locks and do autoexec.
    CreateMutex(nil,True,'Global\D458BE91-F342-4743-938F-B6AD9D392952');
    DoAutostart;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TMainForm.DoAutostart;
var
  i:integer;
begin
  for i:=Low(ExecItems) to High(ExecItems) do
    ExecuteProgram(ExecItems[i].ProgName,ExecItems[i].Params,ExecItems[i].wndMode);
end;

procedure TMainForm.FormActivate(Sender: TObject);
const
  fa:boolean=false;
begin
  if (not fa) then
  begin
    fa:=true;
    if ParamStr(1)='-s' then
    begin
      WindowState:=wsMinimized;
      CloseBtn.Enabled:=false;
    end;
  end;
end;

end.
