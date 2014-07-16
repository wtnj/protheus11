#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT022   ºAutor ³João Felipe         º Data ³  29/02/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CONSUMO DE MATERIAIS/EQUIPAMENTO 			              º±±
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

User Function NHMNT022()

cString   := "STJ"
cDesc1    := "Este   relatorio   tem   como   objetivo  Imprimir "
cDesc2    := ""
cDesc3    := ""
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT022"
nLastKey  := 0
titulo    := "CONSUMO DE MATERIAIS/EQUIPAMENTO"
cabec1    := " Bem          Ordem     C.Trab.  C.Custo                           Produto       Descricao                       Qtde  Custo Un.  Custo Total"
cabec2    := ""
cabec3    := "" 
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT022"
_cPerg    := "MNT022"
 
// mv_par01 de data 
// mv_par02 até data	

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

//-- PROGRAMACAO

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
    
    cQuery := "SELECT TJ.TJ_ORDEM, TJ_CODBEM, TL_CODIGO, B1_DESC, CAST(SUM(TL_QUANTID)AS FLOAT) AS QUANTID, TJ.TJ_CCUSTO, "
    cQuery += " TJ.TJ_CENTRAB, CTT.CTT_DESC01, "
    cQuery += " CAST(SUM(TL_CUSTO)AS MONEY) AS TOTAL , CAST(SUM(TL_CUSTO)/CAST(SUM(TL_QUANTID)AS FLOAT)AS MONEY) AS CUSTO_UNIT "
    cQuery += " FROM "+RetSqlName('STL')+" TL, "+RetSqlName('STJ')+" TJ, "+RetSqlName('SB1')+" B1, "+RetSqlName("CTT")+" CTT,"
	cQuery += RetSqlName('ST9')+" T9"
    cQuery += " WHERE B1_COD = TL_CODIGO"
    cQuery += " AND TJ_ORDEM = TL_ORDEM"
    cQuery += " AND CTT.CTT_CUSTO = TJ.TJ_CCUSTO"
    cQuery += " AND TL.TL_DTINICI >= '"+DtoS(mv_par01)+"'"
    cQuery += " AND TL.TL_DTFIM <= '"+DtoS(mv_par02)+"'"
	cQuery += " AND TJ.TJ_CODBEM = T9.T9_CODBEM"
    cQuery += " AND TL.TL_CODIGO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
    cQuery += " AND TJ.TJ_CCUSTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
    cQuery += " AND T9.T9_CENTRAB BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cQuery += " AND TJ.TJ_ORDEM BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"

    If mv_par11 == 1//Lubrificacao
	    cQuery += " AND TJ_SERVICO <> '000003'"
   	 	cQuery += " AND TL_UNIDADE <> 'KG'"
   	 	cQuery += " AND TL_PLANO IN ('000000','000001')"
   	 	cQuery += " AND TL_CODIGO LIKE 'OL03%'" //fixo  
	EndIf
    If mv_par11 == 2//Manutencao
//	    cQuery += " AND TJ_SERVICO <> '000000'"
// 	 	cQuery += " AND TL_CODIGO LIKE 'MM%'" //fixo  
   	EndIf
    cQuery += " AND CTT.D_E_L_E_T_ = ' ' AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"
    cQuery += " AND TJ.D_E_L_E_T_ = ' ' AND TJ.TJ_FILIAL = '"+xFilial("STJ")+"'"
	cQuery += " AND T9.D_E_L_E_T_ = ' ' AND T9.T9_FILIAL = '"+xFilial('ST9')+"'"
    cQuery += " AND TL.D_E_L_E_T_ = ' ' AND TL.TL_FILIAL = '"+xFilial("STL")+"'"
    cQuery += " AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
    cQuery += " GROUP BY TJ_ORDEM, TJ_CODBEM, TL_CODIGO, B1_DESC, TJ.TJ_CCUSTO, TJ.TJ_CENTRAB, CTT.CTT_DESC01"


	MemoWrit('C:\TEMP\NHMNT022.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1"  
	
	TRA1->(DbGoTop())

Return

Static Function RptDetail()
Local _nttotal := 0
Local _ntqtde := 0
                                         
Titulo += OemToAnsi(" - ( Fábrica: ")+MV_PAR07+OemToAnsi(" até ")+MV_PAR08+")"

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

While TRA1->(!Eof()) 

	If Prow() > 55
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif

	@Prow()+1, 001 psay SUBS(TRA1->TJ_CODBEM,1,14)
	@Prow()  , 015 psay TRA1->TJ_ORDEM
	@Prow()  , 025 psay TRA1->TJ_CENTRAB
	@Prow()  , 033 psay ALLTRIM(TRA1->TJ_CCUSTO)+" - "+SUBS(TRA1->CTT_DESC01,1,24)
//	@Prow()  , 033 psay SUBS(TRA1->CTT_DESC01,1,20)
	@Prow()  , 068 psay ALLTRIM(TRA1->TL_CODIGO)+" - "+SUBS(TRA1->B1_DESC,1,27)
//	@Prow()  , 070 psay TRA1->B1_DESC
	@Prow()  , 110 psay TRA1->QUANTID picture("@e 99999.99")
	_ntqtde += TRA1->QUANTID
	@Prow()  , 118 psay TRA1->CUSTO_UNIT picture("@e 999,999.99")
	@Prow()  , 130 psay TRA1->TOTAL picture("@e 999,999.99")
	_nttotal += TRA1->TOTAL
	TRA1->(DbSkip())
EndDo

@ Prow()+1,000 PSAY __PrtThinLine()
@Prow()+1 , 001 psay "Total: --->"
@Prow()  , 110 psay _ntqtde picture("@e 99999.99")
@Prow()  , 126 psay _nttotal picture("@e 999,999,999.99")
					
TRA1->(DbCloseArea())          

Return(nil)