#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST073  ºAutor ³Fabio William Nico  º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CUSTOS DE MANUTENCAO                                       º±±
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

User Function NHEST080()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os  ")
cDesc2    := OemToAnsi("Valores de Consumo do Almoxarifado")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST080"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE COMPRAS DIRETAS ")                
cabec1    := "Produto            Descricao                        Qtde.       Valor         C.Custo     Cta Contabil     Fornece.      Razao Social                           Dcto.    Dt.Digit   Pedido "
cabec2    := "Periodo de : " + mv_par01 + " a " + mv_par02
cabec3    := "C.Custo  Descricao                Cta Contabil   Descricao                      Qtde.       Valor  "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST080"
_cPerg    := "EST080" 
_nTotal   := 0  
_nTotcol01 := 0  
_nTotcol02 := 0  
          
// mv_ch01 -> Dt Inicio
// mv_ch02 -> Dt Fim                       
// mv_ch05 -> CC Inicio
// mv_ch06 -> CC Fim
// mv_ch03 -> Conta Inicio
// mv_ch04 -> Conta Fim 
// mv_ch07 -> Tipo Analitico / Sintetico.


Pergunte(_cPerg,.F.) 

if mv_par07 = 1
		cabec2    := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)
		SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,'G')
	else
		cabec2    := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)
		SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,'M')	
endif

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

//TRB->(DbCloseArea()) 
//TR3->(DbCloseArea()) 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando()
		//-----------------------------------------------------------------------
		//  monta a query para o SD1
		//-----------------------------------------------------------------------		
		if mv_par07 = 1
			cQuery := " SELECT D1.D1_COD,B1.B1_DESC,D1.D1_QUANT AS QUANTIDADE ,D1.D1_TOTAL AS TOTAL ,D1.D1_CC,D1.D1_CONTA,"
			cQuery += " D1.D1_FORNECE,A2.A2_NOME,D1.D1_DOC,D1.D1_DTDIGIT,D1.D1_PEDIDO,CTT.CTT_DESC01"
			else
			cQuery := " SELECT SUM(D1.D1_QUANT) AS QUANTIDADE, SUM(D1.D1_TOTAL) AS TOTAL,D1.D1_CC,D1.D1_CONTA,CTT.CTT_DESC01,CT1.CT1_DESC01"
		endif                                                                                      
		cQuery += " FROM " + RetSqlName('SD1') + " D1, " + RetSqlName('SA2') +" A2 , " + RetSqlName('SB1') + " B1 , " + RetSqlName('CTT') + " CTT , "
		cQuery += + RetSqlName('CT1') + " CT1 "
		cQuery += " WHERE D1.D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
		cQuery += " AND   D1.D1_CONTA   BETWEEN '"+mv_par03+"' And '"+mv_par04+"' "
		cQuery += " AND   D1.D1_CC      BETWEEN '"+mv_par05+"' And '"+mv_par06+"' "
 		cQuery += " AND   B1.B1_COD = D1.D1_COD "
		cQuery += " AND   A2.A2_COD = D1.D1_FORNECE "
		cQuery += " AND   CTT.CTT_CUSTO = D1.D1_CC "
		cQuery += " AND   CT1.CT1_CONTA = D1.D1_CONTA "
		cQuery += " AND   D1.D_E_L_E_T_ = ' ' "
		cQuery += " AND   B1.D_E_L_E_T_ = ' ' "
		cQuery += " AND   A2.D_E_L_E_T_ = ' ' "
		cQuery += " AND   CTT.D_E_L_E_T_ = ' ' "
		
		if mv_par07 = 2
		 	cQuery += " GROUP BY D1.D1_CC,D1.D1_CONTA,CTT.CTT_DESC01,CT1.CT1_DESC01"
		endif


		MemoWrit('C:\TEMP\NHEST080.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

Return



Static Function RptDetail()  
if mv_par07 = 1
	Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    
  else
	Cabec(Titulo, Cabec3,Cabec2,NomeProg, "M", nTipo)                                      
endif
DbSelectArea('TRA1')
While TRA1->( ! Eof() )
	if mv_par07 = 1
	 	@ Prow()+1 , 001 Psay TRA1->D1_COD
	 	@ Prow()   , 017 Psay TRA1->B1_DESC
	 	@ Prow()   , 050 Psay TRA1->QUANTIDADE  Picture "@E 999,999.99"
	 	@ Prow()   , 064 Psay TRA1->TOTAL  Picture "@E 999,999.99"
	 	@ Prow()   , 080 Psay TRA1->D1_CC
 		@ Prow()   , 090 Psay TRA1->D1_CONTA  
	 	@ Prow()   , 110 Psay TRA1->D1_FORNECE
 		@ Prow()   , 120 Psay TRA1->A2_NOME
	 	@ Prow()   , 160 Psay TRA1->D1_DOC
 		@ Prow()   , 170 Psay TRA1->D1_DTDIGIT
	 	@ Prow()   , 180 Psay TRA1->D1_PEDIDO
	  else
	  	@ Prow()+1 , 001 Psay TRA1->D1_CC   
	 	@ Prow()   , 010 Psay TRA1->CTT_DESC01
	 	@ Prow()   , 030 Psay TRA1->D1_CONTA  
	 	@ Prow()   , 045 Psay TRA1->CT1_DESC01
	 	@ Prow()   , 075 Psay TRA1->QUANTIDADE  Picture "@E 999,999.99"
	 	@ Prow()   , 090 Psay TRA1->TOTAL  Picture "@E 999,999.99"
 	endif
 	
 	_nTotcol01 += TRA1->QUANTIDADE
 	_nTotcol02 += TRA1->TOTAL
 	
    TRA1->(DbSkip())
end


	   	
@ Prow()+2,000 PSAY __PrtThinLine() 
@ Prow()+1 , 001 Psay "TOTAL DO PERIODO..:" 
@ Prow()   , 045 Psay _nTotcol01 picture "@E 99,999,999.99"   
@ Prow()   , 062 Psay _nTotcol02 picture "@E 99,999,999.99"   


Return(nil)