/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHPCP027  ºAutor ³ João Felipe da Rosaº Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PRODUTOS X EMBALAGENS                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHPCP027()
Local aPergs := {}
Private oRelato

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SB1"
    oRelato:cPerg    := "PCP27"
	oRelato:cNomePrg := "NHPCP027"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "M"

	//descricao
	oRelato:cDesc1   := "Este relatorio apresenta a relação de Embalagens por Produtos"

	//titulo
	oRelato:cTitulo  := "RELACAO DE EMBALAGENS POR PRODUTO"

	//cabecalho
	oRelato:cCabec1  := " Produto          Descricao                   Q.Pad    Peso Pç.   Embalagens       Descricao                      Peso Emb.   Quant"
		    
	aAdd(aPergs,{"De Produto ?","C",15,0,"G",""      ,""		 ,"","","","SB1",""}) //mv_par01
	aAdd(aPergs,{"Ate Produto?","C",15,0,"G",""      ,""		 ,"","","","SB1",""}) //mv_par02
	aAdd(aPergs,{"De Grupo ?"  ,"C",06,0,"G",""      ,""	     ,"","","","SBM",""}) //mv_par03
	aAdd(aPergs,{"Ate Grupo ?" ,"C",06,0,"G",""      ,""         ,"","","","SBM",""}) //mv_par04

	oRelato:AjustaSx1(aPergs)
	
	oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local _prod_ant := ""
Local lprim := .T.
Local nTPeso := 0

	Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 

	oRelato:Cabec()

	While TMP->(!EoF())
		
		if _prod_ant <> TMP->B1_COD	
			
			If _prod_ant!=""
				
				@Prow()+1  , 1 psay "PESO TOTAL DO PALLET: " + Transform(nTPeso,"@e 999999.99") //PESO TOTAL DO PALLET
				
				nTPeso := 0 //ZERA O PESO TOTAL DO PALLET
				
				@ Prow()+1,000 PSAY __PrtThinLine()
				If Prow() > 70
					oRelato:Cabec()
				Endif
			EndIf
			_prod_ant := TMP->B1_COD
			
			@Prow()+1, 001 psay TMP->B1_COD
			@Prow()  , 018 psay SUBSTR(TMP->B1_DESC, 1, 25)
			@Prow()  , 046 psay TMP->B5_QPA    Picture "@e 99999"
			@Prow()  , 054 psay TMP->B1_PESBRU Picture "@e 9999.99" //peso da peca

			@Prow()  , 066 psay TMP->B1_EMBAL

			nTPeso += TMP->B5_QPA * TMP->B1_PESBRU
		Else
			@Prow()+1, 066 psay TMP->B1_EMBAL
		EndIf
	
		@Prow()  , 083 psay Substr(TMP->B1_EMBDESC,1,30)
		@Prow()  , 114 psay TMP->B1_PESEMB Picture "@e 9999.99"
		@Prow()  , 124 psay TMP->ZBV_QUANT Picture "@e 999999"
		
		nTPeso += TMP->ZBV_QUANT * TMP->B1_PESEMB

		TMP->(DbSkip())
		
	EndDo

	@Prow()+1  , 1 psay "PESO TOTAL DO PALLET: " + Transform(nTPeso,"@e 999999.99") //PESO TOTAL DO PALLET

	TMP->(dbCloseArea())
		
Return(nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA OS DADOS PARA A IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local cQuery

	cQuery := " SELECT B1.B1_COD, B1.B1_DESC, B12.B1_COD AS B1_EMBAL, B12.B1_DESC AS B1_EMBDESC, ZBV.ZBV_QUANT, B5.B5_QPA"      
	cQuery += " , B1.B1_PESBRU, B12.B1_PESBRU AS B1_PESEMB "
	cQuery += " FROM " + RetSqlName('SB1') +" B1, " + RetSqlName('SB1') +" B12," + RetSqlName('ZBV') +" ZBV, "
	cQuery += RetSqlName("SB5")+" B5 "
	cQuery += " WHERE B1.B1_COD = ZBV.ZBV_PROD"
	cQuery += " AND B1.B1_COD = B5.B5_COD"
	cQuery += " AND B12.B1_COD = ZBV.ZBV_EMBAL"
	cQuery += " AND B1.D_E_L_E_T_  = '' AND B1.B1_FILIAL  = '"+xFilial("SB1")+"'"
	cQuery += " AND B12.D_E_L_E_T_ = '' AND B12.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND ZBV.D_E_L_E_T_ = '' AND ZBV.ZBV_FILIAL = '"+xFilial("ZBV")+"'"
	cQuery += " AND B5.D_E_L_E_T_ = '' AND B5.B5_FILIAL = '"+xFilial("SB5")+"'"
	cQuery += " AND B1.B1_COD BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"'"
	cQuery += " AND B1.B1_GRUPO BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"'"
	cQuery += " ORDER BY B1.B1_COD, ZBV.ZBV_QUANT"
	
	//MemoWrit('C:\TEMP\NHPCP027.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP" //cria variavel para armazenar valor da query 
	
	TMP->(DbGotop()) //Manda o "ponteiro" de leitura da query para o TOPO    
	
Return
