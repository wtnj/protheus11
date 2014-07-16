#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHMNT026  บAutor ณJoใo Felipe da Rosa บ Data ณ  07/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Materiais Pendentes                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANUTENCAO DE ATIVOS                                       บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NHMNT026()   

Agrupo 	  := {}
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi(" as OS de servicos para execucao")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT015"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("O.S. Em aberto por Turno / Situacao ")                
cabec2    := " No.OS     Data OS     Cod.Bem    Descricao Bem                                       C.C.                  C.Trab.    Status p/ Exec"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT026"
_cPerg    := "MNT026" 
_nTotal   := 0  
_totalgeral := 0  
_totalcc := 0

If !Pergunte('MNT026',.T.)
   Return(nil)
Endif 
                       
cabec1  := " Periodo de : " + DTOC(mv_par09) + " a " + DTOC(mv_par10)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

Processa ( {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| Imprime()   },"Classificando dados...")

set filter to 

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
Local cQuery

//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------	 

cQuery := "SELECT TJ.TJ_ORDEM, TJ.TJ_DTORIGI, TJ_CODBEM, T9_NOME, TJ.TJ_CCUSTO,"
cQuery += " TJ.R_E_C_N_O_ AS TJ_RECNO, TJ.TJ_CENTRAB, TJ.TJ_OBSERVA"
cQuery += " FROM "+RetSqlName("STJ")+ " TJ, "+RetSqlName("ST9")+" T9"
cQuery += " WHERE TJ.TJ_CODBEM = T9.T9_CODBEM"
cQuery += " AND TJ.TJ_TERMINO = 'N'" 
cQuery += " AND TJ.TJ_SITUACA <> 'C'"
cQuery += " AND TJ.TJ_ORDEM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND TJ.TJ_CCUSTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery += " AND TJ.TJ_CENTRAB BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQuery += " AND TJ.TJ_SERVICO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
cQuery += " AND TJ.TJ_DTORIGI BETWEEN '"+DtoS(mv_par09)+"' AND '"+DtoS(mv_par10)+"'"
cQuery += " AND TJ.D_E_L_E_T_ = ' ' AND TJ.TJ_FILIAL = '"+xFilial("STJ")+"'"
cQuery += " AND T9.D_E_L_E_T_ = ' ' AND T9.T9_FILIAL = '"+xFilial("ST9")+"'"
cQuery += " ORDER BY TJ.TJ_ORDEM"

