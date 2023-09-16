unit UINIFiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, IniFiles, LCLType, Controls;

  function goPath(Path: String): String;
  function ReadIni(FilePath, Session, Key: String): String;
  procedure WriteIni(FilePath, Session, Key, Value: String);
  function ListIniSection(FilePath: String): TStringList;
  function CheckIniSessionExists(FilePath, Session: String): Boolean;
  procedure DeleteIniSession(FilePath, Session: String);

implementation

uses
  UGFunc;

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
        if GetEnvironmentVariable(lcLista.Strings[i]) <> EmptyStr then
          lcLista.Strings[i] := GetEnvironmentVariable(lcLista.Strings[i]);

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

function ReadIni(FilePath, Session, Key: String): String;
var
  IniFile: TIniFile;
begin
  FilePath := goPath(FilePath);
  if FileExists(FilePath) then
    begin
      try
        if (FilePath = ExtractFilePath(Application.ExeName)+FilePath) or
           (ExtractFilePath(FilePath) = EmptyStr) then
          IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FilePath)
        else
          IniFile := TIniFile.Create(FilePath);

        Result := IniFile.ReadString(Session, Key, '');
        IniFile.Free;
      except
        IniFile.Free;
        Application.MessageBox('Falha ao ler o arquivo de configuração','Erro', MB_ICONERROR + MB_OK);
      end;
    end
  else
    begin
      IniFile.Free;
      Application.MessageBox(PChar('O arquivo de configuração não foi encontrado'+#13#13+'Arquivo: '+FilePath),'Erro', MB_ICONSTOP + MB_OK);
    end;
end;

procedure WriteIni(FilePath, Session, Key, Value: String);
var
  IniFile: TIniFile;
begin
  FilePath := goPath(FilePath);
  if FileExists(FilePath) then
    begin
      try
        if (FilePath = ExtractFilePath(Application.ExeName) + FilePath) or
           (ExtractFilePath(FilePath) = EmptyStr) then
          IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FilePath)
        else
          IniFile := TIniFile.Create(FilePath);

        IniFile.WriteString(Session,Key,Value);
        IniFile.Free;
      except
        IniFile.Free;
        Application.MessageBox('Falha ao gravar o arquivo de configuração','Erro',MB_ICONERROR+MB_OK);
      end;
    end
  else
    begin
      IniFile.Free;
      Application.MessageBox('O arquivo de configuração não foi encontrado','Erro', MB_ICONSTOP + MB_OK);
    end;
end;

function ListIniSection(FilePath: String): TStringList;
var
  IniFile: TIniFile;
begin
  FilePath := goPath(FilePath);
  if FileExists(FilePath) then
    begin
      try
        Result := TStringList.Create;
        if (FilePath = ExtractFilePath(Application.ExeName)+FilePath) or
           (ExtractFilePath(FilePath) = EmptyStr) then
          IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FilePath)
        else
          IniFile := TIniFile.Create(FilePath);

        IniFile.ReadSections(Result);
        IniFile.Free;
      except on E: Exception do
        begin
          IniFile.Free;
          Application.MessageBox(PChar('Falha ao ler o arquivo de configuração'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro', MB_ICONERROR + MB_OK);
        end;
      end;
    end
  else
    begin
      IniFile.Free;
      Application.MessageBox('O arquivo de configuração não foi encontrado','Erro', MB_ICONSTOP + MB_OK);
    end;
end;

function CheckIniSessionExists(FilePath, Session: String): Boolean;
var
  IniFile: TIniFile;
begin
  FilePath := goPath(FilePath);
  if FileExists(FilePath) then
    begin
      try
        if (FilePath = ExtractFilePath(Application.ExeName)+FilePath) or
           (ExtractFilePath(FilePath) = EmptyStr) then
          IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FilePath)
        else
          IniFile := TIniFile.Create(FilePath);

        Result := IniFile.SectionExists(Session);
        IniFile.Free;
      except on E: Exception do
        begin
          IniFile.Free;
          Application.MessageBox(PChar('Falha ao ler o arquivo de configuração'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro', MB_ICONERROR + MB_OK);
        end;
      end;
    end
  else
    begin
      IniFile.Free;
      Application.MessageBox('O arquivo de configuração não foi encontrado','Erro', MB_ICONSTOP + MB_OK);
    end;
end;

procedure DeleteIniSession(FilePath, Session: String);
var
  IniFile: TIniFile;
begin
  FilePath := goPath(FilePath);
  if FileExists(FilePath) then
    begin
      try
        if (FilePath = ExtractFilePath(Application.ExeName)+FilePath) or
           (ExtractFilePath(FilePath) = EmptyStr) then
          IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + FilePath)
        else
          IniFile := TIniFile.Create(FilePath);

        IniFile.EraseSection(Session);
        IniFile.Free;
      except on E: Exception do
        begin
          IniFile.Free;
          Application.MessageBox(PChar('Falha ao tentar deletar '+Session+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
        end;
      end;
    end
  else
    begin
      IniFile.Free;
      Application.MessageBox('O arquivo de configuração não foi encontrado','Erro', MB_ICONSTOP + MB_OK);
    end;
end;

end.

