unit Game.Item.Lockable;

interface

uses
  Game,
  Game.Item;

type
  Lockable = class abstract(Item, IObject, IItem, ILockable)
  strict private
    fLocked: Boolean;
  public
    constructor Create(const where: IWorld); override;
    function IsLocked: Boolean;
    procedure Lock;
    procedure Unlock;
  end;

implementation

{ Lockable }

constructor Lockable.Create(const where: IWorld);
begin
  inherited;
  fLocked := False;
end;

function Lockable.IsLocked: Boolean;
begin
  Result := fLocked;
end;

procedure Lockable.Lock;
begin
  fLocked := True;
end;

procedure Lockable.Unlock;
begin
  fLocked := False;
end;

end.
