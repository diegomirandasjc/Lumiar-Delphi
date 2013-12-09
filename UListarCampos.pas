unit UListarCampos;

interface

uses Classes, UConexaoBanco, UDefinicoes, SqlExpr, DB, DBClient, SysUtils;

type
   TListarCampos = class
   private
      FConexao: TSQLConnection;
      FCampos: TClientDataSet;
      FQueryAux: TSQLQuery;
      
      procedure CriarClientDataSetCampos;
      procedure CriarObjetosAuxiliares;
      procedure PreencherCamposDataSet;
      procedure MarcarCampoDataSetChavePrimaria;
      function GetSQLCampos: String; virtual; abstract;
      function GetTipo: TTipoCampo; virtual; abstract;
      function GetTamanho: Integer; virtual; abstract;
      function GetPrecisao: Integer; virtual; abstract;
      procedure MarcarChavesPrimarias(NomeTabela: String);
      function GetSQLCamposChavesPrimarias: String; virtual; abstract;
   public
      constructor Create(Conexao: TSQLConnection);
      destructor Destroy;

      function CamposTabela(NomeTabela: String): TClientDataSet;
end;

type
   TListarCamposSQLServer = class(TListarCampos)
   private
      function GetSQLCampos: String; override;
      function GetTipo: TTipoCampo; override;
      function GetTamanho: Integer; override;
      function GetPrecisao: Integer; override;
      function GetSQLCamposChavesPrimarias: String; override;
end;

type
   TListarCamposFirebird = class(TListarCampos)
   private
      function GetSQLCampos: String; override;
      function GetTipo: TTipoCampo; override;
      function GetTamanho: Integer; override;
      function GetPrecisao: Integer; override;
      function GetSQLCamposChavesPrimarias: String; override;
end;

type
   TListarCamposInterbase = class(TListarCampos)
   private
      function GetSQLCampos: String; override;
      function GetTipo: TTipoCampo; override;
      function GetTamanho: Integer; override;
      function GetPrecisao: Integer; override;
      function GetSQLCamposChavesPrimarias: String; override;
end;

implementation

{ TListarCampos }

constructor TListarCampos.Create(Conexao: TSQLConnection);
begin
   FConexao := Conexao;

   CriarClientDataSetCampos;
   CriarObjetosAuxiliares;
end;

procedure TListarCampos.CriarClientDataSetCampos;
begin
   FCampos := TClientDataSet.Create(nil);

   FCampos.FieldDefs.Add('Codigo', ftInteger);
   FCampos.FieldDefs.Add('NomeCampo', ftString, 100);
   FCampos.FieldDefs.Add('Descricao', ftString, 8000);
   FCampos.FieldDefs.Add('Tipo', ftSmallint);
   FCampos.FieldDefs.Add('Tamanho', ftInteger);
   FCampos.FieldDefs.Add('ValorMaximo', ftInteger);
   FCampos.FieldDefs.Add('ValorMinimo', ftInteger);
   FCampos.FieldDefs.Add('Precisao', ftInteger);
   FCampos.FieldDefs.Add('Obrigatorio', ftBoolean);
   FCampos.FieldDefs.Add('ChavePrimaria', ftBoolean);


   FCampos.CreateDataSet;
end;

procedure TListarCampos.CriarObjetosAuxiliares;
begin
   FQueryAux := TSQLQuery.Create(nil);
   FQueryAux.SQLConnection := FConexao;
end;

destructor TListarCampos.Destroy;
begin
   FreeAndNil(FCampos);
   FreeAndNil(FQueryAux);
   FreeAndNil(FConexao);
end;

procedure TListarCampos.PreencherCamposDataSet;
begin
   FCampos.Insert;
   FCampos.FieldByName('Codigo').AsInteger        := FQueryAux.FieldByName('ID').AsInteger;
   FCampos.FieldByName('NomeCampo').AsString      := FQueryAux.FieldByName('NOMECAMPO').AsString;
   FCampos.FieldByName('Descricao').AsString      := FQueryAux.FieldByName('TIPO').AsString;
   FCampos.FieldByName('Tipo').AsInteger          := Integer(GetTipo);
   FCampos.FieldByName('Tamanho').AsInteger       := GetTamanho;
   FCampos.FieldByName('ValorMaximo').AsInteger   := 0;
   FCampos.FieldByName('ValorMinimo').AsInteger   := 0;
   FCampos.FieldByName('Precisao').AsInteger      := GetPrecisao;
   FCampos.FieldByName('Obrigatorio').AsBoolean   := FQueryAux.FieldByName('OBRIGATORIO').AsBoolean;
   FCampos.FieldByName('ChavePrimaria').AsBoolean := False;
   FCampos.Post;
end;

function TListarCampos.CamposTabela(NomeTabela: String): TClientDataSet;
begin
   try
      FQueryAux.SQL.Text := GetSQLCampos;
      FQueryAux.ParamByName('NOMETABELA').AsString := NomeTabela;
      FQueryAux.Open;

      while not FQueryAux.Eof do
      begin
         PreencherCamposDataSet;

         FQueryAux.Next;
      end;

