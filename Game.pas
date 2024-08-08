unit Game;

interface

uses
  System.Types,
  Vcl.Graphics,
  Spring;

const
  TICKS_PER_SECOND = 60;

type
  Percent = 0..100;
  AttributeValue = 0..1000;

  Direction = (
    dNorth,
    dSouth,
    dEast,
    dWest,
    dNorthEast,
    dSouthWest,
    dSouthEast,
    dNorthWest
  );

  ItemQuality = (
    iqLow,
    iqNormal,
    iqGood,
    iqGreat,
    iqExceptional
  );

  BodySector = (
    bsHead,
    bsTorso,
    bsArms,
    bsHands,
    bsLegs,
    bsFeet
  );

  BodyPartType = (
    btHead,
    btTorso,
    btLeftHand,
    btRightHand,
    btLeftArm,
    btRightArm,
    btLeftLeg,
    btRightLeg,
    btLeftFoot,
    btRightFoot
  );

  DamageType = (
    dtFisical,
    dtFire,
    dtCold,
    dtElectric,
    dtPoison,
    dtDarkness
  );

  DamageData = class
  strict private
    fDamageType: DamageType;
    fDamageBase: Byte;
  public
    constructor Create(const dmgType: DamageType; const value: Percent);
    function DamageType: DamageType;
    function DamageBase: Byte;
  end;

  ResistData = class
  strict private
    fDamageType: DamageType;
    fResistBase: Percent;
  public
    constructor Create(const dmgType: DamageType; const value: Percent);
    function DamageType: DamageType;
    function ResistBase: Percent;
  end;

  AttributeType = (
    atStrength,
    atDexterity,
    atIntelligence
  );

  AttributeLevel = (
    alBeginner,
    alAverage,
    alSkilled,
    alPro,
    alMaster
  );

  IObject = interface;
  IItem = interface;
  ILockable = interface;
  IContainer = interface;
  IEquipment = interface;
  IArmor = interface;
  IWeapon = interface;
  IMobile = interface;
  IWorld = interface;
  BaseObject = class;
  BaseObjectClass = class of BaseObject;
  BaseMobileController = class;
  BaseMobileControllerClass = class of BaseMobileController;

  EventDamageData = class
  strict private
    fTotalAmount: Word;
    fSource: IMobile;
    fSourceWeapon: IWeapon;
    fTarget: IMobile;
    fTargetAmount: Word;
    fTargetArmor: IArmor;
    fTargetArmorAmount: Word;
    fTargetBodyPart: BodyPartType;
  public
    constructor Create(
      aTotalAmount: Word;
      aSource: IMobile;
      aSourceWeapon: IWeapon;
      aTarget: IMobile;
      aTargetAmount: Word;
      aTargetArmor: IArmor;
      aTargetArmorAmount: Word;
      aTargetBodyPart: BodyPartType);
    function TotalAmount: Word;
    function Source: IMobile;
    function SourceWeapon: IWeapon;
    function Target: IMobile;
    function TargetAmount: Word;
    function TargetArmor: IArmor;
    function TargetArmorAmount: Word;
    function TargetBodyPart: BodyPartType;
  end;

  EventClock = procedure of object;
  EventItem = procedure(const source: IItem) of object;
  EventAnimation = procedure(const animationCode: Integer) of object;
  EventSound = procedure(const soundCode: Integer) of object;
  EventDamage = procedure(const data: EventDamageData) of object;
  EventMobile = procedure(const source: IMobile) of object;

  IObject = interface(IInterface)
  ['{89300AEB-B7D1-4A48-B8D8-CC4D08F25194}']
    function Serial: Int64;
    function Name: String;
    function Graphic: String;
    function Color: Integer;
    function Facing: Direction;
    function Size: Word;
    function Position: TPoint;
    function World: IWorld;
    function Weight: Word;
    function IsItem: Boolean;
    function IsEquipment: Boolean;
    function IsWeapon: Boolean;
    function IsArmor: Boolean;
    function IsLockable: Boolean;
    function IsContainer: Boolean;
    function IsMobile: Boolean;
    procedure SetPosition(const x, y: Word);
    procedure Free;
  end;

  IItem = interface(IObject)
  ['{9A576A8B-8268-4B43-BCD3-994136ADB10C}']
    function Quality: ItemQuality;
    function HP: Percent;
    function IsBroken: Boolean;
    function GetOnBroke: IEvent<EventItem>;
    procedure Use;
    procedure Damage(const amount: Word);
    property OnBroke: IEvent<EventItem> read GetOnBroke;
  end;

  ILockable = interface(IItem)
  ['{95E94DE7-1FD4-476F-951C-C8AA79A7EF17}']
    function IsLocked: Boolean;
    procedure Lock;
    procedure Unlock;
  end;

  IContainer = interface(ILockable)
  ['{9D4873AE-5F0A-434E-905A-603189D50CCC}']
    function ContainedWeight: Word;
    function Capacity: Word;
    function Items: TArray<IItem>;
    function CanAdd(const value: IItem): Boolean;
    function HasItem(const value: IItem): Boolean;
    procedure Add(const value: IItem);
    procedure Remove(const value: IItem);
  end;

  IEquipment = interface(IItem)
  ['{10F41E5B-1BDA-4A3F-8ACD-69ACF92AEE06}']
    function IsEquiped: Boolean;
    function IsEquipedOn: IMobile;
    function IsEquipableOn: TArray<BodySector>;
    procedure Equip(const value: IMobile);
    procedure Unequip;
  end;

  IArmor = interface(IEquipment)
  ['{B5D32D6C-D579-4E9C-A6F2-0D20107067D0}']
    function Resistances: TArray<ResistData>;
    function Resistance(const damage: DamageType): Percent;
  end;

  IWeapon = interface(IEquipment)
  ['{D714B199-1B37-4548-A0E9-2FABC4A509DC}']
    function Damages: TArray<DamageData>;
    function Range: Byte;
    function Speed: Percent;
  end;

  IMobileController = interface(IInterface)
  ['{6707B6E5-B7BF-464F-820C-42483D27A741}']
    procedure Start;
    procedure Stop;
  end;

  IMobile = interface(IObject)
  ['{28D8B252-9213-402B-940D-C1E7A80583D2}']
    function Str: AttributeValue;
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
    function IsAlive: Boolean;
    function CanView(const target: IMobile): Boolean;
    function CanAttack(const target: IMobile): Boolean;
    function CanEquip(const equipmt: IEquipment): Boolean;
    function CanMove(const dir: Direction): Boolean; overload;
    function CanMove(const target: IObject): Boolean; overload;
    function GetAttributeLevel(const attr: AttributeType): AttributeLevel;
    function GetEquipments: TArray<IEquipment>;
    function GetMobilesInRange: TArray<IMobile>;
    function GetWeapon: IWeapon;
    function GetOnDamaged: IEvent<EventDamage>;
    function GetOnDied: IEvent<EventMobile>;
    procedure SetController(const controllerClass: BaseMobileControllerClass);
    procedure SetStr(const value: AttributeValue);
    procedure SetDex(const value: AttributeValue);
    procedure SetInt(const value: AttributeValue);
    procedure Attack(const target: IMobile);
    procedure ApplyDamage(const source: IMobile); overload;
    procedure AddTempResistance(const damage: DamageType; const value: Percent);
    procedure Equip(const equipmt: IEquipment);
    procedure Move(const dir: Direction); overload;
    procedure Move(const target: IObject); overload;
    procedure Heal(const amount: Word);
    procedure Kill;
    procedure UnequipAll;
    procedure Cycle;
    property OnDamaged: IEvent<EventDamage> read GetOnDamaged;
    property OnDied: IEvent<EventMobile> read GetOnDied;
  end;

  IWorld = interface(IInterface)
  ['{F2F226FE-43E7-4B8F-B834-63CF9729E16C}']
    function Clock: Int64;
    function Size: TSize;
    function Mobiles: TArray<IMobile>;
    function CheckLineOfSight(const objA, objB: IObject): Boolean;
    function CreateMobile(const obj: BaseObjectClass): IMobile; overload;
    function CreateMobile(const obj: BaseObjectClass; const params: array of TValue): IMobile; overload;
    function CreateEquipment(const obj: BaseObjectClass): IEquipment; overload;
    function CanMove(const obj: IObject; const position: TPoint): Boolean;
    function GetOnClock: IEvent<EventClock>;
    function GetOnMobileDamaged: IEvent<EventDamage>;
    function GetOnMobileDied: IEvent<EventMobile>;
    function IsDebug: Boolean;
    function IsRunning: Boolean;
    procedure Initialize(const width, height: Word);
    procedure Resize(const width, height: Word);
    procedure Draw(const canvas: TCanvas);
    procedure Debug(const value: Boolean);
    procedure Running(const value: Boolean);
    procedure Shutdown;
    procedure KillAll;
    property OnClock: IEvent<EventClock> read GetOnClock;
    property OnMobileDamaged: IEvent<EventDamage> read GetOnMobileDamaged;
    property OnMobileDied: IEvent<EventMobile> read GetOnMobileDied;
  end;

  BaseObject = class abstract(TInterfaceBase, IObject)
  strict private
    fSerial: Int64;
    fName: String;
    fGraphic: String;
    fColor: Integer;
    fFacing: Direction;
    fSize: Word;
    fPosition: TPoint;
    fWeight: Word;
    fWorld: IWorld;
  protected
    function GetDistance(const target: IObject): Word; virtual;
    procedure SetName(const value: String); virtual;
    procedure SetGraphic(const value: String); virtual;
    procedure SetColor(const value: Integer); virtual;
    procedure SetFacing(const dir: Direction); virtual;
    procedure SetPosition(const x, y: Word); virtual;
    procedure SetSize(const value: Word); virtual;
    procedure SetWeight(const value: Word); virtual;
  public
    constructor Create(const where: IWorld); virtual;
    destructor Destroy; override;
    function Serial: Int64;
    function Name: String; virtual;
    function Graphic: String; virtual;
    function Color: Integer; virtual;
    function Facing: Direction; virtual;
    function Size: Word; virtual;
    function Position: TPoint; virtual;
    function World: IWorld;
    function Weight: Word; virtual;
    function IsItem: Boolean;
    function IsEquipment: Boolean;
    function IsWeapon: Boolean;
    function IsArmor: Boolean;
    function IsLockable: Boolean;
    function IsContainer: Boolean;
    function IsMobile: Boolean;
  end;

  BaseMobileController = class abstract(TInterfaceBase, IMobileController)
  public
    procedure Start; virtual; abstract;
    procedure Stop; virtual; abstract;
  end;

