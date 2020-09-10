unit uDMConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  Dialogs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Data.DB, uEmpresa, uDAONumerario, UITypes;

type
  tEvMensagem = procedure(Mensagem : String) of Object;
  tEvProgressao = procedure(Posicao : Integer) of Object;
  tEvNumeroMax = procedure(Maximo : Integer) of Object;

type
  TDMConnection = class(TDataModule)
    FDConnection: TFDConnection;
    sqlConsulta: TFDQuery;
    FDImagem: TFDConnection;
    sqlConsultaImagem: TFDQuery;
    StoredProc: TFDStoredProc;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FMsg: String;
    FPosicao: Integer;
    FNumMaximo: Integer;

    FevProgressao: tEvProgressao;
    FevMsg: tEvMensagem;
    FevNumMaximo: tEvNumeroMax;

    procedure SetMsg(const Value: String);
    procedure setPosicao(const Value: Integer);
    procedure setNumMaximo(const Value: Integer);
  public
    { Public declarations }
    Url : String;
    Porta : string;
    Token : String;
    Documento : String;
    ID_Empresa : Integer;
    Rota : String;
    CodigoEmpresa : String;
    Terminal : String;
    procedure ConfiguraConexao;
    function Obtem_Token: Boolean;
    function conectar : boolean;
    function desconectar : boolean;
    function GravarImagem : Boolean;
    function Enviar_ConfigFrete : Boolean;
    function Enviar_SubGrupo : Boolean;
    function Enviar_Grupo : Boolean;
    function Enviar_Produto : Boolean;
    function Enviar_Imagem : Boolean;
    function Enviar_Numerario : Boolean;
    function Enviar_Bairro : Boolean;
    function Abre_Tabela(xSql : String) : Boolean;
    function Obtem_Codigo_Empresa : Boolean;
    function Abre_Empresa : Boolean;
    function GetPedido : Boolean;
    function GetCodigoEmpresa : Boolean;
    function PutPedidoStatus : Boolean;

    property evMsg : tEvMensagem read FevMsg write FevMsg;
    property Msg : String read FMsg write SetMsg;
    property evProgresso : tEvProgressao read FevProgressao write FevProgressao;
    property Posicao : Integer read FPosicao write setPosicao;
    property evNumMax : tEvNumeroMax read FevNumMaximo write FevNumMaximo;
    property NumMax : Integer read FNumMaximo write setNumMaximo;
    procedure MensagemPadrao;
  end;

var
  DMConnection: TDMConnection;

implementation

uses
  uToken, uDAOProduto, uProduto, System.Generics.Collections, System.IniFiles,
  uUtilPadrao, uDAOGrupo, uGrupo, uDaoSubGrupo, uSubGrupo, MaskUtils, uDaoPedido,
  uPedido, uPedidoItens, uDaoPedidoItens, Vcl.Forms, uNumerario, uPedidoNumerario,
  uDaoPedidoNumerario, uBairro, uDAOBairro, uConfiguraFrete, uDaoConfigFrete;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TuDMPrincipal }

function TDMConnection.Abre_Tabela(xSql: String): Boolean;
begin
  try
    sqlConsulta.Close;
    sqlConsulta.SQL.Clear;
    sqlConsulta.SQL.Add(xSql);
    sqlConsulta.Open;
    if sqlConsulta.IsEmpty then
      Result := False
    else
      Result := True;
  except
    Result := False;
  end;
end;

function TDMConnection.Abre_Empresa: Boolean;
var
  xSql : String;
begin
  xSql := 'SELECT FIRST(1)EMPRA14CGC, EMPRICOD FROM EMPRESA WHERE UTILIZA_APP = ' + QuotedStr('S');
  if Abre_Tabela(xSql) then
  begin
    Documento := sqlConsulta.FieldByName('EMPRA14CGC').AsString;
    ID_Empresa := sqlConsulta.FieldByName('EMPRICOD').AsInteger;
    Result := True;
  end
  else
  begin
    MessageDlg('Nenhum CNPJ Configurado para utilizar APP',mtError,[mbOK],0);
    Result := False;
  end;
