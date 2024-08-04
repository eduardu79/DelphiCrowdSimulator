unit Game.Item.Lockable.Container;

interface

uses
  Spring,
  Spring.Collections,
  Game,
  Game.Item.Lockable;

type
  Container = class abstract(Lockable, IObject, IItem, ILockable, IContainer)
  strict private
    fCapacity: Word;
    fItems: IList<IItem>;
  public
    constructor Create(const where: IWorld); override;
    destructor Destroy; override;
    function CanAdd(const value: IItem): Boolean;
    function HasItem(const value: IItem): Boolean;
    function Items: TArray<IItem>;
    function Capacity: Word; virtual;
    function ContainedWeight: Word;
    function Weight: Word; override;
    procedure Add(const value: IItem);
    procedure Remove(const value: IItem);
  end;

implementation

{ Container }

constructor Container.Create(const where: IWorld);
begin
  inherited;
  fItems := TCollections.CreateList<IItem>;
  fCapacity := 100;
end;

destructor Container.Destroy;
var
  i: IItem;
begin
  for i in fItems do
  begin
    i.Free;
  end;
  inherited;
end;

function Container.Weight: Word;
begin
  Result := inherited + ContainedWeight;
end;

function Container.Capacity: Word;
begin
  Result := fCapacity;
end;

function Container.ContainedWeight: Word;
var
  i: IItem;
begin
  Result := 0;
  for i in fItems do
  begin
    Inc(Result, i.Weight);
  end;
end;

function Container.Items: TArray<IItem>;
begin
  Result := [];
  if not IsLocked then
  begin
    Result := fItems.ToArray;
  end;
end;

function Container.CanAdd(const value: IItem): Boolean;
begin
  Result := (not IsLocked) and ((value.Weight + ContainedWeight) <= Capacity);
end;

function Container.HasItem(const value: IItem): Boolean;
begin
  Result := fItems.Contains(value);
end;

procedure Container.Add(const value: IItem);
begin
  if CanAdd(value) then
  begin
    fItems.Add(value);
  end;
end;

procedure Container.Remove(const value: IItem);
begin
  if HasItem(value) then
  begin
    fItems.Extract(value);
  end;
end;

end.
