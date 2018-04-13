unit AutoWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TAutoForm = class(TForm)
    TitleEdt: TLabeledEdit;
    ProgramEdt: TLabeledEdit;
    ParamsEdt: TLabeledEdit;
    WindowModeLst: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    OpenProgDlg: TButton;
    OpenExecDlg: TOpenDialog;
    procedure OpenProgDlgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoForm: TAutoForm;

implementation

{$R *.dfm}

procedure TAutoForm.OpenProgDlgClick(Sender: TObject);
begin
  if OpenExecDlg.Execute then
    ProgramEdt.Text:=OpenExecDlg.FileName;
end;

end.
