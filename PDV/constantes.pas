unit Constantes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

  type
  TConstantes = class
  const
    {$WRITEABLECONST ON}
    DECIMAIS_QUANTIDADE:Integer = 3;
    DECIMAIS_VALOR:Integer = 2;
    EMPRESA_BALCAO:Integer = 1;
    {$WRITEABLECONST OFF}
  end;

implementation

end.

