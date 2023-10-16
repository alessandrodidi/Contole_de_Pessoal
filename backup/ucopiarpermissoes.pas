unit UCopiarPermissoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, LCLType,
  ExtCtrls, PairSplitter, Buttons, ComCtrls, ShellCtrls;

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
    sqlqUsuariosOrigem: TSQLQuery;
    sqlqUsuariosDestino: TSQLQuery;
    procedure CopiarPermissoes(IDUsuarioOrigem, UsuarioOrigem, IDUsuarioDestino, UsuarioDestino: String);
    procedure Atualizar;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure lstvwUsuarioDestinoCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstvwUsuarioDestinoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvwUsuarioDestinoSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lstvwUsuarioOrigemCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstvwUsuarioOrigemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnCopiarClick(Sender: TObject);
  private
    IDUsuarioOrigem, UsuarioOrigem, IDUsuarioDestino, UsuarioDestino: String;
  public
    IDUsuario, Usuario, Tipo: String;
    PermAutoEditUser: Boolean;
  end;

var
  frmCopiarPermissoes: TfrmCopiarPermissoes;

implementation

uses
  UGFunc, UConexao, UDBO;

{$R *.lfm}

procedure TfrmCopiarPermissoes.CopiarPermissoes(IDUsuarioOrigem, UsuarioOrigem, IDUsuarioDestino, UsuarioDestino: String);
var
  i,j: Integer;
begin
  try
    if lstvwUsuarioOrigem.SelCount = 0 then
      begin
        Application.MessageBox('Informe o usuário de origem para copiar as permissões'
                              ,'Aviso'
                              ,MB_ICONWARNING + MB_OK);
        Exit;
      end;
    if lstvwUsuarioDestino.SelCount = 0 then
      begin
        Application.MessageBox('Informe o usuário de destino para copiar as permissões'
                              ,'Aviso'
                              ,MB_ICONWARNING + MB_OK);
        Exit;
      end;
    for i:=0 to lstvwUsuarioOrigem.SelCount-1 do
      begin
        //if lstvwUsuarioOrigem.Items.Item[i].Selected then
          //showMessage(lstvwUsuarioOrigem.Items.Item[i].Caption);
          showMessage(lstvwUsuarioOrigem.Selected.Caption);
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

procedure TfrmCopiarPermissoes.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TfrmCopiarPermissoes.FormShow(Sender: TObject);
begin
  if Tipo = 'DE' then
    begin
      Self.Caption := 'Copiar permissões de "'+Usuario+'"';
      IDUsuarioOrigem := IDUsuario;
    end
  else if Tipo = 'PARA' then
    begin
      Self.Caption := 'Copiar permissões para "'+Usuario+'"';
      IDUsuarioDestino := IDUsuario;
    end;

  Atualizar;
end;

procedure TfrmCopiarPermissoes.lstvwUsuarioDestinoCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if ((PermAutoEditUser = False)
      and (Item.Caption = gID_Usuario_Logado)) then
    Sender.Canvas.Font.Color := clMaroon
  else
    if ((Sender.Items.Item[Item.Index].SubItems.Count > 0)
        and (Item.SubItems[1] = 'False')) then
      Sender.Canvas.Font.Color := clGray
    else
      Sender.Canvas.Font.Color := clDefault;
end;

procedure TfrmCopiarPermissoes.lstvwUsuarioDestinoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = VK_A) then
    SelectAll(lstvwUsuarioDestino);
end;

procedure TfrmCopiarPermissoes.lstvwUsuarioDestinoSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if ((PermAutoEditUser = false)
      and (Item.Caption = gID_Usuario_Logado)) then
    begin
      Item.Selected := False;
      Abort;
    end;
end;

procedure TfrmCopiarPermissoes.lstvwUsuarioOrigemCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if ((Sender.Items.Item[Item.Index].SubItems.Count > 0)
      and (Item.SubItems[1] = 'False')) then
    Sender.Canvas.Font.Color := clGray
  else
    Sender.Canvas.Font.Color := clDefault;
end;

