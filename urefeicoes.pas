unit URefeicoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  DBGrids, LCLType, DBCtrls, ExtCtrls, Buttons, StdCtrls, MaskEdit, Grids,
  DateUtils, eventlog;

type

  { TfrmRefeicoes }

  TfrmRefeicoes = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    cbRefeicao: TComboBox;
    dsHorariosRefeicoes: TDataSource;
    dbgRefeicoes: TDBGrid;
    lblHorario: TLabel;
    lblRefeicao1: TLabel;
    lkcbHorariosRefeicoes: TDBLookupComboBox;
    dsRefeicoes: TDataSource;
    lblRefeicao: TLabel;
    pnlCampos: TPanel;
    pnlComandos: TPanel;
    sbtnAtualizar: TSpeedButton;
    sbtnAbrirPeriodo: TSpeedButton;
    sbtnEditarPeriodo: TSpeedButton;
    sbtnEncerrarPeriodo: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnCancelar: TSpeedButton;
    sbtnHorario: TSpeedButton;
    sbtnRegRefeicoesTerminal: TSpeedButton;
    sbtnRegRefeicoesManual: TSpeedButton;
    sqlqHorariosRefeicoes: TSQLQuery;
    sqlqRefeicoes: TSQLQuery;
    sqlqRefeicoesOperacao: TSQLQuery;
    medtHorario: TMaskEdit;
    sqlqParametros: TSQLQuery;
    procedure dbgRefeicoesMouseLeave(Sender: TObject);
    procedure dbgRefeicoesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgRefeicoesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure dbgRefeicoesTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lkcbHorariosRefeicoesDropDown(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lkcbHorariosRefeicoesSelect(Sender: TObject);
    procedure medtHorarioDblClick(Sender: TObject);
    procedure medtHorarioKeyPress(Sender: TObject; var Key: char);
    procedure medtHorarioMouseLeave(Sender: TObject);
    procedure sbtnAbrirPeriodoClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnCancelarClick(Sender: TObject);
    procedure sbtnEditarPeriodoClick(Sender: TObject);
    procedure sbtnEncerrarPeriodoClick(Sender: TObject);
    procedure sbtnHorarioClick(Sender: TObject);
    procedure sbtnRegRefeicoesTerminalClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
  private
    Acao: String;
    Editado: Boolean;
    ToleranciaIniReg, ToleranciaFimReg: TDateTime;
    const
      Modulo: String = 'REFEITORIO';
  public

  end;

var
  frmRefeicoes: TfrmRefeicoes;

implementation

uses
  UConexao, UDBO, UGFunc, URegRefeicoes, UCadHorariosRefeicoes;

{$R *.lfm}

{ TfrmRefeicoes }

procedure TfrmRefeicoes.sbtnAtualizarClick(Sender: TObject);
begin
  try
    dsRefeicoes.Enabled := False;
    SQLExec(sqlqRefeicoes,['SELECT R.id_refeicao ID, H.refeicao REFEIÇÃO, R.dth_abertura ''DT/HR ABERTURA''',
                           ',R.usuario_abertura ''USUÁRIO  ABERTURA'', R.dth_fechamento ''DT/HR FECHAMENTO'', R.usuario_fechamento ''USUÁRIO FECHAMENTO''',
                           ',R.id_horario_refeicao',
                           'FROM r_refeicoes R',
                           'LEFT OUTER JOIN r_horarios_refeicoes H ON H.id_horario_refeicao = R.id_horario_refeicao',
                           'ORDER BY R.dth_abertura DESC']);
    dsRefeicoes.Enabled := True;
    dbgRefeicoes.Columns[6].Width := 0;

    SQLExec(sqlqHorariosRefeicoes,['SELECT id_horario_refeicao, strftime(''%H:%M'',hora_inicio)||'' às ''||strftime(''%H:%M'',hora_fim)||''  ''||refeicao AS hr_refeicao, hora_inicio, hora_fim, refeicao, strftime(''%Y-%m-%d'',dt_inicio), strftime(''%Y-%m-%d'',dt_fim)',
                                   'FROM r_horarios_refeicoes',
                                   'WHERE status = 1',
                                   'and (strftime(''%Y-%m-%d'',dt_inicio) <= strftime(''%Y-%m-%d'',''now''))',
                                   'and ((strftime(''%Y-%m-%d'',dt_fim) >= strftime(''%Y-%m-%d'',''now'')) or dt_fim is null)',
                                   'ORDER BY hora_inicio, hora_fim']);
    lkcbHorariosRefeicoes.ListField := 'hr_refeicao';
    lkcbHorariosRefeicoes.KeyField := 'id_horario_refeicao';
    lkcbHorariosRefeicoes.Refresh;

    //Consulta os parametros do módulo
    SQLExec(sqlqParametros,['SELECT modulo, cod_config, param1, param2, param3, imagem, status',
                            'FROM g_parametros',
                            'WHERE modulo = '''+Modulo+'''']);

    //Carrega o tempo de tolerancia para iniciar e finlizar registros
    sqlqParametros.Filter := 'cod_config = ''REFRGTOINI''';
    sqlqParametros.Filtered := True;
    ToleranciaIniReg := sqlqParametros.Fields[2].AsDateTime;
    sqlqParametros.Filter := '';
    sqlqParametros.Filtered := False;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          dbgRefeicoes.Free;
          Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmRefeicoes.sbtnCancelarClick(Sender: TObject);
begin
  if ((Editado)
     or (Acao <> EmptyStr)) then
    begin
      if Application.MessageBox(Pchar('Cancelar a edição?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
        begin
          if Acao = 'ADICIONAR' then
            begin
              Clean([lkcbHorariosRefeicoes]);
              medtHorario.Text := '00:00';
            end;
          if Acao = 'EDITAR' then
            begin
              //Clean([lkcbHorariosRefeicoes]);
              lkcbHorariosRefeicoes.ItemIndex := -1;
              medtHorario.Text := '00:00';
            end;
          medtHorario.Enabled := False;
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

procedure TfrmRefeicoes.sbtnEditarPeriodoClick(Sender: TObject);
var
  sqlqHR: TSQLQuery;
begin
  try
    if dbgRefeicoes.SelectedRangeCount > 0 then
      begin
        if Acao = EmptyStr then
          begin
            if ((dbgRefeicoes.Columns.Items[4].Field.Text = EmptyStr)
               or  (dbgRefeicoes.Columns.Items[4].Field.Text = ''))  then
              begin
                Acao := 'EDITAR';
                pnlCampos.Height := 60;
                sqlqHR := TSQLQuery.Create(Self);
                sqlqHR.SQLConnection := dmConexao.ConexaoDB;
                sqlqHR.Transaction := dmConexao.sqltTransactions;
                sqlqHR.SQL.Clear;
                sqlqHR.SQL.Add('SELECT  strftime(''%H:%M'',hora_inicio)||'' às ''||strftime(''%H:%M'',hora_fim)||''  ''||refeicao AS hr_refeicao '
                              +'FROM r_horarios_refeicoes '
                              +'WHERE id_horario_refeicao = '''+dbgRefeicoes.Columns.Items[6].Field.Text+'''');
                sqlqHR.Active := True;
                lkcbHorariosRefeicoes.ItemIndex := lkcbHorariosRefeicoes.Items.IndexOf(sqlqHR.FieldByName('hr_refeicao').AsString);
                sqlqHR.Free;
                medtHorario.Text := FormatDateTime('hh:mm',dbgRefeicoes.Columns.Items[2].Field.AsDateTime);
                medtHorario.Enabled := True;
              end
            else
              begin
                Application.MessageBox(PChar('Não é possível editar este período pois ele já foi encerrado'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
              end;
          end;
      end;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao carregar dados para edição'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmRefeicoes.sbtnEncerrarPeriodoClick(Sender: TObject);
var
  ID_Refeicao, DTH_Encerramento, Refeicao: String;
begin
  try
    if dbgRefeicoes.SelectedRangeCount > 0 then
      begin
        if ((dbgRefeicoes.Columns.Items[4].Field.Text = EmptyStr)
           or  (dbgRefeicoes.Columns.Items[4].Field.Text = ''))  then
          begin
            ID_Refeicao := dbgRefeicoes.Columns.Items[0].Field.Text;
            DTH_Encerramento := FormatDateTime('YYYY-MM-DD hh:nn:ss',Now);
            Refeicao := LowerCase(dbgRefeicoes.Columns.Items[2].Field.Text);
            if Application.MessageBox(PChar('Deseja encerrar o período de '+dbgRefeicoes.Columns.Items[1].Field.Text+'  '
                                            +Refeicao+'?'),'Confirmar',MB_ICONEXCLAMATION + MB_YESNO) = MRYES then
              begin
                try
                  SQLExec(sqlqRefeicoesOperacao,['UPDATE r_refeicoes SET',
                                                 'dth_fechamento = '''+DTH_Encerramento+''',usuario_fechamento = '''+gUsuario_Logado+'''',
                                                 'WHERE id_refeicao = '+ID_Refeicao]);
                finally
                  begin
                    Log(LowerCase(Modulo),'refeições','encerrar período refeição',ID_Refeicao,gID_Usuario_Logado,gUsuario_Logado,'<<período de registro de '+Refeicao+' encerrado '+DTH_Encerramento+'>>');
                    Application.MessageBox(PChar('O período foi encerrado com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
                    sbtnAtualizar.Click;
                  end;
                end;
              end
            else
              Exit;
          end
        else
          begin
            Application.MessageBox(PChar('Este período já foi encerrado em '+dbgRefeicoes.Columns.Items[4].Field.Text),'Aviso',MB_ICONEXCLAMATION + MB_OK);
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar encerrar o período de registro de refeições'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmRefeicoes.sbtnHorarioClick(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,'CADASTROS','CADHRCAD') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;

  OpenForm(TfrmCadHorariosRefeicoes,'Modal');
end;

procedure TfrmRefeicoes.sbtnRegRefeicoesTerminalClick(Sender: TObject);
var i: integer;
begin
  if ((dbgRefeicoes.Columns.Items[4].Field.Text = EmptyStr)
     or  (dbgRefeicoes.Columns.Items[4].Field.Text = ''))  then
    begin
      //gID_Refeicao := dbgRefeicoes.Columns.Items[0].Field.AsString;
      //gRefeicao := dbgRefeicoes.Columns.Items[1].Field.AsString;
      Self.Close;
      OpenForm(TfrmRegRefeicoes, 'FullScreen');
      //FreeAndNil(frmRefeicoes);
    end
  else
    begin
      Application.MessageBox(PChar('Período encerrado'+#13+'Selecione o período em aberto ou abra um novo período para registro de refeições'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
    end;
end;

procedure TfrmRefeicoes.sbtnSalvarClick(Sender: TObject);
var
  TextoMsgSalvar, ID_HRefeicao, HRefeicao, DTH_Ini_Refeicao: String;
  Data, Hora: String;
  DataHoraEdt, DataHoraAdd: TDateTime;
  HoraIni, HoraFim: TTime;
begin
  try
    if lkcbHorariosRefeicoes.KeyValue = Null then
      begin
        Application.MessageBox('Selecione a refeição','Aviso', MB_ICONWARNING + MB_OK);
        lkcbHorariosRefeicoes.SetFocus;
        Exit;
      end;
    ID_HRefeicao := sqlqRefeicoes.Fields.Fields[0].AsString;
    DTH_Ini_Refeicao :=  sqlqRefeicoes.Fields[2].AsString;
    HRefeicao :=  sqlqHorariosRefeicoes.Fields[4].AsString;
    if medtHorario.Text = EmptyStr then
      begin
        Application.MessageBox('Selecione o horário','Aviso', MB_ICONWARNING + MB_OK);
        medtHorario.SetFocus;
        Exit;
      end;
    try
      StrToTime(medtHorario.Text);
    Except
      begin
        Application.MessageBox('O horário informado é inválido','Aviso', MB_ICONWARNING + MB_OK);
        medtHorario.SetFocus;
        Exit;
      end;
    end;

    sqlqHorariosRefeicoes.Filter := 'id_horario_refeicao = '+IntToStr(lkcbHorariosRefeicoes.KeyValue);
    sqlqHorariosRefeicoes.Filtered := True;
    HoraIni := sqlqHorariosRefeicoes.Fields[2].AsDateTime;
    HoraFim := sqlqHorariosRefeicoes.Fields[3].AsDateTime;
    sqlqHorariosRefeicoes.Filter := EmptyStr;
    sqlqHorariosRefeicoes.Filtered := False;

    Data := FormatDateTime('DD/MM/YYYY',dbgRefeicoes.Columns.Items[2].Field.AsDateTime);
    Hora := medtHorario.Text;
    DataHoraEdt := StrToDateTime(Data+' '+Hora);
    DataHoraAdd := StrToDateTime(FormatDateTime('DD/MM/YYYY',Now)+' '+Hora);

    if (StrToTime(Hora) < HoraIni-ToleranciaIniReg) or (StrToTime(Hora) > HoraFim) then
      begin
        Application.MessageBox(PChar('O horário de abertura do refeitório para '+HRefeicao+' deve estar entre '+FormatDateTime('hh:nn', HoraIni)+' e '+FormatDateTime('hh:nn', HoraFim)),'Aviso', MB_ICONWARNING + MB_OK);
        medtHorario.SetFocus;
        Exit;
      end;

    if Acao='ADICIONAR' then
      begin
        SQLExec(sqlqRefeicoesOperacao,['INSERT INTO r_refeicoes (id_horario_refeicao, dth_abertura, usuario_abertura)',
                                       'VALUES ('''+IntToStr(lkcbHorariosRefeicoes.KeyValue)+''','''+FormatDateTime('YYYY-MM-DD hh:nn:ss',DataHoraAdd)+''','''+gUsuario_Logado+''')']);
        ID_HRefeicao := SQLQuery(sqlqRefeicoesOperacao,['SELECT MAX (id_refeicao) idrefeicao FROM r_refeicoes'],'idrefeicao');
        Log(LowerCase(Modulo),'refeições','liberar registro refeição',ID_HRefeicao,gID_Usuario_Logado,gUsuario_Logado,'<<período de registro de '+LowerCase(HRefeicao)+' - início: '+FormatDateTime('DD/MM/YYYY hh:nn:ss',DataHoraAdd)+' liberado>>');
        TextoMsgSalvar := 'cadastrado';
      end;
    if Acao='EDITAR' then
      begin
        SQLExec(sqlqRefeicoesOperacao,['UPDATE r_refeicoes SET',
                                       'id_horario_refeicao = '''+IntToStr(lkcbHorariosRefeicoes.KeyValue)+''', dth_abertura = '''+FormatDateTime('YYYY-MM-DD hh:nn:ss',DataHoraEdt)+'''',
                                       'WHERE id_refeicao = '+dbgRefeicoes.Columns.Items[0].Field.Text]);
        Log(LowerCase(Modulo),'refeições','editar período registro refeição',ID_HRefeicao,gID_Usuario_Logado,gUsuario_Logado,'<<período de registro de '+LowerCase(HRefeicao)+' - início: '+DTH_Ini_Refeicao+' editado>>');
        TextoMsgSalvar := 'editado';
      end;
    Application.MessageBox(PChar('Período '+ TextoMsgSalvar +' com sucesso!'),'Aviso',MB_ICONINFORMATION + MB_OK);
    Acao := EmptyStr;
    pnlCampos.Height := 0;
    sbtnAtualizar.Click;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar salvar os dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmRefeicoes.FormShow(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,Modulo,'REFPRACS') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  Editado := False;
  sbtnAtualizar.Click;
end;

procedure TfrmRefeicoes.lkcbHorariosRefeicoesSelect(Sender: TObject);
begin
  Editado := True;
end;

procedure TfrmRefeicoes.medtHorarioDblClick(Sender: TObject);
begin
  if medtHorario.ReadOnly then
    medtHorario.ReadOnly := False
  else
    medtHorario.ReadOnly := True;
end;

procedure TfrmRefeicoes.medtHorarioKeyPress(Sender: TObject; var Key: char);
begin
  Editado := True;
end;

procedure TfrmRefeicoes.medtHorarioMouseLeave(Sender: TObject);
begin
  if medtHorario.ReadOnly = True then
    medtHorario.Cursor := crHandPoint
  else
    medtHorario.Cursor := crDefault;
end;

procedure TfrmRefeicoes.FormCreate(Sender: TObject);
begin
  pnlCampos.Height := 0;

  if CheckPermission(UserPermissions,Modulo,'REFPRABR') then
    sbtnAbrirPeriodo.Enabled := True
  else
    sbtnAbrirPeriodo.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'REFPREDT') then
    sbtnEditarPeriodo.Enabled := True
  else
    sbtnEditarPeriodo.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'REFPRENC') then
    sbtnEncerrarPeriodo.Enabled := True
  else
    sbtnEncerrarPeriodo.Enabled := False;

  if CheckPermission(UserPermissions,'CADASTROS','CADHRCAD') then
    sbtnHorario.Enabled := True
  else
    sbtnHorario.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'REFRGTER') then
    sbtnRegRefeicoesTerminal.Enabled := True
  else
    sbtnRegRefeicoesTerminal.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'REFRGMAN') then
    sbtnRegRefeicoesManual.Enabled := True
  else
    sbtnRegRefeicoesManual.Enabled := False;
end;

procedure TfrmRefeicoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    sbtnCancelar.Click;

  if Key = VK_F5 then
    sbtnAtualizar.Click;

  if (ssCtrl in Shift) and (Key = VK_S) then
    sbtnSalvar.Click;
end;

procedure TfrmRefeicoes.dbgRefeicoesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
var
  CorLinha: TColor;
begin
  CorLinha := TColor($98FB98);
  with (Sender As TDBGrid) do
    begin
      if sqlqRefeicoes.Fields[4].AsString = EmptyStr then
        begin
          Canvas.Brush.Color := CorLinha;
          Canvas.Font.Color := clBlack;
          Canvas.Font.Style := [fsBold];
        end
      else
        begin
          Canvas.Font.Color := clGrayText;
        end;
    end;
end;

procedure TfrmRefeicoes.dbgRefeicoesTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgRefeicoes.Columns.Count - 1 do
    dbgRefeicoes.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgRefeicoes.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];
end;

procedure TfrmRefeicoes.FormClose(Sender: TObject; var CloseAction: TCloseAction
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

procedure TfrmRefeicoes.dbgRefeicoesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  mousePt: TGridcoord;
begin
  mousePt := dbgRefeicoes.MouseCoord(x,y);
  if mousePt.y = 0 then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmRefeicoes.dbgRefeicoesMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfrmRefeicoes.lkcbHorariosRefeicoesDropDown(Sender: TObject);
begin
  SQLExec(sqlqHorariosRefeicoes,['SELECT id_horario_refeicao, strftime(''%H:%M'',hora_inicio)||'' às ''||strftime(''%H:%M'',hora_fim)||''  ''||refeicao AS hr_refeicao,',
                                 'hora_inicio, hora_fim, refeicao',
                                 'FROM r_horarios_refeicoes',
                                 'WHERE status = 1',
                                 'and (strftime(''%Y-%m-%d'',dt_inicio) <= strftime(''%Y-%m-%d'',''now''))',
                                 'and ((strftime(''%Y-%m-%d'',dt_fim) >= strftime(''%Y-%m-%d'',''now'')) or dt_fim is null)',
                                 'ORDER BY hora_inicio, hora_fim']);
  lkcbHorariosRefeicoes.ListField := 'hr_refeicao';
  lkcbHorariosRefeicoes.KeyField := 'id_horario_refeicao';
  lkcbHorariosRefeicoes.Refresh;
end;

procedure TfrmRefeicoes.sbtnAbrirPeriodoClick(Sender: TObject);
begin
  try
    SQLExec(sqlqRefeicoesOperacao,['SELECT R.id_refeicao ID, H.refeicao REFEIÇÃO, R.dth_abertura ''DT/HR ABERTURA'',',
                                   'R.usuario_abertura ''USUÁRIO  ABERTURA'', R.dth_fechamento ''DT/HR FECHAMENTO'', R.usuario_fechamento ''USUÁRIO FECHAMENTO''',
                                   'FROM r_refeicoes R',
                                   'LEFT JOIN r_horarios_refeicoes H ON H.id_horario_refeicao = R.id_horario_refeicao',
                                   'WHERE ((R.dth_fechamento IS NULL) OR (R.dth_fechamento = ''''))',
                                   'ORDER BY R.dth_abertura DESC']);
    if sqlqRefeicoesOperacao.RecordCount > 0 then
      begin
        if Application.MessageBox(PChar('Não é possível abrir um novo período pois ainda existe horário em aberto: '
                                         +sqlqRefeicoesOperacao.Fields[1].AsString+'  '+sqlqRefeicoesOperacao.Fields[2].AsString+#13#13
                                         +'Deseja encerrar o período em aberto para abrir novo príodo?'),'Confirmar',MB_ICONEXCLAMATION + MB_YESNO) = MRYES then
          begin
            sbtnEncerrarPeriodo.Click;
          end
        else
          Exit;
      end;
    if Acao = EmptyStr then
      begin
        pnlCampos.Height := 60;
        lkcbHorariosRefeicoes.ItemIndex := -1 ;
        Acao := 'ADICIONAR';
        lkcbHorariosRefeicoes.SetFocus;
        medtHorario.Enabled := True;
        medtHorario.Text := TimeToStr(Now);
      end;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

end.

