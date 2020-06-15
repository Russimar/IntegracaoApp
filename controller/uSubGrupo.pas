unit uSubGrupo;

interface

type
 TSubGrupo = class
   private
    FcodigoGrupo: Integer;
    Fdescricao: String;
    Fcodigo: Integer;
    Fstatus: String;
    FEmpresa: Integer;

   public
     constructor create;
     destructor destroy; override;
     property codigoGrupo : Integer read FcodigoGrupo write FcodigoGrupo;
     property codigo : Integer read Fcodigo write Fcodigo;
     property descricao : String read Fdescricao write Fdescricao;
     property status : String read Fstatus write Fstatus;
     property empresa : Integer read FEmpresa write FEmpresa;
 end;

implementation

{ TSubGrupo }

constructor TSubGrupo.create;
begin

end;

destructor TSubGrupo.destroy;
begin

  inherited;
end;

end.
