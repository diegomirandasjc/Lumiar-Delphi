unit UUtilitarioBancoDados;

interface

uses Classes, SqlExpr, UDefinicoes;

type
   TBancoDados = class
   private
      FConexao: TSQLConnection;
      FTipoBanco: TTipoBanco;

      procedure CriarConexaoBanco;
   public
      constructor Create(CaminhoServidor, Usuario, Senha: String; TipoBanco: TTipoBanco);
      destructor Destroy;  override;
end;

implementation

uses SysUtils;

{ TBancoDados }

constructor TBancoDados.Create(CaminhoServidor, Usuario, Senha: String;
  TipoBanco: TTipoBanco);
begin
   FTipoBanco := TipoBanco;

   CriarConexaoBanco;
end;

procedure TBancoDados.CriarConexaoBanco;
begin
   FConexao := TSQLConnection.Create(nil);
end;

destructor TBancoDados.Destroy;
begin
   inherited;

   FreeAndNil(FConexao);
end;

end.
