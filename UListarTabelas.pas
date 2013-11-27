unit UListarTabelas;

interface

uses Classes, UConexaoBanco, UDefinicoes, SqlExpr, DB, DBClient, SysUtils;

implementation

uses StdConvs;

type
   TListarTabelas = class
   private
      FConexao: TSQLConnection;
      FTabelas: TClientDataSet;

      procedure CriarClientDataSetTabelas;
      procedure PreencherTabelas; virtual; abstract;
   public
      constructor Create(Conexao: TSQLConnection);
      destructor Destroy;

      function TabelasBanco: TClientDataSet;
end;


{ TListarTabelas }

constructor TListarTabelas.Create(Conexao: TSQLConnection);
begin
   CriarClientDataSetTabelas;
end;

procedure TListarTabelas.CriarClientDataSetTabelas;
begin
   FTabelas := TClientDataSet.Create(nil);

   FTabelas.FieldDefs.Add('Codigo', ftInteger);
   FTabelas.FieldDefs.Add('NomeTabela', ftString, 100);
   FTabelas.FieldDefs.Add('Descricao', ftInteger, 8000);

   FTabelas.CreateDataSet;
end;

destructor TListarTabelas.Destroy;
begin
   FreeAndNil(FTabelas);
end;

function TListarTabelas.TabelasBanco: TClientDataSet;
begin
   PreencherTabelas;
end;

end.
