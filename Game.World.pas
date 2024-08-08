unit Game.World;

interface

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  Vcl.Graphics,
  Vcl.ExtCtrls,
  Spring,
  Spring.Collections,
  Game;

type
  WorldObject = class(TInterfaceBase, IWorld)
  strict private
    fMobiles: IList<IMobile>;
    fDeadMobiles: IList<IMobile>;
    fSize: TSize;
    fRunning: Boolean;
    fTimer: TTimer;
    fClock: Int64;
    fDebug: Boolean;
    fOnClock: Event<EventClock>;
    fOnMobileDamaged: Event<EventDamage>;
    fOnMobileDied: Event<EventMobile>;
    function GetOnClock: IEvent<EventClock>;
    function GetOnMobileDamaged: IEvent<EventDamage>;
    function GetOnMobileDied: IEvent<EventMobile>;
    procedure TimerOnTick(sender: TObject);
    procedure DoOnClock;
    procedure DoOnMobileDamaged(const data: EventDamageData);
    procedure DoOnMobileDied(const source: IMobile);
    procedure ItemBrokeEvent(const value: IItem);
    procedure MobileDamagedEvent(const data: EventDamageData);
    procedure MobileDiedEvent(const source: IMobile);
  private
    function CreateObj(const objclass: BaseObjectClass): IObject; overload;
    function CreateObj(const objclass: BaseObjectClass; const params: array of TValue): IObject; overload;
    function CheckLineOfSight(const objA, objB: IObject): Boolean;
    function CanMove(const obj: IObject; const position: TPoint): Boolean;
    function Clock: Int64;
    function Mobiles: TArray<IMobile>;
    function Size: TSize;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize(const width, height: Word);
    procedure Resize(const width, height: Word);
    procedure Draw(const canvas: TCanvas);
    procedure Shutdown;
    procedure KillAll;
    procedure Debug(const value: Boolean);
    procedure Running(const value: Boolean);
    function CreateMobile(const mob: BaseObjectClass): IMobile; overload;
    function CreateMobile(const mob: BaseObjectClass; const params: array of TValue): IMobile; overload;
    function CreateEquipment(const equip: BaseObjectClass): IEquipment; overload;
    function IsDebug: Boolean;
    function IsRunning: Boolean;
    property OnClock: IEvent<EventClock> read GetOnClock;
    property OnMobileDamaged: IEvent<EventDamage> read GetOnMobileDamaged;
    property OnMobileDied: IEvent<EventMobile> read GetOnMobileDied;
  end;

implementation

uses
  System.TimeSpan;

{ WorldObject }

constructor WorldObject.Create;
begin
  fMobiles := TCollections.CreateList<IMobile>;
  fDeadMobiles := TCollections.CreateList<IMobile>;
  fOnClock.UseFreeNotification := True;
  fOnMobileDamaged.UseFreeNotification := True;
  fOnMobileDied.UseFreeNotification := True;
  fTimer := TTimer.Create(nil);
  fTimer.Interval := 1000 div TICKS_PER_SECOND;
  fTimer.OnTimer := TimerOnTick;
end;

destructor WorldObject.Destroy;
var
  obj: IObject;
begin
  while not fMobiles.IsEmpty do
  begin
    obj := fMobiles.ExtractAt(0);
    obj.Free;
  end;
  while not fDeadMobiles.IsEmpty do
  begin
    obj := fDeadMobiles.ExtractAt(0);
    obj.Free;
  end;
  fOnClock.Clear;
  fOnMobileDamaged.Clear;
  fOnMobileDied.Clear;
  fTimer.Free;
  inherited;
end;

function WorldObject.CreateEquipment(const equip: BaseObjectClass): IEquipment;
begin
  Result := CreateObj(equip) as IEquipment;
end;

function WorldObject.CreateMobile(const mob: BaseObjectClass): IMobile;
begin
  Result := CreateObj(mob) as IMobile;
end;

function WorldObject.CreateMobile(const mob: BaseObjectClass; const params: array of TValue): IMobile;
begin
  Result := CreateObj(mob, params) as IMobile;
end;

function WorldObject.CreateObj(const objclass: BaseObjectClass): IObject;
begin
  Result := CreateObj(objclass, []);
end;

function WorldObject.CreateObj(const objclass: BaseObjectClass; const params: array of TValue): IObject;
var
  spawnPoint: TPoint;
  spawnPointIsValid: Boolean;
  new: TObject;
  obj: IObject;
  itm: IItem;
  mob: IMobile;
  selfValue: TValue;
  allParams: TArray<TValue>;
  param: TValue;
