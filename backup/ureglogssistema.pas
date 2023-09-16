unit URegLogsSistema;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, Buttons,
  ComCtrls, ExtCtrls, Menus, StdCtrls, Grids, DBGrids, BCButton, LCLType;

type

  { TfrmRegLogsSistema }

  TfrmRegLogsSistema = class(TForm)
    bcbtnAplFiltros: TBCButton;
    bcbtnExpRegistros: TBCButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    dsLogsSistema: TDataSource;
    dbgLogsSistema: TDBGrid;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    ppmniFiltrosPrivados: TMenuItem;
    ppmniFiltrosGlobais: TMenuItem;
    N1: TMenuItem;
    ppmniNovoFiltro: TMenuItem;
    ppmniGerFiltros: TMenuItem;
    ppmniExpExcel: TMenuItem;
    pnlComandos: TPanel;
    LogStatusBar: TStatusBar;
    ppmnExportar: TPopupMenu;
    ppmnFiltros: TPopupMenu;
    SaveDialog: TSaveDialog;
    sbtnAtualizar: TSpeedButton;
    sbtnDeletarLogs: TSpeedButton;
    sbtnGerFiltros: TSpeedButton;
    sbtnLimparLogs: TSpeedButton;
    sbtnExpRegistros: TSpeedButton;
    sqlqLogsOperacoes: TSQLQuery;
    sqlqLogsSistema: TSQLQuery;
    sqlqFiltro: TSQLQuery;
    procedure dbgLogsSistemaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgLogsSistemaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgLogsSistemaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppmnFiltrosPopup(Sender: TObject);
    procedure RegistrosSelecionados;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ppmniExpExcelClick(Sender: TObject);
    procedure ppmniGerFiltrosClick(Sender: TObject);
    procedure ppmniNovoFiltroClick(Sender: TObject);
    procedure sbtnAtualizarClick(Sender: TObject);
    procedure sbtnDeletarLogsClick(Sender: TObject);
    procedure sbtnExpRegistrosClick(Sender: TObject);
    procedure sbtnGerFiltrosClick(Sender: TObject);
    procedure sbtnLimparLogsClick(Sender: TObject);
    procedure ExecFiltro(Sender: TObject);
  private
    const
      Modulo: String = 'AUDITORIA';
      Formulario: String = 'LOGSSISTEMA';
  public
    ID_Filtro_Selecionado, Filtro: String;
  end;

var
  frmRegLogsSistema: TfrmRegLogsSistema;

implementation

uses
  Upesquisar, UConexao, UDBO, UGFunc, ExpertTabSheet, UFiltros, UEditorCadFiltros,
  UExecutaFiltro;

{$R *.lfm}

{ TfrmRegLogsSistema }

procedure TfrmRegLogsSistema.FormCreate(Sender: TObject);
begin
  if CheckPermission(UserPermissions,Modulo,'ADTLSEXP') then
    begin
      sbtnExpRegistros.Enabled := True;
      bcbtnExpRegistros.Enabled := True;
    end
  else
    begin
      sbtnExpRegistros.Enabled := False;
      bcbtnExpRegistros.Enabled := False;
    end;

  if CheckPermission(UserPermissions,Modulo,'ADTLSDEL') then
    sbtnDeletarLogs.Enabled := True
  else
    sbtnDeletarLogs.Enabled := False;

  if CheckPermission(UserPermissions,Modulo,'ADTLSLMP') then
    sbtnLimparLogs.Enabled := True
  else
    sbtnLimparLogs.Enabled := False;
end;

procedure TfrmRegLogsSistema.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    sbtnAtualizar.Click;
end;

