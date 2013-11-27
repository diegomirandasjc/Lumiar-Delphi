unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBXpress, DB, SqlExpr, UConexaoBanco, StdCtrls, UDefinicoes,
  DBClient, UListarTabelas;

type
  TForm1 = class(TForm)
    SQLConnection1: TSQLConnection;
    Button1: TButton;
    ClientDataSet1: TClientDataSet;
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
   
   Tabelas := TListarTabelasSQLServer.Create(SQLConnection1);
   Dados := Tabelas.TabelasBanco;

   while not Dados.Eof do
   begin
      ShowMessage(Dados.FieldByName('NomeTabela').AsString);
      Dados.Next;
   end;
end;

end.