MemoWrit('C:\TEMP\NHMNT026.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TRA1->(DbGotop())     

Return

Static Function Imprime()

Local nLinha
Local _cOS
Local _cSC
Local _cStatus := .T.
Local _aMat := {}
Local _aOs  := {}
Local _aPed := {}
Local _aSC  := {}
Local _aNPed := {}

Local _n,_x

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SetRegua(TRA1->(RecCount()))

While TRA1->(!Eof())  

	IncRegua("...Classificando Dados. OS: "+TRA1->TJ_ORDEM)
	iF TRA1->TJ_ORDEM = '177777'
		Alert("Stop")
	EndIf

	//Pega as SCS para a O.S.
    cQuery := "SELECT C1_NUM, C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_PEDIDO, C1_QUANT, C1_QUJE  FROM "+RetSqlName("SC1")+" C1"
    cQuery += " WHERE C1_OS = '"+TRA1->TJ_ORDEM+"'"
    cQuery += " AND D_E_L_E_T_ = ' ' AND C1_FILIAL = '"+xFilial("SC1")+"'"
//    cQuery += " GROUP BY C1_NUM"
    
    TcQuery cQuery New Alias "TRB"
	
	_cStatus := .T.
	If !Empty(TRB->C1_NUM)
//		DbSelectArea("SC1")
//		DbSetOrder(1) // filial + numsc + item
		
		While TRB->(!EoF())
//			DbSeek(xFilial("SC1")+ TRB->C1_NUM)
//			If SC1->(Found())
			//ADICIONA O PEDIDO
			If !Empty(TRB->C1_PEDIDO)
				aAdd(_aNPed,TRB->C1_PEDIDO)
			EndIf

			If TRB->C1_QUANT > TRB->C1_QUJE //pendente
				aAdd(_aSC,{TRA1->TJ_ORDEM,TRA1->TJ_DTORIGI,TRA1->TJ_CODBEM,TRA1->T9_NOME,TRA1->TJ_CCUSTO,TRA1->TJ_RECNO,TRA1->TJ_CENTRAB,"","",;
					    TRB->C1_NUM,TRB->C1_ITEM,TRB->C1_PRODUTO,TRB->C1_DESCRI,TRB->C1_QUANT,TRB->C1_QUJE,"S","P"})  //sc pendente
				_cStatus := .F.
			Else
				If TRB->C1_QUANT == 0 //SC rejeitada
					aAdd(_aSC,{TRA1->TJ_ORDEM,TRA1->TJ_DTORIGI,TRA1->TJ_CODBEM,TRA1->T9_NOME,TRA1->TJ_CCUSTO,TRA1->TJ_RECNO,TRA1->TJ_CENTRAB,"","",;
						    TRB->C1_NUM,TRB->C1_ITEM,TRB->C1_PRODUTO,TRB->C1_DESCRI,TRB->C1_QUANT,TRB->C1_QUJE,"S","R"})  //sc rejeitada
				Else 
					aAdd(_aSC,{TRA1->TJ_ORDEM,TRA1->TJ_DTORIGI,TRA1->TJ_CODBEM,TRA1->T9_NOME,TRA1->TJ_CCUSTO,TRA1->TJ_RECNO,TRA1->TJ_CENTRAB,"","",;
						    TRB->C1_NUM,TRB->C1_ITEM,TRB->C1_PRODUTO,TRB->C1_DESCRI,TRB->C1_QUANT,TRB->C1_QUJE,"S","L"})  //sc liberada
				EndIf
			EndIf
    	
			TRB->(DbSkip())
		EndDo
			
		//Pega os Pedidos para a O.S.
		DbSelectArea("SC7")
		DbSetOrder(1) //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN

		For x:= 1 to len(_aNPed)
			DbSeek(xFilial("SC7")+_aNPed[x])
			If SC7->(Found())
				While SC7->C7_NUM == _aNPed[x]
					If SC7->C7_OS == TRA1->TJ_ORDEM
						If SC7->C7_QUANT > SC7->C7_QUJE
							aAdd(_aPed,{TRA1->TJ_ORDEM,TRA1->TJ_DTORIGI,TRA1->TJ_CODBEM,TRA1->T9_NOME,TRA1->TJ_CCUSTO,TRA1->TJ_RECNO,TRA1->TJ_CENTRAB,"","",;
							SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_PRODUTO,SC7->C7_DESCRI,SC7->C7_QUANT,SC7->C7_QUJE,"P","P"}) //pedido pendente
	            	        _cStatus := .F.
						Else
							aAdd(_aPed,{TRA1->TJ_ORDEM,TRA1->TJ_DTORIGI,TRA1->TJ_CODBEM,TRA1->T9_NOME,TRA1->TJ_CCUSTO,TRA1->TJ_RECNO,TRA1->TJ_CENTRAB,"","",;
							SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_PRODUTO,SC7->C7_DESCRI,SC7->C7_QUANT,SC7->C7_QUJE,"P","L"}) //pedido liberado
						EndIf				
					EndIf
					SC7->(DbSkip())
				EndDo
			EndIf
		Next
		_aNPed := {}
	Else
		aAdd(_aSC,{TRA1->TJ_ORDEM,TRA1->TJ_DTORIGI,TRA1->TJ_CODBEM,TRA1->T9_NOME,TRA1->TJ_CCUSTO,TRA1->TJ_RECNO,TRA1->TJ_CENTRAB,"","",;
				    "","","","","","","",""}) //
	EndIf	
	If mv_par13 <> 3 //ambas
		If _cStatus
			If mv_par13 == 1 //s๓ pego prontas
				//adiciona a matriz com os,sc e pedidos na matriz a ser impressa
				For _x:=1 to len(_aSC)
					aAdd(_aOs,_aSC[_x])
				Next
				For _x:=1 to len(_aPed)
					aAdd(_aOs,_aPed[_x])
				Next
			EndIf
	 	Else
	 		If mv_par13 == 2 //s๓ pego pendentes
				//adiciona a matriz com os,sc e pedidos na matriz a ser impressa
				For _x:=1 to len(_aSC)
					aAdd(_aOs,_aSC[_x])
				Next
				For _x:=1 to len(_aPed)
					aAdd(_aOs,_aPed[_x])
				Next
			EndIf
		EndIf
	Else
		//adiciona a matriz com os,sc e pedidos na matriz a ser impressa
		For _x:=1 to len(_aSC)
			aAdd(_aOs,_aSC[_x])
		Next
		For _x:=1 to len(_aPed)
			aAdd(_aOs,_aPed[_x])
		Next

	EndIf	
	_aSC := {}
	_aPed := {}
	
	TRA1->(DbSkip())
	TRB->(DbCloseArea())
		
EndDo


// IMPRIME 
    

SetRegua(Len(_aOS))
_x := 1

While _x <= Len(_aOS)
//While TRA1->(!Eof())

	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	IncRegua("...Imprimindo")
		
	@Prow()+1, 001 psay _aOS[_x][1] //TRA1->TJ_ORDEM
	@Prow()  , 010 psay StoD(_aOS[_x][2]) //STOD(TRA1->TJ_DTORIGI) Picture "99/99/9999" 
	@Prow()  , 023 psay _aOS[_x][3] //TRA1->TJ_CODBEM
	@Prow()  , 035 psay _aOS[_x][4] //TRA1->T9_NOME
	@Prow()  , 085 psay _aOS[_x][5] //TRA1->TJ_CCUSTO
	@Prow()  , 109 psay _aOS[_x][7] //TRA1->TJ_CENTRAB
    
	//Imprime o campo MEMO de STJ
	DbSelectArea("STJ")
	Dbgoto(_aOS[_x][6])//TRA1->TJ_RECNO
	       
	//conta os caracteres do campo memo
	nLinha := MlCount(Alltrim(STJ->TJ_OBSERVA)) //TJ_OBSERVA

    if Empty(STJ->TJ_OBSERVA)
       	@ Prow()+1 , 034 Psay "DEFEITO.:  - - - "
    EndIf 

	//imprime o campo memo em linhas de 70 caracteres
	for x := 1 to nLinha

		If Prow() > 65 
			_nPag  := _nPag + 1   
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	  	Endif
	
    	if x==1
     		@ Prow()+1 , 034 Psay "DEFEITO.:"
            @ Prow()   , 050 Psay MemoLine(STJ->TJ_OBSERVA,70,x)
       	else
            @ Prow()+1 , 050 Psay MemoLine(STJ->TJ_OBSERVA ,70,x)
        endif
 	next 

	_cOS  := _aOs[_x][1]
	_cSC  := ""
	_cPed := "" 
	_cStatus := .T.
 			
	While _x <= Len(_aOs) .and. _aOs[_x][1] == _cOS

		//Imprime as SC's da O.S.
		If _aOs[_x][16] == "S"
			If Prow() > 65 
				_nPag  := _nPag + 1   
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	  		Endif
	  		If _cSC <> _aOs[_x][10]
  				@ prow()+2,034 PSAY "S.C.: "+ _aOs[_x][10]
				_cSC := _aOs[_x][10]
			EndIf
			@ prow()+1,034 PSAY "PRODUTO: "+ALLTRIM(_aOs[_x][12]) +" - "
			@ prow()  ,057 PSAY SUBSTR(_aOs[_x][13],1,30)
				//verifica se a SC jแ estแ finalizada
			If (_aOs[_x][17] == "R")
				@ prow()  ,088 PSAY "(REJEITADA)"
			Else
				If (_aOs[_x][17] == "L")
					@ prow()  ,088 PSAY "(OK)"
				Else
					_cStatus := .F.
				EndIf
			EndIf				
		
			@ prow()+1,050 PSAY "QTDE: "+TRANSFORM(_aOs[_x][14],"@E 999999")
			@ prow()  ,065 PSAY "ENTREGUE: "+TRANSFORM(_aOs[_x][15],"@E 999999")

		EndIf
		
		//Imprime os Pedidos da O.S.  
		If _aOs[_x][16] == "P"
			If Prow() > 65 
				_nPag  := _nPag + 1   
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	  		Endif
	  		If _cPed <> _aOs[_x][10]
  				@ prow()+2,034 PSAY "PEDIDO: "+ _aOs[_x][10]
				_cPed := _aOs[_x][10]
			EndIf
			@ prow()+1,034 PSAY "PRODUTO: "+ALLTRIM(_aOs[_x][12]) +" - "
			@ prow()  ,057 PSAY SUBSTR(_aOs[_x][13],1,30)
				//verifica se a SC jแ estแ finalizada
			If (_aOs[_x][17] == "L")
				@ prow()  ,088 PSAY "(OK)"
			Else
				_cStatus := .F.
			EndIf				
		
			@ prow()+1,050 PSAY "QTDE: "+TRANSFORM(_aOs[_x][14],"@E 999999")
			@ prow()  ,065 PSAY "ENTREGUE: "+TRANSFORM(_aOs[_x][15],"@E 999999")

		EndIf

		_x++
	
	EndDo

  	//Imprime o status para execu็ใo da O.S.	
	If _cStatus 
		@ prow()  ,125 PSAY "PRONTA"
	Else
		@ prow()  ,125 PSAY "PENDENTE"
	EndIf 
	
	_cStatus := .T.

	@ prow()+1,000 PSAY __PrtThinLine()        
enddo
TRA1->(DbCloseArea())          

Return(nil)