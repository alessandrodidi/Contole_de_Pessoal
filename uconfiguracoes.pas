unit UConfiguracoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, LCLType, ExtCtrls, DBGrids, DBCtrls;

type

  { TfrmConfiguracoes }

  TfrmConfiguracoes = class(TForm)
    dbnConfiguracoes: TDBNavigator;
    dsConfigAvancadas: TDataSource;
    dbgConfigAvancadas: TDBGrid;
    pnlComandos: TPanel;
    pnlComandosOper: TPanel;
    pcConfiguracoes: TPageControl;
    sqlqConfigAvancadas: TSQLQuery;
    tbsConfigAvancadas: TTabSheet;
    procedure dbgConfigAvancadasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Atualizar;
  private

    const
      Modulo: String = 'CONFIGS';
      Formulario: String = 'CADPESSOAS';
  public

  end;

var
  frmConfiguracoes: TfrmConfiguracoes;

implementation

{$R *.lfm}

{ TfrmConfiguracoes }

uses
  UGFunc, UDBO, UConexao;

procedure TfrmConfiguracoes.FormShow(Sender: TObject);
begin
  if not CheckPermission(UserPermissions,Modulo,'CONFACES') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13
                            +'- Para solicitar acesso entre em contato com o administrador do sistema')
                            ,'Aviso'
                            ,MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  FixPageControlColor(pcConfiguracoes);
  Atualizar;
end;

procedure TfrmConfiguracoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    Atualizar;
end;

procedure TfrmConfiguracoes.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAllFormOpenedConnections(Self);
end;

procedure TfrmConfiguracoes.dbgConfigAvancadasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  i, Col: Integer;
begin
  Col := -1;
  for i := (Sender as TDBGrid).Columns.Count-1 downto 0 do
    begin
      if (Sender as TDBGrid).Columns.Items[i].Visible then
        begin
          Col := i;
          Break;
        end;
    end;
  if (Key = VK_INSERT)
     or ((Key = VK_DOWN)
         and ((Sender as TDBGrid).DataSource.DataSet.RecNo = (Sender as TDBGrid).DataSource.DataSet.RecordCount)) then
    Key := 0;

  if (Key = VK_TAB)
     and ((Sender as TDBGrid).DataSource.DataSet.RecNo = (Sender as TDBGrid).DataSource.DataSet.RecordCount) then
    begin
      if ((Sender as TDBGrid).SelectedIndex = Col) then
         Key := 0;
    end;
end;

procedure TfrmConfiguracoes.Atualizar;
begin
  try
    SQLQuery(sqlqConfigAvancadas,['SELECT *'
                                 ,'FROM g_parametros'
                                 ,'ORDER BY modulo, cod_config']);
  except on E: exception do
    begin
      sqlqConfigAvancadas.Free;
      Application.MessageBox(PChar('Falha ao tentar carregar os dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

end.