procedure TfrmCopiarPermissoes.lstvwUsuarioOrigemKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = VK_A) then
    SelectAll(lstvwUsuarioOrigem);
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
var
  ParamUsuarioOrigem, ParamUsuarioDestino: String;
  item1, item2: TListItem;
begin
  try
    Self.Cursor := crHourGlass;
    case Tipo of
      'DE':
        begin
          ParamUsuarioOrigem := 'id_usuario = '+IDUsuarioOrigem;
          ParamUsuarioDestino := '1=1';
        end;
      'PARA':
        begin
          ParamUsuarioOrigem := '1=1';
          ParamUsuarioDestino := 'id_usuario = '+IDUsuarioDestino;
        end;
      else
        begin
          ParamUsuarioOrigem := '1=1';
          ParamUsuarioDestino := '1=1'
        end;
    end;
    //Carrega a lista de usuários de origem
    Self.Cursor := crSQLWait;
    SQLQuery(sqlqUsuariosOrigem,['SELECT id_usuario, usuario, id_pessoa, nome, status, resetar_senha_prox_login, modo_autenticacao'
                                ,'FROM g_usuarios'
                                ,'WHERE '+ParamUsuarioOrigem
                                ,'ORDER BY usuario']);

    //Carrega a lista de usuários de destino
    SQLQuery(sqlqUsuariosDestino,['SELECT id_usuario, usuario, id_pessoa, nome, status, resetar_senha_prox_login, modo_autenticacao'
                                 ,'FROM g_usuarios'
                                 ,'WHERE '+ParamUsuarioDestino
                                 ,'ORDER BY usuario']);

    Self.Cursor := crHourGlass;
    //Carrega a lista de usuários de origem no listview
    if lstvwUsuarioOrigem.SelCount > 0 then
       lstvwUsuarioOrigem.Items.Item[lstvwUsuarioOrigem.Selected.Index].Selected := False;
    //ID_Usuario_Selecionado := EmptyStr;
    lstvwUsuarioOrigem.Clear;

    sqlqUsuariosOrigem.First;
    while not sqlqUsuariosOrigem.EOF do
      begin
        item1 := lstvwUsuarioOrigem.Items.Add;
        item1.Caption := sqlqUsuariosOrigem.FieldByName('id_usuario').Text;
        item1.SubItems.Add(sqlqUsuariosOrigem.FieldByName('usuario').Text);
        item1.SubItems.Add(sqlqUsuariosOrigem.FieldByName('status').Text);

        sqlqUsuariosOrigem.Next;
      end;

    //Carrega a lista de usuários de destino no listview
    if lstvwUsuarioDestino.SelCount > 0 then
       lstvwUsuarioDestino.Items.Item[lstvwUsuarioDestino.Selected.Index].Selected := False;
    lstvwUsuarioDestino.Clear;

    sqlqUsuariosDestino.First;
    while not sqlqUsuariosDestino.EOF do
      begin
        item2 := lstvwUsuarioDestino.Items.Add;
        item2.Caption := sqlqUsuariosDestino.FieldByName('id_usuario').Text;
        item2.SubItems.Add(sqlqUsuariosDestino.FieldByName('usuario').Text);
        item2.SubItems.Add(sqlqUsuariosDestino.FieldByName('status').Text);

        sqlqUsuariosDestino.Next;
      end;

    //Seleciona o usuário na listview caso indicado
    case Tipo of
      'DE':
        begin
          lstvwUsuarioOrigem.Items[0].Selected := True;
          lstvwUsuarioOrigem.Selected.MakeVisible(True);
        end;
      'PARA':
        begin
          lstvwUsuarioDestino.Items[0].Selected := True;
          lstvwUsuarioDestino.Selected.MakeVisible(True);
        end;
      end;

    Self.Cursor := crDefault;
  except on E: exception do
    begin
      Self.Cursor := crDefault;
      Application.MessageBox(PChar('Falha ao tentar carregar os dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmCopiarPermissoes.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAllFormOpenedConnections(Self);
end;

end.