implementation

uses
  System.Math,
  System.SysUtils;

var
  fLastSerial: Int64;

function GetSerial: Int64;
begin
  Inc(fLastSerial);
  Result := fLastSerial;
end;

{ EventDamageData }

constructor EventDamageData.Create(
  aTotalAmount: Word;
  aSource: IMobile;
  aSourceWeapon: IWeapon;
  aTarget: IMobile;
  aTargetAmount: Word;
  aTargetArmor: IArmor;
  aTargetArmorAmount: Word;
  aTargetBodyPart: BodyPartType);
begin
  fTotalAmount := aTotalAmount;
  fSource := aSource;
  fSourceWeapon := aSourceWeapon;
  fTarget := aTarget;
  fTargetAmount := aTargetAmount;
  fTargetArmor := aTargetArmor;
  fTargetArmorAmount := aTargetArmorAmount;
  fTargetBodyPart := aTargetBodyPart;
end;

function EventDamageData.Source: IMobile;
begin
  Result := fSource;
end;

function EventDamageData.SourceWeapon: IWeapon;
begin
  Result := fSourceWeapon;
end;

function EventDamageData.Target: IMobile;
begin
  Result := fTarget;
end;

function EventDamageData.TargetAmount: Word;
begin
  Result := fTargetAmount;
