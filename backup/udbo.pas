unit UDBO;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Dialogs, LCLType, SysUtils, sqldb, sqldblib;

  procedure ConnStart(Conn: TSQLConnector; LibConf: TSQLDBLibraryLoader; IniSysConf, IniUserPref: String);
  procedure ConnStop(Conn: TSQLConnector; LibConf: TSQLDBLibraryLoader);
  procedure SQL(SQLQ: TSQLQuery; Syntax: String);
  function SQLQuery(SQLQ: TSQLQuery; Syntax: Array of String; FieldName: String): String;
  procedure SQLQuery(SQLQ: TSQLQuery; Syntax: Array of String);
  procedure SQLExec(SQLQ: TSQLQuery; Syntax: Array of String);

implementation

uses
  UINIFiles, UGFunc;

procedure ConnStart(Conn: TSQLConnector; LibConf: TSQLDBLibraryLoader; IniSysConf, IniUserPref: String);
var
  IniDBConf, DBAlias, DBName: String;
begin
  try
    IniDBConf := ReadIni(IniSysConf,'DatabaseSettings','DatabaseFile');
    DBAlias := ReadIni(IniUserPref,'Database','DatabaseName');
    DBName := ReadIni(IniDBConf,DBAlias,'Database');

    if CheckIniSessionExists(IniDBConf,DBAlias) then
      begin
        LibConf.ConnectionType := ReadIni(IniDBConf,DBAlias,'Driver');
        LibConf.LibraryName := ReadIni(IniDBConf,DBAlias,'LibraryName');

        Conn.ConnectorType := ReadIni(IniDBConf,DBAlias,'Driver');
        Conn.LoginPrompt := StrToBool(ReadIni(IniDBConf,DBAlias,'LoginPrompt'));
        Conn.KeepConnection := StrToBool(ReadIni(IniDBConf,DBAlias,'KeepConnection'));
        Conn.HostName := ReadIni(IniDBConf,DBAlias,'HostName');
        Conn.DatabaseName := ReadIni(IniDBConf,DBAlias,'Database');
        Conn.UserName := ReadIni(IniDBConf,DBAlias,'UserName');
        Conn.Password := ReadIni(IniDBConf,DBAlias,'Password');

        LibConf.Enabled := True;
        Conn.Connected := True;
      end
    else
      begin
        Application.MessageBox(PChar('Não foi possível localizar a conexão com o banco de dados "'+DBAlias+'"'),'Aviso',MB_ICONEXCLAMATION + MB_OK);
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Conn.Connected := False;
          LibConf.Enabled := False;
          Application.MessageBox(PChar('Não foi possível se conectar ao banco de dados "'+DBName+'"'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro de conexão',MB_ICONERROR + MB_OK);
          //LibConf.Free;
          //Conn.Free;
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure ConnStop(Conn: TSQLConnector; LibConf: TSQLDBLibraryLoader);
begin
  try
    Conn.Connected := False;
    LibConf.Enabled := False;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Conn.Free;
          LibConf.Free;
          Application.MessageBox(PChar('Falha ao desconectar o banco de dados'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro Logoff',MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

function SQLQuery(SQLQ: TSQLQuery; Syntax: Array of String; FieldName: String): String;
var
  i: Integer;
begin
  try
    SQLQ.Close;
    SQLQ.SQL.Clear;
    if CompareText(Copy(Syntax[0],1,6),'SELECT') = 0 then
      begin
        for i := low(Syntax) to high(Syntax) do
          begin
            if Syntax[i] <> EmptyStr then
              SQLQ.SQL.Add(Syntax[i]);
          end;
        SQLQ.Open;
        Result := SQLQ.FieldByName(FieldName).AsString;
      end
    else
      begin
        SQLQ.Close;
        //SQLQ.Free;
        Application.MessageBox('Neste módulo são permitidas apenas consultas','Aviso SQL',MB_ICONEXCLAMATION + MB_OK);
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          SQLQ.Close;
          //SQLQ.Free;
          Application.MessageBox(PChar('Falha na execução da senteça SQL'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro SQL',MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure SQLQuery(SQLQ: TSQLQuery; Syntax: Array of String);
var
  i: Integer;
begin
  try
    SQLQ.Close;
    SQLQ.SQL.Clear;
    if CompareText(Copy(Syntax[0],1,6),'SELECT') = 0 then
      begin
        for i := low(Syntax) to high(Syntax) do
          begin
            if Syntax[i] <> EmptyStr then
              SQLQ.SQL.Add(Syntax[i]);
          end;
        SQLQ.Open;
      end
    else
      begin
        SQLQ.Close;
        //SQLQ.Free;
        Application.MessageBox('Neste módulo são permitidas apenas consultas','Aviso SQL',MB_ICONEXCLAMATION + MB_OK);
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          SQLQ.Close;
          //SQLQ.Free;
          Application.MessageBox(PChar('Falha na execução da senteça SQL'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro SQL',MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end;
  end;
end;

procedure SQL(SQLQ: TSQLQuery; Syntax: String);
var
  strFile: TextFile;
  strLine: String;
  i: Integer;
  SyntaxArray: Array of String;
begin
  i := 0;
  Syntax := goPath(Syntax);
  if FileExists(Syntax) then
    begin
      try
        AssignFile(strFile, Syntax);
        Reset(strFile);
        SetLength(SyntaxArray,FileNumberLines(Syntax));
        while not Eof(strFile) do
          begin
            Readln(strFile,strline);
            SyntaxArray[i] := strLine;
            i := i + 1;
          end;
        SQLExec(SQLQ,SyntaxArray);
        CloseFile(strFile);
      except on E: exception do
        begin
          if E.ClassName <> 'EAbort' then
            begin
              SQLQ.Close;
              //SQLQ.Free;
              Application.MessageBox(PChar('Falha na execução da senteça SQL'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro SQL',MB_ICONERROR + MB_OK);
              Abort;
              Exit;
            end;
        end;
      end;
    end
  else
    begin
      SQLExec(SQLQ,Syntax);
    end;
end;

procedure SQLExec(SQLQ: TSQLQuery; Syntax: Array of String);
var
  i: Integer;
  Command: String;
begin
  try
    SQLQ.Close;
    SQLQ.SQL.Clear;
    for i := low(Syntax) to high(Syntax) do
      begin
        if Syntax[i] <> EmptyStr then
          SQLQ.SQL.Add(Syntax[i]);
          Command := Copy(Syntax[0],1,6);
      end;
    if CompareText(Copy(Syntax[0],1,6),'SELECT') = 0 then
      SQLQ.Open
    else
      SQLQ.ExecSQL;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          SQLQ.Close;
          SQLQ.SQL.Clear;
          //SQLQ.Free;
          Application.MessageBox(PChar('Falha na execução da senteça SQL'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro SQL',MB_ICONERROR + MB_OK);
          Abort;
          Exit;
        end;
    end
  end;
end;

procedure CloseAllFormConnections(Form: TForm);
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

end.

