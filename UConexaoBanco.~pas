unit UConexaoBanco;

interface

uses Classes, SqlExpr, UDefinicoes, SysUtils;

type
   TConexaoBanco = class
   private
      FServidor: String;
      FNomeBanco: String;
      FUsuario: String;
      FSenha: String;

      function GetConexaoConfigurada: TSQLConnection; virtual; abstract;
   public
      constructor Create(Servidor, NomeBanco, Usuario, Senha: String);
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
   TConexaoBancoInterbase = class(TConexaoBanco)
   private
      function GetConexaoConfigurada: TSQLConnection;  override;
end;

type
   TConexaoBancoFactory = class
   public
      class function CriarConexaoBanco(Servidor, NomeBanco, Usuario, Senha: String; TipoBanco: TTipoBanco): TSQLConnection;
end;

implementation

{ TConexaoBanco }

constructor TConexaoBanco.Create(Servidor, NomeBanco, Usuario, Senha: String);
begin
   FServidor := Servidor;
   FNomeBanco := NomeBanco;
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
   Result.Params.Values['Database'] := FServidor;
   Result.Params.Values['User_Name'] := FUsuario;
   Result.Params.Values['Password'] := FSenha;
   Result.Params.Values['SQLDialect'] := '3';
end;

{ TConexaoBancoFactory }

class function TConexaoBancoFactory.CriarConexaoBanco(Servidor, NomeBanco,
  Usuario, Senha: String; TipoBanco: TTipoBanco): TSQLConnection;
var
   ConexaoBanco: TConexaoBanco;
begin
   try
      case TipoBanco of
         tbFirebird:
         begin
            ConexaoBanco := TConexaoBancoFirebird.Create(Servidor, NomeBanco, Usuario, Senha);
         end;
         tbSQLServer:
         begin
            ConexaoBanco := TConexaoBancoSqlServer.Create(Servidor, NomeBanco, Usuario, Senha);
         end;
         tbInterbase:
         begin
            ConexaoBanco := TConexaoBancoInterbase.Create(Servidor, NomeBanco, Usuario, Senha);
         end;
      end;
      Result := ConexaoBanco.GetConexaoBanco;
   finally
      FreeAndNil(ConexaoBanco);
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
   Result.VendorLib := 'sqloledb.dll';

   Result.Params.Clear;
   Result.Params.Values['HostName'] := FServidor;
   Result.Params.Values['Database'] := FNomeBanco;
   Result.Params.Values['User_Name'] := FUsuario;
   Result.Params.Values['Password'] := FSenha;
end;

{ TConexaoBancoInterbase }

function TConexaoBancoInterbase.GetConexaoConfigurada: TSQLConnection;
begin
   Result := TSQLConnection.Create(nil);

   Result.ConnectionName := 'MSSQLConnection';
   Result.DriverName := 'MSSQL';
   Result.GetDriverFunc := 'getSQLDriverMSSQL';
   Result.LibraryName := 'dbexpmss.dll';
   Result.VendorLib := 'oledb';

   Result.Params.Clear;
   Result.Params.Values['Database'] := FServidor;
   Result.Params.Values['User_Name'] := FUsuario;
   Result.Params.Values['Password'] := FSenha;  
end;

end.