end;

function EventDamageData.TargetArmor: IArmor;
begin
  Result := fTargetArmor;
end;

function EventDamageData.TargetArmorAmount: Word;
begin
  Result := fTargetArmorAmount;
end;

function EventDamageData.TargetBodyPart: BodyPartType;
begin
  Result := fTargetBodyPart;
end;

function EventDamageData.TotalAmount: Word;
begin
  Result := fTotalAmount;
end;

{ BaseObject }

constructor BaseObject.Create(const where: IWorld);
begin
  fSerial := GetSerial;
  fWorld := where;
  fPosition.X := 0;
  fPosition.Y := 0;
end;

destructor BaseObject.Destroy;
begin
  inherited;
end;

function BaseObject.Serial: Int64;
begin
  Result := fSerial;
end;

function BaseObject.Name: String;
begin
  Result := fName;
end;

function BaseObject.Graphic: String;
begin
  Result := fGraphic;
end;

function BaseObject.Color: Integer;
begin
  Result := fColor;
end;

function BaseObject.Facing: Direction;
begin
  Result := fFacing;
end;

function BaseObject.Size: Word;
begin
  Result := fSize;
end;

function BaseObject.World: IWorld;
begin
  Result := fWorld;
end;

function BaseObject.Position: TPoint;
begin
  Result := fPosition;
