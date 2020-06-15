unit ConfigurarRest;

interface
uses
  REST.Client,
  REST.Types;

//type
//  TEnumKind = (pkCOOKIE, pkGETorPOST, pkURLSEGMENT, pkHTTPHEADER, pkREQUESTBODY, pkFILE, pkQUERY);

type
  TConfiguraRest = Class
    private
    FBaseURL: String;
    FRestClient: TRESTClient;
    FRestRequest: TRESTRequest;
    FRestResponse: TRESTResponse;

    public
      constructor create;
      destructor destroy; override;
      property RestRequest : TRESTRequest read FRestRequest write FRestRequest;
      property RestClient : TRESTClient read FRestClient write FRestClient;
      property RestResponse : TRESTResponse read FRestResponse write FRestResponse;
      property BaseURL : String read FBaseURL write FBaseURL;
      procedure ConfigurarRest(aParamMethod : TRESTRequestMethod);
      procedure CreateParam(const RESTRequest: TRESTRequest; const ParamName, ParamValue: string; ParamKind : TRESTRequestParameterKind);
  end;

implementation

{ TConfiguraRest }

procedure TConfiguraRest.ConfigurarRest(aParamMethod : TRESTRequestMethod);
begin
  FRestClient := TRESTClient.Create(nil);
  FRestRequest := TRESTRequest.Create(nil);
  FRestResponse := TRESTResponse.Create(nil);
  FRestRequest.Client := FRestClient;
  FRestRequest.Response := FRestResponse;
  FRestClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/json';
  FRESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8, ';
  FRESTClient.FallbackCharsetEncoding := 'utf-8';
  FRESTRequest.Method := aParamMethod;
end;

constructor TConfiguraRest.create;
begin

end;

procedure TConfiguraRest.CreateParam(const RESTRequest: TRESTRequest;
  const ParamName, ParamValue: string; ParamKind : TRESTRequestParameterKind);
begin
  with RESTRequest.Params.AddItem do
  begin
    Name := ParamName;
    Value := ParamValue;
    Kind := ParamKind;
    ContentType := ctAPPLICATION_JSON;
  end;
end;

destructor TConfiguraRest.destroy;
begin
  inherited;
  if Assigned(FRestClient)  then
    FRestClient.Free;
  if Assigned(FRestRequest)  then
    FRestRequest.Free;
  if Assigned(FRestResponse)  then
    FRestResponse.Free;
end;

end.
