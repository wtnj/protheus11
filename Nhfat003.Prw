/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHFAT003        ³ Marcelo J. Santos     ³ Data ³ 07.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Faturamento (Diario, Diario (A), Resumo)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³ Alexandre R. Bento                      | Data | 07.10.02 ³±±
±±³Alterado  ³ Felipe Ciconini                         | Data | 29.10.10 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


#include "rwmake.ch"       

User Function nhfat003()    

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,CRODATXT")
SetPrvt("NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,_F2VALMER,_F2VALTOT,_TOTVALMER")
SetPrvt("_TOTVALTOT,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO")
SetPrvt("_CESCOLHA,_STRUCT,_CARQUIVO,_CCLIENTE,_D2CHAVE,_D2PROD")
SetPrvt("LCOMPLEM,_NCQUANT,_NCVALUNI,_NCVALMER,_NCVALTOT,_NCALIIPI")
SetPrvt("_NQUANT,_NVALUNI,_NVALMER,_NVALTOT,_NALIIPI,_CCF")
SetPrvt("_CTES,_CPROD,_DEMISSAO,_NTOTQUANT,_NTOTPRCVEN,_NTOTVALTOT")
SetPrvt("_NTOTVALMER,_NTOTVALIPI,_NCTOTQUANT,_NCTOTPRCVEN,_NCTOTVALTOT,_NCTOTVALMER")
SetPrvt("_NCTOTVALIPI,_NGTOTQUANT,_NGTOTPRCVEN,_NGTOTVALTOT,_NGTOTVALMER,_NGTOTVALIPI")
SetPrvt("LCLICOMPL,_NPRCVEN,_NVALIPI,_NCPRCVEN,_NCVALIPI,_NCOD")
SetPrvt("_NCLIENTE,_NLOJA,_NVALMED,_NCVALMED,_NTOTVALMED,_NCTOTVALMED")
SetPrvt("_NGTOTVALMED,_NFATSIPI,_NFATCIPI,_NVALDEV,_NACUSIPI,_NACUCIPI")
SetPrvt("_NEMISSAO,")
SetPrvt("M_Pag,_Cab,_aGer")

