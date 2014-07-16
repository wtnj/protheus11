#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP024  ºAutor  ³João Felipe da Rosa º Data ³  10/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PROGRAMA DE EXPEDIÇÃO                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP / LOGÍSTICA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHPCP024()
Local aPergs := {}

	oRelato          := Relatorio():New()

	oRelato:cString  := "ZAP"
    oRelato:cPerg    := "PCP024"
	oRelato:cNomePrg := "NHPCP024"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Apresenta os produtos a serem expedidos no mês. "
	oRelato:cDesc2   := ""
	oRelato:cDesc3   := ""
	
	//tamanho
	oRelato:cTamanho := "G"  //default "M"

	//titulo
	oRelato:cTitulo  := "PROGRAMA DE EXPEDIÇÃO"

	//cabecalho
	oRelato:cCabec1  := " Peça                     "//Descrição"+Space(13)
    oRelato:cCabec2  := ""

	aAdd(aPergs,{"Mes/Ano ?"   ,"C", 7,0,"G",""      ,""		 ,"","","",""   ,"99/9999"}) //mv_par01
	aAdd(aPergs,{"De Produto ?","C",15,0,"G",""      ,""		 ,"","","","SB1",""}) //mv_par02
	aAdd(aPergs,{"Ate Produto?","C",15,0,"G",""      ,""		 ,"","","","SB1",""}) //mv_par03
	aAdd(aPergs,{"De Grupo ?"  ,"C",06,0,"G",""      ,""	     ,"","","","SBM",""}) //mv_par04
	aAdd(aPergs,{"Ate Grupo ?" ,"C",06,0,"G",""      ,""         ,"","","","SBM",""}) //mv_par05
	aAdd(aPergs,{"Produto ?"   ,"N",01,0,"C","Codigo","Descricao","","","","",""}) //mv_par06
	aAdd(aPergs,{"Periodo ?"   ,"N",01,0,"C","Diário","Mensal"   ,"","","","",""}) //mv_par07

	oRelato:AjustaSx1(aPergs)		    

	oRelato:Run({||Imprime()})
	
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local aTMes1 := {0,0,0}
Local aTMes2 := {0,0,0}
Local aTMes3 := {0,0,0}

	If mv_par07==1 //diario
		For x:=1 to 31
			oRelato:cCabec1 += StrZero(x,2)+Space(4)
		Next
		oRelato:cCabec1 += "   Total"
	ElseIf mv_par07==2 //mensal
	    cMes1 := Substr(mv_par01,1,2)
	    cMes2 := StrZero(Val(cMes1)+1,2)
	    cMes3 := StrZero(Val(cMes1)+2,2)
	    cMes4 := StrZero(Val(cMes1)+3,2)
	    
		
		oRelato:cCabec1 += Space(5)
		oRelato:cCabec1 += Substr(MesExtenso(cMes1),1,3)+Space(7)
		oRelato:cCabec1 += Substr(MesExtenso(cMes2),1,3)+Space(7)
		oRelato:cCabec1 += Substr(MesExtenso(cMes3),1,3)+Space(7)
		oRelato:cCabec1 += Substr(MesExtenso(cMes4),1,3)
	EndIf

	Processa({|| Gerando()},"Gerando Dados p/ Impressão...")
	
	oRelato:cTitulo += " DO MÊS DE "+UPPER(MesExtenso(Substr(mv_par01,1,2)))
	oRelato:Cabec()
	
	aTotPeca := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	aTotPeso := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	aTotVlr  := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

	While TRA1->(!EOF())
	
		If Prow() > 65
			oRelato:Cabec()
		EndIf
		
		If mv_par06==1 //codigo do produto
			@Prow()+1, 001 psay TRA1->ZAP_PROD //+Space(1)+SUBSTR(TRA1->B1_DESC,1,20)
		ElseIf mv_par06==2 //descricao
			@Prow()+1, 001 psay SUBSTR(TRA1->B1_DESC,1,21)
		EndIf
		
		nTotal := 0 
		For x:=1 to 31
			cCampo := "TRA1->ZAP_PREV"+strzero(x,2)
			
			If mv_par07==1 //diario
				@Prow()  , 016+(x*6) psay &(cCampo) picture "@e 999999"
			EndIf

			aTotPeca[x] += &(cCampo)
   	        aTotPeso[x] += &(cCampo) * TRA1->B1_PESBRU
       	    aTotVlr[x]  += &(cCampo) * TRA1->ZAP_PRECUN
			nTotal += &(cCampo)

		Next
		
		If mv_par07==1 //diario
			@Prow() , 212 psay nTotal picture "@e 99999999"
		ElseIf mv_par07==2 //mensal
			@Prow() , 026 psay nTotal picture "@e 99999999"
			@Prow() , 036 psay TRA1->ZAP_PREVM1 picture "@e 99999999"
			@Prow() , 046 psay TRA1->ZAP_PREVM2 picture "@e 99999999"
			@Prow() , 056 psay TRA1->ZAP_PREVM3 picture "@e 99999999"
			
			aTMes1[1] += TRA1->ZAP_PREVM1
			aTMes1[2] += TRA1->ZAP_PREVM1 * TRA1->B1_PESBRU
			aTMes1[3] += TRA1->ZAP_PREVM1 * TRA1->ZAP_PRECUN
			
			aTMes2[1] += TRA1->ZAP_PREVM2
			aTMes2[2] += TRA1->ZAP_PREVM2 * TRA1->B1_PESBRU
			aTMes2[3] += TRA1->ZAP_PREVM2 * TRA1->ZAP_PRECUN

			aTMes3[1] += TRA1->ZAP_PREVM3
			aTMes3[2] += TRA1->ZAP_PREVM3 * TRA1->B1_PESBRU
			aTMes3[3] += TRA1->ZAP_PREVM3 * TRA1->ZAP_PRECUN
			
		EndIf

		TRA1->(dbSkip())
	     
	ENDDO

	@Prow() +1,000 psay __PrtThinLine()
 
 	/*****************
 	* TOTAL DE PECAS *
 	*****************/

	@Prow()+1, 001 psay "TOTAL PEÇAS:"
	nPecaGer := 0
	For x:=1 to 31
		If mv_par07==1 //diario
			@Prow()  , 016+(x*6) psay aTotPeca[x] picture "@e 999999"
		EndIf
		nPecaGer += aTotPeca[x]
	Next

	If mv_par07==1 //diario		
		@Prow() , 212 psay  nPecaGer picture "@e 99999999"
	ElseIf mv_par07==2 //mensal
		@Prow() , 026 psay  nPecaGer picture "@e 99999999"
		@Prow() , 036 psay  aTMes1[1] picture "@e 99999999"
		@Prow() , 046 psay  aTMes1[2] picture "@e 99999999"
		@Prow() , 056 psay  aTMes1[3] picture "@e 99999999"				
	EndIf
		        
	/*************
	* TOTAL PESO *
	*************/
	@Prow()+1, 001 psay "TOTAL PESO (em T):"
	nPesoGer := 0
	For x:=1 to 31
		If mv_par07==1//diario
			@Prow()  , 016+(x*6) psay aTotPeso[x]/1000 picture "@e 999999"
		EndIf
		nPesoGer += aTotPeso[x]
	Next
	If mv_par07==1 //diario
		@Prow() , 212 psay  nPesoGer picture "@e 99999999"
	ElseIf mv_par07==2 //mensal
		@Prow() , 026 psay  nPesoGer picture "@e 99999999"
		@Prow() , 036 psay  aTMes2[1] picture "@e 99999999"
		@Prow() , 046 psay  aTMes2[2] picture "@e 99999999"
		@Prow() , 056 psay  aTMes2[3] picture "@e 99999999"				
	EndIf
	
	/**************
	* TOTAL EM R$ *
	**************/
	@Prow()+1, 001 psay "TOTAL R$ (em Mil):"
	nVlrGer := 0
	For x:=1 to 31
		If mv_par07==1 //diario
			@Prow()  , 016+(x*6) psay aTotVlr[x]/1000 picture "@e 999999"
		EndIf
		nVlrGer += aTotVlr[x]
	Next
	If mv_par07==1 //diario
		@Prow() , 212 psay  nVlrGer picture "@e 99999999"
	ElseIf mv_par07==2 //mensal
		@Prow() , 026 psay  nVlrGer picture "@e 99999999"
		@Prow() , 036 psay  aTMes3[1] picture "@e 99999999"
		@Prow() , 046 psay  aTMes3[2] picture "@e 99999999"
		@Prow() , 056 psay  aTMes3[3] picture "@e 99999999"				
	EndIf

	TRA1->(DbCloseArea())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA OS DADOS PARA IMPRESSÃO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()

	cQuery := "SELECT ZAP.*,ZAO.*, B1.B1_DESC, B1.B1_PESBRU "
	cQuery += " FROM "+RetSqlName("ZAP")+" ZAP, "+RetSqlName("ZAO")+" ZAO, "+RetSqlName("SB1")+" B1 "
	cQuery += " WHERE ZAP.ZAP_NUM = ZAO.ZAO_NUM "
	cQuery += " AND ZAP.ZAP_PROD = B1.B1_COD"
	cQuery += " AND ZAO.ZAO_MES = '"+AllTrim(Str(Val(Substr(mv_par01,1,2))))+"'"
	cQuery += " AND YEAR(ZAO.ZAO_DTFIM) = '"+Substr(mv_par01,4,4)+"'"
	cQuery += " AND ZAP.ZAP_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND B1.B1_GRUPO BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	cQuery += " AND ZAP.D_E_L_E_T_ = '' AND ZAP.ZAP_FILIAL = '"+xFilial("ZAP")+"'"
	cQuery += " AND ZAO.D_E_L_E_T_ = '' AND ZAO.ZAO_FILIAL = '"+xFilial("ZAO")+"'"     
	cQuery += " ORDER BY ZAP.ZAP_PROD "

	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DBGOTOP())

Return