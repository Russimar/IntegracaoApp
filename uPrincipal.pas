unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON.Readers, Vcl.StdCtrls, Vcl.Buttons, uDMConnection,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Samples.Gauges, Vcl.Grids, Vcl.ExtCtrls;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    lblHost: TLabel;
    edtHost: TEdit;
    Label4: TLabel;
    edtPorta: TEdit;
    pnlPrincipal: TPanel;
    gridDados: TStringGrid;
    pnlBotton: TPanel;
    btnConsultaProduto: TBitBtn;
    btnGravarProduto: TBitBtn;
    btnGravarSubGrupo: TBitBtn;
    BitBtn3: TBitBtn;
    btnGravarGrupo: TBitBtn;
    btnBuscarGrupo: TBitBtn;
    pnlDados: TPanel;
    lblDocumento: TLabel;
    Label2: TLabel;
    edtProduto: TEdit;
    Gauge1: TGauge;
    btnEnviarImagem: TBitBtn;
    procedure btnConsultaProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGravarProdutoClick(Sender: TObject);
    procedure btnBuscarGrupoClick(Sender: TObject);
    procedure btnGravarGrupoClick(Sender: TObject);
    procedure btnGravarSubGrupoClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure btnEnviarImagemClick(Sender: TObject);
  private
    { Private declarations }
    fDMConnection : TDMConnection;
    Consulta : TFDQuery;
    Documento : String;
    Rota : string;
    procedure ConfiguraConexao;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uToken, uDAOProduto, uProduto, System.Generics.Collections, System.IniFiles,
  uUtilPadrao, uDAOGrupo, uGrupo, uDaoSubGrupo, uSubGrupo, MaskUtils;

{$R *.dfm}
{ TForm1 }

procedure TfrmPrincipal.BitBtn3Click(Sender: TObject);
var
  aToken : String;
  ListaSubGrupo : TObjectList<TSubGrupo>;
  aSubGrupo : TSubGrupo;
begin
  aToken := TToken
            .New
            .BaseURL(Rota)
            .Documento(Documento)
            .GerarToken;

  ListaSubGrupo := TDaoSubGrupo
                 .New
                 .BaseURL(rota + '/allsubgrupos')
                 .CodigoEmpresa('9')
                 .CodigoSubGrupo(edtProduto.Text)
                 .Status('A')
                 .GetSubGrupo(aToken,'9');
  for aSubGrupo in ListaSubGrupo do
  begin
  end;


end;

procedure TfrmPrincipal.btnBuscarGrupoClick(Sender: TObject);
var
  aToken : String;
  ListaGrupo : TObjectList<TGrupo>;
  aGrupo : TGrupo;
  col, lin, i : Integer;
begin
  aToken := TToken
            .New
            .BaseURL(Rota)
            .Documento(Documento)
            .GerarToken;

  ListaGrupo := TDaoGrupo
                 .New
                 .BaseURL(Rota + '/grupos/A')
                 .CodigoEmpresa('9')
                 .CodigoGrupo(edtProduto.Text)
                 .GetGrupo(aToken,'9');
  Gauge1.MinValue := 0;
  Gauge1.MaxValue := ListaGrupo.Count;
  for aGrupo in ListaGrupo do
  begin
    Gauge1.AddProgress(1);
    Gauge1.Update;
    col := 0;
    gridDados.Objects[col,lin] := aGrupo;
    gridDados.Cells[col,lin] := IntToStr(aGrupo.Codigo);
    inc(col);
    gridDados.Cells[col,lin] := aGrupo.descricao;
    inc(col);
    gridDados.Cells[col,lin] := aGrupo.CodigoEmpresa;
    Inc(i);
    if i = 100 then
    begin
      Application.ProcessMessages;
      i := 0;
    end;
    Inc(lin);

  end;

end;

procedure TfrmPrincipal.btnConsultaProdutoClick(Sender: TObject);
var
  aToken: String;
  aDaoProduto : TDaoProduto;
  aProduto : TProduto;
  ListaProduto : TObjectList<TProduto>;
  col, lin, i :  Integer;
begin
  aToken := TToken
            .New
            .BaseURL(Rota)
            .Documento(Documento)
            .GerarToken;
  ListaProduto := TDaoProduto
                   .New
                   .BaseURL(Rota + '/produtos')
                   .CodigoEmpresa('9')
                   .CodigoProduto(edtProduto.Text)
                   .GetProduto(aToken,'9');

  gridDados.RowCount := ListaProduto.Count;
  Gauge1.MinValue := 0;
  Gauge1.MaxValue := ListaProduto.Count;
  i := 1; lin := 0;
  for aProduto in ListaProduto do
  begin
    Gauge1.AddProgress(1);
    Gauge1.Update;
    col := 0;
    gridDados.Objects[col,lin] := aProduto;
    gridDados.Cells[col,lin] := IntToStr(aProduto.codigoProduto);
    inc(col);
    gridDados.Cells[col,lin] := aProduto.descricao;
    inc(col);
    gridDados.Cells[col,lin] := FormatFloat('0.00',aProduto.preco);
    inc(col);
    gridDados.Cells[col,lin] := aProduto.unidade;
    Inc(i);
    if i = 100 then
    begin
      Application.ProcessMessages;
      i := 0;
    end;
    Inc(lin);
  end;

end;

procedure TfrmPrincipal.btnEnviarImagemClick(Sender: TObject);
var
  aToken : String;
  Foto, x : String;
  CodigoProduto : Integer;

