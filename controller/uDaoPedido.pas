unit uDaoPedido;

interface

uses
  uPedido, System.Generics.Collections, App.Interfaces;

type

  TDaoPedido = class(TInterfacedObject, IDaoPedido)
  private
    FCodigoPedido : String;
    FBaseUrl : String;
    FEmpresa : String;
    FCodPedidoRetorno : String;
    FStatus : String;
  public
    class function New: IDaoPedido;
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

function TDaoPedido.CodPedidoRetorno: string;
begin
  Result := FCodPedidoRetorno;
end;

function TDaoPedido.CodPedidoRetorno(const aValue: string): IDaoPedido;
begin
  Result := Self;
  FCodPedidoRetorno := aValue;
end;

function TDaoPedido.CodigoPedido(const aValue: string): IDaoPedido;
begin
  Result := Self;
  FCodigoPedido := aValue;
end;

function TDaoPedido.GetPedido(aToken: String): TObjectList<TPedido>;
var
  FConfigurarRest : TConfiguraRest;
  ja : TJSONArray;
  Pedido: TJsonObject;
  ListaPedido : TObjectList<TPedido>;
  i: Integer;
begin
  FConfigurarRest := TConfiguraRest.create;
  try
    FConfigurarRest.BaseURL := BaseURL + '/pedido/A';
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
      aPedido.clienteTelefone := Pedido.GetValue('clienteTelefone').Value;
      aPedido.clienteCep := Pedido.GetValue('clienteCep').Value;
      aPedido.clienteUf := Pedido.GetValue('clienteUf').Value;
      aPedido.nomeEmpresa := Pedido.GetValue('nomeEmpresa').Value;
      aPedido.tipoEntrega := Pedido.GetValue('tipoEntrega').Value;
      aPedido.valor :=  StrToFloat(Pedido.GetValue('valor').Value);
      aPedido.qtdeItens := StrToFloat(Pedido.GetValue('qtdeItens').Value);
      aPedido.dataEmissao := StrToDateTime(Pedido.GetValue('dataEmissao').Value);
      aPedido.dataEntrega := StrToDateTimeDef(Pedido.GetValue('dataEntrega').Value,aPedido.dataEmissao);
      aPedido.observacoes := Pedido.GetValue('observacoes').Value;
      aPedido.codigoEmpresa := StrToInt(Pedido.GetValue('codigoEmpresa').Value);
      aPedido.codigoPedido := StrToInt(Pedido.GetValue('codigoPedido').Value);
      aPedido.valorfrete := StrToFloat(Pedido.GetValue('valorFrete').Value);
      aPedido.valorPagar := StrToFloat(Pedido.GetValue('valorPagar').Value);
      ListaPedido.Add(aPedido);
    end;
    Result := ListaPedido;
    ja.Free;
  finally
    FConfigurarRest.Free;
  end;

end;

class function TDaoPedido.New: IDaoPedido;
begin
  aPedido := TPedido.create;
  Result := Self.Create;
end;

function TDaoPedido.PostPedido(aValue: TPedido; aToken: String): String;
begin

end;

function TDaoPedido.PutPedido(aToken: String): String;
var
  FConfigurarRest : TConfiguraRest;
begin
  FConfigurarRest := TConfiguraRest.create;
  try
    FConfigurarRest.BaseURL := BaseURL + '/pedidoCodigo/' + CodigoPedido + '/' + CodPedidoRetorno + '/' + Status ;
    with FConfigurarRest do
    begin
      ConfigurarRest(rmPUT);
      CreateParam(RESTRequest, 'token', aToken, pkQUERY);
      RESTRequest.Execute;
    end;
  finally
    FConfigurarRest.Free;
  end;

end;

function TDaoPedido.Status: string;
begin
  Result := FStatus;
end;

function TDaoPedido.Status(const aValue: string): IDaoPedido;
begin
  Result := Self;
  FStatus := aValue;
end;

end.
