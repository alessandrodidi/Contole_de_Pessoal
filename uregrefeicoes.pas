unit URegRefeicoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, ComCtrls,
  LCLType, StdCtrls, ExtCtrls, DBCtrls;

type

  { TfrmRegRefeicoes }

  TfrmRegRefeicoes = class(TForm)
    edtCrachaReg1: TEdit;
    edtCrachaReg10: TEdit;
    edtCrachaReg2: TEdit;
    edtCrachaReg3: TEdit;
    edtCrachaReg4: TEdit;
    edtCrachaReg5: TEdit;
    edtCrachaReg6: TEdit;
    edtCrachaReg7: TEdit;
    edtCrachaReg8: TEdit;
    edtCrachaReg9: TEdit;
    edtCracha: TEdit;
    imgFotoReg1: TImage;
    imgFotoReg10: TImage;
    imgFotoReg2: TImage;
    imgFotoReg3: TImage;
    imgFotoReg4: TImage;
    imgFotoReg5: TImage;
    imgFotoReg6: TImage;
    imgFotoReg7: TImage;
    imgFotoReg8: TImage;
    imgFotoReg9: TImage;
    imgFoto: TImage;
    lblNomeCracha: TLabel;
    lblCracha: TLabel;
    lblValidade: TLabel;
    lblNome: TLabel;
    lblDataValidade: TLabel;
    lblFuncao: TLabel;
    lblEmpresa: TLabel;
    pnlUltimosReg: TPanel;
    pnlRefeicao: TPanel;
    shpModuraFotoReg1: TShape;
    shpModuraFoto: TShape;
    shpModuraFotoReg2: TShape;
    shpModuraFotoReg10: TShape;
    shpModuraFotoReg4: TShape;
    shpModuraFotoReg3: TShape;
    shpModuraFotoReg5: TShape;
    shpModuraFotoReg6: TShape;
    shpModuraFotoReg7: TShape;
    shpModuraFotoReg8: TShape;
    shpModuraFotoReg9: TShape;
    sqlqConsultaCracha: TSQLQuery;
    sqlqRegRefeicao: TSQLQuery;
    sqlqParametros: TSQLQuery;
    sqlqHorariosRefeicoes: TSQLQuery;
    sqlqRefeicoes: TSQLQuery;
    stbBarraStatus: TStatusBar;
    procedure edtCrachaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCrachaKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function ConsultaDados(Cracha: String): Boolean;
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RegistraRefeicao(ID_Refeicao, Cracha, Usuario_Reg: String);
  private
    const
      Modulo: String = 'REFEITORIO';
    var
      SemFoto: TField;
      DelayReg, ToleranciaIniReg, ToleranciaFimReg,
      HoraIni, HoraFim, HoraAbertura, HoraEncerramento: TTime;
      TravaHr: Boolean;
  public

  end;

var
  frmRegRefeicoes: TfrmRegRefeicoes;

implementation

uses
  UConexao, UDBO, UGFunc, URefeicoes;

{$R *.lfm}

{ TfrmRegRefeicoes }

