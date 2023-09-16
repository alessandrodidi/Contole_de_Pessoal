unit URestricaoAcesso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, LCLType,
  ExtCtrls, Buttons, PairSplitter, ComCtrls, StdCtrls, MaskEdit, DBCtrls,
  DBGrids, BGRAColorTheme;

type

  { TfrmRestricaoAcesso }

  TfrmRestricaoAcesso = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnRemoverRestricao: TSpeedButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    ckbxRestContratacao: TCheckBox;
    ckbxRestAcessoRefeitorio: TCheckBox;
    ckbxRestAcessoEmpresa: TCheckBox;
    dsMotivosRestricao: TDataSource;
    dsPessoasRestricao: TDataSource;
    dbgHistoricoRestPessoa: TDBGrid;
    dbgPessoasRestricao: TDBGrid;
    gpbxHistorico: TGroupBox;
    gpbxPessoasRestricao: TGroupBox;
    gpbxRestricoes: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lkcbMotivoRestricao: TDBLookupComboBox;
    edtPessoaNome: TEdit;
    edtPessoa_ID: TEdit;
    edtPesquisar: TEdit;
    gpbxRestPessoa: TGroupBox;
    gpbxPessoa: TGroupBox;
    gpbxRestricao: TGroupBox;
    lblMotivoRestricao: TLabel;
    lblPessoaNome: TLabel;
    lblPessoaCPF: TLabel;
    lblID_Pessoa: TLabel;
    lstvwPessoas: TListView;
    mkedtDataFim: TMaskEdit;
    mkedtDataInicio: TMaskEdit;
    medtPessoaCPF: TMaskEdit;
    pnlComandosRestPessoa: TPanel;
    pnlBtnsAddRemove: TPanel;
    pnlAddRemove: TPanel;
    pnlEsqTitulo: TPanel;
    pstConteudo: TPairSplitter;
    pstsEsquerdo: TPairSplitterSide;
    pstsDireito: TPairSplitterSide;
    pnlComandos: TPanel;
    sbtnAtualizar: TSpeedButton;
    btnAddRestricao: TSpeedButton;
    sbtnPesquisar: TSpeedButton;
    sbtnCadMotivosRestricao: TSpeedButton;
    sbtnAddRestricao: TSpeedButton;
    sbtnEditarRestricao: TSpeedButton;
    sbtnExcluirRestricao: TSpeedButton;
    sbtnLocalizarPessoa: TSpeedButton;
    sbtnTrocarPessoa: TSpeedButton;
    sbtnEncerrarRestricao: TSpeedButton;
    sqlqPessoas: TSQLQuery;
    sqlqPessoasRestricao: TSQLQuery;
    sqlqMotivosRestricao: TSQLQuery;
    procedure btnSalvarClick(Sender: TObject);
    procedure edtPesquisarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure gpbxHistoricoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gpbxRestPessoaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gpbxRestPessoaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lkcbMotivoRestricaoDropDown(Sender: TObject);
    procedure lstvwPessoasCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lstvwPessoasCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstvwPessoasInsert(Sender: TObject; Item: TListItem);
    procedure lstvwPessoasResize(Sender: TObject);
    procedure lstvwPessoasSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure pnlAddRemoveResize(Sender: TObject);
    procedure sbtnAddRestricaoClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnEditarRestricaoClick(Sender: TObject);
    procedure sbtnPesquisarClick(Sender: TObject);
  private
    Editado, FormEditRestAberto, FormHistRestAberto: Boolean;
    Acao, ID_Pessoa: String;
    const
      Modulo: String = 'CADASTROS';
      Formulario: String = 'RESTPESSOAS';
  public

  end;

var
  frmRestricaoAcesso: TfrmRestricaoAcesso;

implementation

uses
  UGFunc, UDBO, UConexao;

{$R *.lfm}

{ TfrmRestricaoAcesso }