end;

function TDMConnection.conectar: boolean;
begin
  FDConnection.Connected := False;
  try
    FDConnection.Connected := True;
    Result := True;
  except
    FDConnection.Connected := False;
    Result := False;
  end;

  FDImagem.Connected := False;
  try
    FDImagem.Connected := True;
  except
    FDImagem.Connected := False;
  end;

end;

procedure TDMConnection.ConfiguraConexao;
var
  ArquivoIni, BancoDados, UserName, PassWord : String;
  BancoDadosImagem, UserNameImagem, PassWordImagem : String;

  Configuracoes : TIniFile;
begin
  ArquivoIni := ExtractFilePath(Application.ExeName) + 'Parceiro.ini';
  if not FileExists(ArquivoIni) then
  begin
    MessageDlg('Arquivo Parceiro.ini não encontrado!', mtInformation,[mbOK],0);
    Exit;
  end;

  Configuracoes := TIniFile.Create(ArquivoINI);
  try
     BancoDados := Configuracoes.ReadString('PDV', 'Database_PDV', BancoDados);
     UserName   := Configuracoes.ReadString('PDV', 'UserName',   UserName);
     PassWord   := Configuracoes.ReadString('PDV', 'PassWord', '');
     url        := Configuracoes.ReadString('APP', 'url', '');
     porta      := Configuracoes.ReadString('APP', 'porta', '');
     Terminal   := Configuracoes.ReadString('APP', 'terminal', '');

     //Banco de dados de Imagem
     BancoDadosImagem := Configuracoes.ReadString('IMAGEM', 'Database', BancoDados);
     UserNameImagem   := Configuracoes.ReadString('IMAGEM', 'UserName',   UserName);
     PassWordImagem   := Configuracoes.ReadString('IMAGEM', 'PassWord', '');

  finally
    Configuracoes.Free;
  end;
  Rota := url + ':' + porta;
  FDConnection.Params.Clear;
  FDConnection.DriverName := 'FB';
  FDConnection.Params.Values['DriveId'] := 'FB';
  FDConnection.Params.Values['DataBase'] := BancoDados;
  FDConnection.Params.Values['User_Name'] := UserName;
  FDConnection.Params.Values['Password'] := PassWord;

  FDImagem.Params.Clear;
  FDImagem.DriverName := 'FB';
  FDImagem.Params.Values['DriveId'] := 'FB';
  FDImagem.Params.Values['DataBase'] := BancoDadosImagem;
  FDImagem.Params.Values['User_Name'] := UserNameImagem;
  FDImagem.Params.Values['Password'] := PassWordImagem;
end;

procedure TDMConnection.DataModuleCreate(Sender: TObject);
begin
//  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
end;

function TDMConnection.desconectar: boolean;
begin
  FDConnection.Connected := False;
  FDConnection.Connected := False;
  Result := True;
end;

function TDMConnection.Enviar_Bairro: Boolean;
var
  xSql : String;
  aBairro : TBairro;
begin
  xSql := 'Select * from BAIRROSATENDIDOS WHERE EMPRICOD = ' + IntToStr(ID_Empresa) + ' AND PENDENTE = ' + QuotedStr('S');
  if Abre_Tabela(xSql) then
  begin
    while not sqlConsulta.Eof do
    begin
      aBairro := TBairro.Create;
      aBairro.Codigo := sqlConsulta.FieldByName('CODIGO').Value;
      aBairro.bairro := sqlConsulta.FieldByName('BAIRRO').Value;
      aBairro.cidade := sqlConsulta.FieldByName('CIDADE').AsString;
      aBairro.uf := sqlConsulta.FieldByName('UF').AsString;
      aBairro.valor := sqlConsulta.FieldByName('VALOR').AsFloat;
      aBairro.Status := sqlConsulta.FieldByName('STATUS').AsString;
      try
      TDAOBairro
        .New
        .BaseURL(Rota )
        .PostBairro(aBairro,Token);
      finally
        FreeAndNil(aBairro);
      end;
      xSql := 'UPDATE BAIRROSATENDIDOS SET PENDENTE = ' + QuotedStr('N') + ' WHERE CODIGO = ' + sqlConsulta.FieldByName('CODIGO').AsString + ' AND EMPRICOD = ' + IntToStr(ID_Empresa);
      FDConnection.ExecSQL(xSql);
      sqlConsulta.Next;
    end;
    Result := True;
  end;