begin
  Result := nil;
  selfValue := Self;
  allParams := [selfValue];
  for param in params do
  begin
    allParams := allParams + [param];
  end;

  new := TActivator.CreateInstance(objclass, allParams);

  if Supports(new, IObject, obj) then
  begin
    if Supports(obj, IItem, itm) then
    begin
      itm.OnBroke.Add(ItemBrokeEvent);
    end;

    if Supports(obj, IMobile, mob) then
    begin
      mob.OnDamaged.Add(MobileDamagedEvent);
      mob.OnDied.Add(MobileDiedEvent);
      fMobiles.Add(mob);
    end;

    spawnPointIsValid := False;
    while not spawnPointIsValid do
    begin
      spawnPoint := TPoint.Create(Random(Size.Width), Random(Size.Height));
      spawnPointIsValid := CanMove(obj, spawnPoint);
    end;
    obj.SetPosition(spawnPoint.X, spawnPoint.Y);

    Result := obj;
  end;
end;

function WorldObject.CanMove(const obj: IObject; const position: TPoint): Boolean;
var
  worldRect: TRect;
  objRect: TRect;
  existent: IObject;
  existentRect: TRect;
begin
  worldRect := Rect(0 + (obj.Size div 2), 0 + (obj.Size div 2), Size.Width - (obj.Size div 2), Size.Height - (obj.Size div 2));
  Result := worldRect.Contains(position);

  if Result then
  begin
    for existent in fMobiles do
    begin
      if existent.Serial <> obj.Serial then
      begin
        existentRect := Rect(
          existent.Position.X - (existent.Size div 2),
          existent.Position.Y - (existent.Size div 2),
          existent.Position.X + (existent.Size div 2),
          existent.Position.Y + (existent.Size div 2));

        objRect := Rect(
          position.X - (obj.Size div 2),
          position.Y - (obj.Size div 2),
          position.X + (obj.Size div 2),
          position.Y + (obj.Size div 2));

        Result := Result and (not objRect.IntersectsWith(existentRect));
        if not Result then
        begin
          Exit(False);
        end;
      end;
    end;
  end;
end;

function WorldObject.CheckLineOfSight(const objA, objB: IObject): Boolean;
begin
  Result := True;
end;

function WorldObject.Clock: Int64;
begin
  Result := fClock;
end;

function WorldObject.Size: TSize;
begin
  Result := fSize;
end;

function WorldObject.IsDebug: Boolean;
begin
  Result := fDebug;
end;

function WorldObject.GetOnClock: IEvent<EventClock>;
begin
  Result := fOnClock;
end;

function WorldObject.GetOnMobileDamaged: IEvent<EventDamage>;
begin
  Result := fOnMobileDamaged;
end;

function WorldObject.GetOnMobileDied: IEvent<EventMobile>;
begin
  Result := fOnMobileDied;
end;

function WorldObject.Mobiles: TArray<IMobile>;
begin
  Result := fMobiles.ToArray;
end;

function WorldObject.IsRunning: Boolean;
begin
  Result := fRunning;
end;

procedure WorldObject.Initialize(const width, height: Word);
begin
  Resize(width, height);
  fClock := 0;
  fRunning := True;
  fTimer.Enabled := True;
end;

procedure WorldObject.Resize(const width, height: Word);
begin
  fSize := TSize.Create(width, height);
end;

procedure WorldObject.Running(const value: Boolean);
begin
  fRunning := value;
end;

procedure WorldObject.Draw(const canvas: TCanvas);
const
  TOTALXHP = 40;
var
  mob: IMobile;
  inRange: IMobile;
  ypos: Word;
  text: String;
