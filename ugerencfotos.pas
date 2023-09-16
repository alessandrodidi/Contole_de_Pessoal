unit UGerencFotos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLType, PairSplitter, ComCtrls, Buttons, DBGrids, StdCtrls, MaskEdit, Menus,
  ExtDlgs, Arrow, EditBtn, BCButton, BGRAImageManipulation, BGRAShape,
  BCGameGrid;

type

  { TfrmGerencFotos }

  TfrmGerencFotos = class(TForm)
    bcbtnAddFoto: TBCButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ckbxStatus: TCheckBox;
    dsFotos: TDataSource;
    dbgFotos: TDBGrid;
    edtZoom: TEdit;
    edtIdFoto: TEdit;
    gpbxInfoFoto: TGroupBox;
    gpbxPreview: TGroupBox;
    imgPreviewFoto: TImage;
    lblDimensoes: TLabel;
    lblDimensoesFoto: TLabel;
    lblIdFoto: TLabel;
    lblDataInicio: TLabel;
    lblDataFim: TLabel;
    medtDataInicio: TMaskEdit;
    medtDataFim: TMaskEdit;
    opdAbrirFoto: TOpenPictureDialog;
    pnlComandosFoto: TPanel;
    ppmniAbrirFoto: TMenuItem;
    ppmniCapturarFoto: TMenuItem;
    pnlComandosOper: TPanel;
    pnlEsqTitulo: TPanel;
    ppmnAddFoto: TPopupMenu;
    pstConteudo: TPairSplitter;
    pstsEsquerdo: TPairSplitterSide;
    pstsDireito: TPairSplitterSide;
    pnlComandos: TPanel;
    sbtnAtualizar: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnEditarFoto: TSpeedButton;
    sbtnExcluirFoto: TSpeedButton;
    sbtnLocalizarPessoa: TSpeedButton;
    sbtnAjustarATela: TSpeedButton;
    sbtnAumentarZoom: TSpeedButton;
    sbtnDiminuirZoom: TSpeedButton;
    sbtnTamanhoReal: TSpeedButton;
    sqlqFotos: TSQLQuery;
    sqlqFotosOperacoes: TSQLQuery;
    sqlqFotosOperacoesid_pessoa: TLongintField;
    procedure dbgFotosSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure dbgFotosTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure imgPreviewFotoClick(Sender: TObject);
    procedure ppmniAbrirFotoClick(Sender: TObject);
    procedure ppmniCapturarFotoClick(Sender: TObject);
    procedure sbtnAddFotoClick(Sender: TObject);
    procedure sbtnAjustarATelaClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnAumentarZoomClick(Sender: TObject);
    procedure sbtnDiminuirZoomClick(Sender: TObject);
    procedure sbtnEditarFotoClick(Sender: TObject);
    procedure sbtnExcluirFotoClick(Sender: TObject);
    procedure sbtnLocalizarPessoaClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnTamanhoRealClick(Sender: TObject);
    function StreamToHex(ms: TMemoryStream): string;
  private
    Acao, formOrigem: String;
    Editado: Boolean;
    Foto: TJPEGImage;
    ftW, ftH: Integer;
  const
      Modulo: String = 'CADASTROS';
  public
    formPai, ID_Pessoa: String;
  end;

var
  frmGerencFotos: TfrmGerencFotos;

implementation

uses
  UGFunc, UDBO, UConexao, UPesquisar;

{$R *.lfm}

{ TfrmGerencFotos }

procedure TfrmGerencFotos.FormShow(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,Modulo,'CADFTCAD') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
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
    end
  else
    begin
      sbtnLocalizarPessoa.Enabled := False;
    end;

  if (ID_Pessoa <> EmptyStr)
     and (ID_Pessoa <> '0') then
    begin
      sbtnAtualizar.Enabled := True;
      bcbtnAddFoto.Enabled := True;
      sbtnEditarFoto.Enabled := True;
      sbtnExcluirFoto.Enabled := True;
      sbtnAtualizar.Click;
    end
  else
    begin
      sbtnAtualizar.Enabled := False;
      bcbtnAddFoto.Enabled := False;
      sbtnEditarFoto.Enabled := False;
      sbtnExcluirFoto.Enabled := False;
      Self.Caption := 'Gerenciador de fotos [<<Selecionar pessoa>>]';
    end;

  Editado := False;
  Acao := EmptyStr;
end;

