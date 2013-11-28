unit UDefinicoes;

interface

type
   TTipoBanco = (tbSQLServer, tbFirebird, tbInterbase);
   TTipoCampo = (tcUnknown, tcBigInt, tcInteger,
                 tcNumeric, tcDecimal, tcDate,
                 tcTime, tcDateTime, tcTimeStamp,
                 tcVarchar, tcChar, tcSmallInt,
                 tcBit);
implementation

end.