begin
  aToken := TToken
            .New
            .BaseURL(Rota)
            .Documento(Documento)
            .GerarToken;


  CodigoProduto := 3036;
  Foto := 'C:\Easy2Solutions\Gestao\Imagem\Fruki.jpg';
  x := TDaoProduto
        .New
        .BaseURL(Rota + '/file/' + IntToStr(CodigoProduto))
        .CaminhoArquivo(Foto)
        .PostProdutoImagem(aToken);
  ShowMessage(x);
end;

procedure TfrmPrincipal.btnGravarGrupoClick(Sender: TObject);
var
  aToken : string;
  aGrupo : TGrupo;
begin
  aToken := TToken
            .New
            .BaseURL(Rota)
            .Documento(Documento)
            .GerarToken;

  with fDMConnection do
  begin
    qryGrupo.Close;
    qryGrupo.Open;
    qryGrupo.First;
    while not qryGrupo.Eof do
    begin
      aGrupo := TGrupo.Create;
      aGrupo.Codigo := qryGrupo.FieldByName('GRUPICOD').Value;
      aGrupo.descricao := qryGrupo.FieldByName('GRUPA60DESCR').Value;
      aGrupo.Status := qryGrupo.FieldByName('Status').AsString;
      TDaoGrupo
       .New
       .BaseURL(Rota + '/grupos')
       .PostGrupo(aGrupo,aToken);
      FreeAndNil(aGrupo);
      qryGrupo.Next;
    end;
  end;

end;

procedure TfrmPrincipal.btnGravarProdutoClick(Sender: TObject);
var
  aToken : string;
  aProduto : TProduto;
begin
  aToken := TToken
            .New
            .BaseURL(Rota)
            .Documento(Documento)
            .GerarToken;

  with fDMConnection do
  begin
    qryProdutos.Close;
    qryProdutos.Open;
    qryProdutos.FetchAll;
    Gauge1.MinValue := 0;
    Gauge1.MaxValue := qryProdutos.RecordCount;
    qryProdutos.First;
    while not qryProdutos.Eof do
    begin
      Gauge1.Progress := Gauge1.Progress + 1;
      Gauge1.Update;
      aProduto := TProduto.Create;
      aProduto.codigoProduto := qryProdutos.FieldByName('PRODICOD').Value;
      aProduto.descricao := StringReplace(qryProdutos.FieldByName('PRODA30ADESCRREDUZ').Value,'''','',[rfReplaceAll]);
      aProduto.preco := qryProdutos.FieldByName('PRODN3VLRVENDA').Value;
      aProduto.marca := qryProdutos.FieldByName('MARCA60DESCR').AsString;
      aProduto.grupo := qryProdutos.FieldByName('GRUPICOD').AsInteger;
      aProduto.subGrupo := qryProdutos.FieldByName('SUBGICOD').AsString;
      aProduto.unidade := qryProdutos.FieldByName('UNIDA5DESCR').AsString;
      TDaoProduto
       .New
       .BaseURL(Rota + '/produtos')
       .PostProduto(aProduto,aToken);
      FreeAndNil(aProduto);
//      Application.ProcessMessages;
      qryProdutos.Next;
    end;
  end;

end;

procedure TfrmPrincipal.btnGravarSubGrupoClick(Sender: TObject);
var
  aToken : string;
  aSubGrupo : TSubGrupo;
begin
  aToken := TToken
            .New
            .BaseURL(Rota)
            .Documento(Documento)
            .GerarToken;

  with fDMConnection do
  begin
    qrySubGrupo.Close;
    qrySubGrupo.Open;
    qrySubGrupo.First;
    while not qrySubGrupo.Eof do
    begin
      aSubGrupo := TSubGrupo.Create;
      aSubGrupo.codigoGrupo := qrySubGrupo.FieldByName('GRUPICOD').Value;
      aSubGrupo.codigo := qrySubGrupo.FieldByName('SUBGICOD').Value;
      aSubGrupo.descricao := qrySubGrupo.FieldByName('SUBGA60DESCR').Value;
      aSubGrupo.Status := qrySubGrupo.FieldByName('Status').AsString;
      TDaoSubGrupo
       .New
       .BaseURL(Rota + '/subgrupo')
       .PostSubGrupo(aSubGrupo,aToken);
      FreeAndNil(aSubGrupo);
      qrySubGrupo.Next;
    end;
  end;

end;

procedure TfrmPrincipal.ConfiguraConexao;
var
  ArquivoIni, BancoDados, UserName, PassWord : String;
  LocalServer : Integer;
  Configuracoes : TIniFile;
begin
  ArquivoIni := ExtractFilePath(Application.ExeName) + 'Parceiro.ini';
  if not FileExists(ArquivoIni) then
  begin
    MessageDlg('Arquivo Parceiro.ini não encontrado!', mtInformation,[mbOK],0);
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

  with fDMConnection do
  begin
    FDConnection.Connected := False;
    FDConnection.Params.Clear;
    FDConnection.DriverName := 'FB';
    FDConnection.Params.Values['DriveId'] := 'FB';
    FDConnection.Params.Values['DataBase'] := BancoDados;
    FDConnection.Params.Values['User_Name'] := UserName;
    FDConnection.Params.Values['Password'] := PassWord;
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fDMConnection.desconectar;
  FreeAndNil(fDMConnection);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
//  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  fDMConnection := TDMConnection.Create(nil);
  ConfiguraConexao;
  if fDMConnection.conectar then
  begin
    Documento := SQLLocate('EMPRESA','EMPRICOD','EMPRA14CGC','1');
  end;
  Rota := edtHost.Text + ':' + edtPorta.Text;
  lblDocumento.Caption :=  lblDocumento.Caption + ' ' +  FormatMaskText('99.999.999/9999-99;0',Documento);
end;

end.