_aGer   := {}
cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem := 0
M_Pag := 1
tamanho:="M"
limite :=132
cString:="SF2"
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0                                             
_Cab     := ""
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relatorio de Faturamento"
cDesc1   := "Diario     : Cliente x NF's"
cDesc2   := "Diario (A) : Cliente x Produto"
cDesc3   := "Resumo     : Por dia, com devolucoes"
cString  := "SD1"
nTipo    := 0
nomeprog := "NHFAT003"
cPerg    := "NHFA03"
nPag     := 1
pergunte('NHFA03',.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Data Inicial                                    ³
//³ mv_par02     Data Final                                      ³
//³ mv_par03     Cliente Inicial                                 ³
//³ mv_par04     Cliente Final                                   ³
//³ mv_par05     Diario / Diario (A) / Resumo                    ³
//---------------------------------------------------------------³
//parametros adicionados (Joao Felipe da Rosa) 					 ³
//³ mv_par06	 whbiii?      (sim/nao)							 ³	
//³ mv_par07     gera txt ?   (sim/nao)							 ³
//³ mv_par08	 Grupo Inicial									 ³	
//³ mv_par08	 Grupo Final									 ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM
	mv_par06 := 2
EndIf


wnrel:= "NHFAT003"

SetPrint("SF2",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

//If pergunte('NHFA03',.T.)
     //
//Endif

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ntipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

_F2VALMER  := 0
_F2VALTOT  := 0

_TOTVALMER  := 0
_TOTVALTOT  := 0

DbSelectArea("SF2")

nRos:=SM0->M0_CGC
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]
lPrimeiro := .T.


SF2->(DbSetOrder(6))
SF2->(DbSeek(xFilial("SF2")+DTOS(mv_par01),.T.))

If mv_par05 == 1
   _cESCOLHA := " Diario (Cliente x NF)"     
   cabec1 := " * (C) = Complemento de Valor "
   _cab   := " * (C) = Complemento de Valor "
   cabec2 := "No. NF  SERIE    DATA       QTDE    CFO/TES CODIGO PRODUTO           VALOR UNIT      VALOR MERC   % IPI         VALOR TOTAL"
//   cabec3 := "------  ---   ----------  --------- ------- --------------------  -------------   -------------   -----   -----------------"
   //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
   //         1         10        20        30        40        50        60        70        80        90        100       110       120       130
Elseif mv_par05 == 2
   _cESCOLHA := " Diario (A) (Cliente x Produto)"
   cabec1 := " * (C) = Complemento de Valor "
   _cab   := " * (C) = Complemento de Valor "
   cabec2 := "PECA                  DESCRICAO                   QUANTIDADE    VALOR MEDIO     TOTAL S/IPI   % IPI    VALOR IPI         VALOR TOTAL"
//   cabec3 := "--------------------  -------------------------  -----------  -------------   -------------   -----   -----------  -----------------"
   //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
   //         1         10        20        30        40        50        60        70        80        90        100       110       120       130
Elseif mv_par05 == 3
   _cESCOLHA := " Resumo com Devolucoes"
   cabec1 := "   DATA DE         VALOR FATURADO              ACUMULADO         VALOR FATURADO              ACUMULADO              VALOR DAS "
   cabec2 := "   EMISSAO                SEM IPI                SEM IPI                COM IPI                COM IPI             DEVOLUCOES "
//   cabec3 := "----------     ------------------     ------------------     ------------------     ------------------     ------------------ "
   //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
   //         1         10        20        30        40        50        60        70        80        90        100       110       120       130
Endif
titulo   := titulo + _cESCOLHA +"   De  "+ Dtoc(Mv_par01) +" Ate " + Dtoc(Mv_par02)

_Struct   := DbStruct("SF2")
//AADD(_Struct,{"F2_DOC",    "C",06,0})
//AADD(_Struct,{"F2_SERIE",  "C",03,0})
//AADD(_Struct,{"F2_EMISSAO","D",08,0})
//AADD(_Struct,{"F2_VALFAT", "N",14,2})
//AADD(_Struct,{"F2_CLIENTE","C",06,0})
//AADD(_Struct,{"F2_LOJA",   "C",02,0})
AADD(_Struct,{"F2_COD",    "C",20,0})
AADD(_Struct,{"F2_QUANT",  "N",14,3})
AADD(_Struct,{"F2_PRCVEN", "N",14,2})
AADD(_Struct,{"F2_TOTAL",  "N",14,2})
AADD(_Struct,{"F2_IPI",    "N",06,2})
//AADD(_Struct,{"F2_VALIPI", "N",14,2})
AADD(_Struct,{"F2_VALDEV", "N",14,2})
_cArquivo := CriaTrab(_Struct)
Use (_cArquivo) Alias PROCSF2 New Exclusive
If mv_par05 == 1
   Index on Dtos(F2_EMISSAO)+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE to (_cArquivo)
Elseif mv_par05 == 2
   Index on F2_CLIENTE+F2_LOJA+F2_COD to (_cArquivo)
Elseif mv_par05 == 3
   Index on Dtos(F2_EMISSAO) to (_cArquivo)
Endif
DbSelectArea("PROCSF2")
DbCloseArea()

//Close PROCSF2

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

setprc(0,0)
rptStatus({||Imprime()},"Imprimindo...")

Return            

Static Function Gerando()
Use (_cArquivo) Index (_cArquivo) Alias PROCSF2 New Exclusive
DbSelectArea("PROCSF2")

If mv_par05 == 1
   DbSelectArea("SF2")
   SetRegua(SF2->(RecCount()))
   SF2->(DbSetOrder(6))
   SF2->(DbSeek(xFilial("SF2")+Dtos(mv_par01),.T.))
   While SF2->F2_EMISSAO <= mv_par02 .and. !SF2->(Eof())
      If SF2->F2_CLIENTE >= mv_par03 .and. SF2->F2_EMISSAO <= mv_par02 .and. SF2->F2_VALFAT <> 0.00
         RecLock("PROCSF2",.T.)
         PROCSF2->F2_DOC     := SF2->F2_DOC
         PROCSF2->F2_SERIE   := SF2->F2_SERIE
         PROCSF2->F2_EMISSAO := SF2->F2_EMISSAO
         PROCSF2->F2_VALFAT  := SF2->F2_VALFAT
         PROCSF2->F2_CLIENTE := SF2->F2_CLIENTE
         PROCSF2->F2_LOJA    := SF2->F2_LOJA
         PROCSF2->F2_TIPO    := SF2->F2_TIPO
         MsUnlock("PROCSF2")
      Endif
      SF2->(DbSkip())
      IncRegua()
   Enddo
Elseif mv_par05 == 2 .or. mv_par05 == 3
   DbSelectArea("SD2")
   SetRegua(SD2->(RecCount()))
   SD2->(DbSetOrder(5))
   SD2->(DbSeek(xFilial("SD2")+Dtos(mv_par01),.T.))
   While SD2->D2_EMISSAO <= mv_par02 .and. !SD2->(Eof())
      If SD2->D2_CLIENTE >= mv_par03 .and. SD2->D2_CLIENTE <= mv_par04
         SF2->(DbSetOrder(1))
         SF2->(DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
         If SF2->F2_VALFAT <> 0.00
			If mv_par06 == 1 .And. Substr(SD2->D2_COD,7,1)$"4/3"
	            RecLock("PROCSF2",.T.)
	            PROCSF2->F2_QUANT   := SD2->D2_QUANT
	            PROCSF2->F2_PRCVEN  := SD2->D2_PRCVEN
	            PROCSF2->F2_TOTAL   := SD2->D2_TOTAL
	            PROCSF2->F2_IPI     := SD2->D2_IPI
	            PROCSF2->F2_VALIPI  := SD2->D2_VALIPI
	            PROCSF2->F2_DOC     := SD2->D2_DOC
	            PROCSF2->F2_SERIE   := SD2->D2_SERIE
	            PROCSF2->F2_EMISSAO := SD2->D2_EMISSAO
	            PROCSF2->F2_VALFAT  := SF2->F2_VALFAT
	            PROCSF2->F2_CLIENTE := SD2->D2_CLIENTE
	            PROCSF2->F2_LOJA    := SD2->D2_LOJA
	            PROCSF2->F2_COD     := SD2->D2_COD
	            PROCSF2->F2_VALDEV  := SD2->D2_VALDEV
	            PROCSF2->F2_TIPO    := SF2->F2_TIPO
	            MsUnlock("PROCSF2")
	  		ElseIf mv_par06 == 2
	            RecLock("PROCSF2",.T.)
	            PROCSF2->F2_QUANT   := SD2->D2_QUANT
	            PROCSF2->F2_PRCVEN  := SD2->D2_PRCVEN
	            PROCSF2->F2_TOTAL   := SD2->D2_TOTAL
	            PROCSF2->F2_IPI     := SD2->D2_IPI
	            PROCSF2->F2_VALIPI  := SD2->D2_VALIPI
	            PROCSF2->F2_DOC     := SD2->D2_DOC
	            PROCSF2->F2_SERIE   := SD2->D2_SERIE
	            PROCSF2->F2_EMISSAO := SD2->D2_EMISSAO
	            PROCSF2->F2_VALFAT  := SF2->F2_VALFAT
	            PROCSF2->F2_CLIENTE := SD2->D2_CLIENTE
	            PROCSF2->F2_LOJA    := SD2->D2_LOJA
	            PROCSF2->F2_COD     := SD2->D2_COD
	            PROCSF2->F2_VALDEV  := SD2->D2_VALDEV
	            PROCSF2->F2_TIPO    := SF2->F2_TIPO
	            MsUnlock("PROCSF2")
	  		EndIf
         Endif
      Endif
      SD2->(DbSkip())
      IncRegua()
   Enddo
Endif
Return

Static Function Imprime()
//Close PROCSF2
DbSelectArea("PROCSF2")
DbCloseArea()

Use (_cArquivo) Index (_cArquivo) Alias PROCSF2 New Exclusive
DbSelectArea("PROCSF2")
SetRegua(RecCount())
PROCSF2->(DbGoTop())
If mv_par05 == 1
   While PROCSF2->F2_EMISSAO <= mv_par02 .and. !PROCSF2->(Eof())
      If PROCSF2->F2_CLIENTE >= mv_par03 .and. PROCSF2->F2_CLIENTE <= mv_par04 .and. PROCSF2->F2_EMISSAO <= mv_par02 .and. PROCSF2->F2_VALFAT <> 0.00
         If PROCSF2->F2_EMISSAO <>_dEMISSAO .and. lPrimeiro == .F. .and. !PROCSF2->(Eof())
            If pRow() > 60
              // Eject
              // nPag := nPag + 1
              // Cabecalho()
      	       SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))        
      	       If Mv_Par05 <> 3
  		          Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		       Endif   
               Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
            Endif
            @ pRow()+1,001 Psay "TOTAL DO CLIENTE ----->"
            @ pRow(),083   Psay _F2VALMER  picture "@E 99,999,999.99"
            @ pRow(),107   Psay _F2VALTOT  picture "@E 99,999,999,999.99"
            @ pRow()+2,001 Psay "T O T A L   G E R A L  ----->"
            @ pRow(),083   Psay _TOTVALMER  picture "@E 99,999,999.99"
            @ pRow(),107   Psay _TOTVALTOT  picture "@E 99,999,999,999.99"
            @ pRow()+2,001 Psay " "
            _F2VALMER   := 0
            _F2VALTOT   := 0
            _TOTVALMER  := 0
            _TOTVALTOT  := 0
            _cCLIENTE   := PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA
            @ 67,01 Psay " "
         Endif
         If PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA <> _cCLIENTE .and. lPrimeiro == .F. .and. !PROCSF2->(Eof())
            @ pRow()+1,001 Psay "TOTAL DO CLIENTE ----->"
            @ pRow(),083 Psay _F2VALMER  picture "@E 99,999,999.99"
            @ pRow(),107 Psay _F2VALTOT  picture "@E 99,999,999,999.99" 
            
            SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
			@ prow()+1,01 Psay " "
			@ prow()+1,01 Psay SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME
			@ prow()+1,01 Psay " "
            
