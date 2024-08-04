unit Game.Mobile.AI;

interface

uses
  Spring,
  Spring.Collections,
  Game,
  Game.Mobile;

type
  MobileAIController = class abstract(MobileController)
  strict private
    fLastDirChange: Int64;
    fDirection: Direction;
  protected
    procedure Cycle; override;
    procedure Wander;
    function GetRandomDirection: Direction;
    function GetMoveDirection: Direction; virtual; abstract;
    function LastDirectionChange: Int64;
  public
    constructor Create(const mob: IMobile); override;
  end;

implementation

{ MobileAIController }

constructor MobileAIController.Create(const mob: IMobile);
begin
  inherited;
end;

procedure MobileAIController.Cycle;
begin
  inherited;
  Wander;
end;

procedure MobileAIController.Wander;
begin
  Mobile.Move(GetRandomDirection);
end;

function MobileAIController.GetRandomDirection: Direction;
const
  MAX_TRIES = 3;
var
  i: Integer;
begin
  if Mobile.World.Clock >= LastDirectionChange + Random(TICKS_PER_SECOND) + TICKS_PER_SECOND * 2 then
  begin;
    fLastDirChange := Mobile.World.Clock;
    for i := 1 to MAX_TRIES do
    begin
      fDirection := Direction(Random(Integer(High(Direction))));
      if Mobile.CanMove(fDirection) then
      begin
        Break;
      end;
    end;
  end;
  Result := fDirection;
end;

function MobileAIController.LastDirectionChange: Int64;
begin
  Result := fLastDirChange;
end;

end.
