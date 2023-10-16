unit UUsuarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, PairSplitter, Buttons, LCLType,
  LCLIntf, Menus, StrUtils;

type

  { TfrmUsuarios }

  TfrmUsuarios = class(TForm)
    Bevel1: TBevel;
    ckbxResetSenha: TCheckBox;
    ckbxStatus: TCheckBox;
    cbModoAutenticacao: TComboBox;
    edtIDPessoa: TEdit;
    edtPesquisar: TEdit;
    edtSenha: TEdit;
    edtNome: TEdit;
    edtIDUsuario: TEdit;
    edtUsuario: TEdit;
    gpbxUsuario: TGroupBox;
    imglCheckBoxTreeView: TImageList;
    lblIDPessoa: TLabel;
    lblModoAutenticacao: TLabel;
    lblSenha: TLabel;
    lblNome: TLabel;
    lblIDUsuario: TLabel;
    lblUsuario: TLabel;
    lstvwPerfisAtribuidos: TListView;
    lstvwPerfisAcesso: TListView;
    lstvwUsuarios: TListView;
    mniCopiarPara: TMenuItem;
    mniCopiarDe: TMenuItem;
    mniRevogarTodosPerfis: TMenuItem;
    mniSelAllPerfisAtribuidos: TMenuItem;
    mniAtribuirTodosPerfis: TMenuItem;
    mniSelAllPerfis: TMenuItem;
    mniCopiarPermissoes: TMenuItem;
    pnlBotoesSelecao: TPanel;
    pnlPerfisAtribuidosTitulo: TPanel;
    pnlPerfisSelecionados: TPanel;
    pnlPerfisTitulo: TPanel;
    pnlComandosSelecao: TPanel;
    pnlPerfisSelecao: TPanel;
    pnlPerfisAcesso: TPanel;
    pnlPerfisDirComandos: TPanel;
    pnlTituloPerfisAcesso: TPanel;
    pnlPerfisAcessoGeral: TPanel;
    pnlPermissoes: TPanel;
    pmnPerfis: TPopupMenu;
    pmnPerfisAtribuidos: TPopupMenu;
    pmnCopiarPermissoes: TPopupMenu;
    pstPermissoes: TPairSplitter;
    pstsPerfis: TPairSplitterSide;
    pstsPermissoes: TPairSplitterSide;
    sbtnAtribuirSelecionados: TSpeedButton;
    sbtnRevogarSelecionados: TSpeedButton;
    sbtnRevogarTodos: TSpeedButton;
    Separator1: TMenuItem;
    mniDeselecionarTodosItens: TMenuItem;
    mniSelecionarTodosItens: TMenuItem;
    LN1: TMenuItem;
    mniDeselecionarTudo: TMenuItem;
    mniSelecionarTudo: TMenuItem;
    mniPermissoes: TMenuItem;
    mniDelUsuario: TMenuItem;
    H2: TMenuItem;
    mniAlterarSenha: TMenuItem;
    mniAtivarDesativaUsuario: TMenuItem;
    mniEditUsuario: TMenuItem;
    mniAddUsuario: TMenuItem;
    H1: TMenuItem;
    pnlPermissoesDirComandos: TPanel;
    pnlPermissoesEsqTitulo: TPanel;
    pnlBasePermissoes: TPanel;
    pmnUsuarios: TPopupMenu;
    pmnPermissoes: TPopupMenu;
    pnlComandosOper: TPanel;
    pnlEsqTitulo: TPanel;
    pstConteudo: TPairSplitter;
    pstsEsquerdo: TPairSplitterSide;
    pstsDireito: TPairSplitterSide;
    pnlComandos: TPanel;
    sbtnCancelar: TSpeedButton;
    sbtnEditUsuario: TSpeedButton;
    sbtnDelUsuario: TSpeedButton;
    sbtnAtualizar: TSpeedButton;
    sbtnAddUsuario: TSpeedButton;
    sbtnAlterarSenha: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnMostarSenha: TSpeedButton;
    sbtnPermissoesExpandirTudo: TSpeedButton;
    sbtnPermissoesRecolherTudo: TSpeedButton;
    sbtnPesquisar: TSpeedButton;
    sbtnEditarPermissoes: TSpeedButton;
    sbtnCopiarPermissoes: TSpeedButton;
    sbtnAtribuirTodos: TSpeedButton;
    sbtnVisualizarPermissoes: TSpeedButton;
    sbtnLocalizarPessoa: TSpeedButton;
    sqlqBasePermissoes: TSQLQuery;
    sqlqPermissoesUsuario: TSQLQuery;
    sqlqPermissoesUsuariosOperacoes: TSQLQuery;
    sqlqPerfisAcesso: TSQLQuery;
    sqlqPerfisAcessoAtribuidos: TSQLQuery;
    sqlqConsPessoa: TSQLQuery;
    sqlqUsuariosOperacao: TSQLQuery;
    sqlqUsuarios: TSQLQuery;
    tvPermissoes: TTreeView;
    procedure edtIDPessoaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvwPerfisAcessoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvwPerfisAtribuidosCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstvwPerfisAtribuidosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvwPerfisAtribuidosSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
    procedure lstvwPerfisAcessoCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstvwPerfisAcessoSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lstvwUsuariosCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure mniAtribuirTodosPerfisClick(Sender: TObject);
    procedure mniCopiarDeClick(Sender: TObject);
    procedure mniCopiarParaClick(Sender: TObject);
    procedure mniRevogarTodosPerfisClick(Sender: TObject);
    procedure mniSelAllPerfisAtribuidosClick(Sender: TObject);
    procedure mniSelAllPerfisClick(Sender: TObject);
    procedure pmnCopiarPermissoesPopup(Sender: TObject);
    procedure pnlComandosSelecaoResize(Sender: TObject);
    procedure pstsPerfisResize(Sender: TObject);
    procedure sbtnAtribuirSelecionadosClick(Sender: TObject);
    procedure sbtnAtribuirTodosClick(Sender: TObject);
    procedure sbtnCopiarPermissoesClick(Sender: TObject);
    procedure sbtnCopiarPermissoesMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sbtnLocalizarPessoaClick(Sender: TObject);
    procedure sbtnRevogarSelecionadosClick(Sender: TObject);
    procedure sbtnRevogarTodosClick(Sender: TObject);
    procedure sbtnVisualizarPermissoesClick(Sender: TObject);
    procedure SelParentNode(Node: TTreeNode);
    procedure cbModoAutenticacaoSelect(Sender: TObject);
    procedure ckbxResetSenhaChange(Sender: TObject);
    procedure edtNomeKeyPress(Sender: TObject; var Key: char);
    procedure edtPesquisarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSenhaChange(Sender: TObject);
    procedure edtUsuarioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure defaultView;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure lstvwUsuariosDblClick(Sender: TObject);
    procedure lstvwUsuariosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvwUsuariosSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure mniDeselecionarTodosItensClick(Sender: TObject);
    procedure mniDeselecionarTudoClick(Sender: TObject);
    procedure mniEditUsuarioClick(Sender: TObject);
    procedure mniPermissoesClick(Sender: TObject);
    procedure mniAddUsuarioClick(Sender: TObject);
    procedure mniAlterarSenhaClick(Sender: TObject);
    procedure mniAtivarDesativaUsuarioClick(Sender: TObject);
    procedure mniDelUsuarioClick(Sender: TObject);
    procedure mniSelecionarTodosItensClick(Sender: TObject);
    procedure mniSelecionarTudoClick(Sender: TObject);
    procedure pmnPermissoesPopup(Sender: TObject);
    procedure pmnUsuariosPopup(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnAlterarSenhaClick(Sender: TObject);
    procedure sbtnEditarPermissoesClick(Sender: TObject);
    procedure sbtnPermissoesExpandirTudoClick(Sender: TObject);
    procedure sbtnPesquisarClick(Sender: TObject);
    procedure sbtnPermissoesRecolherTudoClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnAddUsuarioClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnDelUsuarioClick(Sender: TObject);
    procedure sbtnEditUsuarioClick(Sender: TObject);
    procedure sbtnMostarSenhaClick(Sender: TObject);
    procedure AtivarDesativarUsuario(idUsuario: String);
    procedure SelecionarModoAutenticacao(Modo: String);
    procedure CheckNode(Node: TTreeNode; Checked: Boolean);
    procedure ToggleTreeViewCheckBoxes(Node: TTreeNode);
    procedure ToggleTreeViewCheckBoxes(Node: TTreeNode; Checked: Boolean);
    function NodeChecked(ANode:TTreeNode): Boolean;
    procedure tvPermissoesClick(Sender: TObject);
    procedure setPermission(Node: TTreeNode);
    procedure AcaoPerfilAcesso(IDPerfilAcesso, AcaoRequisitada: String);
    function CheckPermissao(ID_Usuario, DescPermissao: String): Boolean;
    function BlockEditPermissao(ID_Usuario, DescPermissao: String): Boolean;
    procedure tvPermissoesCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure tvPermissoesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvPermissoesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function IDNode(TreeView: TTreeView): Integer;
    procedure SelAllChildNodes(Node: TTreeNode; CheckUncheck: Integer);
    procedure CarregarPessoa(ID: String);
    procedure mniCopiarPermissoesClick(Sender: TObject);
    procedure CopiarPermissoes;
    procedure CopiarPermissoes(IDUsuario, Usuario, Tipo: String);
    procedure mniCopiarPermissoesDeClick(Sender: TObject);
    procedure mniCopiarPermissoesParaClick(Sender: TObject);
  private
    Acao, ModoAutenticacao, ModoAutenticacaoAtual, ModoVincPessoa: String;
    Editado, PermMultUser, PermAutoEditUser, ParamVincPessoa: Boolean;
    PermissoesTemp, PerfisAcessoTemp, PermissoesUsuario: Array of Array of String;
    FoundResult: Integer;
    const
      Modulo: String = 'SEGURANCA';
      TitPerm: String = 'Permissões';
      tvImgChecked = 0;   // Image index of checked icon
      tvImgUnchecked = 1;  // Image index of unchecked icon
  public
    ID_Usuario_Selecionado, Usuario_Selecionado, ID_PerfilAcesso_Selecionado: String;
    Index_Novo_Usuario: Integer;
  end;

var
  frmUsuarios: TfrmUsuarios;

implementation

uses
  UGFunc, UConexao, UDBO, UAlterarSenha, UPerfisUsuarios, UPesquisar, UCopiarPermissoes;

{$R *.lfm}

{ TfrmUsuarios }

procedure TfrmUsuarios.sbtnAtualizarClick(Sender: TObject);
var
  item,item2,item3: TListItem;
  N1, N2, N3, i: Integer;
begin
  try
    Self.Cursor := crHourGlass;
    //Carrega a lista de usuários
    //sbtnCancelar.Click;
    Self.Cursor := crSQLWait;
    SQLExec(sqlqUsuarios,['SELECT id_usuario, usuario, id_pessoa, nome, status, resetar_senha_prox_login, modo_autenticacao'
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
        item.SubItems.Add(sqlqUsuarios.FieldByName('status').Text);

        sqlqUsuarios.Next;
      end;

    //Carrega os perfis de acesso
    if CheckPermission(UserPermissions,Modulo,'SEGPUACS') then
      begin
        SQLQuery(sqlqPerfisAcesso,['SELECT id_perfil_acesso, perfil, detalhe, status, excluido'
                                  ,'FROM g_perfis_acesso'
                                  ,'WHERE excluido = false'
                                  //,'     AND id_perfil_acesso NOT IN (SELECT U.id_perfil_acesso'
                                  //,'                                  FROM g_usuarios_perfis_acessos U'
                                  //,'                                  WHERE U.id_usuario = '''+ID_Usuario_Selecionado+''''
                                  //,'                                       AND U.excluido = false)'
                                  ,'ORDER BY perfil']);

        if lstvwPerfisAcesso.SelCount > 0 then
          lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.Selected.Index].Selected := False;
        ID_PerfilAcesso_Selecionado := EmptyStr;
        lstvwPerfisAcesso.Clear;
        lstvwPerfisAtribuidos.Clear;

        //Monta e define o tamanho da matriz temporária
        SetLength(PerfisAcessoTemp,sqlqPerfisAcesso.RecordCount,3);
        i := 0;  //Zera o contador

        sqlqPerfisAcesso.First; //Coloca o ponteiro no primeiro registro
        while not sqlqPerfisAcesso.EOF do
          begin
            //Preenche os dados no listview
            item2 := lstvwPerfisAcesso.Items.Add;
            item2.Caption := sqlqPerfisAcesso.FieldByName('id_perfil_acesso').Text;
            item2.SubItems.Add(sqlqPerfisAcesso.FieldByName('perfil').Text);
            item2.SubItems.Add(sqlqPerfisAcesso.FieldByName('status').Text);

            //Preenche os dados da matriz temporária
            PerfisAcessoTemp[i,0] := sqlqPerfisAcesso.FieldByName('id_perfil_acesso').Text; //Preenche id do perfil
            PerfisAcessoTemp[i,1] := ''; //Limpa o marcador que identifica se o perfil está atribuído para o usuário (vazio = não atribuído / A = atribuido)
            PerfisAcessoTemp[i,2] := ''; //Limpa o marcador de evento da permissão (vazio = sem modificação / I = incluir / E = excluir)

            sqlqPerfisAcesso.Next;
            i := i+1; //Incrementa o contador
          end;
      end
    else
      begin
        lstvwPerfisAcesso.Clear;
        item2 := lstvwPerfisAcesso.Items.Add;
        item2.Caption := '0';
        item2.SubItems.Add('Você não possui acesso para esta funcionalidade');
        item2.SubItems.Add('0');
        lstvwPerfisAcesso.Enabled := False;

        lstvwPerfisAtribuidos.Clear;
        item3 := lstvwPerfisAtribuidos.Items.Add;
        item3.Caption := '0';
        item3.SubItems.Add('Você não possui acesso para esta funcionalidade');
        item3.SubItems.Add('0');
        lstvwPerfisAtribuidos.Enabled := False;
      end;

    //Carrega a lista de permissões
    if CheckPermission(UserPermissions,Modulo,'SEGPMACS') then
      begin
        //tvPermissoes.Enabled := False;
        tvPermissoes.Visible := True;
        sbtnPermissoesExpandirTudo.Enabled := True;
        sbtnPermissoesRecolherTudo.Enabled := True;

        Self.Cursor := crSQLWait;
        //Consulta base das permissões
        SQLQuery(sqlqBasePermissoes,['SELECT id_permissao, classificacao, modulo, cod_permissao, descricao, nivel'
                                    ,'FROM g_base_permissoes'
                                    ,'ORDER BY classificacao']);
        Self.Cursor := crHourGlass;

        if ((Acao <> 'EDITAR')
            or (Acao <> 'EDITAR_PERMISSOES')) then
          begin
            tvPermissoes.Items.Clear;

            sqlqBasePermissoes.First; //Coloca o ponteiro no primeiro registro
            N1 := 0; //Zera o nível 1
            N2 := 0; //Zera o nível 2
            N3 := 0; //Zera o nível 3
            i := 0;  //Zera o contador

            //Monta e define o tamanho da matriz temporária
            SetLength(PermissoesTemp,sqlqBasePermissoes.RecordCount,4);

            while not sqlqBasePermissoes.EOF do
              begin
                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 1 then
                  begin
                    tvPermissoes.Items.Add(nil,sqlqBasePermissoes.FieldByName('descricao').Text);
                    tvPermissoes.Items.Item[i].StateIndex := 0;
                    N1 := i;
                  end;
                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 2 then
                  begin
                    tvPermissoes.Items.AddChild(tvPermissoes.Items.Item[N1], sqlqBasePermissoes.FieldByName('descricao').Text);
                    tvPermissoes.Items.Item[i].StateIndex := 0;
                    N2 := i;
                  end;
                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 3 then
                  begin
                    tvPermissoes.Items.AddChild(tvPermissoes.Items.Item[N2], sqlqBasePermissoes.FieldByName('descricao').Text);
                    tvPermissoes.Items.Item[i].StateIndex := 0;
                    N3 := i;
                  end;
                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 4 then
                  begin
                    tvPermissoes.Items.AddChild(tvPermissoes.Items.Item[N3], sqlqBasePermissoes.FieldByName('descricao').Text);
                    tvPermissoes.Items.Item[i].StateIndex := 0;
                  end;

                //Preenche os dados da matriz temporária
                PermissoesTemp[i,0] := sqlqBasePermissoes.Fields[2].AsString; //Preenche o módulo
                PermissoesTemp[i,1] := sqlqBasePermissoes.Fields[3].AsString; //Preenche o código da permissão
                PermissoesTemp[i,2] := '0'; //Marca o checkbox
                PermissoesTemp[i,3] := '0'; //Marca se o registro foi atualizado

                sqlqBasePermissoes.Next; //Avança para o próximo registro
                i := i+1; //Incrementa o contador
              end;
          end;
      end
    else
      begin
        tvPermissoes.Items.Clear;
        tvPermissoes.Items.Add(nil,'Você não possui acesso a esta funcionalidade');
        tvPermissoes.Items.Item[0].StateIndex := -1;
        tvPermissoes.Enabled := False;
        sbtnPermissoesExpandirTudo.Enabled := False;
        sbtnPermissoesRecolherTudo.Enabled := False;
      end;
    Self.Cursor := crDefault;
  except on E: exception do
    begin
      Self.Cursor := crDefault;
      Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmUsuarios.sbtnDelUsuarioClick(Sender: TObject);
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      if Application.MessageBox(PChar('Deseja realmente excluir o usuário '''+Usuario_Selecionado+'''?'),'Confirmação',MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          if ID_Usuario_Selecionado <> gID_Usuario_Logado then
            begin
              try
                Self.Cursor := crSQLWait;
                //Apaga os perfis de acesso atribuídos ao usuário
                SQLExec(sqlqPerfisAcessoAtribuidos,['DELETE FROM g_usuarios_perfis_acessos'
                                                   ,'WHERE id_usuario = '''+ID_Usuario_Selecionado+'''']);
                //Apaga as permissões do usuário
                SQLExec(sqlqPermissoesUsuariosOperacoes,['DELETE FROM g_usuarios_permissoes'
                                                        ,'WHERE id_usuario = '''+ID_Usuario_Selecionado+'''']);
                //Apaga o usuário
                SQLExec(sqlqUsuariosOperacao,['DELETE FROM g_usuarios'
                                             ,'WHERE id_usuario = '''+ID_Usuario_Selecionado+'''']);

                Self.Cursor := crDefault;
                sbtnAtualizar.Click;
                Application.MessageBox(PChar('O usuário '''+Usuario_Selecionado+''' foi excluído com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
              except on E: exception do
                begin
                  if E.ClassName <> 'EAbort' then
                    begin
                      Application.MessageBox(PChar('Falha ao tentar excluir o usuário'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                            ,'Erro'
                                            ,MB_ICONERROR + MB_OK);
                      Abort;
                      Exit;
                    end;
                end;
              end;
            end
          else
            begin
              Self.Cursor := crDefault;
              Application.MessageBox(PChar('Não é permitido excluir seu próprio usuário'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
              Abort;
            end;
        end
      else
        Abort;
    end
  else
    begin
      Application.MessageBox(PChar('Selecione um usuário para exclusão'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;
end;

procedure TfrmUsuarios.sbtnEditUsuarioClick(Sender: TObject);
var
  descModoAutenticacao: String;
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      if Acao = EmptyStr then
        begin
          //Verifica nos parâmetros se permite editar o próprio usuário
          if ((PermAutoEditUser = false)
              and (ID_Usuario_Selecionado = gID_Usuario_Logado)) then
            begin
              Application.MessageBox(PChar('Não é permitido editar o próprio usuário')
                                     ,'Aviso'
                                     ,MB_ICONEXCLAMATION + MB_OK);
              lstvwUsuarios.Selected.Selected := false;
              Abort;
            end;

          Self.Cursor := crHourGlass;
          if CheckPermission(UserPermissions,Modulo,'SEGUSEDT') then
            begin
              Acao := 'EDITAR';
              sqlqUsuarios.Filter := 'id_usuario = '+ID_Usuario_Selecionado;
              sqlqUsuarios.Filtered := True;
              edtIDUsuario.Text := sqlqUsuarios.FieldByName('id_usuario').Text;
              edtUsuario.Text := sqlqUsuarios.FieldByName('usuario').Text;
              edtIDPessoa.Text := sqlqUsuarios.FieldByName('id_pessoa').Text;
              edtNome.Text := sqlqUsuarios.FieldByName('nome').Text;
              sbtnLocalizarPessoa.Enabled := True;
              ckbxStatus.Checked := sqlqUsuarios.FieldByName('status').AsBoolean;
              //ckbxResetSenha.Checked := sqlqUsuarios.FieldByName('resetar_senha_prox_login').AsBoolean;
              ModoAutenticacaoAtual := sqlqUsuarios.FieldByName('modo_autenticacao').Text;
              case ModoAutenticacaoAtual of
                'L': descModoAutenticacao := 'Local';
                'D': descModoAutenticacao := 'Domínio';
              end;
              gpbxUsuario.Height := 120;
              lblModoAutenticacao.Visible := True;
              cbModoAutenticacao.Visible := True;
              if ((gAutentLocal)
                  and (gAutentDom))then
                begin
                  cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf(descModoAutenticacao);
                  cbModoAutenticacao.Enabled := True;
                end
              else
                begin
                  cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf(descModoAutenticacao);
                  if gAutentLocal then
                    begin
                      cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf('Local');
                      SelecionarModoAutenticacao('L');
                    end
                  else if gAutentDom then
                    begin
                      cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf('Domínio');
                      SelecionarModoAutenticacao('D');
                    end;
                  cbModoAutenticacao.Enabled := False;
                  //ModoAutenticacaoAtual = 'D')
                    //  and (gAutentLocal)) then ShowMessage('campo senha');
                  //gpbxUsuario.Height := 92;
                  //lblModoAutenticacao.Visible := False;
                  //cbModoAutenticacao.Visible := False;
                end;
              sqlqUsuarios.Filter := EmptyStr;
              sqlqUsuarios.Filtered := False;
              if ((edtIDPessoa.Text = EmptyStr)
                 or (StrToInt(edtIDPessoa.Text) <= 0)) then
                begin
                  edtIDPessoa.Enabled := True;
                  edtNome.Enabled := True;
                end;
              //Configura a exibição dos dados de vínculo da pessoa
              if ParamVincPessoa then
                begin
                  if ModoVincPessoa = 'O' then
                    begin
                      edtIDPessoa.Enabled := False;
                      edtNome.Enabled := False;
                    end
                  else
                    begin
                      edtIDPessoa.Enabled := True;
                      edtNome.Enabled := True;
                    end;
                end
              else
                edtNome.Enabled := True;
            end;

          //Verifica se o usuário selecionado é o usuário logado
          if ID_Usuario_Selecionado <> gID_Usuario_Logado then
            begin
              edtUsuario.Enabled := True;
              if CheckPermission(UserPermissions,Modulo,'SEGUSSTS') then
                ckbxStatus.Enabled := True
              else
                ckbxStatus.Enabled := False;
            end
          else
            begin
              edtUsuario.Enabled := False;
              ckbxStatus.Enabled := False;
            end;

          //Verifica se o usuário tem permissão para editar os perfis de acesso dos usuários
          if CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
            begin
              lstvwPerfisAtribuidos.Enabled := True;
              sbtnAtribuirSelecionados.Enabled := True;
              sbtnAtribuirTodos.Enabled := True;
              sbtnRevogarSelecionados.Enabled := True;
              sbtnRevogarTodos.Enabled := True;
              sbtnVisualizarPermissoes.Enabled := True;
              mniSelAllPerfis.Enabled := True;
              mniAtribuirTodosPerfis.Enabled := True;
              mniSelAllPerfisAtribuidos.Enabled := True;
              mniRevogarTodosPerfis.Enabled := True;
            end
          else
            begin
              lstvwPerfisAtribuidos.Enabled := False;
              sbtnAtribuirSelecionados.Enabled := False;
              sbtnAtribuirTodos.Enabled := False;
              sbtnRevogarSelecionados.Enabled := False;
              sbtnRevogarTodos.Enabled := False;
              sbtnVisualizarPermissoes.Enabled := False;
              mniSelAllPerfis.Enabled := False;
              mniAtribuirTodosPerfis.Enabled := False;
              mniSelAllPerfisAtribuidos.Enabled := False;
              mniRevogarTodosPerfis.Enabled := False;
            end;

          Self.Cursor := crDefault;
        end
      else
        begin
          sbtnCancelar.Click;
        end;
    end
  else
    begin
      Application.MessageBox(PChar('Selecione um usuário para edição'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;
end;

procedure TfrmUsuarios.sbtnMostarSenhaClick(Sender: TObject);
begin
  if edtSenha.EchoMode = emPassword then
    edtSenha.EchoMode := emNormal
  else
    edtSenha.EchoMode := emPassword;
end;

procedure TfrmUsuarios.FormShow(Sender: TObject);
var
  sqlqParametros: TSQLQuery;
begin
  if not CheckPermission(UserPermissions,Modulo,'SEGUSCAD') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  //Ajusta o tamanho dos splitpanel do perfis e permissões de acessos
  pstsPerfis.Width := round(pstsDireito.Width/2);
  pstPermissoes.Repaint;

  //Ajusta o tamanho dos paineis das seleção dos perfis de acesso
  pnlPerfisAcesso.Width := round((pstsPerfis.Width/2)-pnlComandosSelecao.Width);

  try
    //Cria componente Query e atribui os parametros
    sqlqParametros := TSQLQuery.Create(frmUsuarios);
    sqlqParametros.DataBase := dmConexao.ConexaoDB;
    sqlqParametros.Transaction := dmConexao.sqltTransactions;

    //Consulta os parametros
    SQLQuery(sqlqParametros,['SELECT modulo, cod_config, param1, param2, param3, imagem, status',
                             'FROM g_parametros',
                             'WHERE modulo = ''SEGURANCA''']);

    //Carrega parametros controle de usuários
    sqlqParametros.Filter := 'cod_config = ''USUCFGPES''';
    sqlqParametros.Filtered := True;
    ParamVincPessoa := sqlqParametros.FieldByName('status').AsBoolean;
    if ParamVincPessoa then
      ModoVincPessoa := sqlqParametros.FieldByName('param1').Text
    else
      ModoVincPessoa := '';
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    sqlqParametros.Filter := 'cod_config = ''USUVINCPES''';
    sqlqParametros.Filtered := True;
    PermMultUser := sqlqParametros.FieldByName('status').AsBoolean;
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    sqlqParametros.Filter := 'cod_config = ''USUAUTOEDT''';
    sqlqParametros.Filtered := True;
    PermAutoEditUser := sqlqParametros.FieldByName('status').AsBoolean;
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    //Configura a exibição dos dados de vínculo da pessoa
    if ParamVincPessoa then
      begin
        lblIDPessoa.Visible := True;
        edtIDPessoa.Visible := True;
        sbtnLocalizarPessoa.Visible := True;
      end
    else
      begin
        lblIDPessoa.Visible := False;
        edtIDPessoa.Visible := False;
        lblNome.Left := 10;
        edtNome.Left := 47;
        edtNome.Width := 366;
        sbtnLocalizarPessoa.Visible := False;
      end;
  finally
      sqlqParametros.Free;
    end;

  Editado := False;
  sbtnAtualizar.Click;
end;

procedure TfrmUsuarios.lstvwUsuariosDblClick(Sender: TObject);
begin
  if (lstvwUsuarios.SelCount > 0)
     and (CheckPermission(UserPermissions,Modulo,'SEGUSEDT')) then
    sbtnEditUsuario.Click;
end;

procedure TfrmUsuarios.lstvwUsuariosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    sbtnDelUsuario.Click;

  if ((Key = VK_ESCAPE)
     and (edtPesquisar.Visible)) then
    begin
      edtPesquisar.Clear;
      edtPesquisar.Visible := False;
    end;
end;

procedure TfrmUsuarios.FormKeyPress(Sender: TObject; var Key: char);
begin
  if ((Key = #13)
    and (CompareStr(Screen.ActiveControl.Name,'edtIDPessoa') <> 0)) then
    begin
      Key := #0;
      SelectNext(ActiveControl,True,True);
      Exit;
    end;
end;

procedure TfrmUsuarios.edtUsuarioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Editado := True;
end;

procedure TfrmUsuarios.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if Editado then
    begin
      case Application.MessageBox(PChar('Deseja salvar as alterações?'), 'Confirmação',  MB_ICONQUESTION + MB_YESNOCANCEL) of
        MRYES:
          begin
            sbtnSalvar.Click;
            CloseAllFormOpenedConnections(Self);
            Self.Close;
          end;
        MRNO:
          begin
            Editado := False;
            CloseAllFormOpenedConnections(Self);
            Self.Close;
          end;
        MRCANCEL:
          begin
            Abort;
          end;
      end;
    end
  else
    CloseAllFormOpenedConnections(Self);
end;

procedure TfrmUsuarios.FormCreate(Sender: TObject);
begin
  if CheckPermission(UserPermissions,Modulo,'SEGUSADD') then
    sbtnAddUsuario.Enabled := True
  else
    sbtnAddUsuario.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGUSEDT') then
    sbtnEditUsuario.Enabled := True
  else
    sbtnEditUsuario.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGPMSTS')
     or CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
    sbtnEditarPermissoes.Enabled := True
  else
    sbtnEditarPermissoes.Enabled := False;

  {if CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
    begin
      sbtnAtribuirSelecionados.Enabled := True;
      sbtnAtribuirTodos.Enabled := True;
      sbtnRevogarSelecionados.Enabled := True;
      sbtnRevogarTodos.Enabled := True;
    end
  else
    begin
      sbtnAtribuirSelecionados.Enabled := False;
      sbtnAtribuirTodos.Enabled := False;
      sbtnRevogarSelecionados.Enabled := False;
      sbtnRevogarTodos.Enabled := False;
    end;       }

  if CheckPermission(UserPermissions,Modulo,'SEGPMCOP') then
    sbtnCopiarPermissoes.Enabled := True
  else
    sbtnCopiarPermissoes.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGUSALTSEN') then
    sbtnAlterarSenha.Enabled := True
  else
    sbtnAlterarSenha.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGUSDEL') then
    sbtnDelUsuario.Enabled := True
  else
    sbtnDelUsuario.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGUSADD')
     or CheckPermission(UserPermissions,Modulo,'SEGUSEDT')
     or CheckPermission(UserPermissions,Modulo,'SEGPMSTS')
     or CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
    begin
      sbtnSalvar.Enabled := True;
      sbtnCancelar.Enabled := True;
    end
  else
    begin
      sbtnSalvar.Enabled := False;
      sbtnCancelar.Enabled := False;
    end;

  defaultView;
  Acao := EmptyStr;
  Editado := False;
end;

procedure TfrmUsuarios.defaultView;
begin
  edtUsuario.Enabled := False;
  edtIDPessoa.Enabled := False;
  edtNome.Enabled := False;
  edtSenha.Enabled := False;
  ckbxStatus.Enabled := False;
  lblModoAutenticacao.Visible := False;
  cbModoAutenticacao.Visible := False;
  lblSenha.Visible := False;
  edtSenha.Visible := False;
  sbtnMostarSenha.Visible := False;
  ckbxResetSenha.Visible := False;
  gpbxUsuario.Height := 92;
  pstsDireito.Repaint;
end;

procedure TfrmUsuarios.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnSalvar.Click;

  if (ssCtrl in Shift) and (Key = VK_L) then
    sbtnPesquisar.Click;
end;

procedure TfrmUsuarios.ckbxResetSenhaChange(Sender: TObject);
begin

end;

procedure TfrmUsuarios.cbModoAutenticacaoSelect(Sender: TObject);
var
  ModoSel: String;
begin
  case cbModoAutenticacao.Text of
    'Domínio': ModoSel := 'D';
    'Local': ModoSel := 'L';
  end;

  SelecionarModoAutenticacao(ModoSel);
  Editado := True;
end;

procedure TfrmUsuarios.edtNomeKeyPress(Sender: TObject; var Key: char);
begin
  Editado := True;
end;

procedure TfrmUsuarios.edtPesquisarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: integer;
  Found: Boolean;
begin
  if Key = VK_RETURN then
    begin
      if FoundResult >= 0 then
        i := FoundResult +1
      else
        i := 0;
      repeat
        Found := Pos(LowerCase(edtPesquisar.Text), LowerCase(lstvwUsuarios.Items[i].SubItems.Text)) >= 1;
        if not Found then inc(i);
      until Found or (i > lstvwUsuarios.Items.Count - 1);
      if Found then
        begin
          lstvwUsuarios.Items[i].Selected := True;
          //lstvwUsuarios.SetFocus;
          lstvwUsuarios.Selected.MakeVisible(True);
          FoundResult := i;
          //edtPesquisar.SetFocus;
        end
      else
        begin
          lstvwUsuarios.ItemIndex := -1;
          FoundResult := -1;
          edtPesquisar.SetFocus;
        end;
    end;

  if Key = VK_ESCAPE then
    sbtnPesquisar.Click;
end;

procedure TfrmUsuarios.edtSenhaChange(Sender: TObject);
begin
  Editado := True;
end;

procedure TfrmUsuarios.lstvwUsuariosSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  i, j, k: Integer;
  item2, item3: TListItem;
begin
  if Acao = EmptyStr then
    begin
      if lstvwUsuarios.SelCount > 0 then
        begin
          ID_Usuario_Selecionado := lstvwUsuarios.Items.Item[lstvwUsuarios.Selected.Index].Caption;
          Usuario_Selecionado := lstvwUsuarios.Items[lstvwUsuarios.Selected.Index].SubItems[0];

          //Verifica nos parâmetros se permite editar o próprio usuário
          if ((PermAutoEditUser = false)
              and (Item.Caption = gID_Usuario_Logado)) then
            begin
              Item.Selected := False;
              Abort;
            end;

          //Habilita/Desabilita o botão alterar senha de acordo com o modo de login do usuário
          if ((lstvwUsuarios.Items[lstvwUsuarios.Selected.Index].SubItems[1] = 'L')
              and (CheckPermission(UserPermissions,Modulo,'SEGUSALTSEN'))) then
            sbtnAlterarSenha.Enabled := True
          else
            sbtnAlterarSenha.Enabled := False;

          //Perfis de acesso disponíveis para seleção
          if CheckPermission(UserPermissions,Modulo,'SEGPUACS') then
            begin
              lstvwPerfisAcesso.Enabled := True;
              SQLQuery(sqlqPerfisAcesso,['SELECT id_perfil_acesso, perfil, detalhe, status, excluido'
                                        ,'FROM g_perfis_acesso'
                                        ,'WHERE excluido = false'
                                        ,'     AND id_perfil_acesso NOT IN (SELECT U.id_perfil_acesso'
                                        ,'                                  FROM g_usuarios_perfis_acessos U'
                                        ,'                                  WHERE U.id_usuario = '''+ID_Usuario_Selecionado+''''
                                        ,'                                       AND U.excluido = false)'
                                        ,'ORDER BY perfil']);
              //sqlqPerfisAcesso.Filtered := False;
              //sqlqPerfisAcesso.Filter := 'id_perfil_acesso IN (SELECT U.id_perfil_acesso FROM g_usuarios_perfis_acessos U WHERE U.id_usuario = '''+ID_Usuario_Selecionado+''' AND U.excluido = false)';
              //sqlqPerfisAcesso.Filtered := True;
              lstvwPerfisAcesso.Clear;

              sqlqPerfisAcesso.First;
              while not sqlqPerfisAcesso.EOF do
                begin
                  item2 := lstvwPerfisAcesso.Items.Add;
                  item2.Caption := sqlqPerfisAcesso.FieldByName('id_perfil_acesso').Text;
                  item2.SubItems.Add(sqlqPerfisAcesso.FieldByName('perfil').Text);
                  item2.SubItems.Add(sqlqPerfisAcesso.FieldByName('status').Text);

                  sqlqPerfisAcesso.Next;
                end;
            end;

          //Perfis de acesso atribuídos para o usuário
          if CheckPermission(UserPermissions,Modulo,'SEGPUACS') then
            begin
              //lstvwPerfisAtribuidos.Enabled := True;
              SQLQuery(sqlqPerfisAcessoAtribuidos,['SELECT id_perfil_acesso, perfil, detalhe, status, excluido'
                                                  ,'FROM g_perfis_acesso'
                                                  ,'WHERE excluido = false'
                                                  ,'     AND id_perfil_acesso IN (SELECT U.id_perfil_acesso'
                                                  ,'                              FROM g_usuarios_perfis_acessos U'
                                                  ,'                              WHERE U.id_usuario = '''+ID_Usuario_Selecionado+''''
                                                  ,'                                   AND U.excluido = false)'
                                                  ,'ORDER BY perfil']);
              lstvwPerfisAtribuidos.Clear;

              sqlqPerfisAcessoAtribuidos.First;
              while not sqlqPerfisAcessoAtribuidos.EOF do
                begin
                  item3 := lstvwPerfisAtribuidos.Items.Add;
                  item3.Caption := sqlqPerfisAcessoAtribuidos.FieldByName('id_perfil_acesso').Text;
                  item3.SubItems.Add(sqlqPerfisAcessoAtribuidos.FieldByName('perfil').Text);
                  item3.SubItems.Add(sqlqPerfisAcessoAtribuidos.FieldByName('status').Text);

                  //Marca como perfil atribuido
                  PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp,0,sqlqPerfisAcessoAtribuidos.FieldByName('id_perfil_acesso').Text),1] := 'A';

                  sqlqPerfisAcessoAtribuidos.Next;
                end;
            end
          else;

          //Permissões do usuário selecionado
          if CheckPermission(UserPermissions,Modulo,'SEGPMACS') then
            begin
              //Self.Cursor := crSQLWait;
              pnlPermissoesEsqTitulo.Caption := TitPerm+' [ '+Usuario_Selecionado+' ]';

              {'SELECT id_usuario, modulo, cod_permissao, permissao'
                                             ,'FROM g_usuarios_permissoes'
                                             ,'WHERE id_usuario = '''+ID_Usuario_Selecionado+'''']);}

              SQLQuery(sqlqPermissoesUsuario,['SELECT  DISTINCT'
                                             ,'        id_usuario'
                                             ,'      , modulo'
                                             ,'      , cod_permissao'
                                             ,'      , permissao'
                                             ,'      , ''U'' tipo'
                                             ,'FROM g_usuarios_permissoes'
                                             ,'WHERE id_usuario = '+ID_Usuario_Selecionado

                                             ,'UNION ALL'

                                             ,'SELECT  DISTINCT'
                                             ,'        U.id_usuario'
                                             ,'      , P.modulo'
                                             ,'      , P.cod_permissao'
                                             ,'      , P.permissao'
                                             ,'      , ''G'' tipo'
                                             ,'FROM g_perfis_acesso_permissoes P'
                                             ,'INNER JOIN g_usuarios_perfis_acessos U'
                                             ,'      ON U.id_perfil_acesso = P.id_perfil_acesso'
                                             ,'WHERE P.excluido   = false'
                                             ,'  AND U.id_usuario = '''+ID_Usuario_Selecionado+''''
                                             {,'     AND id_perfil_acesso IN ( SELECT id_perfil_acesso'
                                             ,'                               FROM g_usuarios_perfis_acessos'
                                             ,'                               WHERE id_usuario = '''+ID_Usuario_Selecionado+''')'}

                                             ,'GROUP BY id_usuario, modulo, cod_permissao, permissao'

                                             ,'ORDER BY modulo, cod_permissao']);

              //Marca as permissões na TreeView
              for k := 0 to tvPermissoes.Items.Count-1 do
                begin
                  if CheckPermissao(ID_Usuario_Selecionado,tvPermissoes.Items.Item[k].Text) then
                    tvPermissoes.Items.Item[k].StateIndex := 1
                  else
                    tvPermissoes.Items.Item[k].StateIndex := 0;
                end;

              {//Marca as permissões na TreeView
              for k := 0 to tvPermissoes.Items.Count-1 do
                begin
                  //if BlockEditPermissao(ID_Usuario_Selecionado,tvPermissoes.Items.Item[k].Text) then
                    //tvPermissoes.Enabled := false;//.Canvas.Font.Color := clRed;
                  //tvPermissoes.Items.Item[k].StateIndex := -1;
                    //tvPermissoes.Items.Item[k].States := TVIS_BOLD // .Canvas.Font.Style:=[fsBold];
                    //tvPermissoes.Canvas.Font.Color:=clRed;
                    //tvPermissoes.Canvas.Font.Color := clGrayText;
                    //tvPermissoes.Items.Item[k].States := [vsDisabled];
                    //tvPermissoes.Items.Item[k].Visible := true
                    //tvPermissoes.Items.Item[k].tex .StateIndex := 1
                  //else
                    //tvPermissoes.Items.Item[k].States := [vsEnabled];
                end;  }

              //Limpa as permissões de usuário da matriz temporária
              for i := Low(PermissoesUsuario) to High(PermissoesUsuario) do
                begin
                  PermissoesUsuario[i,0] := EmptyStr;
                  PermissoesUsuario[i,1] := EmptyStr;
                  PermissoesUsuario[i,2] := EmptyStr;
                  PermissoesUsuario[i,3] := EmptyStr;
                end;

              //Insere as permissões do usuário em uma matriz temporária
              SetLength(PermissoesUsuario,sqlqPermissoesUsuario.RecordCount,4);
              j := 0;
              sqlqPermissoesUsuario.First;
              while not sqlqPermissoesUsuario.eof do
                begin
                  PermissoesUsuario[j,0] := sqlqPermissoesUsuario.Fields[0].AsString;
                  PermissoesUsuario[j,1] := sqlqPermissoesUsuario.Fields[1].AsString;
                  PermissoesUsuario[j,2] := sqlqPermissoesUsuario.Fields[2].AsString;
                  PermissoesUsuario[j,3] := sqlqPermissoesUsuario.Fields[3].AsString;

                  j := j+1;
                  sqlqPermissoesUsuario.Next;
                end;

              //Limpa a matriz temporária que guarda as alterações nas permissões
              for i := Low(PermissoesTemp) to High(PermissoesTemp) do
                begin
                  PermissoesTemp[i,2] := '0';
                  PermissoesTemp[i,3] := '0';
                end;

              //Insere na matriz temporária as permissões do usuário
              for i := Low(PermissoesTemp) to High(PermissoesTemp) do
                begin
                  sqlqPermissoesUsuario.First;
                  while not sqlqPermissoesUsuario.EOF do
                    begin
                      //Verifica se o usuário possui a permissão e marca na permissão temporária
                      if (MatchStr(PermissoesTemp[i,0],sqlqPermissoesUsuario.Fields[1].AsString)
                         and MatchStr(PermissoesTemp[i,1],sqlqPermissoesUsuario.Fields[2].AsString))
                         and sqlqPermissoesUsuario.Fields[3].AsBoolean then
                        PermissoesTemp[i,2] := '1';

                        sqlqPermissoesUsuario.Next;
                    end;
                end;
            end;
        end
      else
        begin
          ID_Usuario_Selecionado := EmptyStr;
          pnlPermissoesEsqTitulo.Caption := TitPerm;

          //Desmarcas os checkboxes da TreeView
          for i := 0 to tvPermissoes.Items.Count-1 do
            tvPermissoes.Items.Item[i].StateIndex := 0;

          //Limpa os marcadores de atribuição e ação dos perfis de acesso
          for i := Low(PerfisAcessoTemp) to High(PerfisAcessoTemp) do
            begin
              PermissoesTemp[i,1] := '';
              PermissoesTemp[i,2] := '';
            end;

          //Limpa as permissões de usuário da matriz temporária
          for i := Low(PermissoesUsuario) to High(PermissoesUsuario) do
            begin
              PermissoesUsuario[i,0] := EmptyStr;
              PermissoesUsuario[i,1] := EmptyStr;
              PermissoesUsuario[i,2] := EmptyStr;
              PermissoesUsuario[i,3] := EmptyStr;
            end;

          //Limpa a matriz temporária das alterações de permissões
          for i := Low(PermissoesTemp) to High(PermissoesTemp) do
            begin
              PermissoesTemp[i,2] := '0';
              PermissoesTemp[i,3] := '0';
            end;
        end;
    end;
end;

procedure TfrmUsuarios.mniDeselecionarTodosItensClick(Sender: TObject);
begin
  SelAllChildNodes(tvPermissoes.Selected, 1);
end;

procedure TfrmUsuarios.mniDeselecionarTudoClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to tvPermissoes.Items.Count-1 do
    begin
      //Verifica se a permissão foi atribuida por grupo. Caso sim bloqueia a edição
      if not (BlockEditPermissao(ID_Usuario_Selecionado,tvPermissoes.Items.item[i].Text)) then
        begin
          tvPermissoes.Items.Item[i].StateIndex := 1;
          ToggleTreeViewCheckBoxes(tvPermissoes.Items.Item[i]);
          Editado := True;
          setPermission(tvPermissoes.Items.Item[i]);
        end;
    end;
end;

procedure TfrmUsuarios.mniEditUsuarioClick(Sender: TObject);
var
  id: String;
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      sbtnEditUsuario.Click;
    end;
end;

procedure TfrmUsuarios.mniPermissoesClick(Sender: TObject);
begin
  sbtnEditarPermissoes.Click;
end;

procedure TfrmUsuarios.mniAddUsuarioClick(Sender: TObject);
begin
  sbtnAddUsuario.Click;
end;

procedure TfrmUsuarios.mniAlterarSenhaClick(Sender: TObject);
begin
  sbtnAlterarSenha.Click;
end;

procedure TfrmUsuarios.mniAtivarDesativaUsuarioClick(Sender: TObject);
begin
  AtivarDesativarUsuario(ID_Usuario_Selecionado);
end;

procedure TfrmUsuarios.mniDelUsuarioClick(Sender: TObject);
begin
  sbtnDelUsuario.Click;
end;

procedure TfrmUsuarios.mniSelecionarTodosItensClick(Sender: TObject);
begin
  SelAllChildNodes(tvPermissoes.Selected, 0);
end;

procedure TfrmUsuarios.SelAllChildNodes(Node: TTreeNode; CheckUncheck: Integer);
var
  TempNode: TTreeNode;
begin
  if Assigned(Node) then
    begin
      if CheckUncheck = 1 then
        ToggleTreeViewCheckBoxes(Node, false)
      else
        ToggleTreeViewCheckBoxes(Node, true);

      Editado := True;
      setPermission(Node);

      TempNode := Node.GetFirstChild;
      if CheckUncheck = 0 then
         SelParentNode(Node);

      while TempNode <> Nil do
        begin
          if not TempNode.HasChildren then
            begin
              ToggleTreeViewCheckBoxes(TempNode);
              if CheckUncheck = 1 then
                ToggleTreeViewCheckBoxes(TempNode, false)
              else
                ToggleTreeViewCheckBoxes(TempNode, true);
              Editado := True;
              setPermission(TempNode);
            end
          else
            SelAllChildNodes(TempNode, CheckUncheck);

          TempNode := Node.GetNextChild(TempNode);
        end;
    end;
end;

procedure TfrmUsuarios.mniSelecionarTudoClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to tvPermissoes.Items.Count-1 do
    begin
      //Verifica se a permissão foi atribuida por grupo. Caso sim bloqueia a edição
      if not (BlockEditPermissao(ID_Usuario_Selecionado,tvPermissoes.Items.Item[i].Text)) then
        begin
          tvPermissoes.Items.Item[i].StateIndex := 0;
          ToggleTreeViewCheckBoxes(tvPermissoes.Items.Item[i]);
          Editado := True;
          setPermission(tvPermissoes.Items.Item[i]);
        end;
    end;
end;

procedure TfrmUsuarios.pmnPermissoesPopup(Sender: TObject);
begin
  if (CheckPermission(UserPermissions,Modulo,'SEGPMSTS')
      and (Acao <> EmptyStr)) then
    begin
      mniSelecionarTudo.Enabled := True;
      mniDeselecionarTudo.Enabled := True;
      mniSelecionarTodosItens.Enabled := True;
      mniDeselecionarTodosItens.Enabled := True;
    end
  else
    begin
      mniSelecionarTudo.Enabled := False;
      mniDeselecionarTudo.Enabled := False;
      mniSelecionarTodosItens.Enabled := False;
      mniDeselecionarTodosItens.Enabled := False;
    end;

  if IDNode(tvPermissoes) >= 0 then
    begin
      LN1.Visible := True;
      mniSelecionarTodosItens.Visible := True;
      mniDeselecionarTodosItens.Visible := True;
    end
  else
    begin
      LN1.Visible := False;
      mniSelecionarTodosItens.Visible := False;
      mniDeselecionarTodosItens.Visible := False;
    end;
end;

procedure TfrmUsuarios.pmnUsuariosPopup(Sender: TObject);
var
  mniCopiarPermissoesDe, mniCopiarPermissoesPara: TMenuItem;
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      mniEditUsuario.Visible := True;
      mniAlterarSenha.Visible := True;
      mniAtivarDesativaUsuario.Visible := True;
      mniDelUsuario.Visible := True;
      mniPermissoes.Visible := True;
      H1.Visible := True;
      H2.Visible := True;

      if CheckPermission(UserPermissions,Modulo,'SEGUSADD') then
        mniAddUsuario.Enabled := True
      else
        mniAddUsuario.Enabled := False;
      if CheckPermission(UserPermissions,Modulo,'SEGUSEDT') then
        mniEditUsuario.Enabled := True
      else
        mniEditUsuario.Enabled := False;
      if CheckPermission(UserPermissions,Modulo,'SEGUSALTSEN') then
        if lstvwUsuarios.Items[lstvwUsuarios.Selected.Index].SubItems[1] = 'L' then
          mniAlterarSenha.Enabled := True
        else
          mniAlterarSenha.Enabled := False
      else
        mniAlterarSenha.Enabled := False;

      if CheckPermission(UserPermissions,Modulo,'SEGUSSTS') then
        mniAtivarDesativaUsuario.Enabled := True
      else
        mniAtivarDesativaUsuario.Enabled := False;
      if CheckPermission(UserPermissions,Modulo,'SEGPMSTS') then
        mniPermissoes.Enabled := True
      else
        mniPermissoes.Enabled := False;
      if CheckPermission(UserPermissions,Modulo,'SEGPMCOP') then
        begin
          mniCopiarPermissoes.Enabled := True;
          mniCopiarPermissoes.Clear;
          mniCopiarPermissoesDe := TMenuItem.Create(mniCopiarPermissoes);
          mniCopiarPermissoesDe.Caption := 'Copiar permissões de "'+Usuario_Selecionado+'"';
          mniCopiarPermissoesDe.OnClick := @mniCopiarPermissoesDeClick;
          mniCopiarPermissoes.Add(mniCopiarPermissoesDe);
          mniCopiarPermissoesPara := TMenuItem.Create(mniCopiarPermissoes);
          mniCopiarPermissoesPara.Caption := 'Copiar permissões para "'+Usuario_Selecionado+'"';
          mniCopiarPermissoesPara.OnClick := @mniCopiarPermissoesParaClick;
          mniCopiarPermissoes.Add(mniCopiarPermissoesPara);
        end
      else
        mniCopiarPermissoes.Enabled := False;

      if CheckPermission(UserPermissions,Modulo,'SEGUSDEL') then
        mniDelUsuario.Enabled := True
      else
        mniDelUsuario.Enabled := False;

      sqlqUsuarios.Filter := 'id_usuario = '+ID_Usuario_Selecionado;
      sqlqUsuarios.Filtered := True;
      if sqlqUsuarios.FieldByName('status').AsBoolean = True then
        mniAtivarDesativaUsuario.Caption := '&Desativar usuário'
      else
        mniAtivarDesativaUsuario.Caption := 'A&tivar usuário';
      sqlqUsuarios.Filtered := False;

      if ID_Usuario_Selecionado = gID_Usuario_Logado then
        begin
          mniAtivarDesativaUsuario.Enabled := False;
          mniDelUsuario.Enabled := False;
        end
      else
        begin
          if CheckPermission(UserPermissions,Modulo,'SEGUSSTS') then
            mniAtivarDesativaUsuario.Enabled := True;
          if CheckPermission(UserPermissions,Modulo,'SEGUSDEL') then
            mniDelUsuario.Enabled := True;
        end;
    end
  else
    begin
      mniEditUsuario.Visible := False;
      mniAlterarSenha.Visible := False;
      mniAtivarDesativaUsuario.Visible := False;
      mniDelUsuario.Visible := False;
      mniPermissoes.Visible := False;
      H1.Visible := False;
      H2.Visible := False;
      if CheckPermission(UserPermissions,Modulo,'SEGPMCOP') then
        begin
          mniCopiarPermissoes.OnClick := @mniCopiarPermissoesClick;
          mniCopiarPermissoes.Clear;
        end
      else
        mniCopiarPermissoes.Enabled := False;
    end;
end;

procedure TfrmUsuarios.mniCopiarPermissoesClick(Sender: TObject);
begin
  CopiarPermissoes;
end;

procedure TfrmUsuarios.CopiarPermissoes;
begin
  frmCopiarPermissoes := TfrmCopiarPermissoes.Create(Self);
  //frmCopiarPermissoes.IDUsuario := ID_Usuario_Selecionado;
  //frmCopiarPermissoes.Usuario := Usuario_Selecionado;
  frmCopiarPermissoes.PermAutoEditUser := PermAutoEditUser;
  frmCopiarPermissoes.ShowModal;
end;

procedure TfrmUsuarios.CopiarPermissoes(IDUsuario, Usuario, Tipo: String);
begin
  frmCopiarPermissoes := TfrmCopiarPermissoes.Create(Self);
  frmCopiarPermissoes.IDUsuario := IDUsuario;
  frmCopiarPermissoes.Usuario := Usuario;
  frmCopiarPermissoes.Tipo := Tipo;
  frmCopiarPermissoes.PermAutoEditUser := PermAutoEditUser;
  frmCopiarPermissoes.ShowModal;
end;

procedure TfrmUsuarios.mniCopiarPermissoesDeClick(Sender: TObject);
begin
  CopiarPermissoes(ID_Usuario_Selecionado, Usuario_Selecionado, 'DE');
end;

procedure TfrmUsuarios.mniCopiarPermissoesParaClick(Sender: TObject);
begin
  CopiarPermissoes(ID_Usuario_Selecionado, Usuario_Selecionado, 'PARA');
end;

procedure TfrmUsuarios.sbtnCancelarClick(Sender: TObject);
var
  i: Integer;
begin
  if ((Editado)
     or (Acao <> EmptyStr)) then
    begin
      if Application.MessageBox(Pchar('Cancelar a edição?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          Self.Cursor := crHourGlass;
          if Acao = 'ADICIONAR' then
            begin
              CleanForm(Self);
              if Index_Novo_Usuario > 0 then
                begin
                 lstvwUsuarios.Items.Item[Index_Novo_Usuario].Delete;
                 Index_Novo_Usuario := 0;
                 if tvPermissoes.Items.SelectionCount > 0 then
                   tvPermissoes.Selected.Selected := False;
                end;
            end;
          if Acao = 'EDITAR' then
            begin
              {if lstvwUsuarios.SelCount > 0 then
                ID_Usuario_Selecionado := lstvwUsuarios.Items.Item[lstvwUsuarios.Selected.Index].Caption
              else
                ID_Usuario_Selecionado := '0'; }

              Usuario_Selecionado := sqlqUsuarios.Fields[1].AsString;
              sqlqUsuarios.Filter := 'id_usuario = '+ID_Usuario_Selecionado;
              sqlqUsuarios.Filtered := True;
              edtIDUsuario.Text := sqlqUsuarios.Fields[0].AsString;
              edtUsuario.Text := sqlqUsuarios.Fields[1].AsString;
              edtNome.Text := sqlqUsuarios.Fields[2].AsString;
              ckbxStatus.Checked := sqlqUsuarios.Fields[3].AsBoolean;
              sqlqUsuarios.Filter := EmptyStr;
              sqlqUsuarios.Filtered := False;
            end;

          //Default do formulário
          edtIDUsuario.Clear;
          edtUsuario.Enabled := False;
          edtUsuario.Clear;
          edtIDPessoa.Enabled := False;
          edtIDPessoa.Clear;
          edtNome.Enabled := False;
          edtNome.Clear;
          sbtnLocalizarPessoa.Enabled := False;
          lblSenha.Visible := False;
          edtSenha.Enabled := False;
          edtSenha.Clear;
          ckbxStatus.Enabled := False;
          ckbxStatus.Checked := False;
          edtSenha.Visible := False;
          sbtnMostarSenha.Visible := False;
          ckbxResetSenha.Visible := False;
          ckbxResetSenha.Checked := False;
          lblModoAutenticacao.Visible := False;
          cbModoAutenticacao.Visible := False;
          cbModoAutenticacao.ItemIndex := -1;
          gpbxUsuario.Height := 92;
          lstvwPerfisAtribuidos.Enabled := False;
          sbtnAtribuirSelecionados.Enabled := False;
          sbtnAtribuirTodos.Enabled := False;
          sbtnRevogarSelecionados.Enabled := False;
          sbtnRevogarTodos.Enabled := False;
          sbtnVisualizarPermissoes.Enabled := False;
          mniSelAllPerfis.Enabled := False;
          mniAtribuirTodosPerfis.Enabled := False;
          mniSelAllPerfisAtribuidos.Enabled := False;
          mniRevogarTodosPerfis.Enabled := False;
          pstsDireito.Repaint;
          Acao := EmptyStr;
          ModoAutenticacaoAtual := EmptyStr;
          ModoAutenticacao := EmptyStr;
          Editado := False;
          pnlPermissoesEsqTitulo.Caption := TitPerm;

          //Desmarcar permissões na TreeView
          for i := 0 to tvPermissoes.Items.Count-1 do
            begin
              tvPermissoes.Items.Item[i].StateIndex := 0;
            end;

          //Limpa as permissões de usuário
          for i := Low(PermissoesUsuario) to High(PermissoesUsuario) do
            begin
              PermissoesUsuario[i,0] := EmptyStr;
              PermissoesUsuario[i,1] := EmptyStr;
              PermissoesUsuario[i,2] := EmptyStr;
              PermissoesUsuario[i,3] := EmptyStr;
            end;

          //Limpa as alterações nas permissões
          for i := Low(PermissoesTemp) to High(PermissoesTemp) do
            begin
              PermissoesTemp[i,2] := '0';
              PermissoesTemp[i,3] := '0';
            end;

          //Limpa os marcadores de atribuição e ação dos perfis de acesso
          for i := Low(PerfisAcessoTemp) to High(PerfisAcessoTemp) do
            begin
              PermissoesTemp[i,1] := '';
              PermissoesTemp[i,2] := '';
            end;
          Self.Cursor := crDefault;
        end
      else
        begin
          Abort;
        end;
    end;
end;

procedure TfrmUsuarios.sbtnAlterarSenhaClick(Sender: TObject);
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      if ID_Usuario_Selecionado = gID_Usuario_Logado then
        gModAltSenha := 'ALTSENHALAYOUT1'
      else
        gModAltSenha := 'ALTSENHALAYOUT3';
      gID_Usuario_Selecionado := ID_Usuario_Selecionado;
      OpenForm(TfrmAlterarSenha,'Modal');
    end
  else
    begin
      Application.MessageBox(PChar('Selecione um usuário para alterar a senha'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;
end;

procedure TfrmUsuarios.sbtnEditarPermissoesClick(Sender: TObject);
var
  descModoAutenticacao: String;
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      if Acao <> EmptyStr then
        sbtnCancelar.Click;

      //Verifica nos parâmetros se permite editar o próprio usuário
      if ((PermAutoEditUser = false)
          and (ID_Usuario_Selecionado = gID_Usuario_Logado)) then
        begin
          Application.MessageBox(PChar('Não é permitido editar o próprio usuário')
                                 ,'Aviso'
                                 ,MB_ICONEXCLAMATION + MB_OK);
          lstvwUsuarios.Selected.Selected := false;
          Abort;
        end;

      Acao := 'EDITAR_PERMISSOES';
      if CheckPermission(UserPermissions,Modulo,'SEGPMSTS')
         or CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
        begin
          sqlqUsuarios.Filter := 'id_usuario = '+ID_Usuario_Selecionado;
          sqlqUsuarios.Filtered := True;
          edtIDUsuario.Text := sqlqUsuarios.FieldByName('id_usuario').Text;
          edtUsuario.Text := sqlqUsuarios.FieldByName('usuario').Text;
          edtNome.Text := sqlqUsuarios.FieldByName('nome').Text;
          ckbxStatus.Checked := sqlqUsuarios.FieldByName('status').AsBoolean;
          //ckbxResetSenha.Checked := sqlqUsuarios.FieldByName('id_usuario').AsBoolean;
          ModoAutenticacaoAtual := sqlqUsuarios.FieldByName('modo_autenticacao').Text;
          case ModoAutenticacaoAtual of
            'L': descModoAutenticacao := 'Local';
            'D': descModoAutenticacao := 'Domínio';
          end;
          gpbxUsuario.Height := 120;
          lblModoAutenticacao.Visible := True;
          cbModoAutenticacao.Visible := True;
          if ((gAutentLocal)
              and (gAutentDom)) then
            cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf(descModoAutenticacao)
          else
            begin
              cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf(descModoAutenticacao);
              if gAutentLocal then
                begin
                  cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf('Local');
                  SelecionarModoAutenticacao('L');
                end
              else if gAutentDom then
                begin
                  cbModoAutenticacao.ItemIndex := cbModoAutenticacao.Items.IndexOf('Domínio');
                  SelecionarModoAutenticacao('D');
                end;
            end;
          cbModoAutenticacao.Enabled := False;
          sqlqUsuarios.Filtered := False;
          sqlqUsuarios.Filter := '';
        end;

      //Verifica se o usuário tem permissão para editar os perfis de acesso dos usuários
      if CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
        begin
          lstvwPerfisAtribuidos.Enabled := True;
          sbtnAtribuirSelecionados.Enabled := True;
          sbtnAtribuirTodos.Enabled := True;
          sbtnRevogarSelecionados.Enabled := True;
          sbtnRevogarTodos.Enabled := True;
          sbtnVisualizarPermissoes.Enabled := True;
          mniSelAllPerfis.Enabled := True;
          mniAtribuirTodosPerfis.Enabled := True;
          mniSelAllPerfisAtribuidos.Enabled := True;
          mniRevogarTodosPerfis.Enabled := True;
        end
      else
        begin
          lstvwPerfisAtribuidos.Enabled := False;
          sbtnAtribuirSelecionados.Enabled := False;
          sbtnAtribuirTodos.Enabled := False;
          sbtnRevogarSelecionados.Enabled := False;
          sbtnRevogarTodos.Enabled := False;
          sbtnVisualizarPermissoes.Enabled := False;
          mniSelAllPerfis.Enabled := False;
          mniAtribuirTodosPerfis.Enabled := False;
          mniSelAllPerfisAtribuidos.Enabled := False;
          mniRevogarTodosPerfis.Enabled := False;
        end;
    end;
end;

procedure TfrmUsuarios.sbtnPermissoesExpandirTudoClick(Sender: TObject);
begin
  if tvPermissoes.Visible then
    tvPermissoes.FullExpand;
end;

procedure TfrmUsuarios.sbtnPesquisarClick(Sender: TObject);
begin
  if edtPesquisar.Visible = True then
    begin
      edtPesquisar.Clear;
      edtPesquisar.Visible := False;
      lstvwUsuarios.ItemIndex := -1;
      FoundResult := -1;
    end
  else
    begin
      edtPesquisar.Visible := True;
      edtPesquisar.SetFocus;
    end;
end;

procedure TfrmUsuarios.sbtnPermissoesRecolherTudoClick(Sender: TObject);
begin
  if tvPermissoes.Visible then
    tvPermissoes.FullCollapse;
end;

procedure TfrmUsuarios.sbtnSalvarClick(Sender: TObject);
var
  Ativo, nTentativas, ResetSenha, ID_Usuario_Operacao: String;
  i, j: Integer;
begin
  try
    if ckbxStatus.Checked then
      begin
        Ativo := '1';
        nTentativas := '0'
      end
    else
      Ativo := '0';

    if ckbxResetSenha.Checked then
      ResetSenha := '1'
    else
      ResetSenha := '0';

    if Acao = 'ADICIONAR' then
      begin
       if edtUsuario.Text = EmptyStr then
         begin
           Application.MessageBox('Informe o usuário','Aviso', MB_ICONWARNING + MB_OK);
           edtUsuario.SetFocus;
           Exit;
         end;
       if ((ParamVincPessoa)
         and (ModoVincPessoa = 'O')
         and (edtIDPessoa.Text = EmptyStr))then
         begin
           Application.MessageBox('É necessário selecionar uma pessoa para vincular ao usuário','Aviso', MB_ICONWARNING + MB_OK);
           edtIDPessoa.SetFocus;
           Exit;
         end;
       if edtNome.Text = EmptyStr then
         begin
           Application.MessageBox('Informe o nome do usuário','Aviso', MB_ICONWARNING + MB_OK);
           edtNome.SetFocus;
           Exit;
         end;
       if ((ModoAutenticacao = 'L')
           and (edtSenha.Text = EmptyStr)) then
         begin
           Application.MessageBox('Informe uma senha inicial','Aviso', MB_ICONWARNING + MB_OK);
           edtSenha.SetFocus;
           Exit;
         end;
       Self.Cursor := crSQLWait;
       SQLExec(sqlqUsuariosOperacao,['SELECT id_usuario, usuario, nome, status','FROM g_usuarios','WHERE LOWER(usuario) = '''+LowerCase(edtUsuario.Text)+''' ORDER BY id_usuario']);
       Self.Cursor := crDefault;
         if LowerCase(sqlqUsuariosOperacao.FieldByName('usuario').text) = LowerCase(edtUsuario.Text) then
          begin
            Application.MessageBox(PChar('O usuário '+LowerCase(edtUsuario.Text)+' já está registrado para '+sqlqUsuariosOperacao.Fields[2].AsString),'Aviso',MB_ICONEXCLAMATION + MB_OK);
            edtUsuario.SetFocus;
            Exit;
          end;

       if not PermMultUser then
         begin
         Self.Cursor := crSQLWait;
         SQLExec(sqlqUsuariosOperacao,['SELECT id_usuario, usuario, id_pessoa, nome, status, (SELECT nome FROM p_pessoas WHERE id_pessoa = '''+edtIDPessoa.Text+''') nome_pessoa'
                                      ,'FROM g_usuarios'
                                      ,'WHERE id_pessoa = '''+edtIDPessoa.Text+''' ORDER BY id_usuario']);
         Self.Cursor := crDefault;
           if ((edtIDPessoa.Text <> EmptyStr) and (sqlqUsuariosOperacao.FieldByName('id_pessoa').text = edtIDPessoa.Text)) then
            begin
              Application.MessageBox(PChar('O usuário '+LowerCase(sqlqUsuariosOperacao.FieldByName('usuario').Text)+' já está registrado para '+sqlqUsuariosOperacao.FieldByName('nome_pessoa').Text),'Aviso',MB_ICONEXCLAMATION + MB_OK);
              edtUsuario.SetFocus;
              Exit;
            end;
         end;

       Self.Cursor := crSQLWait;
       SQLExec(sqlqUsuariosOperacao,['INSERT INTO g_usuarios (usuario, senha, id_pessoa, nome, status, resetar_senha_prox_login, n_tentativas, modo_autenticacao)',
                                     'VALUES ('''+LowerCase(edtUsuario.Text)+''','''+edtSenha.Text+''','''+edtIDPessoa.Text+''','''+edtNome.Text+''','''+Ativo+''','''+ResetSenha+''','''+nTentativas+''','''+ModoAutenticacao+''')']);

        //Captura o id do usuário criado
        ID_Usuario_Operacao := SQLQuery(sqlqUsuariosOperacao,['SELECT id_usuario','FROM g_usuarios','WHERE LOWER(usuario) = '''+LowerCase(edtUsuario.Text)+''''],'id_usuario');
        Self.Cursor := crDefault;

        //Verifica se o usuário tem perfis de acesso para atribuir
        if CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
          begin
            Self.Cursor := crSQLWait;
            for i := Low(PerfisAcessoTemp) to High(PerfisAcessoTemp) do
              begin
                if PerfisAcessoTemp[i,2] = 'I' then
                  begin
                    SQLExec(sqlqPerfisAcessoAtribuidos,['INSERT INTO g_usuarios_perfis_acessos (id_perfil_acesso, id_usuario)'
                                                       ,'VALUES ('''+PerfisAcessoTemp[i,0]+''','''+ID_Usuario_Operacao+''')']);

                    //Após gravar o registro, limpa o campo de controle do array
                    PerfisAcessoTemp[i,2] := '';
                  end;
              end;
            Self.Cursor := crDefault;
          end;

        //Verifica se o usuário tem permissão para conceder/revogar permissões
        if CheckPermission(UserPermissions,Modulo,'SEGPMSTS') then
          begin
            Self.Cursor := crSQLWait;
            for i := Low(PermissoesTemp) to High(PermissoesTemp) do
              begin
                if PermissoesTemp[i,2] = '1' then
                  begin
                    SQLExec(sqlqPermissoesUsuariosOperacoes,['INSERT INTO g_usuarios_permissoes (id_usuario, modulo, cod_permissao, permissao)'
                                                            ,'VALUES ('''+ID_Usuario_Operacao+''','''+PermissoesTemp[i,0]+''','''+PermissoesTemp[i,1]+''','''+PermissoesTemp[i,2]+''')']);
                  end;
              end;
            Self.Cursor := crDefault;
          end;

        sbtnAtualizar.Click;
        ID_Usuario_Selecionado := ID_Usuario_Operacao;
        edtIDUsuario.Text := ID_Usuario_Operacao;
        edtUsuario.Text := LowerCase(edtUsuario.Text);
        lstvwUsuarios.Items.Item[lstvwUsuarios.FindCaption(0,ID_Usuario_Operacao,True,True,True,True).Index].Selected := True;
        lstvwUsuarios.Items.Item[lstvwUsuarios.FindCaption(0,ID_Usuario_Operacao,True,True,True,True).Index].Focused := True;
        edtUsuario.Enabled := False;
        edtIDPessoa.Enabled := False;
        edtNome.Enabled := False;
        sbtnLocalizarPessoa.Enabled := False;
        edtSenha.Enabled := False;
        cbModoAutenticacao.Enabled := False;
        ckbxStatus.Enabled := False;
        edtSenha.Visible := False;
        sbtnMostarSenha.Visible := False;
        ckbxResetSenha.Visible := False;
        cbModoAutenticacao.Visible := False;
        gpbxUsuario.Height := 92;
        lstvwPerfisAtribuidos.Enabled := False;
        sbtnAtribuirSelecionados.Enabled := False;
        sbtnAtribuirTodos.Enabled := False;
        sbtnRevogarSelecionados.Enabled := False;
        sbtnRevogarTodos.Enabled := False;
        sbtnVisualizarPermissoes.Enabled := False;
        mniSelAllPerfis.Enabled := False;
        mniAtribuirTodosPerfis.Enabled := False;
        mniSelAllPerfisAtribuidos.Enabled := False;
        mniRevogarTodosPerfis.Enabled := False;
        pstsDireito.Repaint;
        Acao := EmptyStr;
        ModoAutenticacao := EmptyStr;
        Editado := False;
        Application.MessageBox(PChar('Usuário '''+LowerCase(edtUsuario.Text)+''' criado com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
      end;

    if Acao = 'EDITAR' then
      begin
        if edtUsuario.Text = EmptyStr then
          begin
            Application.MessageBox('Informe o usuário','Aviso', MB_ICONWARNING + MB_OK);
            edtUsuario.SetFocus;
            Exit;
          end;
        if edtNome.Text = EmptyStr then
          begin
            Application.MessageBox('Informe o nome do usuário','Aviso', MB_ICONWARNING + MB_OK);
            edtNome.SetFocus;
            Exit;
          end;
        if ((ModoAutenticacaoAtual = 'D')
           and (ModoAutenticacao = 'L')
           and (edtSenha.Text = EmptyStr)) then
         begin
           Application.MessageBox('Informe uma senha','Aviso', MB_ICONWARNING + MB_OK);
           edtSenha.SetFocus;
           Exit;
         end;

        if ModoAutenticacao = EmptyStr then
          ModoAutenticacao := ModoAutenticacaoAtual;

        Self.Cursor := crSQLWait;
        SQLQuery(sqlqUsuariosOperacao,['SELECT id_usuario, usuario, id_pessoa, nome, status','FROM g_usuarios','WHERE LOWER(usuario) = '''+LowerCase(edtUsuario.Text)+''' ORDER BY id_usuario']);
        Self.Cursor := crDefault;
        if ((LowerCase(sqlqUsuariosOperacao.Fields[1].AsString) = LowerCase(edtUsuario.Text))
            and (LowerCase(edtUsuario.Text) <> Usuario_Selecionado)) then
          begin
            Application.MessageBox(PChar('O usuário '+LowerCase(edtUsuario.Text)+' já está registrado para '+sqlqUsuariosOperacao.Fields[2].AsString),'Aviso',MB_ICONEXCLAMATION + MB_OK);
            edtUsuario.SetFocus;
            Exit;
          end;
        Self.Cursor := crSQLWait;
        sqlqUsuariosOperacao.Close;

        SQLExec(sqlqUsuariosOperacao,['UPDATE g_usuarios SET'
                                     ,'usuario = '''+LowerCase(edtUsuario.Text)+''', id_pessoa = '''+edtIDPessoa.Text+''', nome = '''+edtNome.Text+''', status = '''+Ativo+''', '
                                     ,'n_tentativas = '''+nTentativas+''', modo_autenticacao = '''+ModoAutenticacao+''''
                                     ,'WHERE id_usuario = '+ID_Usuario_Selecionado]);
        if CompareStr(ModoAutenticacaoAtual, ModoAutenticacao) <> 0 then
          begin
            SQLExec(sqlqUsuariosOperacao,['UPDATE g_usuarios SET'
                                         ,'senha = '''+edtSenha.Text+''', resetar_senha_prox_login = '''+ResetSenha+''''
                                         ,'WHERE id_usuario = '+ID_Usuario_Selecionado]);
          end;
        Self.Cursor := crDefault;
      end;

    //Grava os perfis e permissões de usuários
    if ((Acao = 'EDITAR')
        or (Acao = 'EDITAR_PERMISSOES')) then
      begin
        //Grava os perfis de acesso
        if CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
          begin
            for i := Low(PerfisAcessoTemp) to High(PerfisAcessoTemp) do
              begin
                //Checa se foram removidos perfis de acesso
                if PerfisAcessoTemp[i,2] = 'E' then
                  begin
                    SQLExec(sqlqPerfisAcessoAtribuidos,['DELETE FROM g_usuarios_perfis_acessos'
                                                       ,'WHERE    id_perfil_acesso = '''+PerfisAcessoTemp[i,0]+''''
                                                       ,'     AND id_usuario       = '''+ID_Usuario_Selecionado+'''']);

                    //Após excluir o registro, limpa o campo de controle do array
                    PerfisAcessoTemp[i,2] := '';
                  end;

                //Checa se foram acrescentados perfis de acesso
                if PerfisAcessoTemp[i,2] = 'I' then
                  begin
                    SQLExec(sqlqPerfisAcessoAtribuidos,['INSERT INTO g_usuarios_perfis_acessos (id_perfil_acesso, id_usuario)'
                                                       ,'VALUES ('''+PerfisAcessoTemp[i,0]+''','''+ID_Usuario_Selecionado+''')']);

                    //Após gravar o registro, limpa o campo de controle do array
                    PerfisAcessoTemp[i,2] := '';
                  end;
              end;
          end;

        //Grava as permissões de acesso
        if CheckPermission(UserPermissions,Modulo,'SEGPMSTS') then
          begin
            for i := Low(PermissoesTemp) to High(PermissoesTemp) do
              begin
                //Verifica se houve alteração na permissão
                if PermissoesTemp[i,3] = '1' then
                  begin
                    //Verifica se o usuário já possui a permissão
                    for j := Low(PermissoesUsuario) to High(PermissoesUsuario) do
                      begin
                        {showmessage('PermissoesUsuario[j,1] '+PermissoesUsuario[j,1]+#13+
                                    'PermissoesTemp[i,0] '+PermissoesTemp[i,0]+#13+
                                    'PermissoesUsuario[j,2] '+PermissoesUsuario[j,2]+#13+
                                    'PermissoesTemp[i,1] '+PermissoesTemp[i,1]+#13+
                                    'PermissoesUsuario[j,3] '+PermissoesUsuario[j,3]+#13+
                                    'PermissoesTemp[i,2] '+PermissoesTemp[i,2]+#13); }
                        if (MatchStr(PermissoesUsuario[j,1],PermissoesTemp[i,0])
                           and MatchStr(PermissoesUsuario[j,2],PermissoesTemp[i,1]))
                           and (StrToBool(PermissoesUsuario[j,3]) <> StrToBool(PermissoesTemp[i,2])) then
                          begin
                            {SQLExec(sqlqPermissoesUsuariosOperacoes,['UPDATE g_usuarios_permissoes SET',
                                                                     'permissao = '''+PermissoesTemp[i,2]+'''',
                                                                     'WHERE id_usuario = '''+ID_Usuario_Selecionado+'''',
                                                                     'AND modulo = '''+PermissoesTemp[i,0]+'''',
                                                                     'AND cod_permissao = '''+PermissoesTemp[i,1]+'''']);}
                            //Caso a permissão esteja atribuída e foi removida na edição, apagar o registro na tabela de permissões do usuário
                            SQLExec(sqlqPermissoesUsuariosOperacoes,['DELETE FROM g_usuarios_permissoes'
                                                                    ,'WHERE id_usuario       = '''+ID_Usuario_Selecionado+''''
                                                                    ,'  AND modulo           = '''+PermissoesTemp[i,0]+''''
                                                                    ,'  AND cod_permissao    = '''+PermissoesTemp[i,1]+'''']);

                            PermissoesTemp[i,3] := '0';
                          end;
                      end;

                  //Verifica se o status de alteração da permissão foi alterado para realizado
                  //Caso ainda não tenha sido alterado insere a permissão para o usuário, pois o mesmo ainda não deve ter a permissão registrada para seu login
                  if ((PermissoesTemp[i,3] = '1')
                     and (StrToBool(PermissoesTemp[i,2]))) then
                     begin
                       sqlqPermissoesUsuariosOperacoes.Close;
                       SQLExec(sqlqPermissoesUsuariosOperacoes,['INSERT INTO g_usuarios_permissoes (id_usuario, modulo, cod_permissao, permissao)',
                                                                'VALUES ('''+ID_Usuario_Selecionado+''','''+PermissoesTemp[i,0]+''','''+PermissoesTemp[i,1]+''','''+PermissoesTemp[i,2]+''')']);

                       PermissoesTemp[i,3] := '0';
                     end;
                  end;
              end;


            {//Carrega as permissoes do usuário
            {Self.Cursor := crSQLWait;
            SQLExec(sqlqPermissoesUsuario,['SELECT id_usuario, modulo, cod_permissao, permissao',
                                           'FROM g_usuarios_permissoes',
                                           'WHERE id_usuario = '''+ID_Usuario_Selecionado+'''']);
            Self.Cursor := crHourGlass;}

            for i := Low(PermissoesTemp) to High(PermissoesTemp) do
              begin
                //Verifica se houve alteração na permissão
                if PermissoesTemp[i,3] = '1' then
                  begin
                    //Verifica se o usuário já possui a permissão
                    for j := Low(PermissoesUsuario) to High(PermissoesUsuario) do
                      begin
                        if (MatchStr(PermissoesUsuario[j,1],PermissoesTemp[i,0]) and MatchStr(PermissoesUsuario[j,2],PermissoesTemp[i,1])) then
                          begin


                    //Self.Cursor := crSQLWait;

                    {sqlqPermissoesUsuario.First;
                    while not sqlqPermissoesUsuario.EOF do
                      begin
                        if (MatchStr(sqlqPermissoesUsuario.Fields[1].AsString,PermissoesTemp[i,0]) and MatchStr(sqlqPermissoesUsuario.Fields[2].AsString,PermissoesTemp[i,1])) then
                          begin
                            //sqlqPermissoesUsuariosOperacoes.Close; }
                            SQLExec(sqlqPermissoesUsuariosOperacoes,['UPDATE g_usuarios_permissoes SET',
                                                                     'permissao = '''+PermissoesTemp[i,2]+'''',
                                                                     'WHERE id_usuario = '''+ID_Usuario_Selecionado+'''',
                                                                     'AND modulo = '''+PermissoesTemp[i,0]+'''',
                                                                     'AND cod_permissao = '''+PermissoesTemp[i,1]+'''']);
                            Self.Cursor := crHourGlass;
                            PermissoesTemp[i,3] := '0';
                          end;
                        //sqlqPermissoesUsuario.Next;
                      end;

                  //Verifica se o status de alteração da permissão foi alterado para realizado
                  //Caso ainda não tenha sido alterado insere a permissão para o usuário, pois o mesmo ainda não deve ter a permissão registrada para seu login
                  if PermissoesTemp[i,3] = '1' then
                     begin
                       Self.Cursor := crSQLWait;
                       sqlqPermissoesUsuariosOperacoes.Close;
                       SQLExec(sqlqPermissoesUsuariosOperacoes,['INSERT INTO g_usuarios_permissoes (id_usuario, modulo, cod_permissao, permissao)',
                                                                'VALUES ('''+ID_Usuario_Selecionado+''','''+PermissoesTemp[i,0]+''','''+PermissoesTemp[i,1]+''','''+PermissoesTemp[i,2]+''')']);
                       Self.Cursor := crHourGlass;
                       PermissoesTemp[i,3] := '0';
                     end;
                  end;
              end;
            Self.Cursor := crDefault;}
          end;

        ID_Usuario_Operacao := ID_Usuario_Selecionado;
        sbtnAtualizar.Click;
        ID_Usuario_Operacao := SQLQuery(sqlqUsuariosOperacao,['SELECT id_usuario','FROM g_usuarios','WHERE LOWER(usuario) = '''+LowerCase(edtUsuario.Text)+''''],'id_usuario');
        ID_Usuario_Selecionado := ID_Usuario_Operacao;
        edtUsuario.Text := LowerCase(edtUsuario.Text);
        lstvwUsuarios.Items.Item[lstvwUsuarios.FindCaption(0,ID_Usuario_Operacao,True,True,True,True).Index].Selected := True;
        lstvwUsuarios.Items.Item[lstvwUsuarios.FindCaption(0,ID_Usuario_Operacao,True,True,True,True).Index].Focused := True;
        edtUsuario.Enabled := False;
        edtIDPessoa.Enabled := False;
        edtNome.Enabled := False;
        sbtnLocalizarPessoa.Enabled := False;
        ckbxStatus.Enabled := False;
        cbModoAutenticacao.Enabled := False;
        edtSenha.Enabled := False;
        sbtnMostarSenha.Enabled := False;
        ckbxResetSenha.Enabled := False;
        lstvwPerfisAtribuidos.Enabled := False;
        sbtnAtribuirSelecionados.Enabled := False;
        sbtnAtribuirTodos.Enabled := False;
        sbtnRevogarSelecionados.Enabled := False;
        sbtnRevogarTodos.Enabled := False;
        mniSelAllPerfis.Enabled := False;
        mniAtribuirTodosPerfis.Enabled := False;
        mniSelAllPerfisAtribuidos.Enabled := False;
        mniRevogarTodosPerfis.Enabled := False;
        pstsDireito.Repaint;
        Acao := EmptyStr;
        ModoAutenticacaoAtual := EmptyStr;
        ModoAutenticacao := EmptyStr;
        Editado := False;
        Application.MessageBox(PChar('Informações atualizadas com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar salvar as alterações'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.sbtnAddUsuarioClick(Sender: TObject);
var
  item: TListItem;
  i: Integer;
begin
  if Acao = EmptyStr then
    begin
      Acao := 'ADICIONAR';
      if lstvwUsuarios.SelCount > 0 then
        begin
          ID_Usuario_Selecionado := EmptyStr;
          Usuario_Selecionado := EmptyStr;
          CleanForm(Self);
        end;

      Index_Novo_Usuario := lstvwUsuarios.Items.Count;
      ID_Usuario_Selecionado := '999'+IntToStr(Index_Novo_Usuario);
      item := lstvwUsuarios.Items.Add;
      item.Caption := ID_Usuario_Selecionado;
      item.SubItems.Add('<<Novo usuário>>');
      item.SubItems.Add('');
      item.SubItems.Add('');
      lstvwUsuarios.Items.Item[lstvwUsuarios.Items.Count-1].Selected := True;
      lstvwUsuarios.Items.Item[lstvwUsuarios.Items.Count-1].Focused := True;
      CleanForm(Self);
      edtUsuario.Enabled := True;
      edtUsuario.SetFocus;
      edtIDPessoa.Enabled := True;
      edtNome.Enabled := True;
      sbtnLocalizarPessoa.Enabled := True;
      ckbxStatus.Checked := True;
      if CheckPermission(UserPermissions,Modulo,'SEGUSSTS') then
        ckbxStatus.Enabled := True
      else
        ckbxStatus.Enabled := False;
      //Configura a exibição dos dados de vínculo da pessoa
      if ParamVincPessoa then
        begin
          if ModoVincPessoa = 'O' then
            edtNome.Enabled := False
          else
            edtNome.Enabled := True;
        end
      else
        edtNome.Enabled := True;
      if CheckPermission(UserPermissions,Modulo,'SEGPUSTS') then
        begin
          lstvwPerfisAcesso.Enabled := True;
          lstvwPerfisAtribuidos.Enabled := True;
          sbtnAtribuirSelecionados.Enabled := True;
          sbtnAtribuirTodos.Enabled := True;
          sbtnRevogarSelecionados.Enabled := True;
          sbtnRevogarTodos.Enabled := True;
          sbtnVisualizarPermissoes.Enabled := True;
          mniSelAllPerfis.Enabled := True;
          mniAtribuirTodosPerfis.Enabled := True;
          mniSelAllPerfisAtribuidos.Enabled := True;
          mniRevogarTodosPerfis.Enabled := True;
        end
      else
        begin
          lstvwPerfisAcesso.Enabled := False;
          lstvwPerfisAtribuidos.Enabled := False;
          sbtnAtribuirSelecionados.Enabled := False;
          sbtnAtribuirTodos.Enabled := False;
          sbtnRevogarSelecionados.Enabled := False;
          sbtnRevogarTodos.Enabled := False;
          sbtnVisualizarPermissoes.Enabled := False;
          mniSelAllPerfis.Enabled := False;
          mniAtribuirTodosPerfis.Enabled := False;
          mniSelAllPerfisAtribuidos.Enabled := False;
          mniRevogarTodosPerfis.Enabled := False;
        end;

      if ((gAutentLocal)
          and (not gAutentDom))then
        begin
          ModoAutenticacao := 'L';
          gpbxUsuario.Height := 120;
          lblModoAutenticacao.Visible := False;
          cbModoAutenticacao.Visible := False;
          lblSenha.Visible := True;
          lblSenha.Top := 74;
          edtSenha.Visible := True;
          edtSenha.Top := 70;
          sbtnMostarSenha.Visible := True;
          sbtnMostarSenha.Enabled := True;
          sbtnMostarSenha.Top := 69;
          edtSenha.Enabled := True;
          ckbxResetSenha.Visible := True;
          ckbxResetSenha.Top := 72;
          ckbxResetSenha.Enabled := True;
          ckbxResetSenha.Checked := True;
        end
      else if ((not gAutentLocal)
               and (gAutentDom))then
        begin
          ModoAutenticacao := 'D';
          gpbxUsuario.Height := 92;
          lblModoAutenticacao.Visible := False;
          cbModoAutenticacao.Visible := False;
          lblSenha.Visible := False;
          edtSenha.Visible := False;
          sbtnMostarSenha.Visible := False;
          sbtnMostarSenha.Enabled := False;
          edtSenha.Enabled := False;
          ckbxResetSenha.Visible := False;
          ckbxResetSenha.Enabled := False;
          ckbxResetSenha.Checked := False;
        end
      else if ((gAutentLocal)
               and (gAutentDom))then
        begin
          gpbxUsuario.Height := 120;
          lblModoAutenticacao.Visible := True;
          lblModoAutenticacao.Top := 74;
          cbModoAutenticacao.Visible := True;
          cbModoAutenticacao.Enabled := True;
          cbModoAutenticacao.Top := 70;
          edtSenha.Visible := False;
          sbtnMostarSenha.Visible := False;
          sbtnMostarSenha.Enabled := False;
          edtSenha.Enabled := False;
          ckbxResetSenha.Visible := False;
          ckbxResetSenha.Enabled := False;
          ckbxResetSenha.Checked := False;
        end;

      pnlPermissoesEsqTitulo.Caption := TitPerm+' [ <<Novo usuário>> ]';

      //Limpa as permissões de usuário
      for i := Low(PermissoesUsuario) to High(PermissoesUsuario) do
        begin
          PermissoesUsuario[i,0] := EmptyStr;
          PermissoesUsuario[i,1] := EmptyStr;
          PermissoesUsuario[i,2] := EmptyStr;
          PermissoesUsuario[i,3] := EmptyStr;
        end;

      //Limpa as alterações nas permissões
      for i := Low(PermissoesTemp) to High(PermissoesTemp) do
        begin
          PermissoesTemp[i,2] := '0';
          PermissoesTemp[i,3] := '0';
        end;
    end;
end;

procedure TfrmUsuarios.AtivarDesativarUsuario(idUsuario: String);
var
  txtStatusAtual, txtStatusAtualizado, Status: String;
begin
  try
    if StrToInt(idUsuario) > 0 then
      begin
        if sqlqUsuarios.FieldByName('status').AsBoolean then
          begin
            txtStatusAtual := 'desativar';
            txtStatusAtualizado := 'desativado';
            Status := '0';
          end
        else
          begin
            txtStatusAtual := 'ativar';
            txtStatusAtualizado := 'ativado';
            Status := '1';
          end;

        if Application.MessageBox(PChar('Deseja realmente '+txtStatusAtual+' o usuário '''+Usuario_Selecionado+'''?'),'Confirmação',MB_ICONQUESTION + MB_YESNO) = MRYES then
          begin
            SQLExec(sqlqUsuariosOperacao,['UPDATE g_usuarios SET',
                                          'status = '''+Status+''', n_tentativas = 0',
                                          'WHERE id_usuario = '''+idUsuario+'''']);
            Log(LowerCase(Modulo),'usuários','ativar/desativar usuário',idUsuario,gID_Usuario_Logado,gUsuario_Logado,'<<usuário '+idUsuario+'-'+Usuario_Selecionado+' '+txtStatusAtualizado+'>>');
            Application.MessageBox(PChar('Usuário '''+Usuario_Selecionado+''' '+txtStatusAtualizado+' com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
            sbtnAtualizar.Click;
          end;
      end
    else
      begin
        Application.MessageBox(PChar('Selecione um usuário para ativar/desativar'),'Aviso',MB_ICONINFORMATION + MB_OK);
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar ativar/desativar usuário'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.SelecionarModoAutenticacao(Modo: String);
begin
  case Modo of
      'D':
        begin
          ModoAutenticacao := 'D';
          gpbxUsuario.Height := 120;
          lblSenha.Visible := False;
          edtSenha.Visible := False;
          edtSenha.Text := EmptyStr;
          sbtnMostarSenha.Visible := False;
          sbtnMostarSenha.Enabled := False;
          edtSenha.Enabled := False;
          ckbxResetSenha.Visible := False;
          ckbxResetSenha.Enabled := False;
          ckbxResetSenha.Checked := False;
        end;
      'L':
        begin
          ModoAutenticacao := 'L';
          if ((Acao = 'ADICIONAR')
              or ((Acao = 'EDITAR')
                  and ((ModoAutenticacaoAtual = 'D')
                       or (ModoAutenticacaoAtual = EmptyStr))))then
            begin
              gpbxUsuario.Height := 155;
              lblSenha.Visible := True;
              lblSenha.Top := 106;
              edtSenha.Visible := True;
              edtSenha.Top := 102;
              sbtnMostarSenha.Visible := True;
              sbtnMostarSenha.Enabled := True;
              sbtnMostarSenha.Top := 101;
              edtSenha.Enabled := True;
              ckbxResetSenha.Visible := True;
              ckbxResetSenha.Top := 104;
              ckbxResetSenha.Enabled := True;
              ckbxResetSenha.Checked := True;
            end;
        end;
    end;
  if ModoAutenticacaoAtual <> ModoAutenticacao then Editado := True;
end;

procedure TfrmUsuarios.CheckNode(Node: TTreeNode; Checked:boolean);
begin
  if Assigned(Node) then
    begin
    //Verifica se a permissão foi atribuida por grupo. Caso sim bloqueia a edição
      if not (BlockEditPermissao(ID_Usuario_Selecionado,Node.Text)) then
        begin
          if Checked then
            Node.StateIndex := 1
          else
            Node.StateIndex := 0;
        end;
    end;
end;

procedure TfrmUsuarios.ToggleTreeViewCheckBoxes(Node: TTreeNode);
begin
  if Assigned(Node) then
    begin
      //Verifica se a permissão foi atribuida por grupo. Caso sim bloqueia a edição
      if not (BlockEditPermissao(ID_Usuario_Selecionado,Node.Text)) then
        begin
          if Node.StateIndex = 0 then
            Node.StateIndex := 1
          else if Node.StateIndex = 1 then
            Node.StateIndex := 0;
        end;
    end;
end;

procedure TfrmUsuarios.ToggleTreeViewCheckBoxes(Node: TTreeNode; Checked: Boolean);
begin
  if Assigned(Node) then
    begin
      //Verifica se a permissão foi atribuida por grupo. Caso sim bloqueia a edição
      if not (BlockEditPermissao(ID_Usuario_Selecionado,Node.Text)) then
        begin
          if Checked then
             Node.StateIndex := 1
          else
            Node.StateIndex := 0;
        end;
    end;
end;

function TfrmUsuarios.NodeChecked(ANode:TTreeNode): Boolean;
begin
  Result := (ANode.StateIndex = 1);
end;

procedure TfrmUsuarios.tvPermissoesClick(Sender: TObject);
var
  P: TPoint;
  Node: TTreeNode;
  HT: THitTests;
  TreeView: TTreeView;
begin
  TreeView := (Sender as TTreeView);
  if ((Acao <> EmptyStr)
      and (CheckPermission(UserPermissions,Modulo,'SEGPMSTS')))then
    begin
      GetCursorPos(P);
      P := TreeView.ScreenToClient(P);
      HT := TreeView.GetHitTestInfoAt(P.X, P.Y);
      if (htOnStateIcon in HT) then
        begin
          Node := TreeView.GetNodeAt(P.X, P.Y);

          ToggleTreeViewCheckBoxes(Node);

          SelParentNode(Node);

          Editado := True;
          setPermission(Node);
        end;
    end;
end;

procedure TfrmUsuarios.SelParentNode(Node: TTreeNode);
var
  i: Integer;
  NodeParent: TTreeNode;
begin
  i := Node.Level;
  NodeParent := Node.Parent;
  if i > 0 then
    begin
      //Verifica se a permissão foi atribuida por grupo. Caso sim bloqueia a edição
      if not (BlockEditPermissao(ID_Usuario_Selecionado,Node.Text)) then
        begin
          while i > 0 do
            begin
              if NodeParent.StateIndex = 0 then
                NodeParent.StateIndex := 1;
              setPermission(NodeParent);
              i := i-1;
              if NodeParent.Level > 0 then
                NodeParent := NodeParent.Parent;
            end;
        end;
    end;
end;

procedure TfrmUsuarios.lstvwUsuariosCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if ((PermAutoEditUser = False)
      and (Item.Caption = gID_Usuario_Logado)) then
    Sender.Canvas.Font.Color := clMaroon
  else
    //Sender.Canvas.Font.Color := clDefault;
    if ((Sender.Items.Item[Item.Index].SubItems.Count > 0)
        and (Item.SubItems[2] = 'False')) then
      Sender.Canvas.Font.Color := clGray
    else
      Sender.Canvas.Font.Color := clDefault;
end;

procedure TfrmUsuarios.mniAtribuirTodosPerfisClick(Sender: TObject);
begin
  sbtnAtribuirTodos.Click;
end;

procedure TfrmUsuarios.mniCopiarDeClick(Sender: TObject);
begin
  CopiarPermissoes(ID_Usuario_Selecionado, Usuario_Selecionado, 'DE');
end;

procedure TfrmUsuarios.mniCopiarParaClick(Sender: TObject);
begin
  CopiarPermissoes(ID_Usuario_Selecionado, Usuario_Selecionado, 'PARA');
end;

procedure TfrmUsuarios.mniRevogarTodosPerfisClick(Sender: TObject);
begin
  sbtnRevogarTodos.Click;
end;

procedure TfrmUsuarios.mniSelAllPerfisAtribuidosClick(Sender: TObject);
var
  n, i: integer;
  PerfilSelecionado: TListItems;
begin
  try
    PerfilSelecionado := lstvwPerfisAtribuidos.Items;
    n := PerfilSelecionado.Count-1;
    if ((n >= 0)
      and ((Acao = 'EDITAR')
           or (Acao = 'EDITAR_PERMISSOES'))) then
      begin
        for i:=0 to n do
          begin
            if StrToBool(PerfilSelecionado.Item[i].SubItems.Strings[1]) then
              PerfilSelecionado.Item[i].Selected := True;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar selecionar todos os itens'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.mniSelAllPerfisClick(Sender: TObject);
var
  n, i: integer;
  Perfil: TListItems;
begin
  try
    Perfil := lstvwPerfisAcesso.Items;
    n := Perfil.Count-1;
    if ((n >= 0)
      and ((Acao = 'EDITAR')
           or (Acao = 'EDITAR_PERMISSOES'))) then
      begin
        for i:=0 to n do
          begin
            if StrToBool(Perfil.Item[i].SubItems.Strings[1]) then
              Perfil.Item[i].Selected := True;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar selecionar todos os itens'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.pmnCopiarPermissoesPopup(Sender: TObject);
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      mniCopiarDe.Caption := 'Copiar permissões de "'+Usuario_Selecionado+'"';
      mniCopiarPara.Caption := 'Copiar permissões para "'+Usuario_Selecionado+'"';
    end;
end;

procedure TfrmUsuarios.pnlComandosSelecaoResize(Sender: TObject);
begin
  pnlBotoesSelecao.Top := Round(pnlComandosSelecao.Height/2)-Round(pnlBotoesSelecao.Height/2);
end;

procedure TfrmUsuarios.lstvwPerfisAcessoCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if ((Sender.Items.Item[Item.Index].SubItems.Count > 0)
      and (Item.SubItems[1] = 'False')) then
    Sender.Canvas.Font.Color := clGray
  else
    Sender.Canvas.Font.Color := clDefault;
end;

procedure TfrmUsuarios.lstvwPerfisAtribuidosCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if ((Sender.Items.Item[Item.Index].SubItems.Count > 0)
      and (Item.SubItems[1] = 'False')) then
    Sender.Canvas.Font.Color := clGray
  else
    Sender.Canvas.Font.Color := clDefault;
end;

procedure TfrmUsuarios.edtIDPessoaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_RETURN)
      or (Key = VK_TAB))then
    begin
      if edtIDPessoa.Text = EmptyStr then
        begin
          sbtnLocalizarPessoa.Click;
          Exit;
        end
      else
        begin
          CarregarPessoa(edtIDPessoa.Text);
          SelectNext(ActiveControl,True,True);
        end;
    end;
end;

procedure TfrmUsuarios.lstvwPerfisAcessoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_A) then
    SelectAll(lstvwPerfisAcesso);

  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = VK_A) then
    mniAtribuirTodosPerfis.Click;
end;

procedure TfrmUsuarios.lstvwPerfisAtribuidosKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_A) then
    mniSelAllPerfisAtribuidos.Click;

  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = VK_R) then
    mniRevogarTodosPerfis.Click;
end;

procedure TfrmUsuarios.lstvwPerfisAtribuidosSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if lstvwPerfisAtribuidos.SelCount > 0 then
    begin
      //Verifica se há um usuário selecionado
      if ID_Usuario_Selecionado = EmptyStr then
        begin
          lstvwPerfisAcesso.Selected.Selected := False;
          Abort;
        end;

      //Verifica se o perfil está inativo não permite selecionar
      if  Item.SubItems[1] = 'False' then
        begin
          lstvwPerfisAtribuidos.Selected.Selected:=False;
          Abort;
        end;
    end;
end;

procedure TfrmUsuarios.lstvwPerfisAcessoSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if lstvwPerfisAcesso.SelCount > 0 then
    begin
      //Verifica se há um usuário selecionado
      if ID_Usuario_Selecionado = EmptyStr then
        begin
          lstvwPerfisAcesso.Selected.Selected := False;
          Abort;
        end;

      //Verifica se o perfil está inativo não permite selecionar
      if  Item.SubItems[1] = 'False' then
        begin
          lstvwPerfisAcesso.Selected.Selected := False;
          Abort;
        end;
    end;
end;

procedure TfrmUsuarios.pstsPerfisResize(Sender: TObject);
begin
  //Ajusta o tamanho dos paineis de seleção dos perfis de acesso
  pnlPerfisAcesso.Width := round((pstsPerfis.Width/2)-pnlComandosSelecao.Width);
end;

procedure TfrmUsuarios.sbtnAtribuirSelecionadosClick(Sender: TObject);
var
  i, n, x: Integer;
  Perfil: TListItems;
  PerfilSelecionado: TListItem;
begin
  try
    Perfil := lstvwPerfisAcesso.Items;
    n := Perfil.Count-1;
    if n >= 0 then
      begin
        for i := 0 to n do
          begin
            if Perfil.Item[i].Selected
              and StrToBool(Perfil.Item[i].SubItems.Strings[1]) then
              begin
                PerfilSelecionado := lstvwPerfisAtribuidos.Items.Add;
                PerfilSelecionado.Caption := Perfil.Item[i].Caption;
                PerfilSelecionado.SubItems.Add(Perfil.Item[i].SubItems.Strings[0]);
                PerfilSelecionado.SubItems.Add(Perfil.Item[i].SubItems.Strings[1]);

                //PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp ,0,Perfil.Item[i].Caption),2] := 'I';
                AcaoPerfilAcesso(Perfil.Item[i].Caption,'I');
              end;
          end;

        i := n;
        while i >= 0 do
          begin
            if Perfil.Item[i].Selected
              and StrToBool(Perfil.Item[i].SubItems.Strings[1]) then
              Perfil.Item[i].Delete;
            i := i-1;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar atribuir os perfis de acesso selecionados'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.sbtnAtribuirTodosClick(Sender: TObject);
var
  n, i: integer;
  Perfil: TListItems;
  PerfilSelecionado: TListItem;
begin
  try
    Perfil := lstvwPerfisAcesso.Items;
    n := Perfil.Count-1;
    if n >= 0 then
      begin
        //Preenche os dados do listview perfis para o listview perfis selecionados
        for i:=0 to n do
          begin
            if StrToBool(Perfil.Item[i].SubItems.Strings[1]) then
              begin
                PerfilSelecionado := lstvwPerfisAtribuidos.Items.Add;
                PerfilSelecionado.Caption := Perfil.Item[i].Caption;
                PerfilSelecionado.SubItems.Add(Perfil.Item[i].SubItems.Strings[0]);
                PerfilSelecionado.SubItems.Add(Perfil.Item[i].SubItems.Strings[1]);

                AcaoPerfilAcesso(Perfil.Item[i].Caption,'I');
              end;
          end;
        //Apaga os perfis selecionados da lista de perfis disponíveis para seleção
        i := n;
        while i >= 0 do
          begin
            if StrToBool(Perfil.Item[i].SubItems.Strings[1]) then
              Perfil.Item[i].Delete;
            i := i-1;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar atribuir os perfis de acesso'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.sbtnCopiarPermissoesClick(Sender: TObject);
var
 vPonto : TPoint;
begin
  if lstvwUsuarios.SelCount > 0 then
    begin
      vPonto := sbtnCopiarPermissoes.ClientToScreen(Point(0, sbtnCopiarPermissoes.Height));
      pmnCopiarPermissoes.PopUp(vPonto.x,vPonto.y);
      //pmnCopiarPermissoes.PopUp;
    end
  else
    begin
      CopiarPermissoes;
    end;
end;

procedure TfrmUsuarios.sbtnCopiarPermissoesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TfrmUsuarios.sbtnLocalizarPessoaClick(Sender: TObject);
begin
  frmPesquisar := TfrmPesquisar.Create(Self);
  frmPesquisar.RefConsulta := 'Usuários';
  frmPesquisar.ShowModal;
end;

procedure TfrmUsuarios.sbtnRevogarSelecionadosClick(Sender: TObject);
var
  n, i: integer;
  PerfilSelecionado: TListItems;
  Perfil: TListItem;
begin
  try
    PerfilSelecionado := lstvwPerfisAtribuidos.Items;
    n := PerfilSelecionado.Count-1;
    if n >= 0 then
      begin
        //Preenche os perfis com os dados dos perfis selecionados
        for i:=0 to n do
          begin
            if PerfilSelecionado.Item[i].Selected
              and StrToBool(PerfilSelecionado.Item[i].SubItems.Strings[1]) then
              begin
                Perfil := lstvwPerfisAcesso.Items.Add;
                Perfil.Caption := PerfilSelecionado.Item[i].Caption;
                Perfil.SubItems.Add(PerfilSelecionado.Item[i].SubItems.Strings[0]);
                Perfil.SubItems.Add(PerfilSelecionado.Item[i].SubItems.Strings[1]);

                AcaoPerfilAcesso(PerfilSelecionado.Item[i].Caption,'E');
              end;
          end;
        //Remove os perfis selecionados
        i := n;
        while i >= 0 do
          begin
            if PerfilSelecionado.Item[i].Selected
              and StrToBool(PerfilSelecionado.Item[i].SubItems.Strings[1]) then
              PerfilSelecionado.Item[i].Delete;
            i := i-1;
          end;
      end;
   except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar revogar os perfis de acesso selecionados'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.sbtnRevogarTodosClick(Sender: TObject);
var
  n, i: integer;
  PerfilSelecionado: TListItems;
  Perfil: TListItem;
begin
  try
    PerfilSelecionado := lstvwPerfisAtribuidos.Items;
    n := PerfilSelecionado.Count-1;
    if n >= 0 then
      begin
        //Preenche os perfis com os dados dos perfis selecionados
        for i:=0 to n do
          begin
            if StrToBool(PerfilSelecionado.Item[i].SubItems.Strings[1]) then
              begin
                Perfil := lstvwPerfisAcesso.Items.Add;
                Perfil.Caption := PerfilSelecionado.Item[i].Caption;
                Perfil.SubItems.Add(PerfilSelecionado.Item[i].SubItems.Strings[0]);
                Perfil.SubItems.Add(PerfilSelecionado.Item[i].SubItems.Strings[1]);

                AcaoPerfilAcesso(PerfilSelecionado.Item[i].Caption,'E');
              end;
          end;
        //Remove os perfis selecionados
        i := n;
        while i >= 0 do
          begin
            if StrToBool(PerfilSelecionado.Item[i].SubItems.Strings[1]) then
              PerfilSelecionado.Item[i].Delete;
            i := i-1;
          end;
      end;
   except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar revogar os perfis de acesso'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmUsuarios.sbtnVisualizarPermissoesClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=Low(PerfisAcessoTemp) to High(PerfisAcessoTemp) do
    begin
      ShowMessage(inttostr(i)+': '+PerfisAcessoTemp[i,0]+' >> '+PerfisAcessoTemp[i,1]+' >> '+PerfisAcessoTemp[i,2]);
    end;
end;

procedure TfrmUsuarios.setPermission(Node: TTreeNode);
var
  x, y: Integer;
  Checked, ModuloPU, CodPermissaoPU: String;
begin
  if CheckPermission(UserPermissions,Modulo,'SEGPMACS') then
    begin
      if NodeChecked(Node) then
        Checked := '1'
      else
        Checked := '0';

      sqlqBasePermissoes.Filtered := False;
      sqlqBasePermissoes.Filter := '';
      sqlqBasePermissoes.Filter := 'descricao = '''+Node.Text+'''';
      sqlqBasePermissoes.Filtered := True;

      ModuloPU := sqlqBasePermissoes.FieldByName('modulo').Text;
      CodPermissaoPU := sqlqBasePermissoes.FieldByName('cod_permissao').Text;

      sqlqBasePermissoes.Filtered := False;
      sqlqBasePermissoes.Filter := '';

      for x := Low(PermissoesTemp) to High(PermissoesTemp) do
        begin
          if MatchStr(ModuloPU, PermissoesTemp[x,0]) then
            begin
              for y := Low(PermissoesTemp) to High(PermissoesTemp) do
                if MatchStr(ModuloPU, PermissoesTemp[x,0])
                   and MatchStr(CodPermissaoPU, PermissoesTemp[y,1]) then
                  begin
                    PermissoesTemp[y,2] := Checked;
                    PermissoesTemp[y,3] := '1';
                    Exit;
                  end;
            end;
        end;
    end;
end;

function TfrmUsuarios.CheckPermissao(ID_Usuario, DescPermissao: String): Boolean;
var
  SQL1, SQL2: TSQLQuery;
begin
  Result := False;

  //Cria o componente TSQLQuery para executar a consulta na base de permissões
  SQL1 := TSQLQuery.Create(Nil);
  SQL1.DataBase := dmConexao.ConexaoDB;
  SQL1.Transaction := dmConexao.sqltTransactions;

  //Consulta a permissao filtrando pela descrição (descrição = item da TreeView)
  SQLQuery(SQL1,['SELECT id_permissao, classificacao, modulo, cod_permissao, descricao, nivel'
                ,'FROM g_base_permissoes'
                ,'WHERE descricao = '''+DescPermissao+''''
                ,'ORDER BY classificacao']);

  if SQL1.RecordCount > 0 then
    begin
      //Cria o componente TSQLQuery para executar a consulta das permissões do usuários
      SQL2 := TSQLQuery.Create(Nil);
      SQL2.DataBase := dmConexao.ConexaoDB;
      SQL2.Transaction := dmConexao.sqltTransactions;

      //Verifica se o usuário possui a permissão selecionada na TreeView
      {SQLQuery(SQL2,['SELECT id_usuario, modulo, cod_permissao, permissao'
                    ,'FROM g_usuarios_permissoes'
                    ,'WHERE id_usuario = '''+ID_Usuario+''''
                    ,'AND cod_permissao = '''+SQL1.Fields.FieldByName('cod_permissao').Text+''''],'permissao');}
      SQLQuery(SQL2,['SELECT  DISTINCT'
                    ,'        modulo'
                    ,'      , cod_permissao'
                    ,'      , permissao'
                    //,'      , ''U'' tipo'
                    ,'FROM g_usuarios_permissoes'
                    ,'WHERE    id_usuario    = '+ID_Usuario
                    ,'     AND cod_permissao = '''+SQL1.Fields.FieldByName('cod_permissao').Text+''''

                    ,'UNION ALL'

                    ,'SELECT  DISTINCT'
                    ,'         modulo'
                    ,'       , cod_permissao'
                    ,'       , permissao'
                    //,'      , ''G'' tipo'
                    ,'FROM g_perfis_acesso_permissoes'
                    ,'WHERE    excluido         =  false'
                    ,'     AND id_perfil_acesso IN ( SELECT id_perfil_acesso'
                    ,'                               FROM g_usuarios_perfis_acessos'
                    ,'                               WHERE id_usuario = '''+ID_Usuario+''')'
                    ,'     AND cod_permissao    =  '''+SQL1.Fields.FieldByName('cod_permissao').Text+''''

                    ,'GROUP BY modulo, cod_permissao, permissao'

                    ,'ORDER BY modulo, cod_permissao'],'permissao');

      Result := SQL2.FieldByName('permissao').AsBoolean;
    end;

  //Libera da memória os componentes TSQLQuery criados
  SQL1.Free;
  SQL2.Free;
end;

function TfrmUsuarios.BlockEditPermissao(ID_Usuario, DescPermissao: String): Boolean;
var
  SQL1, SQL2: TSQLQuery;
  n: Integer;
begin
  Result := False;

  //Cria o componente TSQLQuery para executar a consulta na base de permissões
  SQL1 := TSQLQuery.Create(Nil);
  SQL1.DataBase := dmConexao.ConexaoDB;
  SQL1.Transaction := dmConexao.sqltTransactions;

  //Consulta a permissao filtrando pela descrição (descrição = item da TreeView)
  SQLQuery(SQL1,['SELECT id_permissao, classificacao, modulo, cod_permissao, descricao, nivel'
                ,'FROM g_base_permissoes'
                ,'WHERE descricao = '''+DescPermissao+''''
                ,'ORDER BY classificacao']);

  if SQL1.RecordCount > 0 then
    begin
      //Cria o componente TSQLQuery para executar a consulta das permissões do usuários
      SQL2 := TSQLQuery.Create(Nil);
      SQL2.DataBase := dmConexao.ConexaoDB;
      SQL2.Transaction := dmConexao.sqltTransactions;

      //Verifica se o usuário possui a permissão selecionada na TreeView
      {SQLQuery(SQL2,['SELECT id_usuario, modulo, cod_permissao, permissao, id_perfil_acesso'
                    ,'FROM g_usuarios_permissoes'
                    ,'WHERE id_usuario = '''+ID_Usuario+''''
                    ,'AND cod_permissao = '''+SQL1.Fields.FieldByName('cod_permissao').Text+''''],'id_perfil_acesso');}

      SQLQuery(SQL2,['SELECT *'
                    ,'FROM g_perfis_acesso_permissoes'
                    ,'WHERE    excluido = false'
                    ,'     AND cod_permissao = '''+SQL1.Fields.FieldByName('cod_permissao').Text+''''
                    ,'     AND id_perfil_acesso IN ( SELECT id_perfil_acesso'
                    ,'                               FROM g_usuarios_perfis_acessos'
                    ,'                               WHERE id_usuario = '''+ID_Usuario+''')'
                    ,'GROUP BY modulo, cod_permissao, permissao'
                    ,'ORDER BY modulo, cod_permissao']);
      //Result := SQL2.FieldByName('permissao').AsBoolean;
      //if SQL2.FieldByName('id_perfil_acesso').AsInteger > 0 then
      if SQL2.RecordCount > 0 then
        Result := true
      else
        Result := false;

      //Libera da memória os componentes TSQLQuery criados
      SQL2.Free;
    end;

  //Libera da memória os componentes TSQLQuery criados
  SQL1.Free;
end;

procedure TfrmUsuarios.tvPermissoesCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if BlockEditPermissao(ID_Usuario_Selecionado,Node.Text) then
    begin
      Sender.Canvas.Font.Color := clGrayText;
    end;
end;

procedure TfrmUsuarios.tvPermissoesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  TreeView: TTreeView;
  Node: TTreeNode;
begin
  if ((Key = VK_SPACE)
     and (Acao <> EmptyStr)
     and (CheckPermission(UserPermissions,Modulo,'SEGPMSTS'))) then
    begin
      TreeView := (Sender as TTreeView);
      Node := TreeView.Selected;
      ToggleTreeViewCheckBoxes(Node);
      Editado := True;
      setPermission(Node);
    end;
end;

procedure TfrmUsuarios.tvPermissoesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ((Button = mbRight)
      and (lstvwUsuarios.SelCount > 0)
      and (CheckPermission(UserPermissions,Modulo,'SEGPMACS'))) then
    pmnPermissoes.Popup;
end;

function TfrmUsuarios.IDNode(TreeView: TTreeView): Integer;
var
  P: TPoint;
  Node: TTreeNode;
begin
  GetCursorPos(P);
  P := TreeView.ScreenToClient(P);
  Node := TreeView.GetNodeAt(P.X, P.Y);

  if Assigned(Node) then
    Result := Node.AbsoluteIndex
  else
    Result := -1;
end;

procedure TfrmUsuarios.AcaoPerfilAcesso(IDPerfilAcesso, AcaoRequisitada: String);
begin
  if AcaoRequisitada = 'I' then
    begin
      if PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp,0,IDPerfilAcesso),1] = 'A' then
        PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp,0,IDPerfilAcesso),2] := ''
      else
        PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp,0,IDPerfilAcesso),2] := 'I';
    end
  else if AcaoRequisitada = 'E' then
    begin
      if PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp,0,IDPerfilAcesso),1] = 'A' then
        PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp,0,IDPerfilAcesso),2] := 'E'
      else
        PerfisAcessoTemp[IndexArrayString(PerfisAcessoTemp,0,IDPerfilAcesso),2] := '';
    end;
end;

procedure TfrmUsuarios.CarregarPessoa(ID: String);
begin
  try
    SQLQuery(sqlqConsPessoa,['SELECT id_pessoa, nome, cpf',
                             'FROM p_pessoas',
                             'WHERE excluido = false',
                                   'AND id_pessoa = '+ID]);

    if sqlqConsPessoa.RecordCount > 0 then
      begin
        edtNome.Text := sqlqConsPessoa.Fields.FieldByName('nome').AsString;
      end
    else
      begin
        Application.MessageBox(PChar('Código de pessoa '''+ID+''' não localizado'+#13+'Verifique se o código informado está correto'), '', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar carregar dados de pessoa'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

end.
