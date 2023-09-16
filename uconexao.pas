unit UConexao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqldblib, odbcconn, sqlite3conn;

type

  { TdmConexao }

  TdmConexao = class(TDataModule)
    ConexaoDB: TSQLConnector;
    SQLDBLibraryLoader: TSQLDBLibraryLoader;
    sqltTransactions: TSQLTransaction;
  private

  public

  end;

var
  dmConexao: TdmConexao;

implementation

{$R *.lfm}

end.

