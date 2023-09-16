unit UPesquisar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, LCLType, ExtCtrls, DBGrids;

type

  { TfrmPesquisar }

  TfrmPesquisar = class(TForm)
    cbCampo_1: TComboBox;
    cbCriterio_1: TComboBox;
    cbCondicao_1: TComboBox;
    dsPesquisa: TDataSource;
    dbgResultadoPesquisa: TDBGrid;
    edtValor2_1: TEdit;
    edtValor1_1: TEdit;
    gpbxCriteriosPesquisa: TGroupBox;
    gpbxResultadosPesquisa: TGroupBox;
    lblE_1: TLabel;
    lblCondicao: TLabel;
    lblValor: TLabel;
    lblCriterio: TLabel;
    lblCampo: TLabel;
    pnlResultadoPesquisa: TPanel;
    sbtnIncluirCriterio: TSpeedButton;
    sbtnLimparPesquisa_999: TSpeedButton;
    sbtnPesquisar: TSpeedButton;
    sbtnUtilizar: TSpeedButton;
    sqlqPesquisa: TSQLQuery;
    procedure cbCriterio_1Change(Sender: TObject);
    procedure dbgResultadoPesquisaDblClick(Sender: TObject);
    procedure dbgResultadoPesquisaTitleClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtnIncluirCriterioClick(Sender: TObject);
    function Identificador(Sender: TObject): String;
    procedure habCampoValor2(Sender: TObject);
    procedure RemoverCamposCriterio_Click(Sender: TObject);
    procedure RemoverCamposCriterio(idObjRem: String);
    procedure ReorganizarObjetos(idObjetoExcluido: Integer);
    procedure sbtnLimparPesquisa_999Click(Sender: TObject);
    procedure sbtnPesquisarClick(Sender: TObject);
    procedure sbtnUtilizarClick(Sender: TObject);
  private
    nCriterios, idObj, posObjeto: Integer;
    posObjetos: Array of Array of Integer;
    consSQL, Filtro: String;
  public
    posX, posY: Integer;
    RefConsulta, Param1: String;
    const
      DefaultCaption: String = 'Pesquisar';
  end;

var
  frmPesquisar: TfrmPesquisar;

implementation

uses
  UGFunc, UDBO, UConexao, UVinculosPessoas, UGerencFotos, UUsuarios;

{$R *.lfm}

{ TfrmPesquisar }

