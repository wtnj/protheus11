/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE003  ºAutor  ³Microsiga           º Data ³  03/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acordo Individual para prorrogacao de horas de trabalho    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function nhgpe003()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,")

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Acordo Individual para Prorrogacao de Horas de Trabalho"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP11"
cPerg    := 'RHGP07'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RHGP11"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


RptStatus({|| RHG011()})

Return Nil



Static Function RHG011()

DbSelectArea("SRA")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04
   IncRegua()
   @ 7, 22 pSay "* * "+ ALLTRIM(SM0->M0_NOMECOM) + " * *"
   @ pRow()+5, 18 pSay "ACORDO INDIVIDUAL PARA PRORROGACAO DE HORAS DE TRABALHO"


   If SM0->M0_CODIGO == "FN"	.AND. SM0->M0_CODFIL == "02"	
      @ pRow()+5, 01 pSay "ENTRE A EMPRESA " + Subs(SM0->M0_NOMECOM,1,33) + ", COM SEDE EM " + ALLTRIM(SM0->M0_CIDENT)
   Else
      @ pRow()+5, 01 pSay "ENTRE A EMPRESA " + Subs(SM0->M0_NOMECOM,1,40) + ", COM SEDE EM " + ALLTRIM(SM0->M0_CIDENT)
   Endif	            


   @ pRow()+1, 01 pSay "NA  " + Substr(SM0->M0_ENDENT,1,30) + ",  E O FUNCIONARIO ABAIXO ASSINADO, PORTADOR"
   @ pRow()+1, 01 pSay "DA CARTEIRA DE TRABALHO N. " + SRA->RA_NUMCP + ",SERIE N. " + SRA->RA_SERCP +" DE ACORDO COM O DISPOSITIVO"
   @ pRow()+1, 01 pSay "NO ARTIGO 59 SEU PARAGRAFO 1. DO DECRETO LEI N. 5452  DE  1 DE MAIO DE 1943 DA"
   @ pRow()+1, 01 pSay "C.L.T., CONFORME AS CLAUSULAS SEGUINTES : "
   
   @ pRow()+2, 01 pSay "1. A DURACAO DA JORNADA DIARIA DE TRABALHO PODERA  SER  ACRESCIDA  EM ATE DUAS"
   @ pRow()+1, 04 pSay "HORAS   EXTRAORDINARIAS,  RESPEITANDO-SE  OS  LIMITES PREVISTOS  EM  LEI OU" 
   @ pRow()+1, 04 pSay "CONVENCOES SINDICAIS DA CLASSE EM VIGOR."
   
   @ pRow()+2, 01 pSay "2. NA OCORRENCIA DE  HORAS  EXTRAORDINARIAS, TOMAR-SE-AO POR BASE  OS  LIMITES"
   @ pRow()+1, 04 pSay "E PERCENTUAIS  VIGENTES  NA  ULTIMA CONVENCAO TRABALHISTA EM  VIGOR SOBRE A"    
   @ pRow()+1, 04 pSay "HORA NORMAL DO MES CORRENTE."   
   
   @ pRow()+2, 01 pSay "3. O PRAZO DE DURACAO DO  PRESENTE  ACORDO E  POR PRAZO INDETERMINADO VIGORARA"   
   @ pRow()+1, 04 pSay "A PARTIR DA ASSINATURA DESTE."
   
   @ pRow()+5, 01 pSay SRA->RA_ADMISSA
   
   @ pRow()+5, 01 pSay "NOME : " + SRA->RA_NOME
   
   @ pRow()+5, 01 pSay "ASSINATURA : ______________________________________________________"
   
   @ pRow()+5, 01 pSay "EMPREGADOR : ______________________________________________________" 
   
   SRA->(DbSkip())
Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel)
Endif
MS_FLUSH()

Return
