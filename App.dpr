program App;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Game in 'Game.pas',
  Game.Item in 'Game.Item.pas',
  Game.Item.Equipment in 'Game.Item.Equipment.pas',
  Game.Item.Equipment.Armor in 'Game.Item.Equipment.Armor.pas',
  Game.Item.Equipment.Weapon in 'Game.Item.Equipment.Weapon.pas',
  Game.Item.Equipment.Weapon.Dagger in 'Game.Item.Equipment.Weapon.Dagger.pas',
  Game.Item.Equipment.Weapon.ShortSword in 'Game.Item.Equipment.Weapon.ShortSword.pas',
  Game.Item.Lockable in 'Game.Item.Lockable.pas',
  Game.Item.Lockable.Container in 'Game.Item.Lockable.Container.pas',
  Game.Mobile in 'Game.Mobile.pas',
  Game.Mobile.Human in 'Game.Mobile.Human.pas',
  Game.Mobile.Player in 'Game.Mobile.Player.pas',
  Game.Mobile.AI in 'Game.Mobile.AI.pas',
  Game.Mobile.AI.Pacific in 'Game.Mobile.AI.Pacific.pas',
  Game.Mobile.AI.Hostile in 'Game.Mobile.AI.Hostile.pas',
  Game.Mobile.AI.Xenophobic in 'Game.Mobile.AI.Xenophobic.pas',
  Game.World in 'Game.World.pas',
  Vcl.Themes,
  Vcl.Styles,
  Game.Item.Equipment.Weapon.Bow in 'Game.Item.Equipment.Weapon.Bow.pas';

{$R *.res}

var
  MainForm: TMainForm;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