procedure TfrmGerencFotos.imgPreviewFotoClick(Sender: TObject);
begin

end;

procedure TfrmGerencFotos.ppmniAbrirFotoClick(Sender: TObject);

begin
  if Editado then
    sbtnCancelar.Click;

  if opdAbrirFoto.Execute then
    imgPreviewFoto.Picture.LoadFromFile(opdAbrirFoto.FileName);

  Acao := 'ADICIONAR';
  medtDataInicio.Text := FormatDateTime('DD/MM/YYYY', now);
  medtDataInicio.Enabled := True;
  if CheckPermission(UserPermissions,Modulo,'CADFTSTS') then
    ckbxStatus.Enabled := True
  else
    ckbxStatus.Enabled := False;
end;

procedure TfrmGerencFotos.ppmniCapturarFotoClick(Sender: TObject);
begin
  if Editado then
    sbtnCancelar.Click;

  Acao := 'ADICIONAR';
  medtDataInicio.Text := FormatDateTime('DD/MM/YYYY', now);
  if CheckPermission(UserPermissions,Modulo,'CADFTSTS') then
    ckbxStatus.Enabled := True
  else
    ckbxStatus.Enabled := False;
end;

procedure TfrmGerencFotos.sbtnAddFotoClick(Sender: TObject);
var
  APoint: TPoint;
begin
  if Editado then
    sbtnCancelar.Click;

  APoint.x := 0;
  APoint.y := 0;
  APoint := bcbtnAddFoto.ClientToScreen(APoint);
  bcbtnAddFoto.DropdownMenu.PopUp(APoint.X,APoint.Y+bcbtnAddFoto.Height);
end;

procedure TfrmGerencFotos.sbtnAjustarATelaClick(Sender: TObject);
begin
  imgPreviewFoto.Align := alClient;
end;

procedure TfrmGerencFotos.FormCreate(Sender: TObject);
begin
  if CheckPermission(UserPermissions,Modulo,'CADFTADD') then
    begin
      bcbtnAddFoto.Enabled := True;
    end
  else
    begin
      bcbtnAddFoto.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'CADFTEDT') then
    begin
      sbtnEditarFoto.Enabled := True;
    end
  else
    begin
      sbtnEditarFoto.Enabled := False;
    end;

  {if CheckPermission(UserPermissions,Modulo,'CADFTSTS') then
    begin
      ckbxStatus.Enabled := True;
    end
  else
    begin
      ckbxStatus.Enabled := False;
    end;}

  if CheckPermission(UserPermissions,Modulo,'CADFTDEL') then
    begin
      sbtnExcluirFoto.Enabled := True;
    end
  else
    begin
      sbtnExcluirFoto.Enabled := False;
    end;
end;

procedure TfrmGerencFotos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnSalvar.Click;
end;

procedure TfrmGerencFotos.dbgFotosTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgFotos.Columns.Count - 1 do
    dbgFotos.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgFotos.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

