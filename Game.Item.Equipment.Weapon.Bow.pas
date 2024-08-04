unit Game.Item.Equipment.Weapon.Bow;

interface

uses
  Game,
  Game.Item.Equipment.Weapon;

type
  Bow = class(Weapon)
  public
    constructor Create(const where: IWorld); override;
  end;

implementation

{ Bow }

constructor Bow.Create(const where: IWorld);
begin
  inherited;
  SetName('Arco e flechas');
  SetSpeed(55);
  SetRange(100);
  SetWeight(1);
  AppendDamageData(dtFisical, 12);
end;

end.
