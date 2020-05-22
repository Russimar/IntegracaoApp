unit uPedido;

interface

type
 TPedido = class
   private
    Fvalor: real;
    FtipoEntrega: String;
    FclienteNome: String;
    FdataEntrega: String;
    FclienteCidade: String;
    FclienteEndereco: String;
    FnomeEmpresa: String;
    FclienteBairro: String;
    FcodigoPedido: integer;
    FdataEmissao: TDateTime;
    FclienteUf: String;
    FclienteCpf: String;
    FqtdeItens: real;
    FclienteNumero: String;
    FcodigoEmpresa: integer;
    Fobservacoes: string;

   public
     Constructor create;
     Destructor destroy; override;
     property clienteNome : String read FclienteNome write FclienteNome;
     property clienteCpf : String read FclienteCpf write FclienteCpf;
     property clienteCidade : String read FclienteCidade write FclienteCidade;
     property clienteBairro : String read FclienteBairro write FclienteBairro;
     property clienteEndereco : String read FclienteEndereco write FclienteEndereco;
     property clienteNumero : String read FclienteNumero write FclienteNumero;
     property clienteUf : String read FclienteUf write FclienteUf;
     property nomeEmpresa : String read FnomeEmpresa write FnomeEmpresa;
     property tipoEntrega : String read FtipoEntrega write FtipoEntrega;
     property dataEntrega : String read FdataEntrega write FdataEntrega;
     property valor : real read Fvalor write Fvalor;
     property qtdeItens : real read FqtdeItens write FqtdeItens;
     property dataEmissao : TDateTime read FdataEmissao write FdataEmissao;
     property observacoes : string read Fobservacoes write Fobservacoes;
     property codigoEmpresa : integer read FcodigoEmpresa write FcodigoEmpresa;
     property codigoPedido : integer read FcodigoPedido write FcodigoPedido;
 end;

implementation

{ TPedido }

constructor TPedido.create;
begin

end;

destructor TPedido.destroy;
begin

  inherited;
end;

end.
