/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST222  ºAutor  ³DOUGLAS DOURADO     º Data ³  19/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE SALDO POR ENDEREÇO (AGRUPADO)                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

   _______________________________________ 
  |                                       |
  | ~>Variaveis de Perguntas<~            |
  |                                       |
  | * mv_par01 - De Produto?              |
  | * mv_par02 - Até Produto?             |
  | * mv_par03 - De Endereço?             |
  | * mv_par04 - Até Endereço?            | 
  |_______________________________________|

*/
#INCLUDE "TOPCONN.CH"

User Function NHEST222()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SB1"
    oRelato:cPerg    := "EST183"
	oRelato:cNomePrg := "NHEST183"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este relatório imprime o Saldo de produto"
	oRelato:cDesc2   := "por Endereço"
	oRelato:cDesc3   := ""
	
	//tamanho        
	oRelato:cTamanho := "G"  //default "M"

	//titulo
	oRelato:cTitulo  := "SALDO POR ENDEREÇO"

	aAdd(aPergs,{"Do  Produto ?"      ,"C",15,0,"G",   "",   "","","","","SB1",""})
	aAdd(aPergs,{"Ate Produto ?"      ,"C",15,0,"G",   "",   "","","","","SB1",""})
	aAdd(aPergs,{"Do  Endereço ?"     ,"C",15,0,"G",   "",   "","","","",   "",""})
	aAdd(aPergs,{"Ate Endereço ?"     ,"C",15,0,"G",   "",   "","","","",   "",""})
	aAdd(aPergs,{"Mostra Zerados ?"   ,"N",01,0,"C","Sim","Não","","","",   "",""})
	aAdd(aPergs,{"De Local ?"         ,"C",02,0,"G",   "",   "","","","",   "",""})
	aAdd(aPergs,{"Ate Local ?"        ,"C",02,0,"G",   "",   "","","","",   "",""})

	oRelato:AjustaSx1(aPergs)
	
	//cabecalho      
	oRelato:cCabec1  := ""
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

Return

Static Function Imprime()

Processa( {|| Gerando()  },"Gerando Dados para a Impressao")
Processa( {|| RptDetail()  },"Imprimindo...")

Return

Static Function Gerando()
Local cQuery

	cQuery := "SELECT B1.B1_COD, B1.B1_DESC, BF.BF_LOCAL,BF.BF_LOCALIZ, B1.B1_UPRC, SUM(BF.BF_QUANT) QUANT"
	cQuery += " FROM "+RetSqlName("SB1")+" B1 (NOLOCK), "+RetSqlName("SBF")+" BF (NOLOCK), "+RETSQLNAME("SBE")+" BE (NOLOCK) "
	cQuery += " WHERE B1.B1_COD = BF.BF_PRODUTO "
	cQuery += " AND BE.BE_LOCAL = BF.BF_LOCAL "
	cQuery += " AND BE.BE_LOCALIZ = BF.BF_LOCALIZ "
	cQuery += " AND B1.B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND BF.BF_LOCALIZ BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND BF.BF_LOCAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	If mv_par05 == 2
		cQuery += " AND BF.BF_QUANT <> 0 "
	EndIf
	
	cQuery += " AND B1.D_E_L_E_T_ ='' "
	cQuery += " AND BF.D_E_L_E_T_ ='' "
	cQuery += " AND BE.D_E_L_E_T_ ='' "
	cQuery += " AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND BF.BF_FILIAL = '"+xFilial("SBF")+"'"
	cQuery += " AND BE.BE_FILIAL = '"+xFilial("SBE")+"'"	
	cQuery += " GROUP BY B1.B1_COD, B1.B1_DESC,BF.BF_LOCAL,BF.BF_LOCALIZ, B1.B1_UPRC"
	cQuery += " ORDER BY B1.B1_COD "
	
	TCQUERY cQuery NEW ALIAS "TMP1" 
	MemoWrit('C:\TEMP\NHEST222.SQL',cQuery)

	TMP1->(DbGoTop())

Return

Static Function RptDetail()

Local CodProd := ''
Local Desc := ''
Local Armaz := ''
Local endereco := ''
Local quant := 0
Local uprc := 0

oRelato:cCabec1 := "   CODIGO            DESCRIÇÃO                                      LOCAL       ENDEREÇO                                                                                                              SALDO     PRECO CUSTO"
//                  12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                           10        20        30        40        50        60        70        80        90        100       110       120       130       140
oRelato:cCabec2 := ""

oRelato:Cabec()      

CodProd := TMP1->B1_COD

While TMP1->(!EoF())

	If Prow() > 75
   		oRelato:Cabec()
   	EndIf   
   	
   	If TMP1->B1_COD <> CodProd	
		@Prow()+1,003 PSAY CodProd
		@Prow()  ,021 PSAY Desc
		@Prow()  ,070 PSAY Armaz
		@Prow()  ,080 PSAY endereco
		@Prow()  ,190 PSAY quant  Picture "@E 999,999,999.99"
		@Prow()  ,206 PSAY uprc   Picture "@E 999,999,999.99"	
		endereco := ''
		quant := 0
		uprc := 0	  
    EndIf
    
	endereco += AllTrim(TMP1->BF_LOCALIZ)+' / '		
	
	CodProd   := TMP1->B1_COD
	Desc      := TMP1->B1_DESC
	Armaz     := TMP1->BF_LOCAL
	quant     += TMP1->QUANT 
	uprc      += TMP1->B1_UPRC    

	TMP1->(DbSkip())
EndDo
	TMP1->(DbCloseArea())
Return