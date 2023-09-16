unit UEditorFiltros;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, DBGrids, ComCtrls, Buttons, LCLType, ListViewFilterEdit, Grids;

type

  { TfrmEditorFiltros }

  TfrmEditorFiltros = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnOk: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    btnIncluir: TButton;
    btnModificar: TButton;
    btnAgrupar: TButton;
    cbbxCriterio: TComboBox;
    dsExpressao: TDataSource;
    dbgExpressao: TDBGrid;
    edtPesquisar: TEdit;
    edtValor: TEdit;
    edtValorFinal: TEdit;
    gpbxCriterios: TGroupBox;
    gpbxExpressao: TGroupBox;
    lblCriterioSelecionado: TLabel;
    lblCriterio: TLabel;
    lblValor: TLabel;
    lblValorFinal: TLabel;
    lblCampos: TLabel;
    lblPesquisar: TLabel;
    lstvwCampos: TListView;
    pnlComandosExpressao: TPanel;
    rdgpCondicao: TRadioGroup;
    sbtnSubir: TSpeedButton;
    sbtnDescer: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    sbtnLimpar: TSpeedButton;
    sbtnPesquisar: TSpeedButton;
    sqlqCamposTabela: TSQLQuery;
    sqlqExpressao: TSQLQuery;
    procedure btnAgruparClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnModificarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure cbbxCriterioChange(Sender: TObject);
    procedure dbgExpressaoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgExpressaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgExpressaoSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure edtPesquisarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lstvwCamposChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstvwCamposDrawItem(Sender: TCustomListView; AItem: TListItem;
      ARect: TRect; AState: TOwnerDrawState);
    procedure lstvwCamposInsert(Sender: TObject; Item: TListItem);
    procedure lstvwCamposSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure rdgpCondicaoSelectionChanged(Sender: TObject);
    procedure CarregaExpressao;
    procedure sbtnDescerClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnLimparClick(Sender: TObject);
    procedure sbtnPesquisarClick(Sender: TObject);
    procedure sbtnSubirClick(Sender: TObject);
    procedure sqlqExpressaoBeforeClose(DataSet: TDataSet);
  private
    Acao, Filtro, Campo, Titulo, Criterio, Condicao, Valor, Modulo, Formulario, ID_Expressao: String;
    Editado: Boolean;
    TotalLinhas: Integer;
  public
    ID_Filtro: String;
  end;

var
  frmEditorFiltros: TfrmEditorFiltros;

implementation

uses
  UGFunc, UDBO, UConexao;
{$R *.lfm}

{ TfrmEditorFiltros }

procedure TfrmEditorFiltros.FormShow(Sender: TObject);
var
  Item: TListItem;
