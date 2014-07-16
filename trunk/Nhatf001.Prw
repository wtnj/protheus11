/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHATF001  ³ Autor ³Raul S. de Paula       ³ Data ³ 23/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Resumido do Ativo Fixo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Para Cliente (?????)                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"        
#include "topconn.ch"   

User Function Nhatf001()    

SetPrvt("CSAVCUR1,CSAVCOR1,CSAVSCR1,NCOL,CMSGCONTA,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,AORDEM,NORDEM,LVALIDO,CPERG,CABEC2")
SetPrvt("CABEC1,TAMANHO,LIMITE,M_PAG,AREGISTROS,I")
SetPrvt("J,WNREL,CQUERY,NLI,_NTVORIG,_NTVRDMES")
SetPrvt("_NTVRDACM,_NTVRDRES,_NTVORIG99,_NTVRDMES99,_NTVRDACM99,_NTVRDRES99")
SetPrvt("_CCHAVEANT,_CORDEM,_NREGS,")


//+--------------------------------------------------------------+
//¦ Define Variaveis                                             ¦
//+--------------------------------------------------------------+
cSavCur1:=""
cSavCor1:=""
cSavScr1:=""
nCol := 0
cMsgConta := ""
Titulo :="Relatorio Resumo Ativo Fixo"
cDesc1 :=""
cdesc2 :=""
cDesc3 :=""
cString:="SN3"
aReturn := { "Especial", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog:="NHATF001"  //  "ATIFX01"
nLastKey:= 0                             
aOrdem := { 'CONTA CONTABIL', 'DATA AQUISICAO', 'CENTRO DE CUSTO','DEPRECIACAO'}
nOrdem := 0
lValido := .F.
cPerg   :="ATF001"
cabec2 := " "
//cabec1 := "CODIGO DESCRICAO                                     DT.AQUISICAO  CHAPA    VLOR ORIGINAL  TX%         DEPR.MENSAL    DEPR.ACUMULAD  VLR.RESIDUAL  "
//         9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/9999    XXXXXX   99.999.999,99  9999,99999  99.999.999,99  99.999.999,99  99.999.999,99 
//         1          12                                        54            67       77             92          104            119            134           
cabec1 := "CODIGO DESCRICAO                                    AQUISICAO  CHAPA    VLR ORIGINAL     TX%   DEPR.MENSAL DEPR.ACUMULAD VLR.RESIDUAL"
//         9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99   XXXXXX 99.999.999,99 99,9999 99.999.999,99 99.999.999,99 99.999.999,99 
//         0          11                                       52         63     70            84      92            106           120           
tamanho:="M"
limite := 150
m_pag := 1

//+--------------------------------------------------------------+
//¦ Variaveis para armazenar dados do Relatorio                  ¦
//+--------------------------------------------------------------+
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                ³
//³ mv_par01            // da  CODIGO N1_CBASE          ³
//³ mv_par02            // ate CoDIGO N1_CBASE          ³
//³ mv_par03            // DE COD CONTABIL N3_CCONTAB   ³
//³ mv_par04            // ATE COD CONTABIL N3_CCONTAB  ³
//³ mv_par05            // DE CENTRO DE CUSTO N3_CCUSTO ³
//³ mv_par06            // ATE CENTRO DE CUSTO N3_CCUSTO³
//³ mv_par07            // da  DATA AQUISICAO N1_AQUISIC³
//³ mv_par08            // ate DATA AQUISICAO N1_AQUISIC³
//³ mv_par09            // CONSIDERA BAIXA (SIM/NAO)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//+--------------------------------------------------------------+
//Ý Salva a Integridade dos dados de Saida                       Ý
//+--------------------------------------------------------------+
//cSavCur1 := SetCursor(0)
//cSavCor1 := SetColor("bg+/b,,,")
wnrel:= "NHATF001"
//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
pergunte(cperg,.f.)
wnrel  := SetPrint(cString,nomeprog,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem)
If nLastKey == 27
   Set Filter To
   Return
Endif
SetDefault(aReturn,cString)
set device to print

RptStatus({||Imprime()},"Imprime Relatorio")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> RptStatus({||Execute(Imprime)},"Imprime Relatorio")

If aReturn[5] == 1
   Set Printer TO 
   dbcommitAll()
   ourspool(wnrel)
Endif

Set Device To Screen

MS_Flush()

RETURN


Static Function Imprime()

nordem:=aReturn[8]
//TITULO:=TITULO + " POR " + AORDEM[NORDEM]
dbSelectArea("SN3")
dbSetOrder(1)
cquery :=          "SELECT * FROM "
cquery := cquery + RetSqlName("SN3")
cQuery := cQuery + " WHERE N3_FILIAL = '"+xFilial("SN3")+"' " 
cQuery := cQuery + " AND N3_CBASE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery := cQuery + " AND N3_CCONTAB BETWEEN '"+mv_par03+"' AND '"+MV_PAR04+"' "
cQuery := cQuery + " AND N3_CCUSTO  BETWEEN '"+mv_par05+"' AND '"+MV_PAR06+"' "
cQuery := cQuery + " AND N3_AQUISIC BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
IF MV_PAR09 == 2
   cquery:=cquery + "AND N3_BAIXA = '0' "
Endif
cquery := cquery + " AND D_E_L_E_T_ <> '*' "
if nordem == 1 
   cquery:= cquery + " ORDER BY N3_CCONTAB,N3_CBASE,N3_ITEM"
ELSEIF NORDEM==2
   cquery:= cquery + " ORDER BY N3_AQUISIC,N3_CBASE,N3_ITEM"  
ELSEIF NORDEM==3
   cQuery := cQuery + " ORDER BY N3_CCUSTO,N3_CBASE,N3_ITEM"   
ELSE               
   cQuery := cQuery + " ORDER BY N3_CCDEPR"
ENDIF                                       

TCQUERY cQuery NEW ALIAS TN3R     
DbSelectArea("SN1")
SN1->(DbSetOrder(1))
DbSelectArea("SN2")
SN2->(DbSetOrder(1))
nLI:= 65
_nTVORIG := _nTVRDMES := _nTVRDACM := _nTVRDRES := 0
_nTVORIG99:= _nTVRDMES99:= _nTVRDACM99:= _nTVRDRES99:= 0
_cChaveAnt:=''
_cOrdem:=''
If nOrdem     == 1
	_cOrdem := 'C.CONTABIL'
ELSEIF nOrdem == 2
	_cOrdem := 'DT.AQUISIC'
ELSEIF nOrdem == 3
	_cOrdem := 'C.CUSTO'
ELSE
	_cOrdem :='DEPRECIACAO'
ENDIF
DBSELECTAREA("TN3R")
TN3R->(dbGoTop())
_nRegs:= TN3R->(RecCount())
SetRegua(_nRegs)                 
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
While !TN3R->(Eof())
   IncRegua()

   If SN1->(dBSeek(xFilial("SN3") + TN3R->N3_CBASE + TN3R->N3_ITEM))
      If MV_PAR09 == 2 .AND. !Empty(SN1->N1_BAIXA)
         TN3R->(DbSkip())
         Loop
      Endif
   Endif      	


   if Prow() > 56
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   EndIf                                                  

   If _cChaveAnt == ''
		If nordem == 1 
			_cChaveAnt:=  TN3R->N3_CCONTAB
		ElseIf nOrdem == 2
			_cChaveAnt := TN3R->N3_AQUISIC
		ElseIf nOrdem == 3
			_cChaveAnt := TN3R->N3_CCUSTO
		Else
			_cChaveAnt := TN3R->N3_CCDEPR
		Endif
   Endif
	If nOrdem==1
	   If _cChaveAnt <> TN3R->N3_CCONTAB
			@ prow()+1,000 psay " "
			@ PROW()  ,070 PSAY '-------------'
			@ PROW()  ,092 PSAY '-------------'
			@ PROW()  ,106 PSAY '-------------'
			@ PROW()  ,120 PSAY '--------------'
			@ prow()+1,000 psay "TOTAL C.CONTAB."+_cChaveAnt+" --------> "
			@ PROW()  ,069 PSAY _nTVORIG99  PICTURE '@E 999,999,999.99'
			@ PROW()  ,092 PSAY _nTVRDMES99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,106 PSAY _nTVRDACM99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,120 PSAY _nTVRDRES99 PICTURE '@E 999,999,999.99'
			_nTVORIG99:= _nTVRDMES99:= _nTVRDACM99:= _nTVRDRES99:= 0
			_cChaveAnt:=TN3R->N3_CCONTAB
	 @ prow()+1,000 psay " "
		Endif
	ElseIf nOrdem==2
		If _cChaveAnt <> TN3R->N3_AQUISIC
			@ prow()+1,000 psay " "
			@ PROW()  ,070 PSAY '-------------'
			@ PROW()  ,092 PSAY '-------------'
			@ PROW()  ,106 PSAY '-------------'
			@ PROW()  ,120 PSAY '--------------'
			@ prow()+1,000 psay "TOTAL DT.AQUISICAO "+substr(_cChaveAnt,7,2)+'/'+substr(_cChaveAnt,5,2)+'/'+substr(_cChaveAnt,3,2)+" ----> "
			@ PROW()  ,069 PSAY _nTVORIG99  PICTURE '@E 999,999,999.99'
			@ PROW()  ,092 PSAY _nTVRDMES99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,106 PSAY _nTVRDACM99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,120 PSAY _nTVRDRES99 PICTURE '@E 999,999,999.99'
			_nTVORIG99 := _nTVRDMES99:= _nTVRDACM99:= _nTVRDRES99:= 0
			_cChaveAnt := TN3R->N3_AQUISIC
			 @ prow()+1,000 psay " "
		Endif
	ElseIf nOrdem==3
		If _cChaveAnt <> TN3R->N3_CCUSTO
			@ prow()+1,000 psay " "
			@ PROW()  ,070 PSAY '-------------'
			@ PROW()  ,092 PSAY '-------------'
			@ PROW()  ,106 PSAY '-------------'
			@ PROW()  ,120 PSAY '--------------'
			@ prow()+1,000 psay "TOTAL C.CUSTO "+_cChaveAnt+" ---------> "
			@ PROW()  ,069 PSAY _nTVORIG99  PICTURE '@E 999,999,999.99'
			@ PROW()  ,092 PSAY _nTVRDMES99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,106 PSAY _nTVRDACM99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,120 PSAY _nTVRDRES99 PICTURE '@E 999,999,999.99'
			_nTVORIG99 := _nTVRDMES99:= _nTVRDACM99:= _nTVRDRES99:= 0
			_cChaveAnt := TN3R->N3_CCUSTO
			 @ prow()+1,000 psay " "
		Endif
	Else 
		If _cChaveAnt <> TN3R->N3_CCDEPR
			@ prow()+1,000 psay " "
			@ PROW()  ,070 PSAY '-------------'
			@ PROW()  ,092 PSAY '-------------'
			@ PROW()  ,106 PSAY '-------------'
			@ PROW()  ,120 PSAY '--------------'
			@ prow()+1,000 psay "TOTAL DEPRECIACAO "+_cChaveAnt+" --------> "
			@ PROW()  ,069 PSAY _nTVORIG99  PICTURE '@E 999,999,999.99'
			@ PROW()  ,092 PSAY _nTVRDMES99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,106 PSAY _nTVRDACM99 PICTURE '@E 99,999,999.99'
			@ PROW()  ,120 PSAY _nTVRDRES99 PICTURE '@E 999,999,999.99'
			_nTVORIG99:= _nTVRDMES99:= _nTVRDACM99:= _nTVRDRES99:= 0
			_cChaveAnt:=TN3R->N3_CCDEPR
			 @ prow()+1,000 psay " "
		Endif
	Endif
	   nLI:=nLI + 1
	   @ prow()+1,000 psay TN3R->N3_CBASE
	   SN2->(DBGOTOP())
	   SN2->(DBSEEK(XFILIAL("SN2")+TN3R->N3_CBASE+TN3R->N3_ITEM+TN3R->N3_TIPO+"01")) 
	//   IF SN2->(FOUND())
	//      @ pRow()  ,011 Psay SN2->N2_HISTOR
	//   ENDIF   
	   SN1->(DBGOTOP())
	   SN1->(DBSEEK(XFILIAL("SN1")+TN3R->N3_CBASE+TN3R->N3_ITEM)) 
	   @ pRow()  ,011 Psay SN1->N1_DESCRIC
	   @ prow()  ,052 Psay SN1->N1_AQUISIC
	   @ PROW()  ,063 PSAY SN1->N1_CHAPA
	   @ PROW()  ,069 PSAY TN3R->N3_VORIG1  PICTURE '@E 999,999,999.99'
	   @ PROW()  ,084 PSAY TN3R->N3_TXDEPR1 PICTURE "@E 999.9999"
	   @ PROW()  ,092 PSAY TN3R->N3_VRDMES1 PICTURE '@E 99,999,999.99'
	   @ PROW()  ,106 PSAY TN3R->N3_VRDACM1 PICTURE '@E 99,999,999.99'
	   @ PROW()  ,120 PSAY (TN3R->N3_VORIG1-TN3R->N3_VRDACM1)PICTURE '@E 999,999,999.99' // VALOR CALCULADO
	// ACUMULA TOTAIS 
   _nTVORIG    := _nTVORIG    +  TN3R->N3_VORIG1
   _nTVRDMES   := _nTVRDMES   +  TN3R->N3_VRDMES1
   _nTVRDACM   := _nTVRDACM   +  TN3R->N3_VRDACM1
   _nTVRDRES   := _nTVRDRES   + (TN3R->N3_VORIG1-TN3R->N3_VRDACM1)
// ACUMULA SUB-TOTAIS   
   _nTVORIG99  := _nTVORIG99  +  TN3R->N3_VORIG1
   _nTVRDMES99 := _nTVRDMES99 +  TN3R->N3_VRDMES1
   _nTVRDACM99 := _nTVRDACM99 +  TN3R->N3_VRDACM1
   _nTVRDRES99 := _nTVRDRES99 + (TN3R->N3_VORIG1-TN3R->N3_VRDACM1)
   TN3R->(DBSKIP())
Enddo

// LINHA TOTAL    
If Prow() > 58
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIf   
@ prow()+1,000 psay " "
@ PROW()  ,069 PSAY '-------------'
@ PROW()  ,092 PSAY '-------------'
@ PROW()  ,106 PSAY '-------------'
@ PROW()  ,120 PSAY '--------------'
If nOrdem ==2
	@ prow()+1,000 psay "TOTAL DT.AQUISICAO "+substr(_cChaveAnt,7,2)+'/'+substr(_cChaveAnt,5,2)+'/'+substr(_cChaveAnt,3,2)+" ----> "
Else
	@ prow()+1,000 psay "TOTAL "+_cOrdem+' '+_cChaveAnt+" -------> "
Endif   
@ PROW()  ,069 PSAY _nTVORIG99  PICTURE '@E 999,999,999.99'
@ PROW()  ,092 PSAY _nTVRDMES99 PICTURE '@E 99,999,999.99'
@ PROW()  ,106 PSAY _nTVRDACM99 PICTURE '@E 99,999,999.99'
@ PROW()  ,120 PSAY _nTVRDRES99 PICTURE '@E 999,999,999.99'
@ prow()+2,000 psay "T O T A L  G E R A L -------------------> "
@ PROW()  ,069 PSAY _nTVORIG  PICTURE '@E 999,999,999.99'
@ PROW()  ,092 PSAY _nTVRDMES PICTURE '@E 99,999,999.99'
@ PROW()  ,106 PSAY _nTVRDACM PICTURE '@E 99,999,999.99'
@ PROW()  ,120 PSAY _nTVRDRES PICTURE '@E 999,999,999.99'
	
DBSELECTAREA("TN3R")
DBCLOSEAREA("TN3R")

Return
