unit ULocalizarCadPessoa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, DBGrids, LCLType, Grids;

type

  { TfrmLocalizarCadPessoa }

  TfrmLocalizarCadPessoa = class(TForm)
    cbCampo: TComboBox;
    cbCriterio: TComboBox;
    dsBuscaCadPessoa: TDataSource;
    dbgResultadoBusca: TDBGrid;
    edtValor: TEdit;
    gpbxCristeriosBusca: TGroupBox;
    gpbxResultadosBusca: TGroupBox;
    lblCriterio: TLabel;
    lblValor: TLabel;
    lblCampo: TLabel;
    pnlComandos: TPanel;
    spbnPesquisar: TSpeedButton;
    sbtnSelecionar: TSpeedButton;
    sbtnLimparPesquisa: TSpeedButton;
    sqlqBuscaCadPessoa: TSQLQuery;
    procedure cbCriterioChange(Sender: TObject);
    procedure dbgResultadoBuscaMouseLeave(Sender: TObject);
    procedure dbgResultadoBuscaMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure dbgResultadoBuscaTitleClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure sbtnLimparPesquisaClick(Sender: TObject);
    procedure sbtnSelecionarClick(Sender: TObject);
    procedure spbnPesquisarClick(Sender: TObject);
  private

  public

  end;

var
  frmLocalizarCadPessoa: TfrmLocalizarCadPessoa;

implementation

uses
  UGFunc, UDBO, UConexao, UVinculosPessoas;
{$R *.lfm}

{ TfrmLocalizarCadPessoa }

procedure TfrmLocalizarCadPessoa.cbCriterioChange(Sender: TObject);
begin
  if ((cbCriterio.Text = 'é nulo') or (cbCriterio.Text = 'não é nulo')) then
    begin
      edtValor.Text := EmptyStr;
      edtValor.Enabled := False;
    end
  else
    edtValor.Enabled := True;
end;

procedure TfrmLocalizarCadPessoa.dbgResultadoBuscaMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfrmLocalizarCadPessoa.dbgResultadoBuscaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  mousePt: TGridcoord;
begin
  mousePt := dbgResultadoBusca.MouseCoord(x,y);
  if mousePt.y = 0 then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmLocalizarCadPessoa.dbgResultadoBuscaTitleClick(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to dbgResultadoBusca.Columns.Count - 1 do
    dbgResultadoBusca.Columns[i].Title.Font.Style := [];
  TSQLQuery(dbgResultadoBusca.DataSource.DataSet).IndexFieldNames := Column.FieldName;
  Column.Title.Font.Style := [fsBold];

  cbCampo.Text := Column.Title.Caption;
end;

procedure TfrmLocalizarCadPessoa.FormShow(Sender: TObject);
begin
  SQLQuery(sqlqBuscaCadPessoa,['SELECT id_pessoa ID, NOME, CPF','FROM p_pessoas','WHERE excluido = false']);
end;

procedure TfrmLocalizarCadPessoa.sbtnLimparPesquisaClick(Sender: TObject);
begin
  Clean([edtValor,cbCriterio,cbCampo]);
  sqlqBuscaCadPessoa.Filtered := False;
  sqlqBuscaCadPessoa.Filter := EmptyStr;
  SQLQuery(sqlqBuscaCadPessoa,['SELECT id_pessoa ID, NOME, CPF','FROM p_pessoas','WHERE excluido = false']);
end;

procedure TfrmLocalizarCadPessoa.sbtnSelecionarClick(Sender: TObject);
begin
  if not dbgResultadoBusca.Columns[0].Field.IsNull then
    begin
      frmVinculos.CarregarPessoa(dbgResultadoBusca.Columns[0].Field.Value);
      gID_Pessoa := dbgResultadoBusca.Columns[0].Field.Value;
      Self.Close;
    end
  else
    Application.MessageBox('Selecione um cadastro para ser carredo', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
end;

procedure TfrmLocalizarCadPessoa.spbnPesquisarClick(Sender: TObject);
var
  Filtro: String;
begin
  if cbCampo.Text = EmptyStr then
    begin
      Application.MessageBox('Selecione um campo para a pesquisa', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      cbCampo.DroppedDown := True;
      cbCampo.SetFocus;
      Exit;
    end;

  if cbCriterio.Text = EmptyStr then
    begin
      Application.MessageBox('Selecione o critério para a pesquisa', 'Aviso', MB_ICONEXCLAMATION + MB_OK);
      cbCriterio.DroppedDown := True;
      cbCriterio.SetFocus;
      Exit;
    end;

  Filtro := EmptyStr;
  Filtro := cbCampo.Text;
  case cbCriterio.Text of
    'é igual': Filtro := Filtro+' = '''+edtValor.Text+'''';
    'não é igual': Filtro := Filtro+' <> '''+edtValor.Text+'''';
    'contém': Filtro := Filtro+' LIKE ''%'+edtValor.Text+'%''';
    'não contém': Filtro := Filtro+' NOT LIKE ''%'+edtValor.Text+'%''';
    'é nulo': Filtro := Filtro+' IS NULL';
    'não é nulo': Filtro := Filtro+' IS NOT NULL';
    'está entre': Filtro := Filtro+' BETWEEN';
    'não está entre': Filtro := Filtro+' NOT BEWEEN';
  end;

  SQLQuery(sqlqBuscaCadPessoa,['SELECT id_pessoa ID, NOME, CPF','FROM p_pessoas',
                               'WHERE excluido = false',
                                     'AND '+Filtro]);
end;

end.

