unit uBairro;

interface

type
  TBairro = class
  private
    Fbairro: String;
    Fuf: String;
    Fcodigo: integer;
    Fcidade: String;
    Fvalor: real;
    Fstatus: String;
  public
    property codigo : integer read Fcodigo write Fcodigo;
    property bairro : String read Fbairro write Fbairro;
    property cidade : String read Fcidade write Fcidade;
    property uf : String read Fuf write Fuf;
    property valor : real read Fvalor write Fvalor;
    property status : String read Fstatus write Fstatus;
  end;

implementation

end.
