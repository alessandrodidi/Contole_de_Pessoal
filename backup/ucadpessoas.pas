unit UCadPessoas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, LCLType, Buttons, EditBtn, StdCtrls, Menus, MaskEdit, Grids, DBCtrls,
  BCButton, BGRASpeedButton, ExtendedTabControls, Windows;

type

  { TfrmCadPessoas }

  TfrmCadPessoas = class(TForm)
    bcbtnAplFiltros: TBCButton;
    bcbtnCadastros: TBCButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    dsConsMunicipios: TDataSource;
    dbnContatos: TDBNavigator;
    dsContatos: TDataSource;
    dbgContatos: TDBGrid;
    dsEnderecos: TDataSource;
    dbgEnderecos: TDBGrid;
    dbnEnderecos: TDBNavigator;
    dsCadPessoas: TDataSource;
    dbgPessoas: TDBGrid;
    edtPessoaID: TEdit;
    edtPessoaNome: TEdit;
    edtPessoaNumRG: TEdit;
    edtPessoaOrgaoExpRG: TEdit;
    gpbxEnderecos: TGroupBox;
    gpbxDadosPessoais: TGroupBox;
    gpbxContatos: TGroupBox;
    gpbxFoto: TGroupBox;
    imgFoto: TImage;
    lblPessoaCPF: TLabel;
    lblPessoaDtNascimento: TLabel;
    lblPessoaID: TLabel;
    lblPessoaNome: TLabel;
    lblPessoaNumRG: TLabel;
    lblPessoaOrgaoExpRG: TLabel;
    medtPessoaDataNasmento: TMaskEdit;
    medtPessoaNumCPF: TMaskEdit;
    ppmniCadTiposLogradouros: TMenuItem;
    pnlCadCont: TPanel;
    pnlCadEsq: TPanel;
    ppmniCadMunicipios: TMenuItem;
    ppmniCadEstados: TMenuItem;
    ppmniCadCEPs: TMenuItem;
    pnlComandosCadastro: TPanel;
    ppmnCadastros: TPopupMenu;
    ppmniGerFiltros: TMenuItem;
    ppmniNovoFiltro: TMenuItem;
    ppmniFiltrosGlobais: TMenuItem;
    ppmniFiltrosPessoais: TMenuItem;
    N1: TMenuItem;
    pnlCadastro: TPanel;
    pnlComandos: TPanel;
    ppmnFiltros: TPopupMenu;
    sbtnAtualizar: TSpeedButton;
    sbtnAddPessoa: TSpeedButton;
    sbtnEditarPessoa: TSpeedButton;
    sbtnExcluirPessoa: TSpeedButton;
    sbtnGerFiltros: TSpeedButton;
    sbtnGerFotos: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnCadastros: TSpeedButton;
    shpFundoFoto: TShape;
    sbtnVinculo: TSpeedButton;
    sbtnRestricoes: TSpeedButton;
    sqlqCadPessoas: TSQLQuery;
    sqlqEnderecos: TSQLQuery;
    sqlqContatos: TSQLQuery;
    sqlqConsCEP: TSQLQuery;
    sqlqConsMunicipios: TSQLQuery;
    sqlqConsUF: TSQLQuery;
    sqlqTiposLogradouros: TSQLQuery;
    sqlqPessoasOperacoes: TSQLQuery;
    sqlqFiltro: TSQLQuery;
    procedure dbgContatosCellClick(Column: TColumn);
    procedure dbgContatosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgContatosKeyPress(Sender: TObject; var Key: char);
    procedure dbgContatosMouseLeave(Sender: TObject);
    procedure dbgContatosMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgContatosTitleClick(Column: TColumn);
    procedure dbgEnderecosCellClick(Column: TColumn);
    procedure dbgEnderecosEditingDone(Sender: TObject);
    procedure dbgEnderecosEndDag(Sender, Target: TObject; X, Y: Integer);
    procedure dbgEnderecosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgEnderecosKeyPress(Sender: TObject; var Key: char);
    procedure dbgEnderecosMouseLeave(Sender: TObject);
    procedure dbgEnderecosMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgEnderecosTitleClick(Column: TColumn);
    procedure dbgPessoasDblClick(Sender: TObject);
    procedure dbgPessoasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgPessoasMouseLeave(Sender: TObject);
    procedure dbgPessoasMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgPessoasPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure dbgPessoasTitleClick(Column: TColumn);
    procedure dbnContatosClick(Sender: TObject; Button: TDBNavButtonType);
    procedure dbnEnderecosClick(Sender: TObject; Button: TDBNavButtonType);
    procedure edtPessoaNomeKeyPress(Sender: TObject; var Key: char);
    procedure edtPessoaNumRGKeyPress(Sender: TObject; var Key: char);
    procedure edtPessoaOrgaoExpRGKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure gpbxContatosMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gpbxContatosMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure gpbxEnderecosMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gpbxEnderecosMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure medtPessoaDataNasmentoKeyPress(Sender: TObject; var Key: char);
    procedure medtPessoaNumCPFKeyPress(Sender: TObject; var Key: char);
    procedure ppmnFiltrosPopup(Sender: TObject);
    procedure ppmniCadCEPsClick(Sender: TObject);
    procedure ppmniCadMunicipiosClick(Sender: TObject);
    procedure ppmniCadEstadosClick(Sender: TObject);
    procedure ppmniGerFiltrosClick(Sender: TObject);
    procedure ppmniNovoFiltroClick(Sender: TObject);
    procedure sbtnAddPessoaClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnCadastrosClick(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnEditarPessoaClick(Sender: TObject);
    procedure sbtnExcluirPessoaClick(Sender: TObject);
    procedure sbtnGerFiltrosClick(Sender: TObject);
    procedure sbtnGerFotosClick(Sender: TObject);
    procedure sbtnRestricoesClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure CarregarEnderecoContato;
    procedure sbtnVinculoClick(Sender: TObject);
    procedure sqlqContatosAfterDelete(DataSet: TDataSet);
    procedure sqlqContatosBeforeDelete(DataSet: TDataSet);
    procedure sqlqContatosBeforePost(DataSet: TDataSet);
    procedure sqlqEnderecosBeforeDelete(DataSet: TDataSet);
    procedure sqlqEnderecosBeforePost(DataSet: TDataSet);
    procedure ExecFiltro(Sender: TObject);
  private
    Acao, ID_Pessoa: String;
    Editado, ContatosAberto, EnderecosAberto: Boolean;
    const
      Modulo: String = 'CADASTROS';
      Formulario: String = 'CADPESSOAS';
  public
    ID_Filtro_Selecionado, Filtro: String;
  end;

var
  frmCadPessoas: TfrmCadPessoas;

implementation

uses
  UGFunc, UDBO, UConexao, UVinculosPessoas, UGerencFotos, ExpertTabSheet, UPrincipal,
  UFiltros, UEditorCadFiltros, UExecutaFiltro, URestricaoAcesso;

{$R *.lfm}

{ TfrmCadPessoas }

procedure TfrmCadPessoas.FormCreate(Sender: TObject);
var
  Button: TDBNavButtonType;
begin
  pnlCadastro.Height := 0;
  gpbxEnderecos.Height := 20;
  gpbxContatos.Height := 20;
  gpbxEnderecos.Top := 110;
  gpbxContatos.Top := 140;
  ContatosAberto := False;
  EnderecosAberto := False;

  if CheckPermission(UserPermissions,Modulo,'CADPSADD') then
    sbtnAddPessoa.Enabled := True
  else
    sbtnAddPessoa.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADPSEDT') or
     CheckPermission(UserPermissions,Modulo,'CADEDCAD') or
     CheckPermission(UserPermissions,Modulo,'CADCTCAD') then
    sbtnEditarPessoa.Enabled := True
  else
    sbtnEditarPessoa.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADPSDEL') then
    sbtnExcluirPessoa.Enabled := True
  else
    sbtnExcluirPessoa.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADFTCAD') then
    sbtnGerFotos.Enabled := True
  else
    sbtnGerFotos.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADEDCAD') then
    gpbxEnderecos.Enabled := True
  else
    gpbxEnderecos.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADEDADD') then
    dbnEnderecos.Controls[4].Visible := True
  else
    dbnEnderecos.Controls[4].Visible := False;

  if CheckPermission(UserPermissions,Modulo,'CADEDDEL') then
    dbnEnderecos.Controls[5].Visible := True
  else
    dbnEnderecos.Controls[5].Visible := False;

  if CheckPermission(UserPermissions,Modulo,'CADEDEDT') then
    dbnEnderecos.Controls[6].Visible := True
  else
    dbnEnderecos.Controls[6].Visible := False;

  if CheckPermission(UserPermissions,Modulo,'CADEDADD') or
     CheckPermission(UserPermissions,Modulo,'CADEDEDT') then
    begin
      dbgEnderecos.ReadOnly := False;
      dbnEnderecos.Controls[7].Visible := True;
      dbnEnderecos.Controls[8].Visible := True;
    end
  else
    begin
      dbgEnderecos.ReadOnly := True;
      dbnEnderecos.Controls[7].Visible := False;
      dbnEnderecos.Controls[8].Visible := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADCTCAD') then
    gpbxContatos.Enabled := True
  else
    gpbxContatos.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADCTADD') then
    dbnContatos.Controls[4].Visible := True
  else
    dbnContatos.Controls[4].Visible := False;

  if CheckPermission(UserPermissions,Modulo,'CADCTDEL') then
    dbnContatos.Controls[5].Visible := True
  else
    dbnContatos.Controls[5].Visible := False;

  if CheckPermission(UserPermissions,Modulo,'CADCTEDT') then
    dbnContatos.Controls[6].Visible := True
  else
    dbnContatos.Controls[6].Visible := False;

  if CheckPermission(UserPermissions,Modulo,'CADCTADD') or CheckPermission(UserPermissions,Modulo,'CADCTEDT') then
    begin
      dbgContatos.ReadOnly := False;
      dbnContatos.Controls[7].Visible := True;
      dbnContatos.Controls[8].Visible := True;
    end
  else
    begin
      dbgContatos.ReadOnly := True;
      dbnContatos.Controls[7].Visible := False;
      dbnContatos.Controls[8].Visible := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADFUCAD') or
     CheckPermission(UserPermissions,Modulo,'CADTCCAD') or
     CheckPermission(UserPermissions,Modulo,'CADVSCAD') then
    begin
      sbtnVinculo.Enabled := True;
    end
  else
    begin
      sbtnVinculo.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADPSRES') then
    begin
      sbtnRestricoes.Enabled := True;
    end
  else
    begin
      sbtnRestricoes.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADMNCAD') then
    ppmniCadMunicipios.Enabled := True
  else
    ppmniCadMunicipios.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADCPCAD') then
    ppmniCadCEPs.Enabled := True
  else
    ppmniCadCEPs.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADTLCAD') then
    ppmniCadTiposLogradouros.Enabled := True
  else
    ppmniCadTiposLogradouros.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADETCAD') then
    ppmniCadEstados.Enabled := True
  else
    ppmniCadEstados.Enabled := False;
end;

procedure TfrmCadPessoas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnSalvar.Click;
end;

procedure TfrmCadPessoas.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    begin
      Key := #0;
      SelectNext(ActiveControl,True,True);
      Exit;
    end;
end;

procedure TfrmCadPessoas.edtPessoaNomeKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46]) then
    Editado := True;
