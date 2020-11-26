unit uToken;

interface

uses
  REST.Client,
  ConfigurarRest,
  App.Interfaces,
  REST.Json,
  System.Json;

type
  TToken = class(TInterfacedObject, IToken)
  strict private
  private
    FBaseUrl: String;
    FDocumento: String;
    FTokenJson: TJSONObject;
    FConfiguraRest: TConfiguraRest;
  public
    constructor create;
    destructor destroy; override;
    class function New: IToken;
    function BaseURL(const Value: string): IToken; overload;
    function BaseURL: String; overload;
    function Documento(const Value: string): IToken; overload;
    function Documento: String; overload;
    function GerarToken: String;
  end;

  TObjToken = class
  private
    FDocumento: String;
  public
    property Documento: String read FDocumento write FDocumento;
  end;

implementation

uses
  REST.Types, System.Classes, System.Json.Readers, System.SysUtils;

{ TToken }

function TToken.BaseURL(const Value: string): IToken;
begin
  Result := Self;
  FBaseUrl := Value;
end;

function TToken.BaseURL: String;
begin
  Result := FBaseUrl;
end;

constructor TToken.create;
begin
  FConfiguraRest := TConfiguraRest.create;
end;

destructor TToken.destroy;
begin
//  FConfiguraRest.Free;
  inherited;
end;

function TToken.Documento: String;
begin
  Result := FDocumento;
end;

function TToken.Documento(const Value: string): IToken;
begin
  Result := Self;
  FDocumento := Value;
end;

function TToken.GerarToken: String;
var
  aToken: TObjToken;
  FBaseUrl: String;
  TokenObject: TJSONObject;
begin
  FConfiguraRest.BaseURL := BaseURL;
  with FConfiguraRest do
  begin
    aToken := TObjToken.Create;
    try
      aToken.Documento := FDocumento;
      BaseURL := BaseURL;
      ConfigurarRest(rmPOST);
      TokenObject := TJson.ObjectToJsonObject(aToken);
      CreateParam(RESTRequest, 'body', TokenObject.ToString, pkGETorPOST);
      RESTRequest.Execute;
      FTokenJson := TJSONObject.Create;
      try
        FTokenJson := RESTResponse.JSONValue as TJSONObject;
        Result := FTokenJson.GetValue('token').Value
      finally
        FreeAndNil(FTokenJson);
      end;
    finally
      TokenObject.Free;
    end;

  end;
end;

class function TToken.New: IToken;
begin
  Result := Self.Create;
end;

end.