procedure TfrmRegLogsSistema.dbgLogsSistemaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_A) then
    begin
      dbgLogsSistema.DataSource.DataSet.DisableControls;
      dbgLogsSistema.DataSource.DataSet.First;
      while not(dbgLogsSistema.DataSource.DataSet.EOF) do
        begin
          dbgLogsSistema.SelectedRows.CurrentRowSelected:=true;
          dbgLogsSistema.DataSource.DataSet.Next;
        end;
      dbgLogsSistema.DataSource.DataSet.EnableControls;
    end;

  if CheckPermission(UserPermissions,Modulo,'ADTLSDEL')
    and (not (ssCtrl in Shift) and (Key = VK_DELETE)) then
    sbtnDeletarLogs.Click;

  if CheckPermission(UserPermissions,Modulo,'ADTLSLMP')
    and ((ssCtrl in Shift) and (Key = VK_DELETE)) then
    sbtnLimparLogs.Click;

  if Key = VK_ESCAPE then
    begin
      dbgLogsSistema.SelectedRows.Clear;
      LogStatusBar.Panels[1].Text := EmptyStr;
    end;
end;

procedure TfrmRegLogsSistema.dbgLogsSistemaKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((Key = VK_UP) or (Key = VK_DOWN)) then
    RegistrosSelecionados;
end;

procedure TfrmRegLogsSistema.dbgLogsSistemaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  RegistrosSelecionados;
end;

procedure TfrmRegLogsSistema.ExecFiltro(Sender: TObject);
var
  IDFiltro, NomeObjeto: String;
begin
  //Extrai o ID do filtro do nome do SubMenu
  NomeObjeto := (Sender as TMenuItem).Name;
  IDFiltro := Copy(NomeObjeto,8,Length(NomeObjeto));

  //Executa o Filtro
  frmExecutaFiltro := TfrmExecutaFiltro.Create(Nil);
  frmExecutaFiltro.ID_Filtro := IDFiltro;
  frmExecutaFiltro.Show;
end;

procedure TfrmRegLogsSistema.ppmnFiltrosPopup(Sender: TObject);
var
  FiltrosGlobais, FiltrosPrivados, SubMenu: TMenuItem;
  i: integer;
  IDFiltro, NomeFiltro: String;
  Global: Boolean;