end;

function TDMConnection.Enviar_ConfigFrete: Boolean;
var
  xSql : String;
  aConfigFrete : TConfiguraFrete;
begin
  xSql := 'Select * from CONFIGFRETE WHERE EMPRICOD = ' + IntToStr(ID_Empresa) + ' AND PENDENTE = ' + QuotedStr('S');
  if Abre_Tabela(xSql) then
  begin
    while not sqlConsulta.Eof do
    begin
      aConfigFrete := TConfiguraFrete.Create;
      aConfigFrete.valorFixo := sqlConsulta.FieldByName('VALORFIXO').AsFloat;
      aConfigFrete.valorPorKm := sqlConsulta.FieldByName('VALORPORKM').AsFloat;
      aConfigFrete.tipoCalculo := sqlConsulta.FieldByName('TIPO_CALCULO').AsString;
      aConfigFrete.Status := sqlConsulta.FieldByName('Status').AsString;
      aConfigFrete.verificaFrete := 'S';
      try
      TDAOConfigFrete
        .New
        .BaseURL(Rota)
        .PostConfigFrete(aConfigFrete,Token);
      finally
        FreeAndNil(aConfigFrete);
      end;
      xSql := 'UPDATE CONFIGFRETE SET PENDENTE = ' + QuotedStr('N') + ' WHERE CODIGO = ' + sqlConsulta.FieldByName('CODIGO').AsString + ' AND EMPRICOD = ' + IntToStr(ID_Empresa);
      FDConnection.ExecSQL(xSql);
      sqlConsulta.Next;
    end;
    Result := True;
  end;
end;

function TDMConnection.Enviar_Grupo: Boolean;
var
  xSql : String;
  aGrupo : TGrupo;
begin
  xSql := 'Select * from GRUPOAPP_LOG';
  if Abre_Tabela(xSql) then
  begin
    while not sqlConsulta.Eof do
    begin
      aGrupo := TGrupo.Create;
      aGrupo.Codigo := sqlConsulta.FieldByName('ID_GRUPO').Value;
      aGrupo.descricao := sqlConsulta.FieldByName('DESCRICAO').Value;
      aGrupo.Status := sqlConsulta.FieldByName('Status').AsString;
      try
      TDaoGrupo
        .New
        .BaseURL(Rota + '/grupos')
        .PostGrupo(aGrupo,Token);
      finally
        FreeAndNil(aGrupo);
      end;
      xSql := 'Delete from GRUPOAPP_LOG WHERE ID_GRUPO = ' + sqlConsulta.FieldByName('ID_GRUPO').AsString;
      FDConnection.ExecSQL(xSql);
      sqlConsulta.Next;
    end;
    Result := True;
  end;
end;

function TDMConnection.Enviar_Imagem: Boolean;
var
  xSql : String;
begin
  GravarImagem;
//  if not GravarImagem then
//    MessageDlg('Imagem não enviada',mtInformation,[mbOK],0);
end;

function TDMConnection.Enviar_Numerario: Boolean;
var
  xSql : String;
  aNumerario : TNumerario;
  i : Integer;
