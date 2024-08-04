unit Main;

interface

uses
  Winapi.Windows,
  System.Classes,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Graphics,
  Vcl.Forms,
  Game,
  Game.World, Vcl.ComCtrls, Vcl.Samples.Spin;

type
  TMainForm = class(TForm)
    panelMain: TPanel;
    panelControls: TPanel;
    Label2: TLabel;
    addAIMobileBtn: TButton;
    edtName: TEdit;
    edtColor: TColorListBox;
    addPlayerMobileBtn: TButton;
    edtSword: TCheckBox;
    radioButtonPacific: TRadioButton;
    radioButtonXenophobic: TRadioButton;
    radioButtonHostile: TRadioButton;
    btnKillAll: TButton;
    edtArmor: TCheckBox;
    paintBox: TPaintBox;
    richEditLog: TRichEdit;
    spinEditTeams: TSpinEdit;
    spinEditTeamSize: TSpinEdit;
    LabelTeams: TLabel;
    edtDebug: TCheckBox;
    edtStr: TSpinEdit;
    edtDex: TSpinEdit;
    edtInt: TSpinEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtRandomStats: TCheckBox;
    edtDagger: TCheckBox;
    edtBow: TCheckBox;
    edtRunning: TCheckBox;
    procedure addAIMobileBtnClick(Sender: TObject);
    procedure paintBoxPaint(Sender: TObject);
    procedure addPlayerMobileBtnClick(Sender: TObject);
    procedure btnKillAllClick(Sender: TObject);
    procedure edtDebugClick(Sender: TObject);
    procedure edtRandomStatsClick(Sender: TObject);
    procedure spinEditTeamsChange(Sender: TObject);
    procedure edtRunningClick(Sender: TObject);
  strict private type
    AIStyle = (aiNone, aiPacific, aiXeno, aiPsycho);
  strict private
    fWorld: WorldObject;
    function Translate(const part: BodyPartType): String;
    procedure WorldClockEvent;
    procedure MobileDamagedEvent(const data: EventDamageData);
    procedure MobileDiedEvent(const source: IMobile);
    procedure Log(const text: String; const hue: TColor = clGreen);
    procedure CreateMobile(const name: String;
                           const hue: TColor;
                           const giveDagger: Boolean;
                           const giveSword: Boolean;
                           const giveBow: Boolean;
                           const giveArmor: Boolean;
                           const randomStats: Boolean;
                           const str, dex, int: AttributeValue;
                           const aiStyle: AIStyle);
  protected
    procedure DoShow; override;
    procedure Resize; override;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Math,
  Spring,
  Game.Mobile.AI,
  Game.Mobile.AI.Pacific,
  Game.Mobile.AI.Hostile,
  Game.Mobile.AI.Xenophobic,
  Game.Mobile.Player,
  Game.Mobile.Human,
  Game.Item.Equipment.Armor,
  Game.Item.Equipment.Weapon.Bow,
  Game.Item.Equipment.Weapon.Dagger,
  Game.Item.Equipment.Weapon.ShortSword;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.AfterConstruction;
begin
  inherited;
  fWorld := WorldObject.Create;
  fWorld.OnClock.Add(WorldClockEvent);
  fWorld.OnMobileDamaged.Add(MobileDamagedEvent);
  fWorld.OnMobileDied.Add(MobileDiedEvent);
end;

procedure TMainForm.BeforeDestruction;
begin
  inherited;
  fWorld.Shutdown;
  fWorld.Free;
end;

procedure TMainForm.btnKillAllClick(Sender: TObject);
begin
  fWorld.KillAll;
  richEditLog.Lines.Clear;
end;

procedure TMainForm.DoShow;
begin
  inherited;
  fWorld.Initialize(PaintBox.ClientWidth, PaintBox.ClientHeight);
end;

procedure TMainForm.Resize;
begin
  inherited;
  fWorld.Resize(paintBox.ClientWidth, paintBox.ClientHeight);
end;

procedure TMainForm.spinEditTeamsChange(Sender: TObject);
begin
  radioButtonPacific.Enabled := spinEditTeams.Value = 1;
  radioButtonHostile.Enabled := spinEditTeams.Value = 1;
  radioButtonXenophobic.Enabled := spinEditTeams.Value = 1;
end;

procedure TMainForm.WorldClockEvent;
begin
  Refresh;
end;

procedure TMainForm.MobileDamagedEvent(const data: EventDamageData);
var
  phrase: String;
begin
  phrase := Format('%s golpeou com %s %s de %s. Dano: %d', [data.Source.Name,
                                                            data.SourceWeapon.Name,
                                                            Translate(data.TargetBodyPart),
                                                            data.Target.Name,
                                                            data.TargetAmount]);

  if data.TargetArmor <> nil then
  begin
    phrase := Format('%s Armor: %s Dano na armor: %d', [phrase,
                                                        data.TargetArmor.Name,
                                                        data.TargetArmorAmount]);
  end;

  Log(phrase);
end;

procedure TMainForm.MobileDiedEvent(const source: IMobile);
const
  DEATHS: array[0..7] of String = ('%s bateu as botas.', '%s morreu.', '%s já era.', '%s partiu dessa pra melhor.',
                                   '%s foi comer capim pela raiz.', '%s foi pro beleléu.', 'Sentiremos falta de %s.', 'Adeus %s.');
begin
  Log(Format(DEATHS[Random(Length(DEATHS))], [source.Name]), $005050FF);
end;

procedure TMainForm.Log(const text: String; const hue: TColor);
begin
  richEditLog.Lines.Insert(0, text);

  richEditLog.SelStart := 0;
  richEditLog.SelLength := richEditLog.Lines[0].Length;
  richEditLog.SelAttributes.Color := hue;

  while richEditLog.Lines.Count > 10 do
  begin
    richEditLog.Lines.Delete(10);
  end;
