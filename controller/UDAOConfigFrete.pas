unit UDAOConfigFrete;

interface

uses
  App.Interfaces, uConfiguraFrete, ConfigurarRest;

type
  TDAOConfigFrete = class(TInterfacedObject, IDAOConfigFrete)
  private
    FBaseURL : String;
    FStatus : String;
    FConfigurarRest: TConfiguraRest;
  public
    class function New: IDAOConfigFrete;
    constructor create;
    destructor destroy; override;
    function Status(const Value: string): IDAOConfigFrete; overload;
    function Status: string; overload;
    function BaseURL(const Value: string): IDAOConfigFrete; overload;
    function BaseURL: String; overload;
    function PostConfigFrete(aValue : TConfiguraFrete; aToken : String) : String;
  end;

implementation

uses
  System.JSON, REST.Types, REST.Json;

{ TDAOConfigFrete }

function TDAOConfigFrete.BaseURL(const Value: string): IDAOConfigFrete;
begin
  Result := Self;
  FBaseURL := Value;
end;

function TDAOConfigFrete.BaseURL: String;
begin
  Result := FBaseURL;
end;

constructor TDAOConfigFrete.create;
begin
  FConfigurarRest := TConfiguraRest.create;
end;

destructor TDAOConfigFrete.destroy;
begin
  FConfigurarRest.Free;;
  inherited;
end;

class function TDAOConfigFrete.New: IDAOConfigFrete;
begin
  Result := Self.create;
end;

function TDAOConfigFrete.PostConfigFrete(aValue: TConfiguraFrete;
  aToken: String): String;
var
  ConfigFrete: TJsonObject;
begin
  try
    FConfigurarRest.BaseURL := BaseURL + '/configFrete' ;
    with FConfigurarRest do
    begin
      ConfigurarRest(rmPOST);
      CreateParam(RESTRequest, 'token', aToken, pkQUERY);
      ConfigFrete := TJson.ObjectToJsonObject(aValue);
      CreateParam(RESTRequest, 'body', ConfigFrete.ToString, pkGETorPOST);
      RESTRequest.Execute;
      Result := RESTResponse.JSONText;
    end;
  finally
    ConfigFrete.Free;
  end;
end;

function TDAOConfigFrete.Status(const Value: string): IDAOConfigFrete;
begin
  Result := Self;
  FStatus := Value;
end;

function TDAOConfigFrete.Status: string;
begin
  Result := FStatus;
end;

end.
