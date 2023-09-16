unit UPerfisUsuarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  CommCtrl, SQLDB, LCLType, LCLIntf, ExtCtrls, Buttons, PairSplitter,
  ShellCtrls, Menus, laz.VirtualTrees, StrUtils;

type

  { TfrmPerfisUsuarios }

  TfrmPerfisUsuarios = class(TForm)
    Bevel1: TBevel;
    ckbxStatus: TCheckBox;
    edtPerfilAcesso: TEdit;
    edtIDPerfilAcesso: TEdit;
    gpbxPerfisAcesso: TGroupBox;
    imglCheckBoxTreeView: TImageList;
    lblDetalhe: TLabel;
    lblPerfilAcesso: TLabel;
    lblIDPerfilAcesso: TLabel;
    lstvwPerfisAcesso: TListView;
    mniSelecionarTudo: TMenuItem;
    mniDeselecionarTudo: TMenuItem;
    mniSelecionarTodosItens: TMenuItem;
    mniDeselecionarTodosItens: TMenuItem;
    LN1: TMenuItem;
    mmDetalhe: TMemo;
    pnlPermissoesDirComandos: TPanel;
    pnlPermissoesEsqTitulo: TPanel;
    pnlBasePermissoes: TPanel;
    pnlPermissoes: TPanel;
    pnlComandosOper: TPanel;
    pnlEsqTitulo: TPanel;
    pmnPermissoesPerfil: TPopupMenu;
    pstConteudo: TPairSplitter;
    pstsEsquerdo: TPairSplitterSide;
    pstsDireito: TPairSplitterSide;
    pnlComandos: TPanel;
    sbtnAtualizar: TSpeedButton;
    sbtnAddPerfil: TSpeedButton;
    sbtnEditPerfil: TSpeedButton;
    sbtnEditarPermissoes: TSpeedButton;
    sbtnCopiarPermissoes: TSpeedButton;
    sbtnDelPerfil: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnExpandirTudo: TSpeedButton;
    sbtnRecolherTudo: TSpeedButton;
    sbtnReprocAcessos: TSpeedButton;
    sqlqPerfisAcesso: TSQLQuery;
    sqlqBasePermissoes: TSQLQuery;
    sqlqPermissoesPerfilAcesso: TSQLQuery;
    tvPermissoes: TTreeView;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure lstvwPerfisAcessoCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstvwPerfisAcessoDblClick(Sender: TObject);
    procedure lstvwPerfisAcessoInsert(Sender: TObject; Item: TListItem);
    procedure lstvwPerfisAcessoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvwPerfisAcessoResize(Sender: TObject);
    procedure lstvwPerfisAcessoSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure mmDetalheChange(Sender: TObject);
    procedure mniDeselecionarTodosItensClick(Sender: TObject);
    procedure mniDeselecionarTudoClick(Sender: TObject);
    procedure mniSelecionarTodosItensClick(Sender: TObject);
    procedure mniSelecionarTudoClick(Sender: TObject);
    procedure pmnPermissoesPerfilPopup(Sender: TObject);
    procedure sbtnAddPerfilClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure defaultView;
    procedure sbtnCancelarClick(Sender: TObject);
    function CheckPermissao(ID_PerfilAcesso, DescPermissao: String): Boolean;
    procedure sbtnDelPerfilClick(Sender: TObject);
    procedure sbtnEditarPermissoesClick(Sender: TObject);
    procedure sbtnEditPerfilClick(Sender: TObject);
    procedure sbtnExpandirTudoClick(Sender: TObject);
    procedure sbtnRecolherTudoClick(Sender: TObject);
    procedure sbtnReprocAcessosClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure tvPermissoesClick(Sender: TObject);
    procedure tvPermissoesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function IDNode(TreeView: TTreeView): Integer;
    procedure ToggleTreeViewCheckBoxes(Node: TTreeNode);
    procedure setPermission(Node: TTreeNode);
    function NodeChecked(ANode:TTreeNode): Boolean;
    procedure SelAllChildNodes(Node: TTreeNode; CheckUncheck: Integer);
    procedure SelParentNode(Node: TTreeNode);

  private
    Acao: String;
    Editado: Boolean;
    PermissoesTemp, PermissoesPerfilAcesso: Array of Array of String;
    const
      Modulo: String = 'SEGURANCA';
      Formulario: String = 'PERFISUSUARIOS';
      TitPerm: String = 'Permissões';

  public
    ID_PerfilAcesso_Selecionado, PerfilAcesso_Selecionado: String;
    Index_Novo_Perfil_Acesso: Integer;
  end;

var
  frmPerfisUsuarios: TfrmPerfisUsuarios;

implementation

uses
  UGFunc, UConexao, UDBO;

{$R *.lfm}

{ TfrmPerfisUsuarios }


procedure TfrmPerfisUsuarios.FormShow(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,Modulo,'SEGPUCAD') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  Editado := False;
  sbtnAtualizar.Click;
end;

procedure TfrmPerfisUsuarios.lstvwPerfisAcessoCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if ((Sender.Items.Item[Item.Index].SubItems.Count > 0)
      and (Item.SubItems[1] = 'False')) then
    Sender.Canvas.Font.Color := clGray
  else
    Sender.Canvas.Font.Color := clDefault;
end;