end;

function BaseObject.Weight: Word;
begin
  Result := fWeight;
end;

function BaseObject.IsItem: Boolean;
begin
  Result :=  Supports(Self, IItem);
end;

function BaseObject.IsEquipment: Boolean;
begin
  Result := Supports(Self, IEquipment);
end;

function BaseObject.IsLockable: Boolean;
begin
  Result := Supports(Self, ILockable);
end;

function BaseObject.IsContainer: Boolean;
begin
  Result := Supports(Self, IContainer);
end;

function BaseObject.IsWeapon: Boolean;
begin
  Result := Supports(Self, IWeapon);
end;

function BaseObject.IsArmor: Boolean;
begin
  Result := Supports(Self, IArmor);
end;

function BaseObject.IsMobile: Boolean;
begin
  Result := Supports(Self, IMobile);
end;

function BaseObject.GetDistance(const target: IObject): Word;
begin
  Result := Trunc(Position.Distance(target.Position) - (target.Size / 2));
end;

procedure BaseObject.SetName(const value: String);
begin
  fName := value;
end;

procedure BaseObject.SetGraphic(const value: String);
begin
  fGraphic := value;
end;

procedure BaseObject.SetColor(const value: Integer);
begin
  fColor := value;
end;

procedure BaseObject.SetPosition(const x, y: Word);
begin
  fPosition.X := x;
  fPosition.Y := y;
end;

procedure BaseObject.SetSize(const value: Word);
begin
  fSize := value;
end;

procedure BaseObject.SetFacing(const dir: Direction);
begin
  fFacing := dir;
end;

procedure BaseObject.SetWeight(const value: Word);
begin
  fWeight := value;
end;

{ DamageData }

constructor DamageData.Create(const dmgType: DamageType; const value: Percent);
begin
  fDamageType := dmgType;
  fDamageBase := value;
end;

function DamageData.DamageType: DamageType;
begin
  Result := fDamageType;
end;

function DamageData.DamageBase: Byte;
begin
  Result := fDamageBase;
end;

{ ResistData }

constructor ResistData.Create(const dmgType: DamageType; const value: Percent);
begin
  fDamageType := dmgType;
  fResistBase := value;
end;

function ResistData.DamageType: DamageType;
begin
  Result := fDamageType;
end;

function ResistData.ResistBase: Percent;
begin
  Result := fResistBase;
end;

initialization
  Randomize;

end.
