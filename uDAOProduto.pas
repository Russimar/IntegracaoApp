unit uDAOProduto;

interface

uses
  REST.Client,
  uProduto,
  REST.Json,
  IdHTTP,
  System.Generics.Collections;

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

  TDaoProduto = class(TInterfacedObject, IConsultaProduto)
  strict private
  private
    FCodigoProduto: String;
    FBaseURL: String;
    FEmpresa: String;
    FCaminhoImagem: String;
  public
    class function New: IConsultaProduto;
    function CodigoProduto(const aValue: String): IConsultaProduto; overload;
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

implementation

uses
  System.JSON,
  REST.Types,
  System.SysUtils,
  Vcl.Dialogs,
  ConfigurarRest,
  IdMultipartFormData;

{ TDaoProduto }
var
  aProduto: TProduto;

function TDaoProduto.BaseURL: String;
begin
  Result := FBaseURL;
end;

function TDaoProduto.BaseURL(const Value: string): IConsultaProduto;
begin
  Result := Self;
  FBaseURL := Value;
end;

function TDaoProduto.CaminhoArquivo: string;
begin
  Result := FCaminhoImagem;
end;

function TDaoProduto.CaminhoArquivo(const aValue: string): IConsultaProduto;
begin
  Result := Self;
  FCaminhoImagem := aValue;
end;

function TDaoProduto.CodigoEmpresa: string;
begin
  Result := FEmpresa;
end;

function TDaoProduto.CodigoEmpresa(const Value: string): IConsultaProduto;
begin
  Result := Self;
  FEmpresa := Value;
end;

function TDaoProduto.CodigoProduto: string;
begin
  Result := FCodigoProduto;
end;

function TDaoProduto.GetProduto(aToken, aEmpresa: String): TObjectList<TProduto>;
var
  FConfigurarRest : TConfiguraRest;
  ja : TJSONArray;
  Produto: TJsonObject;
  ListaProduto : TObjectList<TProduto>;
  I: Integer;
begin
  FConfigurarRest := TConfiguraRest.create;
  if FEmpresa <> EmptyStr then
    FConfigurarRest.BaseURL := BaseURL + '/' + FEmpresa;
  FConfigurarRest.BaseURL := BaseURL + '/' + FCodigoProduto;
  with FConfigurarRest do
  begin
    ConfigurarRest(rmGET);
    CreateParam(RESTRequest, 'token', aToken, pkGETorPOST);
    RESTRequest.Execute;
    ja := TJsonObject.ParseJSONValue(RESTResponse.JSONText) as TJSONArray;
  end;
  Produto := TJSONObject.Create;
  ListaProduto := TObjectList<TProduto>.Create;
  for I := 0 to Pred(ja.Count) do
  begin
    Produto := ja.Get(i) as TJSONObject;
    aProduto := TProduto.Create;
    aProduto.codigoProduto := StrToInt(Produto.GetValue('codigoProduto').Value);
    aProduto.descricao := Produto.GetValue('descricao').Value;
    aProduto.preco := StrToFloat(Produto.GetValue('preco').Value);
    aProduto.marca := Produto.GetValue('marca').Value;
    aProduto.grupo := StrToInt(Produto.GetValue('grupo').Value);
    aProduto.Unidade := Produto.GetValue('unidade').Value;
    aProduto.SubGrupo := Produto.GetValue('subGrupo').Value;
    ListaProduto.Add(aProduto);
  end;
  Result := ListaProduto;
  ja.Free;
end;

function TDaoProduto.CodigoProduto(const aValue: String): IConsultaProduto;
begin
  Result := Self;
  FCodigoProduto := aValue;
end;

class function TDaoProduto.New: IConsultaProduto;
begin
  aProduto := TProduto.Create;
  Result := Self.Create;
end;

function TDaoProduto.PostProduto(aValue : TProduto; aToken : String): String;
var
  Produto: TJsonObject;
  FConfiguraRest : TConfiguraRest;
begin
  FConfiguraRest := TConfiguraRest.create;
  FConfiguraRest.BaseURL := BaseURL + '?token=' + aToken;
  with FConfiguraRest do
  begin
    ConfigurarRest(rmPOST);
    Produto := TJson.ObjectToJsonObject(aValue);
    CreateParam(RESTRequest, 'body', Produto.ToString, pkGETorPOST);
    RESTRequest.Execute;
    result := RESTResponse.JSONText;
  end;
end;

function TDaoProduto.PostProdutoImagem(aToken: String): String;
var
  Indy: TIdHTTP;
  Params: TIdMultiPartFormDataStream;
  Response: string;
begin
  Indy := TIdHTTP.Create;
  Params :=  TIdMultiPartFormDataStream.Create;
  try
    try
      Params.AddFile('file',FCaminhoImagem);
      Response := Indy.Post(BaseURL + '?token=' + aToken , Params);
    except
      on E:Exception do
        raise exception.Create(E.Classname + ': ' + E.Message);
    end;
  finally
    Params.Free;
    Indy.Free;
  end;
end;

end.
