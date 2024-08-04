unit Game.Mobile.Player;

interface

uses
  Winapi.Windows,
  Spring,
  Game,
  Game.Mobile;

type
  MobilePlayerController = class(MobileController)
  strict private
    fLastDirectionChange: TDateTime;
    fLastDirection: Nullable<Direction>;
  protected
    procedure Cycle; override;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils;

{ MobilePlayerController }

procedure MobilePlayerController.Cycle;
begin
  inherited;

  if (GetKeyState(VK_UP) and $8000) <> 0 then
  begin
    fLastDirection := dNorth;
    fLastDirectionChange := Now;
  end
  else if (GetKeyState(VK_RIGHT) and $8000) <> 0 then
  begin
    fLastDirection := dEast;
    fLastDirectionChange := Now;
  end
  else if (GetKeyState(VK_DOWN) and $8000) <> 0 then
  begin
    fLastDirection := dSouth;
    fLastDirectionChange := Now;
  end
  else if (GetKeyState(VK_LEFT) and $8000) <> 0 then
  begin
    fLastDirection := dWest;
    fLastDirectionChange := Now;
  end;

  if fLastDirection.HasValue and (MilliSecondsBetween(Now, fLastDirectionChange) < 500) then
  begin
    Mobile.Move(fLastDirection);
  end;
end;

end.
