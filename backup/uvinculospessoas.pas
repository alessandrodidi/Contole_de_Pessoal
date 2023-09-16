unit UVinculosPessoas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, MaskEdit, Buttons, DBGrids, ComCtrls, LCLType, BGRAColorTheme;

type

  { TfrmVinculos }

  TfrmVinculos = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    cbbxTipoVinculo: TComboBox;
    ckbxStatus: TCheckBox;
    dsVinculos: TDataSource;
    dbgHistorico: TDBGrid;
    edtNomeCracha: TEdit;
    edtCodCentroCusto: TEdit;
    edtFuncao: TEdit;
    edtCodFuncao: TEdit;
    edtSetor: TEdit;
    edtCodSetor: TEdit;
    edtEmpresa: TEdit;
    edtCodEmpresa: TEdit;
    edtCracha: TEdit;
    edtPessoaNome: TEdit;
    edtPessoa_ID: TEdit;
    edtCentroCusto: TEdit;
    gpbxPessoa: TGroupBox;
    gpbxVinculo: TGroupBox;
    gpbxHistorico: TGroupBox;
    lblNomeCracha: TLabel;
    lblAnotacoes: TLabel;
    lblCodEmpresa: TLabel;
    Label10: TLabel;
    lblCodCentroCusto: TLabel;
    lblEmpresa: TLabel;
    lblCracha: TLabel;
    lblCodSetor: TLabel;
    lblSetor: TLabel;
    lblCodFuncao: TLabel;
    lblFuncao: TLabel;
    lblDataInicio: TLabel;
    lblDataFim: TLabel;
    lblCentroCusto: TLabel;
    lblTipoVinculo: TLabel;
    lblPessoaCPF: TLabel;
    lblPessoaNome: TLabel;
    lblPessoa_ID: TLabel;
    medtDataInicio: TMaskEdit;
    medtDataFim: TMaskEdit;
    medtPessoaCPF: TMaskEdit;
    mmAnotacoes: TMemo;
    pnlComandosVinculo: TPanel;
    pnlComandos: TPanel;
    sbtnAtualizar: TSpeedButton;
    sbtnAddVinculo: TSpeedButton;
    sbtnEditarVinculo: TSpeedButton;
    sbtnExcluirVinculo: TSpeedButton;
    sbtnLocalizarPessoa: TSpeedButton;
    sbtnEncerrarVinculo: TSpeedButton;
    sbtnLocalizarCentroCusto: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnLocalizarEmpresa: TSpeedButton;
    sbtnLocalizarSetor: TSpeedButton;
    sbtnLocalizarFuncao: TSpeedButton;
    sbtnTrocarPessoa: TSpeedButton;
    sqlqConsPessoa: TSQLQuery;
    sqlqConsultasVerificacoes: TSQLQuery;
    sqlqParametros: TSQLQuery;
    sqlqVinculosOperacoes: TSQLQuery;
    sqlqVinculos: TSQLQuery;
    procedure cbbxTipoVinculoChange(Sender: TObject);
    procedure ckbxStatusChange(Sender: TObject);
    procedure dbgHistoricoDblClick(Sender: TObject);
    procedure dbgHistoricoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgHistoricoSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure dbgHistoricoTitleClick(Column: TColumn);
    procedure edtCodCentroCustoKeyPress(Sender: TObject; var Key: char);
    procedure edtCodEmpresaKeyPress(Sender: TObject; var Key: char);
    procedure edtCodFuncaoKeyPress(Sender: TObject; var Key: char);
    procedure edtCodSetorKeyPress(Sender: TObject; var Key: char);
    procedure edtCrachaKeyPress(Sender: TObject; var Key: char);
    procedure edtNomeCrachaKeyPress(Sender: TObject; var Key: char);
    procedure edtPessoa_IDKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gpbxVinculoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure medtDataFimExit(Sender: TObject);
    procedure medtDataFimKeyPress(Sender: TObject; var Key: char);
    procedure medtDataInicioExit(Sender: TObject);
    procedure medtDataInicioKeyPress(Sender: TObject; var Key: char);
    procedure mmAnotacoesKeyPress(Sender: TObject; var Key: char);
    procedure sbtnAddVinculoClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure CarregarPessoa(ID: String);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnEditarVinculoClick(Sender: TObject);
    procedure sbtnEncerrarVinculoClick(Sender: TObject);
    procedure sbtnExcluirVinculoClick(Sender: TObject);
    procedure sbtnLocalizarCentroCustoClick(Sender: TObject);
    procedure sbtnLocalizarEmpresaClick(Sender: TObject);
    procedure sbtnLocalizarFuncaoClick(Sender: TObject);
    procedure sbtnLocalizarPessoaClick(Sender: TObject);
    procedure sbtnLocalizarSetorClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure ResetarControles;
    procedure DesabilitaEdicaoVinculo;
    procedure HabilitaEdicaoVinculo;
    procedure sbtnTrocarPessoaClick(Sender: TObject);
    procedure SelVinculo;
    procedure SelDtInicio;
    procedure SelEmpresa;
    procedure SelSetor;
    procedure SelFuncao;
    procedure SelCentroCusto;
    function VerificaLancamentos(SQL: TSQLQuery; ID_Cracha: String): Boolean;
  private
    Acao, txtTVinc, ID_Cracha, formOrigem, Cod_Empresa, Cod_Setor, Cod_Funcao,
    Cod_Centro_Custo, Dt_Inicio: String;
    ReutCodCrachaFunc, ReutCodCrachaTerc, ReutCodCrachaVis, Editado, FormEditVincAberto: Boolean;
    const
      Modulo: String = 'CADASTROS';
  public
    var
      formPai, ID_Pessoa: String;
  end;

var
  frmVinculos: TfrmVinculos;

implementation

uses
  UGFunc, UConexao, UDBO, UCadPessoas, UPesquisar;

{$R *.lfm}

{ TfrmVinculos }

procedure TfrmVinculos.FormCreate(Sender: TObject);
begin
  Editado := False;

  if CheckPermission(UserPermissions,Modulo,'CADFUADD') or
     CheckPermission(UserPermissions,Modulo,'CADTCADD') or
     CheckPermission(UserPermissions,Modulo,'CADVSADD') then
    begin
      sbtnAddVinculo.Enabled := True;
    end
  else
    begin
      sbtnAddVinculo.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADFUEDT') or
     CheckPermission(UserPermissions,Modulo,'CADTCEDT') or
     CheckPermission(UserPermissions,Modulo,'CADVSEDT') then
    begin
      sbtnEditarVinculo.Enabled := True;
    end
  else
    begin
      sbtnEditarVinculo.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADFUDEL') or
     CheckPermission(UserPermissions,Modulo,'CADTCDEL') or
     CheckPermission(UserPermissions,Modulo,'CADVSDEL') then
    begin
      sbtnExcluirVinculo.Enabled := True;
    end
  else
    begin
      sbtnExcluirVinculo.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADFUSTS') or
     CheckPermission(UserPermissions,Modulo,'CADTCSTS') or
     CheckPermission(UserPermissions,Modulo,'CADVSSTS') then
    begin
      sbtnEncerrarVinculo.Enabled := True;
      ckbxStatus.Enabled := True;
    end
  else
    begin
      sbtnEncerrarVinculo.Enabled := False;
      ckbxStatus.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADFUADD') or
     CheckPermission(UserPermissions,Modulo,'CADFUEDT') then
    begin
      cbbxTipoVinculo.Items.Add('Funcionário');
    end;

  if CheckPermission(UserPermissions,Modulo,'CADTCADD') or
     CheckPermission(UserPermissions,Modulo,'CADTCEDT') then
    begin
      cbbxTipoVinculo.Items.Add('Terceiro');
    end;

  if CheckPermission(UserPermissions,Modulo,'CADVSCAD') or
     CheckPermission(UserPermissions,Modulo,'CADTCEDT')then
    begin
      cbbxTipoVinculo.Items.Add('Visitante');
    end;

  if CheckPermission(UserPermissions,Modulo,'CADFUADD') or
     CheckPermission(UserPermissions,Modulo,'CADFUEDT') or
     CheckPermission(UserPermissions,Modulo,'CADTCADD') or
     CheckPermission(UserPermissions,Modulo,'CADTCEDT') or
     CheckPermission(UserPermissions,Modulo,'CADVSCAD') or
     CheckPermission(UserPermissions,Modulo,'CADTCEDT')then
    begin
      gpbxVinculo.Enabled := True;
    end
  else
    begin
      gpbxVinculo.Enabled := False;
    end;
end;

procedure TfrmVinculos.edtPessoa_IDKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    begin
      if edtPessoa_ID.Text = EmptyStr then
        begin
          //Application.MessageBox(PChar('Informe o código'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
          //Abort;
          sbtnLocalizarPessoa.Click;
          Exit;
        end;
      CarregarPessoa(edtPessoa_ID.Text);
    end;
