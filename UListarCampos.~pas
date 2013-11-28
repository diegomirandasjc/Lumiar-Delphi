unit UListarCampos;

interface

uses Classes, UConexaoBanco, UDefinicoes, SqlExpr, DB, DBClient, SysUtils;

type
   TListarCampos = class
   private
      FConexao: TSQLConnection;
      FTabelas: TClientDataSet;

      procedure CriarClientDataSetCampos;
      function GetSQLNomeTabelas: String; virtual; abstract;
   public
      constructor Create(Conexao: TSQLConnection);
      destructor Destroy;

      function TabelasBanco: TClientDataSet;
end;

type
   TListarCamposSQLServer = class(TListarCampos)
   private
      function GetSQLNomeTabelas: String; override;
end;

type
   TListarCamposFirebird = class(TListarCampos)
   private
      function GetSQLNomeTabelas: String; override;
end;

type
   TListarCamposInterbase = class(TListarCampos)
   private
      function GetSQLNomeTabelas: String; override;
end;
implementation

{ TListarCampos }

constructor TListarCampos.Create(Conexao: TSQLConnection);
begin
   FConexao := Conexao;

   CriarClientDataSetCampos;
end;

procedure TListarCampos.CriarClientDataSetCampos;
begin
   FTabelas := TClientDataSet.Create(nil);

   FTabelas.FieldDefs.Add('Codigo', ftInteger);
   FTabelas.FieldDefs.Add('NomeTabela', ftString, 100);
   FTabelas.FieldDefs.Add('Descricao', ftString, 8000);

   FTabelas.CreateDataSet;
end;

destructor TListarCampos.Destroy;
begin
   FreeAndNil(FTabelas);
   FreeAndNil(FConexao);
end;

function TListarCampos.TabelasBanco: TClientDataSet;
var
   QueryAux: TSQLQuery;
   
   procedure PreencherCamposDataSet;
   begin
      FTabelas.Insert;
      FTabelas.FieldByName('Codigo').AsInteger := QueryAux.FieldByName('ID').AsInteger;
      FTabelas.FieldByName('NomeTabela').AsString := QueryAux.FieldByName('NOMETABELA').AsString;
      FTabelas.Post;
   end;
begin
   try
      QueryAux := TSQLQuery.Create(nil);
      QueryAux.SQLConnection := FConexao;
      QueryAux.SQL.Text := GetSQLNomeTabelas;
      QueryAux.Open;

      while not QueryAux.Eof do
      begin
         PreencherCamposDataSet;

         QueryAux.Next;
      end;
   finally
      FreeAndNil(QueryAux);
   end;

   Result := FTabelas;
end;

{ TListarCamposSQLServer }

function TListarCamposSQLServer.GetSQLNomeTabelas: String;
begin
   Result := 'SELECT ID, '+ #13#10 +
             '       NAME as NOMETABELA'+ #13#10 +
             '  FROM SYSOBJECTS '+ #13#10 +
             ' WHERE XTYPE='+#39+'U'+#39;
end;

{ TListarCamposInterbase }

function TListarCamposInterbase.GetSQLNomeTabelas: String;
begin
   Result := 'SELECT RDB$RELATION_ID as ID,' + #13#10 + 
                '       RDB$RELATION_NAME as NOMETABELA' + #13#10 +
                '  FROM RDB$RELATIONS' + #13#10 +
                ' WHERE RDB$VIEW_BLR IS NULL' + #13#10 +
                '   AND (RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL)';
end;

{ TListarCamposFirebird }

function TListarCamposFirebird.GetSQLNomeTabelas: String;
begin
   Result := 'SELECT RDB$RELATION_ID as ID,' + #13#10 + 
             '       RDB$RELATION_NAME as NOMETABELA' + #13#10 +
             '  FROM RDB$RELATIONS' + #13#10 +
             ' WHERE RDB$VIEW_BLR IS NULL' + #13#10 +
             '   AND (RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL)';
end;


end.