begin
  xSql := 'Select * from NUMERARIOAPP_LOG';
  if Abre_Tabela(xSql) then
  begin
    NumMax := sqlConsulta.RecordCount;
    while not sqlConsulta.Eof do
    begin
      Msg := 'Enviando Numerario nº: ' + sqlConsulta.FieldByName('ID_NUMERARIO').AsString;
      Inc(i);
      Posicao := i;
      aNumerario := TNumerario.Create;
      try
        aNumerario.codigoNumerario := sqlConsulta.FieldByName('ID_NUMERARIO').Value;
        aNumerario.descricao := trim(sqlConsulta.FieldByName('DESCRICAO').Value);
        aNumerario.sigla := sqlConsulta.FieldByName('SIGLA').Value;
        aNumerario.status := sqlConsulta.FieldByName('STATUS').Value;
    //      aNumerario.tipo := sqlConsulta.FieldByName('TIPO').Value;
        try
          TDAONumerario
           .New
           .BaseURL(Rota)
           .PostNumerario(Token, aNumerario);
        finally
          FreeAndNil(aNumerario);
        end;
        xSql := 'Delete from NUMERARIOAPP_LOG WHERE ID_NUMERARIO = ' + sqlConsulta.FieldByName('ID_NUMERARIO').AsString;
        FDConnection.ExecSQL(xSql);
      finally
        aNumerario.Free;
      end;
      sqlConsulta.Next;
    end;
  end;

end;

function TDMConnection.Enviar_Produto: Boolean;
var
  xSql : String;
  aProduto : TProduto;
  i : Integer;
