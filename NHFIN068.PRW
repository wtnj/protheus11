#include 'fivewin.ch'
#include 'topconn.ch'
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHFIN068  ºAutor ³João Felipe da Rosa º Data ³  10/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE INADIMPLENCIA DOS CLIENTES                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHFIN068()   

SetPrvt("")
aCols     := {}                  
cString   := "SE1"
cDesc1    := OemToAnsi("Este relatório tem por objetivo fornecer o total inadimplencia")
cDesc2    := OemToAnsi(" dos clientes da WHB")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN068"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE INADIMPLÊNCIA DOS CLIENTES")                
cabec1    := OemToAnsi(" Cliente  Loja  Descrição                        Vencimento          Vencido      % Inadimplencia")    
cabec2    := " "
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHFIN068"
_cPerg    := "FIN068" 

// mv_par01 -> do cliente
// mv_par02 -> até cliente
// mv_par03 -> da loja
// mv_par04 -> até loja
// mv_par05 -> de data
// mv_par06 -> até data

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

Pergunte(_cPerg,.F.) 

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
		//  monta a query para o SE1
		//-----------------------------------------------------------------------		
		
		cQuery := " SELECT E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_NOMCLI, SUM(E1.E1_SALDO) AS SALDO ,E1_MOEDA"
		cQuery += " FROM " + RetSqlName('SE1') + " E1"
		cQuery += " WHERE E1.E1_CLIENTE BETWEEN'" + mv_par01 +"' AND '" + mv_par02 + "'"
		cQuery += " AND E1.E1_LOJA BETWEEN '" + mv_par03 +"' AND '" + mv_par04 + "'"
		cQuery += " AND E1.E1_VENCREA BETWEEN '" + DtoS(mv_par05) + "' AND '" +DtoS(mv_par06) + "'"
		cQuery += " AND E1.D_E_L_E_T_ = ''"
		cQuery += " GROUP BY E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_NOMCLI, E1.E1_MOEDA ORDER BY E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_NOMCLI, E1_MOEDA"
		
		cQuery2 := " SELECT E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_NOMCLI, SUM(E1.E1_SALDO) AS SALDO"
		cQuery2 += " FROM " + RetSqlName('SE1') + " E1"
		cQuery2 += " WHERE E1_CLIENTE BETWEEN'" + mv_par01 +"' AND '" + mv_par02 + "'"
		cQuery2 += " AND E1.E1_LOJA BETWEEN '" + mv_par03 +"' AND '" + mv_par04 + "'"
		cQuery2 += " AND E1.E1_VENCTO BETWEEN '" + DtoS(mv_par05) +"' AND '" +DtoS(mv_par06) + "'"
		cQuery2 += " AND E1.E1_STATUS = 'A'"
		cQuery2 += " AND E1.D_E_L_E_T_ = ''"
		cQuery2 += " GROUP BY E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_NOMCLI, E1.E1_MOEDA ORDER BY E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_NOMCLI"

		MemoWrit('C:\TEMP\NHFIN068.SQL',cQuery)
		MemoWrit('C:\TEMP\NHFIN068QRY2.SQL',cQuery2)

		TCQUERY cQuery NEW ALIAS 'TRA1'
		TCQUERY cQuery2 NEW ALIAS 'TRB'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
		
Return
    
Static Function RptDetail()  

Local _nVeTotal := 0 //vencimento
Local _nVTotal := 0 //vencido
Local _nTPerc := 0 //total percent
Local _cData := DtoS(Date())
Local _nMoeda := 1
Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    

DbSelectArea('TRA1')    

TRA1->(DbGotop())
TRB->(DbGotop())

While TRA1->( ! Eof() ) .AND. !TRB->(EOF())
	If Prow() > 60
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
	Endif  

	@ Prow()+1 , 002 Psay TRA1->E1_CLIENTE
	@ Prow()   , 010 Psay TRA1->E1_LOJA
	@ Prow()   , 016 Psay TRA1->E1_NOMCLI
    
    SM2->(DbSetOrder(1))
	SM2->(DbSeek(_cData))
	
	Do Case
		Case TRA1->E1_MOEDA == 2
			_nMoeda := SM2->M2_MOEDA2
		Case TRA1->E1_MOEDA == 3
			_nMoeda := SM2->M2_MOEDA3			
		Case TRA1->E1_MOEDA == 4
			_nMoeda := SM2->M2_MOEDA4			
		Case TRA1->E1_MOEDA == 5
			_nMoeda := SM2->M2_MOEDA5			
		Case TRA1->E1_MOEDA == 6
			_nMoeda := SM2->M2_MOEDA6			
	EndCase		

	@ Prow()   , 046 Psay Transform(TRA1->SALDO*_nMoeda,"@e 999,999,999.99")
	If TRA1->E1_CLIENTE == TRB->E1_CLIENTE .and. TRA1->E1_LOJA <> TRB->E1_LOJA .or.;
	   TRA1->E1_CLIENTE <> TRB->E1_CLIENTE .and. TRA1->E1_LOJA == TRB->E1_LOJA .or.;
	   TRA1->E1_CLIENTE <> TRB->E1_CLIENTE .and. TRA1->E1_LOJA <> TRB->E1_LOJA
		@ Prow()   , 071 Psay "Quitado"
		@ Prow()   , 090 Psay "0%"
		TRA1->(DbSkip())	 	
	ElseIf TRA1->E1_CLIENTE == TRB->E1_CLIENTE .And. TRA1->E1_LOJA == TRB->E1_LOJA

		@ Prow()   , 064 Psay Transform(TRB->SALDO*_nMoeda,"@e 999,999,999.99")
		@ Prow()   , 085 Psay Transform(((TRB->SALDO*_nMoeda) *100)/(TRA1->SALDO*_nMoeda), "@E 999.99") + "%" 
    	_nVTotal += (TRB->SALDO*_nMoeda) //vencido
		TRA1->(DbSkip())
		TRB->(DbSkip())	 	
	EndIf
	_nVeTotal += (TRA1->SALDO*_nMoeda) //vencimento

end
@ Prow()+1,000 PSAY __PrtThinLine()
@ Prow()+1,001 Psay "Total:"
@ Prow()  ,046 Psay Transform(_nVeTotal ,"@e 999,999,999.99") 
@ Prow()  ,064 Psay Transform(_nVTotal  ,"@e 999,999,999.99") 
@ Prow()  ,085 Psay Transform((_nVtotal*100)/_nVeTotal,"@e 999.99") + "%"

TRB->(DbCloseArea('TRB')) 

Return(nil)
  