procedure TfrmRegRefeicoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F11 then
    begin
     if Self.WindowState = wsNormal then
       begin
        FullScreen(Self);
       end
     else
       begin
         NormalScreen(Self);
       end;
    end;

  if Key = VK_F10 then
    begin
      if (CheckPermission(UserPermissions,Modulo,'REFRGACS') or CheckPermission(UserPermissions,Modulo,'REFRGTER') or CheckPermission(UserPermissions,Modulo,'REFRGMAN')) then
         OpenForm(TfrmRefeicoes,'Modal')
      else
        begin
          Clean([edtCracha,lblCracha,lblNome,lblFuncao,lblEmpresa,lblFuncao]);
          Application.MessageBox(PChar('Você não possui permissão para registrar as refeições'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
          Exit;
        end;
    end;

  if Key = VK_TAB then
    Key := VK_ESCAPE;
end;

procedure TfrmRegRefeicoes.edtCrachaKeyPress(Sender: TObject; var Key: char);
var
  Agora: TTime;
begin
  if not (Key in ['0'..'9',#8,#13]) then
    Key := #0;

  if Key = #13 then
    begin
      if not CheckPermission(UserPermissions,Modulo,'REFRGTER') then
        begin
          Application.MessageBox(PChar('Você não possui permissão para registrar as refeições'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
          Exit;
        end;

      if gID_Refeicao = EmptyStr then
        begin
          Application.MessageBox(PChar('Selecione a refeição para liberar os registros'+#13#13+'Precione F10 para selecionar uma refeição'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
          edtCracha.Clear;
          edtCracha.SetFocus;
          Exit;
        end;

      if edtCracha.Text = EmptyStr then
        begin
          Clean([lblCracha,lblNome,lblFuncao,lblEmpresa,lblDataValidade]);
          shpModuraFoto.Pen.Color := clRed;
          lblCracha.Font.Color := clRed;
          lblCracha.Caption := 'INFORME O CÓDIGO';
          imgFoto.Picture.Clear;
          LoadImage(SemFoto,imgFoto);
          //Application.MessageBox(PChar('Informe o código do crachá para registrar a refeição'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
          edtCracha.SetFocus;
          Exit;
        end;

      //Define o horário do instante
      Agora := StrToTime(FormatDateTime('hh:nn:ss',Now));

      //Verifica se considere horarios para registrar
      if TravaHr then
        begin
          //Verifica se o refeitório já foi encerrado
          SQLExec(sqlqRefeicoes,['SELECT id_refeicao, dth_abertura, dth_fechamento',
                                 'FROM r_refeicoes',
                                 'WHERE id_refeicao = '''+gID_Refeicao+'''',
                                       'AND dth_fechamento IS NOT NULL',
                                 'ORDER BY dth_abertura DESC',
                                 'LIMIT 1']);

          if sqlqRefeicoes.RecordCount > 0 then
            begin
              Clean([lblCracha,lblNome,lblFuncao,lblEmpresa,lblDataValidade]);
              shpModuraFoto.Pen.Color := clRed;
              imgFoto.Picture.Clear;
              LoadImage(SemFoto,imgFoto);
              lblCracha.Font.Color := clRed;
              lblCracha.Caption := 'ATENÇÃO';
              lblNome.Font.Color := clRed;
              lblNome.Caption := 'HORÁRIO DE '+AnsiUpperCase(gRefeicao)+' ENCERRADO EM '+FormatDateTime('hh:nn',sqlqRefeicoes.Fields[2].AsDateTime);
              edtCracha.Clear;
              edtCracha.SetFocus;
              Exit;
            end;

          //Verifica se o horário do registro está dentro do período selecionado
          if (Agora < (HoraAbertura-ToleranciaIniReg))
             or (Agora > (HoraFim+ToleranciaFimReg)) then
            begin
              Clean([lblCracha,lblNome,lblFuncao,lblEmpresa,lblDataValidade]);
              shpModuraFoto.Pen.Color := clRed;
              lblCracha.Font.Color := clRed;
              lblCracha.Caption := 'ATENÇÃO';
              lblNome.Font.Color := clRed;
              lblNome.Caption := 'FORA DO PERÍODO DE REGISTRO';
              lblFuncao.Font.Color := clRed;
              lblFuncao.Caption := 'PARA '+AnsiUpperCase(gRefeicao)+' SÃO PERMITIDOS REGISTROS ENTRE '+FormatDateTime('hh:nn', HoraIni)+' E '+FormatDateTime('hh:nn', HoraFim);
              LoadImage(SemFoto,imgFoto);
              //Application.MessageBox(PChar('Horário '+FormatDateTime('hh:nn',Agora)+' fora do período configurado'+#13+'Para '+LowerCase(gRefeicao)+' é permitido registros entre '+FormatDateTime('hh:nn', HoraIni)+' e '+FormatDateTime('hh:nn', HoraFim)),'Aviso', MB_ICONEXCLAMATION + MB_OK);
              edtCracha.Clear;
              edtCracha.SetFocus;
              Exit;
            end;
        end;

      //Consulta os parametros do módulo
      SQLExec(sqlqParametros,['SELECT modulo, cod_config, param1, param2, param3, imagem, status',
                              'FROM g_parametros',
                              'WHERE modulo = '''+Modulo+'''',
                                    'AND cod_config = ''REFRGFTPD''']);
      //Define a foto padrão
      SemFoto := sqlqParametros.Fields[5];

      //Executa as funções de checagem e cadastro
      if ConsultaDados(edtCracha.Text) then
        RegistraRefeicao(gID_Refeicao,lblNomeCracha.Caption,gUsuario_Logado);
    end;
end;

procedure TfrmRegRefeicoes.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Log(LowerCase(Modulo),'registro de refeições','encerramento terminal','',gID_Usuario_Logado,gUsuario_Logado,'<<o usuário '+gUsuario_Logado+' encerrou o terminal de registro de '+LowerCase(gRefeicao)+' ('+FormatDateTime('hh:nn',HoraIni)+' às '+FormatDateTime('hh:nn',Horafim)+')>>');
  CloseAllFormOpenedConnections(Self);
end;

procedure TfrmRegRefeicoes.edtCrachaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

function TfrmRegRefeicoes.ConsultaDados(Cracha: String): Boolean;
var
  Funcao: String;
begin
  try
    if Cracha = EmptyStr then
      begin
        lblNome.Canvas.Font.Color := clRed;
        lblNome.Caption := 'INFORME O CÓDIGO';
        Result := False;
        Exit;
      end;

    //if SemFoto.IsNull then showmessage('vazio') else ShowMessage('tem foto');

    SQLExec(sqlqConsultaCracha,['SELECT C.cracha, C.dt_inicio, C.status StatusC,',
                                'C.id_pessoa, P.nome, X.foto, C.cod_vinculo,',
                                'C.cod_empresa, E.fantasia, E.Status StatusE,',
                                'C.cod_setor, S.setor, C.cod_centro_custo, U.centro_custo,',
                                'C.cod_funcao, F.funcao, C.dt_fim, C.nome_cracha',
                                'FROM p_cracha C',
                                     'INNER JOIN p_pessoas P ON P.id_pessoa = C.id_pessoa',
                                                 'AND P.excluido = False',
                                     'LEFT JOIN g_empresas E ON E.cod_empresa = C.cod_empresa',
                                     'LEFT JOIN g_setores S ON S.cod_setor = C.cod_setor AND S.cod_empresa = C.cod_empresa',
                                     'LEFT JOIN g_centros_custo U ON U.cod_centro_custo = C.cod_centro_custo AND U.cod_empresa = C.cod_empresa',
                                     'LEFT JOIN p_funcoes F ON F.cod_funcao = C.cod_funcao AND F.cod_empresa = C.cod_empresa',
                                     'LEFT OUTER JOIN p_fotos X ON X.id_pessoa = C.id_pessoa',
                                                      'AND X.status = True',
                                'WHERE C.cracha = '+Cracha,
                                'ORDER BY C.dt_inicio DESC',
                                'LIMIT 1']);

    Clean([lblCracha,lblNome,lblFuncao,lblEmpresa,lblFuncao]);

    case sqlqConsultaCracha.Fields[6].AsString of
      'F': Funcao := sqlqConsultaCracha.Fields[15].AsString;
      'T': Funcao := 'TERCEIRO';
      'V': Funcao := 'VISITANTE';
    else
      Funcao := EmptyStr;
    end;

    //Verifica se o número do crachá está registrado
    if Cracha = sqlqConsultaCracha.Fields[0].AsString then
      begin
        //Verifica se o crachá está ativo
        if not sqlqConsultaCracha.Fields[2].AsBoolean then
          begin
            Clean([edtCracha,lblCracha,lblNome,lblFuncao,lblEmpresa,lblFuncao]);
            shpModuraFoto.Pen.Color := clRed;
            lblCracha.Font.Color := clRed;
            lblCracha.Caption := Cracha;
            lblNome.Font.Color := clRed;
            lblNome.Caption := 'CÓDIGO INATIVO';
            lblFuncao.Font.Color := clRed;
            lblFuncao.Caption := 'PROCURE A PORTARIA/ADMINISTRAÇÃO';
            imgFoto.Picture.Clear;
            LoadImage(SemFoto,imgFoto);
            Result := False;
            Exit;
          end;

        //Verifica as datas de início e fim de uso do crachá
        if ((sqlqConsultaCracha.FieldByName('dt_inicio').AsDateTime > Now)
           or ((not sqlqConsultaCracha.FieldByName('dt_fim').IsNull)
                and (sqlqConsultaCracha.FieldByName('dt_fim').AsDateTime < Now))) then
          begin
            Clean([edtCracha,lblCracha,lblNome,lblFuncao,lblEmpresa,lblFuncao]);
            shpModuraFoto.Pen.Color := clRed;
            lblCracha.Font.Color := clRed;
            lblCracha.Caption := Cracha;
            lblNome.Font.Color := clRed;
            lblNome.Caption := 'CÓDIGO FORA DO PERÍODO DE USO';
            lblFuncao.Font.Color := clRed;
            lblFuncao.Caption := 'PROCURE A PORTARIA/ADMINISTRAÇÃO';
            imgFoto.Picture.Clear;
            LoadImage(SemFoto,imgFoto);
            Result := False;
            Exit;
          end;

        //Verifica se a empresa está autorizada a registrar refeições
        if (((sqlqConsultaCracha.FieldByName('cod_empresa').Text <> '0')
              and (sqlqConsultaCracha.FieldByName('cod_empresa').Text <> EmptyStr))
           and (not sqlqConsultaCracha.Fields[9].AsBoolean)) then
          begin
            Clean([edtCracha,lblCracha,lblNome,lblFuncao,lblEmpresa,lblFuncao]);
            shpModuraFoto.Pen.Color := clRed;
            lblCracha.Font.Color := clRed;
            lblCracha.Caption := Cracha;
            lblNome.Font.Color := clRed;
            lblNome.Caption := AnsiUpperCase(sqlqConsultaCracha.Fields[8].AsString);
            lblFuncao.Font.Color := clRed;
            lblFuncao.Caption := 'EMPRESA NÃO AUTORIZADA A REGISTRAR REFEIÇÕES';
            lblEmpresa.Font.Color := clRed;
            lblEmpresa.Caption := 'PROCURE A PORTARIA/ADMINISTRAÇÃO';
            imgFoto.Picture.Clear;
            LoadImage(SemFoto,imgFoto);
            Result := False;
            Exit;
          end;

        lblCracha.Font.Color := clBlack;
        lblNome.Font.Color := clBlack;
        lblFuncao.Font.Color := clBlack;
        lblEmpresa.Font.Color := clBlack;
        shpModuraFoto.Pen.Color := clBlack;
        lblCracha.Caption := AnsiUpperCase(sqlqConsultaCracha.Fields[0].AsString);
        lblNomeCracha.Caption := AnsiUpperCase(sqlqConsultaCracha.FieldByName('nome_cracha').AsString);
        lblNome.Caption := AnsiUpperCase(sqlqConsultaCracha.Fields[4].AsString);
        lblFuncao.Caption := AnsiUpperCase(Funcao);
        if not sqlqConsultaCracha.Fields[11].IsNull then
          lblEmpresa.Caption := AnsiUpperCase(sqlqConsultaCracha.Fields[11].AsString+'  '+sqlqConsultaCracha.Fields[8].AsString)
        else
          lblEmpresa.Caption := AnsiUpperCase(sqlqConsultaCracha.Fields[8].AsString);

        if not sqlqConsultaCracha.Fields[5].IsNull then
          begin
            imgFoto.Picture.Clear;
            LoadImage(sqlqConsultaCracha.Fields[5],imgFoto);
          end
        else
          begin
            imgFoto.Picture.Clear;
            LoadImage(SemFoto,imgFoto);
          end;

        Result := True;
      end
    else
      begin
        lblCracha.Font.Color := clRed;
        lblNome.Font.Color := clRed;
        shpModuraFoto.Pen.Color := clRed;
        Clean([edtCracha,lblCracha,lblNome,lblFuncao,lblEmpresa,lblFuncao]);
        imgFoto.Picture.Clear;
        LoadImage(SemFoto,imgFoto);
        lblCracha.Caption := Cracha;
        lblNome.Caption := 'CÓDIGO NÃO LOCALIZADO';
        lblFuncao.Font.Color := clRed;
        lblFuncao.Caption := 'PROCURE A PORTARIA/ADMINISTRAÇÃO';
        Result := False;
        edtCracha.Clear;
        edtCracha.SetFocus;
        Self.Repaint;
        Exit;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          edtCracha.Clear;
          edtCracha.SetFocus;
          Self.Repaint;
          Application.MessageBox(PChar('Falha ao consultar os dados'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmRegRefeicoes.FormPaint(Sender: TObject);
begin
  if gRefeicao <> EmptyStr then
    pnlRefeicao.Caption := AnsiUpperCase(gRefeicao)
  else
    pnlRefeicao.Caption := '(F10)   SELECIONAR   REFEIÇÃO';
end;

procedure TfrmRegRefeicoes.FormShow(Sender: TObject);
var
  Moldura: TShape;
  EditChapa: TEdit;
  Foto: TImage;
  n,i: Integer;
begin
  try
    Clean([edtCracha,lblCracha,lblNome,lblFuncao,lblEmpresa]);

    if not CheckPermission(UserPermissions,Modulo,'REFRGTER') then
      begin
        Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Self.Close;
      end;

    if CheckPermission(UserPermissions,Modulo,'REFRGTER') then
      begin
        //Consulta os horários das refeições
        SQLExec(sqlqRefeicoes,['SELECT H.id_horario_refeicao, H.refeicao, H.hora_inicio, H.hora_fim,',
                               'R.id_refeicao, R.dth_abertura, R.usuario_abertura',
                               'FROM r_horarios_refeicoes H',
                               'INNER JOIN r_refeicoes R ON R.id_horario_refeicao = H.id_horario_refeicao',
                               'WHERE R.dth_fechamento IS NULL',
                                     'AND strftime(''%Y-%m-%d'', R.dth_abertura) = '''+FormatDateTime('YYYY-MM-DD', Now)+'''',
                               'ORDER BY R.dth_abertura DESC',
                               'LIMIT 1']);

        if sqlqRefeicoes.RecordCount > 0 then
          begin
            HoraIni := StrToTime(FormatDateTime('hh:nn:ss',sqlqRefeicoes.Fields[2].AsDateTime));
            HoraFim := StrToTime(FormatDateTime('hh:nn:ss',sqlqRefeicoes.Fields[3].AsDateTime));
            HoraAbertura := StrToTime(FormatDateTime('hh:nn:ss',sqlqRefeicoes.Fields[5].AsDateTime));
            gID_Refeicao := sqlqRefeicoes.Fields[4].AsString;
            gRefeicao := sqlqRefeicoes.Fields[1].AsString;
          end
        else
          begin
            gID_Refeicao := EmptyStr;
            gRefeicao := EmptyStr;
          end;
      end;

    //Consulta os parametros do módulo
    SQLExec(sqlqParametros,['SELECT modulo, cod_config, param1, param2, param3, imagem, status',
                            'FROM g_parametros',
                            'WHERE modulo = '''+Modulo+'''']);

    //Carrega o parametro dalay
    sqlqParametros.Filter := 'cod_config = ''REFRGDELAY''';
    sqlqParametros.Filtered := True;
    DelayReg := sqlqParametros.Fields[2].AsDateTime;
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    //Carrega se travar horários registro de refeições
    sqlqParametros.Filter := 'cod_config = ''TRVHR''';
    sqlqParametros.Filtered := True;
    TravaHr := sqlqParametros.Fields[6].AsBoolean;
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    //Carrega o tempo de tolerancia para iniciar registros
    sqlqParametros.Filter := 'cod_config = ''REFRGTOINI''';
    sqlqParametros.Filtered := True;
    ToleranciaIniReg := StrToTime(FormatDateTime('hh:nn:ss',sqlqParametros.Fields[2].AsDateTime));
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    //Carrega o tempo de tolerancia para finlizar registros
    sqlqParametros.Filter := 'cod_config = ''REFRGTOFIM''';
    sqlqParametros.Filtered := True;
    ToleranciaFimReg := StrToTime(FormatDateTime('hh:nn:ss',sqlqParametros.Fields[2].AsDateTime));
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    //Carrega a imagem para sem foto
    sqlqParametros.Filter := 'cod_config = ''REFRGFTPD''';
    sqlqParametros.Filtered := True;
    SemFoto := sqlqParametros.Fields[5];
    sqlqParametros.Filtered := False;
    sqlqParametros.Filter := '';

    //Limpa as fotos dos registros
    shpModuraFotoReg1.Visible := False;
    imgFotoReg1.Visible := False;
    edtCrachaReg1.Visible := False;
    shpModuraFotoReg2.Visible := False;
    imgFotoReg2.Visible := False;
    edtCrachaReg2.Visible := False;
    shpModuraFotoReg3.Visible := False;
    imgFotoReg3.Visible := False;
    edtCrachaReg3.Visible := False;
    shpModuraFotoReg4.Visible := False;
    imgFotoReg4.Visible := False;
    edtCrachaReg4.Visible := False;
    shpModuraFotoReg5.Visible := False;
    imgFotoReg5.Visible := False;
    edtCrachaReg5.Visible := False;
    shpModuraFotoReg6.Visible := False;
    imgFotoReg6.Visible := False;
    edtCrachaReg6.Visible := False;
    shpModuraFotoReg7.Visible := False;
    imgFotoReg7.Visible := False;
    edtCrachaReg7.Visible := False;
    shpModuraFotoReg8.Visible := False;
    imgFotoReg8.Visible := False;
    edtCrachaReg8.Visible := False;
    shpModuraFotoReg9.Visible := False;
    imgFotoReg9.Visible := False;
    edtCrachaReg9.Visible := False;
    shpModuraFotoReg10.Visible := False;
    imgFotoReg10.Visible := False;
    edtCrachaReg10.Visible := False;

    imgFoto.Picture.Clear;
    //LoadImage(SemFoto,imgFoto);

    //Carrega os últimos registros para o horário selecionado, se houver
    if sqlqRefeicoes.RecordCount > 0 then
      begin
        SQLExec(sqlqConsultaCracha,['SELECT R.cracha, X.foto',
                                    'FROM r_reg_refeicoes R',
                                    'INNER JOIN p_cracha C ON C.cracha = R.cracha',
                                         'AND C.status = true',
                                    'INNER JOIN p_pessoas P ON P.id_pessoa = C.id_pessoa',
                                    'LEFT OUTER JOIN p_fotos X ON X.id_pessoa = C.id_pessoa',
                                         'AND X.status = True',
                                    'WHERE id_refeicao = '''+gID_Refeicao+'''',
                                          'AND origem = ''T''',
                                    'ORDER BY R.id_reg_refeicao DESC',
                                    'LIMIT 10']);

        sqlqConsultaCracha.First;
        n:=1;
        while not sqlqConsultaCracha.EOF do
          begin
            for i:=0 to Self.ComponentCount-1 do
              begin
                if (Self.Components[i].Name = 'shpModuraFotoReg'+IntToStr(n)) then
                  (Self.Components[i] as TShape).Visible := True;

                if (Self.Components[i].Name = 'imgFotoReg'+IntToStr(n)) then
                  begin
                    (Self.Components[i] as TImage).Visible := True;
                    if not sqlqConsultaCracha.FieldByName('foto').IsNull then
                      LoadImage(sqlqConsultaCracha.FieldByName('foto'),(Self.Components[i] as TImage))
                    else
                      LoadImage(SemFoto,(Self.Components[i] as TImage));
                  end;

                if (Self.Components[i].Name = 'edtCrachaReg'+IntToStr(n)) then
                  begin
                    (Self.Components[i] as TEdit).Visible := True;
                    (Self.Components[i] as TEdit).Text := sqlqConsultaCracha.FieldByName('cracha').Text;
                  end;
              end;

            //edtCrachaReg1.Text := sqlqConsultaCracha.FieldByName('cracha').Text;
            n := n+1;
            sqlqConsultaCracha.Next;
          end;
      end;
    //Self.Repaint;
    Log(LowerCase(Modulo),'registro de refeições','liberação terminal','',gID_Usuario_Logado,gUsuario_Logado,'<< o usuário '+gUsuario_Logado+' liberou o terminal para registro de '+LowerCase(gRefeicao)+' ('+FormatDateTime('hh:nn',HoraIni)+' às '+FormatDateTime('hh:nn',Horafim)+')>>');
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro o inicializar o terminal'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmRegRefeicoes.RegistraRefeicao(ID_Refeicao, Cracha, Usuario_Reg: String);
var
  UltimoReg: TDateTime;
begin
  try
    try
      if ID_Refeicao = EmptyStr then
        begin
          Application.MessageBox(PChar('É necessário informar o ID da refeição para realizar o registro'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
          Exit;
        end;

      if Cracha = EmptyStr then
        begin
          Application.MessageBox(PChar('É necessário informar o crachá para realizar o registro'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
          Exit;
        end;

      if Usuario_Reg = EmptyStr then
        begin
          Application.MessageBox(PChar('É necessário informar o usuários para realizar o registro'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
          Exit;
        end;

      SQLQuery(sqlqRegRefeicao,['SELECT dth_reg_refeicao',
                                'FROM r_reg_refeicoes',
                                'WHERE cracha = '''+Cracha+'''',
                                      'AND id_refeicao = '''+ID_Refeicao+'''',
                                      'AND origem = ''T''',
                                'ORDER BY dth_reg_refeicao DESC',
                                'LIMIT 1']);
      UltimoReg := sqlqRegRefeicao.Fields[0].AsDateTime;

      if (UltimoReg+DelayReg) > Now then
        begin
          shpModuraFoto.Pen.Color := clRed;
          lblCracha.Font.Color := clRed;
          lblNome.Font.Color := clRed;
          lblFuncao.Font.Color := clRed;
          lblEmpresa.Font.Color := clRed;
          Exit;
        end;

      SQLExec(sqlqRegRefeicao,['INSERT INTO r_reg_refeicoes (id_refeicao, cracha, quantidade, dth_reg_refeicao, usuario_reg, origem)',
                               'VALUES ('''+ID_Refeicao+''','''+Cracha+''',''1'','''+FormatDateTime('YYYY-MM-DD hh:nn:ss', Now)+''','''+gUsuario_Logado+''',''T'')']);

      if not imgFotoReg9.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg10.Visible := True;
          imgFotoReg10.Visible := True;
          imgFotoReg10.Picture := imgFotoReg9.Picture;
        end;
      if edtCrachaReg9.Text <> EmptyStr then
        begin
          edtCrachaReg10.Visible := True;
          edtCrachaReg10.Text := edtCrachaReg9.Text;
        end;

      if not imgFotoReg8.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg9.Visible := True;
          imgFotoReg9.Visible := True;
          imgFotoReg9.Picture := imgFotoReg8.Picture;
        end;
      if edtCrachaReg8.Text <> EmptyStr then
        begin
          edtCrachaReg9.Visible := True;
          edtCrachaReg9.Text := edtCrachaReg8.Text;
        end;

      if not imgFotoReg7.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg8.Visible := True;
          imgFotoReg8.Visible := True;
          imgFotoReg8.Picture := imgFotoReg7.Picture;
        end;
      if edtCrachaReg7.Text <> EmptyStr then
        begin
          edtCrachaReg8.Visible := True;
          edtCrachaReg8.Text := edtCrachaReg7.Text;
        end;

      if not imgFotoReg6.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg7.Visible := True;
          imgFotoReg7.Visible := True;
          imgFotoReg7.Picture := imgFotoReg6.Picture;
        end;
      if edtCrachaReg6.Text <> EmptyStr then
        begin
          edtCrachaReg7.Visible := True;
          edtCrachaReg7.Text := edtCrachaReg6.Text;
        end;

      if not imgFotoReg5.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg6.Visible := True;
          imgFotoReg6.Visible := True;
          imgFotoReg6.Picture := imgFotoReg5.Picture;
        end;
      if edtCrachaReg5.Text <> EmptyStr then
        begin
          edtCrachaReg6.Visible := True;
          edtCrachaReg6.Text := edtCrachaReg5.Text;
        end;

      if not imgFotoReg4.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg5.Visible := True;
          imgFotoReg5.Visible := True;
          imgFotoReg5.Picture := imgFotoReg4.Picture;
        end;
      if edtCrachaReg4.Text <> EmptyStr then
        begin
          edtCrachaReg5.Visible := True;
          edtCrachaReg5.Text := edtCrachaReg4.Text;
        end;

      if not imgFotoReg3.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg4.Visible := True;
          imgFotoReg4.Visible := True;
          imgFotoReg4.Picture := imgFotoReg3.Picture;
        end;
      if edtCrachaReg3.Text <> EmptyStr then
        begin
          edtCrachaReg4.Visible := True;
          edtCrachaReg4.Text := edtCrachaReg3.Text;
        end;

      if not imgFotoReg2.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg3.Visible := True;
          imgFotoReg3.Visible := True;
          imgFotoReg3.Picture := imgFotoReg2.Picture;
        end;
      if edtCrachaReg2.Text <> EmptyStr then
        begin
          edtCrachaReg3.Visible := True;
          edtCrachaReg3.Text := edtCrachaReg2.Text;
        end;

      if not imgFotoReg1.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg2.Visible := True;
          imgFotoReg2.Visible := True;
          imgFotoReg2.Picture := imgFotoReg1.Picture;
        end;
      if edtCrachaReg1.Text <> EmptyStr then
        begin
          edtCrachaReg2.Visible := True;
          edtCrachaReg2.Text := edtCrachaReg1.Text;
        end;

      if not imgFoto.Picture.Bitmap.Empty then
        begin
          shpModuraFotoReg1.Visible := True;
          imgFotoReg1.Visible := True;
          imgFotoReg1.Picture := imgFoto.Picture;
        end;
      if edtCracha.Text <> EmptyStr then
        begin
          edtCrachaReg1.Visible := True;
          edtCrachaReg1.Text := lblNomeCracha.Caption;//edtCracha.Text;
        end;
    finally
      edtCracha.Clear;
      edtCracha.SetFocus;
      Self.Repaint;
    end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro o inicializar o terminal'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

end.

