unit Game.Mobile;

interface

uses
  System.Types,
  System.Threading,
  Spring,
  Spring.Collections,
  Game,
  Game.Item;

type
  Mobile = class;
  MobileClass = class of Mobile;
  BodyPart = class;
  MobileController = class;
  MobileControllerClass = class of MobileController;

  TempResistEntry = class
  strict private
    fResist: ResistData;
  public
    constructor Create(const aResist: ResistData);
    function Resist: ResistData;
  end;

  Mobile = class abstract(BaseObject, IObject, IMobile)
  strict private
    fController: MobileController;
    fBodyParts: IList<BodyPart>;
    fTempResistance: IList<TempResistEntry>;
    fIntrinsicWeapon: IWeapon;
    fStr: AttributeValue;
    fDex: AttributeValue;
    fInt: AttributeValue;
    fHP: Word;
    fSP: Word;
    fMP: Word;
    fLastMove: TDateTime;
    fLastAttack: TDateTime;
    fLastDamaged: TDateTime;
    fLastHeal: TDateTime;
    fOnDamaged: Event<EventDamage>;
    fOnDied: Event<EventMobile>;
    function GetTempResistance(const damage: DamageType): Percent;
    function GetOnDamaged: IEvent<EventDamage>;
    function GetOnDied: IEvent<EventMobile>;
    function GetDirection(const target: IObject): Direction;
    function GetNewPosition(const dir: Direction): TPoint;
    function CheckMoveCooldown: Boolean;
    function CheckAttackCooldown: Boolean;
    function CheckAttackRange(const target: IMobile): Boolean;
    procedure DoOnDamaged(const data: EventDamageData);
    procedure DoOnDied;
    procedure ApplyRawDamage(const data: EventDamageData);
  protected
    function GetBodyPart(const part: BodyPartType): BodyPart;
    function GetBodyParts: TArray<BodyPart>;
    procedure SetController(const controllerClass: BaseMobileControllerClass);
    procedure SetSize(const value: Word); override;
    procedure Cycle; virtual;
  public
    constructor Create(const where: IWorld; const parts: TArray<BodyPart>); reintroduce; virtual;
    destructor Destroy; override;
    function Str: AttributeValue; virtual;
    function Dex: AttributeValue;
    function Int: AttributeValue;
    function HP: Word;
    function SP: Word;
    function MP: Word;
    function Speed: Percent;
    function MaxHP: Word;
    function MaxSP: Word;
    function MaxMP: Word;
    function AttackRange: Word;
    function SightRange: Word;
    function Weight: Word; override;
    function IsDamaged: Boolean;
    function IsAlive: Boolean;
    function GetAttributeLevel(const attr: AttributeType): AttributeLevel;
    function GetEquipments: TArray<IEquipment>;
    function GetWeapon: IWeapon;
    function CanView(const target: IMobile): Boolean;
    function CanAttack(const target: IMobile): Boolean;
    function CanMove(const dir: Direction): Boolean; overload;
    function CanMove(const target: IObject): Boolean; overload;
    function CanEquip(const equipmt: IEquipment): Boolean;
    procedure Attack(const target: IMobile);
    procedure ApplyDamage(const source: IMobile); overload;
    procedure AddTempResistance(const damage: DamageType; const value: Percent);
    procedure SetStr(const value: AttributeValue);
    procedure SetDex(const value: AttributeValue);
    procedure SetInt(const value: AttributeValue);
    procedure Equip(const equipmt: IEquipment);
    procedure Move(const dir: Direction); overload;
    procedure Move(const target: IObject); overload;
    procedure Heal(const amount: Word);
    procedure Kill;
    procedure UnequipAll;
    property OnDamaged: IEvent<EventDamage> read GetOnDamaged;
    property OnDied: IEvent<EventMobile> read GetOnDied;
  end;

  BodyPart = class abstract
  strict private
    fOwner: IMobile;
    fType: BodyPartType;
    fArmor: IArmor;
    fWeapon: IWeapon;
    procedure EventEquipmentOnBroke(const source: IItem);
  public
    constructor Create(const aOwner: IMobile; const aType: BodyPartType); reintroduce;
    destructor Destroy; override;
    function Owner: IMobile;
    function Sector: BodySector;
    function GetType: BodyPartType;
    function Coverage: Percent;
    function HasEquipment: Boolean;
    function CanEquipWeapon: Boolean;
    function CanEquipArmor: Boolean;
    function HasWeapon: Boolean;
    function HasArmor: Boolean;
    function EquipedWeapon: IWeapon;
    function EquipedArmor: IArmor;
    function CanEquip(const equipmt: IEquipment): Boolean;
    procedure Equip(const equipmt: IEquipment);
    procedure UnequipArmor;
    procedure UnequipWeapon;
    procedure UnequipAll;
  end;

  MobileController = class abstract(BaseMobileController)
  strict private
    fMobile: IMobile;
    fRunning: Boolean;
    procedure InternalCycle;
  protected
    function Mobile: IMobile;
    function MobilesInRange: TArray<IMobile>;
    procedure Cycle; virtual; abstract;
  public
    constructor Create(const mob: IMobile); virtual;
    destructor Destroy; override;
    procedure Start; override;
    procedure Stop; override;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Math,
  Game.Item.Equipment.Weapon;

