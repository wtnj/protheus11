#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP033  ºAutor  ³FELIPE CICONINI     º Data ³  24/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE RELEASES,ENTREGAS E ATRASOS DO DIA             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PLANEJAMENTO E CONTROLE DA PRODUCAO                         º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Chamado nº 010202
Bom dia! Peço a gentileza que seja criado um relatório, onde consigamos verificar o release do dia, a entrega e o atraso do dia (acumulado), 
de todos os fornecedores em uma folha. obrigada

*/


User Function NHPCP033()
Private aMatHj := {}
Private aMatAm := {}
Private cPrev
Private cPrevAm 

cString		:= "ZA0"
cDesc1		:= ""
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHPCP033"
nLastKey	:= 0
titulo		:= OemToAnsi("RELATÓRIO DE RELEASES, ENTREGAS E ACUMULADOS")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHPCP033"
_cPerg		:= "PCP033"

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)
nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| Gerando()  },"Gerando Dados para Impressao")

Set Filter To
If aReturn[5]==1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

	//-------------------------------------------------------------------------------------------------\\
Static Function Gerando()
Local 	cFornec, cQuery, nDia, dDt, cQuery2, nPrevMes:=0, nEntrMes:=0, nPrevPost:=0, nAtraso, nPrev, nPrevAm, nAcum:=0, nAcumAm:=0, nQtdEntr, nAtr
    
    //0000000000000000000000000000000000
    //00000000|MONTANDO A QUERY|00000000
    //0000000000000000000000000000000000
    
	cQuery2 := "SELECT ZA0.ZA0_PREV"+StrZero(DAY(mv_par01),2)+" PREV, ZA0.ZA0_PREV"+StrZero(++DAY(mv_par01),2)+" PREVAM,ZA0.ZA0_PROD, ZA9.ZA9_FORNEC, ZA9.ZA9_LOJA, ZA9.ZA9_MES, ZA9.ZA9_ANO, SB1.B1_DESC, SB1.B1_COD"
	cQuery2 += " FROM "+RetSqlName('ZA0')+" ZA0, "+RetSqlName('ZA9')+" ZA9, "+RetSqlName('SB1')+" SB1"
	cQuery2 += " WHERE	ZA0.ZA0_NUM 	= ZA9.ZA9_NUM"
	cQuery2 += " AND		ZA9.ZA9_FORNEC	BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
	cQuery2 += " AND		ZA9.ZA9_LOJA	BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'"
	cQuery2 += " AND		ZA9.ZA9_MES		= "+StrZero(MONTH(mv_par01),2)
	cQuery2 += " AND		ZA9.ZA9_ANO		= "+StrZero(YEAR(mv_par01),4)
	cQuery2 += " AND		ZA0.ZA0_PROD	= SB1.B1_COD "
	      
	cQuery2 += " AND		ZA9.D_E_L_E_T_	= ' '"
	cQuery2 += " AND		ZA0.D_E_L_E_T_	= ' '"
	cQuery2 += " AND		ZA9.ZA9_FILIAL	= '"+xFilial("ZA9")+"'"
	cQuery2 += " AND		ZA0.ZA0_FILIAL	= '"+xFilial("ZA0")+"'"
	cQuery2 += " ORDER BY ZA9.ZA9_FORNEC, ZA9.ZA9_LOJA"
	MemoWrit('C:\TEMP\NHPCP033.SQL',cQuery2)
	TCQUERY cQuery2 NEW ALIAS 'TMP1'
	
	//-------------------------------------------------------------------------------------------------\\

	cabec1 := "FORNEC - LOJA  NOME"
	cabec2 := OemToAnsi("     PRODUTO          DESCRIÇÃO                        ATRASO         "+DtoC(mv_par01)+"         "+DtoC(mv_par01+1)+"             SALDO              ENTREGUE               RELEASE              PREVISÃO")
	Titulo := OemToAnsi("RELATÓRIO DE RELEASES, ENTREGAS E ACUMULADOS DO DIA ")+DtoC(mv_par01)

    TMP1->(DbGoTop())

    Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
    
    DbSelectArea('SA2')
    SA2->(DbSetOrder(1))		//filial + cod + loja
    
    ProcRegua(0)
    
    While TMP1->(!EoF())
        
    	IncProc()
    	
    	cFornec := TMP1->ZA9_FORNEC
    	
    	
    	If Prow() > 60
    		Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
    	EndIf    	
    	
    	//SEPARA POR FORNECEDORES
    	If SA2->(DbSeek(xFilial("SA2")+TMP1->ZA9_FORNEC+TMP1->ZA9_LOJA))
	        @Prow()+1,001 PSAY TMP1->ZA9_FORNEC+" - "
	    	@Prow()  ,010 PSAY TMP1->ZA9_LOJA
	    	@Prow()  ,015 PSAY SA2->A2_NOME
	    EndIf
    	
    	While cFornec == TMP1->ZA9_FORNEC
    	
	//-------------------------------------------------------------------------------------------------\\
	    		
    		cQuery := "SELECT ZA0_ATRASO"
    		cQuery += " FROM "+RetSqlName("ZA0")+" ZA0, "+RetSqlName("ZA9")+" ZA9 "
    		cQuery += " WHERE 	ZA0_NUM			= ZA9_NUM"
    		cQuery += " AND		ZA9_FORNEC		= '"+TMP1->ZA9_FORNEC+"'"
    		cQuery += " AND		ZA9_LOJA		= '"+TMP1->ZA9_LOJA+"'"
    		cQuery += " AND		ZA0_PROD		= '"+TMP1->B1_COD+"'"
    		cQuery += " AND		ZA9_MES			= '"+StrZero(MONTH(mv_par01),2)+"'"
    		cQuery += " AND		ZA9_ANO			= '"+StrZero(YEAR(mv_par01),4)+"'"
    		
    		cQuery += " AND		ZA0.D_E_L_E_T_  = ' '"
    		cQuery += " AND		ZA9.D_E_L_E_T_	= ' '"
    		cQuery += " AND		ZA0_FILIAL		= '"+xFilial("ZA0")+"'"
    		cQuery += " AND		ZA9_FILIAL		= '"+xFilial("ZA9")+"'"
    		
    		TCQUERY cQuery NEW ALIAS 'TMP2'
    		
    		TMP2->(DbGoTop())
    		
    		nAtraso := TMP2->ZA0_ATRASO
    		nAtr	:= TMP2->ZA0_ATRASO
    		
    		TMP2->(DbCloseArea())
		    
		    dDt := CtoD("01/"+StrZero(MONTH(mv_par01),2)+"/"+StrZero(YEAR(mv_par01),4))
		    
		    nPrevMes 	:= 0
		    nEntrMes 	:= 0
		    nAcum		:= 0
		    nAcumAm		:= 0
		    _nAc		:= 0

			While dDt <= UltimoDia(mv_par01)
	    	
	    		IncProc()
	    		
	    		nDia := DAY(dDt)  //Contador para ZA0_PREV
	    		
	    		cQuery := "SELECT SUM(ZA0_PREV"+StrZero(nDia,2)+") PREV"
	    		cQuery += " FROM "+RetSqlName("ZA0")+" ZA0, "+RetSqlName("ZA9")+" ZA9 "
	    		cQuery += " WHERE 	ZA0_NUM			= ZA9_NUM"
	    		cQuery += " AND		ZA9_FORNEC		= '"+TMP1->ZA9_FORNEC+"'"
	    		cQuery += " AND		ZA9_LOJA		= '"+TMP1->ZA9_LOJA+"'"
	    		cQuery += " AND		ZA0_PROD		= '"+TMP1->B1_COD+"'"
	    		cQuery += " AND		ZA9_MES			= '"+StrZero(MONTH(mv_par01),2)+"'"
	    		cQuery += " AND		ZA9_ANO			= '"+StrZero(YEAR(mv_par01),4)+"'"
	    		
	    		cQuery += " AND		ZA0.D_E_L_E_T_  = ' '"
	    		cQuery += " AND		ZA9.D_E_L_E_T_	= ' '"
	    		cQuery += " AND		ZA0_FILIAL		= '"+xFilial("ZA0")+"'"
	    		cQuery += " AND		ZA9_FILIAL		= '"+xFilial("ZA9")+"'"
	    		
	    		TCQUERY cQuery NEW ALIAS 'TMP3'
	    		
	    		TMP3->(DbGoTop())
	    		
	    		nQtdEntr := fQtdEntr(TMP1->B1_COD,TMP1->ZA9_FORNEC,TMP1->ZA9_LOJA,dDt)
	    		
	    		nPrevMes += TMP3->PREV
	    		nEntrMes += nQtdEntr
	    		
	    		_nAt := 0
	    		_nAt += TMP3->PREV
	    		_nAt -= nQtdEntr
	    		
	    		_nAc += TMP3->PREV
	    		_nAc -= nQtdEntr
	    		
	    		If dDt <= mv_par01
	    			nAtraso += _nAt
	    		EndIf
	    		
	    		If dDt == mv_par01
	    			nAcum 	:= _nAc
	    		ElseIf dDt ==mv_par01+1
	    			nAcumAm := _nAc
	    		EndIf
	    		
	    		TMP3->(DbCloseArea())
	    		
	    		dDt++
	    		
	    	EndDo
		    
	//-------------------------------------------------------------------------------------------------\\
	    		
	    	cQuery := "SELECT ZA0_MES1, ZA0_ATRASO "
	    	cQuery += " FROM "+RetSqlName("ZA0")+" ZA0, "+RetSqlName("ZA9")+" ZA9 "
	    	cQuery += " WHERE 	ZA0_NUM			= ZA9_NUM"
	    	cQuery += " AND		ZA9_FORNEC		= '"+TMP1->ZA9_FORNEC+"'"
	    	cQuery += " AND		ZA9_LOJA		= '"+TMP1->ZA9_LOJA+"'"
	    	cQuery += " AND		ZA0_PROD		= '"+TMP1->B1_COD+"'"
	    	cQuery += " AND		ZA9_MES			= "+StrZero(MONTH(mv_par01),2)
	    	cQuery += " AND		ZA9_ANO			= "+StrZero(YEAR(mv_par01),4)
	    	
	    	cQuery += " AND		ZA0.D_E_L_E_T_  = ' '"
	    	cQuery += " AND		ZA9.D_E_L_E_T_	= ' '"
	    	cQuery += " AND		ZA0_FILIAL		= '"+xFilial("ZA0")+"'"
	    	cQuery += " AND		ZA9_FILIAL		= '"+xFilial("ZA9")+"'"
	    	TCQUERY cQuery NEW ALIAS 'TMP4'
	    	
	    	TMP4->(DbGoTop())
	
	    	nPrevPost	  	:= TMP4->ZA0_MES1

    		//PREVISTO DOS DIAS
    		nPrev  			:= TMP1->PREV
    		nPrevAm 		:= TMP1->PREVAM
	    	
	    	TMP4->(DbCloseArea())
	    	
		    nSaldo := nPrevMes - nEntrMes
		    nSaldo += nAtr
		    
		    nAtraso *= -1
		    nSaldo	*= -1	
	//-------------------------------------------------------------------------------------------------\\
	    	
	    	If Prow() > 65
	    		Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
	    	EndIf 
	    	
     		//IMPRIME OS DADOS
			
			@Prow()+1,005 PSAY TMP1->B1_COD
			@Prow()  ,022 PSAY AllTrim(SubStr(TMP1->B1_DESC,1,20))
			@Prow()  ,050 PSAY nAtraso				Picture "@E 999,999,999"                 //ATRASO
 			@Prow()  ,070 PSAY nPrev        		Picture "@E 999,999,999"                 //DATA01
			@Prow()  ,088 PSAY nPrevAm      		Picture "@E 999,999,999"                 //DATA02
			@Prow()  ,106 PSAY nSaldo  	    		Picture "@E 999,999,999"                 //SALDO
			@Prow()  ,128 PSAY nEntrMes     		Picture "@E 999,999,999"                 //ENTREGUE
			@Prow()  ,150 PSAY nPrevMes     		Picture "@E 999,999,999"                 //RELEASE
			@Prow()  ,172 PSAY nPrevPost    		Picture "@E 999,999,999"                 //PREVISAO DO MES SEGUINTE
			
	    	TMP1->(DbSkip())
	     	
     	EndDo
     	@Prow()+1,000 PSAY __PrtThinLine()
    EndDo
    TMP1->(DbCloseArea())