begin
  try
    if ID_Filtro = EmptyStr then
      begin
        Abort;
      end;

    Editado := False;

    //Carrega os dados do filtro
    SQLQuery(sqlqCamposTabela,['SELECT * FROM g_filtros'
                              ,'WHERE id_filtro = '''+ID_Filtro+'''']);
    Filtro := sqlqCamposTabela.FieldByName('filtro').Text;
    Formulario := sqlqCamposTabela.FieldByName('formulario').Text;

    CarregaExpressao;

    //Carregar os campos para filtragem no ListView de acordo com o formulário de origem do filtro
    case Formulario of
      'LOGSSISTEMA':
        begin
          lstvwCampos.Items.Clear;
          Item := lstvwCampos.Items.Add;
          Item.Caption := 'ID';
          Item.SubItems.Add('id_log');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Data/Hora Log';
          Item.SubItems.Add('dth_log');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Estação';
          Item.SubItems.Add('estacao');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Módulo';
          Item.SubItems.Add('modulo');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Formulário';
          Item.SubItems.Add('formulario');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Ação';
          Item.SubItems.Add('acao');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'ID/COD do Registro';
          Item.SubItems.Add('id_registro');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'ID Usuário';
          Item.SubItems.Add('id_usuario');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Usuário';
          Item.SubItems.Add('usuario');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Detalhes';
          Item.SubItems.Add('detalhes');
        end;

      'CADPESSOAS':
        begin
          lstvwCampos.Items.Clear;
          Item := lstvwCampos.Items.Add;
          Item.Caption := 'ID';
          Item.SubItems.Add('P.id_pessoa');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Nome';
          Item.SubItems.Add('P.nome');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'RG';
          Item.SubItems.Add('P.rg');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'CPF';
          Item.SubItems.Add('P.cpf');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Data de Nascimento';
          Item.SubItems.Add('P.dt_nascimento');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Tipo de Endereço';
          Item.SubItems.Add('E.tipo_endereco');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Tipo de Local do Endereço';
          Item.SubItems.Add('E.tipo_logradouro');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Endereço';
          Item.SubItems.Add('E.logradouro');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Número';
          Item.SubItems.Add('E.numero');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Bairro';
          Item.SubItems.Add('E.bairro');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Referência';
          Item.SubItems.Add('E.referencia');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'CEP';
          Item.SubItems.Add('E.cep');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Município';
          Item.SubItems.Add('M.municipio');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'UF';
          Item.SubItems.Add('U.uf');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Tipo de Contato';
          Item.SubItems.Add('C.tipo_contato');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Meio de Contato';
          Item.SubItems.Add('C.meio_contato');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Contato';
          Item.SubItems.Add('C.contato');

          Item := lstvwCampos.Items.Add;
          Item.Caption := 'Nome Contato';
          Item.SubItems.Add('C.nome_contato_terceiro');
        end;
    end;

    Self.Caption := Self.Caption+' ['+Filtro+']';

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao carregar o filtro'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmEditorFiltros.lstvwCamposChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin

end;

procedure TfrmEditorFiltros.lstvwCamposDrawItem(Sender: TCustomListView;
  AItem: TListItem; ARect: TRect; AState: TOwnerDrawState);
begin

end;

procedure TfrmEditorFiltros.lstvwCamposInsert(Sender: TObject; Item: TListItem);
begin
  if lstvwCampos.Column[0].Width <= lstvwCampos.Width-4 then
    begin
      lstvwCampos.Column[0].AutoSize := False;
      lstvwCampos.Column[0].Width := lstvwCampos.Width-4;
    end
  else
    lstvwCampos.Column[0].AutoSize := True;
end;

procedure TfrmEditorFiltros.lstvwCamposSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if lstvwCampos.SelCount > 0 then
    begin
      Campo := lstvwCampos.Items.Item[lstvwCampos.ItemIndex].SubItems[0];
      Titulo := lstvwCampos.Items.Item[lstvwCampos.ItemIndex].Caption;
    end
  else
    begin
      Campo := EmptyStr;
      Titulo := EmptyStr;
    end;
end;

procedure TfrmEditorFiltros.rdgpCondicaoSelectionChanged(Sender: TObject);
begin
  case rdgpCondicao.ItemIndex of
    0: Condicao := 'AND';
    1: Condicao := 'OR';
  end;
end;

procedure TfrmEditorFiltros.cbbxCriterioChange(Sender: TObject);
begin
  case cbbxCriterio.Text of
    'é igual a': Criterio := '=';
    'é diferente de': Criterio := '<>';
    'é maior que': Criterio := '>';
    'é menor que': Criterio := '<';
    'é maior ou igual a': Criterio := '>=';
    'é menor ou igual a': Criterio := '<=';
    'possui': Criterio := 'LIKE';
    'não possui': Criterio := 'NOT LIKE';
    'contém': Criterio := 'IN';
    'não contém': Criterio := 'NOT IN';
    'está entre': Criterio := 'BETWEEN';
    'não está entre': Criterio := 'NOT BETWEEN';
    'é nulo': Criterio := 'IS NULL';
    'não é nulo': Criterio := 'IS NOT NULL';
    'é verdadeiro': Criterio := '= true';
    'é falso': Criterio := '= false';
  end;

  if ((cbbxCriterio.Text = 'está entre')
     or (cbbxCriterio.Text = 'não está entre')) then
    begin
      lblValor.Caption := 'Valor inicial';
      lblValorFinal.Visible := True;
      edtValorFinal.Visible := True;
    end
  else
    begin
      lblValor.Caption := 'Valor';
      lblValorFinal.Visible := False;
      edtValorFinal.Visible := False;
      edtValorFinal.Clear;
    end;

  if ((cbbxCriterio.Text = 'é nulo')
     or (cbbxCriterio.Text = 'não é nulo')
     or (cbbxCriterio.Text = 'é verdadeiro')
     or (cbbxCriterio.Text = 'é falso')) then
    begin
      edtValor.Text := '';
      edtValor.Enabled := False;
    end
  else
    begin
      edtValor.Enabled := True;
    end;

  if cbbxCriterio.Text <> EmptyStr then
    begin
      lblCriterioSelecionado.Caption := Criterio;
      lblCriterioSelecionado.Visible := True;
    end
  else
    lblCriterioSelecionado.Visible := False;
end;

procedure TfrmEditorFiltros.dbgExpressaoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure TfrmEditorFiltros.dbgExpressaoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    dbgExpressao.SelectedRows.Clear;

  if (ssCtrl in Shift) and (Key = VK_A) then
    begin
      dbgExpressao.DataSource.DataSet.DisableControls;
      dbgExpressao.DataSource.DataSet.First;
      while not(dbgExpressao.DataSource.DataSet.EOF) do
        begin
          dbgExpressao.SelectedRows.CurrentRowSelected:=true;
          dbgExpressao.DataSource.DataSet.Next;
        end;
      dbgExpressao.DataSource.DataSet.EnableControls;
    end;

  if (not (ssCtrl in Shift) and (Key = VK_DELETE)) then
    sbtnExcluir.Click;

  if ((ssCtrl in Shift) and (Key = VK_DELETE)) then
    sbtnLimpar.Click;

  if ((ssCtrl in Shift) and (Key = VK_UP)) then
    sbtnSubir.Click;

  if ((ssCtrl in Shift) and (Key = VK_DOWN)) then
    sbtnDescer.Click;
end;

procedure TfrmEditorFiltros.dbgExpressaoSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
var
  Linha: Integer;
begin
  //Permite selecionar apenas uma linha mesmo que o MultiSelect esteja habilitado
  {Linha := dbgExpressao.DataSource.DataSet.RecNo;
  dbgExpressao.SelectedRows.Clear;
  dbgExpressao.SelectedIndex := Linha;}
end;

procedure TfrmEditorFiltros.edtPesquisarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TfrmEditorFiltros.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Editado then
    begin
      case Application.MessageBox(PChar('Deseja salvar as alterações?'), 'Confirmação',  MB_ICONQUESTION + MB_YESNOCANCEL) of
        MRYES:
          begin
            btnSalvar.Click;
            lstvwCampos.Free;
            CloseAllFormOpenedConnections(Self);
            FreeAndNil(Self);
          end;
        MRNO:
          begin
            Editado := False;
            lstvwCampos.Free;
            CloseAllFormOpenedConnections(Self);
            FreeAndNil(Self);
          end;
        MRCANCEL:
          begin
            Abort;
          end;
      end;
    end
  else
    begin
      lstvwCampos.Free;
      CloseAllFormOpenedConnections(Self);
    end;
end;

procedure TfrmEditorFiltros.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    CarregaExpressao;
end;

procedure TfrmEditorFiltros.btnIncluirClick(Sender: TObject);
var
  Expressao, CondicaoS, Linha, ValorR1, ValorR2, Valor1, Valor2, ValorF: String;
  Separador: Array[0..0] of Char;
  ArrayValor: Array of String;
  i: Integer;
begin
  try
    if Campo = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione o campo que deseja filtrar'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        lstvwCampos.SetFocus;
        Exit;
      end;

    if Criterio = EmptyStr then
      begin
        Application.MessageBox(PChar('Selecione o critério de pesquisa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        cbbxCriterio.SetFocus;
        cbbxCriterio.DroppedDown := True;
        Exit;
      end;

    if ((edtValor.Enabled)
       and (edtValor.Text = EmptyStr)) then
      begin
        Application.MessageBox(PChar('Informe o valor para a pesquisa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtValor.SetFocus;
        Exit;
      end;

    if ((edtValorFinal.Visible)
       and (edtValorFinal.Text = EmptyStr)) then
      begin
        Application.MessageBox(PChar('Informe o valor final para a pesquisa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtValorFinal.SetFocus;
        Exit;
      end;

    if ((sqlqExpressao.RecordCount >= 1)
        and (rdgpCondicao.ItemIndex < 0)) then
      begin
        Application.MessageBox(PChar('Selecione uma condição'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        rdgpCondicao.SetFocus;
        Exit;
      end;

    if TotalLinhas >= 1 then
      CondicaoS := Condicao
    else
      CondicaoS := '';

    Valor1 := edtValor.Text;
    Separador[0] := ';';
    ArrayValor := Valor1.Split(Separador);
    for i := 0 to Length(ArrayValor)-1 do
      begin
        if i = 0 then
          ValorR1 := ''''''+ArrayValor[i]+''''''
        else
          ValorR1 := ValorR1+','''''+ArrayValor[i]+'''''';
      end;

    Valor2 := edtValorFinal.Text;
    Separador[0] := ';';
    ArrayValor := Valor2.Split(Separador);
    for i := 0 to Length(ArrayValor)-1 do
      begin
        if i = 0 then
          ValorR2 := ''''''+ArrayValor[i]+''''''
        else
          ValorR2 := ValorR2+','''''+ArrayValor[i]+'''''';
      end;


    if ((Criterio = 'BETWEEN')
       or (Criterio = 'NOT BETWEEN')) then
      begin
        ValorF := Criterio+' '+ValorR1+' AND '+ValorR2;
      end
    else
    if ((Criterio = 'IN')
       or (Criterio = 'NOT IN')) then
      begin
        ValorF := Criterio+' ('+ValorR1+')';
      end
    else
      if ((Criterio = 'IS NULL')
         or (Criterio = 'IS NOT NULL')
         or (Criterio = '= true')
         or (Criterio = '= false')) then
        ValorF := Criterio
      else
        ValorF := Criterio+' '+ValorR1;

    Expressao := CondicaoS+' '+Campo+' '+ValorF;

    Linha := IntToStr(TotalLinhas+1);
    SQLExec(sqlqExpressao,['INSERT INTO g_filtros_expressoes'
                          ,'(id_filtro, ordem, condicao, campo, titulo, criterio, valor, valor_final, expressao)'
                          ,'VALUES ('''+ID_Filtro+''','''+Linha+''','''+CondicaoS+''','''+Campo+''','''+Titulo+''','''+Criterio+''','''+Valor1+''','''+Valor2+''','''+Expressao+''')']);

    //Atualiza o DBGrid das expressões
    CarregaExpressao;

    ID_Expressao := EmptyStr;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao incluir a expressão'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmEditorFiltros.btnAgruparClick(Sender: TObject);
begin
  if dbgExpressao.SelectedRows.Count > 1 then
    showmessage('Agrupar');
end;

procedure TfrmEditorFiltros.btnCancelarClick(Sender: TObject);
begin
  try
    if Editado then
      begin
        if Application.MessageBox(PChar('Cancelar a edição?'), 'Confirmação', MB_ICONQUESTION + MB_OKCANCEL) = MROK then
          begin
            Editado := False;
          end;
      end
    else
      Self.Close;
  except on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao cancelar a edição'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmEditorFiltros.btnModificarClick(Sender: TObject);
var
  CriterioE, CondicaoE, ValorE, ValorFinalE, ExpressaoE, ValorR1, ValorR2, Valor1, Valor2, ValorF: String;
  Separador: Array[0..0] of Char;
  ArrayValor: Array of String;
  i,j: Integer;
  Found: Boolean;
begin
  if dbgExpressao.SelectedRows.Count > 0 then
    begin
      if ((ID_Expressao = EmptyStr)
         or ((ID_Expressao <> EmptyStr) and (ID_Expressao <> dbgExpressao.DataSource.DataSet.FieldByName('id_expressao').Text))) then
        begin
          case dbgExpressao.DataSource.DataSet.FieldByName('criterio').Text of
            '=': CriterioE := 'é igual a';
            '<>': CriterioE := 'é diferente de';
            '>': CriterioE := 'é maior que';
            '<': CriterioE := 'é menor que';
            '>=': CriterioE := 'é maior ou igual a';
            '<=': CriterioE := 'é menor ou igual a';
            'LIKE': CriterioE := 'possui';
            'NOT LIKE': CriterioE := 'não possui';
            'IN': CriterioE := 'contém';
            'NOT IN': CriterioE := 'não contém';
            'BETWEEN': CriterioE := 'está entre';
            'NOT BETWEE': CriterioE := 'não está entre';
            'IS NULL': CriterioE := 'é nulo';
            'IS NOT NULL': CriterioE := 'não é nulo';
            '= true': CriterioE := 'é verdadeiro';
            '= false': CriterioE := 'é falso';
          end;

          cbbxCriterio.ItemIndex := cbbxCriterio.Items.IndexOf(CriterioE);
          cbbxCriterioChange(cbbxCriterio);

          edtValor.Text := dbgExpressao.DataSource.DataSet.FieldByName('valor').Text;

          if ((Criterio = 'BETWEEN')
             or (Criterio = 'NOT BETWEEN')) then
            edtValorFinal.Text := dbgExpressao.DataSource.DataSet.FieldByName('valor_final').Text;

          Campo := dbgExpressao.DataSource.DataSet.FieldByName('campo').Text;
          Titulo := dbgExpressao.DataSource.DataSet.FieldByName('titulo').Text;


          j := 0;
          repeat
            Found := Pos(LowerCase(Titulo), LowerCase(lstvwCampos.Items[j].Caption)) = 1;
            if not Found then inc(j);
          until Found or (j > lstvwCampos.Items.Count - 1);
          if Found then
            begin
              lstvwCampos.Items[j].Selected := True;
              lstvwCampos.Selected.MakeVisible(True);
            end;

          ID_Expressao := dbgExpressao.DataSource.DataSet.FieldByName('id_expressao').Text;;

          case dbgExpressao.DataSource.DataSet.FieldByName('condicao').Text of
            '': rdgpCondicao.ItemIndex := -1;
            'AND': rdgpCondicao.ItemIndex := 0;
            'OR': rdgpCondicao.ItemIndex := 1;
          end;
        end
      else
        begin
          try
            if Campo = EmptyStr then
              begin
                Application.MessageBox(PChar('Selecione o campo que deseja filtrar'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
                lstvwCampos.SetFocus;
                Exit;
              end;

            if Criterio = EmptyStr then
              begin
                Application.MessageBox(PChar('Selecione o critério de pesquisa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
                cbbxCriterio.SetFocus;
                cbbxCriterio.DroppedDown := True;
                Exit;
              end;

            if ((edtValor.Enabled)
               and (edtValor.Text = EmptyStr)) then
              begin
                Application.MessageBox(PChar('Informe o valor para a pesquisa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
                edtValor.SetFocus;
                Exit;
              end;

            if ((edtValorFinal.Visible)
               and (edtValorFinal.Text = EmptyStr)) then
              begin
                Application.MessageBox(PChar('Informe o valor final para a pesquisa'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
                edtValorFinal.SetFocus;
                Exit;
              end;

            if ((dbgExpressao.DataSource.DataSet.RecNo > 1)
                and (rdgpCondicao.ItemIndex < 0)) then
              begin
                Application.MessageBox(PChar('Selecione uma condição'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
                rdgpCondicao.SetFocus;
                Exit;
              end;

            if dbgExpressao.DataSource.DataSet.RecNo > 1 then
              CondicaoE := Condicao
            else
              CondicaoE := '';

            Valor1 := edtValor.Text;
            Separador[0] := ';';
            ArrayValor := Valor1.Split(Separador);
            for i := 0 to Length(ArrayValor)-1 do
              begin
                if i = 0 then
                  ValorR1 := ''''''+ArrayValor[i]+''''''
                else
                  ValorR1 := ValorR1+','''''+ArrayValor[i]+'''''';
              end;

            Valor2 := edtValorFinal.Text;
            Separador[0] := ';';
            ArrayValor := Valor2.Split(Separador);
            for i := 0 to Length(ArrayValor)-1 do
              begin
                if i = 0 then
                  ValorR2 := ''''''+ArrayValor[i]+''''''
                else
                  ValorR2 := ValorR2+','''''+ArrayValor[i]+'''''';
              end;

            if ((Criterio = 'BETWEEN')
               or (Criterio = 'NOT BETWEEN')) then
              begin
                ValorF := Criterio+' '+ValorR1+' AND '+ValorR2;
              end
            else
            if ((Criterio = 'IN')
               or (Criterio = 'NOT IN')) then
              begin
                ValorF := Criterio+' ('+ValorR1+')';
              end
            else
              if ((Criterio = 'IS NULL')
                 or (Criterio = 'IS NOT NULL')
                 or (Criterio = '= true')
                 or (Criterio = '= false')) then
                ValorF := Criterio
              else
                ValorF := Criterio+' '+ValorR1;

            ExpressaoE := CondicaoE+' '+Campo+' '+ValorF;

            SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                  ,'SET condicao='''+CondicaoE+''', campo='''+Campo+''', titulo='''+Titulo+''', criterio='''+Criterio+''','
                                  ,'valor='''+Valor1+''', valor_final='''+Valor2+''', expressao='''+ExpressaoE+''''
                                  ,'WHERE id_expressao = '+ID_Expressao]);
            {SQLExec(sqlqExpressao,['INSERT INTO g_filtros_expressoes'
                                  ,'(id_filtro, ordem, condicao, campo, titulo, criterio, valor, valor_final, expressao)'
                                  ,'VALUES ('''+ID_Filtro+''','''+Linha+''','''+CondicaoS+''','''+Campo+''','''+Titulo+''','''+Criterio+''','''+edtValor.Text+''','''+edtValorFinal.Text+''','''+Expressao+''')']);}

            //Atualiza o DBGrid das expressões
            CarregaExpressao;

            ID_Expressao := EmptyStr;
          except on E: exception do
            begin
              if E.ClassName <> 'EAbort' then
                begin
                  Application.MessageBox(PChar('Erro ao modificar a expressão'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
                end;
            end;
          end;
        end;
    end;
end;

procedure TfrmEditorFiltros.btnOkClick(Sender: TObject);
begin
  btnSalvar.Click;
  lstvwCampos.Free;
  Self.Close;
end;

procedure TfrmEditorFiltros.btnSalvarClick(Sender: TObject);
begin
  try

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar salvar a expressão'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmEditorFiltros.CarregaExpressao;
begin
  try
    //Carrega os dados no DBGrid das expressoes
    SQLQuery(sqlqExpressao,['SELECT * FROM g_filtros_expressoes'
                           ,'WHERE id_filtro = '''+ID_Filtro+''''
                           ,'ORDER BY ordem, id_expressao']);

    dbgExpressao.Columns[0].FieldName:='id_expressao';
    dbgExpressao.Columns[0].Title.Caption:='ID_EXPRESSAO';
    dbgExpressao.Columns[0].Width := 40;
    dbgExpressao.Columns[1].FieldName:='id_filtro';
    dbgExpressao.Columns[1].Title.Caption:='ID_FILTRO';
    dbgExpressao.Columns[1].Width := 40;
    dbgExpressao.Columns[2].FieldName:='ordem';
    dbgExpressao.Columns[2].Title.Caption:='ORDEM';
    dbgExpressao.Columns[2].Width := 30;
    dbgExpressao.Columns[3].FieldName:='condicao';
    dbgExpressao.Columns[3].Title.Caption:='CONDIÇÃO';
    dbgExpressao.Columns[3].Width := 40;
    dbgExpressao.Columns[4].FieldName:='campo';
    dbgExpressao.Columns[4].Title.Caption:='CAMPO_BD';
    dbgExpressao.Columns[4].Width := 100;
    dbgExpressao.Columns[5].FieldName:='titulo';
    dbgExpressao.Columns[5].Title.Caption:='CAMPO';
    dbgExpressao.Columns[5].Width := 100;
    dbgExpressao.Columns[6].FieldName:='criterio';
    dbgExpressao.Columns[6].Title.Caption:='CRITÉRIO';
    dbgExpressao.Columns[6].Width := 60;
    dbgExpressao.Columns[7].FieldName:='valor';
    dbgExpressao.Columns[7].Title.Caption:='VALOR';
    dbgExpressao.Columns[7].Width := 100;
    dbgExpressao.Columns[8].FieldName:='valor_final';
    dbgExpressao.Columns[8].Title.Caption:='VALOR FINAL';
    dbgExpressao.Columns[8].Width := 100;

    TotalLinhas := sqlqExpressao.RecordCount;

    Clean([edtPesquisar,cbbxCriterio,edtValor,edtValorFinal,rdgpCondicao,lstvwCampos,lblCriterioSelecionado]);
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao carregar a expressão'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmEditorFiltros.sbtnDescerClick(Sender: TObject);
var
  TotReg, Reg, RegProx: Integer;
  ID_Expressao_Proxima, ID_Expressao_Atual, CondicaoN: String;
  Foco: TBookMark;
begin
  TotReg := dbgExpressao.DataSource.DataSet.RecordCount;

  if (TotReg > 1)
     and (dbgExpressao.DataSource.DataSet.RecNo < TotReg) then
    begin
      ID_Expressao_Atual := dbgExpressao.DataSource.DataSet.FieldByName('id_expressao').Text;
      dbgExpressao.DataSource.DataSet.Next;
      CondicaoN := dbgExpressao.DataSource.DataSet.FieldByName('condicao').Text;
      Foco := dbgExpressao.DataSource.DataSet.GetBookmark;
      ID_Expressao_Proxima := dbgExpressao.DataSource.DataSet.FieldByName('id_expressao').Text;
      dbgExpressao.DataSource.DataSet.Prior;

      Reg := dbgExpressao.DataSource.DataSet.RecNo;
      RegProx := dbgExpressao.DataSource.DataSet.RecNo+1;

      if dbgExpressao.DataSource.DataSet.RecNo = 1 then
        begin
          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET condicao='''+CondicaoN+''', ordem='''+IntToStr(RegProx)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Atual]);

          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET condicao='''', ordem='''+IntToStr(Reg)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Proxima]);
        end
      else
        begin
          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET ordem='''+IntToStr(RegProx)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Atual]);

          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET ordem='''+IntToStr(Reg)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Proxima]);
        end;
      CarregaExpressao;
      dbgExpressao.SelectedIndex := RegProx;
      dbgExpressao.DataSource.DataSet.GotoBookmark(Foco);
    end;

