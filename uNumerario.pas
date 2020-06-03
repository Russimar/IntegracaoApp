unit uNumerario;

interface

type
  TNumerario = class
  private
    FcodigoNumerario: integer;
    Fdescricao: String;
    Fstatus: String;
    Fsigla: String;
//    Ftipo: String;
  public
    property codigoNumerario : integer read FcodigoNumerario write FcodigoNumerario;
    property descricao : String read Fdescricao write Fdescricao;
    property sigla : String read Fsigla write Fsigla;
    property status : String read Fstatus write Fstatus;
//    property tipo : String read Ftipo write Ftipo;
  end;

implementation

end.