procedure TfrmGerencFotos.FormClose(Sender: TObject;
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
          begin
            Abort;
          end;
      end;
    end
  else
    CloseAllFormOpenedConnections(Self);
end;

procedure TfrmGerencFotos.dbgFotosSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  try
    if (not (sqlqFotos.FieldByName('id_foto').IsNull)
       and (sqlqFotos.FieldByName('id_foto').Text <> '0')
       and (sqlqFotos.FieldByName('id_foto').Text <> EmptyStr)) then
      begin
        edtIdFoto.Text := sqlqFotos.FieldByName('id_foto').Text;
        medtDataInicio.Text := sqlqFotos.FieldByName('dt_inicio').Text;
        medtDataFim.Text := sqlqFotos.FieldByName('dt_fim').Text;
        if sqlqFotos.FieldByName('status').AsBoolean then
          ckbxStatus.Checked := True
        else
          ckbxStatus.Checked := False;

        LoadImage(sqlqFotos.FieldByName('foto'),imgPreviewFoto);
        lblDimensoes.Visible := True;
        //lblDimensoesFoto.Visible := True;
        ftW := StrToInt(GetImageSize(sqlqFotos.FieldByName('foto'))[0]);
        ftH := StrToInt(GetImageSize(sqlqFotos.FieldByName('foto'))[1]);
        lblDimensoes.Caption := IntToStr(ftW)+' x '+IntToStr(ftH)+' pixels';
      end
    else
      begin
        lblDimensoes.Visible := False;
        //lblDimensoesFoto.Visible := False;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar visualizar a foto selecionada'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmGerencFotos.sbtnAtualizarClick(Sender: TObject);
begin
  try
    if (ID_Pessoa = EmptyStr)
       and (ID_Pessoa = '0') then
      begin
        Application.MessageBox(PChar('Selecione a pessoa para poder visualizar as fotos atreladas ao cadastro'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end
    else
      begin
        sbtnAtualizar.Enabled := True;
        bcbtnAddFoto.Enabled := True;
        sbtnEditarFoto.Enabled := True;
        sbtnExcluirFoto.Enabled := True;
      end;
      //Limpa os dados previamente carregados
      CleanForm(Self);
      imgPreviewFoto.Picture.Clear;

      SQLQuery(sqlqFotos,['SELECT F.id_foto, F.id_pessoa, F.foto, F.dt_inicio, F.dt_fim, F.status, P.nome',
                          'FROM p_pessoas P',
                               'LEFT JOIN p_fotos F ON P.id_pessoa = F.id_pessoa',
                          'WHERE P.id_pessoa = '+ID_Pessoa]);

    dbgFotos.Columns[0].Field := sqlqFotos.FieldByName('id_foto');
    dbgFotos.Columns[0].Width := 40;
    dbgFotos.Columns[0].Title.Caption := 'ID';
    dbgFotos.Columns[1].Field := sqlqFotos.FieldByName('id_pessoa');
    dbgFotos.Columns[1].Width := 0;
    dbgFotos.Columns[2].Field := sqlqFotos.FieldByName('foto');
    dbgFotos.Columns[2].Width := 0;
    dbgFotos.Columns[3].Field := sqlqFotos.FieldByName('dt_inicio');
    dbgFotos.Columns[3].Width := 70;
    dbgFotos.Columns[3].Title.Caption := 'DT INICÍO';
    dbgFotos.Columns[4].Field := sqlqFotos.FieldByName('dt_fim');
    dbgFotos.Columns[4].Width := 70;
    dbgFotos.Columns[4].Title.Caption := 'DT FIM';
    dbgFotos.Columns[5].Field := sqlqFotos.FieldByName('status');
    dbgFotos.Columns[5].Width := 40;
    dbgFotos.Columns[5].Title.Caption := 'ATIVO';
    dbgFotos.Columns[6].Field := sqlqFotos.FieldByName('nome');
    dbgFotos.Columns[6].Width := 0;

    Self.Caption := 'Gerenciador de fotos ['+sqlqFotos.FieldByName('nome').Text+']';
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar carregar os dados'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmGerencFotos.sbtnAumentarZoomClick(Sender: TObject);
var
  zoomW,zoomH: Integer;
begin
  imgPreviewFoto.Align := alNone;
  //imgPreviewFoto.Proportional := False;
  imgPreviewFoto.Stretch := False;
  if (edtZoom.Text <> EmptyStr)
     and (StrToInt(edtZoom.Text) >= 0) then
    begin
      edtZoom.Text := IntToStr(StrToInt(edtZoom.Text)+1);
      zoomW := Round((ftW*(StrToInt(edtZoom.Text)/100)));
      zoomH := Round((ftH*(StrToInt(edtZoom.Text)/100)));
      SetImageSize(imgPreviewFoto,zoomW,zoomH);
    end;
end;

procedure TfrmGerencFotos.sbtnDiminuirZoomClick(Sender: TObject);
var
  zoomW,zoomH: Integer;
begin
  imgPreviewFoto.Align := alNone;
  //imgPreviewFoto.Proportional := False;
  imgPreviewFoto.Stretch := False;
  if (edtZoom.Text <> EmptyStr)
     and (StrToInt(edtZoom.Text) >= 0) then
    begin
      edtZoom.Text := IntToStr(StrToInt(edtZoom.Text)-1);
      zoomW := Round((ftW*(StrToInt(edtZoom.Text)/100)));
      zoomH := Round((ftH*(StrToInt(edtZoom.Text)/100)));
      SetImageSize(imgPreviewFoto,zoomW,zoomH);
    end;
  //showmessage(IntToStr(zoomW)+' x '+IntToStr(zoomH));
end;

procedure TfrmGerencFotos.sbtnEditarFotoClick(Sender: TObject);
var
  JPEG: TJPEGImage;
  vStream: TMemoryStream;
begin
  try
    if ((sqlqFotos.FieldByName('id_foto').IsNull)
       or (sqlqFotos.FieldByName('id_foto').Text = '0')
       or (sqlqFotos.FieldByName('id_foto').Text = EmptyStr)) then
      begin
        Application.MessageBox(Pchar('Selecione uma foto para edição'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if (not (sqlqFotos.FieldByName('id_foto').IsNull)
       and (sqlqFotos.FieldByName('id_foto').Text <> '0')
       and (sqlqFotos.FieldByName('id_foto').Text <> EmptyStr)) then
      begin
        medtDataInicio.Enabled := True;
        medtDataFim.Enabled := True;
        if CheckPermission(UserPermissions,Modulo,'CADFTSTS') then
          ckbxStatus.Enabled := True;

        Acao := 'EDITAR';
      end
    else
      begin
        medtDataInicio.Enabled := False;
        medtDataFim.Enabled := False;
        ckbxStatus.Enabled := False;
      end;
  except on E: Exception do
    begin
      FreeAndNil(sqlqFotos);
      FreeAndNil(imgPreviewFoto);
      Application.MessageBox(PChar('Erro ao carregar os dados para edição'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmGerencFotos.sbtnExcluirFotoClick(Sender: TObject);
begin
  try
    if ((sqlqFotos.FieldByName('id_foto').IsNull)
       or (sqlqFotos.FieldByName('id_foto').Text = '0')
       or (sqlqFotos.FieldByName('id_foto').Text = EmptyStr)) then
      begin
        Application.MessageBox(Pchar('Selecione a foto que deseja excluir'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if Application.MessageBox(PChar('Deseja realmente excluir a foto selecionada?'), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
      begin
        SQLExec(sqlqFotosOperacoes,['DELETE FROM p_fotos',
                                    'WHERE id_foto = '''+sqlqFotos.FieldByName('id_foto').Text+'''']);

        Application.MessageBox(PChar('Foto excluída com sucesso!'), 'Aviso', MB_ICONINFORMATION + MB_OK);
        sbtnAtualizar.Click;
      end
    else
      Abort;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar excluir a foto selecionada'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmGerencFotos.sbtnLocalizarPessoaClick(Sender: TObject);
begin
  frmPesquisar := TfrmPesquisar.Create(Self);
  frmPesquisar.RefConsulta := 'Gerenciador de fotos (Pessoa)';
  frmPesquisar.ShowModal;
end;

procedure TfrmGerencFotos.sbtnSalvarClick(Sender: TObject);
var
  Ativo, TextoMsgSalvar, Dt_Fim: String;
  vStream: TMemoryStream;
 buf : array[1..20] of char;
begin
  try
    if ((medtDataInicio.Text = EmptyStr)
       or (medtDataInicio.Text = '  /  /    ')) then
      begin
        Application.MessageBox(PChar('Informe a data de início de uso da foto'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataInicio.SetFocus;
        Exit;
      end;

    if not TryStrToDate(medtDataInicio.Text) then
      begin
        Application.MessageBox(PChar('A data de início informada é inválida'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataInicio.SetFocus;
        medtDataInicio.SelectAll;
        Exit;
      end;

    if (((medtDataFim.Text <> EmptyStr)
        and (medtDataFim.Text <> '  /  /    '))
       and (not TryStrToDate(medtDataFim.Text))) then
      begin
        Application.MessageBox(PChar('A data final informada é inválida'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        medtDataFim.SetFocus;
        medtDataFim.SelectAll;
        Exit;
      end;

    //Verifica se data início é maior que a data fim
    if ((medtDataInicio.Text <> EmptyStr)
        and (medtDataInicio.Text <> '  /  /    '))
       and ((medtDataFim.Text <> EmptyStr)
        and (medtDataFim.Text <> '  /  /    ')) then
      begin
        if (StrToDate(medtDataInicio.Text) > StrToDate(medtDataFim.Text)) then
          begin
            Application.MessageBox(PChar('A data inicial não pode ser maior que a data final'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            medtDataFim.SetFocus;
            medtDataFim.SelectAll;
            Exit;
          end;
      end;

    if (medtDataFim.Text <> EmptyStr)
       and (medtDataFim.Text <> '  /  /    ') then
      Dt_Fim := FormatDateTime('YYYY-mm-dd',StrToDate(medtDataFim.Text))
    else
      Dt_Fim := '1900-01-01';

    if ckbxStatus.Checked then
      Ativo := '1'
    else
      Ativo := '0';

    vStream := TMemoryStream.Create;
    imgPreviewFoto.Picture.SaveToStream(vStream);

    if Acao='ADICIONAR' then
      begin
        {SQLExec(sqlqFotosOperacoes,['INSERT INTO p_fotos (id_pessoa, foto, dt_inicio, dt_fim, status)',
                                    'VALUES ('''+ID_Pessoa+''','''+imgPreviewFoto.Picture.Graphic.ToString+''','''+FormatDateTime('YYYY-mm-dd',StrToDate(medtDataInicio.Text))+''',',
                                    '(CASE '+Dt_Fim+' WHEN '+'1900-01-01'+' THEN NULL ELSE '''+Dt_Fim+''' END),'''+Ativo+''')']);
        //sqlqFotosOperacoes.ParamByName('foto').LoadFromStream(vStream,ftGraphic); }
        {sqlqFotosOperacoes.Close;
        sqlqFotosOperacoes.SQL.Clear;
        sqlqFotosOperacoes.SQL.Add('INSERT INTO p_fotos (id_pessoa, dt_inicio, dt_fim, status)');
        sqlqFotosOperacoes.FieldByName('id_pessoa').Text := ID_Pessoa;
        sqlqFotosOperacoes.FieldByName('dt_inicio').Text := FormatDateTime('YYYY-mm-dd',StrToDate(medtDataInicio.Text));
        if (medtDataFim.Text <> EmptyStr)
           and (medtDataFim.Text <> '  /  /    ') then
          sqlqFotosOperacoes.FieldByName('dt_fim').Text := FormatDateTime('YYYY-mm-dd',StrToDate(medtDataFim.Text))
        else
          sqlqFotosOperacoes.FieldByName('dt_fim').Text := Null;
        sqlqFotosOperacoes.FieldByName('status').AsBoolean := ckbxStatus.Checked;
        sqlqFotosOperacoes.ExecSQL;}

        //ShowMessage(vStream.);

        sqlqFotosOperacoes.Close;
        sqlqFotosOperacoes.SQL.Add('SELECT * FROM p_fotos');
        sqlqFotosOperacoes.Active:=True;
   sqlqFotosOperacoes.Open;
   vStream := TMemoryStream.Create;
   sqlqFotosOperacoes.Insert;
   sqlqFotosOperacoes.CreateBlobStream(sqlqFotosOperacoes.FieldByName('FOTO'),bmWrite);
   vStream.Position := 0;
   //imgPreviewFoto.Picture.Bitmap.LoadFromStream(vStream);
   vStream.Free;


      end;
    if Acao='EDITAR' then
      begin
        {SQLExec(sqlqHorariosRefeicoesOperacao,['UPDATE p_fotos SET',
                                               'refeicao = '''+edtRefeicao.Text+''', hora_inicio = '''+medtHoraInicio.Text+''', hora_fim = '''+medtHoraFim.Text+''',',
                                               'dt_inicio = '''+FormatDateTime('YYYY-mm-dd',StrToDate(medtDataInicio.Text))+''', status = '''+Ativo+'''',
                                               'WHERE id_horario_refeicao = '+dbgHorariosRefeicoes.Columns.Items[0].Field.Text]);}
      end;
    if Acao = 'ADICIONAR' then
      TextoMsgSalvar := 'cadastrada'
    else
    if Acao = 'EDITAR' then
      TextoMsgSalvar := 'editada';

    Application.MessageBox(PChar('Foto '+ TextoMsgSalvar +' com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
    Acao := EmptyStr;
    medtDataInicio.Enabled := False;
    medtDataFim.Enabled := False;
    ckbxStatus.Enabled := False;
    sbtnAtualizar.Click;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar salvar as modificações'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmGerencFotos.sbtnTamanhoRealClick(Sender: TObject);
begin
  imgPreviewFoto.Align := alNone;
  edtZoom.Text := '100';
end;

function TfrmGerencFotos.StreamToHex(ms: TMemoryStream): string;
var
  i: Integer;
  tam: longint;
  v: byte;
  txt: string;
  TextoHex: String;
begin
  tam := ms.Size;
  ms.Position := 0;
  //TextoHex := '';
  for i := 1 to tam do
  begin
    ms.Read(v, 1);
    result := result + inttohex(v, 2);
  end;
end;

end.