Return
	
	
	//0000000000000000000000000000000000
	//00|FUNÇÃO DE ENTRADA DO PRODUTO|00
	//0000000000000000000000000000000000

//____________________________________________________________________________________________________________
	                                                                                              	  		//|
Static Function fQtdEntr(cProd,cForn,cLoja,dDta)                                                  	  		//|
Local cQtd                                                                                       	  		//|
		                                                                                         	  		//|
	If Select('TMV') > 0                                                                          	   		//|
		TMV->(DbCloseArea())                                                                      	   		//|
	EndIF                                                                                         	   		//|
	                                                                                              	   		//|
	IF SM0->M0_CODIGO == "FN" .AND. ;                                                             	   		//|
	   cForn == '999999' .AND. cLoja == '01' //Se for para fundição, pega da ZBB                  	   		//|
                                                                                                  	   		//|
		cQuery := " SELECT ZBA.ZBA_DATA AS DTDIGIT, SUM(ZBB.ZBB_QUANT) AS QUANT "                 			//|
		cQuery += " FROM "+RetSqlName("ZBA")+" ZBA, "+RetSqlName("ZBB")+" ZBB" //TEM QUE SER DA FUNDICAO    //|
		cQuery += " WHERE ZBA.ZBA_NUM 	= ZBB.ZBB_NUM"                                            			//|
		cQuery += " AND ZBA.ZBA_DATA 	= "+DtoS(dDta)                                            			//|
		cQuery += " AND ZBB.ZBB_COD 	= '"+cProd+"'"                                            			//|
		cQuery += " AND ZBA.ZBA_STATUS 	= 'E'"                                                   			//|
		cQuery += " AND ZBB.ZBB_FILIAL 	= '"+xFilial("ZBB")+"' AND ZBB.D_E_L_E_T_ = ''"           			//|
		cQuery += " AND ZBA.ZBA_FILIAL 	= '"+xFilial("ZBA")+"' AND ZBA.D_E_L_E_T_ = ''"           			//|
		cQuery += " GROUP BY ZBA.ZBA_DATA"                                                        			//|
		cQuery += " ORDER BY ZBA.ZBA_DATA"                                                        			//|
	Else                                                                                          			//|
		cQuery := "SELECT D1_DTDIGIT AS DTDIGIT, SUM(D1.D1_QUANT) AS QUANT "                     			//|
		cQuery += " FROM "+RetSqlName("SD1") + " D1, " + RetSqlName( 'SF4' ) +" F4 "              			//|
		cQuery += " WHERE D1.D1_COD 	= '"+cProd+"'"                                            			//|
		cQuery += " AND D1.D1_FORNECE 	= '"+cForn+"' AND D1.D1_LOJA = '"+cLoja+"'"               			//|
		cQuery += " AND D1.D1_DTDIGIT 	= "+DtoS(dDta)                                            			//|
	    cQuery += " AND D1.D1_TES 		= F4.F4_CODIGO"                                           			//|
	    cQuery += " AND F4.F4_ESTOQUE 	= 'S'" //somente pega as notas que atualizam estoque      			//|
		cQuery += " AND D1.D_E_L_E_T_ 	= ' '"                                                    			//|
	    cQuery += " AND F4.D_E_L_E_T_ 	= ' '"                                                    			//|
	    cQuery += " GROUP BY D1_DTDIGIT"                                                          			//|
	    cQuery += " ORDER BY D1_DTDIGIT"                                                          			//|
	EndIf                                                                                         			//|
				                                                                                  			//|
	TCQUERY cQuery NEW ALIAS 'TMV'                                                                			//|
	                                                                                              			//|
	TcSetField("TMV","DTDIGIT","D")  // Muda a data de string para date                           			//|
	                                                                                              			//|
	cQtd := TMV->QUANT                                                                            			//|
                                                                                                  			//|
Return(cQtd)                                                                                      			//|
																								  			//|
//____________________________________________________________________________________________________________|