{ Mobile }

constructor Mobile.Create(const where: IWorld; const parts: TArray<BodyPart>);
begin
  inherited Create(where);
  fOnDamaged.UseFreeNotification := True;
  fOnDied.UseFreeNotification := True;
  where.OnClock.Add(Cycle);

  fBodyParts := TCollections.CreateObjectList<BodyPart>(parts);
  fTempResistance := TCollections.CreateObjectList<TempResistEntry>;
  fIntrinsicWeapon := Fists.Create(where);

  fStr := 100;
  fDex := 100;
  fInt := 100;

  fHP := MaxHP;
  fSP := MaxSP;
  fMP := MaxMP;
end;

destructor Mobile.Destroy;
begin
  fBodyParts.Clear;
  fTempResistance.Clear;
  fTempResistance := nil;
  fBodyParts := nil;
  fOnDamaged.Clear;
  fOnDied.Clear;
  fIntrinsicWeapon.Free;
  fController.Free;
  inherited;
end;

function Mobile.Str: AttributeValue;
begin
  Result := fStr;
end;

function Mobile.Dex: AttributeValue;
begin
  Result := fDex;
end;

function Mobile.Int: AttributeValue;
begin
  Result := fInt;
end;

function Mobile.HP: Word;
begin
  Result := fHP;
end;

function Mobile.SP: Word;
begin
  Result := fSP;
end;

function Mobile.Speed: Percent;
begin
  Result := Trunc(Dex / 10);
end;

function Mobile.MP: Word;
begin
  Result := fMP;
end;

function Mobile.MaxHP: Word;
begin
  Result := Trunc(Str / 5);
end;

function Mobile.MaxSP: Word;
begin
  Result := Trunc(Dex / 5);
end;

function Mobile.MaxMP: Word;
begin
  Result := Trunc(Int / 5);
end;

function Mobile.AttackRange: Word;
begin
  Result := Trunc(Size / 2) + GetWeapon.Range;
end;

function Mobile.SightRange: Word;
begin
  Result := Trunc(Int / 7.5) + Trunc(Size / 2);
end;

function Mobile.IsAlive: Boolean;
begin
  Result := HP > 0;
end;

function Mobile.IsDamaged: Boolean;
begin
  Result := HP < MaxHP;
end;

function Mobile.Weight: Word;
var
  eq: IEquipment;
begin
  Result := inherited + (Str div 200);
  for eq in GetEquipments do
  begin
    Inc(Result, eq.Weight);
  end;
end;

function Mobile.GetAttributeLevel(const attr: AttributeType): AttributeLevel;
var
  value: AttributeValue;
begin
  value := 0;

  case attr of
    atStrength: value := Str;
    atDexterity: value := Dex;
    atIntelligence: value := Int;
  end;

  case value of
    951..1000: Result := alMaster;
    801..950: Result := alPro;
    601..800: Result := alSkilled;
    351..600: Result := alAverage;
  else
    Result := alBeginner;
  end;
end;

function Mobile.GetBodyParts: TArray<BodyPart>;
begin
  Result := fBodyParts.ToArray;
end;

function Mobile.GetDirection(const target: IObject): Direction;
var
  dx, dy: Integer;
  angle: Double;
