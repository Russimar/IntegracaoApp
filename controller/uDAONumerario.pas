unit uDAONumerario;

interface
uses
  uNumerario, System.Generics.Collections, App.Interfaces;

type
  TDAONumerario = class(TInterfacedObject, IDAONumerario)
    strict private
      FBaseUrl : String;
      FCodigoNumerario : String;
    public
      class function New : IDAONumerario;
      function BaseUrl(const aValue : String) : IDAONumerario; overload;
      function BaseUrl : String; overload;
      function CodigoNumerario(const aValue : String) : IDAONumerario; overload;
      function CodigoNumerario : String; overload;
      function PostNumerario(aToken : String; aValue : TNumerario) : string;
  end;

implementation

uses
  System.JSON, ConfigurarRest, REST.Types, REST.Json;

{ TDAONumerario }

function TDAONumerario.BaseUrl(const aValue: String): IDAONumerario;
begin
  Result := Self;
  FBaseUrl := aValue;
end;

function TDAONumerario.BaseUrl: String;
begin
  Result := FBaseUrl;
end;

function TDAONumerario.CodigoNumerario(const aValue: String): IDAONumerario;
begin
  Result := Self;
  FCodigoNumerario := aValue;
end;

function TDAONumerario.CodigoNumerario: String;
begin
  Result := FCodigoNumerario;
end;

class function TDAONumerario.New: IDAONumerario;
begin
  Result := Self.Create;
end;

function TDAONumerario.PostNumerario(aToken: String; aValue : TNumerario): string;
var
  Numerario: TJsonObject;
  FConfiguraRest : TConfiguraRest;
begin
  FConfiguraRest := TConfiguraRest.create;
  try
    FConfiguraRest.BaseURL := BaseURL + '/numerario' + '?token=' + aToken;
    with FConfiguraRest do
    begin
      ConfigurarRest(rmPOST);
      Numerario := TJson.ObjectToJsonObject(aValue);
      CreateParam(RESTRequest, 'body', Numerario.ToString, pkGETorPOST);
      RESTRequest.Execute;
      result := RESTResponse.JSONText;
    end;
  finally
    FConfiguraRest.Free;
  end;
end;

end.
