unit Game.Mobile.Human;

interface

uses
  Game,
  Game.Mobile;

type
  Human = class(Mobile, IObject, IMobile)
  public
    constructor Create(const where: IWorld); reintroduce; overload;
    constructor Create(const where: IWorld; const humanName: String); reintroduce; overload;
    constructor Create(const where: IWorld; const humanName: String; const humanColor: Integer); reintroduce; overload;
    function Head: BodyPart;
    function Torso: BodyPart;
    function LeftArm: BodyPart;
    function RightArm: BodyPart;
    function LeftLeg: BodyPart;
    function RightLeg: BodyPart;
    function LeftHand: BodyPart;
    function RightHand: BodyPart;
    function LeftFoot: BodyPart;
    function RightFoot: BodyPart;
  end;

implementation

{ Human }

constructor Human.Create(const where: IWorld);
begin
  inherited Create(where, [
    BodyPart.Create(Self, btHead),
    BodyPart.Create(Self, btTorso),
    BodyPart.Create(Self, btLeftArm),
    BodyPart.Create(Self, btRightArm),
    BodyPart.Create(Self, btLeftLeg),
    BodyPart.Create(Self, btRightLeg),
    BodyPart.Create(Self, btLeftHand),
    BodyPart.Create(Self, btRightHand),
    BodyPart.Create(Self, btLeftFoot),
    BodyPart.Create(Self, btRightFoot)]);

  SetName('Humano');
  SetStr(300 + Random(700) + 1);
  SetDex(300 + Random(700) + 1);
  SetInt(300 + Random(700) + 1);
end;

constructor Human.Create(const where: IWorld; const humanName: String);
begin
  Create(where);
  SetName(humanName);
end;

constructor Human.Create(const where: IWorld; const humanName: String; const humanColor: Integer);
begin
  Create(where, humanName);
  SetColor(humanColor);
end;

function Human.Head: BodyPart;
begin
  Result := GetBodyPart(btHead);
end;

function Human.Torso: BodyPart;
begin
  Result := GetBodyPart(btTorso);
end;

function Human.LeftArm: BodyPart;
begin
  Result := GetBodyPart(btLeftArm);
end;

function Human.RightArm: BodyPart;
begin
  Result := GetBodyPart(btRightArm);
end;

function Human.LeftHand: BodyPart;
begin
  Result := GetBodyPart(btLeftHand);
end;

function Human.RightHand: BodyPart;
begin
  Result := GetBodyPart(btRightHand);
end;

function Human.LeftLeg: BodyPart;
begin
  Result := GetBodyPart(btLeftLeg);
end;

function Human.RightLeg: BodyPart;
begin
  Result := GetBodyPart(btRightLeg);
end;

function Human.LeftFoot: BodyPart;
begin
  Result := GetBodyPart(btLeftFoot);
end;

function Human.RightFoot: BodyPart;
begin
  Result := GetBodyPart(btRightFoot);
end;

end.