end;

procedure TfrmVinculos.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if Editado then
    begin
      case Application.MessageBox(PChar('Deseja salvar as alterações?'), 'Confirmação',  MB_ICONQUESTION + MB_YESNOCANCEL) of
        MRYES:
          begin
            sbtnSalvar.Click;
            Self.Close;
          end;
        MRNO:
          begin
            Editado := False;
            Self.Close;
          end;
        MRCANCEL:
          begin
            Abort;
          end;
      end;
    end;
end;

procedure TfrmVinculos.cbbxTipoVinculoChange(Sender: TObject);
begin
  {if Acao = 'EDITAR' then
    Editado := True; }

  SelVinculo;
end;

procedure TfrmVinculos.SelVinculo;
begin
  lblCracha.Visible := True;
  edtCracha.Visible := True;
  lblNomeCracha.Visible := True;
  edtNomeCracha.Visible := True;
  lblCodEmpresa.Visible := True;
  edtCodEmpresa.Visible := True;
  lblEmpresa.Visible := True;
  edtEmpresa.Visible := True;
  sbtnLocalizarEmpresa.Visible := True;
  lblDataInicio.Visible := True;
  medtDataInicio.Visible := True;
  lblDataFim.Visible := True;
  medtDataFim.Visible := True;
  ckbxStatus.Visible := True;

  if cbbxTipoVinculo.Text = 'Funcionário' then
    begin
      lblCodSetor.Visible := True;
      edtCodSetor.Visible := True;
      lblSetor.Visible := True;
      edtSetor.Visible := True;
      sbtnLocalizarSetor.Visible := True;
      lblCodFuncao.Visible := True;
      edtCodFuncao.Visible := True;
      lblFuncao.Visible := True;
      edtFuncao.Visible := True;
      sbtnLocalizarFuncao.Visible := True;
      lblCodCentroCusto.Visible := True;
      edtCodCentroCusto.Visible := True;
      lblCentroCusto.Visible := True;
      edtCentroCusto.Visible := True;
      sbtnLocalizarCentroCusto.Visible := True;
      lblAnotacoes.Visible := False;
      mmAnotacoes.Visible := False;
      gpbxVinculo.Height := 200;
      if CheckPermission(UserPermissions,Modulo,'CADFUSTS') then
        begin
          ckbxStatus.Enabled := True;
        end
      else
        begin
          ckbxStatus.Enabled := False;
        end;
    end;

  if cbbxTipoVinculo.Text = 'Terceiro' then
    begin
      lblCodSetor.Visible := True;
      edtCodSetor.Visible := True;
      lblSetor.Visible := True;
      edtSetor.Visible := True;
      sbtnLocalizarSetor.Visible := True;
      lblCodFuncao.Visible := True;
      edtCodFuncao.Visible := True;
      lblFuncao.Visible := True;
      edtFuncao.Visible := True;
      sbtnLocalizarFuncao.Visible := True;
      lblCodCentroCusto.Visible := False;
      edtCodCentroCusto.Visible := False;
      lblCentroCusto.Visible := False;
      edtCentroCusto.Visible := False;
      sbtnLocalizarCentroCusto.Visible := False;
      lblAnotacoes.Top := 147;
      lblAnotacoes.Visible := True;
      mmAnotacoes.Visible := True;
      mmAnotacoes.Top := 168;
      gpbxVinculo.Height := 287;
      if CheckPermission(UserPermissions,Modulo,'CADTCSTS') then
        begin
          ckbxStatus.Enabled := True;
        end
      else
        begin
          ckbxStatus.Enabled := False;
        end;
    end;

  if cbbxTipoVinculo.Text = 'Visitante' then
    begin
      lblCodSetor.Visible := True;
      edtCodSetor.Visible := True;
      lblSetor.Visible := True;
      edtSetor.Visible := True;
      sbtnLocalizarSetor.Visible := False;
      lblCodFuncao.Visible := False;
      edtCodFuncao.Visible := False;
      lblFuncao.Visible := False;
      edtFuncao.Visible := False;
      sbtnLocalizarFuncao.Visible := False;
      lblCodCentroCusto.Visible := False;
      edtCodCentroCusto.Visible := False;
      lblCentroCusto.Visible := False;
      edtCentroCusto.Visible := False;
      sbtnLocalizarCentroCusto.Visible := False;
      lblAnotacoes.Visible := True;
      lblAnotacoes.Top := 100;
      mmAnotacoes.Visible := True;
      mmAnotacoes.Top := 117;
      gpbxVinculo.Height := 240;
      if CheckPermission(UserPermissions,Modulo,'CADVSSTS') then
        begin
          ckbxStatus.Enabled := True;
        end
      else
        begin
          ckbxStatus.Enabled := False;
        end;
    end;
end;

procedure TfrmVinculos.ckbxStatusChange(Sender: TObject);
begin
  Editado := True;
end;

procedure TfrmVinculos.dbgHistoricoDblClick(Sender: TObject);
begin
  sbtnEditarVinculo.Click;
end;

procedure TfrmVinculos.dbgHistoricoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    sbtnExcluirVinculo.Click;
end;

procedure TfrmVinculos.dbgHistoricoSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  {if sqlqVinculos.FieldByName('cod_vinculo').AsString = 'F' then
    begin
      if CheckPermission(UserPermissions,Modulo,'CADFUEDT') then
        begin
          sbtnEditarVinculo.Enabled := True;
        end
      else
        begin
          sbtnEditarVinculo.Enabled := False;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADFUDEL') then
        begin
          sbtnExcluirVinculo.Enabled := True;
        end
      else
        begin
          sbtnExcluirVinculo.Enabled := False;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADFUSTS') then
        begin
          sbtnEncerrarVinculo.Enabled := True;
          ckbxStatus.Enabled := True;
        end
      else
        begin
          sbtnEncerrarVinculo.Enabled := False;
          ckbxStatus.Enabled := False;
        end;
    end;

  if sqlqVinculos.FieldByName('cod_vinculo').AsString = 'T' then
    begin
      if CheckPermission(UserPermissions,Modulo,'CADTCEDT') then
        begin
          sbtnEditarVinculo.Enabled := True;
        end
      else
        begin
          sbtnEditarVinculo.Enabled := False;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADTCDEL') then
        begin
          sbtnExcluirVinculo.Enabled := True;
        end
      else
        begin
          sbtnExcluirVinculo.Enabled := False;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADTCSTS') then
        begin
          sbtnEncerrarVinculo.Enabled := True;
          ckbxStatus.Enabled := True;
        end
      else
        begin
          sbtnEncerrarVinculo.Enabled := False;
          ckbxStatus.Enabled := False;
        end;
    end;

  if sqlqVinculos.FieldByName('cod_vinculo').AsString = 'V' then
    begin
      if CheckPermission(UserPermissions,Modulo,'CADVSEDT') then
        begin
          sbtnEditarVinculo.Enabled := True;
        end
      else
        begin
          sbtnEditarVinculo.Enabled := False;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADVSDEL') then
        begin
          sbtnExcluirVinculo.Enabled := True;
        end
      else
        begin
          sbtnExcluirVinculo.Enabled := False;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADVSSTS') then
        begin
          sbtnEncerrarVinculo.Enabled := True;
          ckbxStatus.Enabled := True;
        end
      else
        begin
          sbtnEncerrarVinculo.Enabled := False;
          ckbxStatus.Enabled := False;
        end;
    end; }
end;

procedure TfrmVinculos.dbgHistoricoTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgHistorico.Columns.Count - 1 do
    dbgHistorico.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgHistorico.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