procedure TfrmPerfisUsuarios.lstvwPerfisAcessoDblClick(Sender: TObject);
begin
  if (lstvwPerfisAcesso.SelCount > 0)
     and (CheckPermission(UserPermissions,Modulo,'SEGPUEDT')) then
    sbtnEditPerfil.Click;
end;

procedure TfrmPerfisUsuarios.lstvwPerfisAcessoInsert(Sender: TObject;
  Item: TListItem);
begin
  if lstvwPerfisAcesso.Column[1].Width <= lstvwPerfisAcesso.Width-4 then
    begin
      lstvwPerfisAcesso.Column[1].AutoSize := False;
      lstvwPerfisAcesso.Column[1].Width := lstvwPerfisAcesso.Width-4;
    end
  else
    lstvwPerfisAcesso.Column[1].AutoSize := True;
end;

procedure TfrmPerfisUsuarios.lstvwPerfisAcessoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    sbtnDelPerfil.Click;
end;

procedure TfrmPerfisUsuarios.lstvwPerfisAcessoResize(Sender: TObject);
begin
  if lstvwPerfisAcesso.Column[1].Width <= lstvwPerfisAcesso.Width-4 then
    begin
      lstvwPerfisAcesso.Column[1].AutoSize := False;
      lstvwPerfisAcesso.Column[1].Width := lstvwPerfisAcesso.Width-4;
    end
  else
    lstvwPerfisAcesso.Column[1].AutoSize := True;
end;

procedure TfrmPerfisUsuarios.lstvwPerfisAcessoSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  i, j, k: Integer;
  t: String;
