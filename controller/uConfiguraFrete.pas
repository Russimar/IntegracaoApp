unit uConfiguraFrete;

interface

type
  TConfiguraFrete = class
  private
    FtipoCalculo: String;
    FvalorFixo: real;
    Fstatus: String;
    FvalorPorKm: real;
    FverificaFrete: String;
  public
    property tipoCalculo : String read FtipoCalculo write FtipoCalculo;
    property valorFixo : real read FvalorFixo write FvalorFixo;
    property valorPorKm : real read FvalorPorKm write FvalorPorKm;
    property status : String read Fstatus write Fstatus;
    property verificaFrete : String read FverificaFrete write FverificaFrete;
  end;

implementation

end.
