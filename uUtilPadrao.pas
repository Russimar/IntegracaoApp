unit uUtilPadrao;

interface

uses
 Classes,   FireDAC.Comp.Client, uDMConnection, Vcl.Printers, Datasnap.DBClient;

  function  SQLLocate(Tabela, CampoProcura, CampoRetorno, ValorFind: string): string ;
  function GetDefaultPrinterName: string;
  procedure CopiarDataSet(Origem, Destino : TClientDataSet);
  function ConverteAcentos(Str: string): string;

var
 vCaminhoBanco: String;
 fDMConnection : TDMConnection;

implementation

uses
  System.SysUtils, Winapi.CommDlg;


function SQLLocate(Tabela, CampoProcura, CampoRetorno, ValorFind: string): string ;
var
  MyQuery: TFDQuery;
begin
  if ValorFind <> '' then
  begin
    try
      if not Assigned(fDMConnection) then
      begin
        fDMConnection := TDMConnection.Create(nil);
        fDMConnection.ConfiguraConexao;
        fDMConnection.conectar;
      end;
      MyQuery := TFDQuery.Create(fDMConnection);
      MyQuery.Connection := fDMConnection.FDConnection;
      MyQuery.Close;
      MyQuery.SQL.Clear ;
      MyQuery.SQL.Add('select ' + CampoRetorno + ' from ' + Tabela) ;
      MyQuery.SQL.Add('where  ' + CampoProcura + ' = ' + QuotedStr(ValorFind));
      MyQuery.Open ;
      if not MyQuery.EOF then
        SQLLocate := MyQuery.FieldByName(CampoRetorno).AsString
      else
        SQLLocate := '' ;
      MyQuery.Destroy ;
    finally
      fDMConnection.Free;
    end;
  end
  else
    ValorFind := '' ;
end;

function GetDefaultPrinterName: string;
begin
  if (Printer.PrinterIndex >= 0) then
  begin
    Result := Printer.Printers[Printer.PrinterIndex];
  end
  else
  begin
    Result := 'Nenhuma impressora padrão foi detectada.';
  end;
end;

procedure CopiarDataSet(Origem, Destino : TClientDataSet);
begin
  Destino.Data := Origem.Data;
end;

function ConverteAcentos(Str: string): string;
const
  NumChars = 47;
  Acentuados: array[1..NumChars] of Char = ('Á', 'É', 'Í', 'Ó', 'Ú',
    'á', 'é', 'í', 'ó', 'ú',
    'À', 'È', 'Ì', 'Ò', 'Ù',
    'à', 'è', 'ì', 'ò', 'ù',
    'Â', 'Ê', 'Î', 'Ô', 'Û',
    'â', 'ê', 'î', 'ô', 'û',
    'Ã', 'Õ', 'ã', 'õ',
    'Ä', 'Ë', 'Ï', 'Ö', 'Ü',
    'ä', 'ë', 'ï', 'ö', 'ü',
    'Ç', 'ç', 'º');
  Normais: array[1..NumChars] of Char = ('A', 'e', 'I', 'O', 'U',
    'a', 'e', 'i', 'o', 'u',
    'A', 'E', 'I', 'O', 'U',
    'a', 'e', 'i', 'o', 'u',
    'A', 'E', 'I', 'O', 'U',
    'a', 'e', 'i', 'o', 'u',
    'A', 'O', 'a', 'o',
    'A', 'E', 'I', 'O', 'U',
    'a', 'e', 'i', 'o', 'u',
    'C', 'c', '.');
var
  Len, C: Integer;
  { --- }
  function ConvChar(Ch: Char): Char;
  var
    I: Integer;
  begin
    for I := 1 to NumChars do
      if Acentuados[I] = Ch then
      begin
        Result := Normais[I];
        Exit;
      end;
    Result := Ch;
  end;
  { --- }
begin
  Result := '';
  Len := Length(Str);
  for C := 1 to Len do
    Result := Result + ConvChar(Str[C]);
end;


end.