begin
  if Acao = EmptyStr then
    begin
      if lstvwPerfisAcesso.SelCount > 0 then
        begin
          ID_PerfilAcesso_Selecionado := lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.Selected.Index].Caption;
          PerfilAcesso_Selecionado := lstvwPerfisAcesso.Items[lstvwPerfisAcesso.Selected.Index].SubItems[0];

        //Permissões de usuários
          if CheckPermission(UserPermissions,Modulo,'SEGPPACS') then
            begin
              //Self.Cursor := crSQLWait;
              pnlPermissoesEsqTitulo.Caption := TitPerm+' [ '+PerfilAcesso_Selecionado+' ]';

              SQLQuery(sqlqPermissoesPerfilAcesso,['SELECT id_perfil_acesso, modulo, cod_permissao, permissao'
                                                  ,'FROM g_perfis_acesso_permissoes'
                                                  ,'WHERE id_perfil_acesso = '''+ID_PerfilAcesso_Selecionado+'''']);

              //Marca as permissões na TreeView
              for k := 0 to tvPermissoes.Items.Count-1 do
                begin
                  if CheckPermissao(ID_PerfilAcesso_Selecionado,tvPermissoes.Items.Item[k].Text) then
                    tvPermissoes.Items.Item[k].StateIndex := 1
                  else
                    tvPermissoes.Items.Item[k].StateIndex := 0;
                end;

              //Limpa as permissões de usuário
              for i := Low(PermissoesPerfilAcesso) to High(PermissoesPerfilAcesso) do
                begin
                  PermissoesPerfilAcesso[i,0] := EmptyStr;
                  PermissoesPerfilAcesso[i,1] := EmptyStr;
                  PermissoesPerfilAcesso[i,2] := EmptyStr;
                  PermissoesPerfilAcesso[i,3] := EmptyStr;
                end;

              //Insere as permissões do usuário em uma matriz
              SetLength(PermissoesPerfilAcesso,sqlqPermissoesPerfilAcesso.RecordCount,4);
              j := 0;
              sqlqPermissoesPerfilAcesso.First;
              while not sqlqPermissoesPerfilAcesso.eof do
                begin
                  PermissoesPerfilAcesso[j,0] := sqlqPermissoesPerfilAcesso.Fields[0].AsString;
                  PermissoesPerfilAcesso[j,1] := sqlqPermissoesPerfilAcesso.Fields[1].AsString;
                  PermissoesPerfilAcesso[j,2] := sqlqPermissoesPerfilAcesso.Fields[2].AsString;
                  PermissoesPerfilAcesso[j,3] := sqlqPermissoesPerfilAcesso.Fields[3].AsString;

                  j := j+1;
                  sqlqPermissoesPerfilAcesso.Next;
                end;

              //Limpa as alterações nas permissões
              for i := Low(PermissoesTemp) to High(PermissoesTemp) do
                begin
                  PermissoesTemp[i,2] := '0';
                  PermissoesTemp[i,3] := '0';
                end;

              //Insere na matriz temporária as permissões do usuário
              for i := Low(PermissoesTemp) to High(PermissoesTemp) do
                begin
                  sqlqPermissoesPerfilAcesso.First;
                  while not sqlqPermissoesPerfilAcesso.EOF do
                    begin
                      //Verifica se o usuário possui a permissão e marca na permissão temporária
                      if (MatchStr(PermissoesTemp[i,0],sqlqPermissoesPerfilAcesso.Fields[1].AsString)
                         and MatchStr(PermissoesTemp[i,1],sqlqPermissoesPerfilAcesso.Fields[2].AsString))
                         and sqlqPermissoesPerfilAcesso.Fields[3].AsBoolean then
                        PermissoesTemp[i,2] := '1';

                        sqlqPermissoesPerfilAcesso.Next;
                    end;
                end;
            end;
        end
      else
        begin
          ID_PerfilAcesso_Selecionado := EmptyStr;
          pnlPermissoesEsqTitulo.Caption := TitPerm;

          //Desmarcas os checkboxes da TreeView
          for i := 0 to tvPermissoes.Items.Count-1 do
            tvPermissoes.Items.Item[i].StateIndex := 0;

          //Limpa as permissões de usuário
          for i := Low(PermissoesPerfilAcesso) to High(PermissoesPerfilAcesso) do
            begin
              PermissoesPerfilAcesso[i,0] := EmptyStr;
              PermissoesPerfilAcesso[i,1] := EmptyStr;
              PermissoesPerfilAcesso[i,2] := EmptyStr;
              PermissoesPerfilAcesso[i,3] := EmptyStr;
            end;

          //Limpa as alterações nas permissões
          for i := Low(PermissoesTemp) to High(PermissoesTemp) do
            begin
              PermissoesTemp[i,2] := '0';
              PermissoesTemp[i,3] := '0';
            end;
        end;
    end;
end;

procedure TfrmPerfisUsuarios.mmDetalheChange(Sender: TObject);
begin

end;

procedure TfrmPerfisUsuarios.mniDeselecionarTodosItensClick(Sender: TObject);
begin
  SelAllChildNodes(tvPermissoes.Selected, 1);
end;

procedure TfrmPerfisUsuarios.mniDeselecionarTudoClick(Sender: TObject);
var
  i: Integer;
begin
 for i := 0 to tvPermissoes.Items.Count-1 do
   begin
     tvPermissoes.Items.Item[i].StateIndex := 1;
     ToggleTreeViewCheckBoxes(tvPermissoes.Items.Item[i]);
     Editado := True;
     setPermission(tvPermissoes.Items.Item[i]);
   end;
end;

procedure TfrmPerfisUsuarios.mniSelecionarTodosItensClick(Sender: TObject);
begin
  SelAllChildNodes(tvPermissoes.Selected, 0);
end;

procedure TfrmPerfisUsuarios.mniSelecionarTudoClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to tvPermissoes.Items.Count-1 do
    begin
      tvPermissoes.Items.Item[i].StateIndex := 0;
      ToggleTreeViewCheckBoxes(tvPermissoes.Items.Item[i]);
      Editado := True;
      setPermission(tvPermissoes.Items.Item[i]);
    end;
end;

procedure TfrmPerfisUsuarios.pmnPermissoesPerfilPopup(Sender: TObject);
begin
  if (CheckPermission(UserPermissions,Modulo,'SEGPPSTS')
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

procedure TfrmPerfisUsuarios.sbtnAddPerfilClick(Sender: TObject);
var
  item: TListItem;
  i: Integer;
begin
  if Acao = EmptyStr then
    begin
      Acao := 'ADICIONAR';
      if lstvwPerfisAcesso.SelCount > 0 then
        begin
          ID_PerfilAcesso_Selecionado := EmptyStr;
          PerfilAcesso_Selecionado := EmptyStr;
          CleanForm(Self);
        end;

      Index_Novo_Perfil_Acesso := lstvwPerfisAcesso.Items.Count;
      item := lstvwPerfisAcesso.Items.Add;
      item.Caption := '999'+IntToStr(Index_Novo_Perfil_Acesso);
      item.SubItems.Add('<<Novo perfil de acesso>>');
      item.SubItems.Add('');
      lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.Items.Count-1].Selected := True;
      lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.Items.Count-1].Focused := True;
      CleanForm(Self);
      edtPerfilAcesso.Enabled := True;
      edtPerfilAcesso.SetFocus;
      mmDetalhe.Enabled := True;
      ckbxStatus.Checked := True;
      if CheckPermission(UserPermissions,Modulo,'SEGPUSTU') then
        ckbxStatus.Enabled := True
      else
        ckbxStatus.Enabled := False;

      pnlPermissoesEsqTitulo.Caption := TitPerm+' [ <<Novo perfil de acesso>> ]';

      //Limpa as permissões de usuário
      for i := Low(PermissoesPerfilAcesso) to High(PermissoesPerfilAcesso) do
        begin
          PermissoesPerfilAcesso[i,0] := EmptyStr;
          PermissoesPerfilAcesso[i,1] := EmptyStr;
          PermissoesPerfilAcesso[i,2] := EmptyStr;
          PermissoesPerfilAcesso[i,3] := EmptyStr;
        end;

      //Limpa as alterações nas permissões
      for i := Low(PermissoesTemp) to High(PermissoesTemp) do
        begin
          PermissoesTemp[i,2] := '0';
          PermissoesTemp[i,3] := '0';
        end;
    end;
end;

procedure TfrmPerfisUsuarios.sbtnAtualizarClick(Sender: TObject);
var
  item,itemPerm: TListItem;
  N1, N2, N3, i: Integer;
begin
  try
    Self.Cursor := crHourGlass;
    //Carrega a lista de perfis de acesso
    Self.Cursor := crSQLWait;
    SQLExec(sqlqPerfisAcesso,['SELECT id_perfil_acesso, perfil, detalhe, status, excluido'
                             ,'FROM g_perfis_acesso'
                             ,'WHERE excluido = false'
                             ,'ORDER BY perfil']);
    Self.Cursor := crHourGlass;
    if lstvwPerfisAcesso.SelCount > 0 then
       lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.Selected.Index].Selected := False;
    ID_PerfilAcesso_Selecionado := EmptyStr;
    lstvwPerfisAcesso.Clear;

    sqlqPerfisAcesso.First;
    while not sqlqPerfisAcesso.EOF do
      begin
        item := lstvwPerfisAcesso.Items.Add;
        item.Caption := sqlqPerfisAcesso.FieldByName('id_perfil_acesso').Text;
        item.SubItems.Add(sqlqPerfisAcesso.FieldByName('perfil').Text);
        item.SubItems.Add(sqlqPerfisAcesso.FieldByName('status').Text);

        sqlqPerfisAcesso.Next;
      end;

    //Carrega a lista de permissões
    if CheckPermission(UserPermissions,Modulo,'SEGPPACS') then
      begin
        //tvPermissoes.Enabled := False;
        tvPermissoes.Visible := True;
        sbtnExpandirTudo.Enabled := True;
        sbtnRecolherTudo.Enabled := True;

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
            if Length(PermissoesTemp) < sqlqBasePermissoes.RecordCount then
               SetLength(PermissoesTemp,sqlqBasePermissoes.RecordCount,4);

            while not sqlqBasePermissoes.EOF do
              begin
                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 1 then
                  begin
                    //showmessage('N1 '+inttostr(sqlqBasePermissoes.RecordCount)+' - '+inttostr(i));
                    tvPermissoes.Items.Add(nil,sqlqBasePermissoes.FieldByName('descricao').Text);
                    tvPermissoes.Items.Item[i].StateIndex := 0;
                    N1 := i;
                  end;

                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 2 then
                  begin
                    //showmessage('N2 '+inttostr(sqlqBasePermissoes.RecordCount)+' - '+inttostr(i));
                    tvPermissoes.Items.AddChild(tvPermissoes.Items.Item[N1], sqlqBasePermissoes.FieldByName('descricao').Text);
                    tvPermissoes.Items.Item[i].StateIndex := 0;
                    N2 := i;
                  end;

                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 3 then
                  begin
                    //showmessage('N3 '+inttostr(sqlqBasePermissoes.RecordCount)+' - '+inttostr(i));
                    tvPermissoes.Items.AddChild(tvPermissoes.Items.Item[N2], sqlqBasePermissoes.FieldByName('descricao').Text);
                    tvPermissoes.Items.Item[i].StateIndex := 0;
                    N3 := i;
                  end;

                if sqlqBasePermissoes.FieldByName('nivel').AsInteger = 4 then
                  begin
                    //showmessage('N4 '+inttostr(N3)+' | T'+inttostr(sqlqBasePermissoes.RecordCount)+' | N '+inttostr(i)+' > '+sqlqBasePermissoes.FieldByName('descricao').Text);
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
        tvPermissoes.Enabled := False;
        tvPermissoes.Items.Clear;
        tvPermissoes.Items.Add(nil,'Você não possui acesso a esta funcionalidade');
        tvPermissoes.Items.Item[0].StateIndex := -1;
        sbtnExpandirTudo.Enabled := False;
        sbtnRecolherTudo.Enabled := False;
      end;

    //Acao := EmptyStr;
    Self.Cursor := crDefault;
  except on E: exception do
    begin
      Self.Cursor := crDefault;
      Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmPerfisUsuarios.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnSalvar.Click;

  //if (ssCtrl in Shift) and (Key = VK_L) then
    //sbtnPesquisar.Click;
end;

procedure TfrmPerfisUsuarios.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    begin
      Key := #0;
      SelectNext(ActiveControl,True,True);
      Exit;
    end;
end;

procedure TfrmPerfisUsuarios.FormCreate(Sender: TObject);
begin
  if CheckPermission(UserPermissions,Modulo,'SEGPUADD') then
    sbtnAddPerfil.Enabled := True
  else
    sbtnAddPerfil.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGPUEDT') then
    sbtnEditPerfil.Enabled := True
  else
    sbtnEditPerfil.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGPPSTS') then
    sbtnEditarPermissoes.Enabled := True
  else
    sbtnEditarPermissoes.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGPPCPY') then
    sbtnCopiarPermissoes.Enabled := True
  else
    sbtnCopiarPermissoes.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGPPRPA') then
    sbtnReprocAcessos.Enabled := True
  else
    sbtnReprocAcessos.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'SEGPUDEL') then
    sbtnDelPerfil.Enabled := True
  else
    sbtnDelPerfil.Enabled := False;

  defaultView;
  Acao := EmptyStr;
  Editado := False;
end;

procedure TfrmPerfisUsuarios.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
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
          Abort;
      end;
    end
  else
    CloseAllFormOpenedConnections(Self);
end;

procedure TfrmPerfisUsuarios.defaultView;
begin
  edtPerfilAcesso.Enabled := False;
  mmDetalhe.Enabled := False;
  ckbxStatus.Enabled := False;
  pstsDireito.Repaint;
end;

procedure TfrmPerfisUsuarios.sbtnCancelarClick(Sender: TObject);
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
              if Index_Novo_Perfil_Acesso > 0 then
                begin
                 lstvwPerfisAcesso.Items.Item[Index_Novo_Perfil_Acesso].Delete;
                 Index_Novo_Perfil_Acesso := 0;
                 if tvPermissoes.Items.SelectionCount > 0 then
                   tvPermissoes.Selected.Selected := False;
                end;
            end;
          if Acao = 'EDITAR' then
            begin
              PerfilAcesso_Selecionado := sqlqPerfisAcesso.Fields[1].AsString;
              sqlqPerfisAcesso.Filter := 'id_perfil_acesso = '+ID_PerfilAcesso_Selecionado;
              sqlqPerfisAcesso.Filtered := True;
              edtIDPerfilAcesso.Text := sqlqPerfisAcesso.Fields[0].AsString;
              edtPerfilAcesso.Text := sqlqPerfisAcesso.Fields[1].AsString;
              mmDetalhe.Text := sqlqPerfisAcesso.Fields[2].AsString;
              ckbxStatus.Checked := sqlqPerfisAcesso.Fields[3].AsBoolean;
              sqlqPerfisAcesso.Filter := EmptyStr;
              sqlqPerfisAcesso.Filtered := False;
            end;

          //Default do formulário
          edtIDPerfilAcesso.Clear;
          edtPerfilAcesso.Enabled := False;
          edtPerfilAcesso.Clear;
          mmDetalhe.Enabled := False;
          mmDetalhe.Clear;
          ckbxStatus.Enabled := False;
          ckbxStatus.Checked := False;
          pstsDireito.Repaint;
          Acao := EmptyStr;
          Editado := False;
          pnlPermissoesEsqTitulo.Caption := TitPerm;

          //Desmarcar permissões na TreeView
          for i := 0 to tvPermissoes.Items.Count-1 do
            begin
              tvPermissoes.Items.Item[i].StateIndex := 0;
            end;

          //Limpa as permissões do perfil
          for i := Low(PermissoesPerfilAcesso) to High(PermissoesPerfilAcesso) do
            begin
              PermissoesPerfilAcesso[i,0] := EmptyStr;
              PermissoesPerfilAcesso[i,1] := EmptyStr;
              PermissoesPerfilAcesso[i,2] := EmptyStr;
              PermissoesPerfilAcesso[i,3] := EmptyStr;
            end;

          //Limpa as alterações nas permissões
          for i := Low(PermissoesTemp) to High(PermissoesTemp) do
            begin
              PermissoesTemp[i,2] := '0';
              PermissoesTemp[i,3] := '0';
            end;
          Self.Cursor := crDefault;
        end
      else
        begin
          Abort;
        end;
    end;
end;

function TfrmPerfisUsuarios.CheckPermissao(ID_PerfilAcesso, DescPermissao: String): Boolean;
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

      //Verifica se o perfil de acesso possui a permissão selecionada na TreeView
      SQLQuery(SQL2,['SELECT id_perfil_acesso, modulo, cod_permissao, permissao'
                    ,'FROM g_perfis_acesso_permissoes'
                    ,'WHERE id_perfil_acesso = '''+ID_PerfilAcesso+''''
                    ,'AND cod_permissao = '''+SQL1.Fields.FieldByName('cod_permissao').Text+''''],'permissao');

      Result := SQL2.FieldByName('permissao').AsBoolean;
    end;

  //Libera da memória os componentes TSQLQuery criados
  SQL1.Free;
  SQL2.Free;
end;

procedure TfrmPerfisUsuarios.sbtnDelPerfilClick(Sender: TObject);
var
  nUsu: Integer;
begin
  if lstvwPerfisAcesso.SelCount > 0 then
    begin
      if Application.MessageBox(PChar('Deseja realmente excluir o perfil '''+PerfilAcesso_Selecionado+'''?'),'Confirmação',MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          try
            Self.Cursor := crSQLWait;
            //Verifica se o perfil de acesso foi atribuído a algum usuário
            SQLQuery(sqlqPerfisAcesso,['SELECT COUNT(DISTINCT P.id_usuario) nUsu'
                                      ,'FROM g_usuarios_permissoes P'
                                      ,'WHERE P.id_perfil_acesso = '+ID_PerfilAcesso_Selecionado]
                                      ,'nUsu');
            nUsu := sqlqPerfisAcesso.FieldByName('nUsu').AsInteger;

            if nUsu > 0 then
              begin
                Application.MessageBox(PChar('Não é possível excluir o perfil de acesso '''+PerfilAcesso_Selecionado+''' pois o mesmo está sendo utilizado na atribuição de acessos de '''+IntToStr(nUsu)+''' usuários')
                                      ,'Aviso'
                                      ,MB_ICONSTOP + MB_OK);
                Abort;
                {//caso o perfil tenha sido atribuído faz a exclusão lógica
                //Exclui as permissões do perfil de acesso
                SQLExec(sqlqPermissoesPerfilAcesso,['UPDATE g_perfis_acesso_permissoes'
                                                        ,'SET excluido = 1'
                                                        ,'WHERE id_perfil_acesso = '''+ID_PerfilAcesso_Selecionado+'''']);
                //Exclui o perfil de acesso
                SQLExec(sqlqPerfisAcesso,['UPDATE g_perfis_acesso'
                                             ,'SET excluido = 1'
                                             ,'WHERE id_perfil_acesso = '''+ID_PerfilAcesso_Selecionado+'''']);}
              end
            else
              begin
                //caso o perfil não tenha sido atribuído a nenhum usuário, deleta os registros
                //Apaga as permissões do perfil de acesso
                SQLExec(sqlqPermissoesPerfilAcesso,['DELETE FROM g_perfis_acesso_permissoes'
                                                        ,'WHERE id_perfil_acesso = '''+ID_PerfilAcesso_Selecionado+'''']);
                //Apaga o perfil de acesso
                SQLExec(sqlqPerfisAcesso,['DELETE FROM g_perfis_acesso'
                                             ,'WHERE id_perfil_acesso = '''+ID_PerfilAcesso_Selecionado+'''']);

                Self.Cursor := crDefault;
                sbtnAtualizar.Click;
                Application.MessageBox(PChar('O perfil de acesso '''+PerfilAcesso_Selecionado+''' foi excluído com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
              end;
          finally

          end;
        end
      else
        Abort;
    end
  else
    begin
      Application.MessageBox(PChar('Selecione um perfil de acesso para exclusão'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;
end;

procedure TfrmPerfisUsuarios.sbtnEditarPermissoesClick(Sender: TObject);
var
  i, j: Integer;
begin
  if lstvwPerfisAcesso.SelCount > 0 then
    begin
      if Acao = EmptyStr then
        begin
          Self.Cursor := crHourGlass;
          if CheckPermission(UserPermissions,Modulo,'SEGPPSTS') then
            begin
              Acao := 'EDITAR_PERMISSOES';
              sqlqPerfisAcesso.Filter := 'id_perfil_acesso = '+ID_PerfilAcesso_Selecionado;
              sqlqPerfisAcesso.Filtered := True;
              edtIDPerfilAcesso.Text := sqlqPerfisAcesso.FieldByName('id_perfil_acesso').Text;
              edtPerfilAcesso.Text := sqlqPerfisAcesso.FieldByName('perfil').Text;
              mmDetalhe.Lines.Add(sqlqPerfisAcesso.FieldByName('detalhe').AsString);
              ckbxStatus.Checked := sqlqPerfisAcesso.FieldByName('status').AsBoolean;
              sqlqPerfisAcesso.Filter := EmptyStr;
              sqlqPerfisAcesso.Filtered := False;
            end;

          Self.Cursor := crDefault;
        end
      else
        sbtnCancelar.Click;
    end;
end;

procedure TfrmPerfisUsuarios.sbtnEditPerfilClick(Sender: TObject);
var
  i, j: Integer;
begin
  if lstvwPerfisAcesso.SelCount > 0 then
    begin
      if Acao = EmptyStr then
        begin
          Self.Cursor := crHourGlass;
          if CheckPermission(UserPermissions,Modulo,'SEGPUEDT') then
            begin
              Acao := 'EDITAR';
              sqlqPerfisAcesso.Filter := 'id_perfil_acesso = '+ID_PerfilAcesso_Selecionado;
              sqlqPerfisAcesso.Filtered := True;
              edtIDPerfilAcesso.Text := sqlqPerfisAcesso.FieldByName('id_perfil_acesso').Text;
              edtPerfilAcesso.Text := sqlqPerfisAcesso.FieldByName('perfil').Text;
              mmDetalhe.Lines.Add(sqlqPerfisAcesso.FieldByName('detalhe').AsString);
              ckbxStatus.Checked := sqlqPerfisAcesso.FieldByName('status').AsBoolean;
              sqlqPerfisAcesso.Filter := EmptyStr;
              sqlqPerfisAcesso.Filtered := False;
            end;

          edtPerfilAcesso.Enabled := true;
          mmDetalhe.Enabled := true;
          if CheckPermission(UserPermissions,Modulo,'SEGPUSTU') then
            ckbxStatus.Enabled := True
          else
            ckbxStatus.Enabled := False;

          Self.Cursor := crDefault;
        end
      else
        sbtnCancelar.Click;
    end
  else
    begin
      Application.MessageBox(PChar('Selecione um perfil de acesso para edição'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;
end;

procedure TfrmPerfisUsuarios.sbtnExpandirTudoClick(Sender: TObject);
begin
  if tvPermissoes.Visible then
    tvPermissoes.FullExpand;
end;

procedure TfrmPerfisUsuarios.sbtnRecolherTudoClick(Sender: TObject);
begin
  if tvPermissoes.Visible then
    tvPermissoes.FullCollapse;
end;

procedure TfrmPerfisUsuarios.sbtnReprocAcessosClick(Sender: TObject);
begin
  //Verifica se o usuário tem permissão para reprocessar
  if CheckPermission(UserPermissions,Modulo,'SEGPPRPA') then
    begin

    end;
end;

procedure TfrmPerfisUsuarios.sbtnSalvarClick(Sender: TObject);
var
  Ativo, PerfilExiste, ID_Perfil_Inserido: String;
  i, j: Integer;
begin
  try
    if ckbxStatus.Checked then
      Ativo := '1'
    else
      Ativo := '0';

    if Acao = EmptyStr then
      Exit;

    if edtPerfilAcesso.Text = EmptyStr then
      begin
        Application.MessageBox('Informe o nome do perfil de acesso','Aviso', MB_ICONWARNING + MB_OK);
        edtPerfilAcesso.SetFocus;
        Exit;
      end;

    Self.Cursor := crSQLWait;
    SQLExec(sqlqPerfisAcesso,['SELECT id_perfil_acesso, perfil, detalhe, status, excluido'
                             ,'FROM g_perfis_acesso'
                             ,'WHERE LOWER(perfil) = '''+LowerCase(edtPerfilAcesso.Text)+''''
                             ,'and excluido = false'
                             ,'ORDER BY id_perfil_acesso']);
    PerfilExiste := sqlqPerfisAcesso.FieldByName('perfil').Text;
    Self.Cursor := crDefault;

    if Acao = 'ADICIONAR' then
      begin
        if LowerCase(PerfilExiste) = LowerCase(edtPerfilAcesso.Text) then
          begin
            Application.MessageBox(PChar('O perfil de acesso '''+edtPerfilAcesso.Text+''' já está registrado')
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtPerfilAcesso.SetFocus;
            Exit;
          end;

      //Grava o cadastro do novo perfil de acesso
      Self.Cursor := crSQLWait;
      SQLExec(sqlqPerfisAcesso,['INSERT INTO g_perfis_acesso'
                               ,'(perfil, detalhe, status)'
                               ,'VALUES ('''+edtPerfilAcesso.Text+''','''+mmDetalhe.Lines.Text+''','''+Ativo+''')']);

      //Captura o id do perfil criado
      ID_Perfil_Inserido := SQLQuery(sqlqPerfisAcesso,['SELECT MAX(id_perfil_acesso) id'
                                                      ,'FROM g_perfis_acesso'
                                                      ,'WHERE LOWER(perfil) = '''+LowerCase(edtPerfilAcesso.Text)+''''
                                                      ,'and excluido = false']
                                                      ,'id');
      Self.Cursor := crDefault;

      //Verifica se o usuário tem permissão para conceder/revogar permissões aos perfis
      if CheckPermission(UserPermissions,Modulo,'SEGPPSTS') then
        begin
          Self.Cursor := crSQLWait;
          for i := Low(PermissoesTemp) to High(PermissoesTemp) do
            begin
              if PermissoesTemp[i,2] = '1' then
                begin
                  SQLExec(sqlqPermissoesPerfilAcesso,['INSERT INTO g_perfis_acesso_permissoes'
                                                     ,'(id_perfil_acesso, modulo, cod_permissao, permissao)'
                                                     ,'VALUES ('''+ID_Perfil_Inserido+''','''+PermissoesTemp[i,0]+''','''+PermissoesTemp[i,1]+''','''+PermissoesTemp[i,2]+''')']);
                end;
            end;
          Self.Cursor := crDefault;
        end;

      //Finaliza o processo de inclusão
      sbtnAtualizar.Click;
      ID_PerfilAcesso_Selecionado := ID_Perfil_Inserido;
      edtIDPerfilAcesso.Text := ID_Perfil_Inserido;
      lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.FindCaption(0,ID_Perfil_Inserido,True,True,True,True).Index].Selected := True;
      lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.FindCaption(0,ID_Perfil_Inserido,True,True,True,True).Index].Focused := True;
      edtPerfilAcesso.Enabled := False;
      ckbxStatus.Enabled := False;
      mmDetalhe.Enabled := False;
      pstsDireito.Repaint;
      Acao := EmptyStr;
      Editado := False;
      Application.MessageBox(PChar('Perfil de acesso '''+edtPerfilAcesso.Text+''' criado com sucesso!')
                            ,'Aviso'
                            ,MB_ICONINFORMATION + MB_OK);
    end;

    if Acao = 'EDITAR' then
      begin
        if ((LowerCase(PerfilExiste) = LowerCase(edtPerfilAcesso.Text))
            and (LowerCase(edtPerfilAcesso.Text) <> LowerCase(PerfilAcesso_Selecionado))) then
          begin
            Application.MessageBox(PChar('O perfil de acesso '''+edtPerfilAcesso.Text+''' já está registrado')
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtPerfilAcesso.SetFocus;
            Exit;
          end;

        sqlqPerfisAcesso.Close;

        Self.Cursor := crSQLWait;
        SQLExec(sqlqPerfisAcesso,['UPDATE g_perfis_acesso SET'
                                 ,'perfil = '''+edtPerfilAcesso.Text+''', detalhe = '''+mmDetalhe.Lines.Text+''', status = '''+Ativo+''''
                                 ,'WHERE id_perfil_acesso = '+ID_PerfilAcesso_Selecionado]);
        Self.Cursor := crDefault;
      end;

    if ((Acao = 'EDITAR')
        or (Acao = 'EDITAR_PERMISSOES')) then
      begin
        if CheckPermission(UserPermissions,Modulo,'SEGPPSTS') then
          begin
            for i := Low(PermissoesTemp) to High(PermissoesTemp) do
              begin
                //Verifica se houve alteração na permissão
                if PermissoesTemp[i,3] = '1' then
                  begin
                    //Verifica se a permissão já está atribuída ao perfil
                    for j := Low(PermissoesPerfilAcesso) to High(PermissoesPerfilAcesso) do
                      begin
                        if (MatchStr(PermissoesPerfilAcesso[j,1],PermissoesTemp[i,0])
                           and MatchStr(PermissoesPerfilAcesso[j,2],PermissoesTemp[i,1]))
                           and (StrToBool(PermissoesPerfilAcesso[j,3]) <> StrToBool(PermissoesTemp[i,2])) then
                          begin
                            {SQLExec(sqlqPermissoesPerfilAcesso,['UPDATE g_perfis_acesso_permissoes'
                                                               ,'SET permissao = '''+PermissoesTemp[i,2]+''''
                                                               ,'WHERE id_perfil_acesso = '''+ID_PerfilAcesso_Selecionado+''''
                                                                     ,'AND modulo = '''+PermissoesTemp[i,0]+''''
                                                                     ,'AND cod_permissao = '''+PermissoesTemp[i,1]+'''']);   }
                            //showmessage(PermissoesPerfilAcesso[j,1]+'>'+PermissoesPerfilAcesso[j,2]+'='+PermissoesPerfilAcesso[j,3]+' <> '+PermissoesTemp[i,0]+'>'+PermissoesTemp[i,1]+'='+PermissoesTemp[i,2]);

                            //Caso a permissão esteja atribuída e foi removida na edição, apagar o registro na tabela de permissões do perfil de acesso
                            SQLExec(sqlqPermissoesPerfilAcesso,['DELETE FROM g_perfis_acesso_permissoes'
                                                               ,'WHERE    id_perfil_acesso = '''+ID_PerfilAcesso_Selecionado+''''
                                                               ,'     AND modulo           = '''+PermissoesTemp[i,0]+''''
                                                               ,'     AND cod_permissao    = '''+PermissoesTemp[i,1]+'''']);

                            PermissoesTemp[i,3] := '0';
                          end;
                      end;

                  //Verifica se o status de alteração da permissão foi alterado para realizado
                  //Caso ainda não tenha sido alterado insere a permissão no perfil de acesso, pois o mesmo ainda não deve ter a permissão registrada
                  if ((PermissoesTemp[i,3] = '1')
                     and (StrToBool(PermissoesTemp[i,2]))) then
                     begin
                       sqlqPermissoesPerfilAcesso.Close;
                       SQLExec(sqlqPermissoesPerfilAcesso,['INSERT INTO g_perfis_acesso_permissoes (id_perfil_acesso, modulo, cod_permissao, permissao)',
                                                           'VALUES ('''+ID_PerfilAcesso_Selecionado+''','''+PermissoesTemp[i,0]+''','''+PermissoesTemp[i,1]+''','''+PermissoesTemp[i,2]+''')']);

                       PermissoesTemp[i,3] := '0';
                     end;
                  end;
              end;
          end;

        ID_Perfil_Inserido := ID_PerfilAcesso_Selecionado;
        sbtnAtualizar.Click;
        //ID_Perfil_Inserido := SQLQuery(sqlqPerfisAcesso,['SELECT MAX(id_perfil_acesso) id'
        //                                                ,'FROM g_perfis_acesso'
        //                                                ,'WHERE LOWER(perfil) = '''+LowerCase(edtPerfilAcesso.Text)+''''
        //                                                ,'and excluido = false']
        //                                                ,'id');
        ID_PerfilAcesso_Selecionado := ID_Perfil_Inserido;
        lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.FindCaption(0,ID_Perfil_Inserido,True,True,True,True).Index].Selected := True;
        lstvwPerfisAcesso.Items.Item[lstvwPerfisAcesso.FindCaption(0,ID_Perfil_Inserido,True,True,True,True).Index].Focused := True;
        edtPerfilAcesso.Enabled := False;
        mmDetalhe.Enabled := False;
        ckbxStatus.Enabled := False;
        pstsDireito.Repaint;
        Acao := EmptyStr;
        Editado := False;
        Application.MessageBox(PChar('Informações atualizadas com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
      end;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar salvar as alterações'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure TfrmPerfisUsuarios.tvPermissoesClick(Sender: TObject);
var
  P: TPoint;
  Node: TTreeNode;
  HT: THitTests;
  TreeView: TTreeView;
begin
  TreeView := (Sender as TTreeView);
  if ((Acao <> EmptyStr)
      and (CheckPermission(UserPermissions,Modulo,'SEGPPSTS')))then
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

procedure TfrmPerfisUsuarios.tvPermissoesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ((Button = mbRight)
      and (lstvwPerfisAcesso.SelCount > 0)
      and (CheckPermission(UserPermissions,Modulo,'SEGPPACS'))) then
    pmnPermissoesPerfil.Popup;
end;

function TfrmPerfisUsuarios.IDNode(TreeView: TTreeView): Integer;
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

procedure TfrmPerfisUsuarios.ToggleTreeViewCheckBoxes(Node: TTreeNode);
begin
  if Assigned(Node) then
    begin
      if Node.StateIndex = 0 then
        Node.StateIndex := 1
      else if Node.StateIndex = 1 then
        Node.StateIndex := 0;
    end;
end;

procedure TfrmPerfisUsuarios.setPermission(Node: TTreeNode);
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

function TfrmPerfisUsuarios.NodeChecked(ANode:TTreeNode): Boolean;
begin
  Result := (ANode.StateIndex = 1);
end;

procedure TfrmPerfisUsuarios.SelAllChildNodes(Node: TTreeNode; CheckUncheck: Integer);
var
  TempNode: TTreeNode;
begin
  if Assigned(Node) then
    begin
      {if CheckUncheck = 1 then
        CheckUncheck := 0
      else
        CheckUncheck := 1;}

      Node.StateIndex := CheckUncheck;
      ToggleTreeViewCheckBoxes(Node);
      Editado := True;
      setPermission(Node);

      TempNode := Node.GetFirstChild;
      if CheckUncheck = 0 then
         SelParentNode(Node);
      while TempNode <> Nil do
        begin
          if not TempNode.HasChildren then
            begin
              TempNode.StateIndex := CheckUncheck;
              ToggleTreeViewCheckBoxes(TempNode);
              Editado := True;
              setPermission(TempNode);
            end
          else
            SelAllChildNodes(TempNode, CheckUncheck);

          TempNode := Node.GetNextChild(TempNode);
        end;
    end;
end;

procedure TfrmPerfisUsuarios.SelParentNode(Node: TTreeNode);
var
  i: Integer;
  NodeParent: TTreeNode;
begin
  i := Node.Level;
  NodeParent := Node.Parent;
  if i > 0 then
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

end.

