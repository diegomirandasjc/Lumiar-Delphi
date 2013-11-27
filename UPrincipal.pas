unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBXpress, DB, SqlExpr, UConexaoBanco, StdCtrls, UDefinicoes;

type
  TForm1 = class(TForm)
    SQLConnection1: TSQLConnection;
    Button1: TButton;
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
begin
   SQLConnection1 := TConexaoBancoFactory.CriarConexaoBanco('localhost:c:\teste\teste.fdb', 'SYSDBA', 'masterkey', tbFirebird) ;

   ShowMessage(SQLConnection1.ConnectionName);
end;

end.
