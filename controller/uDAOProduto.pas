unit uDAOProduto;

interface

uses
  REST.Client,
  uProduto,
  REST.Json,
  IdHTTP,
  App.Interfaces, ConfigurarRest, System.Generics.Collections;

type

  TDaoProduto = class(TInterfacedObject, IConsultaProduto)
  strict private
  protected
    FCodigoProduto: String;
    FBaseURL: String;
    FEmpresa: String;
    FCaminhoImagem: String;
    FConfigurarRest: TConfiguraRest;
    FProduto: TProduto;
    ListaProduto: TObjectList<TProduto>;
  public
    class function New: IConsultaProduto;
    Constructor create;
    Destructor Destroy; override;
    function CodigoProduto(const aValue: String): IConsultaProduto; overload;
    function CodigoProduto: string; overload;
    function CodigoEmpresa(const Value: string): IConsultaProduto; overload;
    function CodigoEmpresa: string; overload;
    function CaminhoArquivo(const aValue: string): IConsultaProduto; overload;
    function CaminhoArquivo: string; overload;
    function BaseURL(const Value: string): IConsultaProduto; overload;
    function BaseURL: String; overload;
    function GetProduto(aToken, aEmpresa: String): TObjectList<TProduto>;
    function PostProduto(aValue: TProduto; aToken: String): String;
    function PostProdutoImagem(aToken: String): String;
  end;

implementation

uses
  System.Json,
  REST.Types,
  System.SysUtils,
  Vcl.Dialogs,
  IdMultipartFormData;

{ TDaoProduto }

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

constructor TDaoProduto.create;
begin
  FConfigurarRest := TConfiguraRest.create;
  ListaProduto := TObjectList<TProduto>.create;
end;

destructor TDaoProduto.Destroy;
begin
  FreeAndNil(FConfigurarRest);
  FreeAndNil(ListaProduto);
  inherited;
end;

function TDaoProduto.GetProduto(aToken, aEmpresa: String)
  : TObjectList<TProduto>;
var
  ja: TJSONArray;
  Produto: TJsonObject;
  i: Integer;
begin
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
  Produto := TJsonObject.create;
  try
    for i := 0 to Pred(ja.Count) do
    begin
      Produto := ja.Get(i) as TJsonObject;
      FProduto := TProduto.create;
      try
        FProduto.CodigoProduto := StrToInt(Produto.GetValue('codigoProduto').Value);
        FProduto.descricao := Produto.GetValue('descricao').Value;
        FProduto.preco := StrToFloat(Produto.GetValue('preco').Value);
        FProduto.marca := Produto.GetValue('marca').Value;
        FProduto.grupo := StrToInt(Produto.GetValue('grupo').Value);
        FProduto.Unidade := Produto.GetValue('unidade').Value;
        FProduto.SubGrupo := Produto.GetValue('subGrupo').Value;
        FProduto.status := Produto.GetValue('status').Value;
        ListaProduto.Add(FProduto);
      finally
        FreeAndNil(FProduto);
      end;
    end;
    Result := ListaProduto;
  finally
    FreeAndNil(ja);
  end;

end;

function TDaoProduto.CodigoProduto(const aValue: String): IConsultaProduto;
begin
  Result := Self;
  FCodigoProduto := aValue;
end;

class function TDaoProduto.New: IConsultaProduto;
begin
  Result := Self.create;
end;

function TDaoProduto.PostProduto(aValue: TProduto; aToken: String): String;
var
  Produto: TJsonObject;
begin
  try
    FConfigurarRest.BaseURL := BaseURL; // + '?token=' + aToken;
    with FConfigurarRest do
    begin
      ConfigurarRest(rmPOST);
      CreateParam(RESTRequest, 'token', aToken, pkQUERY);
      Produto := TJson.ObjectToJsonObject(aValue);
      CreateParam(RESTRequest, 'body', Produto.ToString, pkGETorPOST);
      RESTRequest.Execute;
      Result := RESTResponse.JSONText;
    end;
  finally
    Produto.Free;
  end;
end;

function TDaoProduto.PostProdutoImagem(aToken: String): String;
var
  Indy: TIdHTTP;
  Params: TIdMultiPartFormDataStream;
  Response: string;
begin
  Indy := TIdHTTP.create;
  Params := TIdMultiPartFormDataStream.create;
  try
    try
      Params.AddFile('file', FCaminhoImagem);
      Response := Indy.Post(BaseURL + '?token=' + aToken, Params);
    except
      on E: Exception do
        raise Exception.create(E.Classname + ': ' + E.Message);
    end;
  finally
    Params.Free;
    Indy.Free;
  end;
end;

end.
