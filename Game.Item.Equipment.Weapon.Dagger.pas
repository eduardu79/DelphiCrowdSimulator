unit Game.Item.Equipment.Weapon.Dagger;

interface

uses
  Game,
  Game.Item.Equipment.Weapon;

type
  Dagger = class(Weapon)
  public
    constructor Create(const where: IWorld); override;
  end;

implementation

{ Dagger }

constructor Dagger.Create(const where: IWorld);
begin
  inherited;
  SetName('Adaga');
  SetSpeed(75);
  SetRange(8);
  SetWeight(1);
  AppendDamageData(dtFisical, 15);
end;

end.
