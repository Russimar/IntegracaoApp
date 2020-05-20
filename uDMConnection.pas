unit uDMConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  Dialogs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TDMConnection = class(TDataModule)
    FDConnection: TFDConnection;
    qryProdutos: TFDQuery;
    qryGrupo: TFDQuery;
    qrySubGrupo: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConfiguraConexao;
    function conectar : boolean;
    function desconectar : boolean;
  end;

var
  DMConnection: TDMConnection;

implementation

uses
  System.IniFiles, Vcl.Forms;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TuDMPrincipal }

function TDMConnection.conectar: boolean;
begin
  FDConnection.Connected := False;
  try
    FDConnection.Connected := True;
    Result := True;
  except
    FDConnection.Connected := False;
    Result := False;
  end;
end;

procedure TDMConnection.ConfiguraConexao;
var
  ArquivoIni, BancoDados, UserName, PassWord : String;
  Configuracoes : TIniFile;
begin
  ArquivoIni := ExtractFilePath(Application.ExeName) + 'Parceiro.ini';
  if not FileExists(ArquivoIni) then
  begin
    MessageDlg('Arquivo config.ini não encontrado!', mtInformation,[mbOK],0);
    Exit;
  end;

  Configuracoes := TIniFile.Create(ArquivoINI);
  try
     BancoDados := Configuracoes.ReadString('PDV', 'Database_PDV', BancoDados);
     UserName   := Configuracoes.ReadString('PDV', 'UserName',   UserName);
     PassWord   := Configuracoes.ReadString('PDV', 'PassWord', '');
  finally
    Configuracoes.Free;
  end;

  FDConnection.Params.Clear;
  FDConnection.DriverName := 'FB';
  FDConnection.Params.Values['DriveId'] := 'FB';
  FDConnection.Params.Values['DataBase'] := BancoDados;
  FDConnection.Params.Values['User_Name'] := UserName;
  FDConnection.Params.Values['Password'] := PassWord;
end;

procedure TDMConnection.DataModuleCreate(Sender: TObject);
begin
//  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
end;

function TDMConnection.desconectar: boolean;
begin
  FDConnection.Connected := False;
end;

end.
