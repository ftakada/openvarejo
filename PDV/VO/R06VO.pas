unit R06VO;

{$MODE Delphi}

interface

Uses Fgl;

type
  TR06VO = class
  private
    FID: Integer;
    FID_OPERADOR: Integer;
    FID_IMPRESSORA: Integer;
    FID_ECF_CAIXA: Integer;
    FSERIE_ECF: String;
    FCOO: Integer;
    FGNF: Integer;
    FGRG: Integer;
    FCDC: Integer;
    FDENOMINACAO: String;
    FDATA_EMISSAO: String;
    FHORA_EMISSAO: String;
    FSINCRONIZADO: String;
    FHASH_TRIPA: String;
    FHASH_INCREMENTO: Integer;


  published

    property Id: Integer read FID write FID;
    property IdOperador: Integer read FID_OPERADOR write FID_OPERADOR;
    property IdImpressora: Integer read FID_IMPRESSORA write FID_IMPRESSORA;
    property IdCaixa: Integer read FID_ECF_CAIXA write FID_ECF_CAIXA;
    property SerieEcf: String  read FSERIE_ECF write FSERIE_ECF;
    property COO: Integer read FCOO write FCOO;
    property GNF: Integer read FGNF write FGNF;
    property GRG: Integer read FGRG write FGRG;
    property CDC: Integer read FCDC write FCDC;
    property Denominacao: String read FDENOMINACAO write FDENOMINACAO;
    property DataEmissao: String read FDATA_EMISSAO write FDATA_EMISSAO;
    property HoraEmissao: String read FHORA_EMISSAO write FHORA_EMISSAO;
    property Sincronizado: String read FSINCRONIZADO write FSINCRONIZADO;
    property HashTripa: String read FHASH_TRIPA write FHASH_TRIPA;
    property HashIncremento: Integer read FHASH_INCREMENTO write FHASH_INCREMENTO;

end;

type
TR06ListaVO = class(specialize TFPGObjectList<TR06VO>);

implementation

end.