begin
  dx := target.Position.X - Position.X;
  dy := target.Position.Y - Position.Y;
  angle := ArcTan2(-dy, dx);
  angle := RadToDeg(angle);
  if angle < 0 then
  begin
    angle := angle + 360;
  end;

  if (angle >= 337.5) or (angle < 22.5) then
  begin
    Result := dEast;
  end
  else if angle < 67.5 then
  begin
    Result := dNorthEast
  end
  else if angle < 112.5 then
  begin
    Result := dNorth
  end
  else if angle < 157.5 then
  begin
    Result := dNorthWest
  end
  else if angle < 202.5 then
  begin
    Result := dWest
  end
  else if angle < 247.5 then
  begin
    Result := dSouthWest
  end
  else if angle < 292.5 then
  begin
    Result := dSouth
  end
  else
  begin
    Result := dSouthEast;
  end;
end;

function Mobile.GetBodyPart(const part: BodyPartType): BodyPart;
var
  bp: BodyPart;
begin
  Result := nil;
  for bp in GetBodyParts do
  begin
    if bp.GetType = part then
    begin
      Exit(bp);
    end;
  end;
end;

function Mobile.GetEquipments: TArray<IEquipment>;
var
  bp: BodyPart;
begin
  Result := [];
  for bp in GetBodyParts do
  begin
    if bp.HasArmor then
    begin
      Result := Result + [bp.EquipedArmor];
    end;

    if bp.HasWeapon then
    begin
      Result := Result + [bp.EquipedWeapon];
    end;
  end;
end;

function Mobile.GetNewPosition(const dir: Direction): TPoint;
begin
  Result := Position;

  case dir of
    dNorth:
    begin
      Dec(Result.Y);
    end;

    dNorthEast:
    begin
      Inc(Result.X);
      Dec(Result.Y);
    end;

    dEast:
    begin
      Inc(Result.X);
    end;

    dSouthEast:
    begin
      Inc(Result.X);
      Inc(Result.Y);
    end;

    dSouth:
    begin
      Inc(Result.Y);
    end;

    dSouthWest:
    begin
      Dec(Result.X);
      Inc(Result.Y);
    end;

    dWest:
    begin
      Dec(Result.X);
    end;

    dNorthWest:
    begin
      Dec(Result.X);
      Dec(Result.Y);
    end;
  end;
end;

function Mobile.GetTempResistance(const damage: DamageType): Percent;
var
  entry: TempResistEntry;
  total: Percent;
begin
  total := 1;
  for entry in fTempResistance do
  begin
    if entry.Resist.DamageType = damage then
    begin
      total := total * entry.Resist.ResistBase;
    end;
  end;
  Result := total - 1;
end;

function Mobile.GetWeapon: IWeapon;
var
  equiped: TArray<IWeapon>;
  eq: IEquipment;
begin
  Result := fIntrinsicWeapon;
  equiped := [];

  for eq in GetEquipments do
  begin
    if eq.IsWeapon and eq.IsEquiped then
    begin
      equiped := equiped + [eq as IWeapon];
    end;
  end;

  if Length(equiped) > 0 then
  begin
    Result := equiped[Random(Length(equiped))];
  end;
end;

function Mobile.CanAttack(const target: IMobile): Boolean;
begin
  Result := (target.Serial <> Serial) and
            IsAlive and
            target.IsAlive and
            World.CheckLineOfSight(Self, target) and
            CheckAttackRange(target);
end;

function Mobile.CanEquip(const equipmt: IEquipment): Boolean;
var
  bs: BodySector;
  bp: BodyPart;
begin
  Result := not equipmt.IsEquiped;
  if Result then
  begin
    for bs in equipmt.IsEquipableOn do
    begin
      for bp in GetBodyParts do
      begin
        if (bp.Sector = bs) and bp.CanEquip(equipmt) then
        begin
          Exit(True);
        end;
      end;
    end;
  end;
end;

function Mobile.CanMove(const dir: Direction): Boolean;
begin
  Result := CheckMoveCooldown and World.CanMove(Self, GetNewPosition(dir));
end;

function Mobile.CanMove(const target: IObject): Boolean;
begin
  Result := CheckMoveCooldown and World.CanMove(Self, GetNewPosition(GetDirection(target)));
end;

function Mobile.CanView(const target: IMobile): Boolean;
begin
  Result := (target.Serial <> Serial) and (GetDistance(target) <= SightRange);
end;

