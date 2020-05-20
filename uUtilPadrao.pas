unit uUtilPadrao;

interface

uses
 Classes,   FireDAC.Comp.Client, uDMConnection, Vcl.Printers, Datasnap.DBClient;

  function  SQLLocate(Tabela, CampoProcura, CampoRetorno, ValorFind: string): string ;
  function GetDefaultPrinterName: string;
  procedure CopiarDataSet(Origem, Destino : TClientDataSet);

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

end.