procedure TfrmRestricaoAcesso.FormCreate(Sender: TObject);
begin
  Editado := False;

  if CheckPermission(UserPermissions,Modulo,'CADPSRAC') or
     CheckPermission(UserPermissions,Modulo,'CADPSRRF') or
     CheckPermission(UserPermissions,Modulo,'CADPSRCT') then
    begin
      sbtnAddRestricao.Enabled := True;
      lkcbMotivoRestricao.Enabled := True;
      mkedtDataInicio.Enabled := True;
      mkedtDataFim.Enabled := True;
    end
  else
    begin
      sbtnAddRestricao.Enabled := False;
      lkcbMotivoRestricao.Enabled := False;
      mkedtDataFim.Enabled := False;
      mkedtDataInicio.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADPSRED') then
    begin
      sbtnEditarRestricao.Enabled := True;
    end
  else
    begin
      sbtnEditarRestricao.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADPSREN') then
    begin
      sbtnEncerrarRestricao.Enabled := True;
    end
  else
    begin
      sbtnEncerrarRestricao.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADPSREX') then
    begin
      sbtnExcluirRestricao.Enabled := True;
    end
  else
    begin
      sbtnExcluirRestricao.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADPSRAC') then
    begin
      ckbxRestAcessoEmpresa.Enabled := True;
    end
  else
    begin
      ckbxRestAcessoEmpresa.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADPSRRF') then
    begin
      ckbxRestAcessoRefeitorio.Enabled := True;
    end
  else
    begin
      ckbxRestAcessoRefeitorio.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADPSRCT') then
    begin
      ckbxRestContratacao.Enabled := True;
    end
  else
    begin
      ckbxRestContratacao.Enabled := False;
    end;
end;

procedure TfrmRestricaoAcesso.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_L) then
    sbtnPesquisar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;


end;

procedure TfrmRestricaoAcesso.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TfrmRestricaoAcesso.edtPesquisarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: integer;
  Found: Boolean;
begin
  if Key = VK_RETURN then
    begin
      i := 0;
      repeat
        Found := Pos(LowerCase(edtPesquisar.Text), LowerCase(lstvwPessoas.Items[i].Caption)) >= 1;
        if not Found then inc(i);
      until Found or (i > lstvwPessoas.Items.Count - 1);
      if Found then
        begin
          lstvwPessoas.Items[i].Selected := True;
          lstvwPessoas.SetFocus;
          lstvwPessoas.Selected.MakeVisible(True);
        end
      else
        begin
          i := 0;
          repeat
            Found := Pos(LowerCase(edtPesquisar.Text), LowerCase(lstvwPessoas.Items[i].SubItems.Text)) >= 1;
            if not Found then inc(i);
          until Found or (i > lstvwPessoas.Items.Count - 1);
          if Found then
            begin
              lstvwPessoas.Items[i].Selected := True;
              lstvwPessoas.SetFocus;
              lstvwPessoas.Selected.MakeVisible(True);
            end
          else
            lstvwPessoas.ItemIndex := -1;
        end;
    end;

  if Key = VK_ESCAPE then
    sbtnPesquisar.Click;
end;

procedure TfrmRestricaoAcesso.btnSalvarClick(Sender: TObject);
begin

end;

procedure TfrmRestricaoAcesso.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Editado then
    begin
      case Application.MessageBox(PChar('Deseja salvar as alterações?'), 'Confirmação',  MB_ICONQUESTION + MB_YESNOCANCEL) of
        MRYES:
          begin
            btnSalvar.Click;
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

procedure TfrmRestricaoAcesso.FormShow(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,Modulo,'CADPSRES') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      //Self.Enabled := False;
      Self.Close;
    end;


  sbtnAtualizar.Click;
  Editado := False;
  Acao := EmptyStr;
  FormEditRestAberto := False;
  gpbxRestPessoa.Height := 20;
  FormHistRestAberto := False;
  gpbxHistorico.Height := 20;
  pnlComandosRestPessoa.Visible := False;
  gpbxRestPessoa.Enabled := False;
  //ResetarControles;
  //DesabilitaEdicaoVinculo;
end;

procedure TfrmRestricaoAcesso.gpbxHistoricoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Y < 0 then
    begin
      if not FormHistRestAberto then
        begin
          gpbxRestPessoa.Height := gpbxRestPessoa.Height+100;
          gpbxHistorico.Height := 120;
          gpbxHistorico.Caption := '▲ Histórico';
          FormHistRestAberto := True;
        end
      else
        begin
          gpbxRestPessoa.Height := gpbxRestPessoa.Height-100;
          gpbxHistorico.Height := 20;
          gpbxHistorico.Caption := '▼ Histórico';
          FormHistRestAberto := False;
        end;
    end;
end;

procedure TfrmRestricaoAcesso.gpbxRestPessoaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin

end;

