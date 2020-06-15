unit uPedidoItens;

interface

type
  TPedidoItens = class
  private
    FEmpresa: integer;
    FdescProd: String;
    FcodigoProduto: integer;
    FvalorUnidade: real;
    FvalorTotal: real;
    Fpedido: integer;
    Fitem: integer;
    Fquantidade: real;
    Funidade: String;
  public
    constructor create;
    destructor destroy; override;
    property empresa : integer read FEmpresa write FEmpresa;
    property pedido : integer read Fpedido write Fpedido;
    property item : integer read Fitem write Fitem;
    property codigoProduto : integer read FcodigoProduto write FcodigoProduto;
    property descProd : String read FdescProd write FdescProd;
    property quantidade : real read Fquantidade write Fquantidade;
    property valorUnidade : real read FvalorUnidade write FvalorUnidade;
    property valorTotal : real read FvalorTotal write FvalorTotal;
    property unidade : String read Funidade write Funidade;

  end;

implementation

{ TPedidoItens }

constructor TPedidoItens.create;
begin

end;

destructor TPedidoItens.destroy;
begin

  inherited;
end;

end.