begin
  FiltrosGlobais := (Sender as TPopupMenu).Items.Items[3];
  FiltrosPrivados := (Sender as TPopupMenu).Items.Items[4];
  FiltrosGlobais.Clear;
  FiltrosPrivados.Clear;

  //Executa a consulta de filtros
  SQLQuery(sqlqFiltro,['SELECT *'
                      ,'FROM g_filtros'
                      ,'WHERE UPPER(modulo)='''+UPPERCASE(Modulo)+''' AND UPPER(formulario)='''+UPPERCASE(Formulario)+''' AND (id_usuario='''+gID_Usuario_Logado+''' OR global = true)'
                      ,'ORDER BY global DESC, filtro']);

  sqlqFiltro.First;
  while not sqlqFiltro.EOF do
    begin
      IDFiltro := sqlqFiltro.FieldByName('id_filtro').Text;
      NomeFiltro := sqlqFiltro.FieldByName('filtro').Text;
      Global := sqlqFiltro.FieldByName('global').AsBoolean;

      if Global then
        begin
          SubMenu := TMenuItem.Create(FiltrosGlobais);
          SubMenu.Caption := NomeFiltro;
          SubMenu.Name := 'Filtro_'+IDFiltro; //Insere o ID do filtro do nome do SubMenu
          SubMenu.OnClick := @ExecFiltro;
          FiltrosGlobais.Add(SubMenu);
        end
      else
        begin
          SubMenu := TMenuItem.Create(FiltrosPrivados);
          SubMenu.Caption := NomeFiltro;
          SubMenu.Name := 'Filtro_'+IDFiltro; //Insere o ID do filtro do nome do SubMenu
          SubMenu.OnClick := @ExecFiltro;
          FiltrosPrivados.Add(SubMenu);
        end;
      sqlqFiltro.Next;
    end;
end;

procedure TfrmRegLogsSistema.RegistrosSelecionados;
var
  Num_Logs: Integer;
begin
  Num_Logs := dbgLogsSistema.SelectedRows.Count;

  if Num_Logs > 0 then
    begin
      if Num_Logs > 1 then
        LogStatusBar.Panels[1].Text := IntToStr(Num_Logs)+' registros selecionados'
      else
        LogStatusBar.Panels[1].Text := '1 registro selecionado';
    end
  else
    LogStatusBar.Panels[1].Text := EmptyStr;
end;


procedure TfrmRegLogsSistema.FormShow(Sender: TObject);
var
  ID_Filtro_Padrao: String;
begin
  if not CheckPermission(UserPermissions,Modulo,'ADTLSACS') then
    begin
      Application.MessageBox(PChar('Você não possui acesso a este módulo'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
      Self.Close;
    end;

  //Verifica se existe um filtro padrão
  SQLQuery(sqlqFiltro,['SELECT *'
                      ,'FROM g_filtros F'
                      ,'INNER JOIN g_filtros_usuarios U'
                             ,'ON U.id_filtro = F.id_filtro'
                      ,'WHERE F.modulo = '''+Modulo+''' AND F.formulario = '''+Formulario+''''
                             ,'AND U.padrao = ''1'' AND (F.id_usuario='''+gID_Usuario_Logado+''' OR F.global = true)']);

  ID_Filtro_Padrao := sqlqFiltro.FieldByName('id_filtro').Text;
  if ((pGERFILSEMP)
     or ((pGERFILNPDR) and (ID_Filtro_Padrao <> EmptyStr))) then
    begin
      frmExecutaFiltro := TfrmExecutaFiltro.Create(Nil);
      frmExecutaFiltro.ID_Filtro := ID_Filtro_Padrao;
      frmExecutaFiltro.Show;
    end
  else
    begin
      Filtro := '1<>1';
      sbtnAtualizar.Click;
      frmFiltros := TfrmFiltros.Create(Nil);
      frmFiltros.Modulo := Modulo;
      frmFiltros.Formulario := Formulario;
      frmFiltros.Show;
    end;
end;

procedure TfrmRegLogsSistema.ppmniExpExcelClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    ExportToWorksheet(SaveDialog.GetNamePath, SaveDialog.FileName, SaveDialog.Filter, 'SELECT * FROM g_log LIMIT 5');
end;

procedure TfrmRegLogsSistema.ppmniGerFiltrosClick(Sender: TObject);
begin
  frmFiltros := TfrmFiltros.Create(Nil);
  frmFiltros.Modulo := Modulo;
  frmFiltros.Formulario := Formulario;
  frmFiltros.Show;
end;

procedure TfrmRegLogsSistema.ppmniNovoFiltroClick(Sender: TObject);
begin
  frmEditorCadFiltros := TfrmEditorCadFiltros.Create(Nil);
  frmEditorCadFiltros.Modulo := Modulo;
  frmEditorCadFiltros.Formulario := Formulario;
  frmEditorCadFiltros.Show;
end;

procedure TfrmRegLogsSistema.sbtnAtualizarClick(Sender: TObject);
var
  NReg: String;
begin
  try
    dsLogsSistema.Enabled := False;
    SQLQuery(sqlqLogsSistema,['SELECT id_log, dth_log, estacao, modulo, formulario, acao, id_registro, id_usuario, usuario, detalhes'
                             ,'FROM g_log L'
                             ,'WHERE '+Filtro
                             ,'ORDER BY L.dth_log DESC']);
    dsLogsSistema.Enabled := True;

    dbgLogsSistema.Columns[0].FieldName:='id_log';
    dbgLogsSistema.Columns[0].Title.Caption:='ID';
    dbgLogsSistema.Columns[0].Width := 0;
    dbgLogsSistema.Columns[1].FieldName:='dth_log';
    dbgLogsSistema.Columns[1].Title.Caption:='DT/HR LOG';
    dbgLogsSistema.Columns[1].Width := 120;
    dbgLogsSistema.Columns[2].FieldName:='estacao';
    dbgLogsSistema.Columns[2].Title.Caption:='ESTAÇÃO';
    dbgLogsSistema.Columns[2].Width := 100;
    dbgLogsSistema.Columns[3].FieldName:='modulo';
    dbgLogsSistema.Columns[3].Title.Caption:='MÓDULO';
    dbgLogsSistema.Columns[3].Width := 100;
    dbgLogsSistema.Columns[4].FieldName:='formulario';
    dbgLogsSistema.Columns[4].Title.Caption:='FORMULÁRIO';
    dbgLogsSistema.Columns[4].Width := 100;
    dbgLogsSistema.Columns[5].FieldName:='acao';
    dbgLogsSistema.Columns[5].Title.Caption := 'AÇÃO';
    dbgLogsSistema.Columns[5].Width := 100;
    dbgLogsSistema.Columns[6].FieldName:='id_registro';
    dbgLogsSistema.Columns[6].Title.Caption := 'ID/COD REGISTRO';
    dbgLogsSistema.Columns[6].Width := 50;
    dbgLogsSistema.Columns[7].FieldName:='id_usuario';
    dbgLogsSistema.Columns[7].Title.Caption := 'ID USUÁRIO';
    dbgLogsSistema.Columns[7].Width := 50;
    dbgLogsSistema.Columns[8].FieldName:='usuario';
    dbgLogsSistema.Columns[8].Title.Caption := 'USUÁRIO';
    dbgLogsSistema.Columns[8].Width := 100;
    dbgLogsSistema.Columns[9].FieldName:='detalhes';
    dbgLogsSistema.Columns[9].Title.Caption := 'DETALHES';
    dbgLogsSistema.Columns[9].Width := 500;

    NReg := IntToStr(sqlqLogsSistema.RecordCount);

    LogStatusBar.Panels[0].Text := NReg+' registros de log';
  except on E: exception do
    begin
      sqlqLogsSistema.Free;
      dsLogsSistema.Free;
      Application.MessageBox(PChar('Erro ao carregar dados'+#13#13+'Classe '+E.ClassName+#13'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
end;

procedure TfrmRegLogsSistema.sbtnDeletarLogsClick(Sender: TObject);
var
  MSG_Log, ID_Log, MSG_Tarefa, ID_Excluir: String;
  i: Integer;
begin
  try
    ID_Excluir := EmptyStr;
    if not CheckPermission(UserPermissions,Modulo,'ADTLSDEL') then
      begin
        Application.MessageBox(PChar('Você não possui acesso a esta funcionalidade'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if dbgLogsSistema.SelectedRows.Count < 1 then
      begin
        Application.MessageBox(PChar('Selecione o(s) registro(s) que deseja apagar'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if Application.MessageBox(PChar('Deseja realmente excluir o(s) Log(s) de Sistema selecionado(s)?'), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
      begin
        if Application.MessageBox(PChar('Esta ação é irreversível e não poderá ser desfeita após a confirmação'+#13#13
                                        +'Deseja proceguir com a(s) exclusão(ões) do(s) registro(s)?'), 'Confirmação', MB_ICONWARNING + MB_YESNO) = MRYES then
          begin
            if dbgLogsSistema.SelectedRows.Count = 1 then
              begin
                MSG_Log := 'excluiu o log id '+dbgLogsSistema.DataSource.DataSet.FieldByName('id_log').Text;
                ID_Log := dbgLogsSistema.DataSource.DataSet.FieldByName('id_log').Text;
                MSG_Tarefa := 'O log foi excluído com sucesso';
              end
            else
              begin
                MSG_Log := 'excluiu '+IntToStr(dbgLogsSistema.SelectedRows.Count)+' registros de log';
                ID_Log := '';
                MSG_Tarefa := 'Os logs foram excluídos com sucesso';
              end;

              for i := 0 to dbgLogsSistema.SelectedRows.Count - 1 do
              	begin
              	sqlqLogsSistema.GotoBookmark(pointer(dbgLogsSistema.SelectedRows.Items[i]));
              	ID_Excluir := ID_Excluir + sqlqLogsSistema.FieldByName('id_log').AsString;
                if ((i >= 0)
                   and (i < dbgLogsSistema.SelectedRows.Count-1)) then
                  ID_Excluir := ID_Excluir + ',';
              	end;
            SQLExec(sqlqLogsOperacoes,['DELETE FROM g_log',
                                       'WHERE id_log IN ('+ID_Excluir+')']);

            Log(LowerCase(Modulo),'logs do sistema','apagar log',ID_Log,gID_Usuario_Logado,gUsuario_Logado,'<<o usuário '+gUsuario_Logado+' '+MSG_Log+'>>');
            sbtnAtualizar.Click;
            Application.MessageBox(PChar(MSG_Tarefa), 'Aviso', MB_ICONINFORMATION + MB_OK);
          end;
      end;
  Except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          sqlqLogsSistema.Free;
          sqlqLogsOperacoes.Free;
          Application.MessageBox(PChar('Erro ao tentar excluir o(s) log(s) selecionado(s)'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmRegLogsSistema.sbtnExpRegistrosClick(Sender: TObject);
var
  APoint: TPoint;
begin
  APoint.x := 0;
  APoint.y := 0;
  APoint := bcbtnExpRegistros.ClientToScreen(APoint);
  bcbtnExpRegistros.DropdownMenu.PopUp(APoint.X,APoint.Y+bcbtnExpRegistros.Height);
end;

procedure TfrmRegLogsSistema.sbtnGerFiltrosClick(Sender: TObject);
begin
  if ID_Filtro_Selecionado <> EmptyStr then
    begin
      frmExecutaFiltro := TfrmExecutaFiltro.Create(Nil);
      frmExecutaFiltro.ID_Filtro := ID_Filtro_Selecionado;
      frmExecutaFiltro.Show;
    end
  else
    begin
      frmFiltros := TfrmFiltros.Create(Nil);
      frmFiltros.Modulo := Modulo;
      frmFiltros.Formulario := Formulario;
      frmFiltros.Show;
    end;
end;

procedure TfrmRegLogsSistema.sbtnLimparLogsClick(Sender: TObject);
var
  Num_Logs: String;
begin
  try
    if not CheckPermission(UserPermissions,Modulo,'ADTLSLMP') then
      begin
        Application.MessageBox(PChar('Você não possui acesso a esta funcionalidade'+#13#13+'- Para solicitar acesso entre em contato com o administrador do sistema'),'Aviso', MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    if Application.MessageBox(PChar('Deseja realmente limpar os Logs de Sistema?'), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
      begin
        if Application.MessageBox(PChar('Esta ação é irreversível e não poderá ser desfeita após a confirmação'+#13#13
                                        +'Deseja proceguir com a exclusão dos registros?'), 'Confirmação', MB_ICONWARNING + MB_YESNO) = MRYES then
          begin
            Num_Logs := IntToStr(dbgLogsSistema.DataSource.DataSet.RecordCount);
            SQLExec(sqlqLogsOperacoes,['DELETE FROM g_log']);
            Log(LowerCase(Modulo),'logs do sistema','limpar logs','',gID_Usuario_Logado,gUsuario_Logado,'<<o usuário '+gUsuario_Logado+' limpou os logs do sistema ('+Num_Logs+' logs)>>');
            sbtnAtualizar.Click;
            Application.MessageBox(PChar('Os logs do sistema foram limpos'+#13+Num_Logs+' Logs foram excluídos'), 'Aviso', MB_ICONINFORMATION + MB_OK);
          end;
      end;
  Except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          sqlqLogsSistema.Free;
          sqlqLogsOperacoes.Free;
          Application.MessageBox(PChar('Erro ao tentar limpar os registros de logs do sistema'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;


end.

