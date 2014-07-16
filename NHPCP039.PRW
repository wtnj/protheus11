/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP039  ºAutor  ³João Felipe da rosa º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GERA ARQUIVO TXT - LAYOUT DO RELEASE P/ FORNECEDORES       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include 'topconn.ch'
#include "rwmake.ch"
#include "protheus.ch"

User Function NHPCP039()

Local nSeq := 1

Private _cArqITP:=SPACE(12)                                                           
Private _cArqPE1:=SPACE(12) 
Private _cArqPE2:=SPACE(12) 
Private _cArqPE3:=SPACE(12) 
Private _cArqPE4:=SPACE(12) 
Private _cArqPE5:=SPACE(12) 
Private _cArqTE1:=SPACE(12) 
Private _cArqFTP:=SPACE(12) 
Private cNovaLinha := Chr(13) + Chr(10)
Private cPath    := 'C:/FORNEC/'
Private cPathEdi := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
Private cArqv    := 'FORN'+Substr(DtoS(dDatabase),7,2)+Substr(Dtos(dDatabase),5,2)+ALLTRIM(STR(nSeq))+".TXT"
Private cArqExp  := cPath + cArqv
Private cArqExp2 := cPathEdi + cArqv

If !MsgBox('O arquivo será gerado automaticamente na área de Transferência.'+chr(10)+chr(13)+;
		   'Para geração do arquivo também em disco local, deve existir uma pasta chamada FORNEC na unidade C: do computador.'+chr(10)+chr(13)+;
		   'Confirma geração do Arquivo?','Layout','YESNO')
	Return
Endif	

While File(cPath+cArqv)
	nSeq++
	cArqv := 'FORN'+Substr(DtoS(dDatabase),7,2)+Substr(Dtos(dDatabase),5,2)+ALLTRIM(STR(nSeq))+".TXT"
Enddo

cArqExp  := cPath + cArqv
cArqExp2 := cPathEdi + cArqv

cARQ    := FCreate(cArqEXP)
cARQEDI := FCreate(cArqExp2)

fCriaDBF()  

Pergunte('PCP039',.T.)

Processa({|| GeraDados()},'gerando arquivo')

PE1->(dbCloseArea())
PE2->(dbCloseArea())
PE3->(dbCloseArea())
PE4->(dbCloseArea())
PE5->(dbCloseArea())
TE1->(dbCloseArea())
FTP->(dbCloseArea())

fErase(_cArqITP)   // Deleta arquivo de dados temporario
fErase(_cArqPE1)   // Deleta arquivo de dados temporario
fErase(_cArqPE2)   // Deleta arquivo de dados temporario
fErase(_cArqPE3)   // Deleta arquivo de dados temporario
fErase(_cArqPE4)   // Deleta arquivo de dados temporario
fErase(_cArqPE5)   // Deleta arquivo de dados temporario
fErase(_cArqTE1)   // Deleta arquivo de dados temporario
fErase(_cArqFTP)   // Deleta arquivo de dados temporario

If File(cARQEXP)
   FClose(cARQ)         
Endif
If File(cARQEXP2)
   FClose(cARQEdi)         
Endif

Return

Static Function fCriaDBF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//---------------  SEGMENTO ITPv0 - Segmento Inicial Mensagem

_cArqITP  := CriaTrab(NIL,.f.)
_cArqITP += ".DBF"
_aITP := {}
                                              // Nome                           Uso  Tipo   Tam  Dec   Posicao
AADD(_aITP,{"IdentSeg"   ,"C", 03,0})         // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aITP,{"NumComu"    ,"C", 03,0})         // Numero Mensagem Comunicacao     M    A       3    0    4    6
AADD(_aITP,{"NumVer"     ,"C", 02,0})         // Numero da Versao da Mensagem    M    N       2    0    7    8
AADD(_aITP,{"NumCont"    ,"C", 05,0})         // Numero de Controle Movimento    O    N       5    0    9   13
AADD(_aITP,{"IdentMov"   ,"C", 12,0})         // Ident. Geracao Movimento        M    N      12    0   14   25
AADD(_aITP,{"IdentTra"   ,"C", 14,0})         // Identificacao do Transmissor    M    N      14    0   26   39
AADD(_aITP,{"IdentRec"   ,"C", 14,0})         // Identificacao do Receptor       M    N      14    0   40   53
AADD(_aITP,{"CodIntTr"   ,"C", 08,0})         // Codigo Interno Transmissor      O    A       8    0   54   61
AADD(_aITP,{"CodIntRe"   ,"C", 08,0})         // Codigo Interno Receptor         O    A       8    0   62   69
AADD(_aITP,{"NomTrans"   ,"C", 25,0})         // Nome do Transmissor             O    A      25    0   70   94
AADD(_aITP,{"NomRece"    ,"C", 25,0})         // Nome do Receptor                O    A      25    0   95  119
AADD(_aITP,{"Espaco"     ,"C", 09,0})         // Espaco                          M    A       9    0  120  128

DbCreate(_cArqITP,_aITP)
DbUseArea(.T.,,_cArqITP,"ITP",.F.) 

//---------------  SEGMENTO PE1v0 - DADOS DO ITEM                         

_cArqPE1  := CriaTrab(NIL,.f.)
_cArqPE1 += ".DBF"
_aPE1 := {}
 			 							// Nome                            Uso  Tipo   Tam   Dec   Posicao