end;

procedure TfrmCadPessoas.edtPessoaNumRGKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46]) then
    Editado := True;
end;

procedure TfrmCadPessoas.edtPessoaOrgaoExpRGKeyPress(Sender: TObject;
  var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46]) then
    Editado := True;
end;

procedure TfrmCadPessoas.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Editado then
    begin
      case Application.MessageBox(PChar('Deseja salvar as alterações?'), 'Confirmação',  MB_ICONQUESTION + MB_YESNOCANCEL) of
        MRYES:
          begin
            sbtnSalvar.Click;
            sqlqCadPessoas.Active := False;
            sqlqContatos.Active := False;
            sqlqEnderecos.Active := False;
            Self.Close;
          end;
        MRNO:
          begin
            Editado := False;
            if sqlqCadPessoas.Active then
              sqlqCadPessoas.Active := False;
            if sqlqContatos.Active then
               sqlqContatos.Active := False;
            if sqlqEnderecos.Active then
               sqlqEnderecos.Active := False;
            Self.Close;
          end;
        MRCANCEL:
          Abort;
      end;
    end
  else
    begin
      if sqlqContatos.Active then
        sqlqContatos.Active := False;
      if sqlqEnderecos.Active then
         sqlqEnderecos.Active := False;
      if sqlqCadPessoas.Active then
         sqlqCadPessoas.Active := False;
    end;

end;