begin
  xSql := 'Select * from PRODUTOAPP_LOG';
  if Abre_Tabela(xSql) then
  begin
    NumMax := sqlConsulta.RecordCount;
    while not sqlConsulta.Eof do
    begin
      Msg := 'Enviando Produto nº: ' + sqlConsulta.FieldByName('ID_PRODUTO').AsString;
      Inc(i);
      Posicao := i;
      aProduto := TProduto.Create;
      aProduto.codigoProduto := sqlConsulta.FieldByName('ID_PRODUTO').Value;
      aProduto.descricao := trim(StringReplace(sqlConsulta.FieldByName('DESCRICAO').Value,'''','',[rfReplaceAll]));
      aProduto.preco := sqlConsulta.FieldByName('PRECO_VENDA').Value;
      aProduto.marca := trim(sqlConsulta.FieldByName('MARCA').AsString);
      aProduto.grupo := sqlConsulta.FieldByName('ID_GRUPO').AsInteger;
      aProduto.subGrupo := trim(sqlConsulta.FieldByName('ID_SUBGRUPO').AsString);
      aProduto.unidade := trim(sqlConsulta.FieldByName('UNIDADE').AsString);
      aProduto.inicioPromocao := sqlConsulta.FieldByName('DT_INICIAL_PROMO').AsDateTime;
      aProduto.finalPromocao := sqlConsulta.FieldByName('DT_FINAL_PROMO').AsDateTime;
      aProduto.valorPromocao := sqlConsulta.FieldByName('PRECO_VENDA_PROMO').AsFloat;
      try
        TDaoProduto
         .New
         .BaseURL(Rota + '/produtos')
         .PostProduto(aProduto,Token);
      finally
        FreeAndNil(aProduto);
      end;
      xSql := 'Delete from PRODUTOAPP_LOG WHERE ID_PRODUTO = ' + sqlConsulta.FieldByName('ID_PRODUTO').AsString;
      FDConnection.ExecSQL(xSql);
      sqlConsulta.Next;
    end;
  end;
  Result := True;
end;

function TDMConnection.Enviar_SubGrupo: Boolean;
var
  xSql : String;
  aSubGrupo : TSubGrupo;
begin
  xSql := 'Select * from SUBGRUPOAPP_LOG';
  if Abre_Tabela(xSql) then
  begin
    while not sqlConsulta.Eof do
    begin
      aSubGrupo := TSubGrupo.Create;
      aSubGrupo.codigoGrupo := sqlConsulta.FieldByName('ID_GRUPO').Value;
      aSubGrupo.codigo := sqlConsulta.FieldByName('ID_SUBGRUPO').Value;
      aSubGrupo.descricao := sqlConsulta.FieldByName('DESCRICAO').Value;
      aSubGrupo.Status := sqlConsulta.FieldByName('Status').AsString;
      try
        TDaoSubGrupo
         .New
         .BaseURL(Rota + '/subgrupo')
         .PostSubGrupo(aSubGrupo,Token);
      finally
        FreeAndNil(aSubGrupo);
      end;
      xSql := 'Delete from SUBGRUPOAPP_LOG WHERE ID_GRUPO = '
              + sqlConsulta.FieldByName('ID_GRUPO').AsString
              + ' AND ID_SUBGRUPO = ' + sqlConsulta.FieldByName('ID_SUBGRUPO').AsString;
      FDConnection.ExecSQL(xSql);
      sqlConsulta.Next;
    end;
    Result := True;
  end;
end;

function TDMConnection.GetCodigoEmpresa: Boolean;
begin
  try
    CodigoEmpresa := TEmpresa
                      .New
                      .BaseURL(Rota)
                      .Documento(Documento)
                      .GetCodigo(token);
    Result := True                  
  except
    Result := False;
  end;
end;

function TDMConnection.GravarImagem : Boolean;
const
  Pendente = 'N';
var
  BlobStream : TStream;
  FileStream : TFileStream;
  Path, NameFile : String;
  xSql : String;
  ID_Produto : Integer;
begin
  try
    sqlConsultaImagem.Close;
    sqlConsultaImagem.SQL.Clear;
    sqlConsultaImagem.SQL.Add('SELECT ID_PRODUTO, IMAGEM FROM PRODUTO_IMAGEM WHERE STATUS = :STATUS');
    sqlConsultaImagem.ParamByName('STATUS').AsString := 'P';
    sqlConsultaImagem.Open;
    begin
      while not sqlConsultaImagem.Eof do
      begin
        ID_Produto := sqlConsultaImagem.FieldByName('ID_PRODUTO').AsInteger;
        Path := ExtractFilePath(Application.ExeName) + 'Imagem';
        NameFile := '\Prod_' + ID_Produto.ToString + '.jpg';
        if not sqlConsultaImagem.IsEmpty then
        begin
          BlobStream := sqlConsultaImagem.CreateBlobStream(sqlConsultaImagem.FieldByName('IMAGEM'), bmRead);
          try
            FileStream := TFileStream.Create(Path + NameFile, fmCreate or fmOpenWrite);
            FileStream.CopyFrom(BlobStream,0);
          finally
            FileStream.Free;
            BlobStream.Free;
          end;
          TDaoProduto
           .New
           .BaseURL(Rota + '/file/' + IntToStr(ID_Produto))
           .CaminhoArquivo(Path + NameFile)
           .PostProdutoImagem(Token);
           Result := True;
        end;
        xSql := 'UPDATE PRODUTO_IMAGEM SET STATUS = ''' + Pendente + ''' where id_produto = ' + ID_Produto.ToString;
        FDImagem.ExecSQL(xSql);
        sqlConsultaImagem.Next;
      end;
    end;
  except
    Result := False;
  end;
end;

procedure TDMConnection.MensagemPadrao;
begin
  Msg := 'Aguardando novo ciclo';
  Posicao := 0;
  NumMax := 100;
end;

function TDMConnection.Obtem_Codigo_Empresa: Boolean;
begin
  try
    CodigoEmpresa := TEmpresa
                       .New
                       .BaseURL(Rota)
                       .Documento(Documento)
                       .GetCodigo(Token);
    Result := True;
  except
    Result := False
  end;
  
end;

function TDMConnection.Obtem_Token: Boolean;
begin
  try
    Token := TToken
             .New
             .BaseURL(Rota)
             .Documento(Documento)
             .GerarToken;
    Result := True;
  except
    on E : Exception do
    begin
      MessageDlg('Erro ao Gerar Token!',mtInformation,[mbOK],0);
      Result := False;
    end;
  end;
end;

function TDMConnection.PutPedidoStatus: Boolean;
var
  xSql : String;
begin
  xSql := 'SELECT * FROM PEDIDOVENDAAPP_LOG ';
  if Abre_Tabela(xSql) then
  begin
    while not sqlConsulta.Eof do
    begin
      TDaoPedido
        .New
        .BaseURL(Rota)
        .CodigoPedido(IntToStr(sqlConsulta.FieldByName('ID_PEDIDOAPP').AsInteger))
        .CodPedidoRetorno(sqlConsulta.FieldByName('ID_PEDIDO').AsString)
        .Status(sqlConsulta.FieldByName('STATUS').AsString)
        .PutPedido(Token);
      FDConnection.ExecSQL('delete from PEDIDOVENDAAPP_LOG where id_pedido= ' + sqlConsulta.FieldByName('ID_PEDIDO').AsString);
      sqlConsulta.Next;
    end;
  end;
  Result := True;
end;

procedure TDMConnection.SetMsg(const Value: String);
begin
  if Assigned(FevMsg) then
    FevMsg(Value);
end;

procedure TDMConnection.setNumMaximo(const Value: Integer);
begin
  if Assigned(FevNumMaximo) then
    FevNumMaximo(Value);
end;

procedure TDMConnection.setPosicao(const Value: Integer);
begin
  if Assigned(FevProgressao) then
    FevProgressao(Value);
end;

function TDMConnection.GetPedido: Boolean;
var
  ListaPedido : TObjectList<TPedido>;
  ListaPedidoItem : TObjectList<TPedidoItens>;
  ListaPedidoNumerario : TObjectList<TPedidoNumerario>;
  aPedido : TPedido;
  aPedidoItem : TPedidoItens;
  aPedidoNumerario : TPedidoNumerario;
  i : integer;
  CodigoCliente, CodigoPedido, Fone : String;
begin
  ListaPedido := TDaoPedido
                   .New
                   .BaseURL(Rota)
                   .GetPedido(Token);
  NumMax := ListaPedido.Count;
  i := 0;
  for aPedido in ListaPedido do
  begin
    Inc(i);
    Posicao := i;
    Msg := 'Importando Pedido nº: ' + IntToStr(aPedido.codigoPedido);
    Fone := aPedido.clienteTelefone;
    Fone := StringReplace(Fone,'(','',[rfReplaceAll]);
    Fone := StringReplace(Fone,')','',[rfReplaceAll]);
    Fone := StringReplace(Fone,' ','',[rfReplaceAll]);
    Fone := StringReplace(Fone,'-','',[rfReplaceAll]);

    //Gravar Cliente
    StoredProc.Close;
    StoredProc.StoredProcName := 'SP_INCLUI_CLIENTE_APP';
    StoredProc.Prepare;
    StoredProc.ParamByName('CPF').Value := aPedido.clienteCpf;
    StoredProc.ParamByName('TERMINAL').Value := Terminal;
    StoredProc.ParamByName('NOME').Value := aPedido.clienteNome;
    StoredProc.ParamByName('ENDERECO').Value := trim(aPedido.clienteEndereco);
    StoredProc.ParamByName('NUMERO_END').Value := trim(aPedido.clienteNumero);
    StoredProc.ParamByName('BAIRRO').Value := aPedido.clienteBairro;
    StoredProc.ParamByName('UF').Value := aPedido.clienteUf;
    StoredProc.ParamByName('FONE').Value := Fone;
    StoredProc.ParamByName('CEP').Value := StringReplace(aPedido.clienteCep,'-','',[rfReplaceAll]);
    StoredProc.ParamByName('CIDADE').Value := ConverteAcentos(aPedido.clienteCidade);
    StoredProc.ParamByName('CODIGOEMPRESA').Value := IntToStr(ID_Empresa);
    StoredProc.Execute;
    CodigoCliente := StoredProc.ParamByName('CODIGO_CLIENTE').AsString;

    //Gravar Pedido
    StoredProc.Close;
    StoredProc.StoredProcName := 'SP_INCLUI_PEDIDO_APP';
    StoredProc.Prepare;
    StoredProc.ParamByName('CODIGOEMPRESA').Value := ID_Empresa;
    StoredProc.ParamByName('TERMINAL').Value := Terminal;
    StoredProc.ParamByName('DATAEMISSAO').Value := aPedido.dataEmissao;
    StoredProc.ParamByName('VALOR').Value := aPedido.valor;
    StoredProc.ParamByName('VALORFRETE').Value := aPedido.valorfrete;
    StoredProc.ParamByName('DATAENTREGA').Value := aPedido.dataEntrega;
    StoredProc.ParamByName('CODIGOCLIENTE').Value := CodigoCliente;
    StoredProc.ParamByName('CODIGOAPP').Value := aPedido.codigoPedido;
    StoredProc.ParamByName('VALORPAGO').Value := aPedido.valorPagar;
    StoredProc.ParamByName('TIPOFRETE').Value := aPedido.tipoEntrega;
    StoredProc.Execute;
    CodigoPedido := StoredProc.ParamByName('CODIGOPEDIDO').AsString;
    if CodigoPedido <> EmptyStr then
    begin
      //Gravar Pedido item
      ListaPedidoItem :=  TDaoPedidoItens
                          .New
                          .CodigoPedido(IntToStr(aPedido.codigoPedido))
                          .CodigoEmpresa(CodigoEmpresa)
                          .BaseURL(Rota)
                          .GetPedidoItens(Token);
      for aPedidoItem in ListaPedidoItem do
      begin
        StoredProc.Close;
        StoredProc.StoredProcName := 'SP_INCLUI_PEDIDOITEM_APP';
        StoredProc.Prepare;
        StoredProc.ParamByName('codigoProduto').Value := aPedidoItem.codigoProduto;
        StoredProc.ParamByName('QUANTIDADE').Value := aPedidoItem.quantidade;
        StoredProc.ParamByName('VALOR_UNITARIO').Value := aPedidoItem.valorUnidade;
        StoredProc.ParamByName('VALOR_TOTAL').Value := aPedidoItem.valorTotal;
        StoredProc.ParamByName('CODIGOPEDIDO').Value := CodigoPedido;
        StoredProc.ParamByName('ITEM').Value := aPedidoItem.item;
        StoredProc.Execute;
      end;

      //Gravar Pedido Numerario
      ListaPedidoNumerario :=  TDAOPedidoNumerario
                                .New
                                .CodigoPedido(IntToStr(aPedido.codigoPedido))
                                .CodigoEmpresa(CodigoEmpresa)
                                .BaseURL(Rota)
                                .GetPedidoNumerario(Token);
      for aPedidoNumerario in ListaPedidoNumerario do
      begin
        StoredProc.Close;
        StoredProc.StoredProcName := 'SP_INCLUI_PEDIDONUMERARIO_APP';
        StoredProc.Prepare;
        StoredProc.ParamByName('CODIGONUMERARIO').Value := aPedidoNumerario.codigoNumerario;
        StoredProc.ParamByName('CODIGOPEDIDO').Value := CodigoPedido;
        StoredProc.ParamByName('ITEM').Value := aPedidoNumerario.item;
        StoredProc.Execute;
      end;
    end;
    TDaoPedido
      .New
      .BaseURL(Rota)
      .CodigoPedido(IntToStr(aPedido.codigoPedido))
      .CodPedidoRetorno(CodigoPedido)
      .Status('R')
      .PutPedido(Token);
  end;

end;

end.
