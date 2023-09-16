unit UCadHorariosRefeicoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  DBGrids, LCLType, DBCtrls, ExtCtrls, Buttons, StdCtrls, MaskEdit, Grids, DateUtils;

type

  { TfrmCadHorariosRefeicoes }

  TfrmCadHorariosRefeicoes = class(TForm)
    Bevel1: TBevel;
    cbRefeicao: TComboBox;
    ckbxStatus: TCheckBox;
    dsHorariosRefeicoes: TDataSource;
    dbgHorariosRefeicoes: TDBGrid;
    edtRefeicao: TEdit;
    Label1: TLabel;
    lblHoraInicio: TLabel;
    lblHoraFim: TLabel;
    lblRefeicao1: TLabel;
    lblRefeicao: TLabel;
    medtDataInicio: TMaskEdit;
    medtHoraFim: TMaskEdit;
    pnlCamposBotoes: TPanel;
    pnlCampos: TPanel;
    pnlComandos: TPanel;
    sbtnAtualizar: TSpeedButton;
    sbtnCadastrarHorario: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnEditarHorario: TSpeedButton;
    sbtnEncerrarHorario: TSpeedButton;
    sbtnDeletarHorario: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sqlqHorariosRefeicoes: TSQLQuery;
    sqlqRegRefeicoes: TSQLQuery;
    sqlqHorariosRefeicoesOperacao: TSQLQuery;
    medtHoraInicio: TMaskEdit;
    sqlqParametros: TSQLQuery;
    procedure dbgHorariosRefeicoesMouseLeave(Sender: TObject);
    procedure dbgHorariosRefeicoesMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure dbgHorariosRefeicoesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure dbgHorariosRefeicoesTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure medtHoraInicioDblClick(Sender: TObject);
    procedure medtHoraInicioKeyPress(Sender: TObject; var Key: char);
    procedure sbtnCadastrarHorarioClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnDeletarHorarioClick(Sender: TObject);
    procedure sbtnEditarHorarioClick(Sender: TObject);
    procedure sbtnEncerrarHorarioClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    function VerificaLancamentos(SQL: TSQLQuery; ID_HR_Refeicao: String): Boolean;
  private
    Acao: String;
    Editado: Boolean;
    ToleranciaIniReg, ToleranciaFimReg: TDateTime;
    const
      Modulo: String = 'CADASTROS';
  public

  end;

var
  frmCadHorariosRefeicoes: TfrmCadHorariosRefeicoes;

implementation

uses
  UConexao, UDBO, UGFunc, URegRefeicoes;

{$R *.lfm}

{ TfrmCadHorariosRefeicoes }

procedure TfrmCadHorariosRefeicoes.sbtnAtualizarClick(Sender: TObject);
begin
  try
    SQLQuery(sqlqHorariosRefeicoes,['SELECT id_horario_refeicao ID, refeicao REFEIÇÃO, strftime(''%H:%M'',hora_inicio)''HR INÍCIO'', strftime(''%H:%M'',hora_fim) ''HR FIM'', strftime(''%d/%m/%Y'',dt_inicio) ''DATA INÍCIO'', strftime(''%d/%m/%Y'',dt_fim) ''DATA FIM'', status ATIVO',
                                    'FROM r_horarios_refeicoes',
                                    'ORDER BY dt_inicio DESC, hora_inicio']);

  except on E: exception do
    begin
      FreeAndNil(dbgHorariosRefeicoes);
      Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmCadHorariosRefeicoes.sbtnCancelarClick(Sender: TObject);