//      MarcarChavesPrimarias(NomeTabela);
   finally
      FQueryAux.Close;
   end;

   Result := FCampos;
end;

procedure TListarCampos.MarcarChavesPrimarias(NomeTabela: String);
begin
  try
      FQueryAux.SQL.Text := GetSQLCamposChavesPrimarias;
      FQueryAux.ParamByName('NOMETABELA').AsString := NomeTabela;
      FQueryAux.Open;

      while not FQueryAux.Eof do
      begin
         MarcarCampoDataSetChavePrimaria;

         FQueryAux.Next;
      end;
   finally
      FQueryAux.Close;
   end;
end;

procedure TListarCampos.MarcarCampoDataSetChavePrimaria;
var
   i: Integer;
begin
   If (FCampos.Locate('NomeCampo', FQueryAux.Fields[0].AsString, [loPartialKey])) Then
   begin
      FCampos.Edit;
      FCampos.FieldByName('ChavePrimaria').AsBoolean := True;
      FCampos.Post;
   end;
end;

{ TListarCamposSQLServer }

function TListarCamposSQLServer.GetPrecisao: Integer;
begin
   Result := Round(Abs(FQueryAux.FieldByName('PRECISAO').AsFloat));
end;

function TListarCamposSQLServer.GetSQLCampos: String;
begin
   Result := 'SELECT C.column_id as ID, ' + #13#10 +
             '       C.[name] AS [NOMECAMPO],' + #13#10 + 
             '       TI.name AS [TIPO],' + #13#10 +
             '       C.[max_length] AS [TAMANHO],' + #13#10 +
             '       C.[precision] AS [PRECISAO],' + #13#10 +
             '       C.[scale] AS [CASASDECIMAIS],' + #13#10 +
             '       CASE WHEN C.[is_nullable] IS NULL THEN' + #13#10 +
             '          1' + #13#10 +
             '       ELSE' + #13#10 +
             '          0' + #13#10 +
             '       END AS OBRIGATORIO' + #13#10 +
             '  FROM sys.[tables] T' + #13#10 +
             ' INNER JOIN sys.[all_columns] C' + #13#10 +
             '    ON T.[object_id] = C.[object_id]' + #13#10 +
             '   AND T.name = ''ALUNO''' + #13#10 +
             ' INNER JOIN sys.[types] TI' + #13#10 +
             '    ON C.[system_type_id] = TI.[system_type_id]' + #13#10 +
             '   AND C.[user_type_id] = TI.[user_type_id]';
end;


function TListarCamposSQLServer.GetSQLCamposChavesPrimarias: String;
begin
   Result :=  'SELECT COLUMN_NAME as CAMPO' + #13#10 +
              '  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE' + #13#10 +
              ' WHERE TABLE_NAME = :NOMETABELA';
end;

function TListarCamposSQLServer.GetTamanho: Integer;
begin
   Case GetTipo of
      tcVarchar, tcChar:
      begin
         Result := FQueryAux.FieldByName('TAMANHO').AsInteger;
      end;

      tcInteger, tcNumeric, tcDecimal,
      tcBigInt, tcSmallInt, tcDate,
      tcTime:
      begin
         Result := FQueryAux.FieldByName('PRECISAO').AsInteger;
      end;

      tcTimeStamp, tcDateTime:
      begin
         Result := 23;
      end;
   end;
end;

function TListarCamposSQLServer.GetTipo: TTipoCampo;
begin
   Result := tcUnknown;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString)= 'BIGINT') then
   begin
      Result := tcBigInt;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'INT') then
   begin
      Result := tcInteger;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'NUMERIC') then
   begin
      Result := tcNumeric;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'DECIMAL') then
   begin
      Result := tcDecimal;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'DATE') then
   begin
      Result := tcDate;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'TIME') then
   begin
      Result := tcTime;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'DATETIME') then
   begin
      Result := tcDateTime;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'DATETIME') then
   begin
      Result := tcDateTime;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'TIMESTAMP') then
   begin
      Result := tcTimeStamp;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'CHAR') then
   begin
      Result := tcChar;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'VARCHAR') then
   begin
      Result := tcVarchar;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'SMALLINT') then
   begin
      Result := tcSmallInt;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'BIT') then
   begin
      Result := tcBit;
   end;
end;

{ TListarCamposInterbase }

function TListarCamposInterbase.GetPrecisao: Integer;
begin
   Result := Round(Abs(FQueryAux.FieldByName('PRECISAO').AsFloat));
end;

function TListarCamposInterbase.GetSQLCampos: String;
begin
   Result := 'SELECT A.RDB$FIELD_ID ID,' + #13#10 +
             '       A.RDB$FIELD_NAME NOMECAMPO,' + #13#10 +
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
             ' WHERE A.RDB$RELATION_NAME = :NOMETABELA';
