unit UGFunc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, LCLType, Controls, StdCtrls, ExtCtrls, Windows, IniFiles,
  Dialogs, sqldb, sqldblib, MaskEdit, DBCtrls, StrUtils, Graphics, DB, Translations,
  ComCtrls, ldapsend, ComObj, UxTheme;

type
  StringMatriz = Array of Array of String;

  var AppTitle, AppVersion, AppIcon, AppLogo, gID_Usuario_Logado, gUsuario_Logado,
      gDominioNome, gDominioPorta, gModAltSenha, gID_Usuario_Selecionado,
      gID_Refeicao, gRefeicao, gID_Pessoa, gTipo_Vinculo, gID_Filtro: String;


      gSenha_Login_Alterada, pGERFILNPDR, pGERFILSEMP, pGERFILSALV, gAutentLocal,
      gAutentDom: Boolean;

  UserPermissions: StringMatriz;

  procedure Launch;
  procedure AppTerminate;
  procedure FixPageControlColor(PageControl: TPageControl);
  procedure Login(fLogin: TForm; cBanco: TComboBox; cUsuario, cSenha: TEdit; Conn: TSQLConnector; SQLQLogin: TSQLQuery; SQLQPermissoes: TSQLQuery);
  procedure DefUserPermissions(SQLQPermissions: TSQLQuery; User_ID: String);
  function CheckPermission(UP: StringMatriz; Module, CodPermission: String): Boolean;
  procedure LoadSystemParameters;
  procedure Logoff(LoginForm: TForm; Conn: TSQLConnector; LibConf: TSQLDBLibraryLoader);
  procedure Clean(Comp: Array of TComponent);
  procedure CleanForm(Form: TForm);
  function goPath(Path: String): String;
  function FileNumberLines(FilePath: String): Integer;
  procedure OpenForm(FormClass: TFormClass; TypeForm: String);
  procedure NormalScreen(Form: TForm);
  procedure FullScreen(Form: TForm);
  procedure LoadImage(PathImageComponent: TComponent; ImageComponent: TImage);
  function GetImageSize(PathImageComponent: TComponent): TStringArray;
  procedure SetImageSize(Image: TImage; SizeW, SizeH: Integer);
  function TryStrToDate(Date: String): Boolean;
  function ValidarCPF(CPF: String): Boolean;
  function ValidarEmail(Email: String): Boolean;
  procedure Log(Modulo, Formulario, Acao, ID_Registro, ID_Usuario, Usuario, Detalhes: String);
  function Estacao: String;
  procedure ExportToWorksheet(FilePath, FileName, FileExt, Query: String);
  procedure CloseAllFormOpenedConnections(Form: TForm);
  function IndexArrayString(xArray: StringMatriz; Col: Integer; Val: String): Integer;
  function ComponentName(Component: TComponent): String;
  procedure SelectAll(Component: TComponent);

implementation

uses
  UINIFiles, UDBO, UPrincipal, ULogin, UAlterarSenha, UVinculosPessoas, UConexao,
  ExpertTabSheet;

{constructor TxForm.Create(AOwner: TComponent; Params: String);
begin
  inherited Create(AOwner);
  xParams := Params;
end; }

procedure Launch;
var
  FilePref, ConfigFile, ConfigDBFile, CompTransFile, CompLang: String;
  IniFile: TIniFile;