function Mobile.CheckAttackCooldown: Boolean;
var
  baseCooldown: Int64;
  aditionalCooldown: Double;
begin
  baseCooldown := 200;
  aditionalCooldown := Trunc(800 * (((GetWeapon.Speed * Speed) / 100) / 100));
  Result := MilliSecondsBetween(Now, fLastAttack) >= baseCooldown + aditionalCooldown;
end;

function Mobile.CheckAttackRange(const target: IMobile): Boolean;
begin
  Result := GetDistance(target) <= AttackRange + Trunc(target.Size / 2) + 1;
end;

function Mobile.CheckMoveCooldown: Boolean;
begin
  Result := MilliSecondsBetween(Now, fLastMove) >= (100 - Speed);
end;

function Mobile.GetOnDamaged: IEvent<EventDamage>;
begin
  Result := fOnDamaged;
end;

function Mobile.GetOnDied: IEvent<EventMobile>;
begin
  Result := fOnDied;
end;

procedure Mobile.SetController(const controllerClass: BaseMobileControllerClass);
begin
  if fController <> nil then
  begin
    fController.Stop;
  end;

  fController := TActivator.CreateInstance(controllerClass, [Self]) as MobileController;
  fController.Start;
end;

procedure Mobile.SetSize(const value: Word);
begin
  inherited;
  SetWeight(value * 2);
end;

procedure Mobile.SetStr(const value: AttributeValue);
begin
  fStr := value;
  fHP := MaxHP;
  SetSize(Trunc(value / 50));
end;

procedure Mobile.SetDex(const value: AttributeValue);
begin
  fDex := value;
  fSP := MaxSP;
end;

procedure Mobile.SetInt(const value: AttributeValue);
begin
  fInt := value;
  fMP := MaxMP;
end;

procedure Mobile.Attack(const target: IMobile);
begin
  if CanAttack(target) and CheckAttackCooldown then
  begin
    fLastAttack := Now;
    target.ApplyDamage(Self);
  end;
end;

procedure Mobile.ApplyRawDamage(const data: EventDamageData);
begin
  if IsAlive then
  begin
    if HP - data.TargetAmount <= 0 then
    begin
      fHP := 0;
    end
    else
    begin
      fHP := HP - data.TargetAmount;
    end;

    DoOnDamaged(data);
    fLastDamaged := Now;

    if not IsAlive then
    begin
      World.OnClock.Remove(Cycle);
      DoOnDied;
    end;
  end;
end;

procedure Mobile.AddTempResistance(const damage: DamageType; const value: Percent);
begin
  fTempResistance.Add(TempResistEntry.Create(ResistData.Create(damage, value)));
end;

procedure Mobile.ApplyDamage(const source: IMobile);
var
  targetDmg: Word;
  targetArmorDmg: Word;
  targetArmor: IArmor;
  targetBodyPart: BodyPart;
  sourceWeapon: IWeapon;
  damage: DamageData;
  armorResist: Percent;
  tempResist: Percent;
  initialDmg: Integer;
  tempMobileDmg: Word;
  tempArmorDmg: Word;
  randomArray: TArray<BodyPart>;
  i: Integer;
