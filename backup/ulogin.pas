unit ULogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType,
  Buttons;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    cbBanco: TComboBox;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    lblRecuperarSenha: TLabel;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    lblBanco: TLabel;
    sbtnOk: TSpeedButton;
    sqlqLogin: TSQLQuery;
    sqlqPermissoes: TSQLQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblRecuperarSenhaClick(Sender: TObject);
    procedure lblRecuperarSenhaMouseEnter(Sender: TObject);
    procedure lblRecuperarSenhaMouseLeave(Sender: TObject);
    procedure lblRecuperarSenhaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbtnOkClick(Sender: TObject);
  private

  public

  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  UGFunc, UDBO, UConexao, UINIFiles, UPrincipal;

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  AppTerminate;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
   Begin
     if ((ActiveControl.Name = 'edtSenha') and (cbBanco.Text <> EmptyStr)) then
       sbtnOk.Click
     else
       begin
         Key := #0;
         SelectNext(ActiveControl,True,True);
       end;
   end;
end;

procedure TfrmLogin.FormPaint(Sender: TObject);
begin
  //Self.BringToFront;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  Self.BringToFront;
  Self.SetFocus;
  cbBanco.Items := ListIniSection(ReadIni('config.ini','DatabaseSettings','DatabaseFile'));
  cbBanco.ItemIndex := cbBanco.Items.IndexOf(ReadIni('pref.ini','Database','DatabaseName')); //%AppData%\SysAgro\preferences.ini
  edtUsuario.Text := ReadIni('pref.ini','Login','UserName');
  if edtUsuario.Text = EmptyStr then
     edtUsuario.SetFocus
  else
    edtSenha.SetFocus;
end;

procedure TfrmLogin.lblRecuperarSenhaClick(Sender: TObject);
begin
  Application.MessageBox(PChar('Esta função não está disponível no momento'),'Aviso', MB_ICONINFORMATION + MB_OK);
end;

procedure TfrmLogin.lblRecuperarSenhaMouseEnter(Sender: TObject);
begin
  lblRecuperarSenha.Cursor := crHandPoint;
  lblRecuperarSenha.Font.Color := clHotLight;
end;

procedure TfrmLogin.lblRecuperarSenhaMouseLeave(Sender: TObject);
begin
  lblRecuperarSenha.Cursor := crDefault;
  lblRecuperarSenha.Font.Color := clGrayText;
end;

procedure TfrmLogin.lblRecuperarSenhaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TfrmLogin.sbtnOkClick(Sender: TObject);
begin
  WriteIni('pref.ini','Database','DatabaseName',cbBanco.Text); //%AppData%\SysAgro\preferences.ini
  WriteIni('pref.ini','Login','UserName',edtUsuario.Text);
  ConnStart(dmConexao.ConexaoDB, dmConexao.SQLDBLibraryLoader,'config.ini','pref.ini');
  Login(Self, cbBanco, edtUsuario, edtSenha, dmConexao.ConexaoDB, sqlqLogin, sqlqPermissoes);
end;

end.