procedure TfrmCadPessoas.dbnContatosClick(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if Button = nbInsert then
    begin
      dbgContatos.Columns[1].Field.Value := ID_Pessoa;
      dbgContatos.Columns[2].Field.FocusControl;

      if dbgContatos.DataSource.DataSet.RecordCount < 1 then
        dbgContatos.DataSource.DataSet.FieldByName('PREFERENCIAL').Value := True
      else
        dbgContatos.DataSource.DataSet.FieldByName('PREFERENCIAL').Value := False;
    end;
  if Button = nbPost then
    Editado := False;
  if Button = nbCancel then
    Editado := False;
end;

procedure TfrmCadPessoas.dbnEnderecosClick(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if Button = nbInsert then
    begin
      dbgEnderecos.Columns[1].Field.Value := ID_Pessoa;
      dbgEnderecos.Columns[2].Field.FocusControl;

      if dbgEnderecos.DataSource.DataSet.RecordCount < 1 then
        dbgEnderecos.DataSource.DataSet.FieldByName('PREFERENCIAL').Value := True
      else
        dbgEnderecos.DataSource.DataSet.FieldByName('PREFERENCIAL').Value := False;
    end;
  if Button = nbPost then
    Editado := False;
  if Button = nbCancel then
    Editado := False;
end;

procedure TfrmCadPessoas.dbgEnderecosCellClick(Column: TColumn);
var
  reg: Integer;
begin
  reg := sqlqEnderecos.RecNo;
  if Column.Title.Caption = 'PREFERENCIAL' then
    begin
      if (sqlqEnderecos.RecordCount < 1) and
         (sqlqEnderecos.FieldByName('id_endereco').IsNull) then
        Column.Field.Value := True
      else
      if (sqlqEnderecos.RecordCount = 1) and
         ((not sqlqEnderecos.FieldByName('id_endereco').IsNull) or
         (sqlqEnderecos.FieldByName('id_endereco').IsNull)) then
        Column.Field.Value := True
      else
        begin
          sqlqEnderecos.First;
          while not sqlqEnderecos.EOF do
            begin
                sqlqEnderecos.Edit;
                if reg = sqlqEnderecos.RecNo then
                  sqlqEnderecos.FieldByName('PREFERENCIAL').AsBoolean := True
                else
                  sqlqEnderecos.FieldByName('PREFERENCIAL').AsBoolean := False;
                sqlqEnderecos.Post;
              sqlqEnderecos.Next;
            end;
          sqlqEnderecos.RecNo := reg;
          reg := 0;
        end;
    end;

  //Carregar o PickList mais rápido
  if Column.PickList.Count > 0 then
    begin
     keybd_event(VK_F2,0,0,0);
     keybd_event(VK_F2,0,KEYEVENTF_KEYUP,0);
     keybd_event(VK_MENU,0,0,0);
     keybd_event(VK_DOWN,0,0,0);
     keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
     keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);
   end;

 { if dbgEnderecos.SelectedColumn.Index = 12 then
    begin
      sqlqConsMunicipios.Close;
      sqlqConsMunicipios.Filtered := False;
      if dbgEnderecos.Columns[9].Field.Text <> EmptyStr then
        sqlqConsMunicipios.Filter := 'cod_uf_ibge = '+dbgEnderecos.Columns[9].Field.Text
      else
        sqlqConsMunicipios.Filter := '';
      sqlqConsMunicipios.Open;
      sqlqConsMunicipios.Filtered := True;
      sqlqConsMunicipios.First;
      dbgEnderecos.Columns[12].PickList.Clear;
      while not sqlqConsMunicipios.Eof do
        begin
          dbgEnderecos.Columns[12].PickList.Add(sqlqConsMunicipios.Fields[2].AsString+' ['+sqlqConsMunicipios.Fields[0].AsString+']');
          sqlqConsMunicipios.next;
         end;
    end;}
end;

procedure TfrmCadPessoas.dbgEnderecosEditingDone(Sender: TObject);
var
  Cod_IBGE_Munic, Cod_IBGE_UF: TStrings;
begin
  //if CheckPermission(UserPermissions,Modulo,'CADEDADD') or
  //   CheckPermission(UserPermissions,Modulo,'CADEDEDT') then
  if not dbgEnderecos.ReadOnly then
    begin
      try
        {try
          if dbgEnderecos.EditorMode then
          Cod_IBGE_UF := TStringList.Create;
          if dbgEnderecos.SelectedColumn.Index = 10 then
            begin
              if dbgEnderecos.Columns[10].Field.Text <> EmptyStr then
                begin
                  Cod_IBGE_UF.Clear;
                  ExtractStrings(['[',']'], [], PChar(dbgEnderecos.Columns[10].Field.Text), Cod_IBGE_UF);
                  dbgEnderecos.Columns[9].Field.Text := Cod_IBGE_UF[1];
                  {sqlqConsMunicipios.Open;
                  sqlqConsMunicipios.Filtered := False;
                  sqlqConsMunicipios.Filter := 'cod_uf_ibge = '+Cod_IBGE_UF[1];
                  sqlqConsMunicipios.Filtered := True;
                  sqlqConsMunicipios.First;
                  dbgEnderecos.Columns[12].PickList.Clear;
                  while not sqlqConsMunicipios.Eof do
                    begin
                      dbgEnderecos.Columns[12].PickList.Add(sqlqConsMunicipios.Fields[2].AsString+' ['+sqlqConsMunicipios.Fields[0].AsString+']');
                      sqlqConsMunicipios.next;
                    end;}
                end
              else
                begin
                  dbgEnderecos.Columns[9].Field.Text := '';
                  {sqlqConsMunicipios.Open;
                  sqlqConsMunicipios.Filtered := False;
                  sqlqConsMunicipios.Filter := '';
                  sqlqConsMunicipios.First;
                  dbgEnderecos.Columns[12].PickList.Clear;
                  while not sqlqConsMunicipios.Eof do
                    begin
                      dbgEnderecos.Columns[12].PickList.Add(sqlqConsMunicipios.Fields[2].AsString+' ['+sqlqConsMunicipios.Fields[0].AsString+']');
                      sqlqConsMunicipios.next;
                    end;}
                  Exit;
                end;
            end;
        finally
          Cod_IBGE_UF.Free;
          sqlqConsUF.Close;
          sqlqConsCEP.Close;
          sqlqConsMunicipios.Close;
        end;
      except on E: exception do
        begin
          sqlqConsUF.Free;
          sqlqConsCEP.Free;
          sqlqConsMunicipios.Free;
          Application.MessageBox(PChar('Erro ao selecionar o estado'+#13#13+'Classe '+E.ClassName+#13+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
      end;

      try
        try
          Cod_IBGE_Munic := TStringList.Create;
          if dbgEnderecos.SelectedColumn.Index = 12 then
            begin
              if dbgEnderecos.Columns[12].Field.Text <> EmptyStr then
                begin
                  Cod_IBGE_Munic.Clear;
                  ExtractStrings(['[',']'], [], PChar(dbgEnderecos.Columns[12].Field.Text), Cod_IBGE_Munic);
                  dbgEnderecos.Columns[11].Field.Text := Cod_IBGE_Munic[1];
                end
              else
                begin
                  dbgEnderecos.Columns[11].Field.Text := '';
                  Exit;
                end;
            end;
        finally
          Cod_IBGE_Munic.Free;
        end;}
      except on E: exception do
        begin
          //FreeAndNil(Cod_IBGE_Munic);
          //FreeAndNil(dbgEnderecos);
          //FreeAndNil(sqlqConsMunicipios);
          Application.MessageBox(PChar('Erro ao selecionar o município'+#13#13+'Classe '+E.ClassName+#13+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
      end;
    end;
end;

procedure TfrmCadPessoas.dbgEnderecosEndDag(Sender, Target: TObject; X,
  Y: Integer);
begin

end;

procedure TfrmCadPessoas.dbgEnderecosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i, Col: Integer;
begin
  Col := -1;
  for i := (Sender as TDBGrid).Columns.Count-1 downto 0 do
    begin
      if (Sender as TDBGrid).Columns.Items[i].Visible then
        begin
          Col := i;
          Break;
        end;
    end;

  if (Shift = [ssCtrl]) and (Key = VK_DELETE) then
    if not CheckPermission(UserPermissions,Modulo,'CADEDDEL') then
      Key := 0;

  if (Key = VK_INSERT) or ((Key = VK_DOWN) and ((Sender as TDBGrid).DataSource.DataSet.RecNo = (Sender as TDBGrid).DataSource.DataSet.RecordCount)) then
    begin
      //if not CheckPermission(UserPermissions,Modulo,'CADEDADD') then
        Key := 0;
    end;

  if (Key = VK_TAB) and ((Sender as TDBGrid).DataSource.DataSet.RecNo = (Sender as TDBGrid).DataSource.DataSet.RecordCount) then
    begin
      if ((Sender as TDBGrid).SelectedIndex = Col) then
        //if not CheckPermission(UserPermissions,Modulo,'CADEDADD') then
          Key := 0;
    end;
end;

procedure TfrmCadPessoas.dbgEnderecosKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46]) then
    Editado := True;
end;

procedure TfrmCadPessoas.dbgEnderecosMouseLeave(Sender: TObject);
begin
  //Screen.Cursor := crDefault;
end;

procedure TfrmCadPessoas.dbgEnderecosMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  mousePt: TGridcoord;
begin
  {mousePt := dbgEnderecos.MouseCoord(x,y);
  if mousePt.y = 0 then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := crDefault;}
end;

procedure TfrmCadPessoas.dbgEnderecosTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgEnderecos.Columns.Count -1 do
    dbgEnderecos.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgEnderecos.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

procedure TfrmCadPessoas.dbgPessoasDblClick(Sender: TObject);
begin
  sbtnEditarPessoa.Click;
end;

procedure TfrmCadPessoas.dbgPessoasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    sbtnExcluirPessoa.Click;
end;

procedure TfrmCadPessoas.dbgPessoasMouseLeave(Sender: TObject);
begin
  //Screen.Cursor := crDefault;
end;

procedure TfrmCadPessoas.dbgContatosMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  mousePt: TGridcoord;
begin
  {mousePt := dbgContatos.MouseCoord(x,y);
  if mousePt.y = 0 then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := crDefault;}
end;

procedure TfrmCadPessoas.dbgContatosMouseLeave(Sender: TObject);
begin
  //Screen.Cursor := crDefault;
end;

procedure TfrmCadPessoas.dbgContatosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i, Col: Integer;
begin
  Col := -1;
  for i := (Sender as TDBGrid).Columns.Count-1 downto 0 do
    begin
      if  (Sender as TDBGrid).Columns.Items[i].Visible then
        begin
          Col := i;
          Break;
        end;
    end;

  if (Shift = [ssCtrl]) and (Key = VK_DELETE) then
    if not CheckPermission(UserPermissions,Modulo,'CADCTDEL') then
      Key := 0;

  if (Key = VK_INSERT) or ((Key = VK_DOWN) and ((Sender as TDBGrid).DataSource.DataSet.RecNo = (Sender as TDBGrid).DataSource.DataSet.RecordCount)) then
    begin
      //if not CheckPermission(UserPermissions,Modulo,'CADCTADD') then
        Key := 0;
    end;

  if (Key = VK_TAB) and (sqlqEnderecos.RecNo = sqlqEnderecos.RecordCount) then
    begin
      if ((Sender as TDBGrid).SelectedIndex = Col) then
        //if not CheckPermission(UserPermissions,Modulo,'CADCTADD') then
          Key := 0;
    end;

end;

procedure TfrmCadPessoas.dbgContatosKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46]) then
    Editado := True;
end;

procedure TfrmCadPessoas.dbgContatosCellClick(Column: TColumn);
var
  reg: Integer;
begin
  reg := sqlqContatos.RecNo;
  if Column.Index = 4 then
    begin
      case dbgContatos.Columns[3].Field.Text of
        'Celular': sqlqContatos.Fields.Fields[4].EditMask := '!\(##\) #.####-####;1;_';
        'Fone fixo': sqlqContatos.Fields.Fields[4].EditMask := '!\(##\) ####-####;1;_';
      else
        sqlqContatos.Fields.Fields[4].EditMask := '';
      end;
    end;

  //Carregar o PickList mais rápido
  if Column.PickList.Count > 0 then
    begin
     keybd_event(VK_F2,0,0,0);
     keybd_event(VK_F2,0,KEYEVENTF_KEYUP,0);
     keybd_event(VK_MENU,0,0,0);
     keybd_event(VK_DOWN,0,0,0);
     keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
     keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);
   end;

  if Column.Title.Caption = 'PREFERENCIAL' then
    begin
      if (sqlqContatos.RecordCount < 1) and
         (sqlqContatos.FieldByName('id_contato').IsNull) then
        Column.Field.Value := True
      else
      if (sqlqContatos.RecordCount = 1) and
         ((not sqlqContatos.FieldByName('id_contato').IsNull) or
         (sqlqContatos.FieldByName('id_contato').IsNull)) then
        Column.Field.Value := True
      else
        begin
          sqlqContatos.First;
          while not sqlqContatos.EOF do
            begin
                sqlqContatos.Edit;
                if reg = sqlqContatos.RecNo then
                  sqlqContatos.FieldByName('PREFERENCIAL').AsBoolean := True
                else
                  sqlqContatos.FieldByName('PREFERENCIAL').AsBoolean := false;
                sqlqContatos.Post;
              sqlqContatos.next;
            end;
          sqlqContatos.RecNo := reg;
          reg := 0;
        end;
    end;
end;

procedure TfrmCadPessoas.dbgContatosTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgContatos.Columns.Count - 1 do
    dbgContatos.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgContatos.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

procedure TfrmCadPessoas.dbgPessoasMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  mousePt: TGridcoord;
begin
  {mousePt := dbgPessoas.MouseCoord(x,y);
  if mousePt.y = 0 then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := crDefault; }
end;

procedure TfrmCadPessoas.dbgPessoasPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
var
  corPadrao: TColor;
begin
  with (Sender As TDBGrid) do
    begin
      corPadrao := Canvas.Brush.Color;
      if ((sqlqCadPessoas.FieldByName('dt_inicio_rest').Text <> EmptyStr)
          or (not sqlqCadPessoas.FieldByName('dt_inicio_rest').IsNull))then
        if ((sqlqCadPessoas.FieldByName('dt_fim_rest').Text <> EmptyStr)
            or (not sqlqCadPessoas.FieldByName('dt_fim_rest').IsNull))then
          Canvas.Brush.Color := RGBToColor(255,215,0)
        else
          Canvas.Brush.Color := RGBToColor(255,69,0)
      else
        Canvas.Brush.Color := corPadrao;
    end;
      {  begin
          Canvas.Brush.Color := CorLinha;
          Canvas.Font.Color := clBlack;
          Canvas.Font.Style := [fsBold];
        end
      else
        begin
          Canvas.Font.Color := clGrayText;
        end;}
end;

procedure TfrmCadPessoas.dbgPessoasTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgPessoas.Columns.Count - 1 do
    dbgPessoas.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgPessoas.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

procedure TfrmCadPessoas.FormShow(Sender: TObject);
var
  ID_Filtro_Padrao: String;