procedure TfrmRestricaoAcesso.gpbxRestPessoaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Y < 0 then
    begin
      if not FormEditRestAberto then
        begin
          if FormHistRestAberto then
            gpbxRestPessoa.Height := 436
          else
            gpbxRestPessoa.Height := 336;
          gpbxRestPessoa.Caption := '▲ Restrições pessoa';
          pnlComandosRestPessoa.Visible := True;
          FormEditRestAberto := True;
        end
      else
        begin
          gpbxRestPessoa.Height := 20;
          gpbxRestPessoa.Caption := '▼ Restrições pessoa';
          pnlComandosRestPessoa.Visible := False;
          dbgHistoricoRestPessoa.Visible:=False;
          FormEditRestAberto := False;
        end;
    end;
end;

procedure TfrmRestricaoAcesso.lkcbMotivoRestricaoDropDown(Sender: TObject);
begin
  SQLQuery(sqlqMotivosRestricao,['SELECT *'
                                ,'FROM p_motivos_restricao M'
                                ,'ORDER BY M.motivo']);
  lkcbMotivoRestricao.ListField := 'motivo';
  lkcbMotivoRestricao.KeyField := 'id_motivo';
  lkcbMotivoRestricao.Refresh;
end;

procedure TfrmRestricaoAcesso.lstvwPessoasCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  corPadrao: TColor;
begin
  corPadrao := lstvwPessoas.Canvas.Brush.Color;
  try
  {if not Item.SubItems[2].IsEmpty then
    if not Item.SubItems[3].IsEmpty then
      lstvwPessoas.Canvas.Brush.Color := RGBToColor(255,215,0)
    else
      lstvwPessoas.Canvas.Brush.Color := RGBToColor(255,69,0)
  else
    lstvwPessoas.Canvas.Brush.Color := corPadrao; }
  except on E:Exception do
    begin
      if E.ClassName = 'EStringListError' then
        Exit;
    end;
  end;
end;

procedure TfrmRestricaoAcesso.lstvwPessoasCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  corPadrao: TColor;
begin
  try
  {
  corPadrao := lstvwPessoas.Canvas.Brush.Color;

  if not Item.SubItems[2].IsEmpty then
    if not Item.SubItems[3].IsEmpty then
      lstvwPessoas.Canvas.Brush.Color := RGBToColor(255,215,0)
    else
      lstvwPessoas.Canvas.Brush.Color := RGBToColor(255,69,0)
  else
    lstvwPessoas.Canvas.Brush.Color := corPadrao;}
  except on E:Exception do
    begin
      if E.ClassName = 'EStringListError' then
        Exit;
    end;
  end;
end;

procedure TfrmRestricaoAcesso.lstvwPessoasInsert(Sender: TObject;
  Item: TListItem);
begin
  if lstvwPessoas.Column[0].Width+lstvwPessoas.Column[1].Width < lstvwPessoas.Width-4 then
    begin
      lstvwPessoas.Column[0].AutoSize := False;
      lstvwPessoas.Column[0].Width := Round(lstvwPessoas.Width)-4;
    end
  else
    lstvwPessoas.Column[0].AutoSize := True;

  {if lstvwPessoas.Column[0].Width+lstvwPessoas.Column[1].Width < lstvwPessoas.Width-4 then
    begin
      lstvwPessoas.Column[1].AutoSize := False;
      lstvwPessoas.Column[1].Width := Round(lstvwPessoas.Width*0.2)-2;
    end
  else
    lstvwPessoas.Column[1].AutoSize := True;}
end;

procedure TfrmRestricaoAcesso.lstvwPessoasResize(Sender: TObject);
begin
  {if lstvwPessoas.Column[0].Width+lstvwPessoas.Column[1].Width < lstvwPessoas.Width-4 then
    begin
      lstvwPessoas.Column[0].AutoSize := False;
      lstvwPessoas.Column[0].Width := Round(lstvwPessoas.Width*0.8)-2;
    end
  else
    lstvwPessoas.Column[0].AutoSize := True;

  if lstvwPessoas.Column[0].Width+lstvwPessoas.Column[1].Width < lstvwPessoas.Width-4 then
    begin
      lstvwPessoas.Column[1].AutoSize := False;
      lstvwPessoas.Column[1].Width := Round(lstvwPessoas.Width*0.2)-2;
    end
  else
    lstvwPessoas.Column[1].AutoSize := True;}
end;