//            If pRow() > 64
//               Eject
//               nPag := nPag + 1
//               Cabecalho()
               
//            Endif

           // Cabecli()
            _F2VALMER  := 0
            _F2VALTOT  := 0
         Endif
         If pRow() > 60
         //   Eject
        //    nPag := nPag + 1
       //     Cabecalho()                                                                              
  		    SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
			
			If Mv_Par05 <> 3
  		        Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		    Endif   

            Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
         Endif
         SD2->(DbSetOrder(3))
         SD2->(DbSeek(xFilial("SD2")+PROCSF2->F2_DOC+PROCSF2->F2_SERIE+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
         While (SD2->D2_DOC+SD2->D2_SERIE) == (PROCSF2->F2_DOC+PROCSF2->F2_SERIE) .and. !SD2->(Eof())
            _D2CHAVE := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
            _D2PROD  := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD
            SD2->(DbSkip())
            If SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD <> _D2PROD
               SD2->(DbSkip(-1))
               If SD2->D2_TES == "581" .Or. SD2->D2_TES == "596" 
                  lComplem := .T.
                  _ncQUANT  := SD2->D2_QUANT
                  _ncVALUNI := SD2->D2_PRCVEN
                  _ncVALMER := SD2->D2_TOTAL
                  _ncVALTOT := ((SD2->D2_TOTAL)+(SD2->D2_TOTAL * SD2->D2_IPI))
                  _ncALIIPI := SD2->D2_IPI
               Else
                  lComplem := .F.
                  _nQUANT  := SD2->D2_QUANT
                  _nVALUNI := SD2->D2_PRCVEN
                  _nVALMER := SD2->D2_TOTAL
                  _nVALTOT := ((SD2->D2_TOTAL)+(SD2->D2_TOTAL * SD2->D2_IPI))
                  _nALIIPI := SD2->D2_IPI
               Endif
               _cCF     := SD2->D2_CF
               _cTES    := SD2->D2_TES
               _cPROD   := SD2->D2_COD

               If lComplem == .T.
                  _F2VALMER   := _F2VALMER  + _ncVALMER
                  _F2VALTOT   := _F2VALTOT  + _ncVALTOT
                  _TOTVALMER  := _TOTVALMER + _ncVALMER
                  _TOTVALTOT  := _TOTVALTOT + _ncVALTOT
               Else
                  _F2VALMER   := _F2VALMER  + _nVALMER
                  _F2VALTOT   := _F2VALTOT  + _nVALTOT
                  _TOTVALMER  := _TOTVALMER + _nVALMER
                  _TOTVALTOT  := _TOTVALTOT + _nVALTOT
               Endif

               SD2->(DbSkip())
            Else
               _nVALMER := 0
               _nVALTOT := 0
               _nQUANT  := 0
               _nVALUNI := 0
               _ncQUANT  := 0
               _ncVALUNI := 0
               _ncVALMER := 0
               _ncVALTOT := 0
               SD2->(DbSkip(-1))
               While SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD == _D2PROD
                  If SD2->D2_TES == "581" .Or. SD2->D2_TES == "596" 
                     lComplem := .T.
                     _ncQUANT  := SD2->D2_QUANT
                     _ncVALUNI := SD2->D2_PRCVEN
                     _ncVALMER := SD2->D2_TOTAL
                     _ncVALTOT := ((SD2->D2_TOTAL)+(SD2->D2_TOTAL * SD2->D2_IPI))
                     _ncALIIPI := SD2->D2_IPI
                  Else
                     lComplem := .F.
                     _nQUANT  := _nQUANT   + SD2->D2_QUANT
                     // _nVALUNI := _nVALUNI  + SD2->D2_PRCVEN Alterado por Jose Roberto em 13/03/2001
                     _nVALUNI := SD2->D2_PRCVEN   
                     _nVALMER := _nVALMER  + SD2->D2_TOTAL
                     _nVALTOT := _nVALTOT + ((SD2->D2_TOTAL)+(SD2->D2_TOTAL * SD2->D2_IPI))
                     _nALIIPI := SD2->D2_IPI
                  Endif
                  _cCF     := SD2->D2_CF
                  _cTES    := SD2->D2_TES
                  _cPROD   := SD2->D2_COD
                  SD2->(DbSkip())
               Enddo

               If lComplem == .T.
                  _F2VALMER   := _F2VALMER  + _ncVALMER
                  _F2VALTOT   := _F2VALTOT  + _ncVALTOT
                  _TOTVALMER  := _TOTVALMER + _ncVALMER
                  _TOTVALTOT  := _TOTVALTOT + _ncVALTOT
               Else
                  _F2VALMER   := _F2VALMER  + _nVALMER
                  _F2VALTOT   := _F2VALTOT  + _nVALTOT
                  _TOTVALMER  := _TOTVALMER + _nVALMER
                  _TOTVALTOT  := _TOTVALTOT + _nVALTOT
               Endif

            Endif
            If !SD2->(Eof())
               If lPrimeiro == .T.
                  //  cabecalho()
        		  SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
		          If Mv_Par05 <> 3
  		             Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		          Endif   

                  Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
               Endif
               lPrimeiro := .F.
               If lComplem == .T.
                  If pRow() > 60
                  //   Eject
                  //   nPag := nPag + 1
                  //   Cabecalho()
          		     SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
		            
		             If Mv_Par05 <> 3
  		                Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		             Endif   
	             
                     Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
                  Endif
                  @ pRow()+1,000 Psay PROCSF2->F2_DOC
                  @ pRow(),008 Psay PROCSF2->F2_SERIE
                  @ pRow(),014 Psay PROCSF2->F2_EMISSAO picture "99/99/9999"
                  @ pRow(),026 Psay _ncQUANT picture "@E 99,999.99"
                  @ pRow(),036 Psay _cCF
                  @ pRow(),039 Psay "."
                  @ pRow(),040 Psay _cTES
                  @ pRow(),044 Psay "(C) "+Left(_cPROD,16)
                  @ pRow(),066 Psay _ncVALUNI  picture "@E 99,999,999.99"
                  @ pRow(),082 Psay _ncVALMER  picture "@E 99,999,999.99"
                  @ pRow(),098 Psay _ncALIIPI  picture "@E 99.99"
                  @ pRow(),106 Psay _ncVALTOT  picture "@E 99,999,999,999.99"
               Else
                  If pRow() > 60
                  //   Eject
                  //   nPag := nPag + 1
                 //    Cabecalho()
                     SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
		             If Mv_Par05 <> 3
  		                 Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		             Endif   
		             
                     Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
                  Endif
                  If _nQUANT <> 0.00 .and. _nVALMER <> 0.00
                     @ pRow()+1,000 Psay PROCSF2->F2_DOC
                     @ pRow(),008 Psay PROCSF2->F2_SERIE
                     @ pRow(),014 Psay PROCSF2->F2_EMISSAO picture "99/99/9999"
                     @ pRow(),026 Psay _nQUANT picture "@E 99,999.99"
                     @ pRow(),036 Psay _cCF
                     @ pRow(),039 Psay "."
                     @ pRow(),040 Psay _cTES
                     @ pRow(),044 Psay _cPROD
                     @ pRow(),066 Psay _nVALUNI  picture "@E 99,999,999.99"
                     @ pRow(),082 Psay _nVALMER  picture "@E 99,999,999.99"
                     @ pRow(),098 Psay _nALIIPI  picture "@E 99.99"
                     @ pRow(),106 Psay _nVALTOT  picture "@E 99,999,999,999.99"
                  Endif
               Endif
            Endif
         Enddo
         _cCLIENTE := PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA
         _dEMISSAO := PROCSF2->F2_EMISSAO
      Endif
      PROCSF2->(Dbskip())
      IncRegua()
   Enddo
   
//   If pRow() > 64
   //   Eject
   //   nPag := nPag + 1
  //    Cabecalho()  
//      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
//   Endif
   @ pRow()+1,000 Psay "TOTAL DO CLIENTE  ----->"
   @ pRow(),083   Psay _F2VALMER  picture "@E 99,999,999.99"
   @ pRow(),107   Psay _F2VALTOT  picture "@E 99,999,999,999.99"
   @ pRow()+2,000 Psay " "
   
   If pRow() > 60
//      Eject
//      nPag := nPag + 1
//      Cabecalho()
 	  SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
      If Mv_Par05 <> 3
          Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
      Endif   

      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
   Endif
   @ pRow()+1,000 Psay "T O T A L   G E R A L  ----->"
   @ pRow(),083   Psay _TOTVALMER  picture "@E 99,999,999.99"
   @ pRow(),107   Psay _TOTVALTOT  picture "@E 99,999,999,999.99"
   @ pRow()+1,000 Psay " "
Elseif mv_par05 == 2
   _cCLIENTE   := PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA
   _cPROD      := PROCSF2->F2_COD
   _nTOTQUANT  := 0
   _nTOTPRCVEN := 0
   _nTOTVALTOT := 0
   _nTOTVALMER := 0
   _nTOTVALIPI := 0
   _ncTOTQUANT  := 0
   _ncTOTPRCVEN := 0
   _ncTOTVALTOT := 0
   _ncTOTVALMER := 0
   _ncTOTVALIPI := 0
   _nGTOTQUANT  := 0
   _nGTOTPRCVEN := 0
   _nGTOTVALTOT := 0
   _nGTOTVALMER := 0
   _nGTOTVALIPI := 0
   lCliCompl := .F.
   While !PROCSF2->(Eof())
      If pRow() > 60 .or. lPrimeiro == .T.
       //  Eject
      //   nPag := nPag + 1
      //  Cabecalho()
 		 SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
         If Mv_Par05 <> 3
            Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
         Endif   

         Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)         
      Endif
      _nQUANT   := 0
      _nPRCVEN  := 0
      _nVALTOT  := 0
      _nVALMER  := 0
      _nVALIPI  := 0
      _ncQUANT   := 0
      _ncPRCVEN  := 0
      _ncVALTOT  := 0
      _ncVALMER  := 0
      _ncVALIPI  := 0
      _cPROD    := PROCSF2->F2_COD
      _cCLIENTE := PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA
      lComplem := .F.
      While PROCSF2->F2_COD == _cPROD .and. !PROCSF2->(Eof())
         SD2->(DbSetOrder(1))
         SD2->(DbSetOrder(3))
         SD2->(DbSeek(xFilial("SD2")+PROCSF2->F2_DOC+PROCSF2->F2_SERIE+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
         If SD2->D2_TES == "581" .Or. SD2->D2_TES == "596" 
            lComplem := .T.
            lCliCompl := .T.
            _ncQUANT   := _ncQUANT  + PROCSF2->F2_QUANT
            // _ncPRCVEN  := _ncPRCVEN + PROCSF2->F2_PRCVEN alterado por Jose Roberto em 13/03/2001
            _ncPRCVEN  := PROCSF2->F2_PRCVEN
            _ncVALMER  := _ncVALMER + PROCSF2->F2_TOTAL
            _ncVALIPI  := _ncVALIPI + PROCSF2->F2_VALIPI
            _ncVALTOT  := _ncVALTOT + PROCSF2->F2_TOTAL
            _nCOD     := PROCSF2->F2_COD
            _nCLIENTE := PROCSF2->F2_CLIENTE
            _nLOJA    := PROCSF2->F2_LOJA
            _ncALIIPI  := PROCSF2->F2_IPI
            _ncTOTQUANT   := _ncTOTQUANT  + PROCSF2->F2_QUANT
            // _ncTOTPRCVEN  := _ncTOTPRCVEN + PROCSF2->F2_PRCVEN Alterado por Jose Roberto em 13/03/2001
            _ncTOTVALTOT  := _ncTOTVALTOT + PROCSF2->F2_TOTAL
            _ncTOTVALMER  := _ncTOTVALMER + PROCSF2->F2_TOTAL
            _ncTOTVALIPI  := _ncTOTVALIPI + PROCSF2->F2_VALIPI
         Else
            _nQUANT   := _nQUANT  + PROCSF2->F2_QUANT
            _nPRCVEN  := _nPRCVEN + PROCSF2->F2_PRCVEN // Alterado por Jose Roberto em 13/03/2001
            _nPRCVEN  := PROCSF2->F2_PRCVEN
            _nVALMER  := _nVALMER + PROCSF2->F2_TOTAL
            _nVALIPI  := _nVALIPI + PROCSF2->F2_VALIPI
            _nVALTOT  := _nVALTOT + PROCSF2->F2_TOTAL
            _nALIIPI  := PROCSF2->F2_IPI
            _nTOTQUANT   := _nTOTQUANT  + PROCSF2->F2_QUANT
            // _nTOTPRCVEN  := _nTOTPRCVEN + PROCSF2->F2_PRCVEN
            _nTOTVALTOT  := _nTOTVALTOT + PROCSF2->F2_TOTAL
            _nTOTVALMER  := _nTOTVALMER + PROCSF2->F2_TOTAL
            _nTOTVALIPI  := _nTOTVALIPI + PROCSF2->F2_VALIPI
         Endif
         _nCOD     := PROCSF2->F2_COD
         _nCLIENTE := PROCSF2->F2_CLIENTE
         _nLOJA    := PROCSF2->F2_LOJA

         _nGTOTQUANT  := _nGTOTQUANT  + PROCSF2->F2_QUANT
         // _nGTOTPRCVEN := _nGTOTPRCVEN + PROCSF2->F2_PRCVEN
         _nGTOTVALTOT := _nGTOTVALTOT + PROCSF2->F2_TOTAL
         _nGTOTVALMER := _nGTOTVALMER + PROCSF2->F2_TOTAL
         _nGTOTVALIPI := _nGTOTVALIPI + PROCSF2->F2_VALIPI
         PROCSF2->(Dbskip())
         IncRegua()
      Enddo

      If _nQUANT <> 0.00 .and. _nVALMER <> 0.00
       //  If pRow() > 64 .or. lPrimeiro == .T.
       //     Eject
       //     nPag := nPag + 1
       //     Cabecalho()
        //    SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
   	    //    If Mv_Par05 <> 3
  		//        Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		//    Endif   
        //    Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)    
        // Endif
         @ pRow()+1,001 Psay _nCOD
         SB1->(DbSetOrder(1))
         SB1->(DbSeek(xFilial("SB1")+_nCOD))
         @ pRow(),022 Psay Left(SB1->B1_DESC,25)
         @ pRow(),049 Psay _nQUANT picture "@E 999,999.999"
         _nVALMED := _nVALMER / _nQUANT
         @ pRow(),062 Psay _nVALMED  picture "@E 99,999,999.99"
         @ pRow(),078 Psay _nVALMER  picture "@E 99,999,999.99"
         @ pRow(),094 Psay _nALIIPI  picture "@E 99.99"
         @ pRow(),103 Psay _nVALIPI  picture "@E 999,999.99"
         @ pRow(),115 Psay (_nVALTOT+_nVALIPI)  picture "@E 99,999,999,999.99"
          aAdd(_aGer,{_nCOD, Left(SB1->B1_DESC,25), _nQuant  ,_nVALMED, _nVALMER,_nALIIPI,_nVALIPI ,(_nVALTOT+_nVALIPI)})
      Endif

      If lComplem == .T.
         If pRow() > 60 // .or. lPrimeiro == .T.
          //  Eject
         //   nPag := nPag + 1
         //   Cabecalho() 
     		SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
		    If Mv_Par05 <> 3
  		        Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		    Endif   
	    
            Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
         Endif
         @ pRow()+1,001 Psay _nCOD
         SB1->(DbSetOrder(1))
         SB1->(DbSeek(xFilial("SB1")+_nCOD))
         @ pRow(),022 Psay "* (C)"+Left(SB1->B1_DESC,20)
         @ pRow(),049 Psay _ncQUANT picture "@E 999,999.999"
         _ncVALMED := _ncVALMER / _ncQUANT
         @ pRow(),062 Psay _ncVALMED  picture "@E 99,999,999.99"
         @ pRow(),078 Psay _ncVALMER  picture "@E 99,999,999.99"
         @ pRow(),094 Psay _ncALIIPI  picture "@E 99.99"
         @ pRow(),103 Psay _ncVALIPI  picture "@E 999,999.99"
         @ pRow(),115 Psay (_ncVALTOT+_ncVALIPI)  picture "@E 99,999,999,999.99"
		aAdd(_aGer,{_nCOD, Left(SB1->B1_DESC,25), _nQuant  ,_nVALMED, _nVALMER,_nALIIPI,_nVALIPI ,(_nVALTOT+_nVALIPI)})
      Endif

      lPrimeiro := .F.
      If PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA <> _cCLIENTE .and. !PROCSF2->(Eof())
         
         @ pRow()+1,001 Psay "TOTAL DO CLIENTE ----->"
         @ pRow(),049 Psay _nTOTQUANT picture "@E 999,999.999"
         _nTOTVALMED := _nTOTVALMER / _nTOTQUANT
         @ pRow(),062 Psay _nTOTVALMED  picture "@E 99,999,999.99"
         @ pRow(),078 Psay _nTOTVALTOT  picture "@E 99,999,999.99"
         @ pRow(),103 Psay _nTOTVALIPI picture "@E 999,999.99"
         @ pRow(),115 Psay (_nTOTVALTOT+_nTOTVALIPI)  picture "@E 99,999,999,999.99"
         If lCliCompl == .T.
            @ pRow()+1,001 Psay "TOTAL * (C) Compl. de Valores --> "
            @ pRow(),049 Psay _ncTOTQUANT picture "@E 999,999.999"
            _ncTOTVALMED := _ncTOTVALMER / _ncTOTQUANT
            @ pRow(),062 Psay _ncTOTVALMED  picture "@E 99,999,999.99"
            @ pRow(),078 Psay _ncTOTVALTOT  picture "@E 99,999,999.99"
            @ pRow(),103 Psay _ncTOTVALIPI picture "@E 999,999.99"
            @ pRow(),115 Psay (_ncTOTVALTOT+_ncTOTVALIPI)  picture "@E 99,999,999,999.99"
            lCliCompl := .F.
         Endif                       
         SA1->(DbSetOrder(1))
      	 SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
		 @ prow()+1,01 Psay " "
		 @ prow()+1,01 Psay SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME
		 @ prow()+1,01 Psay " "

         If pRow() > 64 .or. lPrimeiro == .T.
         //   Eject
         //   nPag := nPag + 1
        //    Cabecalho()
            SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
    	    If Mv_Par05 <> 3
  		        Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  		    Endif   
		 
            Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)            
         Endif
                
         _nTOTQUANT   := 0
         _nTOTPRCVEN  := 0
         _nTOTVALTOT  := 0
         _nTOTVALMER  := 0
         _nTOTVALIPI  := 0
         _ncTOTQUANT  := 0
         _ncTOTPRCVEN := 0
         _ncTOTVALTOT := 0
         _ncTOTVALMER := 0
         _ncTOTVALIPI := 0
        // Cabecli()
      Endif
   Enddo
   
//   If pRow() > 64 .or. lPrimeiro == .T.
    //  Eject
    //  nPag := nPag + 1
    // Cabecalho()       
//	  SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
//      If Mv_Par05 <> 3
//          Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
//      Endif   
//      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)      
//   Endif

   @ pRow()+1,001 Psay "TOTAL DO CLIENTE ----->"
   @ pRow(),049 Psay _nTOTQUANT picture "@E 999,999.999"
   _nTOTVALMED := _nTOTVALMER / _nTOTQUANT
   @ pRow(),062 Psay _nTOTVALMED  picture "@E 99,999,999.99"
   @ pRow(),078 Psay _nTOTVALTOT  picture "@E 99,999,999.99"
   @ pRow(),103 Psay _nTOTVALIPI picture "@E 999,999.99"
   @ pRow(),115 Psay (_nTOTVALTOT+_nTOTVALIPI)  picture "@E 99,999,999,999.99"
   @ pRow()+2,000 Psay " "

   If lCliCompl == .T.
   
      @ pRow()+1,000 Psay "TOTAL * (C) Compl. de Valores --> "
      @ pRow(),049 Psay _ncTOTQUANT picture "@E 999,999.999"
      _ncTOTVALMED := _ncTOTVALMER / _ncTOTQUANT
      @ pRow(),062 Psay _ncTOTVALMED  picture "@E 99,999,999.99"
      @ pRow(),078 Psay _ncTOTVALTOT  picture "@E 99,999,999.99"
      @ pRow(),103 Psay _ncTOTVALIPI picture "@E 999,999.99"
      @ pRow(),115 Psay (_ncTOTVALTOT+_ncTOTVALIPI)  picture "@E 99,999,999,999.99"
      lCliCompl := .F.
   Endif
   SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
   If Mv_Par05 <> 3 .And. !Empty(SA1->A1_COD)
       @ prow()+1,01 Psay " "
       @ prow()+1,01 Psay SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME
       @ prow()+1,01 Psay " "
   Endif
   
   If pRow() > 60 .or. lPrimeiro == .T.
    //  Eject
    //  nPag := nPag + 1
     // Cabecalho()
      SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
	
      If Mv_Par05 <> 3
  	      Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  	  Endif   
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)      
   Endif

   @ pRow()+1,001 Psay "T O T A L   G E R A L  ----->"
   @ pRow(),046 Psay _nGTOTQUANT picture "@E 99,999,999.999"
   _nGTOTVALMED := _nGTOTVALMER / _nGTOTQUANT
   //@ pRow(),062 Psay _nGTOTVALMED  picture "@E 99,999,999.99"
   @ pRow(),078 Psay _nGTOTVALTOT  picture "@E 99,999,999.99"
   @ pRow(),103 Psay _nGTOTVALIPI picture "@E 999,999.99"
   @ pRow(),115 Psay (_nGTOTVALTOT+_nGTOTVALIPI)  picture "@E 99,999,999,999.99"
   @ pRow()+2,001 Psay " "
Elseif mv_par05 == 3
   _nFATSIPI  := 0
   _nFATCIPI  := 0
   _nVALDEV   := 0
   _nACUSIPI  := 0
   _nACUCIPI  := 0
   While !PROCSF2->(Eof())
      If pRow() > 60 .or. lPrimeiro == .T.
     //    Eject
     //    nPag := nPag + 1
     //    Cabecalho() 
   		 SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))

  	     If Mv_Par05 <> 3 
  	         Cabec1 := "  "+ SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME +	"     "+_cab
  	     Endif   
         Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)         
      Endif
      _dEMISSAO := PROCSF2->F2_EMISSAO
      While PROCSF2->F2_EMISSAO == _dEMISSAO .and. !PROCSF2->(Eof())
         _nFATSIPI := _nFATSIPI + PROCSF2->F2_TOTAL
         _nFATCIPI := _nFATCIPI + (PROCSF2->F2_TOTAL + PROCSF2->F2_VALIPI)
         _nVALDEV  := _nVALDEV  + PROCSF2->F2_VALDEV
         _nEMISSAO := PROCSF2->F2_EMISSAO
         PROCSF2->(Dbskip())
         IncRegua()
      Enddo
      @ pRow()+1,001 Psay _nEMISSAO
      @ pRow(),015   Psay _nFATSIPI  picture "@E 999,999,999,999.99"
      _nACUSIPI := _nACUSIPI + _nFATSIPI
      @ pRow(),038   Psay _nACUSIPI  picture "@E 999,999,999,999.99"
      @ pRow(),061   Psay _nFATCIPI  picture "@E 999,999,999,999.99"
      _nACUCIPI := _nACUCIPI + _nFATCIPI
      @ pRow(),084   Psay _nACUCIPI  picture "@E 999,999,999,999.99"
      @ pRow(),107   Psay _nVALDEV   picture "@E 999,999,999,999.99"
      _nFATSIPI  := 0
      _nFATCIPI  := 0
      _nVALDEV   := 0
      lPrimeiro := .F.
   Enddo