begin
  canvas.Pen.Style := psSolid;
  canvas.Pen.Width := 1;
  canvas.Font.Name := 'Tahoma';
  canvas.Font.Size := 7;

  for mob in fMobiles do
  begin
    if mob.IsAlive then
    begin
      canvas.Brush.Color := mob.Color;
      canvas.Font.Color := mob.Color;
      canvas.Pen.Color := mob.Color;

      canvas.Ellipse(
        Trunc(mob.Position.X - (mob.Size / 2)),
        Trunc(mob.Position.Y - (mob.Size / 2)),
        Trunc(mob.Position.X + (mob.Size / 2)),
        Trunc(mob.Position.Y + (mob.Size / 2)));

      canvas.Brush.Style := bsClear;

      if IsDebug then
      begin
        canvas.Pen.Style := psSolid;
        canvas.Pen.Color := $000050;

        canvas.Ellipse(
          Trunc(mob.Position.X - mob.AttackRange),
          Trunc(mob.Position.Y - mob.AttackRange),
          Trunc(mob.Position.X + mob.AttackRange),
          Trunc(mob.Position.Y + mob.AttackRange));

        canvas.Pen.Style := psDot;
        canvas.Pen.Color := $333333;

        canvas.Ellipse(
          Trunc(mob.Position.X - mob.SightRange),
          Trunc(mob.Position.Y - mob.SightRange),
          Trunc(mob.Position.X + mob.SightRange),
          Trunc(mob.Position.Y + mob.SightRange));

        for inRange in mob.GetMobilesInRange do
        begin
          canvas.Polyline([mob.Position, inRange.Position]);
        end;

        ypos := Trunc(mob.Position.Y - mob.Size - 20);
        canvas.TextOut(mob.Position.X - canvas.TextExtent(mob.Name).Width div 2, ypos, mob.Name);
        Dec(ypos, 7);

        canvas.Pen.Style := psSolid;
        canvas.Pen.Color := mob.Color;
        canvas.Rectangle(Trunc(mob.Position.X - TOTALXHP / 2),
                         ypos - 3,
                         Trunc(mob.Position.X + TOTALXHP / 2),
                         ypos + 3);

        canvas.Brush.Style := bsSolid;
        canvas.Brush.Color := mob.Color;
        canvas.Rectangle(Trunc(mob.Position.X - TOTALXHP / 2),
                         ypos - 3,
                         Trunc((mob.Position.X - TOTALXHP / 2) + ((mob.HP / mob.MaxHP * 100) * TOTALXHP / 100)),
                         ypos + 3);
        canvas.Brush.Style := bsClear;

        Dec(ypos, 20);
        text := Format('INT: %d', [Trunc(mob.Int / 10)]);
        canvas.TextOut(mob.Position.X - canvas.TextExtent(text).Width div 2, ypos, text);

        Dec(ypos, 10);
        text := Format('DEX: %d', [Trunc(mob.Dex / 10)]);
        canvas.TextOut(mob.Position.X - canvas.TextExtent(text).Width div 2, ypos, text);

        Dec(ypos, 10);
        text := Format('STR: %d', [Trunc(mob.Str / 10)]);
        canvas.TextOut(mob.Position.X - canvas.TextExtent(text).Width div 2, ypos, text);
      end;
    end;
  end;
end;

procedure WorldObject.Shutdown;
begin
  fTimer.Enabled := False;
end;

procedure WorldObject.KillAll;
var
  index: Integer;
  mob: IMobile;
begin
  for index := Pred(fMobiles.Count) downto 0 do
  begin
    mob := fMobiles.Items[index];
    mob.Kill;
  end;
end;

procedure WorldObject.Debug(const value: Boolean);
begin
  fDebug := value;
end;

procedure WorldObject.DoOnClock;
begin
  if fOnClock.Enabled and fOnClock.CanInvoke then
  begin
    fOnClock.Invoke;
  end;
end;

procedure WorldObject.DoOnMobileDamaged(const data: EventDamageData);
begin
  if fOnMobileDamaged.Enabled and fOnMobileDamaged.CanInvoke then
  begin
    fOnMobileDamaged.Invoke(data);
  end;
  data.Free;
end;

procedure WorldObject.DoOnMobileDied(const source: IMobile);
begin
  if fOnMobileDied.Enabled and fOnMobileDied.CanInvoke then
  begin
    fOnMobileDied.Invoke(source);
  end;
end;

procedure WorldObject.ItemBrokeEvent(const value: IItem);
begin
  value.Free;
end;

procedure WorldObject.MobileDamagedEvent(const data: EventDamageData);
begin
  DoOnMobileDamaged(data);
end;

procedure WorldObject.MobileDiedEvent(const source: IMobile);
begin
  DoOnMobileDied(source);
  if fMobiles.Remove(fMobiles.Where(function(const mob: IMobile): Boolean
                                    begin
                                      Result := mob.Serial = source.Serial;
                                    end).FirstOrDefault) then
  begin
    source.OnDamaged.Remove(MobileDamagedEvent);
    source.OnDied.Remove(MobileDiedEvent);
    fDeadMobiles.Add(source);
  end;
end;

procedure WorldObject.TimerOnTick(sender: TObject);
begin
  if IsRunning then
  begin
    Inc(fClock);
    DoOnClock;
  end;
end;

end.