end;

function TListarCamposInterbase.GetSQLCamposChavesPrimarias: String;
begin
   Result := 'SELECT RDB$FIELD_NAME as CAMPO' + #13#10 +
             '  FROM RDB$RELATION_CONSTRAINTS C, RDB$INDEX_SEGMENTS S' + #13#10 +
             ' WHERE C.RDB$RELATION_NAME = :NOMETABELA' + #13#10 +
             '   AND C.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY''' + #13#10 +
             '   AND S.RDB$INDEX_NAME = C.RDB$INDEX_NAME' + #13#10 +
             ' ORDER BY RDB$FIELD_POSITION';
end;

function TListarCamposInterbase.GetTamanho: Integer;
begin
   Case GetTipo of
      tcVarchar, tcChar:
      begin
         Result := FQueryAux.FieldByName('TAMANHO').AsInteger;
      end;

      tcInteger:
      begin
         Result := 10;
      end;

      tcSmallInt:
      begin
         Result := 4;
      end;

      tcTimeStamp, tcDateTime:
      begin
         Result := 23;
      end;

      tcTime:
      begin
         Result := 8;
      end;

      tcDate:
      begin
         Result := 10;
      end;

      tcBigInt:
      begin
         Result := 19;
      end;

      tcNumeric:
      begin
         Result := FQueryAux.FieldByName('PRECISAO').AsInteger;
      end;
   end;
end;

function TListarCamposInterbase.GetTipo: TTipoCampo;
begin
   Result := tcUnknown;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString)= 'TEXT') then
   begin
      Result := tcChar;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'SHORT') then
   begin
      Result := tcSmallInt;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'LONG') then
   begin
      Result := tcInteger;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'TIMESTAMP') then
   begin
      Result := tcTimeStamp;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'VARYING') then
   begin
      Result := tcVarchar;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'TIME') then
   begin
      Result := tcTime;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'INT64') then
   begin
      if (FQueryAux.FieldByName('PRECISAO').AsInteger = 0) then
      begin
         Result := tcBigInt;
      end
      else
      begin
         Result := tcNumeric;
      end;
   end;
end;

{ TListarCamposFirebird }

function TListarCamposFirebird.GetPrecisao: Integer;
begin
   Result := Round(Abs(FQueryAux.FieldByName('PRECISAO').AsFloat));
end;

function TListarCamposFirebird.GetSQLCampos: String;
begin
   Result := 'SELECT A.RDB$FIELD_ID ID,' + #13#10 +
             '       A.RDB$FIELD_NAME NOMECAMPO,' + #13#10 +
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
             ' WHERE A.RDB$RELATION_NAME = :NOMETABELA';
end;

function TListarCamposFirebird.GetSQLCamposChavesPrimarias: String;
begin
   Result := 'SELECT RDB$FIELD_NAME as CAMPO' + #13#10 +
             '  FROM RDB$RELATION_CONSTRAINTS C, RDB$INDEX_SEGMENTS S' + #13#10 +
             ' WHERE C.RDB$RELATION_NAME = :NOMETABELA' + #13#10 +
             '   AND C.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY''' + #13#10 +
             '   AND S.RDB$INDEX_NAME = C.RDB$INDEX_NAME' + #13#10 +
             ' ORDER BY RDB$FIELD_POSITION';
end;

function TListarCamposFirebird.GetTamanho: Integer;
begin
   Case GetTipo of
      tcVarchar, tcChar:
      begin
         Result := FQueryAux.FieldByName('TAMANHO').AsInteger;
      end;

      tcInteger:
      begin
         Result := 10;
      end;

      tcSmallInt:
      begin
         Result := 4;
      end;

      tcTimeStamp, tcDateTime:
      begin
         Result := 23;
      end;

      tcTime:
      begin
         Result := 8;
      end;

      tcDate:
      begin
         Result := 10;
      end;

      tcBigInt:
      begin
         Result := 19;
      end;

      tcNumeric:
      begin
         Result := FQueryAux.FieldByName('PRECISAO').AsInteger;
      end;
   end;
end;

function TListarCamposFirebird.GetTipo: TTipoCampo;
begin
   Result := tcUnknown;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString)= 'TEXT') then
   begin
      Result := tcChar;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'SHORT') then
   begin
      Result := tcSmallInt;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'LONG') then
   begin
      Result := tcInteger;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'TIMESTAMP') then
   begin
      Result := tcTimeStamp;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'VARYING') then
   begin
      Result := tcVarchar;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'TIME') then
   begin
      Result := tcTime;
   end;

   if (UpperCase(FQueryAux.FieldByName('TIPO').AsString) = 'INT64') then
   begin
      if (FQueryAux.FieldByName('PRECISAO').AsInteger = 0) then
      begin
         Result := tcBigInt;
      end
      else
      begin
         Result := tcNumeric;
      end;
   end;
end;


end.

