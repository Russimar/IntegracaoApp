object DMConnection: TDMConnection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 211
  Width = 304
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=WIN1252'
      'Database=D:\Easy2Solutions\Gestao\Dados\Spader.FDB'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 32
    Top = 32
  end
  object qryProdutos: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      
        'select P.PRODICOD, P.PRODA60DESCR, P.PRODA30ADESCRREDUZ, P.GRUPI' +
        'COD, P.SUBGICOD, M.MARCA60DESCR, U.UNIDA5DESCR, P.PRODN3VLRVENDA'
      'from PRODUTO P'
      'left join MARCA M on P.MARCICOD = M.MARCICOD'
      'left join UNIDADE U on P.UNIDICOD = U.UNIDICOD'
      'where P.GRUPICOD > 0 and'
      '      P.SUBGICOD > 0  and '
      '      p.prodicod > 30069')
    Left = 192
    Top = 32
  end
  object qryGrupo: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select GRUPICOD, GRUPA60DESCR, '#39'A'#39' STATUS'
      'from GRUPO  ')
    Left = 240
    Top = 32
  end
  object qrySubGrupo: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select GRUPICOD, SUBGICOD, SUBGA60DESCR, '#39'A'#39' STATUS'
      'from SUBGRUPO  ')
    Left = 192
    Top = 104
  end
end
