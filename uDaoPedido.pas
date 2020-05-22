unit uDaoPedido;

interface

uses
  uPedido, System.Generics.Collections;

type
  IDaoPedido = Interface(IInterface)
    ['{040AF347-25DD-4B4C-B9B2-475F4703EFDF}']
    function CodigoPedido(const aValue: string): IDaoPedido; overload;
    function CodigoPedido: string; overload;
    function CodigoEmpresa(const Value: string): IDaoPedido; overload;
    function CodigoEmpresa: string; overload;
    function BaseURL(const Value: string): IDaoPedido; overload;
    function BaseURL: String; overload;
    function GetPedido(aToken, aEmpresa: String): TObjectList<TPedido>;
    function PostPedido(aValue: TPedido; aToken: String): String;
  end;

  TDaoPedido = class(TInterfacedObject, IDaoPedido)
  private
    FCodigoPedido : String;
    FBaseUrl : String;
    FEmpresa : String;
  public
    class function New: IDaoPedido;
    function CodigoPedido(const aValue: string): IDaoPedido; overload;
    function CodigoPedido: string; overload;
    function CodigoEmpresa(const Value: string): IDaoPedido; overload;
    function CodigoEmpresa: string; overload;
    function BaseURL(const Value: string): IDaoPedido; overload;
    function BaseURL: String; overload;
    function GetPedido(aToken, aEmpresa: String): TObjectList<TPedido>;
    function PostPedido(aValue: TPedido; aToken: String): String;
  end;

implementation

uses
  ConfigurarRest, System.JSON, System.SysUtils, REST.Types;

{ TDaoPedido }
var
  aPedido : TPedido;

function TDaoPedido.BaseURL(const Value: string): IDaoPedido;
begin
  Result := Self;
  FBaseUrl := Value;
end;

function TDaoPedido.BaseURL: String;
begin
  Result := FBaseUrl;
end;

function TDaoPedido.CodigoEmpresa: string;
begin
  Result := FEmpresa;
end;

function TDaoPedido.CodigoEmpresa(const Value: string): IDaoPedido;
begin
  Result := Self;
  FEmpresa := Value;
end;

function TDaoPedido.CodigoPedido: string;
begin
  Result := FCodigoPedido;
end;

function TDaoPedido.CodigoPedido(const aValue: string): IDaoPedido;
begin
  Result := Self;
  FCodigoPedido := aValue;
end;

function TDaoPedido.GetPedido(aToken, aEmpresa: String): TObjectList<TPedido>;
var
  FConfigurarRest : TConfiguraRest;
  ja : TJSONArray;
  Pedido: TJsonObject;
  ListaPedido : TObjectList<TPedido>;
  i: Integer;
begin
  FConfigurarRest := TConfiguraRest.create;
  if FEmpresa <> EmptyStr then
    FConfigurarRest.BaseURL := BaseURL + '/A';
  with FConfigurarRest do
  begin
    ConfigurarRest(rmGET);
    CreateParam(RESTRequest, 'token', aToken, pkGETorPOST);
    RESTRequest.Execute;
    ja := TJsonObject.ParseJSONValue(RESTResponse.JSONText) as TJSONArray;
  end;
  Pedido := TJSONObject.Create;
  ListaPedido := TObjectList<TPedido>.Create;
  for i := 0 to Pred(ja.Count) do
  begin
    Pedido := ja.Get(i) as TJSONObject;
    aPedido := TPedido.Create;
    aPedido.clienteNome := Pedido.GetValue('clienteNome').Value;
    aPedido.clienteCpf := Pedido.GetValue('clienteCpf').Value;
    aPedido.clienteCidade := Pedido.GetValue('clienteCidade').Value;
    aPedido.clienteBairro := Pedido.GetValue('clienteBairro').Value;
    aPedido.clienteEndereco := Pedido.GetValue('clienteEndereco').Value;
    aPedido.clienteNumero := Pedido.GetValue('clienteNumero').Value;
    aPedido.clienteUf := Pedido.GetValue('clienteUf').Value;
    aPedido.nomeEmpresa := Pedido.GetValue('nomeEmpresa').Value;
    aPedido.tipoEntrega := Pedido.GetValue('tipoEntrega').Value;
    aPedido.dataEntrega := Pedido.GetValue('dataEntrega').Value;
    aPedido.valor :=  StrToFloat(Pedido.GetValue('valor').Value);
    aPedido.qtdeItens := StrToFloat(Pedido.GetValue('qtdeItens').Value);
    aPedido.dataEmissao := StrToDateTime(Pedido.GetValue('dataEmissao').Value);
    aPedido.observacoes := Pedido.GetValue('observacoes').Value;
    aPedido.codigoEmpresa := StrToInt(Pedido.GetValue('codigoEmpresa').Value);
    aPedido.codigoPedido := StrToInt(Pedido.GetValue('codigoPedido').Value);
    ListaPedido.Add(aPedido);
  end;
  Result := ListaPedido;
  ja.Free;

end;

class function TDaoPedido.New: IDaoPedido;
begin
  aPedido := TPedido.create;
  Result := Self.Create;
end;

function TDaoPedido.PostPedido(aValue: TPedido; aToken: String): String;
begin

end;

end.