begin
  if source.IsAlive then
  begin
    randomArray := [];
    for targetBodyPart in GetBodyParts do
    begin
      for i := 1 to targetBodyPart.Coverage do
      begin
        randomArray := randomArray + [targetBodyPart];
      end;
    end;
    targetBodyPart := randomArray[Random(Length(randomArray))];

    targetArmor := nil;
    if targetBodyPart.HasArmor then
    begin
      targetArmor := targetBodyPart.EquipedArmor;
    end;
    sourceWeapon := source.GetWeapon;
    targetDmg := 0;
    targetArmorDmg := 0;

    for damage in sourceWeapon.Damages do
    begin
      initialDmg := damage.DamageBase * 100;

      if damage.DamageType = dtFisical then
      begin
        initialDmg := Trunc((initialDmg * (source.Str / 10)) / 100);
      end;

      armorResist := 0;
      if targetArmor <> nil then
      begin
        armorResist := targetArmor.Resistance(damage.DamageType);
      end;

      // desconta defesa do armor -> 100% de armor = 20% dano no mobile e 80% de dano pro armor
      tempMobileDmg := Trunc(initialDmg - ((initialDmg / 100.0) * ((armorResist / 5) * 4)));
      tempArmorDmg := initialDmg - tempMobileDmg;

      // desconta defesa temporária -> 100% de armor = 20% dano no mobile
      tempResist := GetTempResistance(damage.DamageType);
      tempMobileDmg := Trunc(tempMobileDmg - ((tempMobileDmg / 100.0) * ((tempResist / 5) * 4)));

      Inc(targetDmg, tempMobileDmg);
      Inc(targetArmorDmg, tempArmorDmg);
    end;

    // uma parte dos danos é aleatória
    targetDmg := Trunc((Random(Trunc(targetDmg / 2)) + Trunc(targetDmg / 2)) / 100);
    targetArmorDmg := Trunc((Random(Trunc(targetArmorDmg / 2)) + Trunc(targetArmorDmg / 2)) / 100);

    if not sourceWeapon.IsBroken then
    begin
      if targetArmor <> nil then
      begin
        targetArmor.Damage(targetArmorDmg);
      end;

      ApplyRawDamage(EventDamageData.Create(
        Max(targetDmg, 1) + targetArmorDmg,
        source,
        sourceWeapon,
        Self,
        Max(targetDmg, 1),
        targetArmor,
        targetArmorDmg,
        targetBodyPart.GetType));

      sourceWeapon.Use;
    end;
  end;
end;

procedure Mobile.Heal(const amount: Word);
begin
  if IsAlive then
  begin
    if HP + amount < MaxHP then
    begin
      fHP := HP + amount;
    end
    else
    begin
      fHP := MaxHP;
    end;

    fLastHeal := Now;
  end;
end;

procedure Mobile.Equip(const equipmt: IEquipment);
var
  bp: BodyPart;
begin
  for bp in GetBodyParts do
  begin
    if bp.CanEquip(equipmt) then
    begin
      bp.Equip(equipmt);
      Exit;
    end;
  end;
end;

procedure Mobile.Move(const dir: Direction);
var
  pos: TPoint;
begin
  if CanMove(dir) then
  begin
    fLastMove := Now;
    pos := GetNewPosition(dir);
    SetFacing(dir);
    SetPosition(pos.X, pos.Y);
  end;
end;

procedure Mobile.Move(const target: IObject);
begin
  Move(GetDirection(target));
end;

procedure Mobile.Kill;
begin
  ApplyRawDamage(EventDamageData.Create(
    1000,
    Self,
    GetWeapon,
    Self,
    1000,
    nil,
    0,
    btHead));
end;

procedure Mobile.UnequipAll;
var
  bp: BodyPart;
begin
  for bp in GetBodyParts do
  begin
    bp.UnequipAll;
  end;
end;

procedure Mobile.Cycle;
begin
  if IsDamaged and (SecondsBetween(Now, fLastDamaged) >= 5) and (SecondsBetween(Now, fLastHeal) >= 1) then
  begin
    Heal(Max(Trunc(MaxHP / 100), 1));
  end;
end;

procedure Mobile.DoOnDamaged(const data: EventDamageData);
begin
  if OnDamaged.Enabled and OnDamaged.CanInvoke then
  begin
    fOnDamaged.Invoke(data);
  end;
end;

procedure Mobile.DoOnDied;
begin
  if OnDied.Enabled and OnDied.CanInvoke then
  begin
    fOnDied.Invoke(Self);
  end;
end;

{ BodyPart }

constructor BodyPart.Create(const aOwner: IMobile; const aType: BodyPartType);
begin
  inherited Create;
  fOwner := aOwner;
  fType := aType;
end;

destructor BodyPart.Destroy;
begin
  fOwner := nil;

  if HasArmor then
  begin
    fArmor.OnBroke.Remove(EventEquipmentOnBroke);
    fArmor.Free;
  end;

  if HasWeapon then
  begin
    fWeapon.OnBroke.Remove(EventEquipmentOnBroke);
    fWeapon.Free;
  end;

  inherited;
end;

function BodyPart.Owner: IMobile;
begin
  Result := fOwner;
end;

function BodyPart.Sector: BodySector;
begin
  case GetType of
    btHead: Result := bsHead;
    btTorso: Result := bsTorso;
    btLeftHand, btRightHand: Result := bsHands;
    btLeftArm, btRightArm: Result := bsArms;
    btLeftLeg, btRightLeg: Result := bsLegs;
    btLeftFoot, btRightFoot: Result := bsFeet;
  else
    raise Exception.Create('BodyPartType not defined for BodyPart');
  end;
