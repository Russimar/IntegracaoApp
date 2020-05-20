unit uProduto;

interface

type
  TProduto = class
  private
    FPreco: Real;
    FDescricao: String;
    FCodigoProduto: integer;
    FEstoque: String;
    FMarca: String;
    FTipo: String;
    FUnidade: String;
    FSubGrupo: String;
    FGrupo: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property codigoProduto: integer read FCodigoProduto write FCodigoProduto;
    property descricao: String read FDescricao write FDescricao;
    property preco: Real read FPreco write FPreco;
    property marca: String read FMarca write FMarca;
    property grupo: Integer read FGrupo write FGrupo;
    property Tipo: String read FTipo write FTipo;
    property unidade : String read FUnidade write FUnidade;
    property subGrupo : String read FSubGrupo write FSubGrupo;
  end;

implementation

{ TProduto }

constructor TProduto.Create;
begin

end;

destructor TProduto.Destroy;
begin

  inherited;
end;

end.
