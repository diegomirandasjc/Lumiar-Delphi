object Form1: TForm1
  Left = 192
  Top = 124
  Width = 292
  Height = 533
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 104
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object SQLConnection1: TSQLConnection
    ConnectionName = 'MSSQLConnection'
    DriverName = 'MSSQL'
    GetDriverFunc = 'getSQLDriverMSSQL'
    LibraryName = 'dbexpmss.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MSSQL'
      'HostName=pro26\SQL2012'
      'DataBase=testemvc'
      'User_Name=sa'
      'Password=m@ster123'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'MSSQL TransIsolation=ReadCommited'
      'OS Authentication=False')
    VendorLib = 'sqloledb.dll'
    Connected = True
    Left = 200
    Top = 48
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 16
  end
  object qry1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'Select * from teste')
    SQLConnection = SQLConnection1
    Left = 192
    Top = 168
    object qry1_BIGINT: TFMTBCDField
      FieldName = '_BIGINT'
      Precision = 19
      Size = 0
    end
    object qry1_INTEIRO: TIntegerField
      FieldName = '_INTEIRO'
    end
    object qry1_NUMERIC: TFMTBCDField
      FieldName = '_NUMERIC'
      Precision = 15
      Size = 2
    end
    object qry1_DOUBLE: TBCDField
      FieldName = '_DOUBLE'
      Precision = 5
      Size = 1
    end
    object qry1_DATE: TStringField
      FieldName = '_DATE'
      Size = 10
    end
    object qry1_TIME: TStringField
      FieldName = '_TIME'
      Size = 8
    end
    object qry1_DATETIME: TSQLTimeStampField
      FieldName = '_DATETIME'
    end
    object qry1_TIMESTAMP: TVarBytesField
      FieldName = '_TIMESTAMP'
      Size = 8
    end
    object qry1_CHAR: TStringField
      FieldName = '_CHAR'
      FixedChar = True
      Size = 1
    end
    object qry1_VARCHAR: TStringField
      FieldName = '_VARCHAR'
      FixedChar = True
      Size = 10
    end
    object qry1_SMALLINT: TSmallintField
      FieldName = '_SMALLINT'
    end
    object qry1_BIT: TBooleanField
      FieldName = '_BIT'
    end
  end
end
