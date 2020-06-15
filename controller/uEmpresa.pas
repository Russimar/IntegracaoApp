unit uEmpresa;

interface

uses
  REST.Client,
  ConfigurarRest, App.Interfaces;

type
  TEmpresa = class(TInterfacedObject, IEmpresa)
    strict private
      FBaseUrl : String;
      FDocumento : String;
    public
      class function New : IEmpresa;
      function BaseURL(Const aValue : String) : IEmpresa; overload;
      function BaseURL : String; overload;
      function Documento(Const aValue : String) : IEmpresa; overload;
      function Documento : String; overload;
      function GetCodigo(aToken: String) : String;
  end;


implementation

uses
  System.JSON, REST.Types;

{ TEmpresa }

function TEmpresa.BaseURL(const aValue: String): IEmpresa;
begin
  Result := Self;
  FBaseUrl := aValue;
end;

function TEmpresa.BaseURL: String;
begin
  Result := FBaseUrl;
end;

function TEmpresa.Documento(const aValue: String): IEmpresa;
begin
  Result := Self;
  FDocumento := aValue;
end;

function TEmpresa.Documento: String;
begin
  Result := FDocumento;
end;

function TEmpresa.GetCodigo(aToken: String) : String;
var
  FBaseUrl: String;
  Empresa: TJsonObject;
  FConfiguraRest : TConfiguraRest;
  ja : TJSONArray;
  i : integer;
begin
  FConfiguraRest := TConfiguraRest.create;
  try
    FConfiguraRest.BaseURL := BaseUrl  + '/empresa/' + FDocumento;
    with FConfiguraRest do
    begin
      BaseURL := BaseUrl;
      ConfigurarRest(rmGET);
      CreateParam(RESTRequest, 'token', aToken, pkGETorPOST);
      RestRequest.Execute;
      ja := TJsonObject.ParseJSONValue(RESTResponse.JSONText) as TJSONArray;
      Empresa := TJSONObject.Create;
      for i := 0 to Pred(ja.Count) do
      begin
        Empresa := ja.Get(i) as TJSONObject;
        Result := Empresa.GetValue('codigo').Value;
      end;
    end;
  finally
    FConfiguraRest.Free;
    Empresa.Free;
  end;
end;

class function TEmpresa.New: IEmpresa;
begin
  Result := Self.Create;
end;

end.
