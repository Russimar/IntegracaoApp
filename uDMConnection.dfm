object DMConnection: TDMConnection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 237
  Width = 291
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=WIN1252'
      'Database=D:\Easy2Solutions\Gestao\Dados\Spader2.FDB'
      'DriverID=FB')
    LoginPrompt = False
    Left = 32
    Top = 32
  end
  object sqlConsulta: TFDQuery
    Connection = FDConnection
    Left = 136
    Top = 32
  end
  object FDImagem: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=WIN1252'
      'Database=D:\Easy2Solutions\Gestao\Dados\IMAGEM.FDB'
      'DriverID=FB')
    LoginPrompt = False
    Left = 32
    Top = 112
  end
  object sqlConsultaImagem: TFDQuery
    Connection = FDImagem
    Left = 136
    Top = 112
  end
  object StoredProc: TFDStoredProc
    Connection = FDConnection
    Left = 32
    Top = 176
  end
end
