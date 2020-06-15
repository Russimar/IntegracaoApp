object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 172
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 41
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblHost: TLabel
      Left = 20
      Top = 21
      Width = 30
      Height = 13
      Caption = 'HOST'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 200
      Top = 21
      Width = 31
      Height = 13
      Caption = 'Porta'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtHost: TEdit
      Left = 56
      Top = 11
      Width = 126
      Height = 21
      TabStop = False
      Color = clBtnShadow
      ReadOnly = True
      TabOrder = 0
    end
    object edtPorta: TEdit
      Left = 236
      Top = 11
      Width = 57
      Height = 21
      TabStop = False
      Color = clBtnShadow
      ReadOnly = True
      TabOrder = 1
    end
  end
  object pnlPrincipal: TPanel
    Left = 0
    Top = 41
    Width = 329
    Height = 131
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 252
    object pnlBotton: TPanel
      Left = 1
      Top = 43
      Width = 327
      Height = 87
      Align = alBottom
      Color = clMoneyGreen
      ParentBackground = False
      TabOrder = 0
      ExplicitTop = 164
      object Gauge1: TGauge
        Left = 1
        Top = 58
        Width = 325
        Height = 28
        Align = alBottom
        Progress = 0
        ExplicitTop = 75
        ExplicitWidth = 377
      end
      object lblMensagem: TLabel
        Left = 19
        Top = 24
        Width = 148
        Height = 16
        Caption = 'Aguardando novo ciclo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlDados: TPanel
      Left = 1
      Top = 1
      Width = 327
      Height = 41
      Align = alTop
      Color = clMoneyGreen
      ParentBackground = False
      TabOrder = 1
      object lblDocumento: TLabel
        Left = 19
        Top = 22
        Width = 58
        Height = 13
        Caption = 'Documento:'
      end
      object lblCodigo: TLabel
        Left = 19
        Top = 5
        Width = 37
        Height = 13
        Caption = 'Codigo:'
      end
    end
  end
  object Timer1: TTimer
    Interval = 30000
    OnTimer = Timer1Timer
    Left = 281
    Top = 50
  end
end
