unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBXpress, DB, SqlExpr, UConexaoBanco, StdCtrls, UDefinicoes,
  DBClient, UListarTabelas, FMTBcd;

type
  TForm1 = class(TForm)
    SQLConnection1: TSQLConnection;
    Button1: TButton;
    ClientDataSet1: TClientDataSet;
    qry1: TSQLQuery;
    qry1_BIGINT: TFMTBCDField;
    qry1_INTEIRO: TIntegerField;
    qry1_NUMERIC: TFMTBCDField;
    qry1_DOUBLE: TBCDField;
    qry1_DATE: TStringField;
    qry1_TIME: TStringField;
    qry1_DATETIME: TSQLTimeStampField;
    qry1_TIMESTAMP: TVarBytesField;
    qry1_CHAR: TStringField;
    qry1_VARCHAR: TStringField;
    qry1_SMALLINT: TSmallintField;
    qry1_BIT: TBooleanField;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
   Tabelas: TListarTabelasSQLServer;
   Dados: TClientDataSet;
begin
   SQLConnection1 := TConexaoBancoFactory.CriarConexaoBanco('localhost\SQL2012', 'testemvc', 'sa', 'm@ster123', tbSQLServer) ;
   SQLConnection1.Open;

end;

end.                                                                                   
