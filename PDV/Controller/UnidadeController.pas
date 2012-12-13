unit UnidadeController;

interface

uses
  Classes, SQLExpr, SysUtils, UnidadeProdutoVO;

type
  TUnidadeController = class
  protected
  public
    class Function TabelaUnidade: TObjectList<TUnidadeProdutoVO>;
    class Function UnidadeSPED(pDataInicial, pDataFinal: String): TObjectList<TUnidadeProdutoVO>;
    class function ConsultaIdUnidade(Id: Integer): Boolean;
    class function GravaCargaUnidadeProduto(vTupla: String): Boolean;

  end;

implementation

uses UDataModule, Biblioteca;

var
  ConsultaSQL: String;
  Query: TSQLQuery;

class function TUnidadeController.TabelaUnidade: TObjectList<TUnidadeProdutoVO>;
var
  ListaUnidade: TObjectList<TUnidadeProdutoVO>;
  Unidade: TUnidadeProdutoVO;
begin
  try
    try
      ConsultaSQL := 'select * from UNIDADE_PRODUTO';
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.Open;

      ListaUnidade := TObjectList<TUnidadeProdutoVO>.Create;

      Query.First;
      while not Query.Eof do
      begin
        Unidade := TUnidadeProdutoVO.Create;
        Unidade.Id := Query.FieldByName('ID').AsInteger;
        Unidade.Nome := Query.FieldByName('NOME').AsString;
        Unidade.Descricao := Query.FieldByName('DESCRICAO').AsString;
        Unidade.PodeFracionar := Query.FieldByName('PODE_FRACIONAR').AsString;
        ListaUnidade.Add(Unidade);
        Query.next;
      end;
      result := ListaUnidade;
    except
      result := nil;
    end;
  finally
    Query.Free;
  end;
end;

class function TUnidadeController.UnidadeSPED(pDataInicial, pDataFinal: String): TObjectList<TUnidadeProdutoVO>;
var
  ListaUnidade: TObjectList<TUnidadeProdutoVO>;
  Unidade: TUnidadeProdutoVO;
  DataInicio, DataFim : String ;
begin
  try
    try
      DataInicio := QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(pDataInicial)));
      DataFim := QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(pDataFinal)));

      ConsultaSQL := 'SELECT distinct U.* '+
                     ' FROM UNIDADE_PRODUTO U, PRODUTO P, ECF_VENDA_CABECALHO V, ECF_VENDA_DETALHE D '+
                     ' WHERE V.DATA_VENDA BETWEEN '+DataInicio+' and '+DataFim+
                     ' AND P.ID_UNIDADE_PRODUTO=U.ID '+
                     ' AND V.ID=D.ID_ECF_VENDA_CABECALHO'+
                     ' AND D.ID_ECF_PRODUTO=P.ID';

      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.Open;

      ListaUnidade := TObjectList<TUnidadeProdutoVO>.Create;

      Query.First;
      while not Query.Eof do
      begin
        Unidade := TUnidadeProdutoVO.Create;
        Unidade.Id := Query.FieldByName('ID').AsInteger;
        Unidade.Nome := Query.FieldByName('NOME').AsString;
        Unidade.Descricao := Query.FieldByName('DESCRICAO').AsString;
        Unidade.PodeFracionar := Query.FieldByName('PODE_FRACIONAR').AsString;
        ListaUnidade.Add(Unidade);
        Query.next;
      end;
      result := ListaUnidade;

    except
      result := nil;
    end;
  finally
    Query.Free;
  end;
end;

class function TUnidadeController.ConsultaIdUnidade(Id:Integer):boolean;
begin
  ConsultaSQL := 'select ID from UNIDADE_PRODUTO where (ID = :pID) ';
  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.ParamByName('pID').AsInteger:=Id;
      Query.Open;
      if not Query.IsEmpty then
        result := true
      else
        result := false;
    except
    end;
  finally
    Query.Free;
  end;
end;



class function TUnidadeController.GravaCargaUnidadeProduto(vTupla: String): Boolean;
var ID: integer;
begin
  try
    try
      if FDataModule.BancoPAF = 'FIREBIRD' then
      begin
        ConsultaSQL := 'UPDATE OR INSERT INTO UNIDADE_PRODUTO ' +
                        ' (ID,'+
                        'NOME,'+
                        'DESCRICAO,'+
                        'PODE_FRACIONAR)'+
                        'values ('+
                        DevolveConteudoDelimitado('|',vTupla)+', '+  //    ID              INTEGER NOT NULL,
                        DevolveConteudoDelimitado('|',vTupla)+', '+  //    NOME            VARCHAR(10),
                        DevolveConteudoDelimitado('|',vTupla)+', '+  //    DESCRICAO       VARCHAR(250),
                        DevolveConteudoDelimitado('|',vTupla)+')';   //    PODE_FRACIONAR  CHAR(1)

      end
      else if FDataModule.BancoPAF = 'MYSQL' then
      begin
        ID := StrToInt(DevolveConteudoDelimitado('|',vTupla));            //    ID              INTEGER NOT NULL,

        if not ConsultaIdUnidade(ID) then
          ConsultaSQL :=
          ' INSERT INTO UNIDADE_PRODUTO ' +
          ' (ID,'+
          'NOME,'+
          'DESCRICAO,'+
          'PODE_FRACIONAR)'+
          'values ('+
          IntToStr(ID)+', '+
          DevolveConteudoDelimitado('|',vTupla)+', '+                     //    NOME            VARCHAR(10),
          DevolveConteudoDelimitado('|',vTupla)+', '+                     //    DESCRICAO       VARCHAR(250),
          DevolveConteudoDelimitado('|',vTupla)+')'                       //    PODE_FRACIONAR  CHAR(1)
        else
          ConsultaSQL :=
          ' update UNIDADE_PRODUTO set '+
          'NOME  ='+          DevolveConteudoDelimitado('|',vTupla)+', '+ //    NOME            VARCHAR(10),
          'DESCRICAO ='+      DevolveConteudoDelimitado('|',vTupla)+', '+ //    DESCRICAO       VARCHAR(250),
          'PODE_FRACIONAR ='+ DevolveConteudoDelimitado('|',vTupla)+      //    PODE_FRACIONAR  CHAR(1)
          'where (ID ='+IntToStr(ID)+')';
      end;

      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.ExecSQL();
      result := True;
    except
      result := false;
    end;
  finally
    Query.Free;
  end;

end;



end.