end;

procedure TMainForm.paintBoxPaint(Sender: TObject);
begin
  fWorld.Draw(PaintBox.Canvas);
end;

procedure TMainForm.addPlayerMobileBtnClick(Sender: TObject);
begin
  CreateMobile(edtName.Text,
               edtColor.Selected,
               edtDagger.Checked,
               edtSword.Checked,
               edtBow.Checked,
               edtArmor.Checked,
               edtRandomStats.Checked,
               edtStr.Value,
               edtDex.Value,
               edtInt.Value,
               aiNone);
  addPlayerMobileBtn.Enabled := False;
end;

procedure TMainForm.addAIMobileBtnClick(Sender: TObject);
const
  colors: array[1..4] of TColor = (clRed, clLime, clBlue, clYellow);
var
  style: AIStyle;
  t, j: Integer;
  hue: TColor;
begin
  if radioButtonHostile.Checked then
    style := aiPsycho
  else if radioButtonXenophobic.Checked then
    style := aiXeno
  else
    style := aiPacific;

  if (spinEditTeams.Value > 1) or (spinEditTeamSize.Value > 1) then
  begin
    if spinEditTeams.Value > 1 then
    begin
      style := aiXeno;
    end;

    for t := 1 to spinEditTeams.Value do
    begin
      for j := 1 to spinEditTeamSize.Value do
      begin
        hue := colors[t];
        if spinEditTeams.Value = 1 then
        begin
          hue := edtColor.Selected;
        end;
        CreateMobile(
          Format('%s%d', [IfThen((spinEditTeams.Value > 1) and (spinEditTeamSize.Value > 1),
                                  Format('[Team %d]',
                                  [t]), EmptyStr), j]),
          hue,
          edtDagger.Checked,
          edtSword.Checked,
          edtBow.Checked,
          edtArmor.Checked,
          edtRandomStats.Checked,
          edtStr.Value,
          edtDex.Value,
          edtInt.Value,
          style);
      end;
    end;
  end
  else
  begin
    CreateMobile(edtName.Text,
                 edtColor.Selected,
                 edtDagger.Checked,
                 edtSword.Checked,
                 edtBow.Checked,
                 edtArmor.Checked,
                 edtRandomStats.Checked,
                 edtStr.Value,
                 edtDex.Value,
                 edtInt.Value,
                 style);
  end;
end;

procedure TMainForm.edtDebugClick(Sender: TObject);
begin
  fWorld.Debug(edtDebug.Checked);
end;

procedure TMainForm.edtRandomStatsClick(Sender: TObject);
begin
  edtStr.Enabled := not edtRandomStats.Checked;
  edtDex.Enabled := not edtRandomStats.Checked;
  edtInt.Enabled := not edtRandomStats.Checked;
end;

procedure TMainForm.edtRunningClick(Sender: TObject);
begin
  fWorld.Running(edtRunning.Checked);
end;

procedure TMainForm.CreateMobile(const name: String;
                                 const hue: TColor;
                                 const giveDagger: Boolean;
                                 const giveSword: Boolean;
                                 const giveBow: Boolean;
                                 const giveArmor: Boolean;
                                 const randomStats: Boolean;
                                 const str, dex, int: AttributeValue;
                                 const aiStyle: AIStyle);
var
  mobName: String;
  mobColor: TColor;
  mob: IMobile;
begin
  mobName := name;
  mobColor := hue;
  if mobName.IsEmpty then
  begin
    mobName := ColorToString(mobColor);
  end;

  mob := fWorld.CreateMobile(Human, [mobName, mobColor]);

  case aiStyle of
    aiNone   : mob.SetController(MobilePlayerController);
    aiPacific: mob.SetController(PacificAI);
    aiXeno   : mob.SetController(XenophobicAI);
    aiPsycho : mob.SetController(HostileAI);
  end;

  if not randomStats then
  begin
    mob.SetStr(str * 10);
    mob.SetDex(dex * 10);
    mob.SetInt(int * 10);
  end;

  if giveDagger then
  begin
    mob.Equip(fWorld.CreateEquipment(Dagger));
  end
  else if giveSword then
  begin
    mob.Equip(fWorld.CreateEquipment(ShortSword));
  end
  else if giveBow then
  begin
    mob.Equip(fWorld.CreateEquipment(Bow));
  end;

  if giveArmor then
  begin
    mob.Equip(fWorld.CreateEquipment(HeadArmor));
    mob.Equip(fWorld.CreateEquipment(TorsoArmor));
    mob.Equip(fWorld.CreateEquipment(LegArmor));
    mob.Equip(fWorld.CreateEquipment(LegArmor));
    mob.Equip(fWorld.CreateEquipment(FootArmor));
    mob.Equip(fWorld.CreateEquipment(FootArmor));
    mob.Equip(fWorld.CreateEquipment(ArmArmor));
    mob.Equip(fWorld.CreateEquipment(ArmArmor));
    mob.Equip(fWorld.CreateEquipment(HandArmor));
    mob.Equip(fWorld.CreateEquipment(HandArmor));
  end;
end;

function TMainForm.Translate(const part: BodyPartType): String;
begin
  case part of
    btHead: Result := 'a cabeça';
    btTorso: Result := 'o torax';
    btLeftHand: Result := 'a mão esquerda';
    btRightHand: Result := 'a mão direita';
    btLeftArm: Result := 'o braço esquerdo';
    btRightArm: Result := 'o braço direito';
    btLeftLeg: Result := 'a perna eaquerda';
    btRightLeg: Result := 'a perna direita';
    btLeftFoot: Result := 'o pé esquerdo';
    btRightFoot: Result := 'o pé direito';
  end;
end;

end.
