unit UEditorCadFiltros;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType;

type

  { TfrmEditorCadFiltros }

  TfrmEditorCadFiltros = class(TForm)
    btnSalvar: TButton;
    btnCancelar: TButton;
    btnOK: TButton;
    ckbxFiltroGlobal: TCheckBox;
    edtNomeFiltro: TEdit;
    lblDetalhes: TLabel;
    lblFiltro: TLabel;
    mmDetalhes: TMemo;
    sqlqFiltro: TSQLQuery;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure ckbxFiltroGlobalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ckbxFiltroGlobalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtNomeFiltroKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure mmDetalhesKeyPress(Sender: TObject; var Key: char);
  private
    Editado, Filtro_Global, clickOK: Boolean;
    Acao, Filtro, Detalhes_Filtro: String;
  public
    ID_Filtro, Modulo, Formulario: String;
  end;

var
  frmEditorCadFiltros: TfrmEditorCadFiltros;

implementation

Uses
  UConexao, UDBO, UGFunc, UFiltros;

{$R *.lfm}

{ TfrmEditorCadFiltros }

procedure TfrmEditorCadFiltros.edtNomeFiltroKeyPress(Sender: TObject; var Key: char);
begin
  if Key IN (['a'..'z','A'..'Z','0'..'9',#8,#32,#46,'(',')','_','-']) then
    Editado := True;
  //else
    //Key := #0;
end;

procedure TfrmEditorCadFiltros.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Editado then
    begin
      case Application.MessageBox(PChar('Deseja salvar as alterações?'), 'Confirmação',  MB_ICONQUESTION + MB_YESNOCANCEL) of
        MRYES:
          begin
            btnSalvar.Click;
            CloseAllFormOpenedConnections(Self);
            FreeAndNil(Self);
          end;
        MRNO:
          begin
            Editado := False;
            CloseAllFormOpenedConnections(Self);
            FreeAndNil(Self);
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

procedure TfrmEditorCadFiltros.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_S) then
    btnSalvar.Click;
end;

procedure TfrmEditorCadFiltros.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TfrmEditorCadFiltros.btnSalvarClick(Sender: TObject);
var
  ParamAusente, Global, MSG: String;
begin
  try
    if edtNomeFiltro.Text = EmptyStr then
      begin
        Application.MessageBox(PChar('Informe o nome do filtro'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtNomeFiltro.SetFocus;
        Exit;
      end;
    if ((Modulo = EmptyStr) or (Formulario = EmptyStr)) then
      begin
        if Modulo = EmptyStr then ParamAusente := 'módulo'
        else if Formulario = EmptyStr then ParamAusente := 'formulário';
        Application.MessageBox(PChar('O filtro não será salvo pois o parâmetro '+ParamAusente+' está ausente'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
        edtNomeFiltro.SetFocus;
        Exit;
      end;

    if ckbxFiltroGlobal.Checked then
      Global := '1'
    else
      Global := '0';

    if Acao = 'ADICIONAR' then
      begin
        SQLExec(sqlqFiltro,['INSERT INTO g_filtros'
                           ,'(filtro, detalhes, global, modulo, formulario, id_usuario)'
                           ,'VALUES ('''+edtNomeFiltro.Text+''','''+mmDetalhes.Lines.Text+''','''+Global+''','''+Modulo+''','''+Formulario+''','''+gID_Usuario_Logado+''')']);

        ID_Filtro := SQLQuery(sqlqFiltro,['SELECT MAX (id_filtro) ID FROM g_filtros WHERE id_usuario = '+gID_Usuario_Logado],'ID');

        SQLExec(sqlqFiltro,['INSERT INTO g_filtros_usuarios'
                           ,'(id_filtro, id_usuario, padrao)'
                           ,'VALUES ('''+ID_Filtro+''','''+gID_Usuario_Logado+''',''0'')']);

        MSG := 'criado';
        Editado := False;
        Acao := 'EDITAR';
      end;

    if Acao = 'EDITAR' then
      begin
        SQLExec(sqlqFiltro,['UPDATE g_filtros SET'
                           ,'filtro = '''+edtNomeFiltro.Text+''', detalhes = '''+mmDetalhes.Lines.Text+''', global = '''+Global+''''
                           ,'WHERE id_filtro = '''+ID_Filtro+'''']);

        MSG := 'editado';
        Editado := False;
      end;

    if frmFiltros <> Nil then
      begin
        frmFiltros.btnAtualizar.Click;
      end
    else
      if pGERFILSALV then
        begin
          frmFiltros := TfrmFiltros.Create(Nil);
          frmFiltros.Modulo := Modulo;
          frmFiltros.Formulario := Formulario;
          frmFiltros.Show;
        end;

    Self.SetFocus;
    Application.MessageBox(PChar('Filtro '+MSG+' com sucesso!'), 'Informação', MB_ICONINFORMATION + MB_OK);
    if clickOK then Self.Close;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar salvar o filtro'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmEditorCadFiltros.btnCancelarClick(Sender: TObject);
begin
  try
    {if Editado then
      begin
        if Application.MessageBox(PChar('Cancelar a edição?'), 'Confirmação', MB_ICONQUESTION + MB_OKCANCEL) = MROK then
          begin
            edtNomeFiltro.Text := Filtro;
            ckbxFiltroGlobal.Checked := Filtro_Global;
            mmDetalhes.Lines.AddText(Detalhes_Filtro);
            Editado := False;
          end;
      end
    else}
      Self.Close;
  except on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao cancelar a edição'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmEditorCadFiltros.btnOKClick(Sender: TObject);
begin
  clickOK := True;
  btnSalvar.Click;
end;

procedure TfrmEditorCadFiltros.ckbxFiltroGlobalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then
    Editado := True;
end;

procedure TfrmEditorCadFiltros.ckbxFiltroGlobalMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Editado := True;
end;

procedure TfrmEditorCadFiltros.FormShow(Sender: TObject);
begin
  clickOK := False;
  if ID_Filtro <> EmptyStr then
    begin
      SQLQuery(sqlqFiltro,['SELECT * FROM g_filtros WHERE id_filtro = '''+ID_Filtro+'''']);
      Filtro := sqlqFiltro.FieldByName('filtro').Text;
      Filtro_Global := sqlqFiltro.FieldByName('global').AsBoolean;
      Detalhes_Filtro := sqlqFiltro.FieldByName('detalhes').Text;

      Self.Caption := Self.Caption+' ['+Filtro+']';
      Self.edtNomeFiltro.Text := Filtro;
      ckbxFiltroGlobal.Checked := Filtro_Global;
      mmDetalhes.Lines.AddText(Detalhes_Filtro);
      Acao := 'EDITAR';
    end
  else
    begin
      Self.Caption := Self.Caption+' [<<Novo filtro>>]';
      Acao := 'ADICIONAR';
    end;
end;

procedure TfrmEditorCadFiltros.mmDetalhesKeyPress(Sender: TObject; var Key: char);
begin
  Editado := True;
end;

end.

