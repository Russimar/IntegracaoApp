unit uDAOSubGrupo;

interface
uses
  REST.Client,
  uSubGrupo,
  REST.Json,
  System.Generics.Collections;

type
  IDAOSubGrupo = interface(IInterface)
    ['{F177E7C9-FC1C-4BBE-919F-72C6594F9421}']
    function CodigoSubGrupo(const Value: string): IDAOSubGrupo; overload;
    function CodigoSubGrupo: string; overload;
    function CodigoEmpresa(const Value: string): IDAOSubGrupo; overload;
    function CodigoEmpresa: string; overload;
    function Status(const Value: string): IDAOSubGrupo; overload;
    function Status: string; overload;
    function BaseURL(const Value: string): IDAOSubGrupo; overload;
    function BaseURL: String; overload;
    function GetSubGrupo(aToken, aEmpresa: String): TObjectList<TSubGrupo>;
    function PostSubGrupo(aValue : TSubGrupo; aToken : String) : String;
  end;

  TDaoSubGrupo = class(TInterfacedObject, IDAOSubGrupo)
  private
    FCodigoSubGrupo: String;
    FBaseURL: String;
    FEmpresa: String;
    FStatus: String;
  public
    class function New: IDAOSubGrupo;
    function CodigoSubGrupo(const aValue: String): IDAOSubGrupo; overload;
    function CodigoSubGrupo: string; overload;
    function CodigoEmpresa(const Value: string): IDAOSubGrupo; overload;
    function CodigoEmpresa: string; overload;
    function Status(const Value: string): IDAOSubGrupo; overload;
    function Status: string; overload;
    function BaseURL(const Value: string): IDAOSubGrupo; overload;
    function BaseURL: String; overload;
    function GetSubGrupo(aToken, aEmpresa: String): TObjectList<TSubGrupo>;
    function PostSubGrupo(aValue : TSubGrupo; aToken : String) : String;
  end;

implementation

uses
  System.JSON, REST.Types, System.SysUtils, Vcl.Dialogs, ConfigurarRest;


{ TDaoSubGrupo }
var
  aSubGrupo: TSubGrupo;

function TDaoSubGrupo.BaseURL(const Value: string): IDAOSubGrupo;
begin
  Result := Self;
  FBaseURL := Value;
end;

function TDaoSubGrupo.BaseURL: String;
begin
  Result := FBaseURL;
end;

function TDaoSubGrupo.CodigoEmpresa: string;
begin
  Result := FEmpresa;
end;

function TDaoSubGrupo.CodigoEmpresa(const Value: string): IDAOSubGrupo;
begin
  Result := Self;
  FEmpresa := Value;
end;

function TDaoSubGrupo.CodigoSubGrupo: string;
begin
  Result := FCodigoSubGrupo;
end;

function TDaoSubGrupo.CodigoSubGrupo(const aValue: String): IDAOSubGrupo;
begin
  Result := Self;
  FCodigoSubGrupo := aValue;
end;

function TDaoSubGrupo.GetSubGrupo(aToken,
  aEmpresa: String): TObjectList<TSubGrupo>;
var
  FConfigurarRest : TConfiguraRest;
  ja : TJSONArray;
  SubGrupo: TJsonObject;
  ListaSubGrupo : TObjectList<TSubGrupo>;
  I: Integer;
begin
  FConfigurarRest := TConfiguraRest.create;
  try
    if FEmpresa <> EmptyStr then
      FConfigurarRest.BaseURL := BaseURL + '/' + FEmpresa;
    FConfigurarRest.BaseURL := FConfigurarRest.BaseURL + '/' + FCodigoSubGrupo + FStatus;
    FConfigurarRest.ConfigurarRest(rmGET);
    with FConfigurarRest do
    begin
      CreateParam(RESTRequest, 'token', aToken, pkGETorPOST);
      RESTRequest.Execute;
      SubGrupo := TJSONObject.Create;
      ja := TJsonObject.ParseJSONValue(RESTResponse.JSONText) as TJSONArray;
      ListaSubGrupo := TObjectList<TSubGrupo>.Create;
      for I := 0 to Pred(ja.Count) do
      begin
        SubGrupo := ja.Get(i) as TJSONObject;
        aSubGrupo := TSubGrupo.Create;
        aSubGrupo.codigoGrupo := StrToInt(SubGrupo.GetValue('codigoGrupo').Value);
        aSubGrupo.Codigo := StrToInt(SubGrupo.GetValue('codigoSubGrupo').Value);
        aSubGrupo.descricao := SubGrupo.GetValue('descricao').Value;
        aSubGrupo.status := SubGrupo.GetValue('status').Value;
        aSubGrupo.empresa := StrToInt(SubGrupo.GetValue('empresa').Value);
        ListaSubGrupo.Add(aSubGrupo);
      end;
      Result := ListaSubGrupo;
    end;
  finally
    FConfigurarRest.Free;
  end;
end;

class function TDaoSubGrupo.New: IDAOSubGrupo;
begin
  aSubGrupo := TSubGrupo.create;
  Result := Self.Create;
end;

function TDaoSubGrupo.PostSubGrupo(aValue: TSubGrupo; aToken: String): String;
var
  FConfigurarRest : TConfiguraRest;
  SubGrupo: TJsonObject;
begin
  FConfigurarRest := TConfiguraRest.create;
  FConfigurarRest.BaseURL := BaseURL + '?token=' + aToken;
  with FConfigurarRest do
  begin
    ConfigurarRest(rmPOST);
    SubGrupo := TJson.ObjectToJsonObject(aValue);
    CreateParam(RESTRequest, 'body', SubGrupo.ToString, pkGETorPOST);
    RESTRequest.Execute;
    result := RESTResponse.JSONText;
  end;
end;

function TDaoSubGrupo.Status: string;
begin
  Result := FStatus;
end;

function TDaoSubGrupo.Status(const Value: string): IDAOSubGrupo;
begin
  Result := Self;
  FStatus := Value;
end;

end.
