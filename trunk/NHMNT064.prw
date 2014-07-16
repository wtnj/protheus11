#include 'fivewin.ch'
#include 'topconn.ch'
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT064  ºAutor ³Guilherme D. Camargo º Data ³  04/03/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE HORAS POR DISPOSITIVOS                        º±±
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


User Function NHMNT064() 

SetPrvt("_totHoras")
aCols     := {}                  
cString   := "STJ"
cDesc1    := OemToAnsi("Este relatório tem por objetivo fornecer o total de horas de OS por Dispositivo")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132                                                                         
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT064"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("HORAS DE OS POR DISPOSITIVO")                
cabec1    := OemToAnsi("  Qtd OS    Dispositivo    Letra    Descrição Dispositivo                       C. Trab     C. Custo     Descrição C. Custo                        T.Horas")    
cabec2    := " "
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHMNT064"
_cPerg    := "MNT064" 
_totHoras := 0
_nTam	  := 0

// mv_par01 -> de Dispositivo
// mv_par02 -> ate Dispositivo
// mv_par03 -> de OS
// mv_par04 -> ate OS
// mv_par05 -> Data inicio
// mv_par06 -> Data final
// mv_par09 -> de Centro de Trab
// mv_par10 -> ate Centro de Trab
// mv_par11 -> de Centro de Custo
// mv_par12 -> de Centro de Custo 
// MV_PAR13 -> DE OPERACAO
// MV_PAR14 -> ATE OPERACAO  

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)
Pergunte(_cPerg,.F.) 

IF !EMPTY(mv_par05) .AND. !EMPTY(MV_PAR06)
	titulo += " DE "+DTOC(MV_PAR05)+OEMTOANSI(" ATÉ ")+DTOC(MV_PAR06)
