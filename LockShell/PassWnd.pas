unit PassWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TPassForm = class(TForm)
    PassEdit: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PassForm: TPassForm;

implementation

{$R *.dfm}

end.
