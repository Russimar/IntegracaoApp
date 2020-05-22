unit uDaoPedidoItens;

interface

uses
  uPedidoItens, System.Generics.Collections;

type
  IDaoPedidoItens = Interface(IInterface)
  ['{BFF38762-CFEF-48A5-BF38-50B86D5E43CF}']
    function CodigoPedido(const aValue: string): IDaoPedidoItens; overload;
    function CodigoPedido: string; overload;
    function BaseURL(const Value: string): IDaoPedidoItens; overload;
    function BaseURL: String; overload;
    function GetPedidoItens(aToken, aEmpresa: String): TObjectList<TPedidoItens>;
    function PostPedido(aValue: TPedidoItens; aToken: String): String;
  end;

  TDaoPedidoItens = class(TInterfacedObject, IDaoPedidoItens)
    private
      FCodigoPedido : String;
      FBaseURL : String;
    public
      class function New : IDaoPedidoItens;
      function CodigoPedido(const aValue: string): IDaoPedidoItens; overload;
      function CodigoPedido: string; overload;
      function BaseURL(const Value: string): IDaoPedidoItens; overload;
      function BaseURL: String; overload;
      function GetPedidoItens(aToken, aEmpresa: String): TObjectList<TPedidoItens>;
      function PostPedido(aValue: TPedidoItens; aToken: String): String;
  end;

implementation

uses
  ConfigurarRest, System.JSON, REST.Types, System.SysUtils;

{ TDaoPedidoItens }

var
  aPedidoItens : TPedidoItens;

function TDaoPedidoItens.BaseURL(const Value: string): IDaoPedidoItens;
begin
  Result := Self;
  FBaseURL := Value;
end;

function TDaoPedidoItens.BaseURL: String;
begin
  Result := FBaseURL;
end;

function TDaoPedidoItens.CodigoPedido(const aValue: string): IDaoPedidoItens;
begin
  Result := Self;
  FCodigoPedido := aValue;
end;

function TDaoPedidoItens.CodigoPedido: string;
begin
  Result := FCodigoPedido;
end;

function TDaoPedidoItens.GetPedidoItens(aToken,
  aEmpresa: String): TObjectList<TPedidoItens>;
var
  FConfigurarRest : TConfiguraRest;
  ja : TJSONArray;
  PedidoItens: TJsonObject;
  ListaPedidoItens : TObjectList<TPedidoItens>;
  i: Integer;
begin
  FConfigurarRest := TConfiguraRest.create;
  FConfigurarRest.BaseURL := BaseURL + '/' + aEmpresa + '/' + FCodigoPedido;
  with FConfigurarRest do
  begin
    ConfigurarRest(rmGET);
    CreateParam(RESTRequest, 'token', aToken, pkGETorPOST);
    RESTRequest.Execute;
    ja := TJsonObject.ParseJSONValue(RESTResponse.JSONText) as TJSONArray;
  end;
  PedidoItens := TJSONObject.Create;
  ListaPedidoItens := TObjectList<TPedidoItens>.Create;
  for i := 0 to Pred(ja.Count) do
  begin
    PedidoItens := ja.Get(i) as TJSONObject;
    aPedidoItens := TPedidoItens.Create;
    aPedidoItens.empresa := StrToInt(PedidoItens.GetValue('empresa').Value);
    aPedidoItens.pedido := StrToInt(PedidoItens.GetValue('pedido').Value);
    aPedidoItens.item := StrToInt(PedidoItens.GetValue('item').Value);
    aPedidoItens.codigoProduto :=  StrToIntDef(PedidoItens.GetValue('codigoProduto').Value,0);
    aPedidoItens.descProd := PedidoItens.GetValue('descProd').Value;
    aPedidoItens.quantidade :=  StrToFloat(PedidoItens.GetValue('quantidade').Value);
    aPedidoItens.valorUnidade := StrToFloat(PedidoItens.GetValue('valorUnidade').Value);
    aPedidoItens.unidade := PedidoItens.GetValue('unidade').Value;
    ListaPedidoItens.Add(aPedidoItens);
  end;
  Result := ListaPedidoItens;
  ja.Free;
end;

class function TDaoPedidoItens.New: IDaoPedidoItens;
begin
  aPedidoItens := TPedidoItens.create;
  Result := Self.Create;
end;

function TDaoPedidoItens.PostPedido(aValue: TPedidoItens;
  aToken: String): String;
begin

end;

end.
