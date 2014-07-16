#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHMNT018  บAutor ณJoใo Felipe         บ Data ณ  18/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de atraso de OS                                  บฑฑ
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

User Function NHMNT018()   

aCols	:= {}                  
Agrupo 	:= {}
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("os motivos de atrasos de OS e os totais em horas")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT018"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATำRIO DE ATRASO DE O.S.")                
cabec1    := " Motivo                                   Qtd.Horas           Qtd. "
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT018"
_cPerg    := "MNT018" 
_nTotal   := 0  
_totalgeral := 0  
_totalcc := 0
 
// mv_par01 data inicial
// mv_par02 data final
// mv_par03 servico inicial
// mv_par04 servico final
// mv_par05 bem inicial
// mv_par06 bem final
// mv_par07 centrab inicial
// mv_par08 centrab final
// mv_par09 cc inicial
// mv_par10 cc final


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

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool
DbCloseArea("TMP")     
Return

Static Function ItoHora(nHora,nDigitos)
	Local nHoras    := 0 
	Local nMinutos  := 0 
	Local cHora     := ""             
	Local lNegativo := .F.
	lNegativo := ( nHora < 0 ) 
	nHora     := ABS( nHora ) 
	nHoras    := Int(nHora)
	nMinutos  := (nHora-nHoras)*60
	nDigitos := If( ValType( nDigitos )=="N", nDigitos, 2 ) - If( lNegativo, 1, 0 ) 
	cHora := If( lNegativo, "-", "" ) + StrZero( nHoras, nDigitos )+":"+StrZero( nMinutos, 2 )
Return(cHora)

Static Function Gerando()
Local cQuery
Local _cDesc
Local _nDias
Local _nHoraini
Local _nHorafim
Local _nHoras
Local _nTHora := 0
Local _nTotal //soma dos motivos de atraso de os.
Local _nTMot := 0
Local _nTHr := 0

//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------		


cQuery := " SELECT TPJ.TPJ_DESMOT, TPL.TPL_HOINIC, TPL.TPL_HOFIM, TPL.TPL_DTINIC, TPL.TPL_DTFIM "
cQuery += " FROM "+RetSqlNAme("TPL")+ " TPL, " +RetSqlName("TPJ")+ " TPJ, " +RetSqlName("STJ")+ " TJ "
cQuery += " WHERE TPL.TPL_CODMOT = TPJ.TPJ_CODMOT"
cQuery += " AND TPL.TPL_DTINIC BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"'"
cQuery += " AND TPL.TPL_DTFIM BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"'"
cQuery += " AND TJ.TJ_ORDEM = TPL.TPL_ORDEM"
cQuery += " AND TJ.TJ_SERVICO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery += " AND TJ.TJ_CENTRAB BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQuery += " AND TJ.TJ_CCUSTO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
cQuery += " AND TPL.D_E_L_E_T_ <> '*'"
cQuery += " AND TPJ.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY TPJ.TPJ_DESMOT"
                      
MemoWrit('C:\TEMP\NHMNT017.SQL',cQuery)
TCQUERY cQuery NEW ALIAS 'TMP'

TcSetField("TMP","TPL_DTINIC","D") // TRANSFORMA DE STRING PARA DATA
TcSetField("TMP","TPL_DTFIM","D")  // TRANSFORMA DE STRING PARA DATA	             

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

TMP->(DbGotop())     

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

_cDesc := TMP->TPJ_DESMOT
_nTotal := 0

While TMP->(!Eof()) 

  	If Prow() > 65
	   	_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
	Endif  

	@Prow()+1, 001 psay TMP->TPJ_DESMOT
   
    while _cDesc == TMP->TPJ_DESMOT
	    _nDias    := TMP->TPL_DTFIM - TMP->TPL_DTINIC
 	   	_nHoraini := HoraToInt(TMP->TPL_HOINIC)
 		_nHorafim := HoraToInt(TMP->TPL_HOFIM)
		_nHoras   := _NHorafim - _NHoraini
		_nTHora   += (_nHoras+(_nDias*24))    	
		_nTotal++
		TMP->(dbskip())
	enddo
	
	@Prow()  , 044 psay Transform(_nTHora,"@e 99999.99")
	@Prow()  , 060 psay Transform(_nTotal,"@e 99999")
	
	_cDesc  := TMP->TPJ_DESMOT
	_nTHr   += _nTHora
	_nTMot  += _nTotal 
	_nTHora := 0
	_nTotal := 0
	
enddo
@ Prow()+1,000 PSAY __PrtThinLine()
@ Prow()+1, 038 psay Transform(_nTHr,"@e 999,999.99")
@ Prow()  , 058 psay Transform(_nTMot,"@e 9999999")

TMP->(DbCloseArea())          

Return(nil)