program IntegracaoApp;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uToken in 'uToken.pas',
  uDAOProduto in 'uDAOProduto.pas',
  uProduto in 'uProduto.pas',
  uDMConnection in 'uDMConnection.pas' {DMConnection: TDataModule},
  uUtilPadrao in 'uUtilPadrao.pas',
  uGrupo in 'uGrupo.pas',
  uDAOGrupo in 'uDAOGrupo.pas',
  ConfigurarRest in 'ConfigurarRest.pas',
  uSubGrupo in 'uSubGrupo.pas',
  uDAOSubGrupo in 'uDAOSubGrupo.pas',
  uPedido in 'uPedido.pas',
  uDaoPedido in 'uDaoPedido.pas',
  uPedidoItens in 'uPedidoItens.pas',
  uDaoPedidoItens in 'uDaoPedidoItens.pas',
  uEmpresa in 'uEmpresa.pas',
  uNumerario in 'uNumerario.pas',
  uDAONumerario in 'uDAONumerario.pas',
  uDAOPedidoNumerario in 'uDAOPedidoNumerario.pas',
  uPedidoNumerario in 'uPedidoNumerario.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;

end.
