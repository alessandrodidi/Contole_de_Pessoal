unit UCriteriosFiltrosDin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, MaskEdit, RTTICtrls, LCLType;

type

  { TfrmCriteriosFiltroDin }

  TfrmCriteriosFiltroDin = class(TForm)
    btnExecutar: TButton;
    btnCancelar: TButton;
    gpbxCriterios: TGroupBox;
    pnlComandos: TPanel;
    sqlqExpressoes: TSQLQuery;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExecutarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    lblCampo, lblCampo2: TLabel;
    edtCampo, edtCampo2: TEdit;
  public
    MontaFiltro: Array of Array of String;
    ID_Filtro: String;
  end;

var
  frmCriteriosFiltroDin: TfrmCriteriosFiltroDin;

implementation

Uses
  UGFunc, UFiltros, UDBO, UConexao;

{$R *.lfm}

{ TfrmCriteriosFiltroDin }

procedure TfrmCriteriosFiltroDin.FormShow(Sender: TObject);
var
  i,j,n,topPos, topPos2: Integer;
  Valor, Valor_Final, Filtro: String;
  CamposDinamicos: Boolean;
begin
  try
    SQLQuery(sqlqExpressoes,['SELECT *'
                            ,'FROM g_filtros_expressoes'
                            ,'WHERE id_filtro = '''+ID_Filtro+''''
                            ,'ORDER BY ordem, id_expressao']);

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

    topPos2 := 0;
    n := 0;

    if CamposDinamicos then
      begin
        //Laço para varrer o array com as expressões carredas da janela de filtros
        for i:=0 to High(MontaFiltro) do
          begin
            //Verifica a expressão e monta o campo do valor a ser filtrado
            if MontaFiltro[i,0] <> EmptyStr then
              begin
                //Calcula a posição vertical em que o objeto deverá criado
                if topPos2 > 0 then topPos2 := 28;
                if n = 0 then topPos := 8 else topPos := (topPos+28)+topPos2;

                //Ajusta o tamanho e a posição vertical da janela
                Self.Height := Self.Height + 28;
                Self.Top := Self.Top - 14;

                //Coloca o label com a descição do Campo
                lblCampo := TLabel.Create(Self);
                lblCampo.Parent := gpbxCriterios;
                lblCampo.Name := 'lblCampo_'+IntToStr(i);
                lblCampo.Left := 8;
                lblCampo.Top := topPos+4;
                lblCampo.Visible := True;
                lblCampo.Caption := MontaFiltro[i,0];

                //Monta o edit para digitar o valor a ser filtrado
                edtCampo := TEdit.Create(Self);
                edtCampo.Parent := gpbxCriterios;
                edtCampo.Name := 'edtCampo_'+IntToStr(i);
                edtCampo.Left := lblCampo.Width+13;
                edtCampo.Top := topPos;
                edtCampo.Width := gpbxCriterios.Width-(lblCampo.Width+25);
                edtCampo.Visible := True;
                edtCampo.Text := '';
                edtCampo.Hint := MontaFiltro[i,0];
                edtCampo.ShowHint := True;

                //Incrementa o controle de objetos criados
                n:=n+1;

                //Zera o parâmetro de posição vertical do campo secundário
                topPos2 := 0;
              end;

            //Verifica a expressão e monta o campo do valor final, se ele for requerido pela condição de busca
            if MontaFiltro[i,1] <> EmptyStr then
              begin
                //Calcula a posição vertical em que o objeto deverá criado
                topPos2 := topPos + 28;

                //Ajusta o tamanho e a posição vertical da janela
                Self.Height := Self.Height + 28;
                Self.Top := Self.Top - 14;

                //Cria o label com a descrição do campo de pesquisa
                lblCampo2 := TLabel.Create(Self);
                lblCampo2.Parent := gpbxCriterios;
                lblCampo2.Name := 'lblCampo2_'+IntToStr(i);
                lblCampo2.Left := 8;
                lblCampo2.Top := topPos2+4;
                lblCampo2.Visible := True;
                lblCampo2.Caption := MontaFiltro[i,1];

                //Cria o edti para digitação do valor secundário de pesquisa
                edtCampo2 := TEdit.Create(Self);
                edtCampo2.Parent := gpbxCriterios;
                edtCampo2.Name := 'edtCampo2_'+IntToStr(i);
                edtCampo2.Left := lblCampo2.Width+13;
                edtCampo2.Top := topPos2;
                edtCampo2.Width := gpbxCriterios.Width-(lblCampo2.Width+25);
                edtCampo2.Visible := True;
                edtCampo2.Text := '';
                edtCampo2.Hint := MontaFiltro[i,1];
                edtCampo2.ShowHint := True;

                //Incrementa o controle de objetos criados
                n:=n+1;
              end;
          end;
      end
    else
      begin
        ShowMessage(Filtro);
        Self.Close;
      end;
  except on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao tentar criar o(s) campo(s) de critério(s)'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro', MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmCriteriosFiltroDin.btnExecutarClick(Sender: TObject);
var
  i,j: Integer;
  Expressao, FiltroF, CriterioF, CondicaoF, CampoF, Valor1, Valor2, ValorR1, ValorR2, ValorF: String;
  Separador: Array[0..0] of Char;
  ArrayValor: Array of String;
begin
  try
    {if CamposDinamicos then
        begin
          frmCriteriosFiltroDin := TfrmCriteriosFiltroDin.Create(Self);
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
        end;}
    //Instancia a variável como vazia
    Expressao := EmptyStr;

    //Laço para varrer o array com as expressões carredas da janela de filtros
    for i:=0 to High(MontaFiltro) do
      begin
        //Verifica se o campo foi criado no formulário
        if TEdit(Self.FindComponent('edtCampo_'+IntToStr(i))) <> Nil then
          begin
            //Se o componente foi criado alimenta a variável Valor1 com o valor digitado no campo
            Valor1 := TEdit(Self.FindComponent('edtCampo_'+IntToStr(i))).Text;
            Separador[0] := ';';
            ArrayValor := Valor1.Split(Separador);

            //Laço para montar o valor digitado no campo, se for array ele já faz as separações
            for j := 0 to Length(ArrayValor)-1 do
              begin
                if j = 0 then
                  ValorR1 := ''''+ArrayValor[j]+''''
                else
                  ValorR1 := ValorR1+','''+ArrayValor[j]+'''';
              end;
          end
        else
          Valor1 := EmptyStr;

        //Verifica se o campo foi criado no formulário
        if TEdit(Self.FindComponent('edtCampo2_'+IntToStr(i))) <> Nil then
          begin
            //Se o componente foi criado alimenta a variável Valor1 com o valor digitado no campo
            Valor2 := TEdit(Self.FindComponent('edtCampo2_'+IntToStr(i))).Text;
            Separador[0] := ';';
            ArrayValor := Valor2.Split(Separador);

            //Laço para montar o valor digitado no campo, se for array ele já faz as separações
            for j := 0 to Length(ArrayValor)-1 do
              begin
                if j = 0 then
                  ValorR2 := ''''+ArrayValor[j]+''''
                else
                  ValorR2 := ValorR2+','''+ArrayValor[j]+'''';
              end;
          end
        else
          Valor2 := EmptyStr;

        //Verifica a expressão e se for o caso preenche com os dados preenchidos no formulário
        if ((MontaFiltro[i,0] <> EmptyStr)
           or (MontaFiltro[i,1] <> EmptyStr)) then
          begin
            CriterioF := MontaFiltro[i,5];
            CondicaoF := MontaFiltro[i,3];
            CampoF := MontaFiltro[i,4];

            //Monta a expressão de acordo com o critário
            if ((CriterioF = 'BETWEEN')
               or (CriterioF = 'NOT BETWEEN')) then
              begin
                ValorF := CriterioF+' '+ValorR1+' AND '+ValorR2+'';
              end
            else
            if ((CriterioF = 'IN')
               or (CriterioF = 'NOT IN')) then
              begin
                ValorF := CriterioF+' ('+ValorR1+')'
              end
            else
              ValorF := CriterioF+' '+ValorR1;
            Expressao := Expressao +#13+ (CondicaoF+' '+CampoF+' '+ValorF);
          end
        else
          begin
            Expressao := Expressao +#13+(MontaFiltro[i,8]);
          end;
      end;

    Showmessage(Expressao);
    Self.Close;
  except on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao tentar aplicar o filtro'+#13#13+'Classe '+E.ClassName+#13+'Detalhes: '+E.Message),'Erro', MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmCriteriosFiltroDin.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmCriteriosFiltroDin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Key := VK_TAB;

  if Key = VK_ESCAPE then
    btnCancelar.Click;
end;

end.

