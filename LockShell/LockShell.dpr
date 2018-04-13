program LockShell;

uses
  Forms,
  MainWnd in 'MainWnd.pas' {MainForm},
  OptWnd in 'OptWnd.pas' {OptForm},
  PassWnd in 'PassWnd.pas' {PassForm},
  AutoWnd in 'AutoWnd.pas' {AutoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Lock Shell';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOptForm, OptForm);
  Application.CreateForm(TPassForm, PassForm);
  Application.CreateForm(TAutoForm, AutoForm);
  Application.Run;
end.
