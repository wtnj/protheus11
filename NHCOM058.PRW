/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHCOM058   บAutor ณCAIO LISBOA       บ Data ณ  29/04/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATORIO DE RELAวรO DE SC/PC POR COMPRADOR                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPRAS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   

#INCLUDE "TOPCONN.CH"
  
User Function NHCOM058()

cString		:= "SC1"
cDesc1   	:= OemToAnsi("Este relatorio tem como objetivo relacionar SC's       ")
cDesc2   	:= OemToAnsi("a seu Pedido de Compra, mostrando o Comprador e a      ")
cDesc3   	:= OemToAnsi("diferen็a entre a data da SC e do Pedido.              ")        
tamanho		:= "G"
limite		:= 220
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHCOM058"
nLastKey	:= 0
titulo		:= OemToAnsi("Relatorio SC/PC")
cabec1    	:= OemToAnsi (" COMPRADOR                          Nบ SC           ITEM SC          CODIGO DO PRODUTO        DATA SC           Nบ PC           ITEM PC       DATA PC               VALOR PC       DIFER (DIAS)")
cabec2      := ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHCOM058"
_cPerg		:= "NHCOM058"       

Pergunte(_cperg, .F.)
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
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return
*/
Static Function Gerando()
Local cQuery       

	//------------------
    // MONTA A QUERY
    //------------------ 
        
    cQuery := "SELECT Y1_NOME, C1_NUM, C1_ITEM, C1_PRODUTO, C1_EMISSAO, C7_NUM, C7_ITEM, C7_EMISSAO, C7_TOTAL "
    cQuery += " FROM " + RetSqlName( 'SC1' ) + " SC1, " +  RetSqlName( 'SC7' ) + " SC7, " +  RetSqlName( 'SY1' ) + " SY1 "
    cQuery += " WHERE SC7.C7_NUMSC=SC1.C1_NUM "   
    cQuery += " AND SC7.C7_USER=SY1.Y1_USER "
    cQuery += " AND SC7.C7_RESIDUO <> 'S' "
    cQuery += " AND SC1.C1_RESIDUO <> 'S' "
    //cQuery += " AND SC7.C7_EMISSAO > '20110401' "
    cQuery += " AND SC1.C1_ITEM=SC7.C7_ITEMSC "
    cQuery += " AND SC1.D_E_L_E_T_='' "
    cQuery += " AND SC7.D_E_L_E_T_='' " 
    cQuery += " AND SY1.D_E_L_E_T_='' "
    cQuery += " AND SC1.C1_FILIAL = '"+xFilial("SC1")+"'"
 	cQuery += " AND SC7.C7_FILIAL = '"+xFilial("SC7")+"'"
  	cQuery += " AND SY1.Y1_FILIAL = '"+xFilial("SY1")+"'"
    cQuery += " AND SY1.Y1_USER    BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" 
  	cQuery += " AND SC1.C1_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
  	cQuery += " AND SC7.C7_EMISSAO BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'"
    cQuery += " ORDER BY SY1.Y1_NOME, SC7.C7_EMISSAO, SC1.C1_NUM, SC1.C1_ITEM ASC "

 	//MemoWrit('C:\TEMP\CAIOTESTE.SQL',cQuery)
 	TCQUERY cQuery NEW ALIAS "NHCOM058"  
 	TcSetField("NHCOM058","C1_EMISSAO"  ,"D") // Muda a data de string para date  
 	TcSetField("NHCOM058","C7_EMISSAO"  ,"D") // Muda a data de string para date  
 	
	NHCOM058->(DbSKIP())
	
Return
	
Static Function RptDetail() 
Local _nttotal := 0
Local _ntqtde := 0    

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)       

//@Prow()+2, 001 psay " COMPRADOR                          Nบ SC           ITEM SC          CODIGO DO PRODUTO        DATA SC           Nบ PC           ITEM PC       DATA PC           VALOR PC           DIFER (DIAS)"

While NHCOM058->(!Eof()) 

   	If Prow() > 55
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif

	@Prow()+1, 001 psay SUBS (NHCOM058->Y1_NOME,1,26)  // COMPRADOR 
	@Prow()  , 036 psay NHCOM058->C1_NUM // Nบ SC 
	@Prow()  , 052 psay NHCOM058->C1_ITEM // ITEM SC
	@Prow()  , 069 psay NHCOM058->C1_PRODUTO // CODIGO DO PRODUTO   
	@Prow()  , 094 psay NHCOM058->C1_EMISSAO // DATA DE EMISSรO SC
	@Prow()  , 112 psay NHCOM058->C7_NUM // Nบ PC
	@Prow()  , 128 psay NHCOM058->C7_ITEM // ITEM PC
	@Prow()  , 142 psay NHCOM058->C7_EMISSAO // DATA EMISSรO PC
	@Prow()  , 160 psay NHCOM058->C7_TOTAL picture "@e 99,999,999.99" // VALOR PC
	@Prow()  , 179 psay NHCOM058->(C7_EMISSAO-C1_EMISSAO) // DIFERENวA ENTRE A DATA DO SC E PC
	NHCOM058->(DbSkip())
EndDo    

@Prow()+2,000 PSAY __PrtThinLine()

NHCOM058->(DbCloseArea())    

Return    

