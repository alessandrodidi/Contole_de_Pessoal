unit UCopiarPermissoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, LCLType, ExtCtrls,
  PairSplitter, Buttons, ComCtrls;

type

  { TfrmCopiarPermissoes }

  TfrmCopiarPermissoes = class(TForm)
    lstvwUsuarioOrigem: TListView;
    lstvwUsuarioDestino: TListView;
    pnlEsqTitulo: TPanel;
    pnlDirTitulo: TPanel;
    pstConteudo: TPairSplitter;
    pstsEsquerdo: TPairSplitterSide;
    pstsDireito: TPairSplitterSide;
    pnlComandosOper: TPanel;
    pnlComandos: TPanel;
    sbtnCopiar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnAtualizar: TSpeedButton;
    procedure CopiarPermissoes(IDUsuarioOrigem, UsuarioOrigem, IDUsuarioDestino, UsuarioDestino: String);
    procedure Atualizar;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lstvwUsuarioOrigemCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnCopiarClick(Sender: TObject);
  private
    IDUsuarioOrigem, UsuarioOrigem: String;
  public
    IDUsuario, Usuario: String;
    PermAutoEditUser: Boolean;
  end;

var
  frmCopiarPermissoes: TfrmCopiarPermissoes;

implementation

uses
  UGFunc, UConexao, UDBO;

{$R *.lfm}

procedure TfrmCopiarPermissoes.CopiarPermissoes(IDUsuarioOrigem, UsuarioOrigem, IDUsuarioDestino, UsuarioDestino: String);
begin
  try
    if IDUsuarioOrigem = EmptyStr then
      begin
        Application.MessageBox('Informe o usuário de origem para copiar as permissões','Aviso', MB_ICONWARNING + MB_OK);
        Exit;
      end;
    if IDUsuarioDestino = EmptyStr then
      begin
        Application.MessageBox('Informe o usuário de destino para copiar as permissões','Aviso', MB_ICONWARNING + MB_OK);
        Exit;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar copiar as permissões de '''''+UsuarioOrigem+''''' para '''''+UsuarioDestino+''''''+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmCopiarPermissoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    Atualizar;
end;

procedure TfrmCopiarPermissoes.lstvwUsuarioOrigemCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if ((PermAutoEditUser = False)
      and (Item.Caption = gID_Usuario_Logado)) then
    Sender.Canvas.Font.Color := clMaroon
  else
    if ((Sender.Items.Item[Item.Index].SubItems.Count > 0)
        and (Item.SubItems[2] = 'False')) then
      Sender.Canvas.Font.Color := clGray
    else
      Sender.Canvas.Font.Color := clDefault;
end;

procedure TfrmCopiarPermissoes.sbtnAtualizarClick(Sender: TObject);
begin
  Atualizar;
end;

procedure TfrmCopiarPermissoes.sbtnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCopiarPermissoes.sbtnCopiarClick(Sender: TObject);
begin
  CopiarPermissoes(IDUsuarioOrigem,UsuarioOrigem,IDUsuario,Usuario);
end;

procedure TfrmCopiarPermissoes.Atualizar;
begin
  try
    Self.Cursor := crHourGlass;
    //Carrega a lista de usuários
    Self.Cursor := crSQLWait;
    {SQLExec(sqlqUsuarios,['SELECT id_usuario, usuario, id_pessoa, nome, status, resetar_senha_prox_login, modo_autenticacao'
                         ,'FROM g_usuarios'
                         ,'ORDER BY usuario']);
    Self.Cursor := crHourGlass;
    if lstvwUsuarios.SelCount > 0 then
       lstvwUsuarios.Items.Item[lstvwUsuarios.Selected.Index].Selected := False;
    ID_Usuario_Selecionado := EmptyStr;
    lstvwUsuarios.Clear;

    sqlqUsuarios.First;
    while not sqlqUsuarios.EOF do
      begin
        item := lstvwUsuarios.Items.Add;
        item.Caption := sqlqUsuarios.FieldByName('id_usuario').Text;
        item.SubItems.Add(sqlqUsuarios.FieldByName('usuario').Text);
        item.SubItems.Add(sqlqUsuarios.FieldByName('modo_autenticacao').Text);
        item.SubItems.Add(sqlqUsuarios.FieldByName('status').Text);  }
    Self.Cursor := crDefault;
  except on E: exception do
    begin
      Self.Cursor := crDefault;
      Application.MessageBox(PChar('Falha ao tentar carregar os dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message)
                            ,'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

end.