AADD(_aPE1,{"IdentSeg"	,"C",  03,0})	//  Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aPE1,{"CodFabr"   ,"C",  03,0})   //  CODIGO DA FABRICA ENTREGA       M    A       3    0    4    6
AADD(_aPE1,{"IdentPrg"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    M    A       9    0    7   15
AADD(_aPE1,{"DataPrg"   ,"C",  06,0})   //  DATA DO PROGRAMA ATUAL          M    D       6    0   16   21
AADD(_aPE1,{"IdentPra"  ,"C",  09,0})   //  IDENT. DO PROGRAMA ANTERIOR     O    A       9    0   22   30
AADD(_aPE1,{"DataPrga"  ,"C",  06,0})   //  DATA DO PROGRAMA ANTERIOR       O    D       6    0   31   36
AADD(_aPE1,{"CodItmCl"  ,"C",  30,0})   //  CODIGO DO ITEM DO CLIENTE       M    A      30    0   37   66
AADD(_aPE1,{"CodItmFo"  ,"C",  30,0})   //  CODIGO DO ITEM DO FORNECEDOR    O    A      30    0   67   96
AADD(_aPE1,{"NumPedCo"  ,"C",  12,0})   //  NUMERO DO PEDIDO DE COMPRA      M    A      12    0   97  108
AADD(_aPE1,{"CodLocEn"  ,"C",  05,0})   //  CODIGO DO LOCAL DE ENTREGA      O    A       5    0  109  113
AADD(_aPE1,{"ContatoC"  ,"C",  11,0})   //  CONTATO NO CLIENTE              O    A      11    0  114  124
AADD(_aPE1,{"CodUnMed"  ,"C",  02,0})   //  CODIGO DA UNIDADE DE MEDIDA     M    A       2    0  125  126
AADD(_aPE1,{"QtdCasDe"  ,"C",  01,0})   //  QUANTIDADE DE CASAS DECIMAIS    O    N       1    0  127  127
AADD(_aPE1,{"CodTpFor"  ,"C",  01,0})   //  CODIGO DO TIPO DE FORNECIMENTO  M    A       1    0  128  128

DbCreate(_cArqPE1,_aPE1)
DbUseArea(.T.,,_cArqPE1,"PE1",.F.) 
    
//---------------  SEGMENTO PE2v4 - INFORMACOES DE ENTREGAS

_cArqPE2  := CriaTrab(NIL,.f.)
_cArqPE2 += ".DBF"
_aPE2 := {}

                                        // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aPE2,{"IdentSeg"  ,"C",  03,0})   //  Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aPE2,{"DtUltEnt"  ,"C",  06,0})   //  DATA DA ULTIMA ENTREGA          O    D       6    0    4    9
AADD(_aPE2,{"NumUltNF"  ,"C",  06,0})   //  NUMERO DA ULTIMA NOTA FISCAL    O    N       6    0   10   15
AADD(_aPE2,{"SerUltNF"  ,"C",  04,0})   //  SERIE ULTIMA NOTA FISCAL        O    A       4    0   16   19
AADD(_aPE2,{"DatUltNF"  ,"C",  06,0})   //  DATA DA ULTIMA NOTA FISCAL      O    D       6    0   20   25
AADD(_aPE2,{"QtdUltEn"  ,"C",  12,3})   //  QUANTIDADE DA ULTIMA ENTREGA    O    N      12    3   26   37
AADD(_aPE2,{"QtdEnAcu"  ,"C",  14,3})   //  QUANTIDADE ENTREGA ACUMULADA    O    N      14    3   38   51
AADD(_aPE2,{"QtdNeAcu"  ,"C",  14,3})   //  QTDE NECESSARIA ACUMULADA       O    N      14    3   52   65
AADD(_aPE2,{"QtdLotMi"  ,"C",  12,3})   //  QTDE LOTE MINIMO                O    N      12    3   66   77
AADD(_aPE2,{"CodFreFo"  ,"C",  03,0})   //  CODIGO FREQUENCIA FORNECIMENTO  O    A       3    0   78   80
AADD(_aPE2,{"DatLibPr"  ,"C",  04,0})   //  DATA DA LIBERACAO DA PRODUCAO   O    N       4    0   81   84
AADD(_aPE2,{"DatLibMa"  ,"C",  04,0})   //  DATA LIBERACAO MATERIA PRIMA    O    N       4    0   85   88
AADD(_aPE2,{"CodLoDes"  ,"C",  07,0})   //  CODIGO DO LOCAL DE DESCARGA     O    A       7    0   89   95
AADD(_aPE2,{"IdentPer"  ,"C",  04,0})   //  IDENT. DO PERIODO DE ENTREGA    O    N       4    0   96   99
AADD(_aPE2,{"CodSitIt"  ,"C",  02,0})   //  CODIGO DE SITUACAO DO ITEM      O    A       2    0  100  101
AADD(_aPE2,{"IdTipPro"  ,"C",  01,0})   //  IDENT. DO TIPO DE PROGRAMACAO   M    A       1    0  102  102
AADD(_aPE2,{"PedVenda"  ,"C",  13,0})   //  PEDIDO DA REVENDA               O    A      13    0  103  115
AADD(_aPE2,{"QualifPr"  ,"C",  01,0})   //  QUALIFICACAO DA PROGRAMACAO     O    A       1    0  116  116
AADD(_aPE2,{"Espaco  "  ,"C",  12,0})   //  Espaco                          M    A      12    0  117  128

DbCreate(_cArqPE2,_aPE2)
DbUseArea(.T.,,_cArqPE2,"PE2",.F.)

//---------------  SEGMENTO PE3v0 - CRONOGRAMA DE ENTREGA                     

_cArqPE3 := CriaTrab(NIL,.f.)
_cArqPE3 += ".DBF"
_aPE3 := {}

										// Nome                            Uso  Tipo  Tam  Dec  Posicao
AADD(_aPE3,{"IdentSeg"  ,"C",  03,0})   //  Identificacao Tipo de Segmento  M    A       3    0    1    3

/*

For xP:=1 to 31
	cCmd1 := 'AADD(_aPE3,{"DtEntIt'+strzero(xP,2)+'"  ,"C",  06,0})'   //  DATA DE ENTREGA DO ITEM         M    D       6    0    4    9
	cCmd2 := 'AADD(_aPE3,{"HrEntIt'+strzero(xP,2)+'"  ,"C",  02,0})'   //  HORA PARA ENTREGA DO ITEM       O    N       2    0   10   11
	cCmd3 := 'AADD(_aPE3,{"QtEntIt'+strzero(xP,2)+'"  ,"C",  09,0})'   //  QUANTIDADE DE ENTREGA DO ITEM   M    N       9    0   12   20

	&(cCmd1)
	&(cCmd2)
	&(cCmd3)
Next
*/


AADD(_aPE3,{"DtEntIt1"  ,"C",  06,0})   //  DATA DE ENTREGA DO ITEM         M    D       6    0    4    9
AADD(_aPE3,{"HrEntIt1"  ,"C",  02,0})   //  HORA PARA ENTREGA DO ITEM       O    N       2    0   10   11
AADD(_aPE3,{"QtEntIt1"  ,"C",  09,0})   //  QUANTIDADE DE ENTREGA DO ITEM   M    N       9    0   12   20
AADD(_aPE3,{"DtEntIt2"  ,"C",  06,0})   //  DATA DE ENTREGA DO ITEM         O    D       6    0   21   26
AADD(_aPE3,{"HrEntIt2"  ,"C",  02,0})   //  HORA PARA ENTREGA DO ITEM       O    N       2    0   27   28
AADD(_aPE3,{"QtEntIt2"  ,"C",  09,0})   //  QUANTIDADE DE ENTREGA DO ITEM   O    N       9    0   29   37
AADD(_aPE3,{"DtEntIt3"  ,"C",  06,0})   //  DATA DE ENTREGA DO ITEM         O    D       6    0   38   43
AADD(_aPE3,{"HrEntIt3"  ,"C",  02,0})   //  HORA PARA ENTREGA DO ITEM       O    N       2    0   44   45
AADD(_aPE3,{"QtEntIt3"  ,"C",  09,0})   //  QUANTIDADE DE ENTREGA DO ITEM   O    N       9    0   46   54
AADD(_aPE3,{"DtEntIt4"  ,"C",  06,0})   //  DATA DE ENTREGA DO ITEM         O    D       6    0   55   60
AADD(_aPE3,{"HrEntIt4"  ,"C",  02,0})   //  HORA PARA ENTREGA DO ITEM       O    N       2    0   61   62
AADD(_aPE3,{"QtEntIt4"  ,"C",  09,0})   //  QUANTIDADE DE ENTREGA DO ITEM   O    N       9    0   63   71
AADD(_aPE3,{"DtEntIt5"  ,"C",  06,0})   //  DATA DE ENTREGA DO ITEM         O    D       6    0   72   77
AADD(_aPE3,{"HrEntIt5"  ,"C",  02,0})   //  HORA PARA ENTREGA DO ITEM       O    N       2    0   78   79
AADD(_aPE3,{"QtEntIt5"  ,"C",  09,0})   //  QUANTIDADE DE ENTREGA DO ITEM   O    N       9    0   80   88
AADD(_aPE3,{"DtEntIt6"  ,"C",  06,0})   //  DATA DE ENTREGA DO ITEM         O    D       6    0   89   94
AADD(_aPE3,{"HrEntIt6"  ,"C",  02,0})   //  HORA PARA ENTREGA DO ITEM       O    N       2    0   95   96
AADD(_aPE3,{"QtEntIt6"  ,"C",  09,0})   //  QUANTIDADE DE ENTREGA DO ITEM   O    N       9    0   97  105
AADD(_aPE3,{"DtEntIt7"  ,"C",  06,0})   //  DATA DE ENTREGA DO ITEM         O    D       6    0  106  111
AADD(_aPE3,{"HrEntIt7"  ,"C",  02,0})   //  HORA PARA ENTREGA DO ITEM       O    N       2    0  112  113
AADD(_aPE3,{"QtEntIt7"  ,"C",  09,0})   //  QUANTIDADE DE ENTREGA DO ITEM   O    N       9    0  114  122

AADD(_aPE3,{"Espaco  "  ,"C",  06,0})   //  Espaco                          M    A       6    0  123  128

DbCreate(_cArqPE3,_aPE3)
DbUseArea(.T.,,_cArqPE3,"PE3",.F.)

//---------------  SEGMENTO PE5v1 - COMPLEMENTO PROGRAMA ENTREGA                  

_cArqPE5 := CriaTrab(NIL,.f.)
_cArqPE5 += ".DBF"
_aPE5 := {}

										//  Nome                            Uso  Tipo  Tam  Dec  Posicao
AADD(_aPE5,{"IdentSeg"  ,"C",  03,0})   //  Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aPE5,{"DtIEnIt1"  ,"C",  06,0})   //  DATA INICIO ENTREGA ITEM        O    D       6    0    4    9
AADD(_aPE5,{"IdenPrg1"	,"C",  01,0})   //  IDENTIFICACAO DA PROGRAMACAO    O    A       1    0   10   10
AADD(_aPE5,{"IdenPrA1"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    O    A       9    0   11   19
AADD(_aPE5,{"DtIEnIt2"  ,"C",  06,0})   //  DATA INICIO ENTREGA ITEM        O    D       6    0   20   25
AADD(_aPE5,{"IdenPrg2"  ,"C",  01,0})   //  IDENTIFICACAO DA PROGRAMACAO    O    A       1    0   26   26
AADD(_aPE5,{"IdenPrA2"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    O    A       9    0   27   35
AADD(_aPE5,{"DtIEnIt3"  ,"C",  06,0})   //  DATA INICIO ENTREGA ITEM        O    D       6    0   36   41
AADD(_aPE5,{"IdenPrg3"  ,"C",  01,0})   //  IDENTIFICACAO DA PROGRAMACAO    O    A       1    0   42   42
AADD(_aPE5,{"IdenPrA3"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    O    A       9    0   43   51
AADD(_aPE5,{"DtIEnIt4"  ,"C",  06,0})   //  DATA INICIO ENTREGA ITEM        O    D       6    0   52   57
AADD(_aPE5,{"IdenPrg4"  ,"C",  01,0})   //  IDENTIFICACAO DA PROGRAMACAO    O    A       1    0   58   58
AADD(_aPE5,{"IdenPrA4"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    O    A       9    0   59   67
AADD(_aPE5,{"DtIEnIt5"  ,"C",  06,0})   //  DATA INICIO ENTREGA ITEM        O    D       6    0   68   73
AADD(_aPE5,{"IdenPrg5"  ,"C",  01,0})   //  IDENTIFICACAO DA PROGRAMACAO    O    A       1    0   74   74
AADD(_aPE5,{"IdenPrA5"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    O    A       9    0   75   83
AADD(_aPE5,{"DtIEnIt6"  ,"C",  06,0})   //  DATA INICIO ENTREGA ITEM        O    D       6    0   84   89
AADD(_aPE5,{"IdenPrg6"  ,"C",  01,0})   //  IDENTIFICACAO DA PROGRAMACAO    O    A       1    0   90   90
AADD(_aPE5,{"IdenPrA6"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    O    A       9    0   91   99
AADD(_aPE5,{"DtIEnIt7"  ,"C",  06,0})   //  DATA INICIO ENTREGA ITEM        O    D       6    0  100  105
AADD(_aPE5,{"IdenPrg7"  ,"C",  01,0})   //  IDENTIFICACAO DA PROGRAMACAO    O    A       1    0  106  106
AADD(_aPE5,{"IdenPrA7"  ,"C",  09,0})   //  IDENTIFICACAO PROGRAMA ATUAL    O    A       9    0  107  115
AADD(_aPE5,{"Espaco  "  ,"C",  13,0})   //  Espaco                          M    A      13    0  116  128

DbCreate(_cArqPE5,_aPE5)
DbUseArea(.T.,,_cArqPE5,"PE5",.F.)

//---------------  SEGMENTO PE4v0 - DADOS DA EMBALAGEM                       

_cArqPE4 := CriaTrab(NIL,.f.)
_cArqPE4 += ".DBF"
_aPE4 := {}
										//  Nome                            Uso  Tipo  Tam  Dec  Posicao
AADD(_aPE4,{"IdentSeg"  ,"C",  03,0})   //  Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aPE4,{"IdEmbCli"  ,"C",  30,0})   //  IDENT. EMBALAGEM SEC. CLIENTE   M    A      30    0    4   33
AADD(_aPE4,{"IdEmbFor"  ,"C",  30,0})   //  IDENT. EMBALAGEM SEC. FORNEC.   O    A      30    0   34   63
AADD(_aPE4,{"CpEmbSec"  ,"C",  12,3})   //  CAPACIDADE EMBALAGEM SECUND.    O    N      12    3   64   75
AADD(_aPE4,{"IdEbPFor"  ,"C",  30,0})   //  IDENT. EMBALAGEM PRIMARIA FOR.  O    A      30    0   76  105
AADD(_aPE4,{"CpEmPFor"  ,"C",  12,3})   //  CAPACIDADE EMB. PRIMARIA FORN.  O    N      12    3  106  117
AADD(_aPE4,{"CodResEm"  ,"C",  01,0})   //  CODIGO RESPONSAVEL EMBALAGEM    O    A       1    0  118  118
AADD(_aPE4,{"Espaco  "  ,"C",  10,0})   //  Espaco                          M    A      10    0  119  128

DbCreate(_cArqPE4,_aPE4)
DbUseArea(.T.,,_cArqPE4,"PE4",.F.)

//--------------- SEGMENTO TE1v0 - TEXTO LIVRE                          

_cArqTE1  := CriaTrab(NIL,.f.)
_cArqTE1 += ".DBF"
_aTE1 := {}
                                        // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aTE1,{"IdentSeg"   ,"C", 03,0})   // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aTE1,{"Texto1"     ,"C", 40,0})   // TEXTO LIVRE INFORMATIVO         M    A      40    0    4   43
AADD(_aTE1,{"Texto2"     ,"C", 40,0})   // TEXTO LIVRE INFORMATIVO         M    A      40    0   44   83
AADD(_aTE1,{"Texto3"     ,"C", 40,0})   // TEXTO LIVRE INFORMATIVO         M    A      40    0   84  123
AADD(_aTE1,{"Espaco"     ,"C", 05,0})   // Espaco                          M    A       5    0  124  128

DbCreate(_cArqTE1,_aTE1)
DbUseArea(.T.,,_cArqTE1,"TE1",.F.) 
   
//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    

_cArqFTP  := CriaTrab(NIL,.f.)
_cArqFTP += ".DBF"
_aFTP := {}
                                         // Nome                           Uso  Tipo  Tam  Dec   Posicao
AADD(_aFTP,{"IdentSeg"   ,"C", 03,0})    // Identificacao Tipo de Segmento  M    A       3    0    1    3
AADD(_aFTP,{"NumCont"    ,"C", 05,0})    // Numero de Controle Movimento    O    N       5    0    4    8
AADD(_aFTP,{"QtdeSeg"    ,"C", 09,0})    // Quantidade de Segmentos         M    N       9    0    9   17
AADD(_aFTP,{"NumToVl"    ,"C", 17,0})    // Numero Total de Valores         O    N      17    2   18   34
AADD(_aFTP,{"CatOper"    ,"C", 01,0})    // Categoria da Operacao           O    A       1    0   35   35
AADD(_aFTP,{"Espaco"     ,"C", 93,0})    // Espaco                          M    A      93    0   36  128

DbCreate(_cArqFTP,_aFTP)
DbUseArea(.T.,,_cArqFTP,"FTP",.F.) 
  
Return                                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                    ³
//³ GRAVACAO DOS DADOS ³
//³                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GeraDados()
Local cAl := getNextAlias()
Local nFTP := 0

SA2->(dbSetOrder(1))
If !SA2->(dbSeek(xFilial('SA2')+ZA9->ZA9_FORNEC+ZA9->ZA9_LOJA))
	Alert("Erro ao tentar localizar o fornecedor!")
	return 
EndIf

PROCREGUA(0)

//---------------  SEGMENTO ITPv0 - Segmento Inicial Mensagem

Incproc('Gerando segmento ITP')

cDtaHor         := Subs(Dtos(dDatabase),3,6)+Stuff(TIME(),AT(":",TIME()),1,"")  // DATA+HHMMSS

RecLock("ITP",.T.)             
   ITP->IdentSeg  := "ITP"
   ITP->NumComu   := "001"
   ITP->NumVer    := "06"
   ITP->NumCont   := "00001" // Fazer este numero sequencia atraves de MV_VOLKS
   ITP->IdentMov  := Stuff(cDtaHor,AT(":",cDtaHor),1,"")  // DATA+HHMMSS tira o segundo :
   ITP->IdentTra  := IIF(SM0->M0_CODIGO == "NH","73355174000140","01261681000104")  //empresa Usinagem OU Fundicao
   ITP->IdentRec  := SA2->A2_CGC //"59104422005704" //CGC VOLKS Planta Anchieta
   ITP->CodIntTr  := space(8)
   ITP->CodIntRe  := space(8)
   ITP->NomTrans  := IIF(SM0->M0_CODIGO == "NH","73355174000140","01261681000104")  //empresa Usinagem OU Fundicao
   ITP->NomRece   := SA2->A2_NOME //"TRANS GRANDE ABC"	
   ITP->Espaco    := Space(09)
MsUnlock("ITP")

FWrite(cArq   ,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentMov+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha)) 
FWrite(cArqedi,(ITP->(IdentSeg+NumComu+NumVer+NumCont+IdentMov+IdentTra+IdentRec+CodIntTr+CodIntRe+NomTrans+NomRece+Espaco)+cNovaLinha)) 

DbSelectArea("ITP")
DbCloseArea()
nFTP += 1  //Controle de qtde de segmentos
       
ZA0->(dbSetOrder(1))
If !ZA0->(dbSeek(xFilial("ZA0")+ZA9->ZA9_NUM))
	Alert("Erro ao tentar localizar os itens do release!")
	return
EndIf

SB1->(dbSetOrder(1)) //filial + cod

Incproc('Gerando segmento PE1')

While ZA0->(!EOF()) .AND. ZA0->ZA0_NUM==ZA9->ZA9_NUM

	//---------------  SEGMENTO PE1v0 - DADOS DO ITEM                         

	beginSql Alias cAl
		SELECT 
			TOP 1 ZA9_NUM, ZA9_MES, ZA9_ANO, ZA9_DATA
		FROM 
			%Table:ZA9% ZA9,
		    %Table:ZA0% ZA0
		WHERE
			ZA9_NUM = ZA0_NUM
		AND ZA9_NUM <> %Exp:ZA9->ZA9_NUM%
		AND ZA9_FORNEC = %Exp:ZA9->ZA9_FORNEC%
		AND ZA9_LOJA   = %Exp:ZA9->ZA9_LOJA%
		AND ZA0_PROD = %Exp:ZA0->ZA0_PROD%
		AND ZA0.%NotDel%
		AND ZA9.%NotDel%
		AND ZA0.ZA0_FILIAL = %xFilial:ZA0%
		AND ZA9.ZA9_FILIAL = %xFilial:ZA9%
		ORDER BY ZA9_NUM DESC
	endSql
	
	TcSetField(cAl,"ZA9_DATA","D")
	
	If (cAl)->(!eof())
		cIdentPra := '000' + (cAl)->ZA9_NUM
		cDataPrga := Right(STRZERO(Year((cAl)->ZA9_DATA),4),2)+StrZero(Month((cAl)->ZA9_DATA),2)+StrZero(Day((cAl)->ZA9_DATA),2)
	Else
		cIdentPra := space(9)
		cDataPrga := '000000'
	Endif
	
	SB1->(dbSeek(xFilial("SB1")+ZA0->ZA0_PROD))

	Reclock("PE1",.T.)
		PE1->IdentSeg := 'PE1'
		PE1->CodFabr  := '001'
		PE1->IdentPrg := '000' + ZA9->ZA9_NUM
		PE1->DataPrg  := Right(STRZERO(Year((cAl)->ZA9_DATA),4),2)+StrZero(Month(ZA9->ZA9_DATA),2)+StrZero(Day(ZA9->ZA9_DATA),2)
		PE1->IdentPra := cIdentPra
		PE1->DataPrga := cDataPrga
		PE1->CodItmCl := ZA0->ZA0_PROD
		PE1->CodItmFo := SB1->B1_CODAP5
		PE1->NumPedCo := ZA9->ZA9_NUMAE
		PE1->CodLocEn := '00000'
		PE1->ContatoC := ZA9->ZA9_RESP
		PE1->CodUnMed := SB1->B1_UM
		PE1->QtdCasDe := '2'
		PE1->CodTpFor := 'P'
	MsUnlock("PE1")	

	FWrite(cArq   ,(PE1->(IdentSeg+CodFabr+IdentPrg+DataPrg+IdentPra+DataPrga+CodItmCl+CodItmFo+NumPedCo+CodLocEn+ContatoC+CodUnMed+QtdCasDe+CodTpFor)+cNovaLinha))
	FWrite(cArqedi,(PE1->(IdentSeg+CodFabr+IdentPrg+DataPrg+IdentPra+DataPrga+CodItmCl+CodItmFo+NumPedCo+CodLocEn+ContatoC+CodUnMed+QtdCasDe+CodTpFor)+cNovaLinha))
	
//	DbSelectArea("PE1")
//	DbCloseArea()
    nFTP += 1  //Controle de qtde de segmentos
       
	//---------------  SEGMENTO PE2v4 - INFORMACOES DE ENTREGAS
	
	Incproc('Gerando segmento PE2')

	aUltNf := fUltNF(ZA0->ZA0_PROD,ZA9->ZA9_FORNEC,ZA9->ZA9_LOJA)
	aQtdEn := fQtdEntr(ZA0->ZA0_PROD,ZA9->ZA9_FORNEC,ZA9->ZA9_LOJA,CtoD('01/'+strzero(ZA9->ZA9_MES,2)+'/'+STRZERO(ZA9->ZA9_ANO,4)),UltimoDia(CtoD('01/'+strzero(ZA9->ZA9_MES,2)+'/'+STRZERO(ZA9->ZA9_ANO,4))))

	nQtdEnAcu := 0
	For xQ:=1 to len(aQtdEn)
		nQtdEnAcu += aQtdEn[xQ][2]
	Next
	
	nQtdNeAcu := 0
	cDtEntIt1 := ''
	cQtEntIt1 := '';
	
	aDtEntIt := {}
	aQtEntIt := {}

	For xQ:=1 to DAY(ultimodia(ctod('01/'+StrZero(ZA9->ZA9_MES,2)+'/'+STRZERO(ZA9->ZA9_ANO,4))))

		cField := "ZA0->ZA0_PREV"+strzero(xQ,2)
		nQtdNeAcu += &(cField)
		If &(cField) > 0
		
			aAdd(aDtEntIt, Right(STRZERO(ZA9->ZA9_ANO,4),2) + StrZero(ZA9->ZA9_MES,2) + StrZero(xQ,2)) //, cDtEntIt1)
			aAdd(aQtEntIt, StrZero(&(cField),7)+'00' )
			
		EndIf
	Next 
	
	While Len(aDtEntIt) < 31
		aAdd(aDtEntIt,space(6))
	EndDo
	
	While Len(aQtEntIt) < 31
		aAdd(aQtEntIt,space(9))
	EndDo

	//-- PEGA AS PREVISOES DOS PROXIMOS MESES
	
	For xM:=1 to 3
	
		nProxM := ZA9->ZA9_MES + xM
		nAnoAt := ZA9->ZA9_ANO
	
		//-- verifica se o proximo mes é maior que 12
		If nProxM > 12
			nProxM -= 12
			nAnoAt++
		Endif
	
		aAdd(aDtEntIt, Right(STRZERO(nAnoAt,4),2) + StrZero(nProxM,2) + '01') //-- sempre o dia 01 do proximo mes
		aAdd(aQtEntIt, StrZero(&('ZA0->ZA0_MES'+STRZERO(xM,1)),7)+'00' )
	
	Next

	Reclock("PE2",.T.)
		PE2->IdentSeg := 'PE2'
		PE2->DtUltEnt := Iif( MV_PAR01==1 , Right(STRZERO(Year(aUltNf[4]),4),2)+StrZero(Month(aUltNf[4]),2)+StrZero(Day(aUltNf[4]),2) , SPACE(6) )
		PE2->NumUltNF := Iif( MV_PAR01==1 , Right(aUltNf[1],6) , space(6) )
		PE2->SerUltNF := Iif( MV_PAR01==1 , AllTrim(aUltNf[2]) + Repli(" ",4 - len(aUltNf[2])) , space(4) )
		PE2->DatUltNF := Iif( MV_PAR01==1 , Right(STRZERO(Year(aUltNf[3]),4),2)+StrZero(Month(aUltNf[3]),2)+StrZero(Day(aUltNf[3]),2) , space(6) )
		PE2->QtdUltEn := Iif( MV_PAR01==1 , StrZero(aUltNf[5],9)+'000' , space(12) )
		PE2->QtdEnAcu := StrZero(nQtdEnAcu,11)+'000'
		PE2->QtdNeAcu := StrZero(nQtdNeAcu,11)+'000'
		PE2->QtdLotMi := StrZero(SB1->B1_LM,9)+'000'
		PE2->CodFreFo := PadL(ZA0->ZA0_FREQ,3)
		PE2->DatLibPr := '0000'
		PE2->DatLibMa := '0000'
		PE2->CodLoDes := '0000000'
		PE2->IdentPer := '0000'
		PE2->CodSitIt := '00'
		PE2->IdTipPro := '1'
		PE2->PedVenda := '0000000000000' // PEDIDO DA REVENDA
		PE2->QualifPr := '0'
		PE2->Espaco   := Space(12)
	MsUnlock("PE2")	

	FWrite(cArq   ,(PE2->(IdentSeg+DtUltEnt+NumUltNF+SerUltNF+DatUltNF+QtdUltEn+QtdEnAcu+QtdNeAcu+QtdLotMi+CodFreFo+DatLibPr+DatLibMa+CodLoDes+IdentPer+CodSitIt+IdTipPro+PedVenda+QualifPr+Espaco)+cNovaLinha))
	FWrite(cArqedi,(PE2->(IdentSeg+DtUltEnt+NumUltNF+SerUltNF+DatUltNF+QtdUltEn+QtdEnAcu+QtdNeAcu+QtdLotMi+CodFreFo+DatLibPr+DatLibMa+CodLoDes+IdentPer+CodSitIt+IdTipPro+PedVenda+QualifPr+Espaco)+cNovaLinha))
		
//	DbSelectArea("PE2")
//	DbCloseArea()    
    nFTP += 1  //Controle de qtde de segmentos
       	
	//---------------  SEGMENTO PE3v0 - CRONOGRAMA DE ENTREGA   

	Incproc('Gerando segmento PE3')

	For xP:=1 to Len(aDtEntIt)

		If EMPTY(aDtEntIt[xP])
			Loop
		Endif
		
		RecLock("PE3",.T.)	
			PE3->IdentSeg := 'PE3'
			
	//			cCmd1 := "PE3->DtEntIt"+StrZero(xP,1)+" := aDtEntIt["+AllTrim(str(xP))+"]"
	//			cCmd2 := "PE3->HrEntIt"+StrZero(xP,1)+" := '00'"
	//			cCmd3 := "PE3->QtEntIt"+StrZero(xP,1)+" := aQtEntIt["+AllTrim(str(xP))+"]"
	
				cCmd1 := "PE3->DtEntIt1 := aDtEntIt["+AllTrim(str(xP))+"]"
				cCmd2 := "PE3->HrEntIt1 := '  '"
				cCmd3 := "PE3->QtEntIt1 := aQtEntIt["+AllTrim(str(xP))+"]"
	
				&(cCmd1)
				&(cCmd2)
				&(cCmd3)
	
			PE3->Espaco := SPACE(6) 
		MsUnlock("PE3")	
	
		cStrPe3 := PE3->IdentSeg

		cStrPe3 += PE3->DtEntIt1
		cStrPe3 += PE3->HrEntIt1
		cStrPe3 += PE3->QtEntIt1
	
		For xS:=1 to 6
			cStrPe3 += SPACE(6)
			cStrPe3 += SPACE(2)
			cStrPe3 += SPACE(9)
		Next

		cStrPe3 += PE3->Espaco + cNovaLinha	

		FWrite(cArq   ,cStrPe3)
		FWrite(cArqedi,cStrPe3)
	
	    nFTP += 1  //Controle de qtde de segmentos

	Next
    
	//---------------  SEGMENTO PE5v1 - COMPLEMENTO PROGRAMA ENTREGA  
	
	Incproc('Gerando segmento PE5')

	RecLock("PE5",.T.)
		PE5->IdentSeg := 'PE5'
		PE5->DtIEnIt1 := '000000' 
		PE5->IdenPrg1 := '0'
		PE5->IdenPrA1 := '000000000' 
		PE5->DtIEnIt2 := '000000'
		PE5->IdenPrg2 := '0'
		PE5->IdenPrA2 := '000000000' 
		PE5->DtIEnIt3 := '000000'
		PE5->IdenPrg3 := '0'
		PE5->IdenPrA3 := '000000000' 
		PE5->DtIEnIt4 := '000000'
		PE5->IdenPrg4 := '0'
		PE5->IdenPrA4 := '000000000' 
		PE5->DtIEnIt5 := '000000'
		PE5->IdenPrg5 := '0'
		PE5->IdenPrg5 := '000000000' 
		PE5->DtIEnIt6 := '000000'
		PE5->IdenPrg6 := '0'
		PE5->IdenPrA6 := '000000000' 
		PE5->DtIEnIt7 := '000000'
		PE5->IdenPrg7 := '0'
		PE5->IdenPrA7 := '000000000' 
		PE5->Espaco   := Space(13)
	MsUnlock("PE5")

// segmento opcional retirado em 16/05/11	
//	FWrite(cArq,(PE5->(IdentSeg+DtIEnIt1+IdenPrg1+IdenPrA1+DtIEnIt2+IdenPrg2+IdenPrA2+DtIEnIt3+IdenPrg3+IdenPrA3+DtIEnIt4+IdenPrg4+IdenPrA4+DtIEnIt5+IdenPrg5+IdenPrA5+DtIEnIt6+IdenPrg6+IdenPrA6+DtIEnIt7+IdenPrg7+IdenPrA7+Espaco)+cNovaLinha))

//	DbSelectArea("PE5")
//	DbCloseArea()
//    nFTP += 1  //Controle de qtde de segmentos
	//---------------  SEGMENTO PE4v0 - DADOS DA EMBALAGEM                       

	Incproc('Gerando segmento PE4')

	Reclock("PE4",.T.)
		PE4->IdentSeg := 'PE4'
		PE4->IdEmbCli := Space(29)+'1'
		PE4->IdEmbFor := Space(30) 
		PE4->CpEmbSec := space(12)
		PE4->IdEbPFor := space(30)
		PE4->CpEmPFor := space(12)
		PE4->CodResEm := SPACE(1)
		PE4->Espaco   := SPACE(10)
	MsUnlock("PE4")
// segmento opcional retirado em 16/05/11	
//	FWrite(cArq,(PE4->(IdentSeg+IdEmbCli+IdEmbFor+CpEmbSec+IdEbPFor+CpEmPFor+CodResEm+Espaco)+cNovaLinha))
//	DbSelectArea("PE4")
//	DbCloseArea()
//    nFTP += 1  //Controle de qtde de segmentos
    
	//--------------- SEGMENTO TE1v0 - TEXTO LIVRE                          
	
	Incproc('Gerando segmento TE1')

	Reclock("TE1",.T.)
		TE1->IdentSeg := 'TE1' 
		TE1->Texto1   := "Saldo a entregar ref. ao mês atual "+strzero(month(date()),2)+SPACE(3)
		TE1->Texto2   := SPACE(40)
		TE1->Texto3   := SPACE(40)
		TE1->Espaco   := SPACE(5)
	MsUnlock("TE1")

	FWrite(cArq   ,(TE1->(IdentSeg+Texto1+Texto2+Texto3+Espaco)+cNovaLinha))
	FWrite(cArqedi,(TE1->(IdentSeg+Texto1+Texto2+Texto3+Espaco)+cNovaLinha))
	
//	DbSelectArea("TE1")
//	DbCloseArea()
    nFTP += 1  //Controle de qtde de segmentos

	(cAl)->(dbclosearea())
	
	ZA0->(dbSkip())
    	
EndDo

//-------------  SEGMENTO FTPv0 - Segmento Final Mensagem                    

Incproc('Gerando segmento FTP')

nFTP += 1  //Controle de qtde de segmentos
Reclock("FTP",.T.)
	FTP->IdentSeg := 'FTP'
	FTP->NumCont  := '00000'
	FTP->QtdeSeg  := StrZero(nFtp,9)
    FTP->NumToVl  :="00000000000000000"
    FTP->CatOper  := Space(01)
    FTP->Espaco   := Space(36)
MsUnlock("FTP")    

FWrite(cArq   ,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))                
FWrite(cArqedi,(FTP->(IdentSeg+NumCont+QtdeSeg+NumToVl+CatOper+ Espaco)+cNovaLinha))                

FClose(cARQ)
FClose(cARQEdi)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A ULTIMA NOTA DE ENTRADA ³
//-- esta funcao foi tirada do fonte nhpcp011, deve ser alterada la tambem caso necessite de alteracao
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fUltNF(cProd,cForn,cLoja)

	cQuery := "SELECT TOP 1 D1.D1_DOC,D1.D1_EMISSAO,D1.D1_SERIE, D1_DTDIGIT, D1_QUANT"
	cQuery += " FROM "+RetSqlName("SD1") + " D1, " + RetSqlName( 'SF4' ) +" F4 "
	cQuery += " WHERE D1.D1_FORNECE = '"+cForn+"'"
	cQuery += " AND D1.D1_LOJA = '"+cLoja+"'"
	cQuery += " AND D1.D1_COD = '"+cProd+"'"
	cQuery += " AND D1.D1_TES = F4.F4_CODIGO"
	cQuery += " AND F4.F4_ESTOQUE = 'S'" //somente pega as notas que atualizam estoque
	cQuery += " AND D1.D1_TES != '196'" //Chamado 005229 do helpdesk
	cQuery += " AND D1.D_E_L_E_T_ = ' '"
	cQuery += " AND F4.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY D1.D1_DTDIGIT DESC, D1.D1_DOC DESC"
	
	TCQUERY cQuery NEW ALIAS "TMP"

	If TMP->(!eof())
		cUltNF     := Right(TMP->D1_DOC,6)
		dD1Emissao := StoD(TMP->D1_EMISSAO)
		cD1Serie   := TMP->D1_SERIE
		cD1Digit   := StoD(TMP->D1_DTDIGIT)
		nD1Quant   := TMP->D1_QUANT
	Else
		cUltNF     := ''
		dD1Emissao := CtoD('  /  /    ')
		cD1Serie   := ''
		cD1Digit   := StoD(TMP->D1_DTDIGIT)
		nD1Quant   := 0
	Endif
	
	TMP->(DbCloseArea())

Return {cUltNF,cD1Serie,dD1Emissao,cD1Digit,nD1Quant}


Static Function fQtdEntr(cProd,cForn,cLoja,dDtIni,dDtFim)
Local aQtd   := {}
Local dDtRef := dDtIni

	If dDtFim < dDtIni
		alert("dDtFim < dDtIni! Funcao fQtdEntr - NHPCP011")
		return
	EndIf

	While(dDtRef <= dDtFim)
		aAdd(aQtd,{DtoC(dDtRef),0})
		dDtRef++
	EndDo
		
	If Select('TMV') > 0
		TMV->(DbCloseArea())
	EndIF			
	
	IF SM0->M0_CODIGO == "FN" .AND. ;
	   cForn == '999999' .AND. cLoja == '01' //Se for para fundição, pega da ZBB

		cQuery := " SELECT ZBA.ZBA_DATA AS DTDIGIT, SUM(ZBB.ZBB_QUANT) AS QUANT "
		cQuery += " FROM ZBAFN0 ZBA, ZBBFN0 ZBB" //TEM QUE SER DA FUNDICAO
		cQuery += " WHERE ZBA.ZBA_NUM = ZBB.ZBB_NUM"
		cQuery += " AND ZBA.ZBA_DATA BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFim)+"'"
		cQuery += " AND ZBB.ZBB_COD = '"+cProd+"'"
		cQuery += " AND ZBA.ZBA_STATUS = 'E'"
		cQuery += " AND ZBB.ZBB_FILIAL = '"+XFILIAL("ZBB")+"' AND ZBB.D_E_L_E_T_ = ''"
		cQuery += " AND ZBA.ZBA_FILIAL = '"+XFILIAL("ZBA")+"' AND ZBA.D_E_L_E_T_ = ''"
		cQuery += " GROUP BY ZBA.ZBA_DATA"
		cQuery += " ORDER BY ZBA.ZBA_DATA" 
	Else
		cQuery := "SELECT D1_DTDIGIT AS DTDIGIT, SUM(D1.D1_QUANT) AS QUANT "
		cQuery += " FROM "+RetSqlName("SD1") + " D1, " + RetSqlName( 'SF4' ) +" F4 "
		cQuery += " WHERE D1.D1_COD = '"+cProd+"'"
		cQuery += " AND D1.D1_FORNECE = '"+cForn+"' AND D1.D1_LOJA = '"+cLoja+"'"
		cQuery += " AND D1.D1_DTDIGIT BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFim)+"'"
	    cQuery += " AND D1.D1_TES = F4.F4_CODIGO"	
	    cQuery += " AND F4.F4_ESTOQUE = 'S'" //somente pega as notas que atualizam estoque
		cQuery += " AND D1.D_E_L_E_T_ = ' '"
	    cQuery += " AND F4.D_E_L_E_T_ = ' '"
	    cQuery += " GROUP BY D1_DTDIGIT"
	    cQuery += " ORDER BY D1_DTDIGIT"
	EndIf
				
	TCQUERY cQuery NEW ALIAS 'TMV'
	         
	TcSetField("TMV","DTDIGIT","D")  // Muda a data de string para date    
	                   
	While !TMV->(EOF())
		_n := aScan(aQtd,{|x| x[1] == DtoC(TMV->DTDIGIT)})
		If _n!=0
			aQtd[_n][2] := TMV->QUANT
			TMV->(dbSkip())
		EndIf
	EndDo

	TMV->(dbCloseArea())
	
Return(aQtd)