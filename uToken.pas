unit uToken;

interface

uses
  REST.Client,
  ConfigurarRest;

type
  IToken = Interface(IInterface)
    ['{FF229F15-D991-42D8-8792-A30F00AE873A}']
    function BaseURL(const Value: string): IToken; overload;
    function BaseURL: String; overload;
    function Documento(const Value: string): IToken; overload;
    function Documento: String; overload;
    function GerarToken: String;
  end;

  TToken = class(TInterfacedObject, IToken)
  strict private
  private
    FBaseUrl: String;
    FDocumento: String;

  public
    class function New: IToken;
    function BaseURL(const Value: string): IToken; overload;
    function BaseURL: String; overload;
    function Documento(const Value: string): IToken; overload;
    function Documento: String; overload;
    function GerarToken: String;
  end;

implementation

uses
  REST.Types, System.Classes, System.JSON.Readers, System.SysUtils,
  System.JSON;

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
  FBaseUrl: String;
  JSonObject: TJsonObject;
  FConfiguraRest : TConfiguraRest;
begin
  FConfiguraRest := TConfiguraRest.create;
  FConfiguraRest.BaseURL := BaseUrl;
  with FConfiguraRest do
  begin
    BaseURL := BaseUrl;
    ConfigurarRest(rmPOST);
    CreateParam(RestRequest, 'body', '{"documento":' + FDocumento + '}',pkREQUESTBODY);
    RestRequest.Execute;
    JSonObject := TJsonObject.ParseJSONValue(RestResponse.Content) as TJsonObject;
    Result := JSonObject.GetValue('token').Value;
  end;
end;

class function TToken.New: IToken;
begin
  Result := Self.Create;
end;

end.