Endif

If aReturn[5] == 1
   Set Printer To
   Commit
   Ourspool(wnrel) //Chamada do Spool de Impressao
Endif

DbSelectArea("PROCSF2")
DbCloseArea("PROCSF2")
MS_FLUSH() //Libera fila de relatorios em spool
fErase(_cArquivo+".DBF")
fErase(_cArquivo+".CDX")

If mv_par07 == 1
 	fGerar()
EndIf


Return


Static Function Cabecalho()

aDriver := ReadDriver()

If ( Tamanho == 'P' )
    @ 1,1 Psay &(aDriver[1])
ElseIf ( Tamanho == 'G' )
    @ 1,1 Psay &(aDriver[5])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 1 ) 
    @ 1,1 Psay &(aDriver[3])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 2 ) 
    @ 1,1 Psay &(aDriver[4])
EndIf


SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))

@ prow()+1,01 Psay Repli("*",132)
@ prow()+1,01 Psay "*"+SM0->M0_NOMECOM
@ prow(),112  Psay "Folha : "                                                                                                    
@ prow(),124  Psay StrZero(nPag,5,0)+"  *"
@ prow()+1,01 Psay "*S.I.G.A. / "+nomeprog
@ prow(),20   Psay PadC(titulo,82)
@ prow(),112  Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
@ prow()+1,01 Psay "*Hora...: "+Time()
@ prow(),112  Psay "Emissao: "+Dtoc(Date())+"  *"
@ prow()+1,01 Psay Repli("*",132)
@ prow()+1,01 Psay " "
If mv_par05 == 1
   @ prow()+1,01 Psay SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME
