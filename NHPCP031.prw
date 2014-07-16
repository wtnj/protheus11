#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP031  ºAutor  ³FELIPE CICONINI     º Data ³  13/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE PRODUCAO, PROGRAMA E ESTOQUE                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PLANEJAMENTO E CONTROLE DA PRODUCAO                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

*/


User Function NHPCP031()
//Variaveis de Arrays para armazenar as informações para os relatorios
Private aTot	:= {} //array geral
Private aMat	:= {} 
Private cProd
Private nQuant	:= 0
Private aProg	:= {}
Private aProd	:= {}
Private aEst	:= {}
Private aEnt	:= {}
Private aAux := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

cString		:= "SHC"
cDesc1		:= "Este relatorio tem como objetivo imprimir"
cDesc2		:= ""
cDesc3		:= ""
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHPCP031"
nLastKey	:= 0
titulo		:= " "
cabec1		:= "  DIAS             01    02    03    04    05    06    07    08    09    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31"
cabec2		:= " "
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHPCP031"
_cPerg		:= "PCP031"



Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

titulo := OemToAnsi("RELATÓRIO DE PRODUÇÃO - PERÍODO "+Upper(MesExtenso(SubStr(mv_par01,1,2)))+" DE "+SubStr(mv_par01,4,7)+" ")

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| Programa()  },"Gerando Dados para Impressao")
RptStatus({|| RptDetail()  },"Imprimindo...")

Set Filter To
If aReturn[5]==1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

