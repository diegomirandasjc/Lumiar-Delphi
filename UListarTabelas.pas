unit UListarTabelas;

interface

uses Classes, UConexaoBanco, UDefinicoes, SqlExpr, DB, DBClient, SysUtils;

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

type
   TListarTabelasSQLServer = class(TListarTabelas)
   private
      procedure PreencherTabelas; override;
end;


implementation

{ TListarTabelas }

constructor TListarTabelas.Create(Conexao: TSQLConnection);
begin
   FConexao := Conexao;

   CriarClientDataSetTabelas;
end;

procedure TListarTabelas.CriarClientDataSetTabelas;
begin
   FTabelas := TClientDataSet.Create(nil);

   FTabelas.FieldDefs.Add('Codigo', ftInteger);
   FTabelas.FieldDefs.Add('NomeTabela', ftString, 100);
   FTabelas.FieldDefs.Add('Descricao', ftString, 8000);

   FTabelas.CreateDataSet;
end;

destructor TListarTabelas.Destroy;
begin
   FreeAndNil(FTabelas);
   FreeAndNil(FConexao);
end;

function TListarTabelas.TabelasBanco: TClientDataSet;
begin
   PreencherTabelas;
end;

{ TListarTabelasSQLServer }

procedure TListarTabelasSQLServer.PreencherTabelas;
var
   QueryAux: TSQLQuery;
   
   function GetSQLTabelasBanco: String;
   begin
      Result := 'SELECT ID, '+ #13#10 +
                '       NAME '+ #13#10 +
                '  FROM SYSOBJECTS '+ #13#10 +
                ' WHERE XTYPE='+#39+'U'+#39;
   end;

   procedure PreencherCamposDataSet;
   begin
      FTabelas.Insert;
      FTabelas.FieldByName('Codigo').AsInteger := QueryAux.FieldByName('ID').AsInteger;
      FTabelas.FieldByName('NomeTabela').AsString := QueryAux.FieldByName('NAME').AsString;
      FTabelas.Post;
   end;
begin
   try
      QueryAux := TSQLQuery.Create(nil);
      QueryAux.SQLConnection := FConexao;

      QueryAux.SQL.Text := GetSQLTabelasBanco;
      QueryAux.Open;
      
      while not QueryAux.Eof do
      begin
         PreencherCamposDataSet;

         QueryAux.Next;
      end;
   finally
      FreeAndNil(QueryAux);
   end;
end;

end.
