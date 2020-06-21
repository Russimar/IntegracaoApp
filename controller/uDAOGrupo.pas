unit uDAOGrupo;

interface
uses
  REST.Client,
  uGrupo,
  REST.Json,
  System.Generics.Collections, App.Interfaces;

type

  TDaoGrupo = class(TInterfacedObject, IDAOGrupo)
  strict private
  private
    FCodigoGrupo: String;
    FBaseURL: String;
    FEmpresa: String;
    FListaGrupo : TObjectList<TGrupo>;
  public
    class function New: IDAOGrupo;
    constructor create;
    destructor Destroy; override;
    function CodigoGrupo(const aValue: String): IDAOGrupo; overload;
    function CodigoGrupo: string; overload;
    function CodigoEmpresa(const Value: string): IDAOGrupo; overload;
    function CodigoEmpresa: string; overload;
    function BaseURL(const Value: string): IDAOGrupo; overload;
    function BaseURL: String; overload;
    function GetGrupo(aToken, aEmpresa: String): TObjectList<TGrupo>;
    function PostGrupo(aValue : TGrupo; aToken : String) : String;
  end;


implementation

uses
  System.JSON, REST.Types, System.SysUtils, Vcl.Dialogs, ConfigurarRest;

{ TDaoGrupo }
var
  aGrupo: TGrupo;

function TDaoGrupo.BaseURL: String;
begin
  Result := FBaseURL;
end;

function TDaoGrupo.BaseURL(const Value: string): IDAOGrupo;
begin
  Result := Self;
  FBaseURL := Value;
end;

function TDaoGrupo.CodigoEmpresa: string;
begin
  Result := FEmpresa;
end;

function TDaoGrupo.CodigoEmpresa(const Value: string): IDAOGrupo;
begin
  Result := Self;
  FEmpresa := Value;
end;

function TDaoGrupo.CodigoGrupo: string;
begin
  Result := FCodigoGrupo;
end;

constructor TDaoGrupo.create;
begin
  FListaGrupo := TObjectList<TGrupo>.Create;
end;

destructor TDaoGrupo.Destroy;
begin
  FListaGrupo.Free;
  inherited;
end;

function TDaoGrupo.CodigoGrupo(const aValue: String): IDAOGrupo;
begin
  Result := Self;
  FCodigoGrupo := aValue;
end;

function TDaoGrupo.GetGrupo(aToken, aEmpresa: String): TObjectList<TGrupo>;
var
  FConfigurarRest : TConfiguraRest;
  ja : TJSONArray;
  Grupo: TJsonObject;
//  ListaGrupo : TObjectList<TGrupo>;
  I: Integer;
begin
  FConfigurarRest := TConfiguraRest.create;
  if FEmpresa <> EmptyStr then
    FConfigurarRest.BaseURL := BaseURL + '/' + FEmpresa;
  FConfigurarRest.BaseURL := BaseURL + '/' + FCodigoGrupo;
  FConfigurarRest.ConfigurarRest(rmGET);
  with FConfigurarRest do
  begin
    CreateParam(RESTRequest, 'token', aToken, pkQUERY);
    RESTRequest.Execute;
    Grupo := TJSONObject.Create;
    ja := TJsonObject.ParseJSONValue(RESTResponse.JSONText) as TJSONArray;
//    ListaGrupo := TObjectList<TGrupo>.Create;
    for I := 0 to Pred(ja.Count) do
    begin
      Grupo := ja.Get(i) as TJSONObject;
      aGrupo := TGrupo.Create;
      aGrupo.Codigo := StrToInt(Grupo.GetValue('codigo').Value);
      aGrupo.descricao := Grupo.GetValue('descricao').Value;
      aGrupo.CodigoEmpresa := Grupo.GetValue('empresa').Value;
      FListaGrupo.Add(aGrupo);
    end;
    Result := FListaGrupo;
  end;
end;

class function TDaoGrupo.New: IDAOGrupo;
begin
  aGrupo := TGrupo.Create;
  Result := Self.Create;
end;

function TDaoGrupo.PostGrupo(aValue: TGrupo; aToken: String): String;
var
  FConfigurarRest : TConfiguraRest;
  Grupo: TJsonObject;
begin
  FConfigurarRest := TConfiguraRest.create;
  try
    FConfigurarRest.BaseURL := BaseURL;// + '?token=' + aToken;
    with FConfigurarRest do
    begin
      ConfigurarRest(rmPOST);
      CreateParam(RESTRequest, 'token', aToken, pkQUERY);
      Grupo := TJson.ObjectToJsonObject(aValue);
      CreateParam(RESTRequest, 'body', Grupo.ToString, pkGETorPOST);
      RESTRequest.Execute;
      result := RESTResponse.JSONText;
    end;
  finally
    FConfigurarRest.Free;
  end;
end;

end.