procedure TfrmRestricaoAcesso.lstvwPessoasSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  ID_Pessoa := lstvwPessoas.Items.Item[Item.Index].SubItems[1];

  sqlqPessoasRestricao.First;
  while not sqlqPessoasRestricao.EOF do
    begin
      if sqlqPessoasRestricao.FieldByName('ID').Text = ID_Pessoa then
        begin
          dbgPessoasRestricao.SelectedIndex := sqlqPessoasRestricao.RecNo;
          Exit;
        end
      else
        sqlqPessoasRestricao.Next;
    end;
end;

procedure TfrmRestricaoAcesso.pnlAddRemoveResize(Sender: TObject);
begin
  pnlBtnsAddRemove.Top := Round(pnlAddRemove.Height/2)-Round(pnlBtnsAddRemove.Height/2)-Round(pnlEsqTitulo.Height/2);
end;

procedure TfrmRestricaoAcesso.sbtnAddRestricaoClick(Sender: TObject);
begin
  if ID_Pessoa <> EmptyStr then
    begin
      gpbxRestPessoa.Enabled := True;
    end;
end;

procedure TfrmRestricaoAcesso.sbtnAtualizarClick(Sender: TObject);
var
  item: TListItem;
begin
  try
    SQLQuery(sqlqPessoas,['SELECT P.id_pessoa ID_PESSOA, P.nome NOME, P.cpf CPF, R.dt_inicio DT_INICIO, R.dt_fim DT_FIM'
                         ,'FROM p_pessoas P'
                         ,'LEFT JOIN p_restricoes R'
                               ,'ON R.id_pessoa = P.id_pessoa'
                         ,'WHERE P.excluido = false'
                         ,'ORDER BY P.nome']);

    SQLQuery(sqlqPessoasRestricao,['SELECT P.id_pessoa ID, P.nome NOME, P.CPF, M.motivo, R.dt_inicio, R.dt_fim, R.rest_dependencias, R.rest_restaurante, R.rest_contratacao'
                                  ,'FROM p_restricoes R'
                                  ,'INNER JOIN p_pessoas P'
                                       ,'ON P.id_pessoa = R.id_pessoa'
                                  ,'LEFT JOIN p_restricao_pessoa X'
                                       ,'ON X.id_restricao = R.id_restricao'
                                  ,'LEFT JOIN p_motivos_restricao M'
                                       ,'ON M.id_motivo = X.id_motivo'
                                  ,'WHERE P.excluido = false'
                                  ,'ORDER BY R.dt_inicio, R.dt_fim, P.nome']);

    ID_Pessoa := EmptyStr;
    lstvwPessoas.Clear;

    sqlqPessoas.First;
    while not sqlqPessoas.EOF do
      begin
        item := lstvwPessoas.Items.Add;
        item.Caption := sqlqPessoas.FieldByName('nome').Text;
        item.SubItems.Add(sqlqPessoas.FieldByName('cpf').Text);
        item.SubItems.Add(sqlqPessoas.FieldByName('id_pessoa').Text);
        item.SubItems.Add(sqlqPessoas.FieldByName('dt_inicio').Text);
        item.SubItems.Add(sqlqPessoas.FieldByName('dt_fim').Text);
        {if ((sqlqPessoas.FieldByName('dt_inicio').Text <> EmptyStr)
           or not (sqlqPessoas.FieldByName('dt_inicio').IsNull))then
          item.Checked:=True;}
        sqlqPessoas.Next;
      end;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmRestricaoAcesso.sbtnEditarRestricaoClick(Sender: TObject);
begin
  if ID_Pessoa <> EmptyStr then
    begin
      gpbxRestPessoa.Enabled := True;
    end
  else
    Exit;

  if CheckPermission(UserPermissions,Modulo,'CADPSRAC') or
     CheckPermission(UserPermissions,Modulo,'CADPSRRF') or
     CheckPermission(UserPermissions,Modulo,'CADPSRCT') then
    begin
      lkcbMotivoRestricao.Enabled := True;
      mkedtDataInicio.Enabled := True;
      mkedtDataFim.Enabled := True;
    end
  else
    begin
      lkcbMotivoRestricao.Enabled := False;
      mkedtDataFim.Enabled := False;
      mkedtDataInicio.Enabled := False;
    end;
end;

procedure TfrmRestricaoAcesso.sbtnPesquisarClick(Sender: TObject);
begin
  if edtPesquisar.Visible = True then
    begin
      edtPesquisar.Clear;
      edtPesquisar.Visible := False;
      lstvwPessoas.ItemIndex := -1;
    end
  else
    begin
      edtPesquisar.Visible := True;
      edtPesquisar.SetFocus;
    end;
end;

end.

