unit Game.Item.Equipment;

interface

uses
  Game,
  Game.Item;

type
  Equipment = class abstract(Item, IObject, IItem, IEquipment)
  strict private
    fEquipedOn: IMobile;
  public
    destructor Destroy; override;
    function IsEquiped: Boolean;
    function IsEquipedOn: IMobile;
    function IsEquipableOn: TArray<BodySector>; virtual; abstract;
    procedure Equip(const value: IMobile);
    procedure Unequip;
  end;

  EquipmentClass = class of Equipment;

implementation

{ Equipment }

destructor Equipment.Destroy;
begin
  fEquipedOn := nil;
  inherited;
end;

function Equipment.IsEquiped: Boolean;
begin
  Result := IsEquipedOn <> nil;
end;

function Equipment.IsEquipedOn: IMobile;
begin
  Result := fEquipedOn;
end;

procedure Equipment.Equip(const value: IMobile);
begin
  fEquipedOn := value;
end;

procedure Equipment.Unequip;
begin
  fEquipedOn := nil;
end;

end.
