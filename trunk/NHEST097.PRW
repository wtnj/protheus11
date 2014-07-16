#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST073  ºAutor ³Fabio William Nico  º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CONFERENCIA DE NFS DE ENTRADA                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST097()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os  ")
cDesc2    := OemToAnsi("Valores de Consumo do Almoxarifado")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST097"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE CONFERENCIA DE NF DE ENTRADA / RETENCAO ")                
cabec2    := " N.NF       Cli/Loja    Razao Social                                 CNPJ                      Vlr.Total NF      Retenção   Vlr.ICMS"
//cabec2    := "Periodo de : " + mv_par01 + " a " + mv_par02
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST097"
_cPerg    := "EST097" 
_nTotal   := 0  
_nTotcol01 := 0  
_nTotcol02 := 0  


Pergunte(_cPerg,.F.)                                      
cabec1    := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)
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

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

TRA1->(DbCloseArea())

set filter to 

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

Static Function Gerando()
		//-----------------------------------------------------------------------
		//  monta a query para o SF1
		//-----------------------------------------------------------------------		
		//relacionar o Sf1 com o SD1 utilizar os campos p/ relaciomanento D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_EMISSAO
		cQuery := " SELECT F1.F1_DOC,F1.F1_FORNECE,F1.F1_LOJA, F1.F1_VALBRUT,F1.F1_VALICM,F1.F1_SERIE,"                                                    
		cQuery += " F1.F1_VALPIS+F1.F1_VALCOFI+F1.F1_VALCSLL+F1.F1_IRRF+F1.F1_ISS+F1.F1_INSS AS RETENCAO,'CLIENTE' =  "		
		cQuery += " CASE "
   		cQuery += "   WHEN F1.F1_TIPO IN ('D','B') THEN "  
		cQuery += "        (SELECT A1.A1_NOME+"+"A1.A1_CGC"
		cQuery += "         FROM " +RetSqlName('SA1') +" A1 "
		cQuery += "         WHERE A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = F1.F1_FORNECE "
		cQuery += "         AND A1.A1_LOJA = F1.F1_LOJA) "                           
		cQuery += "   ELSE "
		cQuery += "        (SELECT A2.A2_NOME+"+"A2.A2_CGC"
		cQuery += "         FROM " +RetSqlName('SA2') +" A2 "
		cQuery += "         WHERE A2.D_E_L_E_T_ = ' ' AND A2.A2_COD = F1.F1_FORNECE "
		cQuery += "         AND A2.A2_LOJA = F1.F1_LOJA) "
		cQuery += " END "
		cQuery += " FROM " + RetSqlName('SF1') + " F1," + RetSqlName('SD1') + " D1"  
		cQuery += " WHERE F1.F1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
		cQuery += " AND D1.D1_LOCAL BETWEEN '"+ mv_par03+"' And '"+ mv_par04+"' "		
		cQuery += " AND D1.D1_DOC+D1.D1_SERIE+D1.D1_FORNECE+D1.D1_LOJA = F1.F1_DOC+F1.F1_SERIE+F1.F1_FORNECE+F1.F1_LOJA" 
		cQuery += " AND F1.F1_DTDIGIT = D1.D1_DTDIGIT"
		cQuery += " AND F1.D_E_L_E_T_ = '' "		
		cQuery += " AND D1.D_E_L_E_T_ = '' "		
		cQuery += " ORDER BY F1.F1_DOC,F1.F1_SERIE,F1.F1_FORNECE,F1.F1_LOJA"

		
 //       MemoWrit('C:\TEMP\EST097.SQL',cQuery)
 		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
Return

Static Function RptDetail()                                      
Local _cChave := ""

DBSELECTAREA("TRA1")
TRA1->(DbGoTop())

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

while !eof()       

    If _cChave <> TRA1->F1_DOC+TRA1->F1_SERIE+TRA1->F1_FORNECE+TRA1->F1_LOJA
        _cChave := TRA1->F1_DOC+TRA1->F1_SERIE+TRA1->F1_FORNECE+TRA1->F1_LOJA
		@ Prow()+1, 001 Psay TRA1->F1_DOC 	 Picture "@e 999999999"
		@ Prow()  , 012 Psay TRA1->F1_FORNECE Picture "@e 999999"	
		@ Prow()  , 019 Psay TRA1->F1_LOJA	 Picture "@e 99"	                                                    
		@ Prow()  , 022 Psay substr(TRA1->CLIENTE,0,40)	 Picture "@!"	
		@ Prow()  , 065 Psay transform(substr(TRA1->CLIENTE,41,60),"@R 99.999.999/9999-99")
		@ Prow()  , 095 Psay TRA1->F1_VALBRUT Picture "@e 999,999.99"			
		@ Prow()  , 110 Psay TRA1->RETENCAO   Picture "@e 999,999.99"			
		@ Prow()  , 121 Psay TRA1->F1_VALICM Picture "@e 999,999.99"			
		
		_nTotcol01 := _nTotcol01 + TRA1->F1_VALBRUT
		_nTotcol02 := _nTotcol02 + TRA1->RETENCAO
	
		if prow() > 70 
			Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
		endif
    Endif 		
		
	TRA1->(DbSkip())	
enddo

@ Prow()+2,000 PSAY __PrtThinLine() 
@ Prow()+1 , 001 Psay "TOTAL DO PERIODO..:" 
@ Prow()   , 090 Psay _nTotcol01 picture "@E 999,999,999.99"   
@ Prow()   , 110 Psay _nTotcol02 picture "@E 999,999.99"   
Return(nil)