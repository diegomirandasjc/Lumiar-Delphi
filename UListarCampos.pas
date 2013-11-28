unit UListarCampos;

interface

uses Classes, UConexaoBanco, UDefinicoes, SqlExpr, DB, DBClient, SysUtils;

type
   TListarCampos = class
   private
      FConexao: TSQLConnection;
      FTabelas: TClientDataSet;

      procedure CriarClientDataSetCampos;
      function GetSQLCampos: String; virtual; abstract;
   public
      constructor Create(Conexao: TSQLConnection);
      destructor Destroy;

      function TabelasBanco: TClientDataSet;
end;

type
   TListarCamposSQLServer = class(TListarCampos)
   private
      function GetSQLCampos: String; override;
end;

type
   TListarCamposFirebird = class(TListarCampos)
   private
      function GetSQLCampos: String; override;
end;

type
   TListarCamposInterbase = class(TListarCampos)
   private
      function GetSQLCampos: String; override;
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
   FTabelas.FieldDefs.Add('NomeCampo', ftString, 100);
   FTabelas.FieldDefs.Add('Descricao', ftString, 8000);
   FTabelas.FieldDefs.Add('Tamanho', ftInteger);
   FTabelas.FieldDefs.Add('Precisao', ftInteger);
   FTabelas.FieldDefs.Add('Obrigatorio', ftBoolean);

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
      QueryAux.SQL.Text := GetSQLCampos;
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

function TListarCamposSQLServer.GetSQLCampos: String;
begin
   Result := 'SELECT ID, '+ #13#10 +
             '       NAME as NOMETABELA'+ #13#10 +
             '  FROM SYSOBJECTS '+ #13#10 +
             ' WHERE XTYPE='+#39+'U'+#39;
end;

{ TListarCamposInterbase }

function TListarCamposInterbase.GetSQLCampos: String;
begin
   Result := 'SELECT A.RDB$FIELD_NAME NOMECAMPO,' + #13#10 +
             '       C.RDB$TYPE_NAME TIPO,' + #13#10 +
             '       B.RDB$FIELD_LENGTH TAMANHO,' + #13#10 +
             '       B.RDB$FIELD_PRECISION PRECISAO,' + #13#10 +
             '       B.RDB$FIELD_SCALE CASASDECIMAIS,' + #13#10 +
             '       A.RDB$NULL_FLAG OBRIGATORIO' + #13#10 +
             '  FROM RDB$RELATION_FIELDS A' + #13#10 +
             ' INNER JOIN RDB$FIELDS B' + #13#10 +
             '    ON B.RDB$FIELD_NAME = A.RDB$FIELD_SOURCE' + #13#10 +
             ' INNER JOIN RDB$TYPES C' + #13#10 +
             '    ON C.RDB$TYPE = B.RDB$FIELD_TYPE' + #13#10 +
             '   AND C.RDB$FIELD_NAME = ''RDB$FIELD_TYPE''' + #13#10 +
             ' WHERE A.RDB$RELATION_NAME = ''CAMPOS''';
end;

{ TListarCamposFirebird }

function TListarCamposFirebird.GetSQLCampos: String;
begin
   Result := 'SELECT A.RDB$FIELD_NAME NOMECAMPO,' + #13#10 +
             '       C.RDB$TYPE_NAME TIPO,' + #13#10 +
             '       B.RDB$FIELD_LENGTH TAMANHO,' + #13#10 +
             '       B.RDB$FIELD_PRECISION PRECISAO,' + #13#10 +
             '       B.RDB$FIELD_SCALE CASASDECIMAIS,' + #13#10 +
             '       A.RDB$NULL_FLAG OBRIGATORIO' + #13#10 +
             '  FROM RDB$RELATION_FIELDS A' + #13#10 +
             ' INNER JOIN RDB$FIELDS B' + #13#10 +
             '    ON B.RDB$FIELD_NAME = A.RDB$FIELD_SOURCE' + #13#10 +
             ' INNER JOIN RDB$TYPES C' + #13#10 +
             '    ON C.RDB$TYPE = B.RDB$FIELD_TYPE' + #13#10 +
             '   AND C.RDB$FIELD_NAME = ''RDB$FIELD_TYPE''' + #13#10 +
             ' WHERE A.RDB$RELATION_NAME = ''CAMPOS''';
end;


end.

