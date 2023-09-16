unit UFiltros;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, DBGrids, ExtCtrls, ShellCtrls, LCLType, FileCtrl, Grids;

type

  { TfrmFiltros }

  TfrmFiltros = class(TForm)
    Bevel1: TBevel;
    btnAtualizar: TButton;
    btnNovo: TButton;
    btnRenomear: TButton;
    btnEditar: TButton;
    btnCopiar: TButton;
    btnExcluir: TButton;
    btnExecutar: TButton;
    btnFechar: TButton;
    ckbxFiltroDefault: TCheckBox;
    dsExpressoes: TDataSource;
    dbgFiltroSelecionado: TDBGrid;
    gpbxFiltros: TGroupBox;
    gpbxFiltroSelecionado: TGroupBox;
    imglstFiltros: TImageList;
    ltvwFiltros: TListView;
    sqlqFiltros: TSQLQuery;
    sqlqFiltrosOperacoes: TSQLQuery;
    sqlqExpressoes: TSQLQuery;
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnExecutarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnRenomearClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure ckbxFiltroDefaultExit(Sender: TObject);
    procedure dbgFiltroSelecionadoDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ltvwFiltrosInsert(Sender: TObject; Item: TListItem);
    procedure ltvwFiltrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ltvwFiltrosSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    ID_Filtro, Nome_Filtro, ID_Prop_Filtro, ID_Filtro_Padrao: String;
    Filtro_Global: Boolean;
  public
    Modulo, Formulario: String;
    MontaFiltro: Array of Array of String;
  end;

var
  frmFiltros: TfrmFiltros;

implementation

uses
  UConexao, UDBO, UGFunc, UEditorCadFiltros, UEditorFiltros, UExecutaFiltro;

{$R *.lfm}

{ TfrmFiltros }

procedure TfrmFiltros.FormCreate(Sender: TObject);
begin

end;

procedure TfrmFiltros.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    btnAtualizar.Click;
end;

procedure TfrmFiltros.btnAtualizarClick(Sender: TObject);
var
  item: TListItem;
