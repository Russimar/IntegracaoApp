unit uDAOPedidoNumerario;

interface

uses
  uPedidoNumerario, System.Generics.Collections;

type
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

  TDAOPedidoNumerario = class(TInterfacedObject, IDAOPedidoNumerario)
    strict private
      FBaseUrl : String;
      FCodigoPedido : String;
      FCodigoEmpresa : String;
    public
      class function New : IDAOPedidoNumerario;
      function BaseUrl(const aValue : String) : IDAOPedidoNumerario; overload;
      function BaseUrl : String; overload;
      function CodigoPedido(const aValue : String) : IDAOPedidoNumerario; overload;
      function CodigoPedido : String; overload;
      function CodigoEmpresa(const aValue : String) : IDAOPedidoNumerario; overload;
      function CodigoEmpresa : String; overload;
      function GetPedidoNumerario(aToken: String): TObjectList<TPedidoNumerario>;
  end;

implementation

uses
  ConfigurarRest, System.JSON, REST.Types, System.SysUtils;

{ TDAOPedidoNumerario }
var
  aPedidoNumerario : TPedidoNumerario;

function TDAOPedidoNumerario.BaseUrl(const aValue: String): IDAOPedidoNumerario;
begin
  Result := Self;
  FBaseUrl := aValue;
end;

function TDAOPedidoNumerario.BaseUrl: String;
begin
  Result := FBaseUrl;
end;

function TDAOPedidoNumerario.CodigoEmpresa: String;
begin
  Result := FCodigoEmpresa;
end;

function TDAOPedidoNumerario.CodigoEmpresa(
  const aValue: String): IDAOPedidoNumerario;
begin
  Result := Self;
  FCodigoEmpresa := aValue;
end;

function TDAOPedidoNumerario.CodigoPedido: String;
begin
  Result := FCodigoPedido;
end;

function TDAOPedidoNumerario.CodigoPedido(
  const aValue: String): IDAOPedidoNumerario;
begin
  Result := Self;
  FCodigoPedido := aValue
end;

function TDAOPedidoNumerario.GetPedidoNumerario(
  aToken: String): TObjectList<TPedidoNumerario>;
var
  FConfigurarRest : TConfiguraRest;
  ja : TJSONArray;
  PedidoNumerario: TJsonObject;
  ListaPedidoNumerario : TObjectList<TPedidoNumerario>;
  i: Integer;
begin
  FConfigurarRest := TConfiguraRest.create;
  try
    FConfigurarRest.BaseURL := BaseURL + '/pedidoNumerario/' + CodigoEmpresa + '/' + CodigoPedido;
    with FConfigurarRest do
    begin
      ConfigurarRest(rmGET);
      CreateParam(RESTRequest, 'token', aToken, pkGETorPOST);
      RESTRequest.Execute;
      ja := TJsonObject.ParseJSONValue(RESTResponse.JSONText) as TJSONArray;
    end;
    PedidoNumerario := TJSONObject.Create;
    ListaPedidoNumerario := TObjectList<TPedidoNumerario>.Create;
    for i := 0 to Pred(ja.Count) do
    begin
      PedidoNumerario := ja.Get(i) as TJSONObject;
      aPedidoNumerario := TPedidoNumerario.Create;
      aPedidoNumerario.codigoPedido := StrToInt(PedidoNumerario.GetValue('codigoPedido').Value);
      aPedidoNumerario.codigoNumerario := StrToInt(PedidoNumerario.GetValue('codigoNumerario').Value);
      aPedidoNumerario.item := StrToInt(PedidoNumerario.GetValue('item').Value);
      ListaPedidoNumerario.Add(aPedidoNumerario);
    end;
    Result := ListaPedidoNumerario;
    ja.Free;
  finally
    FConfigurarRest.Free;
  end;
end;

class function TDAOPedidoNumerario.New: IDAOPedidoNumerario;
begin
  aPedidoNumerario := TPedidoNumerario.Create;
  Result := Self.Create;
end;

end.
