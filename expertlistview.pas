unit ExpertListView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazUtils, ComCtrls, UITypes, ExtCtrls, ImgList;

type

{ TEListView }

 TEListView = Class (TListView)
  private
    FListGroups: TListGroups;
    FGroupView: Boolean;
  protected
    property Groups: TListGroups read FListGroups write SetListGroups stored StoreGroups;
    property GroupView: Boolean read FGroupView write SetGroupView default False;
    property GroupHeaderImages: TCustomImageList read FGroupHeaderImages write SetGroupHeaderImages;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;

end;

 { EListView }

 EListView = Class (TEListView)
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Groups;
    property GroupHeaderImages;
    property GroupView default False;

end;

implementation

{ EListView }

constructor EListView.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

destructor EListView.Destroy;
begin
  inherited Destroy;
end;

{ TEListView }

constructor TEListView.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

destructor TEListView.Destroy;
begin
  inherited Destroy;
end;


end.

