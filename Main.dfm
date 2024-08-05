object MainForm: TMainForm
  Left = 0
  Top = 0
  Margins.Top = 0
  Margins.Right = 5
  Caption = 'Crowd Simulator'
  ClientHeight = 561
  ClientWidth = 834
  Color = clBlack
  Constraints.MinHeight = 600
  Constraints.MinWidth = 850
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object panelMain: TPanel
    Left = 0
    Top = 0
    Width = 690
    Height = 561
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object paintBox: TPaintBox
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 680
      Height = 400
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Color = clBlack
      ParentColor = False
      OnPaint = paintBoxPaint
    end
    object richEditLog: TRichEdit
      AlignWithMargins = True
      Left = 5
      Top = 410
      Width = 680
      Height = 146
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      TabStop = False
      Align = alBottom
      BorderStyle = bsNone
      Color = 1315860
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Zoom = 100
    end
  end
  object panelControls: TPanel
    AlignWithMargins = True
    Left = 690
    Top = 5
    Width = 139
    Height = 551
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alRight
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 691
    object Label2: TLabel
      AlignWithMargins = True
      Left = 7
      Top = 3
      Width = 73
      Height = 16
      Caption = 'Estilo do AI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object LabelTeams: TLabel
      Left = 49
      Top = 455
      Width = 42
      Height = 13
      Caption = 'Times de'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 6
      Top = 110
      Width = 19
      Height = 13
      Caption = 'STR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 6
      Top = 135
      Width = 19
      Height = 13
      Caption = 'DEX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 6
      Top = 160
      Width = 17
      Height = 13
      Caption = 'INT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnHelp: TSpeedButton
      Left = 116
      Top = 0
      Width = 23
      Height = 22
      Hint = 'Help'
      Caption = '?'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnHelpClick
    end
    object addAIMobileBtn: TButton
      AlignWithMargins = True
      Left = 6
      Top = 480
      Width = 127
      Height = 25
      Margins.Bottom = 0
      Caption = 'Adicionar AI'
      TabOrder = 4
      OnClick = addAIMobileBtnClick
    end
    object edtName: TEdit
      AlignWithMargins = True
      Left = 6
      Top = 185
      Width = 125
      Height = 24
      Margins.Bottom = 0
      TabOrder = 0
      TextHint = 'Nome da criatura'
    end
    object edtColor: TColorListBox
      AlignWithMargins = True
      Left = 6
      Top = 216
      Width = 125
      Height = 129
      Margins.Bottom = 0
      Selected = clMaroon
      Style = [cbStandardColors, cbPrettyNames]
      TabOrder = 1
    end
    object addPlayerMobileBtn: TButton
      AlignWithMargins = True
      Left = 6
      Top = 507
      Width = 48
      Height = 20
      Margins.Bottom = 0
      Caption = 'player'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = addPlayerMobileBtnClick
    end
    object edtSword: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 371
      Width = 107
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar espada'
      TabOrder = 2
      OnClick = edtSwordClick
    end
    object radioButtonPacific: TRadioButton
      AlignWithMargins = True
      Left = 6
      Top = 25
      Width = 79
      Height = 17
      Margins.Bottom = 0
      Caption = 'Pac'#237'fico'
      Checked = True
      TabOrder = 5
      TabStop = True
    end
    object radioButtonXenophobic: TRadioButton
      AlignWithMargins = True
      Left = 6
      Top = 45
      Width = 83
      Height = 17
      Margins.Bottom = 0
      Caption = 'Xenof'#243'bico'
      TabOrder = 7
    end
    object radioButtonHostile: TRadioButton
      AlignWithMargins = True
      Left = 6
      Top = 65
      Width = 83
      Height = 17
      Margins.Bottom = 0
      Caption = 'Psicopata'
      TabOrder = 6
    end
    object btnKillAll: TButton
      AlignWithMargins = True
      Left = 56
      Top = 507
      Width = 77
      Height = 20
      Margins.Bottom = 0
      Caption = 'Kill them all!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = btnKillAllClick
    end
    object edtArmor: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 411
      Width = 126
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar armaduras'
      TabOrder = 9
    end
    object spinEditTeams: TSpinEdit
      Left = 8
      Top = 452
      Width = 35
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxValue = 4
      MinValue = 1
      ParentFont = False
      TabOrder = 10
      Value = 1
      OnChange = spinEditTeamsChange
    end
    object spinEditTeamSize: TSpinEdit
      Left = 98
      Top = 452
      Width = 35
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxValue = 60
      MinValue = 1
      ParentFont = False
      TabOrder = 11
      Value = 1
      OnChange = spinEditTeamsChange
    end
    object edtDebug: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 530
      Width = 55
      Height = 17
      Margins.Bottom = 0
      Caption = 'Debug'
      TabOrder = 12
      OnClick = edtDebugClick
    end
    object edtStr: TSpinEdit
      Left = 30
      Top = 107
      Width = 45
      Height = 22
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxValue = 100
      MinValue = 20
      ParentFont = False
      TabOrder = 13
      Value = 100
    end
    object edtDex: TSpinEdit
      Left = 30
      Top = 132
      Width = 45
      Height = 22
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxValue = 100
      MinValue = 20
      ParentFont = False
      TabOrder = 14
      Value = 100
    end
    object edtInt: TSpinEdit
      Left = 30
      Top = 157
      Width = 45
      Height = 22
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxValue = 100
      MinValue = 20
      ParentFont = False
      TabOrder = 15
      Value = 100
    end
    object edtRandomStats: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 85
      Width = 121
      Height = 17
      Margins.Bottom = 0
      Caption = 'Randomizar'
      Checked = True
      State = cbChecked
      TabOrder = 16
      OnClick = edtRandomStatsClick
    end
    object edtDagger: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 351
      Width = 107
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar adaga'
      TabOrder = 17
      OnClick = edtDaggerClick
    end
    object edtBow: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 391
      Width = 126
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar arco'
      TabOrder = 18
      OnClick = edtBowClick
    end
    object edtRunning: TCheckBox
      AlignWithMargins = True
      Left = 67
      Top = 530
      Width = 64
      Height = 17
      Margins.Bottom = 0
      Caption = 'Running'
      Checked = True
      State = cbChecked
      TabOrder = 19
      OnClick = edtRunningClick
    end
  end
end
