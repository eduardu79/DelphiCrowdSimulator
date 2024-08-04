object MainForm: TMainForm
  Left = 0
  Top = 0
  Margins.Top = 0
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
    Width = 685
    Height = 561
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 635
    object paintBox: TPaintBox
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 675
      Height = 399
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Color = clBlack
      ParentColor = False
      OnPaint = paintBoxPaint
      ExplicitWidth = 225
    end
    object richEditLog: TRichEdit
      AlignWithMargins = True
      Left = 3
      Top = 412
      Width = 679
      Height = 146
      TabStop = False
      Align = alBottom
      BorderStyle = bsNone
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Zoom = 100
      ExplicitWidth = 629
    end
  end
  object panelControls: TPanel
    AlignWithMargins = True
    Left = 690
    Top = 5
    Width = 139
    Height = 551
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alRight
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 640
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
      Top = 474
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
      Left = 7
      Top = 202
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
      Left = 7
      Top = 227
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
      Left = 7
      Top = 252
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
    object addAIMobileBtn: TButton
      AlignWithMargins = True
      Left = 6
      Top = 499
      Width = 127
      Height = 25
      Margins.Bottom = 0
      Caption = 'Adicionar AI'
      TabOrder = 4
      OnClick = addAIMobileBtnClick
    end
    object edtName: TEdit
      AlignWithMargins = True
      Left = 8
      Top = 281
      Width = 125
      Height = 24
      Margins.Bottom = 0
      TabOrder = 0
      TextHint = 'Nome da criatura'
    end
    object edtColor: TColorListBox
      AlignWithMargins = True
      Left = 8
      Top = 334
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
      Top = 526
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
      Top = 109
      Width = 107
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar espada'
      TabOrder = 2
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
      Top = 526
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
      Top = 149
      Width = 126
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar armaduras'
      TabOrder = 9
    end
    object spinEditTeams: TSpinEdit
      Left = 8
      Top = 471
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
      Top = 471
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
      Left = 8
      Top = 310
      Width = 125
      Height = 17
      Margins.Bottom = 0
      Caption = 'Debug'
      TabOrder = 12
      OnClick = edtDebugClick
    end
    object edtStr: TSpinEdit
      Left = 30
      Top = 199
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
      Top = 224
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
      Top = 249
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
      Top = 177
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
      Top = 89
      Width = 107
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar adaga'
      TabOrder = 17
    end
    object edtBow: TCheckBox
      AlignWithMargins = True
      Left = 6
      Top = 129
      Width = 126
      Height = 17
      Margins.Bottom = 0
      Caption = 'Equipar arco'
      TabOrder = 18
    end
  end
end