end;

function BodyPart.GetType: BodyPartType;
begin
  Result := fType;
end;

function BodyPart.CanEquipArmor: Boolean;
begin
  Result := not HasArmor;
end;

function BodyPart.CanEquipWeapon: Boolean;
begin
  Result := (not HasWeapon) and (Sector = bsHands);
end;

function BodyPart.Coverage: Percent;
begin
  case GetType of
    btHead: Result := 14;
    btTorso: Result := 36;
    btLeftHand: Result := 4;
    btRightHand: Result := 4;
    btLeftArm: Result := 9;
    btRightArm: Result := 9;
    btLeftLeg: Result := 8;
    btRightLeg: Result := 8;
    btLeftFoot: Result := 4;
    btRightFoot: Result := 4;
  else
    Result := 0;
  end;
end;

function BodyPart.HasEquipment: Boolean;
begin
  Result := HasArmor or HasWeapon;
end;

function BodyPart.HasArmor: Boolean;
begin
  Result := fArmor <> nil;
end;

function BodyPart.HasWeapon: Boolean;
begin
  Result := fWeapon <> nil;
end;

function BodyPart.EquipedArmor: IArmor;
begin
  Result := fArmor;
end;

function BodyPart.EquipedWeapon: IWeapon;
begin
  Result := fWeapon;
end;

function BodyPart.CanEquip(const equipmt: IEquipment): Boolean;
var
  bs: BodySector;
begin
  Result := False;
  for bs in equipmt.IsEquipableOn do
  begin
    if bs = Sector then
    begin
      if (equipmt.IsWeapon and CanEquipWeapon) or (equipmt.IsArmor and CanEquipArmor) then
      begin
        Exit(True);
      end;
    end;
  end;
end;

procedure BodyPart.Equip(const equipmt: IEquipment);
begin
  if CanEquip(equipmt) then
  begin
    if equipmt.IsArmor then
    begin
      fArmor := equipmt as IArmor;
    end
    else if equipmt.IsWeapon then
    begin
      fWeapon := equipmt as IWeapon;
    end;
    equipmt.Equip(Owner);
    equipmt.OnBroke.Add(EventEquipmentOnBroke);
  end;
end;

procedure BodyPart.UnequipAll;
begin
  UnequipArmor;
  UnequipWeapon;
end;

procedure BodyPart.UnequipArmor;
begin
  fArmor := nil;
end;

procedure BodyPart.UnequipWeapon;
begin
  fWeapon := nil;
end;

procedure BodyPart.EventEquipmentOnBroke(const source: IItem);
begin
  if source.IsArmor then
  begin
    UnequipArmor;
  end
  else if source.IsWeapon then
  begin
    UnequipWeapon;
  end;
end;

{ MobileController }

constructor MobileController.Create(const mob: IMobile);
begin
  fMobile := mob;
end;

destructor MobileController.Destroy;
begin
  Stop;
  fMobile := nil;
  inherited;
end;

procedure MobileController.InternalCycle;
begin
  if fRunning and (Mobile <> nil) and Mobile.IsAlive then
  begin
    Cycle;
  end;
end;

procedure MobileController.Start;
begin
  fRunning := True;
  Mobile.World.OnClock.Add(InternalCycle);
end;

procedure MobileController.Stop;
begin
  fMobile.World.OnClock.Remove(InternalCycle);
  fRunning := False;
end;

function MobileController.Mobile: IMobile;
begin
  Result := fMobile;
end;

function MobileController.MobilesInRange: TArray<IMobile>;
var
  mob: IMobile;
  mobs: TArray<IMobile>;
begin
  mobs := [];
  if (Mobile <> nil) and Mobile.IsAlive then
  begin
    for mob in Mobile.World.Mobiles do
    begin
      if mob.IsAlive and (mob.Serial <> Mobile.Serial) and Mobile.CanView(mob) then
      begin
        Result := Result + [mob];
      end;
    end;
  end;
end;

{ TempResistEntry }

constructor TempResistEntry.Create(const aResist: ResistData);
begin
  fResist := aResist;
end;

function TempResistEntry.Resist: ResistData;
begin
  Result := fResist;
end;

end.
