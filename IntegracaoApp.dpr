program IntegracaoApp;

uses
  Vcl.Forms,
  uDMConnection in 'model\uDMConnection.pas' {DMConnection: TDataModule},
  ConfigurarRest in 'controller\ConfigurarRest.pas',
  SmartPoint in 'controller\SmartPoint.pas',
  uDAOGrupo in 'controller\uDAOGrupo.pas',
  uDAONumerario in 'controller\uDAONumerario.pas',
  uDaoPedido in 'controller\uDaoPedido.pas',
  uDaoPedidoItens in 'controller\uDaoPedidoItens.pas',
  uDAOPedidoNumerario in 'controller\uDAOPedidoNumerario.pas',
  uDAOProduto in 'controller\uDAOProduto.pas',
  uDAOSubGrupo in 'controller\uDAOSubGrupo.pas',
  uEmpresa in 'controller\uEmpresa.pas',
  uGrupo in 'controller\uGrupo.pas',
  uNumerario in 'controller\uNumerario.pas',
  uPedido in 'controller\uPedido.pas',
  uPedidoItens in 'controller\uPedidoItens.pas',
  uPedidoNumerario in 'controller\uPedidoNumerario.pas',
  uProduto in 'controller\uProduto.pas',
  uSubGrupo in 'controller\uSubGrupo.pas',
  uToken in 'controller\uToken.pas',
  uUtilPadrao in 'controller\uUtilPadrao.pas',
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  uPrincipal in 'view\uPrincipal.pas' {frmPrincipal},
  App.Interfaces in 'model\App.Interfaces.pas';

{$R *.res}
var
  hMapping: hwnd;

begin
  Application.Initialize;
  hMapping := CreateFileMapping(HWND($FFFFFFFF), nil, PAGE_READONLY, 0, 32, PChar(ExtractFileName(Application.ExeName)));
  if (hMapping <> Null) and (GetLastError <> 0) then
  begin
    Application.MessageBox('Aplicativo já se encontra em execução !','Atenção',MB_OK);
    Halt;
  end;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;

end.
