unit uPedidoNumerario;

interface

type
  TPedidoNumerario = class
    private
      FCodigoPedido: integer;
      FItem: integer;
      FCodigoNumerario: integer;
    public
      property codigoPedido : integer read FCodigoPedido write FCodigoPedido;
      property codigoNumerario : integer read FCodigoNumerario write FCodigoNumerario;
      property item : integer read FItem write FItem;
  end;

implementation

end.
