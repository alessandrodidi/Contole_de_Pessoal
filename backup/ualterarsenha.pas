unit UAlterarSenha;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, LCLType, ExtCtrls;

type

  { TfrmAlterarSenha }

  TfrmAlterarSenha = class(TForm)
    ckbxForcarTrocarSenha: TCheckBox;
    edtNovaSenha: TEdit;
    edtRepeteNovaSenha: TEdit;
    edtSenhaAtual: TEdit;
    lblNovaSenha: TLabel;
    lblSenhaAtual: TLabel;
    sbtnConfirmar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnMostarNovaSenha: TSpeedButton;
    sbtnMostarSenhaAtual: TSpeedButton;
    sqlqAltSenha: TSQLQuery;
    procedure ckbxForcarTrocarSenhaChange(Sender: TObject);
    procedure edtNovaSenhaKeyPress(Sender: TObject; var Key: char);
    procedure edtRepeteNovaSenhaKeyPress(Sender: TObject; var Key: char);
    procedure edtSenhaAtualKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnConfirmarClick(Sender: TObject);
    procedure sbtnMostarNovaSenhaMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sbtnMostarNovaSenhaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbtnMostarSenhaAtualMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sbtnMostarSenhaAtualMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    SenhaAtual, IDUsuAltSenha, UsuAltSenha, ForcarAltSenha: String;
    Editado: Boolean;
    const
      Modulo: String = 'SEGURANCA';
  public

  end;

var
  frmAlterarSenha: TfrmAlterarSenha;

implementation

uses
  UGFunc, UDBO;

{$R *.lfm}

{ TfrmAlterarSenha }

procedure TfrmAlterarSenha.sbtnMostarSenhaAtualMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if edtSenhaAtual.EchoMode = emPassword then
    edtSenhaAtual.EchoMode := emNormal;
end;

procedure TfrmAlterarSenha.sbtnMostarNovaSenhaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if edtNovaSenha.EchoMode = emPassword then
    edtNovaSenha.EchoMode := emNormal;
  if edtRepeteNovaSenha.EchoMode = emPassword then
    edtRepeteNovaSenha.EchoMode := emNormal;
end;