Static Function Programa(cProd)
	Local cQuery
	Local cQuery2
	
	//|||||||||||||||||||||||||||||||||||||||||||\\
	//|||||||MONTANDO A QUERY DE PROGRAMA||||||||\\
	//|||||||||||||||||||||||||||||||||||||||||||\\
	
	cQuery := "SELECT SHC.HC_PRODUTO, SHC.HC_QUANT, SHC.HC_DATA, SHC.HC_DOC "
	cQuery += " FROM "+RetSqlName('SHC')+" SHC" 
	cQuery += " WHERE MONTH(SHC.HC_DATA) = '"+SubStr(mv_par01,1,2)+"'"
	cQuery += " AND YEAR(SHC.HC_DATA) = '"+SubStr(mv_par01,4,7)+"'"
	
	cQuery += " AND SHC.D_E_L_E_T_ = ' ' "
	cQuery += " AND SHC.HC_FILIAL = '"+xFilial('SHC')+"'"
	
	cQuery += " ORDER BY SHC.HC_PRODUTO "
	MemoWrit('C:\TEMP\NHPCP031prog.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS 'TRA1' //Inicia TRA
	TRA1->(DbGoTop())
	TcSetField("TRA1","HC_DATA","D")
	
	ProcRegua(0)   

   	While TRA1->(!EoF())
   		IncProc()
   		cProd := TRA1->HC_PRODUTO
   		aProg := aClone(aAux)
   		
   		While TRA1->(!EoF()) .and. cProd==TRA1->HC_PRODUTO
   		
	 		aProg[Day(TRA1->HC_DATA)] += TRA1->HC_QUANT
	 		
	 		TRA1->(dbSkip())
	 		
		EndDo
		
		//ADICIONANDO NA MATRIZ PRINCIPAL
		aProd 	:= fProd(cProd)                         
		aEst  	:= fEst(cProd)[1]
		aEnt	:= fEst(cProd)[2]
		aAdd(aMat,{cProd,aProg,aProd,aEst,aEnt})		
			
	EndDo

TRA1->(DbCloseArea()) //Fecha TRA1

Return

Static Function fProd(cProd)
Local cQuery
Local cQuery2
    
   	//|||||||||||||||||||||||||||||||||||||||||||\\
	//|||||||MONTANDO A QUERY DE PRODUCAO||||||||\\
	//|||||||||||||||||||||||||||||||||||||||||||\\
	
	
	cQuery := "SELECT ZAU.ZAU_DATA, ZAG.ZAG_PROD, SUM(ZAG_EMBAL1+ZAG_EMBAL2+ZAG_EMBAL3) SOMA "
	cQuery += " FROM "+RetSqlName('ZAG')+" ZAG, "+RetSqlName('ZAU')+" ZAU"
	cQuery += " WHERE ZAG_PROD = '"+cProd+"'"
	cQuery += " AND MONTH(ZAU.ZAU_DATA) = '"+SubStr(mv_par01,1,2)+"'"
	cQuery += " AND YEAR(ZAU.ZAU_DATA) = '"+SubStr(mv_par01,4,7)+"'"
	cQuery += " AND ZAG.ZAG_NUM = ZAU.ZAU_NUM"
	
	cQuery += " AND ZAG.D_E_L_E_T_ = ' '"
	cQuery += "	AND ZAU.D_E_L_E_T_ = ' '"
	cQuery += " AND ZAG.ZAG_FILIAL = '"+xFilial('ZAG')+"'"
	cQuery += " AND ZAU.ZAU_FILIAL = '"+xFilial('ZAU')+"'"
	
	cQuery += " GROUP BY ZAU.ZAU_DATA, ZAG.ZAG_PROD"
	MemoWrit('C:\TEMP\NHPCP031prod.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS 'TEMP' //Inicia TEMP
	TEMP->(DbGoTop())
	TcSetField("TEMP","ZAU_DATA","D")
	
	aProd := aClone(aAux)
		 
	While TEMP->(!Eof()) .and. cProd==TEMP->ZAG_PROD
			
		aProd[Day(TEMP->ZAU_DATA)] += TEMP->SOMA
		
		TEMP->(DbSkip())
		
	EndDo

TEMP->(DbCloseArea()) //Fecha TEMP
		
Return(aProd)

Static Function fEst(cProd)
Local cQuery
Local dDtIni
Local nSaidas := 0 


	//||||||||||||||||||||||||||||||||||||||||||||||||||||||\\
	//|||||||MONTANDO A QUERY DE ESTOQUE E ENTREGAS|||||||||\\
	//||||||||||||||||||||||||||||||||||||||||||||||||||||||\\


	//pega a quantidade inicial do produto
	cQuery := "SELECT SUM(B9_QINI) qini"
	cQuery += " FROM "+RetSqlName('SB9')+" SB9"
	cQuery += " WHERE SB9.B9_LOCAL BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	cQuery += " AND MONTH(SB9.B9_DATA) = '"+StrZero(--val(SubStr(mv_par01,1,2)),2)+"'"
	cQuery += " AND YEAR(SB9.B9_DATA) = '"+SubStr(mv_par01,4,7)+"'"
	cQuery += " AND SB9.B9_COD = '"+cProd+"'"
	
	cQuery += " AND SB9.D_E_L_E_T_ = ' '"
	cQuery += " AND SB9.B9_FILIAL = '"+xFilial('SB9')+"'"

	MemoWrit('C:\TEMP\NHPCP031est.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS 'TRA2' //Inicia TRA2
	TRA2->(dbGoTop())
	
	nQuant := TRA2->qini
	
	TRA2->(DbCloseArea()) //Fecha TRA2

	dDtIni 	:= CtoD("01/"+mv_par01)

	aEst 	:= aClone(aAux)
	aEnt 	:= aClone(aAux)

	For nCo := Day(dDtIni) to Day(Ultimodia(dDtIni))
	
		//pega as entradas do produto 	
		cQuery := "SELECT SD3.D3_COD, SD3.D3_EMISSAO, SUM(D3_QUANT) quant "
		cQuery += " FROM "+RetSqlname('SD3')+" SD3 "
		cQuery += " WHERE SD3.D3_COD = '"+cProd+"'"
		cQuery += " AND SD3.D3_LOCAL BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
		cQuery += " AND SD3.D3_EMISSAO = '"+SubStr(mv_par01,4,7)+SubStr(mv_par01,1,2)+StrZero(nCo,2)+"'"
		cQuery += " AND SD3.D3_TM < '500' "

		cQuery += " AND SD3.D3_ESTORNO <> 'S'"
		
		cQuery += " AND SD3.D_E_L_E_T_ = ' '"
		cQuery += " AND SD3.D3_FILIAL = '"+xFilial('SD3')+"'"
		
		cQuery += " GROUP BY SD3.D3_COD,SD3.D3_EMISSAO"
	    
	    MemoWrit('C:\TEMP\NHPCP031xxx.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA3' //Inicia TRA3

		TRA3->(DbGoTop())
	    While TRA3->(!Eof())
			nQuant += TRA3->quant
			TRA3->(DbSkip())
		EndDo
	
		If Select("TMR") > 0
			TMR->(DbCloseArea("TMR"))
		EndIf
		//Verifica as Saidas
		cQuery := " SELECT D2.D2_SERIE, D2.D2_CLIENTE, D2.D2_LOJA, D2.D2_DOC, SUM(D2_QUANT) QUANT "
		cQuery += " FROM "+RetSqlName("SD2")+" D2"
		cQuery += " WHERE D2.D2_COD = '"+cProd+"'"
		cQuery += " AND D2.D2_LOCAL BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
		cQuery += " AND D2.D2_EMISSAO = '"+SubStr(mv_par01,4,7)+SubStr(mv_par01,1,2)+StrZero(nCo,2)+"'"
		
		cQuery += " AND D2.D2_FILIAL = '"+xFilial("SD2")+"'"
		cQuery += " AND D2.D_E_L_E_T_ = ' '"
		 
		cQuery += "	GROUP BY D2.D2_DOC, D2.D2_EMISSAO, D2.D2_CLIENTE, D2.D2_LOJA, D2.D2_SERIE"
	
		
		TCQUERY cQuery NEW ALIAS "TMR" //Inicia TMR
		  
		TMR->(DbGoTop())
		nSaidas := 0        
		While TMR->(!Eof())
			nQuant 	-= TMR->QUANT
			nSaidas += TMR->QUANT
		 	If SM0->M0_CODIGO == "FN"  //empresa FUNDICAO		
				If !(TMR->D2_CLIENTE$"900004" .AND. TMR->D2_LOJA$"02") .AND. ;
				   !(TMR->D2_CLIENTE$"900003" .AND. TMR->D2_LOJA$"02") .AND. ;
				   !(TMR->D2_CLIENTE$"900025" .AND. TMR->D2_LOJA$"02") .AND. ;
				   !(TMR->D2_CLIENTE$"900022" .AND. TMR->D2_LOJA$"01") .AND. ;
				   !(TMR->D2_CLIENTE$"000012" .AND. (TMR->D2_LOJA$"02" .OR. TMR->D2_LOJA$"03"))
		
					If Select("TMT") > 0
						TMT->(DbCloseArea("TMT"))
					EndIf
						
					//VERIFICA O QUE HOUVE DE DEVOLUÇÃO DO PRODUTO
					cQuery2 := " SELECT SUM(D1_QUANT) AS QUANT FROM "+RetSqlName("SD1")+" D1 "
					cQuery2 += " WHERE D1.D1_TIPO = 'D' "//DEVOLUCAO
					cQuery2 += " AND D1.D1_FORMUL = 'S' "// ENTRADA COM A PRÓPRIA NOTA
					cQuery2 += " AND D1.D1_FORNECE = '"+TMR->D2_CLIENTE+"'"
	 				cQuery2 += " AND D1.D1_LOJA = '"+TMR->D2_LOJA+"'"
					cQuery2 += " AND D1.D1_COD = '"+cProd+"'"
					cQuery2 += " AND D1.D1_NFORI = '"+TMR->D2_DOC+"'"
					cQuery2 += " AND D1.D1_SERIORI = '"+TMR->D2_SERIE+"'"
					
					cQuery2 += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
					cQuery2 += " AND D1.D_E_L_E_T_ = ' '"
					
					TCQUERY cQuery2 NEW ALIAS "TMT" //Inicia TMT
				        
					If !Empty(TMT->QUANT)
						nQuant 	+= TMT->QUANT
						nSaidas -= TMT->QUANT
					EndIf
					TMT->(DbCloseArea()) //Fecha TMT
				EndIf	
			EndIf
			TMR->(DbSkip())
		EndDo
	                     
	
		TMR->(DbSkip())
   		aEnt[nCo] := nSaidas
   		aEst[nCo] := nQuant
   		
		TMR->(DbCloseArea()) //Fecha TMR
   		TRA3->(DbCloseArea()) //Fecha TRA3		
	Next

	
Return{aEst,aEnt}



			//|||||||||||||||||||||||||||||||\\
			//||||||||||IMPRIMINDO|||||||||||\\
			//|||||||||||||||||||||||||||||||\\

Static Function RptDetail()
Local _nCont
Local _cDesc
SetRegua(len(aMat))
	
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	
	For xM:=1 to len(aMat)
		IncRegua()
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aMat[xM][1]))
		_cDesc := SB1->B1_DESC
		
		If @Prow() > 55
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		EndIf
		
//________________________________________________________________________
		_nCont := 15													//|
		@Prow()+2,001 psay aMat[xM][1]+" - "+_cDesc                     //|
		@Prow()+1,000 psay __PrtThinLine()                              //| 
		@Prow()+1,001 psay "PROGRAMA"                                   //|
		                                                                //|
		For xPg:=1 to len(aMat[xM][2])									//|
			@Prow()  ,_nCont psay aMat[xM][2][xPg]Picture "@E 999999"   //|
			_nCont += 6                                                 //|
	    Next                                                            //|
		                                                                //|
		_nCont := 15                                                    //|
		@Prow()+1,000 psay __PrtThinLine()                              //|
		@Prow()+1,001 psay "PRODUÇÃO"                                   //|
		                                                                //|
		For xPr:=1 to len(aMat[xM][3])                                  //|
			@Prow()  ,_nCont psay aMat[xM][3][xPr] Picture "@E 999999"  //|
			_nCont += 6                                                 //|
		Next                                                            //|
		                                                                //|
		_nCont := 15                                                    //|
		@Prow()+1,000 psay __PrtThinLine()                              //|
		@Prow()+1,001 psay "ESTOQUE"                                    //|
																		//|
		For xEs:=1 to len(aMat[xM][4])                                  //|
			@Prow()  ,_nCont psay aMat[xM][4][xEs] Picture "@E 999999"  //|
			_nCont += 6                                                 //|
		Next                                                            //|
		                                                                //|
		_nCont := 15                                                    //|
		@Prow()+1,000 psay __PrtThinLine()                              //|
		@Prow()+1,001 psay "ENTREGAS"                                   //|
		                                                                //|
		For xEn:=1 to len(aMat[xM][5])                                  //|
			@Prow()  ,_nCont psay aMat[xM][5][xEn] Picture "@E 999999"  //|
			_nCont += 6                                                 //|
		Next                                                            //|
//________________________________________________________________________|
		
		@Prow()+1,000 psay __PrtThinLine()
	Next

Return   


//THE END