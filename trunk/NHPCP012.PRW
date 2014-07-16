#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHPCP012   ºAutor ³João Felipe         º Data ³  29/02/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO RELEASE							              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHPCP012()   

cString   := "SZ9"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("a relação dos saldos dos Releases de Fornecedores.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHPCP012"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE RELEASE")
cabec1    := " RMR      FORNECEDOR"//                                 DATA INICIAL     DATA FINAL"
cabec2    := "          Item    Produto                                            Previsto      Entregue     %"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHPCP012"
_cPerg    := "PCP012" 
 
// mv_par01 DO FORNECEDOR
// mv_par02 ATE FORNECEDOR
// mv_par03 DATA INICIAL
// mv_par04 DATA FINAL

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
    
    cQuery := "SELECT ZA9.ZA9_NUM, ZA9.ZA9_FORNEC, ZA9.ZA9_LOJA, ZA9.ZA9_DTINI, ZA9.ZA9_DTFIM,ZA0.ZA0_ITEM, ZA0.ZA0_PROD,"
    cQuery += "	(ZA0.ZA0_PRSEM1+ZA0.ZA0_PRSEM2+ZA0.ZA0_PRSEM3+ZA0.ZA0_PRSEM4+ZA0.ZA0_PRSEM5) AS PREVISAO,"
    cQuery += "	(SELECT SUM(D1.D1_QUANT) FROM SD1NH0 D1"
    cQuery += "	WHERE D1.D1_COD = ZA0.ZA0_PROD"
    cQuery += "	AND D1.D1_EMISSAO BETWEEN ZA9.ZA9_DTINI AND ZA9.ZA9_DTFIM) AS ENTREGUE"
    cQuery += "	FROM ZA9NH0 ZA9, ZA0NH0 ZA0, SD1NH0 D1"
    cQuery += "	WHERE ZA9.ZA9_NUM = ZA0.ZA0_NUM"
    cQuery += "	AND ZA9.ZA9_FORNEC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
    cQuery += "	AND ZA9.ZA9_DTINI >= '"+DTOS(MV_PAR03)+"'"
    cQuery += "	AND ZA9.ZA9_DTFIM <= '"+DTOS(MV_PAR04)+"'"        
    cQuery += "	AND ZA9.D_E_L_E_T_ = ' ' AND ZA9.ZA9_FILIAL = '"+xFilial("ZA9")+"'"
    cQuery += "	AND ZA0.D_E_L_E_T_ = ' ' AND ZA0.ZA0_FILIAL = '"+xFilial("ZA0")+"'"
    cQuery += "	GROUP BY ZA9.ZA9_NUM, ZA9.ZA9_FORNEC, ZA9.ZA9_DTINI, ZA9.ZA9_DTFIM, ZA0.ZA0_ITEM, ZA0.ZA0_PROD, "
    cQuery += "	ZA0.ZA0_PRSEM1,ZA0.ZA0_PRSEM2,ZA0.ZA0_PRSEM3,ZA0.ZA0_PRSEM4,ZA0.ZA0_PRSEM5, ZA9.ZA9_LOJA"

	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TcSetField("TRA1","ZA9_DTINI","D")  // Muda a data de string para date    
 	TcSetField("TRA1","ZA9_DTFIM","D")  // Muda a data de string para date    	
    						
	TRA1->(DbGoTop())

Return

Static Function RptDetail()
Local _cNum := ""
Local nlin := 1
TITULO := OemToAnsi("RELATÓRIO DE RELEASE De "+DtoC(MV_PAR03)+" até "+DtoC(MV_PAR04))

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

While TRA1->(!Eof()) 
	
	If Prow() > 70
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif


	
	If _cNum <> TRA1->ZA9_NUM
		@Prow()+nlin, 001 psay TRA1->ZA9_NUM
		nlin := 2
		@Prow()	   , 010 psay TRA1->ZA9_FORNEC+" - "+TRA1->ZA9_LOJA
		SA2->(DBSETORDER(1))//XFILIAL + COD + LOJA
		SA2->(DBSEEK(XFILIAL("SA2")+TRA1->(ZA9_FORNEC+ZA9_LOJA)))
		IF SA2->(FOUND())
			@Prow()	 , 022 psay SUBSTR(SA2->A2_NOME,1,26)
		ENDIF
//		@Prow()	 , 054 psay TRA1->ZA9_DTINI
//		@Prow()	 , 070 psay TRA1->ZA9_DTFIM
		_cNum :=  TRA1->ZA9_NUM
	EndIf

                        	
	@Prow()+1, 010 psay TRA1->ZA0_ITEM
	@Prow()  , 018 psay TRA1->ZA0_PROD
	SB1->(DbSetOrder(1))
	SB1->(DBSEEK(XFILIAL("SB1")+TRA1->ZA0_PROD))
	IF SB1->(FOUND())
		@Prow()  , 035 psay SUBSTR(SB1->B1_DESC,1,20)
	ENDIF
	@Prow()  , 068 psay TRA1->PREVISAO picture("@e 99999999")
	@Prow()  , 080 psay TRA1->ENTREGUE picture("@e 99999999")
	@Prow()  , 088 psay TRANSFORM((TRA1->PREVISAO/100)*TRA1->ENTREGUE,"@e 99999999")+"%"
	TRA1->(DbSkip())
EndDo

@ Prow()+1,000 PSAY __PrtThinLine()

TRA1->(DbCloseArea())          

Return(nil)