procedure TfrmAlterarSenha.sbtnConfirmarClick(Sender: TObject);
begin
  if (edtSenhaAtual.Text = EmptyStr)
     and (gModAltSenha = 'ALTSENHALAYOUT1') then
    begin
      Application.MessageBox(PChar('Informe a senha atual'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      edtSenhaAtual.SetFocus;
      Exit;
    end;
  if edtNovaSenha.Text = EmptyStr then
    begin
      Application.MessageBox(PChar('Informe a nova senha'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      edtNovaSenha.SetFocus;
      Exit;
    end;
  if edtRepeteNovaSenha.Text = EmptyStr then
    begin
      Application.MessageBox(PChar('Repita a nova senha'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      edtRepeteNovaSenha.SetFocus;
      Exit;
    end;
  if edtNovaSenha.Text <> edtRepeteNovaSenha.Text then
    begin
      Application.MessageBox(PChar('Os campos ''Nova senha'' e ''Repita a nova senha'' devem conter o mesmo valor'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      Clean([edtRepeteNovaSenha]);
      edtRepeteNovaSenha.SetFocus;
      Exit;
    end;
  if (edtSenhaAtual.Text <> SenhaAtual)
     and (gModAltSenha = 'ALTSENHALAYOUT1') then
    begin
      Application.MessageBox(PChar('Senha incorreta!'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      edtSenhaAtual.SetFocus;
      Exit;
    end;
  if (((edtNovaSenha.Text = SenhaAtual))
      and ((gModAltSenha = 'ALTSENHALAYOUT1')
           or (gModAltSenha = 'ALTSENHALAYOUT2'))) then
    begin
      Application.MessageBox(PChar('A nova senha deve ser diferente da senha atual'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      edtNovaSenha.SetFocus;
      Exit;
    end;

  if ckbxForcarTrocarSenha.Checked then
    ForcarAltSenha := '1'
  else
    ForcarAltSenha := '0';
  SQLExec(sqlqAltSenha,['UPDATE g_usuarios SET',
                            'senha = '''+edtNovaSenha.Text+''',resetar_senha_prox_login = '''+ForcarAltSenha+'''',
                            'WHERE id_usuario = '+IDUsuAltSenha]);
  if IDUsuAltSenha <> gID_Usuario_Logado then
     Log(LowerCase(Modulo),'alterar senha','alterar senha de usuário',IDUsuAltSenha,gID_Usuario_Logado,gUsuario_Logado,'<<alterou a senha do usuário '+IDUsuAltSenha+'-'+UsuAltSenha+'>>');
  Editado := False;
  gSenha_Login_Alterada := True;
  CleanForm(Self);
  Application.MessageBox(PChar('A senha foi alterada com sucesso'), 'Aviso', MB_ICONINFORMATION + MB_OK);
  Self.Close;
end;

procedure TfrmAlterarSenha.FormShow(Sender: TObject);
begin
  if (gModAltSenha = 'ALTSENHALAYOUT3')
     and (not CheckPermission(UserPermissions,Modulo,'SEGUSALTSEN')) then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  Editado := False;
  if gModAltSenha = 'ALTSENHALAYOUT1' then
      begin
        IDUsuAltSenha := gID_Usuario_Logado;
        lblSenhaAtual.Visible := True;
        edtSenhaAtual.Visible := True;
        sbtnMostarSenhaAtual.Visible := True;
        ckbxForcarTrocarSenha.Visible := False;
        edtSenhaAtual.SetFocus;
      end
  else
  if gModAltSenha = 'ALTSENHALAYOUT2' then
      begin
        IDUsuAltSenha := gID_Usuario_Logado;
        lblSenhaAtual.Visible := False;
        edtSenhaAtual.Visible := False;
        sbtnMostarSenhaAtual.Visible := False;
        lblNovaSenha.Top := 14;
        edtNovaSenha.Top := 10;
        sbtnMostarNovaSenha.Top := 9;
        edtRepeteNovaSenha.Top := 41;
        ckbxForcarTrocarSenha.Visible := False;
        sbtnConfirmar.Top := 94;
        sbtnCancelar.Top := 94;
        Self.Height := 127;
        edtNovaSenha.SetFocus;
      end
    else
    if gModAltSenha = 'ALTSENHALAYOUT3' then
      begin
        IDUsuAltSenha := gID_Usuario_Selecionado;
        lblSenhaAtual.Visible := False;
        edtSenhaAtual.Visible := False;
        sbtnMostarSenhaAtual.Visible := False;
        lblNovaSenha.Top := 14;
        edtNovaSenha.Top := 10;
        sbtnMostarNovaSenha.Top := 9;
        edtRepeteNovaSenha.Top := 41;
        ckbxForcarTrocarSenha.Visible := True;
        edtNovaSenha.SetFocus;
      end;

  SQLQuery(sqlqAltSenha,['SELECT id_usuario, usuario, senha, nome, resetar_senha_prox_login',
                        'FROM g_usuarios',
                        'WHERE id_usuario = '''+IDUsuAltSenha+'''']);
  SenhaAtual := sqlqAltSenha.FieldByName('senha').text;
  UsuAltSenha := sqlqAltSenha.FieldByName('usuario').text;
end;

procedure TfrmAlterarSenha.sbtnCancelarClick(Sender: TObject);
begin
  if Editado then
    begin
      if Application.MessageBox(PChar('Deseja cancelar a alteração da senha'),'Confirmação', MB_ICONQUESTION + MB_OKCANCEL) = MROK then
        begin
          CleanForm(Self);
          Self.Close;
        end
      else
        Abort;
    end
  else
    Self.Close;
end;

procedure TfrmAlterarSenha.edtSenhaAtualKeyPress(Sender: TObject; var Key: char
  );
begin
  Editado := True;
end;

procedure TfrmAlterarSenha.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnConfirmar.Click;
end;

procedure TfrmAlterarSenha.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    begin
      if ActiveControl.Name = 'edtRepeteNovaSenha' then
        sbtnConfirmar.Click
      else
        begin
          Key := #0;
          SelectNext(ActiveControl,True,True);
        end;
    end;
  if Key = #27 then
    begin
      sbtnCancelar.Click;
    end;
end;


procedure TfrmAlterarSenha.edtNovaSenhaKeyPress(Sender: TObject; var Key: char);
begin
  Editado := True;
end;

procedure TfrmAlterarSenha.ckbxForcarTrocarSenhaChange(Sender: TObject);
begin

end;

procedure TfrmAlterarSenha.edtRepeteNovaSenhaKeyPress(Sender: TObject;
  var Key: char);
begin
  Editado := True;
end;

procedure TfrmAlterarSenha.sbtnMostarNovaSenhaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if edtNovaSenha.EchoMode = emNormal then
    edtNovaSenha.EchoMode := emPassword;
  if edtRepeteNovaSenha.EchoMode = emNormal then
    edtRepeteNovaSenha.EchoMode := emPassword;
end;

procedure TfrmAlterarSenha.sbtnMostarSenhaAtualMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if edtSenhaAtual.EchoMode = emNormal then
    edtSenhaAtual.EchoMode := emPassword;
end;

end.