end;

procedure TfrmEditorFiltros.sbtnExcluirClick(Sender: TObject);
var
  ID_Excluir: String;
  i: Integer;
begin
  try
    if dbgExpressao.SelectedRows.Count > 0 then
      begin
        if Application.MessageBox(PChar('Deseja realmente excluir a(s) linha(s) selecionada(s) da expressão?'), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
          begin
            for i := 0 to dbgExpressao.SelectedRows.Count - 1 do
              begin
                sqlqExpressao.GotoBookmark(pointer(dbgExpressao.SelectedRows.Items[i]));
                ID_Excluir := ID_Excluir + sqlqExpressao.FieldByName('id_expressao').AsString;
                if ((i >= 0)
                   and (i < dbgExpressao.SelectedRows.Count-1)) then
                  ID_Excluir := ID_Excluir + ',';
              end;
              SQLExec(sqlqExpressao,['DELETE FROM g_filtros_expressoes'
                                    ,'WHERE id_expressao IN ('+ID_Excluir+')']);

              CarregaExpressao;
              {//Refazer ordem das linhas
              sqlqExpressao.First;
              while not sqlqExpressao.EOF do
                begin
                  SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                       ,'SET ordem='''+IntToStr(sqlqExpressao.RecNo)+''''
                                       ,'WHERE id_expressao = '+sqlqExpressao.FieldByName('id_expressao').Text]);
                  //CarregaExpressao;
                  sqlqExpressao.Next;
                end;}
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar excluir a linha da expressão'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmEditorFiltros.sbtnLimparClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('Deseja realmente limpar todas as linhas da expressão?'), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
    begin
      SQLExec(sqlqExpressao,['DELETE FROM g_filtros_expressoes WHERE id_filtro = '+ID_Filtro]);

      CarregaExpressao;
    end;
end;

procedure TfrmEditorFiltros.sbtnPesquisarClick(Sender: TObject);
var
  i: integer;
  Found: Boolean;
begin
  i := 0;
  repeat
    Found := Pos(LowerCase(edtPesquisar.Text), LowerCase(lstvwCampos.Items[i].Caption)) >= 1;
    if not Found then inc(i);
  until Found or (i > lstvwCampos.Items.Count - 1);
  if Found then
    begin
      lstvwCampos.Items[i].Selected := True;
      lstvwCampos.Selected.MakeVisible(True);
      lstvwCampos.SetFocus;
    end
  else
    lstvwCampos.ItemIndex := -1;
end;

procedure TfrmEditorFiltros.sbtnSubirClick(Sender: TObject);
var
  TotReg, Reg, RegAnt: Integer;
  ID_Expressao_Anterior, ID_Expressao_Atual, CondicaoN: String;
  Foco: TBookMark;
begin
  TotReg := dbgExpressao.DataSource.DataSet.RecordCount;

  if (TotReg > 1)
     and (dbgExpressao.DataSource.DataSet.RecNo > 1) then
    begin
      ID_Expressao_Atual := dbgExpressao.DataSource.DataSet.FieldByName('id_expressao').Text;
      CondicaoN := dbgExpressao.DataSource.DataSet.FieldByName('condicao').Text;
      dbgExpressao.DataSource.DataSet.Prior;
      Foco := dbgExpressao.DataSource.DataSet.GetBookmark;
      ID_Expressao_Anterior := dbgExpressao.DataSource.DataSet.FieldByName('id_expressao').Text;

      Reg := dbgExpressao.DataSource.DataSet.RecNo+1;
      RegAnt := dbgExpressao.DataSource.DataSet.RecNo;

      if dbgExpressao.DataSource.DataSet.RecNo = 1 then
        begin
          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET condicao='''', ordem='''+IntToStr(RegAnt)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Atual]);

          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET condicao='''+CondicaoN+''', ordem='''+IntToStr(Reg)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Anterior]);
        end
      else
        begin
          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET ordem='''+IntToStr(RegAnt)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Atual]);

          SQLExec(sqlqExpressao,['UPDATE g_filtros_expressoes'
                                ,'SET ordem='''+IntToStr(Reg)+''''
                                ,'WHERE id_expressao = '+ID_Expressao_Anterior]);
        end;
      CarregaExpressao;
      dbgExpressao.SelectedIndex := RegAnt;
      dbgExpressao.DataSource.DataSet.GotoBookmark(Foco);
    end;
end;

procedure TfrmEditorFiltros.sqlqExpressaoBeforeClose(DataSet: TDataSet);
begin

end;

end.

