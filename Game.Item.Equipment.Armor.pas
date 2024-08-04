unit Game.Item.Equipment.Armor;

interface

uses
  Spring,
  Spring.Collections,
  Game,
  Game.Item.Equipment;

type
  Armor = class abstract(Equipment, IObject, IItem, IEquipment, IArmor)
  strict private
    fResistances: IList<ResistData>;
  protected
    procedure AppendResistData(const damage: DamageType; const value: Percent);
  public
    constructor Create(const where: IWorld); override;
    destructor Destroy; override;
    function Resistances: TArray<ResistData>;
    function Resistance(const damage: DamageType): Percent;
  end;

  HeadArmor = class(Armor)
  public
    constructor Create(const where: IWorld); override;
    function IsEquipableOn: TArray<BodySector>; override;
  end;

  TorsoArmor = class(Armor)
  public
    constructor Create(const where: IWorld); override;
    function IsEquipableOn: TArray<BodySector>; override;
  end;

  ArmArmor = class(Armor)
  public
    constructor Create(const where: IWorld); override;
    function IsEquipableOn: TArray<BodySector>; override;
  end;

  HandArmor = class(Armor)
  public
    constructor Create(const where: IWorld); override;
    function IsEquipableOn: TArray<BodySector>; override;
  end;

  LegArmor = class(Armor)
  public
    constructor Create(const where: IWorld); override;
    function IsEquipableOn: TArray<BodySector>; override;
  end;

  FootArmor = class(Armor)
  public
    constructor Create(const where: IWorld); override;
    function IsEquipableOn: TArray<BodySector>; override;
  end;

implementation

{ Armor }

constructor Armor.Create;
begin
  inherited;
  fResistances := TCollections.CreateObjectList<ResistData>;
  SetName('Armor');
end;

destructor Armor.Destroy;
begin
  fResistances.Clear;
  fResistances := nil;
  inherited;
end;

procedure Armor.AppendResistData(const damage: DamageType; const value: Percent);
begin
  fResistances.Add(ResistData.Create(damage, value));
end;

function Armor.Resistances: TArray<ResistData>;
begin
  Result := fResistances.ToArray;
end;

function Armor.Resistance(const damage: DamageType): Percent;
var
  rd: ResistData;
begin
  Result := 0;
  for rd in Resistances do
  begin
    if rd.DamageType = damage then
    begin
      Inc(Result, rd.ResistBase);
    end;
  end;
end;

{ HeadArmor }

constructor HeadArmor.Create;
begin
  inherited;
  SetName('Elmo');
  AppendResistData(dtFisical, 40);
end;

function HeadArmor.IsEquipableOn: TArray<BodySector>;
begin
  Result := [bsHead];
end;

{ TorsoArmor }

constructor TorsoArmor.Create;
begin
  inherited;
  SetName('Peitoral de couro');
  AppendResistData(dtFisical, 40);
end;

function TorsoArmor.IsEquipableOn: TArray<BodySector>;
begin
  Result := [bsTorso, bsArms];
end;

{ HandArmor }

constructor HandArmor.Create;
begin
  inherited;
  SetName('Luva de couro');
  AppendResistData(dtFisical, 40);
end;

function HandArmor.IsEquipableOn: TArray<BodySector>;
begin
  Result := [bsHands];
end;

{ ArmArmor }

constructor ArmArmor.Create;
begin
  inherited;
  SetName('Mangote de couro');
  AppendResistData(dtFisical, 40);
end;

function ArmArmor.IsEquipableOn: TArray<BodySector>;
begin
  Result := [bsArms];
end;

{ LegArmor }

constructor LegArmor.Create;
begin
  inherited;
  SetName('Calça de couro');
  AppendResistData(dtFisical, 40);
end;

function LegArmor.IsEquipableOn: TArray<BodySector>;
begin
  Result := [bsLegs];
end;

{ FootArmor }

constructor FootArmor.Create;
begin
  inherited;
  SetName('Bota de couro');
  AppendResistData(dtFisical, 40);
end;

function FootArmor.IsEquipableOn: TArray<BodySector>;
begin
  Result := [bsFeet];
end;

end.
