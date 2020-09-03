unit uDAOBairro;

interface

uses
  uBairro, App.Interfaces;

type
  TDAOBairro = class(TInterfacedObject, IDAOBairro)
  private
    FCodigoBairro : String;
    FStatus : String;
    FBaseURL : String;
  public
    class function New: IDAOBairro;
    constructor create;
    destructor destroy; override;
    function CodigoBairro(const Value: string): IDAOBairro; overload;
    function CodigoBairro: string; overload;
    function Status(const Value: string): IDAOBairro; overload;
    function Status: string; overload;
    function BaseURL(const Value: string): IDAOBairro; overload;
    function BaseURL: String; overload;
    function PostBairro(aValue : TBairro; aToken : String) : String;
  end;

implementation

uses
  ConfigurarRest, System.JSON, REST.Types, REST.Json;

{ TDAOBairro }

function TDAOBairro.BaseURL(const Value: string): IDAOBairro;
begin
  Result := Self;
  FBaseURL := Value;
end;

function TDAOBairro.BaseURL: String;
begin
  Result := FBaseURL;
end;

function TDAOBairro.CodigoBairro(const Value: string): IDAOBairro;
begin
  Result := Self;
  FCodigoBairro := Value;
end;

function TDAOBairro.CodigoBairro: string;
begin
  Result := FCodigoBairro;
end;

constructor TDAOBairro.create;
begin

end;

destructor TDAOBairro.destroy;
begin

  inherited;
end;

class function TDAOBairro.New: IDAOBairro;
begin
  Result := Self.create;
end;

function TDAOBairro.PostBairro(aValue: TBairro; aToken: String): String;
var
  FConfigurarRest : TConfiguraRest;
  Bairro: TJsonObject;
begin
  FConfigurarRest := TConfiguraRest.create;
  try
    FConfigurarRest.BaseURL := BaseURL + '/bairros';// + '?token=' + aToken;
    with FConfigurarRest do
    begin
      ConfigurarRest(rmPOST);
      CreateParam(RESTRequest, 'token', aToken, pkQUERY);
      Bairro := TJson.ObjectToJsonObject(aValue);
      CreateParam(RESTRequest, 'body', Bairro.ToString, pkGETorPOST);
      RESTRequest.Execute;
      result := RESTResponse.JSONText;
    end;
  finally
    FConfigurarRest.Free;
  end;
end;

function TDAOBairro.Status: string;
begin
  Result := FStatus;
end;

function TDAOBairro.Status(const Value: string): IDAOBairro;
begin
  Result := Self;
  FStatus := Value;
end;

end.
