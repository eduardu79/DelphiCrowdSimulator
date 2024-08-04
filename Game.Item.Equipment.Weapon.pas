unit Game.Item.Equipment.Weapon;

interface

uses
  Spring,
  Spring.Collections,
  Game,
  Game.Item.Equipment;

type
  Weapon = class abstract(Equipment, IObject, IItem, IEquipment, IWeapon)
  strict private
    fDamages: IList<DamageData>;
    fRange: Byte;
    fSpeed: Percent;
  protected
    procedure AppendDamageData(const damage: DamageType; const value: Byte);
    procedure SetRange(const value: Byte);
    procedure SetSpeed(const value: Percent);
  public
    constructor Create(const where: IWorld); override;
    destructor Destroy; override;
    function Damages: TArray<DamageData>;
    function Range: Byte; virtual;
    function Speed: Percent; virtual;
    function IsEquipableOn: TArray<BodySector>; override;
  end;

  // mobile intrinsic weapon
  Fists = class(Weapon)
  public
    constructor Create(const where: IWorld); override;
    procedure Use; override;
  end;

implementation

{ Weapon }

constructor Weapon.Create(const where: IWorld);
begin
  inherited;
  fDamages := TCollections.CreateObjectList<DamageData>;
  fRange := 4;
  fSpeed := 100;
end;

destructor Weapon.Destroy;
begin
  fDamages.Clear;
  fDamages := nil;
  inherited;
end;

function Weapon.Damages: TArray<DamageData>;
begin
  Result := fDamages.ToArray;
end;

function Weapon.Range: Byte;
begin
  Result := fRange;
end;

function Weapon.Speed: Percent;
begin
  Result := fSpeed;
end;

function Weapon.IsEquipableOn: TArray<BodySector>;
begin
  Result := [bsHands];
end;

procedure Weapon.AppendDamageData(const damage: DamageType; const value: Byte);
begin
  fDamages.Add(DamageData.Create(damage, value));
end;

procedure Weapon.SetRange(const value: Byte);
begin
  if value < 5 then
  begin
    fRange := 5;
  end
  else
    fRange := value;
end;

procedure Weapon.SetSpeed(const value: Percent);
begin
  fSpeed := value;
end;

{ Fists }

constructor Fists.Create(const where: IWorld);
begin
  inherited;
  SetName('Punhos');
  SetSpeed(80);
  SetWeight(0);
  AppendDamageData(dtFisical, 6);
end;

procedure Fists.Use;
begin
  // descarta o gasto do item
end;

end.
