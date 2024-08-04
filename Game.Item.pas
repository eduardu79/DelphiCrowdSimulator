unit Game.Item;

interface

uses
  Spring,
  Game;

type
  Item = class abstract(BaseObject, IObject, IItem)
  strict private
    fInitialHP: Word;
    fQuality: ItemQuality;
    fHP: Word;
    fOnBroke: Event<EventItem>;
    procedure DoOnBroke;
  protected
    procedure SetQuality(const value: ItemQuality);
    procedure SetHP(const value: Word);
  public
    constructor Create(const where: IWorld); override;
    destructor Destroy; override;
    function Quality: ItemQuality; virtual;
    function HP: Percent;
    function IsBroken: Boolean;
    function GetOnBroke: IEvent<EventItem>;
    procedure Use; virtual;
    procedure Damage(const amount: Word);
    property OnBroke: IEvent<EventItem> read GetOnBroke;
  end;

implementation

{ Item }

constructor Item.Create(const where: IWorld);
var
  base: Double;
  amount: Double;
begin
  inherited;
  fOnBroke.UseFreeNotification := True;

  fQuality := iqLow;
  base := 1000;

  case Quality of
    iqLow: amount := base * 0.7;
    iqGood: amount := base * 1.25;
    iqGreat: amount := base * 1.5;
    iqExceptional: amount := base * 2;
  else
    amount := base;
  end;

  fInitialHP := Trunc(amount);
  fHP := fInitialHP;
end;

destructor Item.Destroy;
begin
  fOnBroke.Clear;
  inherited;
end;

function Item.Quality: ItemQuality;
begin
  Result := fQuality;
end;

function Item.HP: Percent;
begin
  Result := Trunc((fHP * 100) / fInitialHP);
end;

function Item.IsBroken: Boolean;
begin
  Result := fHP <= 0;
end;

function Item.GetOnBroke: IEvent<EventItem>;
begin
  Result := fOnBroke;
end;

procedure Item.SetHP(const value: Word);
begin
  fHP := value;
end;

procedure Item.SetQuality(const value: ItemQuality);
begin
  fQuality := value;
end;

procedure Item.Damage(const amount: Word);
begin
  if not IsBroken then
  begin
    if fHP - amount < 0 then
    begin
      fHP := 0;
    end
    else
    begin
      fHP := fHP - amount;
    end;

    if IsBroken then
    begin
      DoOnBroke;
    end;
  end;
end;

procedure Item.DoOnBroke;
begin
  if OnBroke.Enabled and OnBroke.CanInvoke then
  begin
    fOnBroke.Invoke(Self);
  end;
end;

procedure Item.Use;
begin
  if not IsBroken then
  begin
    fHP := fHP - 1;
    if IsBroken then
    begin
      DoOnBroke;
    end;
  end;
end;

end.
