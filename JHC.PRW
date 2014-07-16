
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ relatorio estoque   ºAutor ³Felipe Ciconini   º Data ³  27/07/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESSAO DE SOLICITACAO DE EPI                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
   
#INCLUDE "TOPCONN.CH"

User Function JHC2()

cString		:= "ZDC"
cDesc1		:= "Este relatorio tem como objetivo Imprimir"
cDesc2      := "a relação produtos e suas quantidades"
cDesc3      := "em cada estoque"      
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "Relatorio Teste"
nLastKey	:= 0
titulo		:= OemToAnsi("Relatorio de Produtos")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "Relatorio Teste"
_cPerg		:= ""             

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

Static Function Gerando()
Local cQuery

	//------------------
    // MONTA A QUERY
    //------------------ 
    
    cQuery := "select B1_COD, B1_DESC, B2_LOCAL, B2_QATU "
    cQuery += " FROM SB1FN0 SB1, SB2FN0 SB2 "
    cQuery += " WHERE B1_COD=B2_COD "   
    cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += " AND SB2.D_E_L_E_T_ = ' ' "    

 	TCQUERY cQuery NEW ALIAS "JHC"
	JHC->(DbSKIP())
	
Return
	
Static Function RptDetail() 
Local _nttotal := 0
Local _ntqtde := 0    

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)       

@Prow()+2, 001 psay "CODIGO         DESCRIÇÃO                                  LOCAL          QTD"

While JHC->(!Eof()) 

	@Prow()+1, 001 psay JHC->B1_COD // CODIGO
	@Prow()  , 016 psay JHC->B1_DESC // DESCRIÇÃO 
	@Prow()  , 060 psay JHC->B2_LOCAL // LOCAL
	@Prow()  , 075 psay JHC->B2_QATU // QUANTIDADE
	JHC->(DbSkip())
EndDo    

@Prow()+2,000 PSAY __PrtThinLine()

JHC->(DbCloseArea())    

Return    
    
     