procedure TfrmPesquisar.FormShow(Sender: TObject);
begin
  if ((posX >= 0) and (posY >= 0)) then
    begin
      Self.Position := poDesigned;
      Self.Top := posY;
      Self.Left := posX;
    end
  else
    Self.Position := poOwnerFormCenter;

  if RefConsulta <> EmptyStr then
    Self.Caption := DefaultCaption+' ['+RefConsulta+']'
  else
    Self.Caption := DefaultCaption;

  case RefConsulta of
    'Vínculos (Pessoa)':
      begin
        cbCampo_1.Items.AddStrings(['ID','NOME','CPF']);
        consSQL := 'SELECT id_pessoa ID, NOME, CPF FROM p_pessoas WHERE excluido = false AND ';
      end;
    'Vínculos (Empresa)':
      begin
        cbCampo_1.Items.AddStrings(['COD','NOME','RAZÃO SOCIAL','CNPJ','ATIVO']);
        consSQL := 'SELECT cod_empresa COD, fantasia NOME, razao_social AS ''RAZÃO SOCIAL'', cnpj CNPJ, status ATIVO FROM g_empresas WHERE ';
      end;
    'Vínculos (Setor)':
      begin
        cbCampo_1.Items.AddStrings(['COD','SETOR','ATIVO']);
        consSQL := 'SELECT cod_setor COD, SETOR, status ATIVO FROM g_setores WHERE cod_empresa = '''+Param1+''' AND ';
      end;
    'Vínculos (Função)':
      begin
        cbCampo_1.Items.AddStrings(['COD','FUNÇÃO','ATIVO']);
        consSQL := 'SELECT cod_funcao COD, funcao FUNÇÃO, status ATIVO FROM p_funcoes WHERE cod_empresa = '''+Param1+''' AND ';
      end;
    'Vínculos (Centro de Custo)':
      begin
        cbCampo_1.Items.AddStrings(['COD','CENTRO DE CUSTO','CLASSIFICAÇÃO','NÍVEL','TIPO','ATIVO']);
        consSQL := 'SELECT cod_centro_custo COD, centro_custo ''CENTRO DE CUSTO'', classificacao CLASSIFICAÇÃO, nivel NÍVEL, TIPO, status ATIVO FROM g_centros_custo WHERE cod_empresa = '''+Param1+''' AND ';
      end;
    'Gerenciador de fotos (Pessoa)':
      begin
        cbCampo_1.Items.AddStrings(['ID','NOME','CPF']);
        consSQL := 'SELECT id_pessoa ID, NOME, CPF FROM p_pessoas WHERE excluido = false AND ';
      end;
    'Usuários':
      begin
        cbCampo_1.Items.AddStrings(['ID','NOME','CPF','CRACHA','COD VÍNCULO','VÍNCULO']);
        consSQL := 'SELECT P.id_pessoa ID, P.nome NOME, P.cpf CPF, C.cracha CRACHA, C.cod_vinculo ''COD VÍNCULO'', (CASE C.cod_vinculo WHEN ''F'' THEN ''Funcionário'' WHEN ''T'' THEN ''Terceiro'' END) VÍNCULO'
                  +' FROM p_pessoas P'
                  +' LEFT JOIN p_cracha C'
                  +'     ON  C.id_pessoa = P.id_pessoa'
                  +' WHERE P.excluido = false'
                  +'      AND C.status = true'
                  +'      AND (C.dt_fim IS NULL or dt_fim = '''')'
                  +'      AND C.cod_vinculo IN (''F'',''T'') AND ';
      end;
    else
      begin
        Application.MessageBox(PChar('Não foram encontrados parâmetros de pesquisa para '''+RefConsulta+''''+#13#13
                              +'- Entre em contato com o administrador do sistema para reportar o problema')
                              ,'Erro'
                              ,MB_ICONERROR + MB_OK);
        Self.Close;
        Abort;
      end;
  end;

  Filtro := '1=1';
  SQLExec(sqlqPesquisa,[consSQL+Filtro]);
end;

procedure TfrmPesquisar.sbtnIncluirCriterioClick(Sender: TObject);
var
  cbCampos, cbCriterios, cbCondicao: TComboBox;
  edtValor1, edtValor2: TEdit;
  sbtnRemoverCriterio: TSpeedButton;
  lblE: TLabel;
  topPos, i: Integer;
  idPenObj: String;
begin
  try
    if nCriterios > 9 then
      begin
        Application.MessageBox(PChar('Não é possível incluir um novo critério pois o número máximo de critérios foi atingido')
                              ,'Aviso'
                              ,MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    nCriterios := nCriterios + 1;
    idObj := idObj+1;
    lblCondicao.Visible := True;
    gpbxCriteriosPesquisa.Height := gpbxCriteriosPesquisa.Height+28;
    Self.Height := Self.Height+28;

    i:=0;
    while i < 9 do
      begin
        if posObjetos[i,1] = 0 then
          begin
            posObjetos[i,1] := idObj;
            posObjeto := i+2;
            //Pega o id do penúltimo campo ativo
            if posObjeto = 2 then
              idPenObj := '1'
            else
              idPenObj := IntToStr(posObjetos[i-1,1]);
            i:=8;
          end;
        i:=i+1;
      end;
    case posObjeto of
      2: topPos := 48;
      3: topPos := 76;
      4: topPos := 104;
      5: topPos := 132;
      6: topPos := 160;
      7: topPos := 188;
      8: topPos := 216;
      9: topPos := 244;
      10: topPos := 272;
    end;

    //Habilita o penúltimo campo de  condição
    (Self.Components[FindComponent('cbCondicao_'+idPenObj).ComponentIndex] as TComboBox).Visible := True;

    //Incluir o combobox dos campos para pesquisa
    cbCampos := TComboBox.Create(Self);
    cbCampos.Parent := gpbxCriteriosPesquisa;
    cbCampos.Name := 'cbCampo_'+IntToStr(idObj);
    cbCampos.Top := topPos;
    cbCampos.Left := 8;
    cbCampos.Width := 85;
    cbCampos.Visible := True;
    cbCampos.Text := '';
    cbCampos.Style := csOwnerDrawFixed;
    //cbCampos.Items.AddStrings(CamposTabela);
    cbCampos.Items := cbCampo_1.Items;
    cbCampos.Hint := 'Campo '+IntToStr(idObj);
    cbCampos.ShowHint := True;

    //Incluir o combobox dos critérios
    cbCriterios := TComboBox.Create(Self);
    cbCriterios.Parent := gpbxCriteriosPesquisa;
    cbCriterios.Name := 'cbCriterio_'+IntToStr(idObj);
    cbCriterios.Top := topPos;
    cbCriterios.Left := 104;
    cbCriterios.Width := 106;
    cbCriterios.Visible := True;
    cbCriterios.Text := '';
    cbCriterios.Style := csOwnerDrawFixed;
    cbCriterios.Items.AddStrings(['é igual','não é igual','contém','não contém','é nulo','não é nulo','está entre','não está entre']);
    cbCriterios.OnChange := @habCampoValor2;
    cbCriterios.Hint := 'Critério '+IntToStr(idObj);;
    cbCriterios.ShowHint := True;

    //Incluir campo de valor1
    edtValor1 := TEdit.Create(Self);
    edtValor1.Parent := gpbxCriteriosPesquisa;
    edtValor1.Name := 'edtValor1_'+IntToStr(idObj);
    edtValor1.Left := 220;
    edtValor1.Top := topPos;
    edtValor1.Width := 150;
    edtValor1.Visible := True;
    edtValor1.Text := '';
    edtValor1.Hint := 'Valor '+IntToStr(idObj);;
    edtValor1.ShowHint := True;

    //Incluir label E
    lblE := TLabel.Create(Self);
    lblE.Parent := gpbxCriteriosPesquisa;
    lblE.Name := 'lblE_'+IntToStr(idObj);
    lblE.Left := 374;
    lblE.Top := topPos+4;
    lblE.Visible := False;
    lblE.Caption := 'E';

    //Incluir campo de valor2
    edtValor2 := TEdit.Create(Self);
    edtValor2.Parent := gpbxCriteriosPesquisa;
    edtValor2.Name := 'edtValor2_'+IntToStr(idObj);
    edtValor2.Left := 384;
    edtValor2.Top := topPos;
    edtValor2.Width := 150;
    edtValor2.Visible := False;
    edtValor2.Text := '';
    edtValor2.Hint := 'Valor final '+IntToStr(idObj);
    edtValor2.ShowHint := True;

    //Incluir o combobox de condições
    cbCondicao := TComboBox.Create(Self);
    cbCondicao.Parent := gpbxCriteriosPesquisa;
    cbCondicao.Name := 'cbCondicao_'+IntToStr(idObj);
    cbCondicao.Top := topPos;
    cbCondicao.Left := 544;
    cbCondicao.Width := 51;
    cbCondicao.Visible := False;
    cbCondicao.Text := '';
    cbCondicao.Style := csOwnerDrawFixed;
    cbCondicao.Items.AddStrings(['E','OU']);
    cbCondicao.Hint := 'Condição '+IntToStr(idObj);;
    cbCondicao.ShowHint := True;

    //Inclui o botão para remover o critério
    sbtnRemoverCriterio := TSpeedButton.Create(Self);
    sbtnRemoverCriterio.Parent := gpbxCriteriosPesquisa;
    sbtnRemoverCriterio.Name := 'sbtnRemoverCriterio_'+IntToStr(idObj);
    sbtnRemoverCriterio.Top := topPos;
    sbtnRemoverCriterio.Left := 599;
    sbtnRemoverCriterio.Width := 23;
    sbtnRemoverCriterio.Height := 23;
    sbtnRemoverCriterio.Caption := '-';
    sbtnRemoverCriterio.Visible := True;
    sbtnRemoverCriterio.Hint := 'Remover critério';
    sbtnRemoverCriterio.ShowHint := True;
    sbtnRemoverCriterio.Font.Bold := True;
    sbtnRemoverCriterio.OnClick := @RemoverCamposCriterio_Click;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao tentar incluir novos campos de critérios'+#13#13
                            +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmPesquisar.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  posX := -1;
  posY := -1;
  nCriterios := 1;
  idObj := 1;
  posObjeto := 0;

  SetLength(posObjetos,9,2);
  i:=0;
  while i < 9 do
    begin
      posObjetos[i,0] := i+2;
      posObjetos[i,1] := 0;
      i:=i+1;
    end;
end;

procedure TfrmPesquisar.cbCriterio_1Change(Sender: TObject);
begin
  if ((cbCriterio_1.Text = 'está entre')
     or (cbCriterio_1.Text = 'não está entre')) then
    begin
      edtValor2_1.Visible := True;
      edtValor1_1.Hint := 'Valor inicial';
      lblE_1.Visible := True;
    end
  else
    begin
      edtValor2_1.Visible := False;
      edtValor1_1.Hint := 'Valor';
      lblE_1.Visible := False;
    end;

  if ((cbCriterio_1.Text = 'é nulo')
     or (cbCriterio_1.Text = 'não é nulo')
     or (cbCriterio_1.Text = 'é verdadeiro')
     or (cbCriterio_1.Text = 'é falso')) then
    begin
      edtValor1_1.Text := '';
      edtValor1_1.Enabled := False;
    end
  else
    begin
      edtValor1_1.Enabled := True;
    end;
end;

procedure TfrmPesquisar.dbgResultadoPesquisaDblClick(Sender: TObject);
begin
  sbtnUtilizar.Click;
end;

procedure TfrmPesquisar.dbgResultadoPesquisaTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgResultadoPesquisa.Columns.Count - 1 do
    dbgResultadoPesquisa.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgResultadoPesquisa.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

function  TfrmPesquisar.Identificador(Sender: TObject): String;
var
  objNome: String;
  sPos, nPos: Integer;
begin
  if (Sender is TSpeedButton) then
    objNome := (Sender as TSpeedButton).Name;

  if (Sender is TComboBox) then
    objNome := (Sender as TComboBox).Name;

  if (Sender is TEdit) then
    objNome := (Sender as TEdit).Name;

  if (Sender is TLabel) then
    objNome := (Sender as TLabel).Name;

  nPos := StrLen(PChar(objNome));
  sPos := Pos('_', objNome);
  Result := Copy(objNome, sPos+1, nPos);
end;

procedure TfrmPesquisar.habCampoValor2(Sender: TObject);
var
  id: String;
  i: Integer;
begin
  try
  id := Identificador(Sender);

  if (((Sender as TComboBox).Text = 'está entre')
     or ((Sender as TComboBox).Text = 'não está entre')) then
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'lblE_'+id then
            (Self.Components[i] as TLabel).Visible := True;
          if Self.Components[i].Name = 'edtValor2_'+id then
            (Self.Components[i] as TEdit).Visible := True;
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Hint := 'Valor inicial '+id;
        end;
    end
  else
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'lblE_'+id then
            (Self.Components[i] as TLabel).Visible := False;
          if Self.Components[i].Name = 'edtValor2_'+id then
            (Self.Components[i] as TEdit).Visible := False;
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Hint := 'Valor '+id;
        end;
    end;

  if (((Sender as TComboBox).Text = 'é nulo')
     or ((Sender as TComboBox).Text = 'não é nulo')
     or (cbCriterio_1.Text = 'é verdadeiro')
     or (cbCriterio_1.Text = 'é falso')) then
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Text := '';
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Enabled := False;
        end;
    end
  else
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Enabled := True;
        end;
    end;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao tentar mostrar/ocultar campo'+#13#13
                            +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmPesquisar.RemoverCamposCriterio_Click(Sender: TObject);
var
  idObjRem_2: String;
begin
  //Recebe o identificador dos objetos que devem ser excluídos
  idObjRem_2 := Identificador(Sender);
  RemoverCamposCriterio(idObjRem_2);
end;

procedure TfrmPesquisar.RemoverCamposCriterio(idObjRem: String);
  var
  i: Integer;
begin
  try
    i := (Self.ComponentCount)-1;
    while i > 0 do
      begin
        //Verifica se o objeto atual possui identificador igual o identificador para exclusão
        if Identificador(Self.Components[i]) = idObjRem then
          Self.Components[i].Free;
        i:=i-1;
      end;

    ReorganizarObjetos(StrToInt(idObjRem));
    Self.Height := Self.Height-28;
    gpbxCriteriosPesquisa.Height := gpbxCriteriosPesquisa.Height-28;
    nCriterios := nCriterios-1;
    idObjRem := EmptyStr;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar destruir objetos dos critérios de pesquisa'+#13#13
                                +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
        end;
      Abort;
    end;
  end;
end;

procedure TfrmPesquisar.ReorganizarObjetos(idObjetoExcluido: Integer);
var
  i, j, p, k, maxPos, novaPos: Integer;
  id, idPenObj, idUltObj: String;
begin
  try
  //Verifica qual a última posição ocupada
  p:=0;
  maxPos:=1;
  while p < 9 do
    begin
      if posObjetos[p,1] > 0 then
        begin
          maxPos := maxPos+1;
          //Pega o id do penúltimo campo de condição visível
          if p > 0 then
            idPenObj := IntToStr(posObjetos[p-1,1])
          else
            idPenObj := '1';
          //Pega o último id id do campo de condição visível
          idUltObj := IntToStr(posObjetos[p,1]);
        end;
      p:=p+1;
    end;

  //Verifica a posição do objeto excluído
  i:=0;
  while i < 9 do
    begin
      if posObjetos[i,1] = idObjetoExcluido then
        begin
          k := posObjetos[i,0];
          posObjetos[i,1] := 0;
          i:=9;
        end;
      i:=i+1;
    end;

  //Oculta o campo condição do penúltimo registro
  if maxPos = 2 then
    begin
      cbCondicao_1.Visible := False;
      lblCondicao.Visible := False;
    end
  else
    begin
      if k < maxPos then
        (Self.Components[FindComponent('cbCondicao_'+idUltObj).ComponentIndex] as TComboBox).Visible := False
      else
        (Self.Components[FindComponent('cbCondicao_'+idPenObj).ComponentIndex] as TComboBox).Visible := False;
    end;

  //se objeto excluído não for da última posição reorganiza os objetos
  if k < maxPos then
    begin
      while k < maxPos do
        begin
          id := IntToStr(posObjetos[k-1,1]);
          case k of
            2: novaPos := 48;
            3: novaPos := 76;
            4: novaPos := 104;
            5: novaPos := 132;
            6: novaPos := 160;
            7: novaPos := 188;
            8: novaPos := 216;
            9: novaPos := 244;
            10: novaPos := 272;
          end;
          j:=0;
          while j < Self.ComponentCount do
            begin
              if Self.Components[j].Name = 'cbCampo_'+id then
                begin
                  (Self.Components[j] as TComboBox).Top := novaPos;
                end;
              if Self.Components[j].Name = 'cbCriterio_'+id then
                begin
                  (Self.Components[j] as TComboBox).Top := novaPos;
                end;
              if Self.Components[j].Name = 'cbCondicao_'+id then
                begin
                  (Self.Components[j] as TComboBox).Top := novaPos;
                end;
              if Self.Components[j].Name = 'edtValor1_'+id then
                begin
                  (Self.Components[j] as TEdit).Top := novaPos;
                end;
              if Self.Components[j].Name = 'edtValor2_'+id then
                begin
                  (Self.Components[j] as TEdit).Top := novaPos;
                end;
              if Self.Components[j].Name = 'lblE_'+id then
                begin
                  (Self.Components[j] as TLabel).Top := novaPos+4;
                end;
              if Self.Components[j].Name = 'sbtnRemoverCriterio_'+id then
                begin
                  (Self.Components[j] as TSpeedButton).Top := novaPos;
                end;
              j:=j+1;
            end;
          posObjetos[k-2,1] := posObjetos[k-1,1];
          posObjetos[k-1,1] := posObjetos[k,1];
          k:=k+1;
        end;
      idObjetoExcluido := 0;
    end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar reorganizar os objetos dos critérios de pesquisa'+#13#13
                                +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
        end;
      Abort;
    end;
  end;
end;

procedure TfrmPesquisar.sbtnLimparPesquisa_999Click(Sender: TObject);
var
  i: Integer;
begin
  try
    CleanForm(Self);

    Filtro := '1=1';
    SQLExec(sqlqPesquisa,[consSQL+Filtro]);

    if nCriterios > 1 then
      begin
        i := 0;
        while i < 9 do
          begin
            if posObjetos[i,1] > 0 then
              RemoverCamposCriterio(IntToStr(posObjetos[i,1]));
            i:=i+1;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar limpar a pesquisa'+#13+#13
                                +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmPesquisar.sbtnPesquisarClick(Sender: TObject);
var
  i, sPos, nCriterio: Integer;
  objNome, objConteudo, objHint, Campo, Criterio, Valor1, Valor2, Condicao: String;
  AddFiltro: Boolean;
begin
  try
    Filtro := EmptyStr;
    AddFiltro := False;
    nCriterio := 0;
    //Rotina da montagem do filtro de pesquisa
    for i:=0 to Self.ComponentCount-1 do
      begin
        if (Self.Components[i] is TComboBox) then
          begin
            objNome := (Self.Components[i] as TComboBox).Name;
            objConteudo := (Self.Components[i] as TComboBox).Text;
            objHint := (Self.Components[i] as TComboBox).Hint;
          end;

        if (Self.Components[i] is TEdit) then
          begin
            objNome := (Self.Components[i] as TEdit).Name;
            objConteudo := (Self.Components[i] as TEdit).Text;
            objHint := (Self.Components[i] as TEdit).Hint;
          end;

        //Extrai o nome do objeto
        sPos := Pos('_', objNome);
        objNome := Copy(objNome, 0, sPos-1);

        //Verifica se os campos estão preenchidos
        if (((objNome = 'cbCampo') and (objConteudo = EmptyStr))
           or ((objNome = 'cbCriterio') and (objConteudo = EmptyStr))
           or ((objNome = 'edtValor1') and ((Self.Components[i] as TEdit).Enabled) and  (objConteudo = EmptyStr))
           or ((objNome = 'edtValor2') and ((Self.Components[i] as TEdit).Visible) and (objConteudo = EmptyStr))
           or ((objNome = 'cbCondicao') and ((Self.Components[i] as TComboBox).Visible) and (objConteudo = EmptyStr))) then
          begin
            Application.MessageBox(PChar('O campo '''+objHint+''' não pode ser vazio')
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            if (Self.Components[i] is TComboBox) then
              begin
               (Self.Components[i] as TComboBox).SetFocus;
               (Self.Components[i] as TComboBox).DroppedDown := True;
              end;
            if (Self.Components[i] is TEdit) then
              (Self.Components[i] as TEdit).SetFocus;
            Exit;
          end;

        //Lê os dados para filtragem
        if (objNome = 'cbCampo') then
          begin
            Campo := (Self.Components[i] as TComboBox).Text;
            nCriterio := nCriterio+1;
            case Campo of
              'RAZÃO SOCIAL': Campo := 'razao_social';
              'COD VÍNCULO':  Campo := 'cod_vinculo';
            end;
          end;

        if (objNome = 'cbCriterio') then
          Criterio := (Self.Components[i] as TComboBox).Text;

        if (objNome = 'edtValor1') then
          if ((Self.Components[i] as TEdit).Enabled) then
            Valor1 := (Self.Components[i] as TEdit).Text;

        if (objNome = 'edtValor2') then
          if ((Self.Components[i] as TEdit).Visible) then
            Valor2 := (Self.Components[i] as TEdit).Text;

        if (objNome = 'cbCondicao') then
          begin
            if ((Self.Components[i] as TComboBox).Visible) then
              Condicao := (Self.Components[i] as TComboBox).Text;
            AddFiltro := True;
          end;

        //Monta o filtro
        if AddFiltro = True then
          begin
            case Condicao of
              'E':  Filtro := Filtro+' AND ';
              'OU': Filtro := Filtro+' OR ';
            end;

            if nCriterio = 1 then
              Filtro := Campo
            else
              Filtro := Filtro+Campo;

            case Criterio of
              'é igual':        Filtro := Filtro+' = '''+Valor1+'''';
              'não é igual':    Filtro := Filtro+' <> '''+Valor1+'''';
              'contém':         Filtro := Filtro+' LIKE ''%'+Valor1+'%''';
              'não contém':     Filtro := Filtro+' NOT LIKE ''%'+Valor1+'%''';
              'está entre':     Filtro := Filtro+' BETWEEN '''+Valor1+''' AND '''+Valor2+'''';
              'não está entre': Filtro := Filtro+' NOT BETWEEN '''+Valor1+''' AND '''+Valor2+'''';
              'é nulo':         Filtro := Filtro+' IS NULL';
              'não é nulo':     Filtro := Filtro+' IS NOT NULL';
              'é verdadeiro':   Filtro := Filtro+ ' = true';
              'é falso':        Filtro := Filtro+ ' = false';
            end;

            AddFiltro := False;
          end;
      end;

    //Rotina de execução da pesquisa
    SQLExec(sqlqPesquisa,[consSQL+Filtro]);

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar executar a pesquisa'+#13+#13
                                +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmPesquisar.sbtnUtilizarClick(Sender: TObject);
begin
  try
  if sqlqPesquisa.Fields.Fields[0].Text = EmptyStr then
    begin
      Application.MessageBox(PChar('Selecione um registro para utilizar')
                            ,'Aviso'
                            ,MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;

  case RefConsulta of
    'Vínculos (Pessoa)':
      begin
        if (((frmVinculos.ID_Pessoa <> EmptyStr)
           and (frmVinculos.ID_Pessoa <> '0'))
           and (frmVinculos.ID_Pessoa <>  sqlqPesquisa.FieldByName('ID').Text))then
          frmVinculos.sbtnTrocarPessoa.Click;

        frmVinculos.edtPessoa_ID.Text := sqlqPesquisa.FieldByName('ID').Text;
        frmVinculos.CarregarPessoa(sqlqPesquisa.FieldByName('ID').Text);
      end;
    'Vínculos (Empresa)':
      begin
        frmVinculos.edtCodEmpresa.Text := sqlqPesquisa.FieldByName('COD').Text;
        frmVinculos.SelEmpresa;
      end;
    'Vínculos (Setor)':
      begin
        frmVinculos.edtCodSetor.Text := sqlqPesquisa.FieldByName('COD').Text;
        frmVinculos.SelSetor;
      end;
    'Vínculos (Função)':
      begin
        frmVinculos.edtCodFuncao.Text := sqlqPesquisa.FieldByName('COD').Text;
        frmVinculos.SelFuncao;
      end;
    'Vínculos (Centro de Custo)':
      begin
        frmVinculos.edtCodCentroCusto.Text := sqlqPesquisa.FieldByName('COD').Text;
        frmVinculos.SelCentroCusto;
      end;
    'Gerenciador de fotos (Pessoa)':
      begin
        if (((frmGerencFotos.ID_Pessoa <> EmptyStr)
           and (frmGerencFotos.ID_Pessoa <> '0'))
           and (frmGerencFotos.ID_Pessoa <>  sqlqPesquisa.FieldByName('ID').Text)) then
          frmGerencFotos.sbtnCancelar.Click;

        frmGerencFotos.ID_Pessoa := sqlqPesquisa.FieldByName('ID').Text;
        frmGerencFotos.sbtnAtualizar.Click;
      end;
    'Usuários':
      begin
        frmUsuarios.edtIDPessoa.Text := sqlqPesquisa.FieldByName('ID').Text;
        frmUsuarios.CarregarPessoa(sqlqPesquisa.FieldByName('ID').Text)
      end
    else
      begin
        Application.MessageBox(PChar('Não foram encontrados parâmetros para o retorno da pesquisa em '''+RefConsulta+''''+#13
                              +'A operação será abortada e não haverão resultados selecionados'+#13#13
                              +'- Entre em contato com o administrador do sistema para reportar o problema')
                              ,'Aviso'
                              ,MB_ICONEXCLAMATION + MB_OK);
        Abort;
      end;
  end;
  Self.Close;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao utilizar o registro'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

end.

