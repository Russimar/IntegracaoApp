unit App.Interfaces;

interface

uses
  uProduto, uGrupo, uNumerario, uPedido, System.Generics.Collections,
  uPedidoItens, uPedidoNumerario, uSubGrupo;

type
  IConsultaProduto = Interface(IInterface)
    ['{9B94BFDF-A382-4A16-8040-C775C0713F60}']
    function CodigoProduto(const Value: string): IConsultaProduto; overload;
    function CodigoProduto: string; overload;
    function CodigoEmpresa(const Value: string): IConsultaProduto; overload;
    function CodigoEmpresa: string; overload;
    function CaminhoArquivo(const aValue: string): IConsultaProduto; overload;
    function CaminhoArquivo: string; overload;
    function BaseURL(const Value: string): IConsultaProduto; overload;
    function BaseURL: String; overload;
    function GetProduto(aToken, aEmpresa: String): TObjectList<TProduto>;
    function PostProduto(aValue : TProduto; aToken : String) : String;
    function PostProdutoImagem(aToken : String) : String;
  end;

  IDAOGrupo = Interface(IInterface)
    ['{BC07F7D9-9DB2-4780-A5C4-4D37B06CCB85}']
    function CodigoGrupo(const Value: string): IDAOGrupo; overload;
    function CodigoGrupo: string; overload;
    function CodigoEmpresa(const Value: string): IDAOGrupo; overload;
    function CodigoEmpresa: string; overload;
    function BaseURL(const Value: string): IDAOGrupo; overload;
    function BaseURL: String; overload;
    function GetGrupo(aToken, aEmpresa: String): TObjectList<TGrupo>;
    function PostGrupo(aValue : TGrupo; aToken : String) : String;
  end;

  IDAONumerario = Interface(IInterface)
    ['{D5B60924-57F9-42BB-8D33-C5331F03FAC7}']
    function BaseUrl(const aValue : String) : IDAONumerario; overload;
    function BaseUrl : String; overload;
    function CodigoNumerario(const aValue : String) : IDAONumerario; overload;
    function CodigoNumerario : String; overload;
    function PostNumerario(aToken : String; aValue : TNumerario) : string;
  end;

  IDaoPedido = Interface(IInterface)
    ['{040AF347-25DD-4B4C-B9B2-475F4703EFDF}']
    function CodigoPedido(const aValue: string): IDaoPedido; overload;
    function CodigoPedido: string; overload;
    function CodPedidoRetorno(const aValue: string): IDaoPedido; overload;
    function CodPedidoRetorno: string; overload;
    function Status(const aValue: string): IDaoPedido; overload;
    function Status: string; overload;
    function CodigoEmpresa(const Value: string): IDaoPedido; overload;
    function CodigoEmpresa: string; overload;
    function BaseURL(const Value: string): IDaoPedido; overload;
    function BaseURL: String; overload;
    function GetPedido(aToken: String): TObjectList<TPedido>;
    function PostPedido(aValue: TPedido; aToken: String): String;
    function PutPedido(aToken: String): String;
  end;

  IDaoPedidoItens = Interface(IInterface)
  ['{BFF38762-CFEF-48A5-BF38-50B86D5E43CF}']
    function CodigoPedido(const aValue: string): IDaoPedidoItens; overload;
    function CodigoPedido: string; overload;
    function CodigoEmpresa(const aValue: string): IDaoPedidoItens; overload;
    function CodigoEmpresa: string; overload;
    function BaseURL(const Value: string): IDaoPedidoItens; overload;
    function BaseURL: String; overload;
    function GetPedidoItens(aToken: String): TObjectList<TPedidoItens>;
    function PostPedido(aValue: TPedidoItens; aToken: String): String;
  end;

  IDAOPedidoNumerario = Interface(IInterface)
    ['{05A521A6-DF30-4681-B3BD-62A0C05D2FC4}']
    function BaseUrl(const aValue : String) : IDAOPedidoNumerario; overload;
    function BaseUrl : String; overload;
    function CodigoPedido(const aValue : String) : IDAOPedidoNumerario; overload;
    function CodigoPedido : String; overload;
    function CodigoEmpresa(const aValue : String) : IDAOPedidoNumerario; overload;
    function CodigoEmpresa : String; overload;
    function GetPedidoNumerario(aToken: String): TObjectList<TPedidoNumerario>;
  end;

  IDAOSubGrupo = interface(IInterface)
    ['{F177E7C9-FC1C-4BBE-919F-72C6594F9421}']
    function CodigoSubGrupo(const Value: string): IDAOSubGrupo; overload;
    function CodigoSubGrupo: string; overload;
    function CodigoEmpresa(const Value: string): IDAOSubGrupo; overload;
    function CodigoEmpresa: string; overload;
    function Status(const Value: string): IDAOSubGrupo; overload;
    function Status: string; overload;
    function BaseURL(const Value: string): IDAOSubGrupo; overload;
    function BaseURL: String; overload;
    function GetSubGrupo(aToken, aEmpresa: String): TObjectList<TSubGrupo>;
    function PostSubGrupo(aValue : TSubGrupo; aToken : String) : String;
  end;

  IEmpresa = Interface(IInterface)
    ['{9125F2EE-8FD9-4DDD-AE60-C0527A01D4E9}']
    function BaseURL(Const aValue : String) : IEmpresa; overload;
    function BaseURL : String; overload;
    function Documento(Const aValue : String) : IEmpresa; overload;
    function Documento : String; overload;
    function GetCodigo(aToken: String) : String;
  end;

  IToken = Interface(IInterface)
    ['{FF229F15-D991-42D8-8792-A30F00AE873A}']
    function BaseURL(const Value: string): IToken; overload;
    function BaseURL: String; overload;
    function Documento(const Value: string): IToken; overload;
    function Documento: String; overload;
    function GerarToken: String;
  end;

implementation

end.
