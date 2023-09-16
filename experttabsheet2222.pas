unit ExpertTabSheet;

interface

uses
  Classes, Forms, Controls, ComCtrls, LCLIntf, LCLType;

type

  { TODPageControl }

  TODPageControl=class(TPageControl)
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure PaintWindow(DC: HDC); override;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    pc: TODPageControl;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var ts: TTabSheet;
begin
  pc:=TODPageControl.Create(Self);
  pc.Align:=alBottom;
  pc.Parent:=Self;
  ts:=pc.AddTabSheet;
  ts.Caption:='First';
  ts:=pc.AddTabSheet;
  ts.Caption:='Second';
  ts:=pc.AddTabSheet;
  ts.Caption:='Third';
end;

{ TODPageControl }

procedure TODPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var r:TRect;
    i, h2:integer;
begin
  if Button=mbLeft then begin
    i:= TabPosition(Point(X,Y));
    r:=TabRect(i);
    h2:=((r.Bottom-r.Top) div 3) shl 1;
    if (X>r.Right-h2) and (Y<r.Top+h2) then
      self.RemovePage(i);
  end;
end;

procedure TODPageControl.PaintWindow(DC: HDC);
var r:TRect;
    points: array[0..1] of TPoint;
    i, h, h2: Integer;
begin
  inherited PaintWindow(DC);

  for i:=0 to PageCount-1 do begin
    r:= TabRect(i);
    h:=(r.Bottom-r.Top) div 3;
    h2:=h shl 1;
    if Rectangle(DC, r.Right-h2, r.Top+h, r.Right-h, r.Top+h2) then
      begin
        points[0].x:=r.Right-h2;
        points[0].y:=r.Top+h;
        points[1].x:=r.Right-h;
        points[1].y:=r.Top+h2;
        Polyline(DC,@points,2);
        points[0].x:=r.Right-h;
        points[0].y:=r.Top+h;
        points[1].x:=r.Right-h2;
        points[1].y:=r.Top+h2;
        Polyline(DC,@points,2);
      end;
  end;//for
end;

end.