ENDIF

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]  

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
		
		cQuery := "SELECT ZBN_COD, ZBN_LETRA, ZBN_DESC,ZBN_CTRAB,ZBN_CC, ZBN_OP,CTT_DESC01, ZBO_HORINI, ZBO_HORFIM, ZBO_DATINI, ZBO_DATFIM, ZBO_DISP "
		cQuery += "FROM "+RetSqlName("CTT")+" CTT, "+RetSqlName("ZBN")+" ZBN "
		cQuery += "LEFT JOIN "+RetSqlName("ZBO")+" ZBO ON "
		cQuery += "     ZBO.ZBO_DISP+ZBO.ZBO_LETRA = ZBN.ZBN_COD+ZBN.ZBN_LETRA AND ZBO.D_E_L_E_T_ = ' ' AND ZBO.ZBO_FILIAL = '"+XFILIAL("ZBO")+"' AND "
		cQuery += "ZBO_ORDEM BETWEEN '"  + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "// DE OS ATE OS
		cQuery += "ZBO_DATINI BETWEEN '" + DTOC(MV_PAR05) + "' AND '" + DTOC(MV_PAR06) + "' AND "// DATA INICIAL DE/ATE
		cQuery += "ZBO_DATFIM BETWEEN '" + DTOC(MV_PAR05) + "' AND '" + DTOC(MV_PAR06) + "' "// DATA FINAL DE/ATE
		cQuery += "WHERE ZBN.D_E_L_E_T_ = ' ' AND ZBN.ZBN_FILIAL = '"+XFILIAL("ZBN")+"' AND "
		cQuery += "CTT.D_E_L_E_T_ = ' ' AND CTT.CTT_FILIAL = '"+XFILIAL("CTT")+"' AND "
		cQuery += "ZBN_CC = CTT_CUSTO AND "
		cQuery += "ZBN_COD BETWEEN '"    + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "// DE DISPOSITIVO ATE DISPOSITIVO

		cQuery += "ZBN_CTRAB BETWEEN '"  + MV_PAR09 + "' AND '" + MV_PAR10 + "' AND " 
		cQuery += "ZBN_CC BETWEEN '"     + MV_PAR11 + "' AND '" + MV_PAR12 + "' AND " 
		cQuery += "ZBN_OP BETWEEN '"     + MV_PAR13 + "' AND '" + MV_PAR14 + "' "// DE OPERAÇÃO ATE OPERAÇÃO  
		cQuery += "ORDER BY ZBN_COD"

		MemoWrit('C:\TEMP\NHMNT064.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

Return

Static Function RptDetail()  
aDisp := {}
nCont := 0
nTotOS := 0
_totHoras := 0
DbSelectArea('TRA1')              
DbGotop()
Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    
 While TRA1->( ! Eof() )
		//aDisp,{Disp, Letra, Desc, C Trab., CC, Desc do CC, Hr ini, Hr final, Dt ini, Dt final}  
	If LEN(aDisp)>0
		If TRA1->ZBN_COD == aDisp[1][1] .AND. TRA1->ZBN_LETRA == aDisp[1][2] .AND. TRA1->ZBO_DISP <> NIL
			nCont++
			aDisp[1][7] += ((CTOD(TRA1->ZBO_DATFIM) - CTOD(TRA1->ZBO_DATINI)+1)*24) + (24-(fHoraToInt(TRA1->ZBO_HORFIM) - (fHoraToInt(TRA1->ZBO_HORINI))))
		Else
			If Prow() > 60
				Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
			Endif
			@ Prow()+1 , 004 Psay Iif(aDisp[1][7]==0,0,nCont) Picture '@E 9999'//Qtde OS
			@ Prow()   , 012 Psay aDisp[1][1] //Cod. Dispositivo
			@ Prow()   , 029 Psay OemToAnsi(ALLTRIM(aDisp[1][2])) // Letra Dispositivo
			@ Prow()   , 036 Psay OemToansi(SUBSTR(aDisp[1][3],1,40)) //Desc. Dispositivo
		    @ Prow()   , 080 Psay aDisp[1][4] //centrab
			@ Prow()   , 092 Psay aDisp[1][5] //ccusto       
			@ Prow()   , 105 Psay Substr(aDisp[1][6],1,40)//Desc. CC
			@ Prow()   , 147 Psay Iif(aDisp[1][7]==0, '  00:00',IntToHora(aDisp[1][7],4)) //_nHpr Qtde Horas
			_totHoras += aDisp[1][7]
			nTotOS += Iif(aDisp[1][7]==0,0,nCont)
			//nTotOS += nCont
			aDisp[1][7] := 0
    		aDisp := {}
    		nCont := 1
    		aAdd(aDisp,{TRA1->ZBN_COD, TRA1->ZBN_LETRA, TRA1->ZBN_DESC, TRA1->ZBN_CTRAB, TRA1->ZBN_CC, TRA1->CTT_DESC01, ;
  				Iif(Empty(TRA1->ZBO_DISP), 0,((CTOD(TRA1->ZBO_DATFIM) - CTOD(TRA1->ZBO_DATINI)+1)*24) + (24-(fHoraToInt(TRA1->ZBO_HORFIM) - (fHoraToInt(TRA1->ZBO_HORINI)))))})
    	Endif
  	Else
  		nCont := 1
  		aAdd(aDisp,{TRA1->ZBN_COD, TRA1->ZBN_LETRA, TRA1->ZBN_DESC, TRA1->ZBN_CTRAB, TRA1->ZBN_CC, TRA1->CTT_DESC01, ;
  			Iif(Empty(TRA1->ZBO_DISP), 0,((CTOD(TRA1->ZBO_DATFIM) - CTOD(TRA1->ZBO_DATINI)+1)*24) + (24-(fHoraToInt(TRA1->ZBO_HORFIM) - (fHoraToInt(TRA1->ZBO_HORINI)))))})
  	EndIf
    TRA1->(DbSkip())
end 

@ Prow()+1,000 PSAY __PrtThinLine()
@ Prow()+1,003 Psay 'TOTAL OS : '
@ Prow()  ,017 Psay nTotOS
@ Prow()  ,126 Psay "Total de Horas : "
//_nTam := Len(Alltrim(Str(Int(_totHoras))))
@ Prow()  ,145 Psay IntToHora(_totHoras,5)
Return(nil)

//--------------------------------------------------//   
//* FUNCAO QUE TRANSFORMA A HORA(STRING) EM INTEIRO*//
//* AUTOR: JOAO FELIPE DA ROSA                     *//
//--------------------------------------------------//


Static Function fHoraToInt(_cHora)
Local _nHora := 0 
Local _nHr
Local _nMn
	For i:=1 to Len(_cHora)
		If substr(_cHora,i,1) == ":"          // se encontrar ":"
			_nHr := Val(substr(_cHora,1,i))   // atribui a uma variavel o que vem antes de ":" convertido em int
			_nMn := Val(substr(_cHora,i+1,2)) // atribui a outra variavel o que vem depois de ":" convertido em int
			_nHora := ((_nHr*60)+_nMn)/60     // Soma a hora e minutos  
			exit
		EndIf
	Next
Return(_nHora)

Static Function IntToHora(nHora,nDigitos)

Local nHoras    := 0 
Local nMinutos  := 0 
Local cHora     := ""             
Local lNegativo := .F.

lNegativo := ( nHora < 0 ) 

nHora     := ABS( nHora ) 

nHoras    := Int(nHora)
nMinutos  := (nHora-nHoras)*60
                                                                                                                                 
nDigitos := Iif( ValType( nDigitos )=="N", nDigitos, 2 )// - If( lNegativo, 1, 0 ) 

cHora := If( lNegativo, "-", "" ) + StrZero( nHoras, nDigitos )+":"+StrZero( nMinutos, 2 )

Return(cHora)

*/