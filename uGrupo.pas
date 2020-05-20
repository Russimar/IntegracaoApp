unit uGrupo;

interface

type
  TGrupo = class
    private
    FCodigo: Integer;
    FStatus: String;
    FDescricao: String;
    FCodigoEmpresa: String;
    public
      constructor Create;
      destructor Destroy; override;
      property Codigo : Integer read FCodigo write FCodigo;
      property Descricao : String read FDescricao write FDescricao;
      property Status : String read FStatus write FStatus;
      property CodigoEmpresa : String read FCodigoEmpresa write FCodigoEmpresa;
  end;


implementation

{ TGrupo }

constructor TGrupo.Create;
begin

end;

destructor TGrupo.Destroy;
begin

  inherited;
end;

end.
