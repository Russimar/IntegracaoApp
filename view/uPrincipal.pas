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
  FireDAC.Comp.Client, Vcl.Samples.Gauges, Vcl.Grids, Vcl.ExtCtrls, uEmpresa,
  System.ImageList, Vcl.ImgList, Vcl.AppEvnts;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    lblHost: TLabel;
    edtHost: TEdit;
    Label4: TLabel;
    edtPorta: TEdit;
    pnlPrincipal: TPanel;
    pnlBotton: TPanel;
    pnlDados: TPanel;
    lblDocumento: TLabel;
    Gauge1: TGauge;
    lblCodigo: TLabel;
    lblMensagem: TLabel;
    Timer1: TTimer;
    ImageList: TImageList;
    TrayIcon: TTrayIcon;
    ApplicationEvents: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
  private
    { Private declarations }
    fDMConnection : TDMConnection;
    procedure evMensagem(Msg : String);
    procedure evProgressao(Posicao : Integer);
    procedure evNumeroMaximo(NumMaximo : Integer);
    procedure Iniciar_Servico;
    procedure Fechar_Servico;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uToken, uDAOProduto, uProduto, System.Generics.Collections, System.IniFiles,
  uUtilPadrao, uDAOGrupo, uGrupo, uDaoSubGrupo, uSubGrupo, MaskUtils, uDaoPedido,
  uPedido, uPedidoItens, uDaoPedidoItens;

{$R *.dfm}
{ TForm1 }

procedure TfrmPrincipal.ApplicationEventsMinimize(Sender: TObject);
begin
  Self.Hide();
  Self.WindowState := wsMinimized;
  TrayIcon.Visible := True;
  TrayIcon.Animate := True;
  TrayIcon.ShowBalloonHint;
end;

procedure TfrmPrincipal.BitBtn1Click(Sender: TObject);
begin
  fDMConnection.GetCodigoEmpresa;
end;

procedure TfrmPrincipal.Fechar_Servico;
begin
  fDMConnection.desconectar;
  FreeAndNil(fDMConnection);
end;

procedure TfrmPrincipal.evMensagem(Msg: String);
begin
  lblMensagem.Caption := Msg;
  lblMensagem.Update;
end;

procedure TfrmPrincipal.evNumeroMaximo(NumMaximo: Integer);
begin
  Gauge1.MinValue := 0;
  Gauge1.MaxValue := NumMaximo;
end;

procedure TfrmPrincipal.Iniciar_Servico;
begin
  fDMConnection := TDMConnection.Create(nil);
  fDMConnection.ConfiguraConexao;
  if fDMConnection.conectar then
  begin
    if not fDMConnection.Abre_Empresa then
    begin
      Application.Terminate;
      exit;
    end;
    edtHost.Text := fDMConnection.url;
    edtPorta.Text := fDMConnection.porta;
    fDMConnection.Obtem_Token;
    fDMConnection.Obtem_Codigo_Empresa;
  end;
  lblDocumento.Caption := 'Documento: ' + FormatMaskText('99.999.999/9999-99;0', fDMConnection.Documento);
  lblCodigo.Caption := 'Empresa: ' + fDMConnection.CodigoEmpresa;
  fDMConnection.evMsg := evMensagem;
  fDMConnection.evProgresso := evProgressao;
  fDMConnection.evNumMax := evNumeroMaximo;
end;

procedure TfrmPrincipal.evProgressao(Posicao: Integer);
begin
  Gauge1.Progress := Posicao;
  Gauge1.Update;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(fDMConnection);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  top := Screen.Height - Height - 50;
  left := Screen.Width - Width;
//  Iniciar_Servico;
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    Iniciar_Servico;
    with fDMConnection do
    begin
      Enviar_ConfigFrete;
      Enviar_Bairro;
      Enviar_Grupo;
      Enviar_SubGrupo;
      Enviar_Produto;
      Enviar_Imagem;
      Enviar_Numerario;
      GetPedido;
      PutPedidoStatus;
      MensagemPadrao;
    end;
  finally
    Fechar_Servico;
    Timer1.Enabled := True;
  end;
end;

procedure TfrmPrincipal.TrayIconDblClick(Sender: TObject);
begin
  TrayIcon.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

end.
