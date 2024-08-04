unit Game.Item.Equipment.Weapon.ShortSword;

interface

uses
  Game,
  Game.Item.Equipment.Weapon;

type
  ShortSword = class(Weapon)
  public
    constructor Create(const where: IWorld); override;
  end;

implementation

{ ShortSword }

constructor ShortSword.Create(const where: IWorld);
begin
  inherited;
  SetName('Espada Curta');
  SetSpeed(40);
  SetRange(16);
  SetWeight(3);
  AppendDamageData(dtFisical, 25);
end;

end.
