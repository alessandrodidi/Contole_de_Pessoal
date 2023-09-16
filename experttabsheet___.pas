unit ExpertTabSheet;

interface

uses
  Windows, Classes, ExtCtrls, Dialogs, ComCtrls, Forms, Buttons,
  Controls, SysUtils, Themes, UxTheme, Graphics;

type ETabSheet = Class (TTabSheet)
  private
    FCloseBtn: TSpeedButton;
    procedure CloseBtn(AOwner: TWinControl);
    procedure CloseBtnClick(Sender: TObject);
  protected
    function ReleaseContainer(TabSheet: ETabSheet): Boolean;
    procedure RemoveTabSheet(TabSheet: ETabSheet);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
end;

  procedure OpenWindowTab(PageControl: TPageControl; Form: TForm; Parameters: Array of String);
  procedure CloseAllTabs(PageControl: TPageControl);
  function GetParameter(Parameters: Array of String; Parameter: String): String;

implementation

constructor ETabSheet.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor ETabSheet.Destroy;
begin
  inherited Destroy;
end;

procedure OpenWindowTab(PageControl: TPageControl; Form: TForm; Parameters: Array of String);
var
  i: Integer;
  FormClass: TFormClass;
  FormOwner: TComponent;
  TabSheet: ETabSheet;
  TitleBar, ButtonsSet: TPanel;
  MultiTab: Boolean;
  TabTitle, Title: String;
