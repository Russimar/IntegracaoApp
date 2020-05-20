object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 459
  ClientWidth = 407
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
    Width = 407
    Height = 41
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 381
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
      TabOrder = 0
      Text = 'http://200.98.170.118'
    end
    object edtPorta: TEdit
      Left = 236
      Top = 11
      Width = 57
      Height = 21
      TabOrder = 1
      Text = '3333'
    end
  end
  object pnlPrincipal: TPanel
    Left = 0
    Top = 41
    Width = 407
    Height = 418
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 381
    object gridDados: TStringGrid
      Left = 1
      Top = 42
      Width = 405
      Height = 288
      Align = alClient
      FixedCols = 0
      FixedRows = 0
      TabOrder = 0
      ExplicitWidth = 379
      RowHeights = (
        24
        24
        24
        24
        24)
    end
    object pnlBotton: TPanel
      Left = 1
      Top = 330
      Width = 405
      Height = 87
      Align = alBottom
      Color = clMoneyGreen
      ParentBackground = False
      TabOrder = 1
      ExplicitWidth = 379
      object Gauge1: TGauge
        Left = 1
        Top = 58
        Width = 403
        Height = 28
        Align = alBottom
        Progress = 0
        ExplicitTop = 75
        ExplicitWidth = 377
      end
      object btnConsultaProduto: TBitBtn
        Left = 2
        Top = 1
        Width = 101
        Height = 29
        Caption = 'Consulta Produto'
        TabOrder = 0
        OnClick = btnConsultaProdutoClick
      end
      object btnGravarProduto: TBitBtn
        Left = 2
        Top = 28
        Width = 101
        Height = 29
        Caption = 'Gravar Produto'
        TabOrder = 1
        OnClick = btnGravarProdutoClick
      end
      object btnGravarSubGrupo: TBitBtn
        Left = 200
        Top = 28
        Width = 101
        Height = 29
        Caption = 'Gravar SubGrupo'
        TabOrder = 2
        OnClick = btnGravarSubGrupoClick
      end
      object BitBtn3: TBitBtn
        Left = 200
        Top = 1
        Width = 101
        Height = 29
        Caption = 'Consulta SubGrupo'
        TabOrder = 3
        OnClick = BitBtn3Click
      end
      object btnGravarGrupo: TBitBtn
        Left = 101
        Top = 28
        Width = 101
        Height = 29
        Caption = 'Gravar Grupo'
        TabOrder = 4
        OnClick = btnGravarGrupoClick
      end
      object btnBuscarGrupo: TBitBtn
        Left = 101
        Top = 1
        Width = 101
        Height = 29
        Caption = 'Consulta Grupo'
        TabOrder = 5
        OnClick = btnBuscarGrupoClick
      end
      object btnEnviarImagem: TBitBtn
        Left = 299
        Top = 1
        Width = 101
        Height = 29
        Caption = 'Enviar Imagem'
        TabOrder = 6
        OnClick = btnEnviarImagemClick
      end
    end
    object pnlDados: TPanel
      Left = 1
      Top = 1
      Width = 405
      Height = 41
      Align = alTop
      Color = clMoneyGreen
      ParentBackground = False
      TabOrder = 2
      ExplicitWidth = 379
      object lblDocumento: TLabel
        Left = 199
        Top = 22
        Width = 58
        Height = 13
        Caption = 'Documento:'
      end
      object Label2: TLabel
        Left = 7
        Top = 22
        Width = 42
        Height = 13
        Caption = 'Produto:'
      end
      object edtProduto: TEdit
        Left = 55
        Top = 14
        Width = 78
        Height = 21
        TabOrder = 0
      end
    end
  end
end