procedure TfrmVinculos.edtCodCentroCustoKeyPress(Sender: TObject; var Key: char
  );
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;

  if (Key = #13) and (edtCodCentroCusto.Text <> EmptyStr) then
    begin
      SelCentroCusto;
    end;
end;

procedure TfrmVinculos.edtCodEmpresaKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;

  if (Key = #13) and (edtCodEmpresa.Text <> EmptyStr) then
    begin
      SelEmpresa;
    end;
end;

procedure TfrmVinculos.edtCodFuncaoKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;

  if (Key = #13) and (edtCodFuncao.Text <> EmptyStr) then
    begin
      SelFuncao;
    end;
end;

procedure TfrmVinculos.edtCodSetorKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;

  if (Key = #13) and (edtCodSetor.Text <> EmptyStr) then
    begin
      SelSetor;
    end;
end;

procedure TfrmVinculos.edtCrachaKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;
end;

procedure TfrmVinculos.edtNomeCrachaKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46]) then
    Editado := True;
end;

procedure TfrmVinculos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnSalvar.Click;
end;

procedure TfrmVinculos.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    begin
      if Screen.ActiveControl.Name <> 'edtPessoa_ID' then
        begin
          //Key := #0;
          SelectNext(ActiveControl,True,True);
          Exit;
        end;
    end;
end;

procedure TfrmVinculos.FormResize(Sender: TObject);
begin
  mmAnotacoes.Left := 8;
  mmAnotacoes.Width := gpbxVinculo.Width-20;
end;

procedure TfrmVinculos.FormShow(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,Modulo,'CADFUCAD') and
     not CheckPermission(UserPermissions,Modulo,'CADTCCAD') and
     not CheckPermission(UserPermissions,Modulo,'CADVSCAD') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  case gTipo_Vinculo of
    'F': txtTVinc := 'Funcionário';
    'T': txtTVinc := 'Terceiro';
    'V': txtTVinc := 'Visitante';
  end;

  if gID_Pessoa <> EmptyStr then
    begin
      sbtnAtualizar.Enabled := True;
      ID_Pessoa := gID_Pessoa;
      sbtnAtualizar.Click;
      edtPessoa_ID.Enabled := False;
      edtPessoaNome.Enabled := False;
      medtPessoaCPF.Enabled := False;
      CarregarPessoa(ID_Pessoa);
    end
  else
    begin
      sbtnAtualizar.Enabled := False;
      ID_Pessoa := '0';
      sbtnAtualizar.Click;
      edtPessoa_ID.Enabled := True;
      edtPessoaNome.Enabled := False;
      medtPessoaCPF.Enabled := False;
      Self.Caption := 'Vínculos  [<<Selecionar pessoa>>]';
    end;

  if formPai <> EmptyStr then
    begin
      formOrigem := formPai;
    end
  else
    begin
      formOrigem := Self.Name;
    end;

  if formOrigem = Self.Name then
    begin
      sbtnLocalizarPessoa.Enabled := True;
      sbtnTrocarPessoa.Enabled := True;
    end
  else
    begin
      sbtnLocalizarPessoa.Enabled := False;
      sbtnTrocarPessoa.Enabled := False;
    end;

  Editado := False;
  Acao := EmptyStr;
  gpbxVinculo.Height := 20;
  pnlComandosVinculo.Visible := False;
  ResetarControles;
  DesabilitaEdicaoVinculo;

  //Consulta os parametros do módulo
  SQLExec(sqlqParametros,['SELECT modulo, cod_config, param1, param2, param3, imagem, status',
                          'FROM g_parametros',
                          'WHERE modulo = '''+Modulo+'''']);

  //Parâmetro permite reutilizar códigos de crachás para funcionários
  sqlqParametros.Filter := 'cod_config = ''RECODCRAFN''';
  sqlqParametros.Filtered := True;
  ReutCodCrachaFunc := sqlqParametros.Fields[6].AsBoolean;
  sqlqParametros.Filtered := False;
  sqlqParametros.Filter := '';

  //Parâmetro permite reutilizar códigos de crachás para terceiros
  sqlqParametros.Filter := 'cod_config = ''RECODCRATC''';
  sqlqParametros.Filtered := True;
  ReutCodCrachaTerc := sqlqParametros.Fields[6].AsBoolean;
  sqlqParametros.Filtered := False;
  sqlqParametros.Filter := '';

  //Parâmetro permite reutilizar códigos de crachás para visitantes
  sqlqParametros.Filter := 'cod_config = ''RECODCRAVS''';
  sqlqParametros.Filtered := True;
  ReutCodCrachaVis := sqlqParametros.Fields[6].AsBoolean;
  sqlqParametros.Filtered := False;
  sqlqParametros.Filter := '';
end;

procedure TfrmVinculos.gpbxVinculoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Y < 0 then
    begin
      if not FormEditVincAberto then
        begin
          if cbbxTipoVinculo.Text = 'Funcionário' then
            begin
              gpbxVinculo.Height := 200;
            end
          else if cbbxTipoVinculo.Text = 'Terceiro' then
            begin
              gpbxVinculo.Height := 240;
            end
          else if cbbxTipoVinculo.Text = 'Visitante' then
            begin
              gpbxVinculo.Height := 240;
            end
          else
            begin
              gpbxVinculo.Height := 100;
            end;
          pnlComandosVinculo.Visible := True;
          FormEditVincAberto := True;
          gpbxVinculo.Caption := '▲ Vínculo';
        end
      else
        begin
          pnlComandosVinculo.Visible := False;
          gpbxVinculo.Height := 20;
          gpbxVinculo.Caption := '▼ Vínculo';
          FormEditVincAberto := False;
        end;
    end;
end;

procedure TfrmVinculos.medtDataFimExit(Sender: TObject);
begin
  if (medtDataFim.Text <> EmptyStr) and (medtDataFim.Text <> '  /  /    ') then
    begin
      try
        StrToDate(medtDataFim.Text);
      Except
        begin
          Application.MessageBox('A data final informada é inválido','Aviso', MB_ICONWARNING + MB_OK);
          medtDataFim.SetFocus;
          medtDataFim.SelectAll;
          Exit;
        end;
      end;
    end;
end;

procedure TfrmVinculos.medtDataFimKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;
end;

procedure TfrmVinculos.medtDataInicioExit(Sender: TObject);
begin
  SelDtInicio;
end;

procedure TfrmVinculos.medtDataInicioKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;
end;

procedure TfrmVinculos.mmAnotacoesKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46]) then
    Editado := True;
end;

procedure TfrmVinculos.sbtnAddVinculoClick(Sender: TObject);
begin
  if Editado = True then
    sbtnCancelar.Click;

  Acao := 'ADICIONAR';
  Clean([cbbxTipoVinculo,edtCracha,edtCodEmpresa,edtEmpresa,medtDataInicio,medtDataFim,
         edtCodFuncao,edtFuncao,edtCodSetor,edtSetor,edtCodCentroCusto,edtCentroCusto,mmAnotacoes]);
  gpbxVinculo.Height := 100;
  pnlComandosVinculo.Visible := True;
  HabilitaEdicaoVinculo;
end;

procedure TfrmVinculos.sbtnAtualizarClick(Sender: TObject);
begin
  try
    SQLQuery(sqlqVinculos,['SELECT C.id_cracha, C.cracha, C.nome_cracha, C.cod_vinculo,',
                           '(CASE C.cod_vinculo WHEN ''F'' THEN ''Funcionário'' WHEN ''T'' THEN ''Terceiro'' WHEN ''V'' THEN ''Visitante'' END) VÍNCULO,',
                           'C.cod_empresa, E.fantasia, C.cod_setor, S.setor, C.cod_centro_custo, U.centro_custo,',
                           'C.cod_funcao, F.funcao, C.dt_inicio, C.dt_fim, C.status, C.anotacoes',
                           'FROM p_cracha C',
                               'LEFT JOIN g_empresas E ON E.cod_empresa = C.cod_empresa',
                               'LEFT JOIN g_setores S ON S.cod_setor = C.cod_setor AND S.cod_empresa = C.cod_empresa',
                               'LEFT JOIN g_centros_custo U ON U.cod_centro_custo = C.cod_centro_custo AND U.cod_empresa = C.cod_empresa',
                               'LEFT JOIN p_funcoes F ON F.cod_funcao = C.cod_funcao AND F.cod_empresa = C.cod_empresa',
                           'WHERE C.id_pessoa = '+ID_Pessoa+'',
                           'ORDER BY C.dt_inicio DESC, C.dt_fim']);

    dbgHistorico.Columns[0].FieldName:='id_cracha';
    dbgHistorico.Columns[0].Width:=0;
    dbgHistorico.Columns[1].FieldName:='cracha';
    dbgHistorico.Columns[1].Title.Caption:='CRACHÁ';
    dbgHistorico.Columns[1].Width:=60;
    dbgHistorico.Columns[2].FieldName:='nome_cracha';
    dbgHistorico.Columns[2].Title.Caption:='NOME';
    dbgHistorico.Columns[2].Width:=150;
    dbgHistorico.Columns[3].FieldName:='cod_vinculo';
    dbgHistorico.Columns[3].Width:=0;
    dbgHistorico.Columns[4].FieldName:='VÍNCULO';
    dbgHistorico.Columns[4].Title.Caption:='VÍNCULO';
    dbgHistorico.Columns[4].Width:=75;
    dbgHistorico.Columns[5].FieldName:='cod_empresa';
    dbgHistorico.Columns[5].Title.Caption:='COD';
    dbgHistorico.Columns[5].Width:=0;
    dbgHistorico.Columns[6].FieldName:='fantasia';
    dbgHistorico.Columns[6].Title.Caption:='EMPRESA';
    dbgHistorico.Columns[6].Width:=170;
    dbgHistorico.Columns[7].FieldName:='cod_setor';
    dbgHistorico.Columns[7].Title.Caption:='COD';
    dbgHistorico.Columns[7].Width:=0;
    dbgHistorico.Columns[8].FieldName:='setor';
    dbgHistorico.Columns[8].Title.Caption:='SETOR';
    dbgHistorico.Columns[8].Width:=150;
    dbgHistorico.Columns[9].FieldName:='cod_centro_custo';
    dbgHistorico.Columns[9].Title.Caption:='COD CCU';
    dbgHistorico.Columns[9].Width:=60;
    dbgHistorico.Columns[10].FieldName:='centro_custo';
    dbgHistorico.Columns[10].Title.Caption:='CENTRO DE CUSTO';
    dbgHistorico.Columns[10].Width:=200;
    dbgHistorico.Columns[11].FieldName:='cod_funcao';
    dbgHistorico.Columns[11].Title.Caption:='COD';
    dbgHistorico.Columns[11].Width:=0;
    dbgHistorico.Columns[12].FieldName:='funcao';
    dbgHistorico.Columns[12].Title.Caption:='FUNÇÃO';
    dbgHistorico.Columns[12].Width:=200;
    dbgHistorico.Columns[13].FieldName:='dt_inicio';
    dbgHistorico.Columns[13].Title.Caption:='DT INÍCIO';
    dbgHistorico.Columns[13].Width:=70;
    dbgHistorico.Columns[14].FieldName:='dt_fim';
    dbgHistorico.Columns[14].Title.Caption:='DT FIM';
    dbgHistorico.Columns[14].Width:=70;
    dbgHistorico.Columns[15].FieldName:='status';
    dbgHistorico.Columns[15].Title.Caption:='ATIVO';
    dbgHistorico.Columns[15].Width:=40;
    dbgHistorico.Columns[16].FieldName:='anotacoes';
    dbgHistorico.Columns[16].Title.Caption:='ANOTAÇÕES';
    dbgHistorico.Columns[16].Width:=350;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar carregar dados de vínculos'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.CarregarPessoa(ID: String);
begin
  try
  SQLQuery(sqlqConsPessoa,['SELECT id_pessoa, nome, cpf',
                           'FROM p_pessoas',
                           'WHERE excluido = false',
                                 'AND id_pessoa = '+ID]);

  if sqlqConsPessoa.RecordCount > 0 then
    begin
      ID_Pessoa := sqlqConsPessoa.Fields.Fields[0].AsString;
      edtPessoa_ID.Text := sqlqConsPessoa.Fields.Fields[0].AsString;
      edtPessoa_ID.Enabled := False;
      edtPessoaNome.Text := sqlqConsPessoa.Fields.Fields[1].AsString;
      medtPessoaCPF.Text := sqlqConsPessoa.Fields.Fields[2].AsString;
      sbtnAtualizar.Enabled := True;
      Self.Caption := 'Vínculos  ['+sqlqConsPessoa.Fields.Fields[1].AsString+']';
      sbtnAtualizar.Click;
    end
  else
    begin
      Application.MessageBox(PChar('Código de pessoa '''+ID+''' não localizado'+#13+'Verifique se o código informado está correto'), '', MB_ICONEXCLAMATION + MB_OK);
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

procedure TfrmVinculos.sbtnCancelarClick(Sender: TObject);
begin
  if Editado then
    begin
      if Application.MessageBox(Pchar('Cancelar a edição?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          if formOrigem = Self.Name then
            begin
              Acao := EmptyStr;
              Editado := False;
              sbtnAtualizar.Click;
              ResetarControles;
              Clean([cbbxTipoVinculo,edtCracha,edtCodEmpresa,edtEmpresa,medtDataInicio,medtDataFim,
                     edtCodFuncao,edtFuncao,edtCodSetor,edtSetor,edtCodCentroCusto,edtCentroCusto,mmAnotacoes]);
              DesabilitaEdicaoVinculo;
              pnlComandosVinculo.Visible := False;
              gpbxVinculo.Height := 20;
              FormEditVincAberto := False;
            end
          else
            begin
              Self.Close;
            end;
        end
      else
        Abort;
    end
  else
    begin
      Acao := EmptyStr;
      Editado := False;
      sbtnAtualizar.Click;
      ResetarControles;
      Clean([cbbxTipoVinculo,edtCracha,edtCodEmpresa,edtEmpresa,medtDataInicio,medtDataFim,
             edtCodFuncao,edtFuncao,edtCodSetor,edtSetor,edtCodCentroCusto,edtCentroCusto,mmAnotacoes]);
      DesabilitaEdicaoVinculo;
      pnlComandosVinculo.Visible := False;
      gpbxVinculo.Height := 20;
      FormEditVincAberto := False;
    end;
      {BtnClicado := Application.MessageBox(PChar('Deseja sair do cadastro?'),'Confirmação', MB_ICONQUESTION + MB_YESNOCANCEL);
      if BtnClicado = MRYES then
        Self.Close
      else if BtnClicado = MRNO then
        begin
          Acao := EmptyStr;
          Editado := False;
          //edtPessoa_ID.Enabled := True;
          //ID_Pessoa := '0';
          sbtnAtualizar.Click;
          //sbtnAtualizar.Enabled := False;
          //Self.Caption := 'Vínculos  [<<Selecionar pessoa>>]';
          //CleanForm(Self);
          ResetarControles;
          DesabilitaEdicaoVinculo;
          pnlComandosVinculo.Visible := False;
          gpbxVinculo.Height := 20;
          FormEditVincAberto := False;
        end
      else
        Abort;
    end;}
end;

procedure TfrmVinculos.sbtnEditarVinculoClick(Sender: TObject);
var
  Tipo_Vinculo: String;
begin
  try
    if Editado then
      sbtnCancelar.Click;

    if sqlqVinculos.FieldByName('id_cracha').Text = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione o histórico que deseja editar'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'F' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADFUEDT') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para editar cadastros de funcionários'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'T' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADTCEDT') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para editar cadastros de terceiros'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'V' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADVSEDT') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para editar cadastros de visitantes'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    if sqlqVinculos.FieldByName('status').AsBoolean = False then
      begin
        Application.MessageBox(PChar('O histórico selecionado já foi encerrado e não pode ser alterado'+#13+
                                     'Caso necessário abra um novo histórico para registrar o vínculo desejado'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    Acao := 'EDITAR';
    gpbxVinculo.Height := 100;
    pnlComandosVinculo.Visible := True;
    HabilitaEdicaoVinculo;

    //Carrega os dados nos campos
    case sqlqVinculos.FieldByName('cod_vinculo').Text of
        'F': Tipo_Vinculo := 'Funcionário';
        'T': Tipo_Vinculo := 'Terceiro';
        'V': Tipo_Vinculo := 'Visitante';
      end;

    ID_Cracha := sqlqVinculos.Fields.FieldByName('id_cracha').AsString;

    cbbxTipoVinculo.ItemIndex :=  cbbxTipoVinculo.Items.IndexOf(Tipo_Vinculo);
    SelVinculo;

    if sqlqVinculos.Fields.FieldByName('dt_inicio').AsString <> EmptyStr then
      begin
        medtDataInicio.Text := sqlqVinculos.Fields.FieldByName('dt_inicio').AsString;
        //medtDataInicio.SetFocus;
      end
    else
      medtDataInicio.Text := EmptyStr;

    if sqlqVinculos.Fields.FieldByName('dt_fim').AsString <> EmptyStr then
      begin
        medtDataFim.Text := sqlqVinculos.Fields.FieldByName('dt_fim').AsString;
        //medtDataFim.SetFocus;
      end
    else
      medtDataFim.Text := EmptyStr;

    edtCracha.Text := sqlqVinculos.Fields.FieldByName('cracha').AsString;
    edtNomeCracha.Text := sqlqVinculos.Fields.FieldByName('nome_cracha').AsString;

    if sqlqVinculos.Fields.FieldByName('cod_empresa').AsInteger > 0 then
      begin
        edtCodEmpresa.Text := sqlqVinculos.Fields.FieldByName('cod_empresa').AsString;
        if edtCodEmpresa.Text <> EmptyStr then SelEmpresa;
        edtCodEmpresa.SetFocus;
      end
    else
      edtCodEmpresa.Text := EmptyStr;

    if sqlqVinculos.Fields.FieldByName('cod_setor').AsInteger > 0 then
      begin
        edtCodSetor.Text := sqlqVinculos.Fields.FieldByName('cod_setor').AsString;
        if edtCodSetor.Text <> EmptyStr then SelSetor;
        edtCodSetor.SetFocus;
      end
    else
      edtCodSetor.Text := EmptyStr;

    if sqlqVinculos.Fields.FieldByName('cod_funcao').AsInteger > 0 then
      begin
        edtCodFuncao.Text := sqlqVinculos.Fields.FieldByName('cod_funcao').AsString;
        if edtCodFuncao.Text <> EmptyStr then SelFuncao;
        edtCodFuncao.SetFocus;
      end
    else
      edtCodFuncao.Text := EmptyStr;

    if sqlqVinculos.Fields.FieldByName('cod_centro_custo').AsInteger > 0 then
      begin
        edtCodCentroCusto.Text := sqlqVinculos.Fields.FieldByName('cod_centro_custo').AsString;
        if edtCodCentroCusto.Text <> EmptyStr then SelCentroCusto;
        edtCodCentroCusto.SetFocus;
      end
    else
      edtCodCentroCusto.Text := EmptyStr;

    ckbxStatus.Checked := sqlqVinculos.Fields.FieldByName('status').AsBoolean;

    mmAnotacoes.Text := sqlqVinculos.Fields.FieldByName('anotacoes').AsString;
    medtDataInicio.SetFocus;
    edtCracha.SetFocus;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar carregar os dados para edição'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end
    end;
  end;
end;

procedure TfrmVinculos.sbtnEncerrarVinculoClick(Sender: TObject);
var
  Tipo_Vinculo, DataFim, Cracha: String;
  ConfDataFim, R: Boolean;
begin
  try
    if Editado then
      sbtnCancelar.Click;

    if sqlqVinculos.FieldByName('id_cracha').Text = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione o vínculo a ser encerrado'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if sqlqVinculos.FieldByName('status').AsBoolean = False then
      begin
        Application.MessageBox(PChar('O vínculo selecionado já foi encerrado'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'F' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADFUSTS') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para encerrar cadastros de funcionários'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'T' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADTCSTS') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para encerrar cadastros de terceiros'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'V' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADVSSTS') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para encerrar cadastros de visitantes'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    case sqlqVinculos.FieldByName('cod_vinculo').Text of
      'F': Tipo_Vinculo := 'funcionário';
      'T': Tipo_Vinculo := 'terceiro';
      'V': Tipo_Vinculo := 'visitante';
    end;

    Cracha := sqlqVinculos.Fields.FieldByName('cracha').AsString;

    if Application.MessageBox(PChar('Aviso'+#13+'Após o encerramento não será possível utilizar este crachá para novos lançamentos'+#13#13
                                    +'Deseja proceguir e encerrar o vínculo de '''+Tipo_Vinculo+''' do crachá '''+Cracha+'''?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
      begin
        ID_Cracha := sqlqVinculos.Fields.FieldByName('id_cracha').AsString;

        if ((sqlqVinculos.FieldByName('dt_fim').Text <> EmptyStr)
           and (sqlqVinculos.FieldByName('dt_fim').AsDateTime > Now))then
          DataFim := sqlqVinculos.FieldByName('dt_fim').Text
        else
          DataFim := FormatDateTime('DD/MM/YYYY',Now);

        R := False;
        while R = False do
          begin
            ConfDataFim := InputQuery('Confirmação', 'Confirmar a data de encerramento (dd/mm/aaaa)', DataFim);
            if ConfDataFim then
              begin
                if not TryStrToDate(DataFim) then
                  begin
                    Application.MessageBox(PChar('A data de encerramento informada é inválida'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
                  end
                else if StrToDate(FormatDateTime('DD/MM/YYYY',Now-1)) >= StrToDate(FormatDateTime('DD/MM/YYYY',StrToDate(DataFim))) then
                  begin
                    Application.MessageBox(PChar('A data de encerramento não pode ser menor que a data atual'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
                  end
                else
                  R := True;
              end
                else
                  Exit;
          end;
        try
          SQLExec(sqlqVinculosOperacoes,['UPDATE p_cracha SET',
                                         'dt_fim='''+FormatDateTime('YYYY-MM-DD',StrToDate(DataFim))+'''',
                                         ',status=false',
                                         'WHERE id_cracha = '+ID_Cracha]);
          Log(LowerCase(Modulo),'pessoas','encerrar vínculo',ID_Cracha,gID_Usuario_Logado,gUsuario_Logado,'<<vínculo '+Cracha+'-'+Tipo_Vinculo+' encerrado para '+edtPessoa_ID.Text+'-'+edtPessoaNome.Text+'>>');
        finally
          begin
            ID_Cracha := EmptyStr;
            sbtnAtualizar.Click;
            Application.MessageBox(PChar('Vínculo encerrado com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
          end;
        end;
      end
    else
      begin
        ID_Cracha := EmptyStr;
        Exit;
      end;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar encerrar o vínculo'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.sbtnExcluirVinculoClick(Sender: TObject);
var
  Tipo_Vinculo, Cracha: String;
begin
  try
    if Editado then
      sbtnCancelar.Click;

    if sqlqVinculos.FieldByName('id_cracha').Text = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione o vínculo que deseja excluir'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'F' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADFUDEL') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para excluir cadastros de funcionários'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'T' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADTCDEL') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para excluir cadastros de terceiros'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    if sqlqVinculos.FieldByName('cod_vinculo').Text = 'V' then
      begin
        if not CheckPermission(UserPermissions,Modulo,'CADVSDEL') then
          begin
            Application.MessageBox(PChar('Você não possui acesso para excluir cadastros de visitantes'), 'Aviso', MB_ICONEXCLAMATION);
            Exit;
          end;
      end;

    ID_Cracha := sqlqVinculos.Fields.FieldByName('id_cracha').AsString;
    Cracha := sqlqVinculos.Fields.FieldByName('cracha').AsString;

    case sqlqVinculos.FieldByName('cod_vinculo').Text of
      'F': Tipo_Vinculo := 'funcionário';
      'T': Tipo_Vinculo := 'terceiro';
      'V': Tipo_Vinculo := 'visitante';
    end;

    if not VerificaLancamentos(sqlqConsultasVerificacoes,ID_Cracha) then
      begin
        Application.MessageBox(PChar('Não é possível excluir o crachá '''+Cracha
                               +''' pois existem lançamentos vinculados a ele'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if Application.MessageBox(PChar('Deseja realmente excluir o crachá '''+Cracha
                              +'''?'),'Confirmar',MB_ICONQUESTION + MB_YESNO) = MRYES then
      begin
        SQLExec(sqlqVinculosOperacoes,['DELETE FROM p_cracha',
                                       'WHERE id_cracha='+ID_Cracha]);
        Log(LowerCase(Modulo),'pessoas','deletar vínculo',ID_Cracha,gID_Usuario_Logado,gUsuario_Logado,'<<vínculo '+Cracha+'-'+Tipo_Vinculo+' excluído para '+edtPessoa_ID.Text+'-'+edtPessoaNome.Text+'>>');
        ID_Cracha := EmptyStr;
        sbtnAtualizar.Click;
        Application.MessageBox(PChar('Vínculo excluído com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
      end
    else
      Exit;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar excluir o vínculo'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.sbtnLocalizarCentroCustoClick(Sender: TObject);
begin
  frmPesquisar := TfrmPesquisar.Create(Self);
  frmPesquisar.RefConsulta := 'Vínculos (Centro de Custo)';
  frmPesquisar.Param1 := edtCodEmpresa.Text;
  frmPesquisar.ShowModal;
end;

procedure TfrmVinculos.sbtnLocalizarEmpresaClick(Sender: TObject);
begin
  //OpenForm(TfrmPesquisar,'Modal');
  frmPesquisar := TfrmPesquisar.Create(Self);
  frmPesquisar.RefConsulta := 'Vínculos (Empresa)';
  //frmPesquisar.posX := sbtnLocalizarEmpresa.Left;
  //frmPesquisar.posY := sbtnLocalizarEmpresa.Top;
  frmPesquisar.Show;
end;

procedure TfrmVinculos.sbtnLocalizarFuncaoClick(Sender: TObject);
begin
  frmPesquisar := TfrmPesquisar.Create(Self);
  frmPesquisar.RefConsulta := 'Vínculos (Função)';
  frmPesquisar.Param1 := edtCodEmpresa.Text;
  frmPesquisar.ShowModal;
end;

procedure TfrmVinculos.sbtnLocalizarPessoaClick(Sender: TObject);
begin
  //if ((ID_Pessoa <> EmptyStr) and (ID_Pessoa <> '0')) then
    //sbtnTrocarPessoa.Click;

  frmPesquisar := TfrmPesquisar.Create(Self);
  frmPesquisar.RefConsulta := 'Vínculos (Pessoa)';
  frmPesquisar.ShowModal;
end;

procedure TfrmVinculos.sbtnLocalizarSetorClick(Sender: TObject);
begin
  frmPesquisar := TfrmPesquisar.Create(Self);
  frmPesquisar.RefConsulta := 'Vínculos (Setor)';
  frmPesquisar.Param1 := edtCodEmpresa.Text;
  frmPesquisar.ShowModal;
end;

procedure TfrmVinculos.sbtnSalvarClick(Sender: TObject);
var
  Filtro, MSG, Tipo_Vinculo, Status, Dt_Fim: String;
begin
  try
    if ((ID_Pessoa = EmptyStr) or (ID_Pessoa = '0')) then
      begin
        Application.MessageBox(PChar('Selecione a pessoa para realizar o vínculo'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtPessoa_ID.SetFocus;
        Exit;
      end;

    if not Editado then
      Exit;

    if cbbxTipoVinculo.Text = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione o tipo de vínculo da pessoa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        cbbxTipoVinculo.SetFocus;
        cbbxTipoVinculo.DroppedDown := True;
        Exit;
      end;
    if edtCracha.Text = EmptyStr then
      begin
        Application.MessageBox(PChar('Informe o código do crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtCracha.SetFocus;
        Exit;
      end;
    if edtNomeCracha.Text = EmptyStr then
      begin
        Application.MessageBox(PChar('Informe o nome para impressão no crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtNomeCracha.SetFocus;
        Exit;
      end;
    if (medtDataInicio.Text = EmptyStr) or (medtDataInicio.Text = '  /  /    ') then
      begin
        Application.MessageBox(PChar('Informe a data de início de uso do crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataInicio.SetFocus;
        Exit;
      end;
    if (cbbxTipoVinculo.Text = 'Funcionário') or (cbbxTipoVinculo.Text = 'Terceiro') then
      begin
        if edtCodEmpresa.Text = EmptyStr then
          begin
            Application.MessageBox(PChar('Informe a empresa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            edtCodEmpresa.SetFocus;
            Exit;
          end;
      end;

    if cbbxTipoVinculo.Text = 'Funcionário' then
      begin
        if edtCodSetor.Text = EmptyStr then
          begin
            Application.MessageBox(PChar('Informe o setor'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            edtCodSetor.SetFocus;
            Exit;
          end;
        if edtCodFuncao.Text = EmptyStr then
          begin
            Application.MessageBox(PChar('Informe a função'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            edtCodFuncao.SetFocus;
            Exit;
          end;
        if edtCodCentroCusto.Text = EmptyStr then
          begin
            Application.MessageBox(PChar('Informe o centro de custo'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            edtCodCentroCusto.SetFocus;
            Exit;
          end;
      end;

    if cbbxTipoVinculo.Text = 'Visitante' then
      begin
        if (medtDataFim.Text = EmptyStr) or (medtDataFim.Text = '  /  /    ') then
          begin
            Application.MessageBox(PChar('Informe a data final de uso do crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            medtDataFim.SetFocus;
            Exit;
          end;
      end;

    //Verifica se data início é maior que a data fim
    if ((medtDataInicio.Text <> EmptyStr) and (medtDataInicio.Text <> '  /  /    ')) and
       ((medtDataFim.Text <> EmptyStr) and (medtDataFim.Text <> '  /  /    ')) then
      begin
        if (StrToDate(medtDataInicio.Text) > StrToDate(medtDataFim.Text)) then
          begin
            Application.MessageBox(PChar('A data inicial não pode ser maior que a data final'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            medtDataFim.SetFocus;
            medtDataFim.SelectAll;
            Exit;
          end;
      end;

    //Verifica se a pessoa possui históricos em aberto
    SQLQuery(sqlqConsultasVerificacoes,['SELECT count(id_cracha) reg, cracha, id_pessoa, cod_vinculo, dt_fim, status',
                                        'FROM p_cracha',
                                        'WHERE id_pessoa = '''+ID_Pessoa+'''',
                                               'AND id_cracha <> '''+ID_Cracha+'''',
                                               'AND status = true',
                                               'AND (dt_fim IS NULL or dt_fim = '''')',
                                        'ORDER BY dt_inicio DESC']);

    case sqlqConsultasVerificacoes.FieldByName('cod_vinculo').Text of
      'F': Tipo_Vinculo := 'funcionário';
      'T': Tipo_Vinculo := 'terceiro';
      'V': Tipo_Vinculo := 'visitante';
    end;

    if (sqlqConsultasVerificacoes.FieldByName('reg').AsInteger > 0)
       and (Acao = 'ADICIONAR') then
      begin
        if Application.MessageBox(PChar(''''+edtPessoaNome.Text+''' já possui vínculo ativo como '''+Tipo_Vinculo+''' no crachá '''+sqlqConsultasVerificacoes.FieldByName('cracha').Text+
                                        #13#13+'Deseja encerrar este vínculo?'), 'Aviso', MB_ICONEXCLAMATION + MB_YESNO) = MRYES then
          begin
            sbtnEncerrarVinculo.Click;
          end
        else
          Exit;
      end;

    //Filtros
    if cbbxTipoVinculo.Text = 'Funcionário' then
      begin
        Filtro := 'AND C.cod_vinculo = ''F'' AND C.cod_empresa = '''+edtCodEmpresa.Text+'''';
        if ReutCodCrachaFunc then
          Filtro := Filtro + ' AND C.status = True'
        else
          Filtro := Filtro + ' AND (C.status = True OR C.status = False)';
      end;
    if cbbxTipoVinculo.Text = 'Terceiro' then
      begin
        Filtro := 'AND C.cod_vinculo = ''T'' AND C.cod_empresa = '''+edtCodEmpresa.Text+'''';
        if ReutCodCrachaTerc then
          Filtro := Filtro + ' AND C.status = True'
        else
          Filtro := Filtro + ' AND (C.status = True OR C.status = False)';
      end;
    if cbbxTipoVinculo.Text = 'Visitante' then
      begin
        Filtro := 'AND C.cod_vinculo = ''V''';
        if ReutCodCrachaVis then
          Filtro := Filtro + ' AND C.status = True'
        else
          Filtro := Filtro + ' AND (C.status = True OR C.status = False)';
      end;

    //Verifica se o código do cracha está liberado
    SQLQuery(sqlqConsultasVerificacoes,['SELECT count(C.id_cracha) reg, P.id_pessoa, P.nome, C.status',
                                        'FROM p_cracha C',
                                        'INNER JOIN p_pessoas P ON P.id_pessoa = C.id_pessoa',
                                        'WHERE C.cracha = '''+edtCracha.Text+'''',
                                               Filtro]);
    if (sqlqConsultasVerificacoes.FieldByName('reg').AsInteger > 0) and
       ((sqlqConsultasVerificacoes.FieldByName('id_pessoa').Text <> ID_Pessoa) or
       ((sqlqConsultasVerificacoes.FieldByName('id_pessoa').Text = ID_Pessoa) and
       (sqlqConsultasVerificacoes.FieldByName('status').AsBoolean = False) and
       ((not ReutCodCrachaFunc) or (not ReutCodCrachaTerc) or (not ReutCodCrachaVis)))) then
      begin
        if sqlqConsultasVerificacoes.FieldByName('status').AsBoolean then
          begin
            MSG := 'O crachá '''+edtCracha.Text+''' já está em uso para '''
                   +sqlqConsultasVerificacoes.FieldByName('nome').Text+'''';
          end
        else
          begin
            MSG := 'O crachá '''+edtCracha.Text+''' já consta no histórico e não poderá ser utilizado'
          end;

        Application.MessageBox(PChar(MSG), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtCracha.SetFocus;
        Exit;
      end;

    if (medtDataFim.Text <> EmptyStr) and (medtDataFim.Text <> '  /  /    ') then
        Dt_Fim := FormatDateTime('YYYY-mm-dd',StrToDate(medtDataFim.Text))
      else
        Dt_Fim := '1900-01-01';

    try
      case cbbxTipoVinculo.Text of
        'Funcionário': Tipo_Vinculo := 'F';
        'Terceiro': Tipo_Vinculo := 'T';
        'Visitante': Tipo_Vinculo := 'V';
      end;
      if ckbxStatus.Checked then
        Status := '1'
      else
        Status := '0';

      if Acao = 'ADICIONAR' then
        begin
          SQLExec(sqlqVinculosOperacoes,['INSERT INTO p_cracha (id_pessoa, cod_vinculo, cod_empresa, cracha, nome_cracha,',
                                         'cod_setor, cod_centro_custo, cod_funcao, anotacoes, dt_inicio, dt_fim, status)',
                                         'VALUES ('''+ID_Pessoa+''','''+Tipo_Vinculo+''','''+Cod_Empresa+''',',
                                         ''''+edtCracha.Text+''','''+edtNomeCracha.Text+''','''+Cod_Setor+''','''+Cod_Centro_Custo+''',',
                                         ''''+Cod_Funcao+''','''+mmAnotacoes.Text+''','''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''',',
                                         '(CASE '+Dt_Fim+' WHEN '+'1900-01-01'+' THEN NULL ELSE '''+Dt_Fim+''' END),'''+Status+''')']);

          ID_Cracha := SQLQuery(sqlqConsultasVerificacoes,['SELECT MAX(id_cracha) idcracha FROM p_cracha WHERE id_pessoa = '''+ID_Pessoa+''''],'idcracha');
          MSG := 'Vínculo realizado com sucesso'+#13#13+'Detalhes:'+#13+''''+edtPessoaNome.Text+''' foi vinculado(a) ao crachá '''+edtCracha.Text+''' como '''+cbbxTipoVinculo.Text+'''';
          Log(LowerCase(Modulo),'pessoas','adicionar vínculo',ID_Cracha,gID_Usuario_Logado,gUsuario_Logado,'<<vínculo '+edtCracha.Text+'-'+cbbxTipoVinculo.Text+' criado '+ID_Pessoa+'-'+edtPessoaNome.Text+'>>');
        end;
      if Acao = 'EDITAR' then
        begin
          SQLExec(sqlqVinculosOperacoes,['UPDATE p_cracha SET',
                                         'cod_vinculo='''+Tipo_Vinculo+''',cod_empresa='''+Cod_Empresa+''',cracha='''+edtCracha.Text+''',nome_cracha='''+edtNomeCracha.Text+'''',
                                         ',cod_setor='''+Cod_Setor+''',cod_centro_custo='''+Cod_Centro_Custo+''',cod_funcao='''+Cod_Funcao+'''',
                                         ',anotacoes='''+mmAnotacoes.Text+''',dt_inicio='''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+'''',
                                         ',dt_fim=(CASE '+Dt_Fim+' WHEN '+'1900-01-01'+' THEN NULL ELSE '''+Dt_Fim+''' END),status='''+Status+'''',
                                         'WHERE id_cracha = '''+ID_Cracha+'''']);

          MSG := 'Vínculo atualizado com sucesso';
          Log(LowerCase(Modulo),'pessoas','editar vínculo',ID_Cracha,gID_Usuario_Logado,gUsuario_Logado,'<<vínculo '+edtCracha.Text+'-'+cbbxTipoVinculo.Text+' editado '+ID_Pessoa+'-'+edtPessoaNome.Text+'>>');
        end;
      sbtnAtualizar.Click;
      //gpbxVinculo.Height := 20;
      //pnlComandosVinculo.Visible := False;
      DesabilitaEdicaoVinculo;
      Acao := EmptyStr;
      Editado := False;
      Application.MessageBox(PChar(MSG), 'Aviso', MB_ICONINFORMATION + MB_OK);
    finally

    end;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar salvar o vínculo'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.ResetarControles;
begin
  lblCracha.Visible := False;
  edtCracha.Visible := False;
  lblNomeCracha.Visible := False;
  edtNomeCracha.Visible := False;
  lblCodEmpresa.Visible := False;
  edtCodEmpresa.Visible := False;
  lblEmpresa.Visible := False;
  edtEmpresa.Enabled := False;
  edtEmpresa.Visible := False;
  sbtnLocalizarEmpresa.Visible := False;
  lblDataInicio.Visible := False;
  medtDataInicio.Visible := False;
  lblDataFim.Visible := False;
  medtDataFim.Visible := False;
  ckbxStatus.Visible := False;
  lblCodSetor.Visible := False;
  edtCodSetor.Visible := False;
  lblSetor.Visible := False;
  edtSetor.Visible := False;
  edtSetor.Enabled := False;
  sbtnLocalizarSetor.Visible := False;
  lblCodFuncao.Visible := False;
  edtCodFuncao.Visible := False;
  lblFuncao.Visible := False;
  edtFuncao.Visible := False;
  edtFuncao.Enabled := False;
  sbtnLocalizarFuncao.Visible := False;
  lblCodCentroCusto.Visible := False;
  edtCodCentroCusto.Visible := False;
  lblCentroCusto.Visible := False;
  edtCentroCusto.Visible := False;
  edtCentroCusto.Enabled := False;
  sbtnLocalizarCentroCusto.Visible := False;
  lblAnotacoes.Visible := False;
  mmAnotacoes.Visible := False;
  cbbxTipoVinculo.ItemIndex := -1;
end;

procedure TfrmVinculos.DesabilitaEdicaoVinculo;
begin
  cbbxTipoVinculo.Enabled := False;
  edtCracha.Enabled := False;
  edtNomeCracha.Enabled := False;
  edtCodEmpresa.Enabled := False;
  sbtnLocalizarEmpresa.Enabled := False;
  medtDataInicio.Enabled := False;
  medtDataFim.Enabled := False;
  ckbxStatus.Enabled := False;
  edtCodFuncao.Enabled := False;
  sbtnLocalizarFuncao.Enabled := False;
  edtCodSetor.Enabled := False;
  sbtnLocalizarSetor.Enabled := False;
  edtCodCentroCusto.Enabled := False;
  sbtnLocalizarCentroCusto.Enabled := False;
  mmAnotacoes.Enabled := False;
end;

procedure TfrmVinculos.HabilitaEdicaoVinculo;
begin
  cbbxTipoVinculo.Enabled := True;
  edtCracha.Enabled := True;
  edtNomeCracha.Enabled := True;
  edtCodEmpresa.Enabled := True;
  sbtnLocalizarEmpresa.Enabled := True;
  medtDataInicio.Enabled := True;
  medtDataFim.Enabled := True;
  ckbxStatus.Enabled := True;
  edtCodFuncao.Enabled := True;
  sbtnLocalizarFuncao.Enabled := True;
  edtCodSetor.Enabled := True;
  sbtnLocalizarSetor.Enabled := True;
  edtCodCentroCusto.Enabled := True;
  sbtnLocalizarCentroCusto.Enabled := True;
  mmAnotacoes.Enabled := True;
end;

procedure TfrmVinculos.sbtnTrocarPessoaClick(Sender: TObject);
begin
  if Editado = True then
    begin
      if Application.MessageBox(Pchar('Cancelar a edição?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          if formOrigem = Self.Name then
            begin
              Acao := EmptyStr;
              Editado := False;
              ID_Pessoa := '0';
              CleanForm(Self);
              sbtnAtualizar.Enabled := False;
              sbtnAtualizar.Click;
              edtPessoa_ID.Enabled := True;
              edtPessoaNome.Enabled := False;
              medtPessoaCPF.Enabled := False;
              Self.Caption := 'Vínculos  [<<Selecionar pessoa>>]';
              ResetarControles;
              DesabilitaEdicaoVinculo;
              pnlComandosVinculo.Visible := False;
              gpbxVinculo.Height := 20;
              FormEditVincAberto := False;
              ResetarControles;
              DesabilitaEdicaoVinculo;
              pnlComandosVinculo.Visible := False;
              gpbxVinculo.Height := 20;
              FormEditVincAberto := False;
              edtPessoa_ID.SetFocus;
            end
          else
            begin
              Self.Close;
            end;
        end
      else
        Abort;
    end
  else
    begin
      {BtnClicado := Application.MessageBox(PChar('Deseja sair do cadastro?'),'Confirmação', MB_ICONQUESTION + MB_YESNOCANCEL);
      if BtnClicado = MRYES then
        Self.Close
      else if BtnClicado = MRNO then
        begin}
          Acao := EmptyStr;
          ID_Pessoa := '0';
          CleanForm(Self);
          sbtnAtualizar.Enabled := False;
          sbtnAtualizar.Click;
          edtPessoa_ID.Enabled := True;
          edtPessoaNome.Enabled := False;
          medtPessoaCPF.Enabled := False;
          Self.Caption := 'Vínculos  [<<Selecionar pessoa>>]';
          ResetarControles;
          DesabilitaEdicaoVinculo;
          pnlComandosVinculo.Visible := False;
          gpbxVinculo.Height := 20;
          FormEditVincAberto := False;
          ResetarControles;
          DesabilitaEdicaoVinculo;
          pnlComandosVinculo.Visible := False;
          gpbxVinculo.Height := 20;
          FormEditVincAberto := False;
          Editado := False;
        //end
      //else
        //Abort;
    end;
end;

procedure TfrmVinculos.SelEmpresa;
begin
  try
    if (medtDataInicio.Text = EmptyStr) or (medtDataInicio.Text = '  /  /    ') then
      begin
        Application.MessageBox(PChar('Informe a data de início de uso do crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataInicio.SetFocus;
        Clean([edtCodEmpresa,edtEmpresa]);
        Cod_Empresa := EmptyStr;
        Exit;
      end;
    SelDtInicio;
    //Localiza os dados da empresa selecionada
    if (Acao = 'ADICIONAR')
       or (Editado) then
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_empresa) reg, cod_empresa, fantasia, status',
                                            'FROM g_empresas',
                                            'WHERE 1=1',
                                            'AND cod_empresa = '''+edtCodEmpresa.Text+'''',
                                            'AND status = True',
                                            'AND (strftime(''%Y-%m-%d'',dt_inicio) <= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''')',
                                            'AND ((strftime(''%Y-%m-%d'',dt_fim) >= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''') OR dt_fim IS NULL)']);
      end
    else
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_empresa) reg, cod_empresa, fantasia, status',
                                            'FROM g_empresas',
                                            'WHERE 1=1',
                                            'AND cod_empresa = '''+edtCodEmpresa.Text+'''']);
      end;

    if sqlqConsultasVerificacoes.FieldByName('reg').AsInteger > 0 then
      begin
        Cod_Empresa := sqlqConsultasVerificacoes.FieldByName('cod_empresa').Text;
        edtEmpresa.Text := sqlqConsultasVerificacoes.FieldByName('fantasia').Text;
      end
    else
      begin
        Application.MessageBox(PChar('Empresa não localizada ou inativa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Clean([edtCodEmpresa,edtEmpresa]);
        Cod_Empresa := EmptyStr;
        edtCodEmpresa.SetFocus;
        Exit;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar selecionar a empresa'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.SelSetor;
begin
  try
    if (medtDataInicio.Text = EmptyStr) or (medtDataInicio.Text = '  /  /    ') then
      begin
        Application.MessageBox(PChar('Informe a data de início de uso do crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataInicio.SetFocus;
        Clean([edtCodSetor,edtSetor]);
        Cod_Setor := EmptyStr;
        Exit;
      end;
    if Cod_Empresa = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione a empresa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtCodEmpresa.SetFocus;
        Clean([edtCodSetor,edtSetor]);
        Cod_Setor := EmptyStr;
        Exit;
      end;

    //Localiza setor informado
    if (Acao = 'ADICIONAR')
       or (Editado) then
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_setor) reg, cod_setor, setor, status',
                                            'FROM g_setores',
                                            'WHERE 1=1',
                                            'AND cod_setor = '''+edtCodSetor.Text+'''',
                                            'AND cod_empresa = '''+Cod_Empresa+'''',
                                            'AND status = True',
                                            'AND (strftime(''%Y-%m-%d'',dt_inicio) <= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''')',
                                            'AND ((strftime(''%Y-%m-%d'',dt_fim) >= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''') OR dt_fim IS NULL)']);
      end
    else
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_setor) reg, cod_setor, setor, status',
                                            'FROM g_setores',
                                            'WHERE 1=1',
                                            'AND cod_setor = '''+edtCodSetor.Text+'''',
                                            'AND cod_empresa = '''+Cod_Empresa+'''']);
      end;
    if sqlqConsultasVerificacoes.FieldByName('reg').AsInteger > 0 then
      begin
        Cod_Setor := sqlqConsultasVerificacoes.FieldByName('cod_setor').Text;
        edtSetor.Text := sqlqConsultasVerificacoes.FieldByName('setor').Text;
      end
    else
      begin
        Application.MessageBox(PChar('Setor não localizado ou inativo'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Clean([edtCodSetor,edtSetor]);
        Cod_Setor := EmptyStr;
        edtCodSetor.SetFocus;
        Exit;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar selecionar o setor'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.SelFuncao;
begin
  try
    if (medtDataInicio.Text = EmptyStr) or (medtDataInicio.Text = '  /  /    ') then
      begin
        Application.MessageBox(PChar('Informe a data de início de uso do crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataInicio.SetFocus;
        Clean([edtCodFuncao,edtSetor]);
        Cod_Funcao := EmptyStr;
        Exit;
      end;
    if Cod_Empresa = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione a empresa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtCodEmpresa.SetFocus;
        Clean([edtCodFuncao,edtSetor]);
        Cod_Funcao := EmptyStr;
        Exit;
      end;

    //Localiza função informada
    if (Acao = 'ADICIONAR')
       or (Editado) then
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_funcao) reg, cod_funcao, funcao, status',
                                            'FROM p_funcoes',
                                            'WHERE 1=1',
                                            'AND cod_funcao = '''+edtCodFuncao.Text+'''',
                                            'AND cod_empresa = '''+Cod_Empresa+'''',
                                            'AND status = True',
                                            'AND (strftime(''%Y-%m-%d'',dt_inicio) <= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''')',
                                            'AND ((strftime(''%Y-%m-%d'',dt_fim) >= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''') OR dt_fim IS NULL)']);
      end
    else
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_funcao) reg, cod_funcao, funcao, status',
                                            'FROM p_funcoes',
                                            'WHERE 1=1',
                                            'AND cod_funcao = '''+edtCodFuncao.Text+'''',
                                            'AND cod_empresa = '''+Cod_Empresa+'''']);
      end;

    if sqlqConsultasVerificacoes.FieldByName('reg').AsInteger > 0 then
      begin
        Cod_Funcao := sqlqConsultasVerificacoes.FieldByName('cod_funcao').Text;
        edtFuncao.Text := sqlqConsultasVerificacoes.FieldByName('funcao').Text;
      end
    else
      begin
        Application.MessageBox(PChar('Função não localizada ou inativa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Clean([edtCodFuncao,edtFuncao]);
        Cod_Funcao := EmptyStr;
        edtCodFuncao.SetFocus;
        Exit;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar selecionar a função'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.SelCentroCusto;
begin
  try
    if (medtDataInicio.Text = EmptyStr) or (medtDataInicio.Text = '  /  /    ') then
      begin
        Application.MessageBox(PChar('Informe a data de início de uso do crachá'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataInicio.SetFocus;
        Clean([edtCodCentroCusto,edtCentroCusto]);
        Cod_Centro_Custo := EmptyStr;
        Exit;
      end;
    if Cod_Empresa = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione a empresa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtCodEmpresa.SetFocus;
        Clean([edtCodCentroCusto,edtCentroCusto]);
        Cod_Centro_Custo := EmptyStr;
        Exit;
      end;

    //Localiza função informada
    if (Acao = 'ADICIONAR')
       or (Editado) then
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_centro_custo) reg, cod_centro_custo, centro_custo, status',
                                            'FROM g_centros_custo',
                                            'WHERE 1=1',
                                            'AND cod_centro_custo = '''+edtCodCentroCusto.Text+'''',
                                            'AND cod_empresa = '''+Cod_Empresa+'''',
                                            'AND status = True',
                                            'AND (strftime(''%Y-%m-%d'',dt_inicio) <= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''')',
                                            'AND ((strftime(''%Y-%m-%d'',dt_fim) >= '''+FormatDateTime('YYYY-mm-dd',StrToDate(Dt_Inicio))+''') OR dt_fim IS NULL)']);
      end
    else
      begin
        SQLQuery(sqlqConsultasVerificacoes,['SELECT count(cod_centro_custo) reg, cod_centro_custo, centro_custo, status',
                                            'FROM g_centros_custo',
                                            'WHERE 1=1',
                                            'AND cod_centro_custo = '''+edtCodCentroCusto.Text+'''',
                                            'AND cod_empresa = '''+Cod_Empresa+'''']);
      end;
    if sqlqConsultasVerificacoes.FieldByName('reg').AsInteger > 0 then
      begin
        Cod_Centro_Custo := sqlqConsultasVerificacoes.FieldByName('cod_centro_custo').Text;
        edtCentroCusto.Text := sqlqConsultasVerificacoes.FieldByName('centro_custo').Text;
      end
    else
      begin
        Application.MessageBox(PChar('Centro de Custo não localizado ou inativo'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Clean([edtCodCentroCusto,edtCentroCusto]);
        Cod_Centro_Custo := EmptyStr;
        edtCodCentroCusto.SetFocus;
        Exit;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar selecionar o centro de custo'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmVinculos.SelDtInicio;
begin
  if (medtDataInicio.Text <> EmptyStr) and (medtDataInicio.Text <> '  /  /    ') then
    begin
      try
        StrToDate(medtDataInicio.Text);
      Except
        begin
          Application.MessageBox('A data de início informada é inválido','Aviso', MB_ICONWARNING + MB_OK);
          medtDataInicio.SetFocus;
          medtDataInicio.SelectAll;
          Exit;
        end;
      end;

      if Dt_Inicio <> medtDataInicio.Text then
        begin
          if Cod_Empresa <> EmptyStr then
            begin
              Cod_Empresa := EmptyStr;
              Clean([edtCodEmpresa,edtEmpresa]);
            end;
          if Cod_Setor <> EmptyStr then
            begin
              Cod_Setor := EmptyStr;
              Clean([edtCodSetor,edtSetor]);
            end;
          if Cod_Funcao <> EmptyStr then
            begin
              Cod_Funcao := EmptyStr;
              Clean([edtCodFuncao,edtFuncao]);
            end;
          if Cod_Centro_Custo <> EmptyStr then
            begin
              Cod_Centro_Custo := EmptyStr;
              Clean([edtCodCentroCusto,edtCentroCusto]);
            end;
        end;

      Dt_Inicio := medtDataInicio.Text;
    end;
end;

function TfrmVinculos.VerificaLancamentos(SQL: TSQLQuery; ID_Cracha: String): Boolean;
begin
  try
    SQLQuery(SQL,['SELECT COUNT(R.id_reg_refeicao) NREG',
                  'FROM r_reg_refeicoes R',
                  'INNER JOIN p_cracha C ON C.cracha = R.cracha',
                  'WHERE C.id_cracha = '''+ID_Cracha+'''']);
    if SQL.Fields[0].AsInteger = 0 then
      Result := True
    else
      Result := False;
  except on E: Exception do
    begin

    end;
  end;
end;

end.