begin
  try
    //PageControl.OwnerDraw := true;
    TabSheet := ETabSheet.Create(PageControl);

    //Get parameters
    try
      if GetParameter(Parameters,'FormClass') <> EmptyStr then
        FormClass := TFormClass(GetClass(GetParameter(Parameters,'FormClass')));

      if GetParameter(Parameters,'FormOwner') <> EmptyStr then
        FormOwner := TComponent(GetClass(GetParameter(Parameters,'FormOwner')))
      else
        FormOwner := Nil;

      //Check if form is create
      if Form = Nil then
        begin
          if GetParameter(Parameters,'FormClass') <> EmptyStr then
            begin
              Form := FormClass.Create(FormOwner);
            end
          else
            begin
              Application.MessageBox(PChar('Erro ao tentar criar o formulário'+#13+'Deve ser informada a classe para a criação do formulário'), 'Erro', MB_ICONERROR + MB_OK);
              Exit;
            end;
        end;
    except on E: exception do
      begin
        Application.MessageBox(PChar('Erro ao tentar criar o formulário'+#13+#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message),'Erro', MB_ICONERROR + MB_OK);
        Form.Free;
        Exit;
      end;
    end;

    if GetParameter(Parameters,'MultiTab') <> EmptyStr then
      MultiTab := StrToBool(GetParameter(Parameters,'MultiTab'))
    else
      MultiTab := False;

    if GetParameter(Parameters,'TabTitle') <> EmptyStr then
      TabTitle := GetParameter(Parameters,'TabTitle')
    else
      TabTitle := Form.Caption;

    if GetParameter(Parameters,'Title') <> EmptyStr then
      Title := GetParameter(Parameters,'Title')
    else
      Title := TabTitle;

    //Check if form is open
    for i := 0 to PageControl.ControlCount -1 do
    if (PageControl.Pages[i].Caption = TabTitle) and (MultiTab = False) then
      begin
        PageControl.ActivePageIndex := i;
        Exit;
      end;

    //Create TabSheet
    TabSheet.PageControl := PageControl;
    //Form := FormClass.Create(TabSheet);
    Form.Parent := TabSheet;

    //Create TabSheet Title bar
    TitleBar := TPanel.Create(TabSheet);
    TitleBar.Parent := TabSheet;
    TitleBar.Align := alTop;
    TitleBar.Height := 22;
    TitleBar.Caption := Title;
    TitleBar.Color := clWindow;
    TitleBar.Visible := True;

    //Set form proprieties
    Form.Align := alClient;
    Form.BorderStyle := bsNone;
    Form.Visible := True;
    TabSheet.Caption := TabTitle;

    //Create Buttons Set
    ButtonsSet := TPanel.Create(TitleBar);
    ButtonsSet.Parent := TitleBar;
    ButtonsSet.Align := alRight;
    ButtonsSet.Caption := '';
    ButtonsSet.Width := 80;
    ButtonsSet.BorderSpacing.Right := 1;
    ButtonsSet.BiDiMode := bdRightToLeft;
    ButtonsSet.BorderStyle := bsNone;
    ButtonsSet.BevelInner := bvNone;
    ButtonsSet.BevelOuter := bvNone;
    ButtonsSet.Anchors := [akTop,akRight];
    ButtonsSet.Color := clNone;
    ButtonsSet.Visible := True;

    //Create close button to TabSheet
    TabSheet.CloseBtn(ButtonsSet);

    //Activate opened tabsheet
    PageControl.ActivePage := TabSheet;
    if (Form <> Nil)
       and (Form.Enabled) then
      Form.SetFocus;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Falha ao tentar criar a nova aba '+Form.Caption+''+#13#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      FreeAndNil(Form);
      ButtonsSet.Free;
      TitleBar.Free;
      TabSheet.Free;
      Abort;
    end;
  end;
end;

procedure ETabSheet.CloseBtn(AOwner: TWinControl);
begin
  try
    //Check if CloseBtn is created
    if FCloseBtn <> Nil then Exit;

    //Create CloseBtn
    FCloseBtn := TSpeedButton.Create(AOwner);
    FCloseBtn.Parent := AOwner;
    FCloseBtn.Width := 19;
    FCloseBtn.Height := 19;
    FCloseBtn.Left := 60;
    FCloseBtn.BorderSpacing.Around := 1;
    FCloseBtn.BorderSpacing.InnerBorder := 0;
    FCloseBtn.BorderSpacing.CellAlignHorizontal := ccaCenter;
    FCloseBtn.BorderSpacing.CellAlignVertical := ccaCenter;
    FCloseBtn.Align := alNone;
    FCloseBtn.Anchors := [akTop,akRight];
    FCloseBtn.Caption := 'X';
    FCloseBtn.Hint := 'Fechar aba';
    FCloseBtn.Transparent := True;
    FCloseBtn.ShowHint := True;
    FCloseBtn.Visible := True;
    FCloseBtn.OnClick := @CloseBtnClick;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Falha ao tentar criar o botão fechar para a nova aba'+#13#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      FreeAndNil(FCloseBtn);
      FreeAndNil(AOwner);
      Exit;
    end;
  end;
end;

procedure ETabSheet.CloseBtnClick(Sender: TObject);
var
  TabSheet: ETabSheet;
  TabSheetCaption: String;
begin
  try
    TabSheet := ((Sender as TSpeedButton).Parent.Parent.Parent as ETabSheet);
    TabSheetCaption := TabSheet.Caption;
    if ReleaseContainer(TabSheet) then
      RemoveTabSheet(TabSheet);
  except on E: exception do
    begin
      Application.MessageBox(PChar('Falha na execução da rotina de fechamento da aba '+TabSheetCaption+#13#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      FreeAndNil(TabSheet);
      Exit;
    end;
  end;
end;

function ETabSheet.ReleaseContainer(TabSheet: ETabSheet): Boolean;
var
  i: Integer;
  FormName: String;
begin
  try
    if Assigned(TabSheet) then
      begin
        Result := False;
        i := TabSheet.ControlCount-1;
        while i >= 0 do
          begin
            if (TabSheet.Controls[i] is TForm) then
              begin
                FormName := (TabSheet.Controls[i] as TForm).Name;
                (TabSheet.Controls[i] as TForm).Close;
                Result := True;
              end;
            i:=i-1;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar liberar o container '+FormName+#13#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          TabSheet.Free;
          Exit;
        end;
    end;
  end;
end;

procedure ETabSheet.RemoveTabSheet(TabSheet: ETabSheet);
var
  TabSheetCaption: String;
begin
  try
    if Assigned(TabSheet) then
      begin
        TabSheetCaption := TabSheet.Caption;
        TabSheet.Free;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar fechar a aba '+TabSheetCaption+#13#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          TabSheet.Free;
          Exit;
        end;
    end;
  end;
end;

procedure CloseAllTabs(PageControl: TPageControl);
var
  i,j: Integer;
  TabSheet: TTabSheet;
  TabSheetCaption: String;
begin
  try
    //Result := True;
    if Assigned(PageControl) then
      begin
        i := PageControl.PageCount-1;
        while i >= 0 do
          begin
            TabSheet := PageControl.Pages[i];
            TabSheetCaption := TabSheet.Caption;
            if Assigned(TabSheet) then
              begin
                j := TabSheet.ControlCount-1;
                while j >= 0 do
                  begin
                    if (TabSheet.Controls[j] is TForm) then
                      begin
                        (TabSheet.Controls[j] as TForm).Close;
                        TabSheet.Free;
                      end;
                    j:=j-1;
                  end;
              end;
            i:=i-1;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName = 'EAbort' then
        begin
          PageControl.ActivePage := TabSheet;
          //Result := False;
          Abort;
        end
      else
        begin
          Application.MessageBox(PChar('Erro ao tentar fechar a aba '+TabSheetCaption+#13#13+'Classe '+E.ClassName+#13+'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
          TabSheet.Free;
        end;
    end;
  end;
end;

function GetParameter(Parameters: Array of String; Parameter: String): String;
var
  i,n: Integer;
  v: Boolean;
  Param1,Param2: String;
begin
  try
    Result := EmptyStr;
    for i:= Low(Parameters) to High(Parameters) do
      begin
        Param1 := Copy(Parameters[i],1,pos(':',Parameters[i])-1);
        if Param1 = Parameter then
          begin
            n := 0;
            v := False;
            Param2 := Copy(Parameters[i],pos(':',Parameters[i])+1,Length(Parameters[i]));
            if Length(Param2) > 0 then
              begin
                while v = False do
                  begin
                    if Copy(Param2,n,1) <> ' ' then
                      begin
                        Param2 := Copy(Param2,n,Length(Param2));
                        v := True;
                      end;
                    n := n+1;
                  end;
                n := Length(Param2);
                v := False;
                while v = False do
                  begin
                    if Copy(Param2,n,1) <> ' ' then
                      begin
                        Result := Copy(Param2,1,n);
                        v := True;
                      end;
                    n := n-1;
                  end;
              end;
          end;
      end;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Falha ao tentar carregar os parâmetros'+#13#13+'Erro: '+E.Message),'Erro',MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
end;

initialization
  ETabSheet.ClassName;

end.
