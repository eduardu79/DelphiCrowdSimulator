unit Game.Mobile.AI.Hostile;

interface

uses
  Game,
  Game.Mobile.AI;

type
  HostileAI = class(MobileAIController)
  strict private
    fTarget: IMobile;
    procedure TargetDied(const source: IMobile);
    procedure Lock(const target: IMobile);
    function GetTarget: IMobile;
  protected
    procedure Cycle; override;
    function CanBeTarget(const target: IMobile): Boolean; virtual;
  end;

implementation

{ HostileAI }

procedure HostileAI.Cycle;
var
  mob: IMobile;
begin
  mob := GetTarget;
  if mob = nil then
  begin
    for mob in Mobile.GetMobilesInRange do
    begin
      if CanBeTarget(mob) and Mobile.CanView(mob) then
      begin
        Lock(mob);
      end;
    end;
  end;

  mob := GetTarget;
  if mob <> nil then
  begin
    if Mobile.CanView(mob) then
    begin
      if Mobile.CanAttack(mob) then
      begin
        Mobile.Attack(mob);
      end
      else if Mobile.CanMove(mob) then
      begin
        Mobile.Move(mob);
      end
      else
      begin
        fTarget := nil;
        inherited;
      end;
    end
    else
    begin
      fTarget := nil;
      inherited;
    end;
  end
  else
    inherited;
end;

procedure HostileAI.Lock(const target: IMobile);
begin
 if target.Serial <> Mobile.Serial then
 begin
   fTarget := target;
   fTarget.OnDied.Add(TargetDied);
 end;
end;

function HostileAI.CanBeTarget(const target: IMobile): Boolean;
begin
  Result := True;
end;

procedure HostileAI.TargetDied(const source: IMobile);
begin
  fTarget := nil;
end;

function HostileAI.GetTarget: IMobile;
begin
  Result := fTarget;
end;

end.