begin
  try
    ConfigFile := GoPath('config.ini');

    AppTitle := ReadIni(ConfigFile,'System','AppTitle');
    AppVersion := ReadIni(ConfigFile,'System','AppVersion');
    AppIcon := ReadIni(ConfigFile,'System','AppIcon');
    AppLogo := ReadIni(ConfigFile,'System','AppLogo');

    Application.Title := AppTitle+' ['+AppVersion+']';
    Application.MainForm.Caption := Application.Title;
    if FileExists(AppIcon) then
      Application.Icon.LoadFromFile(AppIcon)
    else
      Application.Icon.HandleAllocated;

    Application.MainForm.Enabled := False;
    Application.ShowMainForm := False;
    frmLogin.Show;
    //SetForegroundWindow(Application.Handle);

    FilePref := GoPath('pref.ini'); //%AppData%\SysAgro\pref.ini
    ConfigDBFile := GoPath('configdb.ini');

    //Traduz mensagens padrões do compilador
    CompTransFile := ReadIni(ConfigFile,'Translation','CompLanguageFile');
    CompLang := ReadIni(ConfigFile,'Translation','CompLanguage');
    if FileExists(CompTransFile) then
      TranslateUnitResourceStrings('LclStrConsts',CompTransFile,CompLang,'');
  except on E: exception do
    begin
      Application.MessageBox(PChar('Houve uma falha grave na inicialiação'+#13+'O aplicativo será encerrado'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro fatal',MB_ICONERROR + MB_OK);
      Application.Terminate;
    end;
  end;
end;

procedure AppTerminate;
begin
  if Application.MessageBox('Deseja sair do sistema?','Confirmação', MB_ICONQUESTION + MB_YESNO) = mrYES then
    begin
      CloseAllTabs(frmPrincipal.PageControl);
      Log('sistema','sistema','sair','',gID_Usuario_Logado,gUsuario_Logado,'<<usuário '+gUsuario_Logado+' encerrou o sistema>>');
      Application.Terminate;
    end
  else
    Abort;
end;

procedure FixPageControlColor(PageControl: TPageControl);
begin
  UxTheme.SetWindowTheme(PageControl.Handle, NIL, '');
end;

procedure Login(fLogin: TForm; cBanco: TComboBox; cUsuario, cSenha: TEdit; Conn: TSQLConnector; SQLQLogin: TSQLQuery; SQLQPermissoes: TSQLQuery);
var
  numTentUsuario, maxTentLogin: Integer;
  sqlqParametros, sqlqTentativas: TSQLQuery;
  bStatus, bResetSenha, BlockExcedTentLogin: Boolean;
  bUsuario, bSenha, bModoAutenticacao, bDesModoAutenticacao: String;
  FLDAP: TLDAPSend;
begin
  try
    //Carrega parâmetros do sistema
    try
      //Cria componente Query e atribui os parametros
      sqlqParametros := TSQLQuery.Create(fLogin);
      sqlqParametros.DataBase := dmConexao.ConexaoDB;
      sqlqParametros.Transaction := dmConexao.sqltTransactions;

      //Consulta os parametros
      SQLQuery(sqlqParametros,['SELECT modulo, cod_config, param1, param2, param3, imagem, status',
                               'FROM g_parametros',
                               'WHERE modulo = ''SEGURANCA''']);
      //Carrega parametros login
      sqlqParametros.Filter := 'cod_config = ''NTENTBLOCK''';
      sqlqParametros.Filtered := True;
      BlockExcedTentLogin := sqlqParametros.FieldByName('status').AsBoolean;
      maxTentLogin := sqlqParametros.FieldByName('param1').AsInteger;
      sqlqParametros.Filtered := False;
      sqlqParametros.Filter := '';

      sqlqParametros.Filter := 'modulo = ''SEGURANCA'' AND cod_config = ''METAUTENT''';
      sqlqParametros.Filtered := True;
      gAutentLocal := StrToBool(sqlqParametros.FieldByName('param1').Text);
      gAutentDom := StrToBool(sqlqParametros.FieldByName('param2').Text);
      sqlqParametros.Filtered := False;
      sqlqParametros.Filter := '';

      if gAutentDom then
        begin
          sqlqParametros.Filter := 'modulo = ''SEGURANCA'' AND  cod_config = ''CONFDOM''';
          sqlqParametros.Filtered := True;
          gDominioNome := sqlqParametros.FieldByName('param1').AsString;
          gDominioPorta := sqlqParametros.FieldByName('param2').AsString;
          sqlqParametros.Filtered := False;
          sqlqParametros.Filter := '';
        end;


      //Cria componente Query e atribui os parametros
      if BlockExcedTentLogin then
        begin
          sqlqTentativas := TSQLQuery.Create(fLogin);
          sqlqTentativas.DataBase := dmConexao.ConexaoDB;
          sqlqTentativas.Transaction := dmConexao.sqltTransactions;
          sqlqTentativas.Options := [sqoAutoCommit];
        end;
    finally
      sqlqParametros.Free;
    end;

    if cBanco.Text = EmptyStr then
      begin
       Application.MessageBox('Selecione o banco de dados','Aviso', MB_ICONWARNING + MB_OK);
       cBanco.SetFocus;
       Exit;
      end;
    if not Conn.Connected then
      begin
        if Application.MessageBox(PChar('O sistema não está conectado ao banco de dados'+#13+'- Verifique as configurações do sistema e do banco de dados ou contate o administrador do sistema'+#13#13+'Deseja tentar novamente?'), 'Erro', MB_ICONERROR + MB_YESNO) = mrNo then
          Application.Terminate;
          Exit;
      end;
    if cUsuario.Text = EmptyStr then
      begin
       Application.MessageBox('Informe o usuário','Aviso', MB_ICONWARNING + MB_OK);
       cUsuario.SetFocus;
       Exit;
      end;
    if cSenha.Text = EmptyStr then
      begin
       Application.MessageBox('Informe a senha','Aviso', MB_ICONWARNING + MB_OK);
       cSenha.SetFocus;
       Exit;
      end;

    //Consulta os dados do usuário
    SQLQuery(SQLQLogin,['SELECT usuario, senha, status, resetar_senha_prox_login, modo_autenticacao','FROM g_usuarios','WHERE usuario = '''+cUsuario.Text+'''']);
    bUsuario := SQLQLogin.FieldByName('usuario').Text;
    bSenha := SQLQLogin.FieldByName('senha').Text;
    bStatus := SQLQLogin.FieldByName('status').AsBoolean;
    bResetSenha := SQLQLogin.FieldByName('resetar_senha_prox_login').AsBoolean;
    bModoAutenticacao := SQLQLogin.FieldByName('modo_autenticacao').Text;

    if CompareText(cUsuario.Text, bUsuario) <> 0 then
      begin
        Application.MessageBox(PChar('Usuário '''+cUsuario.Text+''' não registrado'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
        Clean([cUsuario,cSenha]);
        cUsuario.SetFocus;
        Exit;
      end;
    if not bStatus then
      begin
        Application.MessageBox(PChar('Usuário '''+cUsuario.Text+''' inativo'+#13+'- Entre em contato com o administrador do sistema'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
        Clean([cSenha]);
        cUsuario.SetFocus;
        Exit;
      end;

    //Autentica o usuário pelo banco de dados local
    if ((gAutentLocal) and (CompareText(bModoAutenticacao, 'L') = 0)) then
      begin
        if CompareText(cSenha.Text, bSenha) <> 0 then
          begin
            if BlockExcedTentLogin then
              begin
                numTentUsuario := StrToInt(SQLQuery(sqlqTentativas,['SELECT n_tentativas','FROM g_usuarios','WHERE usuario = '''+cUsuario.Text+''''],'n_tentativas'));
                if numTentUsuario < maxTentLogin then
                  begin
                    Application.MessageBox(PChar('Senha inválida'+#13+'O usuário será bloqueado após '+IntToStr(maxTentLogin-(numTentUsuario))+' tentativas'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                    SQLExec(sqlqTentativas,['UPDATE g_usuarios SET',
                                            'n_tentativas = '''+IntToStr(numTentUsuario+1)+'''',
                                            'WHERE usuario = '''+cUsuario.Text+'''']);
                    Clean([cSenha]);
                    cSenha.SetFocus;
                    Exit;
                  end
                else
                  begin
                    Application.MessageBox(PChar('O usuário '''+cUsuario.Text+''' foi bloqueado por excesso de tentativas de logon'+#13#13+'- Entre em contato com o administrador para desbloquear'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                    SQLExec(sqlqTentativas,['UPDATE g_usuarios SET',
                                            'status = false',
                                            'WHERE usuario = '''+cUsuario.Text+'''']);
                    Log('sistema','login','logon','','0',cUsuario.Text,'<<usuário '+cUsuario.Text+' bloqueado por excesso de tentativas de logon>>');
                    Clean([cSenha]);
                    cSenha.SetFocus;
                    Exit;
                  end;
              end
            else
              begin
                Application.MessageBox(PChar('Senha inválida'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                Clean([cSenha]);
                cSenha.SetFocus;
                Exit;
              end;
          end;
      end
    else
    //Autentica o usuário pelo domínio
    if ((gAutentDom) and (CompareText(bModoAutenticacao, 'D') = 0)) then
      begin
        try
          try
            FLDAP := TLDAPSend.Create;
            FLDAP.TargetHost := gDominioNome;
            FLDAP.TargetPort := gDominioPorta;
            FLDAP.UserName := cUsuario.Text+'@'+gDominioNome;
            FLDAP.Password := cSenha.Text;

            if FLDAP.Login then
              begin
                if not FLDAP.Bind then
                  begin
                    if BlockExcedTentLogin then
                      begin
                        numTentUsuario := StrToInt(SQLQuery(sqlqTentativas,['SELECT n_tentativas','FROM g_usuarios','WHERE usuario = '''+cUsuario.Text+''''],'n_tentativas'));
                        if numTentUsuario < maxTentLogin then
                          begin
                            Application.MessageBox(PChar('Usuário ou senha inválida'+#13+'O usuário será bloqueado após '+IntToStr(maxTentLogin-(numTentUsuario))+' tentativas'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                            SQLExec(sqlqTentativas,['UPDATE g_usuarios SET',
                                                    'n_tentativas = '''+IntToStr(numTentUsuario+1)+'''',
                                                    'WHERE usuario = '''+cUsuario.Text+'''']);
                            Clean([cSenha]);
                            cSenha.SetFocus;
                            Exit;
                          end
                        else
                          begin
                            Application.MessageBox(PChar('O usuário '''+cUsuario.Text+''' foi bloqueado por excesso de tentativas de logon'+#13#13+'- Entre em contato com o administrador para desbloquear'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                            SQLExec(sqlqTentativas,['UPDATE g_usuarios SET',
                                                    'status = false',
                                                    'WHERE usuario = '''+cUsuario.Text+'''']);
                            Log('sistema','login','logon','','0',cUsuario.Text,'<<usuário '+cUsuario.Text+' bloqueado por excesso de tentativas de logon>>');
                            Clean([cSenha]);
                            cSenha.SetFocus;
                            Exit;
                          end;
                      end
                    else
                      begin
                        Application.MessageBox(PChar('Usuário ou senha inválida'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                        Clean([cSenha]);
                        cSenha.SetFocus;
                        Exit;
                      end;
                  end
                else
                  begin
                    Application.MessageBox(PChar('Não foi possível realizar autenticação no domínio "'+gDominioNome+'"'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                    Clean([cSenha]);
                    cSenha.SetFocus;
                    Exit;
                  end;
              end
            else
              begin
                Application.MessageBox(PChar('Falha ao conectar-se ao domínio "'+gDominioNome+'"'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
                Clean([cSenha]);
                cSenha.SetFocus;
                Exit;
              end;
            except on E: Exception do
              begin
                Application.MessageBox(PChar('Falha na autenticação pelo domínio "'+gDominioNome+'"'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
                FreeAndNil(FLDAP);
                Abort;
              end;
            end;
        finally
          FLDAP.logout;
          FreeAndNil(FLDAP);
        end;
      end
    else
      begin
        case bModoAutenticacao of
          'L': bDesModoAutenticacao := 'sistema';
          'D': bDesModoAutenticacao := 'domínio';
        else
          bDesModoAutenticacao := 'não identificado'
        end;
        Application.MessageBox(PChar('Falha na autenticação do usuário'+#13#13+'Modo de autenticação: '+bDesModoAutenticacao+#13+'- Entre em contato com o administrador do sistema para verificação dos parâmetros do sistema e da conta de usuário'), 'Erro', MB_ICONSTOP + MB_OK);
        Clean([cSenha]);
        cSenha.SetFocus;
        Exit;
      end;

    SQLQuery(SQLQLogin,['SELECT id_usuario, usuario, modo_autenticacao, resetar_senha_prox_login','FROM g_usuarios','WHERE usuario = '''+cUsuario.Text+'''']);
    gID_Usuario_Logado := SQLQLogin.FieldByName('id_usuario').Text;
    gUsuario_Logado := SQLQLogin.FieldByName('usuario').Text;

    //Reseta a quantidade de tentativas de logon
    if BlockExcedTentLogin then
      begin
        SQLExec(sqlqTentativas,['UPDATE g_usuarios SET',
                                'n_tentativas = 0',
                                'WHERE usuario = '''+cUsuario.Text+'''']);
        sqlqTentativas.Free;
      end;

    if ((gAutentLocal)
        and (CompareText(bModoAutenticacao, 'L') = 0)
        and (bResetSenha)) then
      begin
        gSenha_Login_Alterada := False;
        gModAltSenha := 'ALTSENHALAYOUT2';
        OpenForm(TfrmAlterarSenha,'Modal');
      end
    else
      gSenha_Login_Alterada := True;
    while not gSenha_Login_Alterada do
      begin
        case Application.MessageBox(PChar('Para prosseguir é necessário atualizar a senha'+#13+'Deseja alterar a senha agora?'),'Confirmação', MB_ICONQUESTION + MB_YESNOCANCEL) of
          MRYES:
            begin
              gModAltSenha := 'ALTSENHALAYOUT2';
              OpenForm(TfrmAlterarSenha,'Modal');
            end;
          MRNO:
            begin
              gSenha_Login_Alterada := True;
              Application.Terminate;
            end;
          MRCANCEL: Exit;
        end;
      end;
    Clean([cSenha]);
    Application.MainForm.Enabled := True;
    DefUserPermissions(SQLQPermissoes, gID_Usuario_Logado);
    LoadSystemParameters;
    Application.MainForm.Show;
    fLogin.Hide;
    Log('sistema','login','logon','',gID_Usuario_Logado,gUsuario_Logado,'<<usuário '+gUsuario_Logado+' acessou o sistema>>');

  except on E: exception do
    begin
      Application.MessageBox(PChar('Falha ao tentar realizar login no sistema'+#13+'Erro: '+E.Message+#13#13+'- Contate o administrador do sistema'),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure DefUserPermissions(SQLQPermissions: TSQLQuery; User_ID: String);
var
  i: Integer;
begin
  try
    //Baixa catálago de permissões do usuário
    {SQLExec(SQLQPermissions,['SELECT id_usuario, modulo, cod_permissao, permissao',
                            'FROM g_usuarios_permissoes',
                            'WHERE id_usuario = '''+User_ID+'''']);      }
    SQLExec(SQLQPermissions,['SELECT  DISTINCT'
                            ,'        modulo'
                            ,'      , cod_permissao'
                            ,'      , permissao'
                            ,'FROM g_usuarios_permissoes'
                            ,'WHERE id_usuario = '+User_ID

                            ,'UNION ALL'

                            ,'SELECT  DISTINCT'
                            ,'         modulo'
                            ,'       , cod_permissao'
                            ,'       , permissao'
                            ,'FROM g_perfis_acesso_permissoes'
                            ,'WHERE excluido = false'
                            ,'     AND id_perfil_acesso IN ( SELECT id_perfil_acesso'
                            ,'                               FROM g_usuarios_perfis_acessos'
                            ,'                               WHERE id_usuario = '''+User_ID+''')'

                            ,'GROUP BY modulo, cod_permissao, permissao'

                            ,'ORDER BY modulo, cod_permissao']);

    //Define o tamanho da matriz
    SetLength(UserPermissions,SQLQPermissions.RecordCount,3);

    //Carrega as permissões para a matriz
    i := 0;
    while not SQLQPermissions.eof do
      begin
        UserPermissions[i,0] := SQLQPermissions.Fields[0].AsString;
        UserPermissions[i,1] := SQLQPermissions.Fields[1].AsString;
        UserPermissions[i,2] := SQLQPermissions.Fields[2].AsString;

        SQLQPermissions.Next;
        i := i+1;
      end;

    //Atualizar o form principal para atibuir as permissões
    Application.MainForm.Repaint;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Falha ao atribuir permissões ao usuário'+#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message+#13#13+'- Contate o administrador do sistema'),'Erro',MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

function CheckPermission(UP: StringMatriz; Module, CodPermission: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i:=Low(UP) to High(UP) do
    begin
      if MatchStr(Module,UP[i,0]) and MatchStr(CodPermission,UP[i,1]) and StrToBool(UP[i,2]) = True then
        begin
          Result := True;
          Exit;
        end;
    end;

  //Atualizar o form principal para atibuir as permissões
  Application.MainForm.Repaint;
end;

procedure LoadSystemParameters;
var
  sqlqSystemParams: TSQLQuery;
begin
  try
    //Carrega parâmetros do sistema
    try
      //Cria componente Query e atribui os parametros
      sqlqSystemParams := TSQLQuery.Create(Nil);
      sqlqSystemParams.DataBase := dmConexao.ConexaoDB;
      sqlqSystemParams.Transaction := dmConexao.sqltTransactions;

      //Consulta os parametros
      SQLQuery(sqlqSystemParams,['SELECT modulo, cod_config, param1, param2, param3, imagem, status'
                                ,'FROM g_parametros']);

      //Carrega parametros para a tela de filtros
      //Sempre abrir o gerenciador de filtros se não for definido nenhum filtro padrão
      sqlqSystemParams.Filter := 'modulo = ''FILTROS'' AND cod_config = ''GERFILNPDR''';
      sqlqSystemParams.Filtered := True;
      pGERFILNPDR := sqlqSystemParams.FieldByName('status').AsBoolean;
      sqlqSystemParams.Filtered := False;
      sqlqSystemParams.Filter := '';

      //Sempre abrir o gerenciador de filtros ao abrir as janelas
      sqlqSystemParams.Filter := 'modulo = ''FILTROS'' AND cod_config = ''GERFILSEMP''';
      sqlqSystemParams.Filtered := True;
      pGERFILSEMP := sqlqSystemParams.FieldByName('status').AsBoolean;
      sqlqSystemParams.Filtered := False;
      sqlqSystemParams.Filter := '';

      //Abrir o gerenciador de filtros ao criar novo filtro
      sqlqSystemParams.Filter := 'modulo = ''FILTROS'' AND cod_config = ''GERFILSALV''';
      sqlqSystemParams.Filtered := True;
      pGERFILSALV := sqlqSystemParams.FieldByName('status').AsBoolean;
      sqlqSystemParams.Filtered := False;
      sqlqSystemParams.Filter := '';

    finally
      sqlqSystemParams.Free;
    end;

  except on E: exception do
    begin
      Application.MessageBox(PChar('Falha ao carregar os parâmetros do sistema'+#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message+#13#13+'- Contate o administrador do sistema'),'Erro',MB_ICONERROR + MB_OK);
      Application.Terminate;
    end;
  end;
end;

procedure Logoff(LoginForm: TForm; Conn: TSQLConnector; LibConf: TSQLDBLibraryLoader);
begin
  CloseAllTabs(frmPrincipal.PageControl);
  Application.MainForm.Enabled := False;
  Application.MainForm.Hide;
  LoginForm.Show;
  Log('sistema','sistema','logoff','',gID_Usuario_Logado,gUsuario_Logado,'<<usuário '+gUsuario_Logado+' efetuou logoff>>');
  gID_Usuario_Logado := '';
  gUsuario_Logado := ' ';
  ConnStop(Conn, LibConf);
end;

procedure Clean(Comp: array of TComponent);
var
  i: Integer;
begin
  for i := low(Comp) to high(Comp) do
    begin
      if (Comp[i] is TEdit) then
        (Comp[i] as TEdit).Clear;
      if (Comp[i] is TMaskEdit) then
        (Comp[i] as TMaskEdit).Clear;
      if (Comp[i] is TCheckBox) then
        (Comp[i] as TCheckBox).Checked := False;
      if (Comp[i] is TListBox) then
        (Comp[i] as TListBox).Clear;
      if (Comp[i] is TDBLookupComboBox) then
        (Comp[i] as TDBLookupComboBox).Clear;
      if (Comp[i] is TLabel) then
        (Comp[i] as TLabel).Caption := EmptyStr;
      if (Comp[i] is TComboBox) then
        (Comp[i] as TComboBox).ItemIndex := -1;
      if (Comp[i] is TRadioGroup) then
        (Comp[i] as TRadioGroup).ItemIndex := -1;
      if (Comp[i] is TListView) then
        (Comp[i] as TListView).ItemIndex := -1;
    end;
end;

procedure CleanForm(Form: TForm);
var
  i: Integer;
begin
  for i := 0 to Form.ComponentCount -1 do
    begin
      if (Form.Components[i] is TEdit) then
        (Form.Components[i] as TEdit).Clear;

      if (Form.Components[i] is TMaskEdit) then
        (Form.Components[i] as TMaskEdit).Clear;

      if (Form.Components[i] is TRadioGroup) then
        (Form.Components[i] as TRadioGroup).ItemIndex := -1;

      if (Form.Components[i] is TCheckBox) then
        (Form.Components[i] as TCheckBox).Checked := False;

      if (Form.Components[i] is TComboBox) then
        (Form.Components[i] as TComboBox).ItemIndex := -1;

      if (Form.Components[i] is TMemo) then
        (Form.Components[i] as TMemo).Clear;
    end;
end;

function goPath(Path: String): String;
var
  lcLista: TStringList;
  i: Integer;
  R: String;
begin
  try
    lcLista := TStringList.Create;
    ExtractStrings( ['%'], [' '], PChar(Path), lcLista );
    for i := 0 to lcLista.Count -1 do
      begin
        if SysUtils.GetEnvironmentVariable(lcLista.Strings[i]) <> EmptyStr then
          lcLista.Strings[i] := SysUtils.GetEnvironmentVariable(lcLista.Strings[i]);
        if i = 0 then
          R := lcLista.Strings[i]
        else
          R := R+lcLista.Strings[i];
      end;
    Result := R;
  finally
    FreeAndNil( lcLista );
  end;
end;

function FileNumberLines(FilePath: String): Integer;
var
  i: Integer;
  strFile: TextFile;
  strLine: String;
begin
  i := 0;
  FilePath := goPath(FilePath);
  if FileExists(FilePath) then
    begin
      try
        AssignFile(strFile, FilePath);
        Reset(strFile);
        while not Eof(strFile) do
          begin
            Readln(strFile,strline);
            i := i + 1;
          end;
            Result := i;
            CloseFile(strFile);
      except
        CloseFile(strFile);
        Application.MessageBox(PChar('Falha na contagem de linhas do arquivo '+FilePath),'Erro',MB_ICONERROR + MB_OK);
      end;
    end
  else
    begin
      CloseFile(strFile);
      Application.MessageBox(PChar('A contagem das linhas não pode ser realizado'+#13+'O arquivo '+FilePath+' não foi encontrado'),'Erro',MB_ICONERROR + MB_OK);
    end;
end;

procedure OpenForm(FormClass: TFormClass; TypeForm: String);
var
  Form: TForm;
begin
  try
    try
      //Form := TForm(FormClass);
      //Application.CreateForm(FormClass, Form);
      Form := FormClass.Create(Application);
      if TypeForm = 'Modal' then
        begin
          Form.ShowModal;
          FreeAndNil(Form);
        end
      else
      if TypeForm = 'Normal' then
        Form.Show
      else
      if TypeForm = 'FullScreen' then
        begin
          FullScreen(Form);
          Form.ShowModal;
          FreeAndNil(Form);
        end
      else
        abort;
    finally

    end;
  except on E: Exception do
    begin
      FreeAndNil(Form);
      Application.MessageBox(PChar('Falha ao abrir a janela '+Form.Caption+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure NormalScreen(Form: TForm);
begin
  try
    Form.BorderStyle := bsSizeable;
    Form.WindowState := wsNormal;
    Form.FormStyle := fsNormal;
    Form.Width := Screen.Width-120;
    Form.Height := Screen.Height-150;
    Form.Top := 50;
    Form.Left := 50;
    Form.Position := poScreenCenter;
  except on E: Exception do
    begin
      FreeAndNil(Form);
      Application.MessageBox(PChar('Erro ao restaurar a janela'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure FullScreen(Form: TForm);
begin
  try
    Form.BorderStyle := bsNone;
    Form.Position := poScreenCenter;
    Form.FormStyle := fsStayOnTop;
    Form.WindowState := wsFullScreen;
    Form.Top := 0;
    Form.Left := 0;
  except on E: Exception do
    begin
      FreeAndNil(Form);
      Application.MessageBox(PChar('Erro ao colocar no modo Tela Cheia'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure LoadImage(PathImageComponent: TComponent; ImageComponent: TImage);
var
  tJPEG: TJPEGImage;
  vStream: TMemoryStream;
begin
  try
    if (PathImageComponent is TField) then
      begin
        if not (PathImageComponent as TField).IsNull then
          begin
            tJPEG := TJPEGImage.Create;
            vStream := TMemoryStream.Create;
            TBlobField((PathImageComponent as TField)).SaveToStream(vStream);
            vStream.Position := 0;
            tJPEG.LoadFromStream(vStream);
            ImageComponent.Picture.Clear;
            ImageComponent.Picture.Assign(tJPEG);
            tJPEG.Free;
            vStream.Free;
          end
        else
          ImageComponent.Picture.Clear;
      end;
  except on E: Exception do
    begin
      FreeAndNil(PathImageComponent);
      FreeAndNil(ImageComponent);
      Application.MessageBox(PChar('Erro ao carregar imagem'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
    end;
  end;
end;

function GetImageSize(PathImageComponent: TComponent): TStringArray;
var
  tJPEG: TJPEGImage;
  vStream: TMemoryStream;
begin
  try
    if (PathImageComponent is TField) then
      begin
        if not (PathImageComponent as TField).IsNull then
          begin
            SetLength(Result,2);
            tJPEG := TJPEGImage.Create;
            vStream := TMemoryStream.Create;
            TBlobField((PathImageComponent as TField)).SaveToStream(vStream);
            vStream.Position := 0;
            tJPEG.LoadFromStream(vStream);
            Result[0] := IntToStr(tJPEG.Width);
            Result[1] := IntToStr(tJPEG.Height);
            tJPEG.Free;
            vStream.Free;
          end;
      end;
  except on E: Exception do
    begin
      FreeAndNil(PathImageComponent);
      Application.MessageBox(PChar('Erro ao tentar extrair as informações da imagem'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure SetImageSize(Image: TImage; SizeW, SizeH: Integer);
var
  tJPEG: TJPEGImage;
begin
  try
    tJPEG := Image.Picture.Jpeg;
    Image.Picture.Jpeg.SetSize(SizeW,SizeH);
    //Image.Picture.Jpeg.Canvas.Brush.Color := clWhite;
    Image.Picture.Jpeg := tJPEG;
    //Image.Picture.Jpeg.Canvas.co;
    //Image.Picture.Jpeg.Canvas.Rectangle(0, 0, Image.ClientWidth, Image.ClientHeight);
    //Image.Canvas.CopyRect();
    //Image.Width := SizeW;
    //Image.Height := SizeH;
    //Image.Refresh;
  except on E: Exception do
    begin
      FreeAndNil(Image);
      Application.MessageBox(PChar('Erro ao tentar ajustar o tamanho da imagem'+#13+#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
    end;
  end;
end;

function TryStrToDate(Date: String): Boolean;
begin
  try
    StrToDate(Date);
    Result := True;
  except on E: Exception do
    Result := False;
  end;
end;

function ValidarCPF(CPF: String): Boolean;
const
  A: Set of Char = ['.','-'];
var
  i,D1,D2: Integer;
  xCPF: String;
begin
  try
    xCPF := EmptyStr;
    for i := 1 to length(CPF) do
      begin
        if not (CPF[i] in A) then
          if not (CPF[i] = ' ') then
            xCPF := xCPF+CPF[i];
      end;

    if ((length(xCPF) <> 11) or
       (xCPF = '00000000000') or (xCPF = '11111111111') or
       (xCPF = '22222222222') or (xCPF = '33333333333') or
       (xCPF = '44444444444') or (xCPF = '55555555555') or
       (xCPF = '66666666666') or (xCPF = '77777777777') or
       (xCPF = '88888888888') or (xCPF = '99999999999')) then
      begin
        Result := False;
        Exit;
      end;

    D1 := 0;
    for i := 1 to 9 do
      begin
        D1 := D1+(strtoint(xCPF[10-i])*(i+1));
      end;
    D1 := ((11 - (D1 mod 11))mod 11) mod 10;
    if D1 > 9 then
      D1 := 0;


    D2 := 0;
    for i := 1 to 10 do
      begin
        D2 := D2+(strtoint(xCPF[11-i])*(i+1));
      end;
    D2 := ((11 - (D2 mod 11))mod 11) mod 10;
    if D2 > 9 then
      D2 := 0;

    if ((IntToStr(D1) <> xCPF[10]) or (IntToStr(D2) <> xCPF[11])) then
      begin
        Result := False;
        Exit;
      end;

    Result := True;
  except
    Result := False;
  end;
end;

function ValidarEmail(Email: String): Boolean;
var
  i, cont: Integer;
begin
  Email := LowerCase(Email);
  Result := True;

  if Email = EmptyStr then
    begin
      Result := False;
      Exit;
    end;

  if not ((Pos('@', EMail)<>0) and (Pos('.', EMail)<>0)) then
    begin
      Result := False;
      Exit;
    end;

  if (abs(Pos('@', EMail) - Pos('.', EMail)) = 1) or
     (abs(Pos('@', EMail) - Pos('_', EMail)) = 1) or
     (abs(Pos('@', EMail) - Pos('-', EMail)) = 1) then
    begin
      Result := False;
      Exit;
    end;

  cont := 0;
  for i := 1 to Length(Email) do
    begin
      if not (Email[i] in ['a' .. 'z', '0' .. '9', '_', '-', '.', '@']) then
        begin
          Result := False;
          Exit;
        end;

      if (EMail[i] = '.') and (EMail[i+1] = '.') then
        begin
          Result := false;
          Exit;
        end;

      if EMail[i] = '@' then
        begin
          cont := cont + 1;
          if cont > 1 then
            begin
              Result := False;
              Exit;
            end;
        end;
    end;
end;

procedure Log(Modulo, Formulario, Acao, ID_Registro, ID_Usuario, Usuario, Detalhes: String);
var
  sqlqLog: TSQLQuery;
begin
  try
    if ID_Usuario <> EmptyStr then
      begin
        try
          sqlqLog := TSQLQuery.Create(Application);
          sqlqLog.Name := 'sqlqLog';
          sqlqLog.SQLConnection := dmConexao.ConexaoDB;
          sqlqLog.Transaction := dmConexao.sqltTransactions;
          sqlqLog.Options := [sqoAutoCommit];
          SQLExec(sqlqLog,['INSERT INTO g_log'
                           ,'(dth_log,estacao,modulo,formulario,acao,id_registro,id_usuario,usuario,detalhes)'
                           ,'VALUES ('''+FormatDateTime('YYYY-MM-DD hh:nn:ss', Now)+''','''+LowerCase(Estacao)+''''
                           ,','''+Modulo+''','''+Formulario+''','''+Acao+''','''+ID_Registro+''''
                           ,','''+ID_Usuario+''','''+Usuario+''','''+Detalhes+''')']);
        finally
          sqlqLog.Free;
        end;
      end;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao registrar log'+#13#13+'Classe '+E.ClassName
                                 +#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          sqlqLog.Free;
          Abort;
        end;
    end;
  end;
end;

function Estacao: String;
var
  Buffer: Array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  Windows.GetComputerName(@Buffer, Size);
  Result := StrPas(Buffer);
end;

procedure ExportToWorksheet(FilePath, FileName, FileExt, Query: String);
var
  sqlQuery: TSQLQuery;
  TaskDialog: TTaskDialog;
  StopProcess: Boolean;
  i, MaxRow: Integer;
begin
  try
    try
      StopProcess := False;
      TaskDialog := TTaskDialog.Create(Nil);
      TaskDialog.Caption := 'Progresso...';
      TaskDialog.Title := 'Exportando arquivo';
      TaskDialog.Text := 'Aguarde enquanto o arquivo é exportado';
      TaskDialog.CommonButtons := [tcbCancel];
      TaskDialog.ModalResult := mrCancel;
      TaskDialog.Flags := [tfAllowDialogCancellation{, tfShowMarqueeProgressBar}];
      //TaskDialog. .ProgressBar.MarqueeSpeed := 10;
      TaskDialog.Execute;
      if TaskDialog.ModalResult = mrCancel then
        StopProcess := True;
      sqlQuery := TSQLQuery.Create(Nil);
      sqlQuery.Name := 'sqlqExpExcel';
      sqlQuery.SQLConnection := dmConexao.ConexaoDB;
      sqlQuery.Transaction := dmConexao.sqltTransactions;
      sqlQuery.Options := [sqoAutoCommit];
      SQLExec(sqlQuery,[Query]);

      sqlQuery.First;
      MaxRow := sqlQuery.RecordCount-1;
      i := 0;

      while i <= MaxRow do
        begin
          Application.ProcessMessages;
          //ShowMessage(sqlQuery.FieldByName('id_log').Text);
          if (StopProcess = True) then
            Break;

          sqlQuery.Next;
          i:=i+1;
        end;

      //ShowMessage(goPath(FileName));
      //showmessage(FilePath+' - '+FileName+' - '+' - '+FileExt+#13+Query);
    finally
      sqlQuery.Free;
      TaskDialog.Free;
    end;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar exportar o arquivo'+#13#13+'Classe '+E.ClassName
                                 +#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          sqlQuery.Free;
          Abort;
        end;
    end;
  end;
end;

procedure CloseAllFormOpenedConnections(Form: TForm);
var
  i: Integer;
begin
  for i := 0 to Form.ComponentCount -1 do
    begin
      if (Form.Components[i] is TSQLQuery) then
        begin
          if (Form.Components[i] as TSQLQuery).Active then
            (Form.Components[i] as TSQLQuery).Active := False;
        end;
    end;
end;

function IndexArrayString(xArray: StringMatriz; Col: Integer; Val: String): Integer;
var
  i: Integer;
begin
  try
    Result := -1;
    for i := Low(xArray) to High(xArray) do
       begin
         if MatchStr(Val, xArray[i,Col]) then
           Result := i;
       end;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar localizar o índice do array'+#13#13+'Classe '+E.ClassName
                                 +#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

function ComponentName(Component: TComponent): String;
begin
  try
    Result := 'Parâmetro de component não definido';
    if (Component is TEdit) then
      Result := (Component as TEdit).Name;

  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao obter o nome do component'+#13#13+'Classe '+E.ClassName
                                 +#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure SelectAll(Component: TComponent);
var
  i: Integer;
  ListView: TListView;
begin
  try
    if (Component is TListView) then
      begin
        ListView := (Component as TListView);
        for i := 0 to ListView.Items.Count - 1 do
          begin
            ListView.Items.Item[i].Selected := True;
          end;
      end;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar selecionar todos os itens'+#13#13
                                +'Component '+Component.Name
                                +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

end.