begin
  try
    SQLQuery(sqlqFiltros,['SELECT F.id_filtro, F.filtro, F.detalhes, F.global, F.id_usuario, G.padrao'
                         ,'FROM g_filtros F'
                         ,'INNER JOIN g_filtros_usuarios G'
                         ,'ON G.id_filtro = F.id_filtro AND G.id_usuario = F.id_usuario' //'''+gID_Usuario_Logado+''''
                         ,'WHERE UPPER(F.modulo)='''+UPPERCASE(Modulo)+''' AND UPPER(F.formulario)='''+UPPERCASE(Formulario)+''' AND (F.id_usuario='''+gID_Usuario_Logado+''' OR F.global = true)'
                         ,'ORDER BY F.global DESC, F.filtro']);

    if ltvwFiltros.SelCount > 0 then
      ltvwFiltros.Selected.Selected := False;

    ID_Filtro := EmptyStr;
    Nome_Filtro := EmptyStr;
    ID_Filtro_Padrao := EmptyStr;
    Filtro_Global := False;
    ckbxFiltroDefault.Checked := False;

    ltvwFiltros.Clear;
    sqlqFiltros.First;
    while not sqlqFiltros.Eof do
      begin
        item := ltvwFiltros.Items.Add;
        item.Caption := '';
        item.ImageIndex := sqlqFiltros.FieldByName('global').AsInteger;
        item.SubItems.Add(sqlqFiltros.FieldByName('id_filtro').Text);
        item.SubItems.Add(sqlqFiltros.FieldByName('padrao').Text);
        item.SubItems.Add(sqlqFiltros.FieldByName('filtro').Text);
        item.SubItems.Add(sqlqFiltros.FieldByName('id_usuario').Text);
        item.SubItems.Add(sqlqFiltros.FieldByName('global').Text);

        if sqlqFiltros.FieldByName('padrao').AsBoolean then
          ID_Filtro_Padrao := sqlqFiltros.FieldByName('id_filtro').Text;
        sqlqFiltros.Next;
      end;
  except on E: exception do
    begin
      item.Free;
      sqlqFiltros.Free;
      Application.MessageBox(PChar('Erro ao carregar os filtros'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
end;

procedure TfrmFiltros.btnExcluirClick(Sender: TObject);
begin
  try
    if ltvwFiltros.SelCount > 0 then
      begin
        if ID_Prop_Filtro <> gID_Usuario_Logado then
          begin
            Application.MessageBox(PChar('Você não pode excluir o filtro '''+Nome_Filtro+''' pois ele foi desenvolvido por outro usuário'), 'Aviso', MB_ICONINFORMATION + MB_OK);
            Exit;
          end;
        if Application.MessageBox(PChar('Deseja realmente excluir o filtro '''+Nome_Filtro+'''?'), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
          begin
            //Apaga a expressao construída para o filtro
            SQLExec(sqlqFiltrosOperacoes,['DELETE FROM g_filtros_expressoes'
                                         ,'WHERE id_filtro = '+ID_Filtro]);
            //Apaga os parametros de usuario do filtro
            SQLExec(sqlqFiltrosOperacoes,['DELETE FROM g_filtros_usuarios'
                                         ,'WHERE id_filtro = '+ID_Filtro]);
            //Apaga o filtro
            SQLExec(sqlqFiltrosOperacoes,['DELETE FROM g_filtros'
                                         ,'WHERE id_filtro = '+ID_Filtro]);

            //Application.MessageBox(PChar('O filtro '''+Nome_Filtro+''' foi excluído com sucesso!'), 'Aviso', MB_ICONINFORMATION + MB_OK);
            btnAtualizar.Click;
          end;
      end;
  except on E: Exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar excluir o filtro '''+Nome_Filtro+''+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmFiltros.btnExecutarClick(Sender: TObject);
begin
  frmExecutaFiltro := TfrmExecutaFiltro.Create(Self);
  frmExecutaFiltro.ID_Filtro := ID_Filtro;
  frmExecutaFiltro.Show;
  Self.Close;

  {if ltvwFiltros.SelCount > 0 then
    begin
      CamposDinamicos := False;
      i := 0;
      SetLength(MontaFiltro,sqlqExpressoes.RecordCount,9);
      sqlqExpressoes.First;
      while not sqlqExpressoes.EOF do
        begin
          Valor := sqlqExpressoes.FieldByName('valor').Text;
          Valor_Final := sqlqExpressoes.FieldByName('valor_final').Text;
          if ((Copy(Valor, Pos('[', Valor), Pos(']', Valor)) <> EmptyStr)
             or (Copy(Valor_Final, Pos('[', Valor_Final), Pos(']', Valor_Final)) <> EmptyStr)) then
            begin
              CamposDinamicos := True;
              MontaFiltro[i,0] := Copy(Valor, Pos('[', Valor)+1, Pos(']', Valor)-2);
              MontaFiltro[i,1] := Copy(Valor_Final, Pos('[', Valor_Final)+1, Pos(']', Valor_Final)-2);
              MontaFiltro[i,2] := sqlqExpressoes.FieldByName('id_expressao').Text;
              MontaFiltro[i,3] := sqlqExpressoes.FieldByName('condicao').Text;
              MontaFiltro[i,4] := sqlqExpressoes.FieldByName('campo').Text;
              MontaFiltro[i,5] := sqlqExpressoes.FieldByName('criterio').Text;
              MontaFiltro[i,6] := sqlqExpressoes.FieldByName('valor').Text;
              MontaFiltro[i,7] := sqlqExpressoes.FieldByName('valor_final').Text;
              MontaFiltro[i,8] := '';
            end
          else
            begin
              MontaFiltro[i,0] := '';
              MontaFiltro[i,1] := '';
              MontaFiltro[i,2] := '';
              MontaFiltro[i,3] := '';
              MontaFiltro[i,4] := '';
              MontaFiltro[i,5] := '';
              MontaFiltro[i,6] := '';
              MontaFiltro[i,7] := '';
              MontaFiltro[i,8] := sqlqExpressoes.FieldByName('expressao').Text;
            end;

          Filtro := Filtro+#13+sqlqExpressoes.FieldByName('expressao').Text;

          sqlqExpressoes.Next;
          i:=i+1;
        end;
      if CamposDinamicos then
        begin
          frmCriteriosFiltroDin := TfrmExecutaFiltro.Create(Self);
          SetLength(frmCriteriosFiltroDin.MontaFiltro,High(MontaFiltro)+1,9);

          for j:=0 to High(MontaFiltro) do
            begin
              frmCriteriosFiltroDin.MontaFiltro[j,0] := MontaFiltro[j,0];
              frmCriteriosFiltroDin.MontaFiltro[j,1] := MontaFiltro[j,1];
              frmCriteriosFiltroDin.MontaFiltro[j,2] := MontaFiltro[j,2];
              frmCriteriosFiltroDin.MontaFiltro[j,3] := MontaFiltro[j,3];
              frmCriteriosFiltroDin.MontaFiltro[j,4] := MontaFiltro[j,4];
              frmCriteriosFiltroDin.MontaFiltro[j,5] := MontaFiltro[j,5];
              frmCriteriosFiltroDin.MontaFiltro[j,6] := MontaFiltro[j,6];
              frmCriteriosFiltroDin.MontaFiltro[j,7] := MontaFiltro[j,7];
              frmCriteriosFiltroDin.MontaFiltro[j,8] := MontaFiltro[j,8];
            end;
          frmCriteriosFiltroDin.Show;
          Self.Close;
        end
      else
        begin
          ShowMessage(Filtro);
          Self.Close;
        end;
      //ShowMessage(Filtro);
    end;}
end;

procedure TfrmFiltros.btnFecharClick(Sender: TObject);
begin
  Self.Close
end;

procedure TfrmFiltros.btnRenomearClick(Sender: TObject);
begin
  if ltvwFiltros.SelCount > 0 then
    begin
      if ID_Prop_Filtro <> gID_Usuario_Logado then
        begin
          Application.MessageBox(PChar('Você não pode editar o filtro '''+Nome_Filtro+''' pois ele foi desenvolvido por outro usuário'), 'Aviso', MB_ICONINFORMATION + MB_OK);
          Exit;
        end;

      frmEditorCadFiltros := TfrmEditorCadFiltros.Create(Nil);
      frmEditorCadFiltros.ID_Filtro := ID_Filtro;
      //frmEditorFiltros.Filtro := Filtro;
      //frmEditorFiltros.Filtro_Global := Filtro_Global;
      frmEditorCadFiltros.Modulo := Modulo;
      frmEditorCadFiltros.Formulario := Formulario;
      frmEditorCadFiltros.Show;
    end;
end;

procedure TfrmFiltros.btnNovoClick(Sender: TObject);
begin
  frmEditorCadFiltros := TfrmEditorCadFiltros.Create(Nil);
  frmEditorCadFiltros.Modulo := Modulo;
  frmEditorCadFiltros.Formulario := Formulario;
  frmEditorCadFiltros.Show;
end;

procedure TfrmFiltros.btnEditarClick(Sender: TObject);
begin
  if ltvwFiltros.SelCount > 0 then
    begin
      if ID_Prop_Filtro <> gID_Usuario_Logado then
        begin
          Application.MessageBox(PChar('Você não pode editar o filtro '''+Nome_Filtro+''' pois ele foi desenvolvido por outro usuário'), 'Aviso', MB_ICONINFORMATION + MB_OK);
          Exit;
        end;

      frmEditorFiltros := TfrmEditorFiltros.Create(Nil);
      frmEditorFiltros.ID_Filtro := ID_Filtro;
      frmEditorFiltros.Show;
    end;
end;

procedure TfrmFiltros.ckbxFiltroDefaultExit(Sender: TObject);
var
  Padrao: String;
  ID_Filtro_Padrao_U: Integer;
begin
  try
    if ckbxFiltroDefault.Checked then
      Padrao := '1'
    else
      Padrao := '0';

    SQLQuery(sqlqFiltros,['SELECT F.id_filtro, G.padrao'
                         ,'FROM g_filtros F'
                         ,'INNER JOIN g_filtros_usuarios G'
                         ,'ON G.id_filtro = F.id_filtro AND G.id_usuario = F.id_usuario' //'''+gID_Usuario_Logado+''''
                         ,'WHERE UPPER(F.modulo)='''+UPPERCASE(Modulo)+''' AND UPPER(F.formulario)='''+UPPERCASE(Formulario)+''' AND (F.id_usuario='''+gID_Usuario_Logado+''' OR F.global = true) AND G.padrao = true'
                         ,'ORDER BY F.global DESC, F.filtro']);

    ID_Filtro_Padrao_U := sqlqFiltros.FieldByName('id_filtro').AsInteger;

    //if ((ID_Filtro_Padrao <> EmptyStr)
    //    and (ID_Filtro_Padrao <> ID_Filtro))  then
    if ID_Filtro_Padrao_U > 0 then
      begin
        showmessage('possui filtro padrão '+inttostr(ID_Filtro_Padrao_U)+' '+ID_Filtro);
        {SQLExec(sqlqFiltrosOperacoes,['UPDATE g_filtros_usuarios'
                                     ,'SET padrao = 0'
                                     ,'WHERE id_filtro = '''+ID_Filtro_Padrao+''''
                                            ,'AND id_usuario = '''+gID_Usuario_Logado+'''']);}
      end;
    showmessage('não possui filtro padrão '+inttostr(ID_Filtro_Padrao_U)+' '+ID_Filtro);
    {SQLExec(sqlqFiltrosOperacoes,['UPDATE g_filtros_usuarios'
                                 ,'SET padrao = 0'
                                 ,'WHERE id_filtro IN (SELECT id_filtro FROM g_filtros'
                                                      ,'WHERE modulo = '''+Modulo+''''
                                                            ,'AND formulario = '''+Formulario+''''
                                                            ,'AND id_usuario = '''+gID_Usuario_Logado+''')']);

    SQLExec(sqlqFiltrosOperacoes,['UPDATE g_filtros_usuarios'
                                 ,'SET padrao = '+Padrao
                                 ,'WHERE id_filtro = '''+ID_Filtro+''''
                                        ,'AND id_usuario = '''+gID_Usuario_Logado+'''']);}
    //btnAtualizar.Click;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          sqlqFiltrosOperacoes.Free;
          Application.MessageBox(PChar('Erro ao definir filtro padrão'), 'Erro', MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmFiltros.dbgFiltroSelecionadoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dbgFiltroSelecionado.Columns.Items[0].Width < dbgFiltroSelecionado.Width-20 then
    dbgFiltroSelecionado.Columns.Items[0].Width := dbgFiltroSelecionado.Width-20;
end;

procedure TfrmFiltros.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ltvwFiltros.Free;
  Self := Nil;
end;

procedure TfrmFiltros.FormShow(Sender: TObject);
begin
  if ((Modulo = 'AUDITORIA')
     AND (Formulario = 'ADTLSACS')) then
    Self.Caption := Self.Caption+' [Logs de Sistema]';

  btnAtualizar.Click;
end;

procedure TfrmFiltros.ltvwFiltrosInsert(Sender: TObject; Item: TListItem);
begin
  if ltvwFiltros.Column[3].Width <= ltvwFiltros.Width-ltvwFiltros.Column[0].Width-4 then
    begin
      ltvwFiltros.Column[3].AutoSize := False;
      ltvwFiltros.Column[3].Width := ltvwFiltros.Width-ltvwFiltros.Column[0].Width-4;
    end
  else
    ltvwFiltros.Column[3].AutoSize := True;
end;

procedure TfrmFiltros.ltvwFiltrosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  TipoFiltroModif, StatusGlob: String;
begin
  if (ltvwFiltros.SelCount > 0)
    and ((ssCtrl in Shift) and (Key = VK_G)) then
    begin
      if Filtro_Global then
        begin
          TipoFiltroModif := 'privado';
          StatusGlob := '0';
        end
      else
        begin
          TipoFiltroModif := 'global';
          StatusGlob := '1';
        end;
      if ID_Prop_Filtro = gID_Usuario_Logado then
        begin
          if Application.MessageBox(PChar('Deseja transformar o filtro '''+Nome_Filtro+''' em um filtro '+TipoFiltroModif+'?'),'Confirmação', MB_ICONQUESTION + MB_YESNO) = MRYES then
            begin
              SQLExec(sqlqFiltrosOperacoes,['UPDATE g_filtros'
                                           ,'SET global = '''+StatusGlob+''''
                                           ,'WHERE id_filtro = '''+ID_Filtro+''''
                                           ,'AND id_usuario = '''+gID_Usuario_Logado+'''']);
              btnAtualizar.Click;
            end;
        end
      else
        Application.MessageBox(PChar('Você não pode transformar o filtro '''+Nome_Filtro+''' em um filtro '+TipoFiltroModif+' pois ele foi desenvolvido por outro usuário'), 'Aviso', MB_ICONINFORMATION + MB_OK);
    end;

  if ((ltvwFiltros.SelCount > 0)
     and (Key = VK_DELETE)) then
    begin
      btnExcluir.Click;
    end;
end;

procedure TfrmFiltros.ltvwFiltrosSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ltvwFiltros.SelCount > 0 then
    begin
      ID_Filtro := ltvwFiltros.Items[ltvwFiltros.Selected.Index].SubItems[0];
      Nome_Filtro := ltvwFiltros.Items[ltvwFiltros.Selected.Index].SubItems[2];
      ID_Prop_Filtro := ltvwFiltros.Items[ltvwFiltros.Selected.Index].SubItems[3];
      Filtro_Global := StrToBool(ltvwFiltros.Items[ltvwFiltros.Selected.Index].SubItems[4]);

      if StrToBool(ltvwFiltros.Items[ltvwFiltros.Selected.Index].SubItems[1]) then
        ckbxFiltroDefault.Checked := True
      else
        ckbxFiltroDefault.Checked := False;

      SQLQuery(sqlqExpressoes,['SELECT expressao'
                              ,'FROM g_filtros_expressoes'
                              ,'WHERE id_filtro = '''+ID_Filtro+''''
                              ,'ORDER BY ordem, id_expressao']);
      //dbgFiltroSelecionado.Columns[0].Width := ;
    end
  else
    begin
      ckbxFiltroDefault.Checked := False;
      ID_Filtro := EmptyStr;
      Nome_Filtro := EmptyStr;
      ID_Prop_Filtro := EmptyStr;
      Filtro_Global := False;
      dbgFiltroSelecionado.SelectedRows.Clear;
    end;
end;

end.