Endif
@ prow()+1,01 Psay cabec1
@ prow()+1,01 Psay cabec2
@ prow()+1,01 Psay cabec3


Return(nil)   


Static Function Cabecli()

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+PROCSF2->F2_CLIENTE+PROCSF2->F2_LOJA))
@ prow()+1,01 Psay " "
@ prow()+1,01 Psay SA1->A1_COD+" - "+SA1->A1_LOJA+" / "+SA1->A1_NOME
@ prow()+1,01 Psay cabec2
@ prow()+1,01 Psay cabec3



Return

//----------------------------------------
//  Funcao que gera o arquivo txt
//----------------------------------------

Static Function fGerar()

// Gera o arquivo txt

            _nOutFile:= Fcreate("C:\RELFAT\RelFat.txt",0)

            For x := 1 to Len(_aGer)
		       	Fwrite(_nOutFile,_aGer[x][1]+"	"+_aGer[x][2]+"	"+Str(_aGer[x][3],12,2) +"	"+Str(_aGer[x][4],12,2)+"	"+;
          					     Str(_aGer[x][5],12,2)+"	"+Str(_aGer[x][6],12,2)+"	"+Str(_aGer[x][7],12,2)+"	"+Str(_aGer[x][8],12,2)+ CHR(13)+CHR(10),200)

            Next x 

            Fclose(_nOutFile)
            MSGALERT('Relatorio Gerado Em: C:\RELFAT\RelFat.txt , caso não tenha sido criado, verifique se existe a pasta C:\RELFAT\')
            
            _aGer:= {}

Return 



