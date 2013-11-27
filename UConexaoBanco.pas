unit UConexaoBanco;

interface

uses Classes, SqlExpr, UDefinicoes;

type
   TConexaoBanco = class
   private
      FCaminhoServidor: String;
      FUsuario: String;
      FSenha: String;

      function GetConexaoConfigurada: TSQLConnection; virtual; abstract;
   public
      constructor Create(CaminhoServidor, Usuario, Senha: String);
      function GetConexaoBanco: TSQLConnection;
end;

type
   TConexaoBancoFirebird = class(TConexaoBanco)
   private
      function GetConexaoConfigurada: TSQLConnection;   override;
end;

type
   TConexaoBancoSqlServer = class(TConexaoBanco)
   private
      function GetConexaoConfigurada: TSQLConnection;  override;
end;

type
   TConexaoBancoFactory = class
   public
      class function CriarConexaoBanco(CaminhoServidor, Usuario, Senha: String; TipoBanco: TTipoBanco): TSQLConnection;
end;

implementation

{ TConexaoBanco }

constructor TConexaoBanco.Create(CaminhoServidor, Usuario, Senha: String);
begin
   FCaminhoServidor := CaminhoServidor;
   FUsuario := Usuario;
   FSenha := Senha;
end;

function TConexaoBanco.GetConexaoBanco: TSQLConnection;
begin
   Result := GetConexaoConfigurada;
end;

{ TConexaoBancoFirebird }

function TConexaoBancoFirebird.GetConexaoConfigurada: TSQLConnection;
begin
   Result := TSQLConnection.Create(nil);

   Result.ConnectionName := 'IBConnection';
   Result.DriverName := 'Firebird';
   Result.GetDriverFunc := 'getSQLDriverINTERBASE';
   Result.LibraryName := 'dbexpint.dll';
   Result.VendorLib := 'gds32.dll';

   Result.Params.Clear;
   Result.Params.Values['Database'] := FCaminhoServidor;
   Result.Params.Values['User_Name'] := FUsuario;
   Result.Params.Values['Password'] := FSenha;
   Result.Params.Values['SQLDialect'] := '3';
end;

{ TConexaoBancoFactory }

class function TConexaoBancoFactory.CriarConexaoBanco(CaminhoServidor,
  Usuario, Senha: String; TipoBanco: TTipoBanco): TSQLConnection;
var
   ConexaoBanco: TConexaoBanco;
begin
   case TipoBanco of
      tbFirebird:
      begin
         ConexaoBanco := TConexaoBancoFirebird.Create(CaminhoServidor, Usuario, Senha);
         Result := ConexaoBanco.GetConexaoBanco;
      end;
      tbSQLServer:
      begin
         ConexaoBanco := TConexaoBancoSqlServer.Create(CaminhoServidor, Usuario, Senha);
         Result := ConexaoBanco.GetConexaoBanco;
      end;
      tbInterbase:
      begin

      end;
   end;
end;

{ TConexaoBancoSqlServer }

function TConexaoBancoSqlServer.GetConexaoConfigurada: TSQLConnection;
begin
   Result := TSQLConnection.Create(nil);

   Result.ConnectionName := 'MSSQLConnection';
   Result.DriverName := 'MSSQL';
   Result.GetDriverFunc := 'getSQLDriverMSSQL';
   Result.LibraryName := 'dbexpmss.dll';
   Result.VendorLib := 'oledb';

   Result.Params.Clear;
   Result.Params.Values['Database'] := FCaminhoServidor;
   Result.Params.Values['User_Name'] := FUsuario;
   Result.Params.Values['Password'] := FSenha;
end;

end.
