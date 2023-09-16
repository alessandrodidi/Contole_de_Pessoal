unit uBtnTabSheet;

interface

uses
 Classes, Controls, ComCtrls, SysUtils, StdCtrls, Buttons, Types;

Type

  TCustumTabBtn  = class(TSpeedButton)
  private
    FbtnTab: TTabSheet;
    procedure SetbtnTab(const Value: TTabSheet);
  published
    public
      procedure Click; Override;
      property btnTab    :TTabSheet read FbtnTab write SetbtnTab;
  end;

 TBtnTabSheet  = class(TTabSheet)
    private
       FBtn: TCustumTabBtn;
       procedure SetupInternalBtn;
       procedure SetBtnPosition;
   protected
      procedure SetParent(AParent: TWinControl); override;
      procedure DoShow; override;
       procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    public
      constructor Create(AOwner: TComponent); override;
       procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
 end;

 procedure Register;

implementation

procedure Register;
begin
 //RegisterComponents(´Diego Tiemann´, [TBtnTabSheet]);
end;

{ TBtnTabSheet }

constructor TBtnTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //Chama a procedure que cria o BitBtn
  SetupInternalBtn;
end;

procedure TBtnTabSheet.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FBtn) and (Operation = opRemove) then
    FBtn := nil;
  end;

procedure TBtnTabSheet.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  //Chama a procedure que ajusta a posição do BitBtn
  SetBtnPosition;
end;

procedure TBtnTabSheet.SetBtnPosition;
var
 rec: TRect;
begin
  if not Assigned(PageControl) then
    exit;
  //aqui pego o rect da aba (bem lé em cima o cabeçalho)
  Rec := self.PageControl.TabRect(self.PageIndex);
  Fbtn.SetBounds(rec.Right-FBtn.Width, rec.Top, Fbtn.Width, Fbtn.Height);
 end;

procedure TBtnTabSheet.SetParent(AParent: TWinControl);
begin
  inherited;
  inherited SetParent(AParent);
  if FBtn = nil then
     exit;

  FBtn.Parent  := AParent;
  FBtn.Visible := True;
end;

procedure TBtnTabSheet.SetupInternalBtn;
begin
 if Assigned(FBtn) then
   exit;
  FBtn := TCustumTabBtn.Create(Self);
  FBtn.FreeNotification(Self);
  FBtn.Caption :='X';
  FBtn.Height  :=20;
  FBtn.Width   :=19;
  FBtn.Flat    :=True;
  FBtn.btnTab  :=Self;
end;

procedure TBtnTabSheet.DoShow;
begin
  inherited;
  {Aqui colocao um espaço no final do caption para o botão
  não sobreescrever o texto }
  if Pos(´      ´, Caption)=0 then
    Caption :=Caption+´      ´;
  SetBtnPosition;
end;

{ TCustumTabBtn }
procedure TCustumTabBtn.Click;
begin
  inherited;
  if Assigned(FbtnTab) then
    FbtnTab.Destroy;
end;

procedure TCustumTabBtn.SetbtnTab(const Value: TTabSheet);
begin
  FbtnTab := Value;
end;

end.
