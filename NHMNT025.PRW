#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT025   ºAutor ³João Felipe         º Data ³  05/05/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ MAPA DE MANUTENCAO 2					                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT025()   

cString   := "STJ"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("o mapa de manutenção do ano.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT025"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("MAPA DE MANUTENCAO 2")                                                                                                                           
cabec1    := "                                                           |                                  "+StrZero(Year(Date()),4)+"                                 |"
cabec2    := "Servico     Descricao                                      | JAN | FEV | MAR | ABR | MAI | JUN | JUL | AGO | SET | OUT | NOV | DEZ |"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT025"
_cPerg    := "MNT025" 
 
// mv_par01 DO BEM
// mv_par02 até BEM
// mv_par03 DE DATA 
// mv_par04 ATÉ DATA
// mv_par05 DA FAMILIA
// mv_par06 ATE FAMILIA
// mv_par07 DO SERVICO
// mv_par08 ATE SERVICO
// mv_par09 de ccusto
// mv_par10 ate ccusto
Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
Local cQuery

    //------------------
    // MONTA A QUERY
    //------------------
/*    
    cQuery := "SELECT TJ.TJ_CODBEM, T9.T9_NOME, TJ.TJ_SERVICO,T4.T4_NOME, TJ.TJ_DTMPINI, "
    cQuery += " TJ.TJ_DTMPFIM, TJ.TJ_DTMRINI, TJ.TJ_DTMRFIM, TJ.TJ_SEQUENC, TF.TF_NOMEMAN, "
    cQuery += " TF.TF_TEENMAN, TF.TF_UNENMAN, TF.TF_DTULTMA"
	cQuery += " FROM "+RetSqlName("STJ")+" TJ, "+RetSqlName("ST9")+" T9, "+RetSqlName("ST4")+" T4, "+RetSqlName("STF")+" TF"
	cQuery += " WHERE TJ.TJ_CODBEM = T9.T9_CODBEM"
	cQuery += " AND T4.T4_SERVICO = TJ.TJ_SERVICO"
	cQuery += " AND TF.TF_SEQUENC = TJ.TJ_SEQUENC"
	cQuery += " AND TF.TF_CODBEM = TJ.TJ_CODBEM"
	cQuery += " AND TF.TF_SERVICO = TJ.TJ_SERVICO"
	cQuery += " AND TJ.TJ_CODBEM  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
//	cQuery += " AND TJ.TJ_DTMRFIM >= '"+DtoS(mv_par03)+"'"
	cQuery += " AND T9.T9_CODFAMI BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	cQuery += " AND TJ.TJ_SERVICO BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	cQuery += " AND T9.T9_SITMAN = 'A'"
	cQuery += " AND T9.T9_SITBEM = 'A'"
	cQuery += " AND TJ.TJ_FILIAL = '"+xFilial("STJ")+"' AND TJ.D_E_L_E_T_ = ' '"
	cQuery += " AND T9.T9_FILIAL = '"+xFilial("ST9")+"' AND T9.D_E_L_E_T_ = ' '"
	cQuery += " AND T4.T4_FILIAL = '"+xFilial("ST4")+"' AND T4.D_E_L_E_T_ = ' '"
	cQuery += " AND TF.TF_FILIAL = '"+xFilial("STF")+"' AND TF.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY TJ.TJ_CODBEM"
*/
	
    cQuery := "SELECT TF.TF_CODBEM, T9.T9_NOME, TF.TF_SERVICO,T4.T4_NOME, TF.TF_SEQUENC, TF.TF_DTULTMA,"
    cQuery += " TF.TF_TEENMAN, TF.TF_UNENMAN, TF.TF_NOMEMAN, TF.TF_SEQRELA"
    cQuery += " FROM  "+RetSqlName("STF")+" TF, "+RetSqlName("ST9")+" T9, "+RetSqlName("ST4")+" T4 "
    cQuery += " WHERE TF.TF_CODBEM = T9.T9_CODBEM 
    cQuery += " AND  TF.TF_SERVICO = T4.T4_SERVICO 
	cQuery += " AND T9.T9_SITMAN = 'A'"
	cQuery += " AND T9.T9_SITBEM = 'A'"
	cQuery += " AND TF.TF_ATIVO = 'S'" 
	cQuery += " AND T9.T9_CCUSTO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cQuery += " AND T9.T9_OPERAC BETWEEN '"+mv_par11 +"' AND '"+ mv_par12+"'"
	cQuery += " AND TF.TF_CODBEM  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"	
	cQuery += " AND T9.T9_CODFAMI BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"	    
	cQuery += " AND TF.TF_SERVICO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND T9.T9_CENTRAB BETWEEN '"+mv_par13+"' AND '"+mv_par14+"'"
    cQuery += " AND T9.T9_FILIAL = '"+xFilial("ST9")+"' AND T9.D_E_L_E_T_ = ' '" 
    cQuery += " AND T4.T4_FILIAL = '"+xFilial("ST4")+"' AND T4.D_E_L_E_T_ = ' '" 
    cQuery += " AND TF.TF_FILIAL = '"+xFilial("STF")+"' AND TF.D_E_L_E_T_ = ' '" 
    cQuery += " ORDER BY TF.TF_CODBEM, TF.TF_SERVICO, TF.TF_SEQRELA"

	TCQUERY cQuery NEW ALIAS "TRA1" 
	MemoWrit('C:\TEMP\MNT025.SQL',cQuery)
	
//	TcSetField("TRA1","TJ_DTMPINI","D")  // Muda a data de string para date
//	TcSetField("TRA1","TJ_DTMPFIM","D")  // Muda a data de string para date
//	TcSetField("TRA1","TJ_DTMRINI","D")  // Muda a data de string para date
//	TcSetField("TRA1","TJ_DTMRFIM","D")  // Muda a data de string para date
	TcSetField("TRA1","TF_DTULTMA","D")  // Muda a data de string para date
	TRA1->(DbGoTop())

Return

Static Function RptDetail()

Local nCOL1
Local nCOL2  
Local dDt   
Local aVerf   := {}
Private aMnt  := {}
Private aPrev := {}
Private _cArqNtx
Private _cOrdem


Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 


ProcRegua(RecCount())

While TRA1->(!Eof()) 

	If Prow() > 55
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif

	IncProc("Imprimindo...")

	If "S"$TRA1->TF_UNENMAN .OR. "D"$TRA1->TF_UNENMAN
		TRA1->(DbSkip())
		Loop
	EndIf

 	//gera a data da previsao da proxima manutencao no array aPrev
	fCalcPrev(TRA1->TF_DTULTMA, TRA1->TF_TEENMAN, TRA1->TF_UNENMAN)
	//traz as datas de manutencao realizadas e previstas no array aMnt
	fManut(TRA1->TF_CODBEM, TRA1->TF_SERVICO)
		
	@Prow()+3, 001 psay "Bem: "+TRA1->TF_CODBEM + TRA1->T9_NOME
	@Prow()+1, 001 Psay "Serv.: "+TRA1->TF_SERVICO + " - " + SUBSTR(TRA1->T4_NOME,1,20)
    
	//** IMPRIME A DATA DA PREVISAO DA MANUTENCAO **//
	aVerf := {}
	nCOL1 := 60
	nCOL2 := 65
    @Prow()  , 054 Psay "Prev.|"

	//Imprime as 12 primeiras linhas dos meses
    For x := 1 To 12
       	@Prow()  ,nCOL2 Psay '|'
        nCOL2 := nCOL2 + 6
	Next

	//imprime a data da previsao das proximas manut.
	
 	For x:=1 to len(aPrev)
 		If !Empty(aPrev[x]) .and. ;
 		   Year(aPrev[x]) == Year(mv_par03) .And. ;
 		   aPrev[x] > mv_par03 ;
 		   .and. aPrev[x] <> TRA1->TF_DTULTMA .AND. ;
 		   aPrev[x] <= mv_par04
	   		nCOL1 := 60 + (MONTH(aPrev[x])*6) -5
	   		If aScan(aVerf,{|x| x==nCOL1}) == 0
		   		aAdd(aVerf,nCOL1)
		   		@Prow()  , nCOL1 Psay SUBSTR(DtoC(aPrev[x]),1,5) PICTURE "99/99"
		   	EndIf
		EndIf
	Next
	
	// imprime a data de previsao da manutencao da tabela TJ
	For x := 1 to len(aMnt)
		If aMnt[x][1] > mv_par03 .and. aMnt[x][1] <= mv_par04 //previsao TJ_DTMPFIM
			nCOL1 := 60 + (MONTH(aMnt[x][1])*6) -5				
	   		If aScan(aVerf,{|x| x==nCOL1}) == 0
		   		aAdd(aVerf,nCOL1)
				@Prow()  , nCOL1 Psay SUBSTR(DtoC(aMnt[x][1]),1,5) PICTURE "99/99"
			EndIf
		EndIf
	Next

	@Prow()+1 , 001 Psay "Seq.: " + TRA1->TF_SEQRELA
	@Prow()   , 010 Psay "Manut.: " + SUBSTR(TRA1->TF_NOMEMAN,1,30)
	
	//** IMPRIME A DATA REAL DA MANUTENCAO **//

	aVerf := {}
	nCOL1 := 60
	nCOL2 := 65
    @Prow()   , 054 Psay "Real.|"

	//Imprime as 12 segundas linhas dos meses
    For x := 1 To 12
       	@Prow()  ,nCOL2 Psay '|'
        nCOL2 := nCOL2 + 6
	Next

	If TRA1->TF_DTULTMA >= MV_PAR03 .AND. TRA1->TF_DTULTMA <= MV_PAR04
  		nCOL1 := nCOL1 + (MONTH(TRA1->TF_DTULTMA)*6) -5
		If aScan(aVerf,{|x| x==nCOL1}) == 0
	   		aAdd(aVerf,nCOL1)
			@Prow()  , nCOL1 Psay SUBSTR(DtoC(TRA1->TF_DTULTMA),1,5) PICTURE "99/99"   	
		EndIf
   	EndIf

	For x := 1 to len(aMnt)
		If aMnt[x][2] > mv_par03 .and. aMnt[x][2] <= mv_par04 //previsao TJ_DTMPFIM
			nCOL1 := 60 + (MONTH(aMnt[x][2])*6) -5
			If aScan(aVerf,{|x| x==nCOL1}) == 0
		   		aAdd(aVerf,nCOL1)
				@Prow()  , nCOL1 Psay SUBSTR(DtoC(aMnt[x][2]),1,5) PICTURE "99/99"
			EndIf
		EndIf
	Next  
	// Imprime o nº da OS.

	aVerf := {}

    @Prow()+1 , 055 Psay "O.S.|"

	//Imprime as 12 segundas linhas dos meses

	For x := 1 to len(aMnt)
		If aMnt[x][2] > mv_par03 .and. aMnt[x][2] <= mv_par04
			nCOL1 := 59 + (MONTH(aMnt[x][2])*6) -5
			If aScan(aVerf,{|x| x==nCOL1}) == 0
		   		aAdd(aVerf,nCOL1)
				@Prow()  , nCOL1 Psay aMnt[x][3]
			EndIf
		EndIf
	Next

	TRA1->(DbSkip())
EndDo
@ Prow()+1,000 PSAY __PrtThinLine()
If Select("TRA1") > 1	
	TRA1->(DbCloseArea()) 
EndIf
If Select("TRB") > 1	
	TRB->(DbCloseArea()) 
EndIf
Return(nil)

//*****************************************************//
//    FUNCAO QUE CALCULA PREVISAO PARA PRÓXIMA MANUT   //
//*****************************************************//

Static Function fCalcPrev(dData, nDurac ,cPeriodo)
Local dPrev, nDias  
	  
	aPrev := {}
    dPrev := dData
// 	aAdd(aPrev,dPrev) //adiciona a data da ultima manutencao no array
	
	If nDurac == 0
		Return
	EndIf
	
	While year(dPrev) <= year(mv_par03)
	
		If "S"$cPeriodo     //SEMANA
			dPrev += 7*nDurac
		ElseIf "D"$cPeriodo //DIAS
			dPrev += nDurac
		ElseIf "M"$cPeriodo // MES 
			
			For x:=1 to nDurac
				dPrev += Day(Ultimodia(dPrev))
			Next			

/*			If StrZero(Month(dPrev)+nDurac,2) > "12"

				dPrev := CtoD(StrZero(Day(dPrev),2)+"/"+StrZero(Month(dPrev)+nDurac-12,2)+"/"+StrZero(Year(dPrev)+1,4))
			Else	

				dPrev := CtoD(StrZero(Day(dPrev),2)+"/"+StrZero(Month(dPrev)+nDurac,2)+"/"+StrZero(Year(dPrev),4))	
			EndIf
*/
		EndIf
		
		If Year(dPrev) <= Year(mv_par03)
			aAdd(aPrev,dPrev)
		EndIf
	Enddo

Return

//************************************************************//
// FUNCAO QUE SERVE PARA CALCULAR AS MANUTENCOES REALIZADAS   //
//************************************************************//

Static Function fManut(cPBem, cPServ)
Local cQuery1
	
	If Select("TRB") > 1
		DbCloseArea("TRB")
	EndIf
	
	aMnt := {}

	cQuery1 := "SELECT TJ_DTMPFIM, TJ_DTMRFIM,TJ_ORDEM FROM  "+RetSqlName("STJ")
	cQuery1 += " WHERE TJ_CODBEM = '"+cPBem+"'"
	cQuery1 += " AND TJ_SERVICO = '"+cPServ+"'"
	cQuery1 += " AND D_E_L_E_T_ = ' '"
	cQuery1 += " AND TJ_FILIAL = '"+xFilial("STJ")+"'"

	TCQUERY cQuery1 NEW ALIAS "TRB" 
	MemoWrit('C:\TEMP\MNT025-B.SQL',cQuery1)
     
	TcSetField("TRB","TJ_DTMPFIM","D")  // Muda a data de string para date
	TcSetField("TRB","TJ_DTMRFIM","D")  // Muda a data de string para date

	//adiciona no array aMnt as datas prev. e real. 
	While TRB->(!EoF())
		If Empty(TRB->TJ_DTMRFIM)
			aAdd(aMnt, {TRB->TJ_DTMPFIM,CtoD("  /  /  "),TRB->TJ_ORDEM})
		Else
			aAdd(aMnt, {TRB->TJ_DTMPFIM,TRB->TJ_DTMRFIM,TRB->TJ_ORDEM})
		EndIf
		TRB->(DbSkip())
	Enddo

Return