begin
  if ((Editado) or (Acao <> EmptyStr)) then
    begin
      if Application.MessageBox(Pchar('Cancelar a edição?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          Clean([edtRefeicao,medtHoraInicio,medtHoraFim,medtDataInicio]);
          Acao := EmptyStr;
          Editado := False;
          pnlCampos.Height := 0;
        end
      else
        Abort;
    end
  else
    begin
      pnlCampos.Height := 0;
    end;
end;

procedure TfrmCadHorariosRefeicoes.sbtnDeletarHorarioClick(Sender: TObject);
begin
  try
    if dbgHorariosRefeicoes.SelectedRangeCount < 0 then
      begin
        Application.MessageBox(PChar('Selecione o registro que deseja excluir'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;
    if not VerificaLancamentos(sqlqRegRefeicoes,dbgHorariosRefeicoes.Columns.Items[0].Field.Text) then
      begin
        Application.MessageBox(PChar('Não é possível excluir o registro selecionado pois existem lançamentos atrelados a ele'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;
    if Application.MessageBox(PChar('Deseja realmente excluir o horário de '+LowerCase(dbgHorariosRefeicoes.Columns.Items[1].Field.Text)+'?'),'Confirmar',MB_ICONQUESTION + MB_YESNO) = MRYES then
      begin
        SQLExec(sqlqHorariosRefeicoesOperacao,['DELETE FROM r_horarios_refeicoes',
                                               'WHERE id_horario_refeicao = '''+dbgHorariosRefeicoes.Columns.Items[0].Field.Text+'''']);

        sbtnAtualizar.Click;
        Log('refeitorio','cadastro horários refeições','excluir horário',dbgHorariosRefeicoes.Columns.Items[0].Field.Text,gID_Usuario_Logado,gUsuario_Logado,'<<horário de refeição '+dbgHorariosRefeicoes.Columns.Items[0].Field.Text+'-'+LowerCase(dbgHorariosRefeicoes.Columns.Items[1].Field.Text)+' excluído>>');
        Application.MessageBox(PChar('Horário excluído com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
      end
    else
      Exit;
  except on e: Exception  do
    begin
      Application.MessageBox(PChar('Falha ao tenar exluir o horário de '+AnsiLowerCase(dbgHorariosRefeicoes.Columns.Items[1].Field.Text)+#13#13+'Classe '+E.ClassName+#13+'Detalhes '+E.Message),'Erro', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmCadHorariosRefeicoes.sbtnEditarHorarioClick(Sender: TObject);
begin
  try
    if dbgHorariosRefeicoes.SelectedRangeCount > 0 then
      begin
        if Acao = EmptyStr then
          begin
            if ((dbgHorariosRefeicoes.Columns.Items[5].Field.Text <> EmptyStr) or  (dbgHorariosRefeicoes.Columns.Items[5].Field.Text <> ''))  then
              begin
                Application.MessageBox(PChar('Não é possível editar o horário de refeição selecionado pois ele já foi encerrado'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
                Exit;
              end;
            if VerificaLancamentos(sqlqRegRefeicoes,dbgHorariosRefeicoes.Columns.Items[0].Field.Text) then
              begin
                Acao := 'EDITAR';
                pnlCampos.Height := 60;
                edtRefeicao.Text := dbgHorariosRefeicoes.Columns.Items[1].Field.Text;
                medtHoraInicio.Text := dbgHorariosRefeicoes.Columns.Items[2].Field.Text;
                medtHoraFim.Text := dbgHorariosRefeicoes.Columns.Items[3].Field.Text;
                medtDataInicio.Text := dbgHorariosRefeicoes.Columns.Items[4].Field.Text;
                if dbgHorariosRefeicoes.Columns.Items[6].Field.AsBoolean then
                  ckbxStatus.Checked := True
                else
                  ckbxStatus.Checked := False;
              end
            else
              begin
                Application.MessageBox(PChar('O horário de refeição selecionado não pode ser editado pois existem lançamentos com ele'+#13#13+'Caso necessário encerre este horário e abra um novo com as definições desejadas'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
              end;
          end;
      end
    else
      begin
        Application.MessageBox(PChar('Selecione um registro para editar'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      end;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao carregar dados para edição'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmCadHorariosRefeicoes.sbtnEncerrarHorarioClick(Sender: TObject);
var
  DataFim: String;
  ConfDataFim, R: Boolean;
begin
  if dbgHorariosRefeicoes.SelectedRangeCount > 0 then
    begin
      if ((dbgHorariosRefeicoes.Columns.Items[5].Field.Text = EmptyStr) or (dbgHorariosRefeicoes.Columns.Items[5].Field.IsNull)) then
        begin
          if Application.MessageBox(PChar('Aviso'+#13+'Após o encerramento não será possível utilizar este horário'+#13#13
                                          +'Deseja proceguir e encerrar o horário de '+LowerCase(dbgHorariosRefeicoes.Columns.Items[1].Field.Text)+'?'),'Confirmar',MB_ICONQUESTION + MB_YESNO) = MRYES then
            begin
              R := False;
              DataFim := FormatDateTime('DD/MM/YYYY',Now);
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
                SQLExec(sqlqHorariosRefeicoesOperacao,['UPDATE r_horarios_refeicoes SET',
                                                       'dt_fim = '''+FormatDateTime('YYYY-MM-DD',StrToDate(DataFim))+'''',
                                                       'WHERE id_horario_refeicao = '+dbgHorariosRefeicoes.Columns.Items[0].Field.Text]);
              finally
                begin
                  sbtnAtualizar.Click;
                  Log('refeitorio','cadastro horários refeições','encerrar horário',dbgHorariosRefeicoes.Columns.Items[0].Field.Text,gID_Usuario_Logado,gUsuario_Logado,'<<horário de refeição '+dbgHorariosRefeicoes.Columns.Items[0].Field.Text+'-'+LowerCase(dbgHorariosRefeicoes.Columns.Items[1].Field.Text)+' encerrado>>');
                  Application.MessageBox(PChar('Horário encerrado com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
                end;
              end;
            end
          else
            Exit;
        end
      else
        begin
          Application.MessageBox(PChar('Este horário de refeição já foi encerrado'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        end;
    end;
end;

procedure TfrmCadHorariosRefeicoes.sbtnSalvarClick(Sender: TObject);
var
  Data, Hora, TextoMsgSalvar, Ativo, ID_RefCadastrado: String;
  DataHoraEdt, DataHoraAdd: TDateTime;
  HoraIni, HoraFim: TTime;
begin
  try
    if edtRefeicao.Text = EmptyStr then
      begin
        Application.MessageBox('Informe a refeição','Aviso', MB_ICONWARNING + MB_OK);
        edtRefeicao.SetFocus;
        Exit;
      end;
    if (medtHoraInicio.Text = EmptyStr) or (medtHoraInicio.Text = '  :  ') then
      begin
        Application.MessageBox('Informe a hora de início','Aviso', MB_ICONWARNING + MB_OK);
        medtHoraInicio.SetFocus;
        Exit;
      end;
    try
      StrToTime(medtHoraInicio.Text);
    Except
      begin
        Application.MessageBox('O horário de início informado é inválido','Aviso', MB_ICONWARNING + MB_OK);
        medtHoraInicio.SetFocus;
        medtHoraInicio.SelectAll;
        Exit;
      end;
    end;
    if (medtHoraFim.Text = EmptyStr) or (medtHoraFim.Text = '  :  ') then
      begin
        Application.MessageBox('Informe a hora de fim','Aviso', MB_ICONWARNING + MB_OK);
        medtHoraFim.SetFocus;
        Exit;
      end;
    try
      StrToTime(medtHoraFim.Text);
    Except
      begin
        Application.MessageBox('O horário de fim informado é inválido','Aviso', MB_ICONWARNING + MB_OK);
        medtHoraFim.SetFocus;
        medtHoraFim.SelectAll;
        Exit;
      end;
    end;
    if (medtDataInicio.Text = EmptyStr) or (medtDataInicio.Text = '  /  /    ') then
      begin
        Application.MessageBox('Informe a data de início','Aviso', MB_ICONWARNING + MB_OK);
        medtDataInicio.SetFocus;
        Exit;
      end;
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

    if ckbxStatus.Checked then
      Ativo := '1'
    else
      Ativo := '0';

    if Acao='ADICIONAR' then
      begin
        SQLExec(sqlqHorariosRefeicoesOperacao,['INSERT INTO r_horarios_refeicoes (refeicao, hora_inicio, hora_fim, dt_inicio, status)',
                                               'VALUES ('''+edtRefeicao.Text+''','''+medtHoraInicio.Text+''','''+medtHoraFim.Text+''','''+FormatDateTime('YYYY-mm-dd',StrToDate(medtDataInicio.Text))+''','''+Ativo+''')']);
        ID_RefCadastrado := SQLQuery(sqlqHorariosRefeicoesOperacao,['SELECT MAX(id_horario_refeicao) id_hrefeicao FROM r_horarios_refeicoes'],'id_hrefeicao');
        Log('refeitorio','cadastro horários refeições','cadastrar horário',ID_RefCadastrado,gID_Usuario_Logado,gUsuario_Logado,'<<horário de refeição '+ID_RefCadastrado+'-'+LowerCase(edtRefeicao.Text)+' cadastrado>>');
      end;
    if Acao='EDITAR' then
      begin
        SQLExec(sqlqHorariosRefeicoesOperacao,['UPDATE r_horarios_refeicoes SET',
                                               'refeicao = '''+edtRefeicao.Text+''', hora_inicio = '''+medtHoraInicio.Text+''', hora_fim = '''+medtHoraFim.Text+''',',
                                               'dt_inicio = '''+FormatDateTime('YYYY-mm-dd',StrToDate(medtDataInicio.Text))+''', status = '''+Ativo+'''',
                                               'WHERE id_horario_refeicao = '+dbgHorariosRefeicoes.Columns.Items[0].Field.Text]);
        Log('refeitorio','cadastro horários refeições','editar horário',dbgHorariosRefeicoes.Columns.Items[0].Field.Text,gID_Usuario_Logado,gUsuario_Logado,'<<horário de refeição '+dbgHorariosRefeicoes.Columns.Items[0].Field.Text+'-'+LowerCase(dbgHorariosRefeicoes.Columns.Items[1].Field.Text)+' editado>>');
      end;
    if Acao = 'ADICIONAR' then
      TextoMsgSalvar := 'cadastrado'
    else
    if Acao = 'EDITAR' then
      TextoMsgSalvar := 'editado';
    Application.MessageBox(PChar('Horário '+ TextoMsgSalvar +' com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
    Acao := EmptyStr;
    sbtnAtualizar.Click;
    pnlCampos.Height := 0;
  finally
  end;
end;

procedure TfrmCadHorariosRefeicoes.FormShow(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,Modulo,'CADHRCAD') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  Editado := False;
  sbtnAtualizar.Click;
end;

procedure TfrmCadHorariosRefeicoes.medtHoraInicioDblClick(Sender: TObject);
begin
  if medtHoraInicio.ReadOnly then
    medtHoraInicio.ReadOnly := False
  else
    medtHoraInicio.ReadOnly := True;
end;

procedure TfrmCadHorariosRefeicoes.medtHoraInicioKeyPress(Sender: TObject; var Key: char);
begin
  Editado := True;
end;

procedure TfrmCadHorariosRefeicoes.FormCreate(Sender: TObject);
begin
  pnlCampos.Height := 0;

  if CheckPermission(UserPermissions,Modulo,'CADHRADD') then
    sbtnCadastrarHorario.Enabled := True
  else
    sbtnCadastrarHorario.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADHREDT') then
    sbtnEditarHorario.Enabled := True
  else
    sbtnEditarHorario.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADHRENC') then
    sbtnEncerrarHorario.Enabled := True
  else
    sbtnEncerrarHorario.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'CADHRDEL') then
    sbtnDeletarHorario.Enabled := True
  else
    sbtnDeletarHorario.Enabled := False;
end;

procedure TfrmCadHorariosRefeicoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnSalvar.Click;
end;

procedure TfrmCadHorariosRefeicoes.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    begin
      Key := #0;
      SelectNext(ActiveControl,True,True);
      Exit;
    end;
end;

procedure TfrmCadHorariosRefeicoes.dbgHorariosRefeicoesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  try
    with (Sender As TDBGrid) do
      begin
        if not sqlqHorariosRefeicoes.Fields[6].AsBoolean then
          begin
            Canvas.Brush.Color := clMenu;
            Canvas.Font.Color := clGrayText;
            Canvas.Font.Style := [fsBold];
          end;
        if not sqlqHorariosRefeicoes.Fields[5].IsNull then
          begin
            Canvas.Brush.Color := clMenu;
            Canvas.Font.Color := clActiveCaption;
            Canvas.Font.Style := [fsBold];
          end;
      end;
  except
    begin
      FreeAndNil(Sender);
      Exit;
    end;
  end;
end;

procedure TfrmCadHorariosRefeicoes.dbgHorariosRefeicoesTitleClick(
  Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgHorariosRefeicoes.Columns.Count - 1 do
    dbgHorariosRefeicoes.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgHorariosRefeicoes.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

procedure TfrmCadHorariosRefeicoes.FormClose(Sender: TObject;
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

procedure TfrmCadHorariosRefeicoes.dbgHorariosRefeicoesMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  mousePt: TGridcoord;
begin
  mousePt := dbgHorariosRefeicoes.MouseCoord(x,y);
  if mousePt.y = 0 then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmCadHorariosRefeicoes.dbgHorariosRefeicoesMouseLeave(
  Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfrmCadHorariosRefeicoes.sbtnCadastrarHorarioClick(Sender: TObject);
begin
  if Acao = EmptyStr then
    begin
      Clean([edtRefeicao,medtHoraInicio,medtHoraFim,medtDataInicio]);
      pnlCampos.Height := 60;
      Acao := 'ADICIONAR';
      edtRefeicao.SetFocus;
      medtDataInicio.Text := DateToStr(Now);
      ckbxStatus.Checked := True;
    end;
end;

function TfrmCadHorariosRefeicoes.VerificaLancamentos(SQL: TSQLQuery; ID_HR_Refeicao: String): Boolean;
begin
  try
    SQLQuery(SQL,['SELECT COUNT(R.id_reg_refeicao) NREG',
                  'FROM r_reg_refeicoes R',
                  'INNER JOIN r_refeicoes F ON F.id_refeicao = R.id_refeicao',
                  'INNER JOIN r_horarios_refeicoes H ON H.id_horario_refeicao = F.id_horario_refeicao',
                  'WHERE H.id_horario_refeicao = '''+ID_HR_Refeicao+'''']);
    if sqlqRegRefeicoes.Fields[0].AsInteger = 0 then
      Result := True
    else
      Result := False;
  except on E: Exception do
    begin

    end;
  end;
end;

end.

