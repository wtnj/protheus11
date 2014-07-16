#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST179  ºAutor  ³FELIPE CICONINI     º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE PESOS DO PRODUTO (CHAMADO 13610)               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE/CUSTOS - FATURAMENTO                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

  _______________________________________ 
 |                                       |
 | ~>Variaveis de Perguntas<~            |
 |                                       |
 | * mv_par01 - De Produto?              |
 | * mv_par02 - Até Produto?             |
 | * mv_par03 - De Grupo?                |
 | * mv_par04 - Até Grupo?               | 
 | * mv_par05 - Macho? (S/N)             |
 | * mv_par06 - Mostra Bloqueados? (S/N) |
 | * mv_par07 - Apenas Atualizados?(S/N) |
 |_______________________________________|
 

*/

User Function NHEST179()

cString		:= "SB1"
cDesc1		:= "Este relatorio tem como objetivo Imprimir"
cDesc2      := "o resumo de pesagens das peças"
cDesc3      := ""      
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHEST179"
nLastKey	:= 0
titulo		:= OemToAnsi("TABELA DE PESO ENGENHARIA")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHEST179"
_cPerg		:= "EST179"

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif          

SetDefault(aReturn,cString)

nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver	:= ReadDriver()
cCompac	:= aDriver[1]

Processa( {|| Gerando()  },"Gerando Dados para a Impressao")
Processa( {|| RptDetail()  },"Imprimindo...")    

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return


//*********************************
//*********GERANDO A QUERY*********
//*********************************

Static Function Gerando()
Local cQuery
Local cQuery2

	cQuery := "SELECT B1.B1_COD,B1.B1_DESC,B1.B1_PPLACA,B1.B1_FILTRO,B1.B1_PESO,B1.B1_PECANAL,B1.B1_PECJTRO,B1.B1_RMETAL,B1.B1_ULTATU,A7.A7_CODCLI"
	cQuery += " ,("
	cQuery += "		SELECT TOP 1 G1.G1_COMP "
	cQuery += " 	FROM "+RetSqlName("SB1")+" B11, "+RetSqlName("SG1")+" G1 "
	cQuery += " 	WHERE B11.B1_COD = G1.G1_COD "
	cQuery += " 	AND SUBSTRING(G1.G1_COMP,6,2) = '.2' "
	cQuery += " 	AND B11.D_E_L_E_T_ ='' "
	cQuery += " 	AND G1.D_E_L_E_T_ ='' "
	cQuery += " 	AND B11.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " 	AND G1.G1_FILIAL = '"+xFilial("SG1")+"'"
	cQuery += "		AND B11.B1_COD = B1.B1_COD"
	cQuery += "	 ) COMP"
	cQuery += " FROM "+RetSqlName("SB1")+" B1 , "+RetSqlName("SA7")+" A7, "+RetSqlName("SA1")+" A1 "
	cQuery += " WHERE 	B1.B1_COD		BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND 	B1.B1_GRUPO		BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND		B1.B1_COD		= A7.A7_PRODUTO"
	cQuery += " AND		A7.A7_CLIENTE	= A1.A1_COD"
	cQuery += " AND		A7.A7_CODCLI	<> ''"
	
//	If mv_par07 == 1								//APENAS ATUALIZADOS
		cQuery += " AND B1_ULTATU		<> ''"
//	EndIf
	
//	If mv_par06 == 2								//TIRA BLOQUEADOS
//		cQuery += " AND B1.B1_MSBLQL	= '2'"
//	EndIf

	cQuery += " AND		B1.D_E_L_E_T_	= '' "
	cQuery += " AND		A7.D_E_L_E_T_	= '' "
	cQuery += " AND		A1.D_E_L_E_T_	= '' "
	cQuery += " AND		B1.B1_FILIAL	= '"+xFilial("SB1")+"'"
	cQuery += " AND		A7.A7_FILIAL	= '"+xFilial("SA7")+"'"
	cQuery += " AND		A1.A1_FILIAL	= '"+xFilial("SA1")+"'"
	cQuery += " GROUP BY B1.B1_COD,B1.B1_DESC,B1.B1_PPLACA,B1.B1_FILTRO,B1.B1_PESO,B1.B1_PECANAL,B1.B1_PECJTRO,B1.B1_RMETAL,B1.B1_ULTATU,A7.A7_CODCLI"
	
//	MemoWrit("C:\TEMP\NHEST179.SQL",cQuery)
	TCQUERY cQuery NEW ALIAS "TMP1"

Return

Static Function RptDetail()
Local cMach := ""
Local nPMach := 0
Local cCod	:= ""

//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160
Cabec1 := "            CODIGO                                  PEÇAS  PESO   PESO     PESO                  PESO           ULTIMA"
Cabec2 := "   CODIGO   CLIENTE          DESCRIÇÃO              PLACA  LIQ    CANAIS   CJTO   RENDIM  MACHO  MACHO  FILTRO  ATUALIZAÇAO"
                       
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

While TMP1->(!EoF())

	If Prow() > 70
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	EndIf
	
	SB1->(DbSelectArea(1))		//filial+cod
	If !Empty(TMP1->COMP)							//PEGA CODIGO DO MACHO
		If SB1->(DbSeek(xFilial("SB1")+TMP1->COMP))
/*			If mv_par05 == 2	//apenas produtos sem macho
				TMP1->(DbSkip())
				Loop
			EndIf*/
			cMach := "SIM"
			cPMach := SB1->B1_PESO
		EndIf
	Else
/*		If mv_par05 == 1		//apenas produtos com macho
			TMP1->(DbSkip())
			Loop
		EndIf*/
		cMach := "NÃO"
		cPMach := 0
	EndIf
	
	If SubStr(TMP1->B1_COD,6,2) == ".P"						//VERIFICANDO SE EXISTE UM PRODUTO TERMINADO PARA SUBSTITUIR O PROTOTIPO
		
		cCod := SubStr(TMP1->B1_COD,1,5)+".1."+SubStr(TMP1->B1_COD,9,8)
		
		If SB1->(DbSeek(xFilial("SB1")+TMP1->B1_COD))
			TMP1->(DbSkip())
			Loop
		EndIf
		
	EndIf
	
	@Prow()+2,003 PSAY SubStr(TMP1->B1_COD,1,3)+SubStr(TMP1->B1_COD,9,4)
	@Prow()  ,012 PSAY SubStr(TMP1->A7_CODCLI,1,15)
	@Prow()  ,029 PSAY SubStr(TMP1->B1_DESC,1,20)
	@Prow()  ,051 PSAY TMP1->B1_PPLACA	Picture "@E 999"
	@Prow()  ,058 PSAY TMP1->B1_PESO	Picture "@E 999.99"
	@Prow()  ,066 PSAY TMP1->B1_PECANAL	Picture "@E 999.99"
	@Prow()  ,074 PSAY TMP1->B1_PECJTRO Picture "@E 999.99"
	@Prow()  ,082 PSAY TMP1->B1_RMETAL	Picture "@E 999.99"
	@Prow()  ,091 PSAY cMach
	@Prow()  ,096 PSAY cPMach			Picture "@E 999.99"
	@Prow()  ,104 PSAY TMP1->B1_FILTRO	Picture "@E 999"
	If !Empty(TMP1->B1_ULTATU)							//TROCA A DATA EM BRANCO POR "  /  /  "
		@Prow()  ,113 PSAY StoD(TMP1->B1_ULTATU)
	Else
		@Prow()  ,113 PSAY "  /  /  "
	EndIf	
	
	TMP1->(DbSkip())
	
	
EndDo

TMP1->(DbCloseArea())
Return