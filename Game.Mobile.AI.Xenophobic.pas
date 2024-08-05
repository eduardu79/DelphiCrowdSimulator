unit Game.Mobile.AI.Xenophobic;

interface

uses
  Game,
  Game.Mobile.AI.Hostile;

type
  XenophobicAI = class(HostileAI)
  protected
    function CanBeTarget(const target: IMobile): Boolean; override;
  end;

implementation

{ XenophobicAI }

function XenophobicAI.CanBeTarget(const target: IMobile): Boolean;
begin
  Result := target.Color <> Mobile.Color;
end;

end.