begin
  if not CheckPermission(UserPermissions,Modulo,'CADPSCAD') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  Editado := False;

  //Verifica se existe um filtro padrão
  SQLQuery(sqlqFiltro,['SELECT *'
                      ,'FROM g_filtros F'
                      ,'INNER JOIN g_filtros_usuarios U'
                             ,'ON U.id_filtro = F.id_filtro'
                      ,'WHERE F.modulo = '''+Modulo+''' AND F.formulario = '''+Formulario+''''
                             ,'AND U.padrao = ''1'' AND (F.id_usuario='''+gID_Usuario_Logado+''' OR F.global = true)']);

  ID_Filtro_Padrao := sqlqFiltro.FieldByName('id_filtro').Text;
  if ((pGERFILSEMP)
     or ((pGERFILNPDR) and (ID_Filtro_Padrao <> EmptyStr))) then
    begin
      frmExecutaFiltro := TfrmExecutaFiltro.Create(Nil);
      frmExecutaFiltro.ID_Filtro := ID_Filtro_Padrao;
      frmExecutaFiltro.Show;
    end
  else
    begin
      Filtro := '1<>1';
      sbtnAtualizar.Click;
      frmFiltros := TfrmFiltros.Create(Nil);
      frmFiltros.Modulo := Modulo;
      frmFiltros.Formulario := Formulario;
      frmFiltros.Show;
    end;
end;

procedure TfrmCadPessoas.gpbxContatosMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Y < 0 then
    begin
      if not ContatosAberto then
        begin
          gpbxContatos.Height := 160;
          gpbxContatos.Caption := '▲ Contatos';
          ContatosAberto := True;
          pnlCadastro.Height := pnlCadastro.Height+125;
        end
      else
        begin
          gpbxContatos.Height := 20;
          gpbxContatos.Caption := '▼ Contatos';
          ContatosAberto := False;
          pnlCadastro.Height := pnlCadastro.Height-125;
        end;
    end;
end;

procedure TfrmCadPessoas.gpbxContatosMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if gpbxContatos.Enabled and ContatosAberto then
    gpbxContatos.ShowHint := false
  else
    gpbxContatos.ShowHint := True;
end;

procedure TfrmCadPessoas.gpbxEnderecosMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Y < 0 then
    begin
      if not EnderecosAberto then
        begin
          gpbxEnderecos.Height := 160;
          gpbxContatos.Top := 280;
          gpbxEnderecos.Caption := '▲ Endereços';
          EnderecosAberto := True;
          pnlCadastro.Height := pnlCadastro.Height+125;
        end
      else
        begin
          gpbxEnderecos.Height := 20;
          gpbxContatos.Top := 140;
          gpbxEnderecos.Caption := '▼ Endereços';
          EnderecosAberto := False;
          pnlCadastro.Height := pnlCadastro.Height-125;
        end;
    end;
end;

procedure TfrmCadPessoas.gpbxEnderecosMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    if gpbxEnderecos.Enabled
       and EnderecosAberto then
    gpbxEnderecos.ShowHint := False
  else
    gpbxEnderecos.ShowHint := True;
end;

procedure TfrmCadPessoas.medtPessoaDataNasmentoKeyPress(Sender: TObject;
  var Key: char);
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;
end;

procedure TfrmCadPessoas.medtPessoaNumCPFKeyPress(Sender: TObject; var Key: char
  );
begin
  if Key IN (['0'..'9',#8,#46]) then
    Editado := True;
end;

procedure TfrmCadPessoas.ExecFiltro(Sender: TObject);
var
  IDFiltro, NomeObjeto: String;
begin
  //Extrai o ID do filtro do nome do SubMenu
  NomeObjeto := (Sender as TMenuItem).Name;
  IDFiltro := Copy(NomeObjeto,8,Length(NomeObjeto));

  //Executa o Filtro
  frmExecutaFiltro := TfrmExecutaFiltro.Create(Nil);
  frmExecutaFiltro.ID_Filtro := IDFiltro;
  frmExecutaFiltro.Show;
end;

procedure TfrmCadPessoas.ppmnFiltrosPopup(Sender: TObject);
var
  FiltrosGlobais, FiltrosPrivados, SubMenu: TMenuItem;
  i: integer;
  IDFiltro, NomeFiltro: String;
  Global: Boolean;
begin
  FiltrosGlobais := (Sender as TPopupMenu).Items.Items[3];
  FiltrosPrivados := (Sender as TPopupMenu).Items.Items[4];
  FiltrosGlobais.Clear;
  FiltrosPrivados.Clear;

  //Executa a consulta de filtros
  SQLQuery(sqlqFiltro,['SELECT *'
                      ,'FROM g_filtros'
                      ,'WHERE UPPER(modulo)='''+UPPERCASE(Modulo)+''' AND UPPER(formulario)='''+UPPERCASE(Formulario)+''' AND (id_usuario='''+gID_Usuario_Logado+''' OR global = true)'
                      ,'ORDER BY global DESC, filtro']);

  sqlqFiltro.First;
  while not sqlqFiltro.EOF do
    begin
      IDFiltro := sqlqFiltro.FieldByName('id_filtro').Text;
      NomeFiltro := sqlqFiltro.FieldByName('filtro').Text;
      Global := sqlqFiltro.FieldByName('global').AsBoolean;

      if Global then
        begin
          SubMenu := TMenuItem.Create(FiltrosGlobais);
          SubMenu.Caption := NomeFiltro;
          SubMenu.Name := 'Filtro_'+IDFiltro; //Insere o ID do filtro do nome do SubMenu
          SubMenu.OnClick := @ExecFiltro;
          FiltrosGlobais.Add(SubMenu);
        end
      else
        begin
          SubMenu := TMenuItem.Create(FiltrosPrivados);
          SubMenu.Caption := NomeFiltro;
          SubMenu.Name := 'Filtro_'+IDFiltro; //Insere o ID do filtro do nome do SubMenu
          SubMenu.OnClick := @ExecFiltro;
          FiltrosPrivados.Add(SubMenu);
        end;
      sqlqFiltro.Next;
    end;
end;

procedure TfrmCadPessoas.ppmniCadCEPsClick(Sender: TObject);
begin

end;

procedure TfrmCadPessoas.ppmniCadMunicipiosClick(Sender: TObject);
begin

end;

procedure TfrmCadPessoas.ppmniCadEstadosClick(Sender: TObject);
begin

end;

procedure TfrmCadPessoas.ppmniGerFiltrosClick(Sender: TObject);
begin
  frmFiltros := TfrmFiltros.Create(Nil);
  frmFiltros.Modulo := Modulo;
  frmFiltros.Formulario := Formulario;
  frmFiltros.Show;
end;

procedure TfrmCadPessoas.ppmniNovoFiltroClick(Sender: TObject);
begin
  frmEditorCadFiltros := TfrmEditorCadFiltros.Create(Nil);
  frmEditorCadFiltros.Modulo := Modulo;
  frmEditorCadFiltros.Formulario := Formulario;
  frmEditorCadFiltros.Show;
end;

procedure TfrmCadPessoas.sbtnAddPessoaClick(Sender: TObject);
begin
  if Acao <> EmptyStr then
    sbtnCancelar.Click;

  Acao := 'ADICIONAR';

  pnlCadastro.Height := 230;
  if EnderecosAberto then
    pnlCadastro.Height := pnlCadastro.Height+125;
  if ContatosAberto then
    pnlCadastro.Height := pnlCadastro.Height+125;

  ID_Pessoa := EmptyStr;
  gpbxEnderecos.Enabled := False;
  gpbxContatos.Enabled := False;
  sbtnGerFotos.Enabled := False;
  ID_Pessoa := EmptyStr;
  Clean([edtPessoaID,edtPessoaNome,edtPessoaNumRG,edtPessoaOrgaoExpRG,medtPessoaNumCPF,medtPessoaDataNasmento]);
  imgFoto.Picture.Clear;
  //sqlqCadPessoas.Clear;
  sqlqContatos.Clear;
  sqlqEnderecos.Clear;
end;

procedure TfrmCadPessoas.sbtnAtualizarClick(Sender: TObject);
begin
  try
    dsCadPessoas.Enabled := False;
    SQLQuery(sqlqCadPessoas,['SELECT DISTINCT P.id_pessoa'
                            ,', P.nome'
                            ,', P.rg ||'' ''|| P.rg_org_exped RG'
                            ,', P.cpf'
                            ,', strftime(''%d/%m/%Y'',P.dt_nasc) dt_nascimento'
                            ,', P.rg num_rg'
                            ,', P.rg_org_exped'
                            ,', F.foto'
                            ,', E.tipo_endereco'
                            ,', E.tipo_logradouro'
                            ,', E.logradouro'
                            ,', E.numero'
                            ,', E.bairro'
                            ,', E.referencia'
                            ,', E.cep'
                            ,', M.municipio'
                            ,', U.uf'
                            ,', C.tipo_contato'
                            ,', C.meio_contato'
                            ,', C.contato'
                            ,', C.nome_contato_terceiro'
                            ,', K.cracha'
                            ,', (CASE K.cod_vinculo WHEN ''F'' THEN ''Funcionário'' WHEN ''T'' THEN ''Terceiro'' WHEN ''V'' THEN ''Visitante'' END) Vinculo'
                            ,', K.cod_empresa'
                            ,', G.fantasia'
                            ,', K.cod_setor'
                            ,', S.Setor'
                            ,', K.cod_funcao'
                            ,', J.funcao'
                            ,', K.cod_centro_custo'
                            ,', O.centro_custo'
                            ,', (SELECT MAX(R.dt_inicio) FROM p_restricoes R WHERE R.id_pessoa = P.id_pessoa) dt_inicio_rest'
                            ,', (SELECT R.dt_fim FROM p_restricoes R WHERE R.id_pessoa = P.id_pessoa AND R.dt_inicio = (SELECT MAX(R.dt_inicio) FROM p_restricoes R WHERE R.id_pessoa = P.id_pessoa)) dt_fim_rest'
                            ,'FROM p_pessoas P'
                            ,'LEFT JOIN p_fotos F ON F.id_pessoa = P.id_pessoa AND F.status = true'
                            ,'LEFT JOIN p_endereco E ON E.id_pessoa = P.id_pessoa AND E.preferencial = true'
                            ,'LEFT JOIN g_municipios M ON M.cod_munic_ibge = E.mun_cod_ibge'
                            ,'LEFT JOIN g_estados U ON U.cod_uf_ibge = E.uf_cod_ibge'
                            ,'LEFT JOIN p_contato C ON C.id_pessoa = P.id_pessoa AND C.preferencial = true'
                            ,'LEFT JOIN p_cracha K ON K.id_pessoa = P.id_pessoa AND K.status = true AND K.dt_fim IS NULL'
                            ,'LEFT JOIN g_empresas G ON G.cod_empresa = K.cod_empresa'
                            ,'LEFT JOIN g_setores S ON S.cod_empresa = K.cod_empresa AND S.cod_setor = K.cod_setor AND S.dt_inicio >= K.dt_inicio AND (S.dt_fim <= K.dt_inicio OR S.dt_fim IS NULL)'
                            ,'LEFT JOIN p_funcoes J ON J.cod_funcao = K.cod_funcao AND J.cod_empresa = K.cod_empresa AND J.dt_inicio >= K.dt_inicio AND (J.dt_fim <= K.dt_inicio OR J.dt_fim IS NULL)'
                            ,'LEFT JOIN g_centros_custo O ON O.cod_centro_custo = K.cod_centro_custo AND O.cod_empresa = K.cod_empresa AND O.dt_inicio >= K.dt_inicio AND (O.dt_fim <= K.dt_inicio OR O.dt_fim IS NULL)'
                            ,'WHERE P.excluido = false AND '+Filtro
                            ,'ORDER BY P.nome']);
    dsCadPessoas.Enabled := True;

    dbgPessoas.Columns[0].FieldName:='id_pessoa';
    dbgPessoas.Columns[0].Title.Caption:='ID';
    dbgPessoas.Columns[0].Width := 50;
    dbgPessoas.Columns[1].FieldName:='nome';
    dbgPessoas.Columns[1].Title.Caption:='NOME';
    dbgPessoas.Columns[1].Width := 225;
    dbgPessoas.Columns[2].FieldName:='RG';
    dbgPessoas.Columns[2].Title.Caption:='RG';
    dbgPessoas.Columns[2].Width := 100;
    dbgPessoas.Columns[3].FieldName:='cpf';
    dbgPessoas.Columns[3].Title.Caption:='CPF';
    dbgPessoas.Columns[3].Width := 90;
    dbgPessoas.Columns[4].FieldName:='dt_nascimento';
    dbgPessoas.Columns[4].Title.Caption:='DT NASCIMENTO';
    dbgPessoas.Columns[4].Width := 100;
    dbgPessoas.Columns[5].Visible := False;
    dbgPessoas.Columns[6].Visible := False;
    dbgPessoas.Columns[7].Visible := False;
    dbgPessoas.Columns[8].FieldName:='tipo_endereco';
    dbgPessoas.Columns[8].Title.Caption := 'TIPO ENDEREÇO';
    dbgPessoas.Columns[8].Width := 95;
    dbgPessoas.Columns[8].Visible := False;
    dbgPessoas.Columns[9].FieldName:='tipo_logradouro';
    dbgPessoas.Columns[9].Title.Caption := 'TIPO LOCAL ENDEREÇO';
    dbgPessoas.Columns[9].Width := 98;
    dbgPessoas.Columns[9].Visible := False;
    dbgPessoas.Columns[10].FieldName:='logradouro';
    dbgPessoas.Columns[10].Title.Caption := 'ENDEREÇO';
    dbgPessoas.Columns[10].Width := 250;
    dbgPessoas.Columns[10].Visible := False;
    dbgPessoas.Columns[11].FieldName:='numero';
    dbgPessoas.Columns[11].Title.Caption := 'NÚMERO';
    dbgPessoas.Columns[11].Width := 80;
    dbgPessoas.Columns[11].Visible := False;
    dbgPessoas.Columns[12].FieldName:='bairro';
    dbgPessoas.Columns[12].Title.Caption := 'BAIRRO';
    dbgPessoas.Columns[12].Width := 150;
    dbgPessoas.Columns[12].Visible := False;
    dbgPessoas.Columns[13].FieldName:='referencia';
    dbgPessoas.Columns[13].Title.Caption := 'REFERÊNCIA';
    dbgPessoas.Columns[13].Width := 150;
    dbgPessoas.Columns[13].Visible := False;
    dbgPessoas.Columns[14].FieldName:='cep';
    dbgPessoas.Columns[14].Title.Caption := 'CEP';
    dbgPessoas.Columns[14].Width := 60;
    dbgPessoas.Columns[14].Visible := False;
    dbgPessoas.Columns[15].FieldName:='municipio';
    dbgPessoas.Columns[15].Title.Caption := 'MUNICÍPIO';
    dbgPessoas.Columns[15].Width := 220;
    dbgPessoas.Columns[15].Visible := False;
    dbgPessoas.Columns[16].FieldName := 'UF';
    dbgPessoas.Columns[16].Title.Caption := 'UF';
    dbgPessoas.Columns[16].Width := 75;
    dbgPessoas.Columns[16].Visible := False;
    dbgPessoas.Columns[17].FieldName:='tipo_contato';
    dbgPessoas.Columns[17].Title.Caption := 'TIPO CONTATO';
    dbgPessoas.Columns[17].Width := 93;
    dbgPessoas.Columns[17].Visible := False;
    dbgPessoas.Columns[18].FieldName:='meio_contato';
    dbgPessoas.Columns[18].Title.Caption := 'MEIO CONTATO';
    dbgPessoas.Columns[18].Width := 93;
    dbgPessoas.Columns[18].Visible := False;
    dbgPessoas.Columns[19].FieldName:='contato';
    dbgPessoas.Columns[19].Title.Caption := 'CONTATO';
    dbgPessoas.Columns[19].Width := 250;
    dbgPessoas.Columns[19].Visible := False;
    dbgPessoas.Columns[20].FieldName:='nome_contato_terceiro';
    dbgPessoas.Columns[20].Title.Caption := 'NOME CONTATO';
    dbgPessoas.Columns[20].Width := 200;
    dbgPessoas.Columns[20].Visible := False;
    dbgPessoas.Columns[21].FieldName:='cracha';
    dbgPessoas.Columns[21].Title.Caption := 'CRACHÁ';
    dbgPessoas.Columns[21].Width := 50;
    dbgPessoas.Columns[21].Visible := False;
    dbgPessoas.Columns[22].FieldName:='vinculo';
    dbgPessoas.Columns[22].Title.Caption := 'VÍNCULO';
    dbgPessoas.Columns[22].Width := 80;
    dbgPessoas.Columns[22].Visible := False;
    dbgPessoas.Columns[23].FieldName:='cod_empresa';
    dbgPessoas.Columns[23].Title.Caption := 'CÓD. EMPRESA';
    dbgPessoas.Columns[23].Width := 50;
    dbgPessoas.Columns[23].Visible := False;
    dbgPessoas.Columns[24].FieldName:='fantasia';
    dbgPessoas.Columns[24].Title.Caption := 'EMPRESA';
    dbgPessoas.Columns[24].Width := 150;
    dbgPessoas.Columns[24].Visible := False;
    dbgPessoas.Columns[25].FieldName:='cod_setor';
    dbgPessoas.Columns[25].Title.Caption := 'CÓD. SETOR';
    dbgPessoas.Columns[25].Width := 50;
    dbgPessoas.Columns[25].Visible := False;
    dbgPessoas.Columns[26].FieldName:='setor';
    dbgPessoas.Columns[26].Title.Caption := 'SETOR';
    dbgPessoas.Columns[26].Width := 150;
    dbgPessoas.Columns[26].Visible := False;
    dbgPessoas.Columns[27].FieldName:='cod_funcao';
    dbgPessoas.Columns[27].Title.Caption := 'CÓD. FUNÇÃO';
    dbgPessoas.Columns[27].Width := 50;
    dbgPessoas.Columns[27].Visible := False;
    dbgPessoas.Columns[28].FieldName:='funcao';
    dbgPessoas.Columns[28].Title.Caption := 'FUNÇÃO';
    dbgPessoas.Columns[28].Width := 150;
    dbgPessoas.Columns[28].Visible := False;
    dbgPessoas.Columns[29].FieldName:='cod_centro_custo';
    dbgPessoas.Columns[29].Title.Caption := 'CÓD. C. CUSTO';
    dbgPessoas.Columns[29].Width := 50;
    dbgPessoas.Columns[29].Visible := False;
    dbgPessoas.Columns[30].FieldName:='centro_custo';
    dbgPessoas.Columns[30].Title.Caption := 'CENTRO DE CUSTO';
    dbgPessoas.Columns[30].Width := 150;
    dbgPessoas.Columns[30].Visible := False;
    dbgPessoas.Columns[31].Visible := False;
    dbgPessoas.Columns[32].Visible := False;

    if CheckPermission(UserPermissions,Modulo,'CADEDCAD') then
      begin
        dbgPessoas.Columns[8].Visible := True;
        dbgPessoas.Columns[9].Visible := True;
        dbgPessoas.Columns[10].Visible := True;
        dbgPessoas.Columns[11].Visible := True;
        dbgPessoas.Columns[12].Visible := True;
        dbgPessoas.Columns[13].Visible := True;
        dbgPessoas.Columns[14].Visible := True;
        dbgPessoas.Columns[15].Visible := True;
        dbgPessoas.Columns[16].Visible := True;
      end;
    {else
      begin
        dbgPessoas.Columns[8].Visible := False;
        dbgPessoas.Columns[9].Visible := False;
        dbgPessoas.Columns[10].Visible := False;
        dbgPessoas.Columns[11].Visible := False;
        dbgPessoas.Columns[12].Visible := False;
        dbgPessoas.Columns[13].Visible := False;
        dbgPessoas.Columns[14].Visible := False;
        dbgPessoas.Columns[15].Visible := False;
        dbgPessoas.Columns[16].Visible := False;
      end; }

    if CheckPermission(UserPermissions,Modulo,'CADCTCAD') then
      begin
        dbgPessoas.Columns[17].Visible := True;
        dbgPessoas.Columns[18].Visible := True;
        dbgPessoas.Columns[19].Visible := True;
        dbgPessoas.Columns[20].Visible := True;
      end;
    {else
      begin
        dbgPessoas.Columns[17].Visible := False;
        dbgPessoas.Columns[18].Visible := False;
        dbgPessoas.Columns[19].Visible := False;
        dbgPessoas.Columns[20].Visible := False;
      end;}

    if CheckPermission(UserPermissions,Modulo,'CADFUCAD') or
       CheckPermission(UserPermissions,Modulo,'CADTCCAD') or
       CheckPermission(UserPermissions,Modulo,'CADVSCAD') then
      begin
        dbgPessoas.Columns[21].Visible := True;
        dbgPessoas.Columns[22].Visible := True;
        dbgPessoas.Columns[23].Visible := True;
        dbgPessoas.Columns[24].Visible := True;
        dbgPessoas.Columns[25].Visible := True;
        dbgPessoas.Columns[26].Visible := True;
        dbgPessoas.Columns[27].Visible := True;
        dbgPessoas.Columns[28].Visible := True;
        dbgPessoas.Columns[29].Visible := True;
        dbgPessoas.Columns[30].Visible := True;
      end;
    {else
      begin
        dbgPessoas.Columns[21].Visible := False;
        dbgPessoas.Columns[22].Visible := False;
        dbgPessoas.Columns[23].Visible := False;
        dbgPessoas.Columns[24].Visible := False;
        dbgPessoas.Columns[25].Visible := False;
        dbgPessoas.Columns[26].Visible := False;
        dbgPessoas.Columns[27].Visible := False;
        dbgPessoas.Columns[28].Visible := False;
        dbgPessoas.Columns[29].Visible := False;
        dbgPessoas.Columns[30].Visible := False;
      end; }

  except on E: exception do
    begin
      sqlqCadPessoas.Free;
      dsCadPessoas.Free;
      sqlqEnderecos.Free;
      dsEnderecos.Free;
      sqlqContatos.Free;
      dsContatos.Free;
      Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
end;

procedure TfrmCadPessoas.sbtnCadastrosClick(Sender: TObject);
var
  APoint: TPoint;
begin
  APoint.x := 0;
  APoint.y := 0;
  APoint := bcbtnCadastros.ClientToScreen(APoint);
  bcbtnCadastros.DropdownMenu.PopUp(APoint.X,APoint.Y+bcbtnCadastros.Height);
end;

procedure TfrmCadPessoas.sbtnCancelarClick(Sender: TObject);
begin
  if Editado then
    begin
      if Application.MessageBox(Pchar('Cancelar a edição?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          Acao := EmptyStr;
          Editado := False;
          ID_Pessoa := EmptyStr;
          Clean([edtPessoaID,edtPessoaNome,edtPessoaNumRG,edtPessoaOrgaoExpRG,medtPessoaNumCPF,medtPessoaDataNasmento]);
          imgFoto.Picture.Clear;
          //sqlqEnderecos.Cancel;
          //sqlqEnderecos.Close;
          //sqlqContatos.Cancel;
          //sqlqContatos.Close;
          pnlCadastro.Height := 0;
          gpbxEnderecos.Height := 20;
          EnderecosAberto := False;
          gpbxContatos.Height := 20;
          gpbxEnderecos.Top := 110;
          gpbxContatos.Top := 140;
          ContatosAberto := False;
        end
      else
        Abort;
    end
  else
    begin
      Clean([edtPessoaID,edtPessoaNome,edtPessoaNumRG,edtPessoaOrgaoExpRG,medtPessoaNumCPF,medtPessoaDataNasmento]);
      imgFoto.Picture.Clear;
      sqlqEnderecos.Cancel;
      sqlqEnderecos.Close;
      sqlqContatos.Cancel;
      sqlqContatos.Close;
      pnlCadastro.Height := 0;
      gpbxEnderecos.Height := 20;
      EnderecosAberto := False;
      gpbxContatos.Height := 20;
      gpbxEnderecos.Top := 110;
      gpbxContatos.Top := 140;
      ContatosAberto := False;
      {if Application.MessageBox(PChar('Deseja sair do cadastro?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
        Self.Close
      else
        Abort;}
    end;
end;

procedure TfrmCadPessoas.sbtnEditarPessoaClick(Sender: TObject);
var
  i: Integer;
begin
  try
    if Acao <> EmptyStr then
      sbtnCancelar.Click;

    if dbgPessoas.SelectedRows.Count > 0 then
      begin
        Application.MessageBox(PChar('Selecione um cadastro para edição'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    Acao := 'EDITAR';
    //Redimensiona o painel para carregar as opções de edição
    pnlCadastro.Height := 230;
    if EnderecosAberto then
      pnlCadastro.Height := pnlCadastro.Height+125;
    if ContatosAberto then
      pnlCadastro.Height := pnlCadastro.Height+125;

    //Carrega os dados pessoais nos campos para edição
    edtPessoaNome.Enabled := True;
    medtPessoaDataNasmento.Enabled := True;
    medtPessoaNumCPF.Enabled := True;
    edtPessoaNumRG.Enabled := True;
    edtPessoaOrgaoExpRG.Enabled := True;
    ID_Pessoa := dbgPessoas.Columns.Items[0].Field.Text;
    edtPessoaID.Text := dbgPessoas.Columns.Items[0].Field.Text;
    edtPessoaNome.Text := dbgPessoas.Columns.Items[1].Field.Text;
    medtPessoaNumCPF.Text := dbgPessoas.Columns.Items[3].Field.Text;
    medtPessoaDataNasmento.Text := dbgPessoas.Columns.Items[4].Field.Text;
    edtPessoaNumRG.Text := dbgPessoas.Columns.Items[5].Field.Text;
    edtPessoaOrgaoExpRG.Text := dbgPessoas.Columns.Items[6].Field.Text;
    imgFoto.Picture.Clear;
    LoadImage(sqlqCadPessoas.Fields[7],imgFoto);

    CarregarEnderecoContato;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          sqlqCadPessoas.Free;
          dsCadPessoas.Free;
          sqlqEnderecos.Free;
          dsEnderecos.Free;
          sqlqContatos.Free;
          dsContatos.Free;
          Application.MessageBox(Pchar('Falha ao tentar carregar os dados para edição'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmCadPessoas.sbtnExcluirPessoaClick(Sender: TObject);
var
  ID_Pessoa_sel, Nome_Pessoa_sel: String;
  Verif_Vinculos: Integer;
begin
  if not CheckPermission(UserPermissions,Modulo,'CADPSDEL') then
    begin
      Application.MessageBox(PChar('Você não possui permissão para excluir cadastros'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;

  if Acao <> EmptyStr then
    sbtnCancelar.Click;

  if dbgPessoas.SelectedRows.Count > 0 then
    begin
      Application.MessageBox(PChar('Selecione um cadastro para exclusão'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;
  ID_Pessoa_sel := dbgPessoas.Columns.Items[dbgPessoas.Columns.ColumnByFieldname('id_pessoa').Index].Field.Text; //dbgPessoas.Columns.Items[0].Field.Text;
  Nome_Pessoa_sel := dbgPessoas.Columns.Items[dbgPessoas.Columns.ColumnByFieldname('nome').Index].Field.Text;//dbgPessoas.Columns.Items[1].Field.Text;

  if Application.MessageBox(PChar('Deseja realmente excluir o cadastro de '''+Nome_Pessoa_sel+''' e apagar todas as suas informações?'+#13+#13+
                                  '*Este é um processo irreversível que poderá implicar em outros módulos'+#13+#13+
                                  'Confirmar a exclusão?'), 'Confirmar', MB_ICONQUESTION + MB_YESNO) = MRYES then
    begin
      try
        try
          //Verifica se existem operações atreladas a pessoa sendo excluída
          SQLQuery(sqlqPessoasOperacoes,['SELECT count(C.id_pessoa) reg',
                                         'FROM p_cracha C',
                                         'INNER JOIN r_reg_refeicoes R ON R.cracha = C.cracha',
                                         'WHERE C.id_pessoa = '+ID_Pessoa_sel],'reg');
          Verif_Vinculos := sqlqPessoasOperacoes.FieldByName('reg').AsInteger;

          if Verif_Vinculos = 0 then
            begin
              SQLExec(sqlqPessoasOperacoes,['DELETE FROM p_contato',
                                            'WHERE id_pessoa = '+ID_Pessoa_sel]);
              SQLExec(sqlqPessoasOperacoes,['DELETE FROM p_endereco',
                                            'WHERE id_pessoa = '+ID_Pessoa_sel]);
              SQLExec(sqlqPessoasOperacoes,['DELETE FROM p_fotos',
                                            'WHERE id_pessoa = '+ID_Pessoa_sel]);
              SQLExec(sqlqPessoasOperacoes,['DELETE FROM p_cracha',
                                            'WHERE id_pessoa = '+ID_Pessoa_sel]);
              SQLExec(sqlqPessoasOperacoes,['DELETE FROM p_pessoas',
                                            'WHERE id_pessoa = '+ID_Pessoa_sel]);
            end
          else
            begin
              SQLExec(sqlqPessoasOperacoes,['UPDATE p_cracha SET',
                                            'status = false',
                                            'WHERE id_pessoa = '+ID_Pessoa_sel]);
              SQLExec(sqlqPessoasOperacoes,['UPDATE p_pessoas SET',
                                            'excluido = true',
                                            'WHERE id_pessoa = '+ID_Pessoa_sel]);
            end;
          Log(LowerCase(Modulo),'pessoas','deletar pessoa',ID_Pessoa_sel,gID_Usuario_Logado,gUsuario_Logado,'<<o cadastro de pessoa de '+Nome_Pessoa_sel+' foi deletado>>');
        finally
          sbtnAtualizar.Click;
          Application.MessageBox(PChar('O cadastro de '''+Nome_Pessoa_sel+''' e todas as suas informações foram excluídas com sucesso!'), 'Aviso', MB_ICONINFORMATION + MB_OK);
          ID_Pessoa_sel := EmptyStr;
          Nome_Pessoa_sel := EmptyStr;
        end;
      except on E: exception do
        begin
          Application.MessageBox(PChar('Falha ao tentar excluir o cadastro de '''+Nome_Pessoa_sel+''''+#13#13+
                                       'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Exit;
        end;
      end;
    end
  else
    Exit;
end;

procedure TfrmCadPessoas.sbtnGerFiltrosClick(Sender: TObject);
begin
  if ID_Filtro_Selecionado <> EmptyStr then
    begin
      frmExecutaFiltro := TfrmExecutaFiltro.Create(Nil);
      frmExecutaFiltro.ID_Filtro := ID_Filtro_Selecionado;
      frmExecutaFiltro.Show;
    end
  else
    begin
      frmFiltros := TfrmFiltros.Create(Nil);
      frmFiltros.Modulo := Modulo;
      frmFiltros.Formulario := Formulario;
      frmFiltros.Show;
    end;
end;

procedure TfrmCadPessoas.sbtnGerFotosClick(Sender: TObject);
begin
  //OpenForm(TfrmGerencFotos,'Modal');
  frmGerencFotos := TfrmGerencFotos.Create(Self);
  frmGerencFotos.formPai := Self.Name;
  frmGerencFotos.ID_Pessoa := dbgPessoas.DataSource.DataSet.FieldByName('id_pessoa').Text;
  OpenWindowTab(frmPrincipal.PageControl,frmGerencFotos,['TabTitle: Gerenciador de fotos ['+dbgPessoas.DataSource.DataSet.FieldByName('NOME').Text+']']);
  //frmGerencFotos.ShowModal;
end;

procedure TfrmCadPessoas.sbtnRestricoesClick(Sender: TObject);
begin
  if ((edtPessoaID.Text = EmptyStr) and (dbgPessoas.SelectedRows.Count > 0)) then
    begin
      Application.MessageBox(PChar('Selecione um cadastro para gerenciar as restrições'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;

  if edtPessoaID.Text <> EmptyStr then
    gID_Pessoa := edtPessoaID.Text
  else
    gID_Pessoa := dbgPessoas.Columns.Items[0].Field.Text;

  gTipo_Vinculo := EmptyStr;

  frmRestricaoAcesso := TfrmRestricaoAcesso.Create(Self);
  //frmRestricaoAcesso.formPai := Self.Name;
  OpenWindowTab(frmPrincipal.PageControl,frmRestricaoAcesso,['TabTitle: Gerenciar restrições de ['+dbgPessoas.DataSource.DataSet.FieldByName('NOME').Text+']']);
end;

procedure TfrmCadPessoas.sbtnSalvarClick(Sender: TObject);
var
  Nome_Pessoa: String;
begin
  if edtPessoaNome.Text = EmptyStr then
    begin
      Application.MessageBox('Informe o nome','Aviso', MB_ICONWARNING + MB_OK);
      edtPessoaNome.SetFocus;
      Exit;
    end;
  if (medtPessoaDataNasmento.Text <> '  /  /    ') and (not TryStrToDate(medtPessoaDataNasmento.Text)) then
    begin
      Application.MessageBox('Data de nascimento inválida','Aviso', MB_ICONWARNING + MB_OK);
      medtPessoaDataNasmento.SetFocus;
      Exit;
    end;

  if (medtPessoaNumCPF.Text = EmptyStr) or (medtPessoaNumCPF.Text = '   .   .   -  ') then
    begin
      Application.MessageBox('Informe o CPF','Aviso', MB_ICONWARNING + MB_OK);
      medtPessoaNumCPF.SetFocus;
      Exit;
    end;
  if not ValidarCPF(medtPessoaNumCPF.Text) then
    begin
      Application.MessageBox('CPF inválido','Aviso', MB_ICONWARNING + MB_OK);
      medtPessoaNumCPF.SetFocus;
      Exit;
    end;

  //Verifica se o número do CPF já está está cadastrado para outro pessoa
  SQLQuery(sqlqPessoasOperacoes,['SELECT id_pessoa, nome, cpf',
                                 'FROM p_pessoas',
                                 'WHERE cpf = '''+medtPessoaNumCPF.Text+'''',
                                       'AND excluido = false']);
  if ((ID_Pessoa <> sqlqPessoasOperacoes.Fields[0].AsString) and
      (CompareText(sqlqPessoasOperacoes.Fields[2].AsString, medtPessoaNumCPF.Text) = 0)) then
    begin
      Application.MessageBox(PChar('O CPF '+medtPessoaNumCPF.Text+' já está cadastrado para '+
                                   sqlqPessoasOperacoes.Fields[1].AsString+' no registro nº '+sqlqPessoasOperacoes.Fields[0].AsString),'Aviso', MB_ICONWARNING + MB_OK);
      medtPessoaNumCPF.SetFocus;
      Exit;
    end;

  if Acao = 'ADICIONAR' then
    begin
      SQLExec(sqlqPessoasOperacoes,['INSERT INTO p_pessoas (nome, dt_nasc, cpf, rg, rg_org_exped, excluido)',
                                     'VALUES ('''+edtPessoaNome.Text+''','''+FormatDateTime('YYYY-mm-dd',StrToDate(medtPessoaDataNasmento.Text))+''',',
                                     ''''+medtPessoaNumCPF.Text+''','''+edtPessoaNumRG.Text+''','''+edtPessoaOrgaoExpRG.Text+''',false)']);

      if CheckPermission(UserPermissions,Modulo,'CADEDCAD') then
        begin
          pnlCadastro.Height := pnlCadastro.Height+125;
          gpbxEnderecos.Enabled := True;
          gpbxEnderecos.Height := 160;
          gpbxContatos.Top := 279;
          dbgEnderecos.SetFocus;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADCTCAD') then
        begin
          pnlCadastro.Height := pnlCadastro.Height+125;
          gpbxContatos.Enabled := True;
          gpbxContatos.Height := 160;
        end;

      if CheckPermission(UserPermissions,Modulo,'CADFTCAD') then
        sbtnGerFotos.Enabled := True;

      SQLQuery(sqlqPessoasOperacoes,['SELECT id_pessoa, nome FROM p_pessoas WHERE cpf = '''+medtPessoaNumCPF.Text+''' AND excluido = false']);
      ID_Pessoa := sqlqPessoasOperacoes.FieldByName('id_pessoa').Text;
      Nome_Pessoa := sqlqPessoasOperacoes.FieldByName('nome').Text;
      Acao := 'EDITAR';
      Editado := False;
      edtPessoaID.Text := ID_Pessoa;
      edtPessoaNome.Enabled := False;
      medtPessoaDataNasmento.Enabled := False;
      medtPessoaNumCPF.Enabled := False;
      edtPessoaNumRG.Enabled := False;
      edtPessoaOrgaoExpRG.Enabled := False;
      CarregarEnderecoContato;

      Log(LowerCase(Modulo),'pessoas','cadastrar pessoa',ID_Pessoa,gID_Usuario_Logado,gUsuario_Logado,'<<pessoa '+Nome_Pessoa+' cadastrada>>');
      Application.MessageBox(PChar('Cadastro salvo com sucesso!'),'Aviso', MB_ICONINFORMATION + MB_OK);
      sbtnAtualizar.Click;
    end;

  if Acao = 'EDITAR' then
    begin
      SQLExec(sqlqPessoasOperacoes,['UPDATE p_pessoas SET',
                                    'nome = '''+edtPessoaNome.Text+''', dt_nasc = '''+FormatDateTime('YYYY-mm-dd',StrToDate(medtPessoaDataNasmento.Text))+''',',
                                    'cpf = '''+medtPessoaNumCPF.Text+''', rg = '''+edtPessoaNumRG.Text+''', rg_org_exped = '''+edtPessoaOrgaoExpRG.Text+'''',
                                    'WHERE id_pessoa = '''+ID_Pessoa+'''']);


      Acao := EmptyStr;
      Editado := False;
      edtPessoaNome.Enabled := False;
      medtPessoaDataNasmento.Enabled := False;
      medtPessoaNumCPF.Enabled := False;
      edtPessoaNumRG.Enabled := False;
      edtPessoaOrgaoExpRG.Enabled := False;

      {if dbnEnderecos.Controls[7].Enabled then
        dbnEnderecos.DataSource.DataSet.Post;

      if dbgContatos.Controls[7].Enabled then
        dbnEnderecos.DataSource.DataSet.Post; }

      Log(LowerCase(Modulo),'pessoas','editar pessoa',ID_Pessoa,gID_Usuario_Logado,gUsuario_Logado,'<<cadastro pessoa '+edtPessoaNome.Text+' editado>>');
      Application.MessageBox(PChar('Cadastro atualizado com sucesso!'),'Aviso', MB_ICONINFORMATION + MB_OK);
      sbtnAtualizar.Click;
    end;
end;

procedure TfrmCadPessoas.CarregarEnderecoContato;
var
  i: Integer;
begin
  try
    if CheckPermission(UserPermissions,Modulo,'CADEDCAD') then
      begin
        gpbxEnderecos.Enabled := True;
        //Carrega tabelas auxiliares
        //CEPs
        SQLQuery(sqlqConsCEP,['SELECT cep, cod_munic_ibge, cod_uf_ibge',
                              'FROM g_cep',
                              'ORDER BY cep']);
        //Tipos logradouros
        SQLQuery(sqlqTiposLogradouros,['SELECT cod_tipo, tipo_logradouro',
                                       'FROM g_tipos_logradouros',
                                       'ORDER BY tipo_logradouro']);
        //Municipios
        SQLQuery(sqlqConsMunicipios,['SELECT cod_munic_ibge, cod_uf_ibge, municipio',
                                       'FROM g_municipios',
                                       'ORDER BY municipio']);
        //Estados
        SQLQuery(sqlqConsUF,['SELECT cod_uf_ibge, estado, uf',
                                       'FROM g_estados',
                                       'ORDER BY estado']);

        //Carrega os endereços para edição
        SQLQuery(sqlqEnderecos,['SELECT id_endereco, id_pessoa, tipo_endereco, tipo_logradouro,',
                                'logradouro, numero, bairro, referencia, cep,',
                                'uf_cod_ibge, uf, mun_cod_ibge, municipio, complemento, preferencial',
                                'FROM p_endereco',
                                'WHERE id_pessoa = '''+ID_Pessoa+'''']);
        dbgEnderecos.Columns[0].Visible := False;
        dbgEnderecos.Columns[1].Visible := False;

        dbgEnderecos.Columns[2].Title.Caption := 'TIPO ENDEREÇO';
        dbgEnderecos.Columns[2].ButtonStyle := cbsPickList;
        dbgEnderecos.Columns[2].PickList.AddStrings(['Residencial','Comercial']);
        dbgEnderecos.Columns[2].Width := 95;

        //Carrega a lista de tipos de logradouros
        dbgEnderecos.Columns[3].Title.Caption := 'TIPO LOCAL ENDEREÇO';
        dbgEnderecos.Columns[3].ButtonStyle := cbsPickList;
        dbgEnderecos.Columns[3].Width := 98;
        sqlqTiposLogradouros.First;
        while not sqlqTiposLogradouros.eof do
          begin
            dbgEnderecos.Columns[3].PickList.Add(sqlqTiposLogradouros.Fields[1].AsString);
            sqlqTiposLogradouros.next;
          end;
        
        dbgEnderecos.Columns[4].Title.Caption := 'ENDEREÇO';
        dbgEnderecos.Columns[4].Width := 250;

        dbgEnderecos.Columns[5].Title.Caption := 'NÚMERO';
        dbgEnderecos.Columns[5].Width := 80;

        dbgEnderecos.Columns[6].Title.Caption := 'BAIRRO';
        dbgEnderecos.Columns[6].Width := 150;

        dbgEnderecos.Columns[7].Title.Caption := 'REFERÊNCIA';
        dbgEnderecos.Columns[7].Width := 150;

        //Carrega a lista de CEPs
        dbgEnderecos.Columns[8].Title.Caption := 'CEP';
        dbgEnderecos.Columns[8].Width := 60;
        dbgEnderecos.Columns[8].ButtonStyle := cbsPickList;
        sqlqConsCEP.First;
        while not sqlqConsCEP.eof do
          begin
            dbgEnderecos.Columns[8].PickList.Add(sqlqConsCEP.Fields[0].AsString);
            sqlqConsCEP.next;
          end;

        dbgEnderecos.Columns[9].Visible := False;
        dbgEnderecos.Columns[10].Title.Caption := 'UF';
        dbgEnderecos.Columns[10].Width := 75;
        dbgEnderecos.Columns.Items[10].Field.FieldName := 'UF';

        //Carrega a lista de estados
        dbgEnderecos.Columns[10].ButtonStyle := cbsPickList;
        sqlqConsUF.First;
        while not sqlqConsUF.eof do
          begin
            dbgEnderecos.Columns[10].PickList.Add(sqlqConsUF.Fields[2].AsString+' ['+sqlqConsUF.Fields[0].AsString+']');
            sqlqConsUF.next;
          end;
        dbgEnderecos.Columns[11].Visible := False;
        dbgEnderecos.Columns[12].Width := 220;
        //Carrega a lista de municípios
        dbgEnderecos.Columns[12].ButtonStyle := cbsPickList;
        sqlqConsMunicipios.First;
        while not sqlqConsMunicipios.eof do
          begin
            dbgEnderecos.Columns[12].PickList.Add(sqlqConsMunicipios.Fields[2].AsString+' ['+sqlqConsMunicipios.Fields[0].AsString+']');
            sqlqConsMunicipios.next;
          end;

        dbgEnderecos.Columns[13].Width := 250;

        dbgEnderecos.Columns[14].Width := 90;
      end;

    if CheckPermission(UserPermissions,Modulo,'CADCTCAD') then
      begin
        gpbxContatos.Enabled := True;
        //Carrega os contatos para edição
        SQLQuery(sqlqContatos,['SELECT id_contato, id_pessoa, tipo_contato, meio_contato,',
                               'contato, nome_contato_terceiro, preferencial',
                               'FROM p_contato',
                               'WHERE id_pessoa = '''+ID_Pessoa+'''']);
        dbgContatos.Columns[0].Visible := False;
        dbgContatos.Columns[1].Visible := False;

        dbgContatos.Columns[2].Title.Caption := 'TIPO CONTATO';
        dbgContatos.Columns[2].ButtonStyle := cbsPickList;
        dbgContatos.Columns[2].PickList.AddStrings(['Pessoal','Comercial']);
        dbgContatos.Columns[2].Width := 93;

        dbgContatos.Columns[3].Title.Caption := 'MEIO CONTATO';
        dbgContatos.Columns[3].ButtonStyle := cbsPickList;
        dbgContatos.Columns[3].PickList.AddStrings(['Celular','Email','Fone fixo']);
        dbgContatos.Columns[3].Width := 93;

        dbgContatos.Columns[4].Width := 250;

        dbgContatos.Columns[5].Title.Caption := 'NOME CONTATO';
        dbgContatos.Columns[5].Width := 200;

        dbgContatos.Columns[6].Width := 90;
      end;
  except on E: exception do
    begin
      FreeAndNil(dbgEnderecos);
      FreeAndNil(dbgContatos);
      Application.MessageBox(PChar('Erro ao carregar enderecos/contatos'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmCadPessoas.sbtnVinculoClick(Sender: TObject);
begin
  if ((edtPessoaID.Text = EmptyStr) and (dbgPessoas.SelectedRows.Count > 0)) then
    begin
      Application.MessageBox(PChar('Selecione um cadastro para definir o vículo'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;

  if edtPessoaID.Text <> EmptyStr then
    gID_Pessoa := edtPessoaID.Text
  else
    gID_Pessoa := dbgPessoas.Columns.Items[0].Field.Text;

  gTipo_Vinculo := EmptyStr;

  //OpenForm(TfrmVinculos,'Modal');
  frmVinculos := TfrmVinculos.Create(Self);
  frmVinculos.formPai := Self.Name;
  //frmVinculos.ShowModal;
  OpenWindowTab(frmPrincipal.PageControl,frmVinculos,['TabTitle: Vínculos ['+dbgPessoas.DataSource.DataSet.FieldByName('NOME').Text+']']);
end;

procedure TfrmCadPessoas.sqlqContatosAfterDelete(DataSet: TDataSet);
begin

end;

procedure TfrmCadPessoas.sqlqContatosBeforeDelete(DataSet: TDataSet);
var
  reg: Integer;
begin
  reg := sqlqContatos.RecNo;
  if sqlqContatos.FieldByName('PREFERENCIAL').AsBoolean = True then
    begin
      if sqlqContatos.RecordCount > 1 then
        begin
          if sqlqContatos.RecNo = 1 then
            sqlqContatos.RecNo := 2
          else
            sqlqContatos.RecNo := 1;
          sqlqContatos.Edit;
          sqlqContatos.FieldByName('PREFERENCIAL').AsBoolean := True;
          sqlqContatos.Post;
          sqlqContatos.RecNo := reg;
        end;
    end;
  reg := 0;
end;

procedure TfrmCadPessoas.sqlqContatosBeforePost(DataSet: TDataSet);
begin
  if sqlqContatos.Fields.Fields[2].Text = EmptyStr then
    begin
      Application.MessageBox('Selecione o tipo de contato', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;

  if sqlqContatos.Fields.Fields[3].Text = EmptyStr then
    begin
      Application.MessageBox('Selecione o meio de contato', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;

  if sqlqContatos.Fields.Fields[4].Text = EmptyStr then
    begin
      Application.MessageBox('Informe o contato', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;

  if sqlqContatos.Fields.Fields[3].Text = 'Email' then
    begin
      if not ValidarEmail(sqlqContatos.Fields.Fields[4].Text) then
        begin
          Application.MessageBox('Email inválido', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
          Abort;
        end;
    end;
end;

procedure TfrmCadPessoas.sqlqEnderecosBeforeDelete(DataSet: TDataSet);
var
  reg: Integer;
begin
  reg := sqlqEnderecos.RecNo;
  if sqlqEnderecos.FieldByName('PREFERENCIAL').AsBoolean = True then
    begin
      if sqlqEnderecos.RecordCount > 1 then
        begin
          if sqlqEnderecos.RecNo = 1 then
            sqlqEnderecos.RecNo := 2
          else
            sqlqEnderecos.RecNo := 1;
          sqlqEnderecos.Edit;
          sqlqEnderecos.FieldByName('PREFERENCIAL').AsBoolean := True;
          sqlqEnderecos.Post;
          sqlqEnderecos.RecNo := reg;
        end;
    end;
  reg := 0;
end;

procedure TfrmCadPessoas.sqlqEnderecosBeforePost(DataSet: TDataSet);
begin
  if sqlqEnderecos.FieldByName('tipo_endereco').Text = EmptyStr  then
    begin
      Application.MessageBox('Selecione o tipo de endereço', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;

  if sqlqEnderecos.FieldByName('logradouro').Text = EmptyStr then
    begin
      Application.MessageBox('Informe o endereço', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Abort;
    end;

 { if sqlqEnderecos.FieldByName('municipio').Text <> EmptyStr then
    begin
      sqlqEnderecos.FieldByName('municipio').Text := Copy(dbgEnderecos.Columns[12].Field.Text, 1, Pos('[', dbgEnderecos.Columns[12].Field.Text)-2)
    end;}
end;

end.

