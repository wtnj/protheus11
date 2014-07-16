
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณpcp045  Autor:Jos้ Henrique M Felipetto Data ณ01/13/12      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PCP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"
#INCLUDE "protheus.ch"
#include "colors.ch"
#include "TOPCONN.CH"
#include 'COLORS.CH'
#Include "prtopdef.ch"

// Apontamento ----------------------------- ///////////////////// ----------------------- ////////////////// ------------------
User Function NHPCP045()

Local aSize       := MsAdvSize()
Local bOk         := {|| oDlg:End()}
Local bEnchoice   := {||}

Private oList1 , oList2 , oList3
Private aList1 := {}
Private aList2 := {}
Private aList3 := {}
Private nList1
Private nList2
Private nList3
Private aCab1 := {"Produto","Descri็ใo"}
Private aCab2 := {"Ord. Prod","Data","Quantidade"}
Private aCab3 := {"Opera็ใo","Codigo","Quantidade","Descri็ใo"}

fProd() //-- carrega os produtos da forjaria no list 1

bEnchoice := {|| EnchoiceBar(oDlg,bOk,{||oDlg:End()}) }

oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Produ็ใo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oList1 := TWBrowse():New(20,010,160,240,,aCab1,,oDlg,,,,{||fOPrd() },,,,,,,,.F.,,.T.,,.F.,,,)
oList1:SetArray( aList1 )
oList1:bLine := {|| {aList1[oList1:nAt,1],aList1[oList1:nAt,2] }}

oList2 := TWBrowse():New(20,180,100,240,,aCab2,,oDlg,,,, {||fQtde() },,,,,,,,.F.,,.T.,,.F.,,,)

oList3 := TWBrowse():New(20,290,250,240,,aCab3,,oDlg,,,,,{||fDet() },,,,,,,.F.,,.T.,,.F.,,,)

oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return


// --------------------------------------------------------------------------------
Static Function fProd()

cAl := getnextalias()

beginSql alias cAl
	SELECT B1_COD, B1_DESC
	FROM %Table:SB1% SB1
	WHERE B1_GRUPO = 'PA04'
	AND SUBSTRING(B1_COD,6,3) = '.1.'
	AND SB1.%NotDel%
	AND SB1.B1_FILIAL = %xFilial:SB1%
	AND SB1.B1_MSBLQL <> '1'
endSql

While (cAl)->(!eof())
	aAdd(aList1,{(cAl)->B1_COD,(cAl)->B1_DESC})
	(cAl)->(dbSkip())
Enddo

(cAl)->(dbclosearea())


Return

// --------------------------------------------------------------------------------
Static Function fOPrd()

aList2 := {}

cAl := getnextalias()

beginSql alias cAl
	SELECT C2_NUM,C2_EMISSAO,C2_QUANT
	FROM %TABLE:SC2%
	WHERE C2_PRODUTO = %Exp:aList1[oList1:nAt,1]%
	AND C2_QUJE < C2_QUANT
	AND C2_FILIAL = %xFilial:SC2%
	AND %notDel%
endSql

While (cAl)->(!eof())
	aAdd(aList2,{(cAl)->C2_NUM,DTOC(STOD((cAl)->C2_EMISSAO)),(cAl)->C2_QUANT })
	(cAl)->(dbSkip())
Enddo

(cAl)->(dbclosearea())


oList2:SetArray( aList2 )
oList2:bLine := {|| {aList2[oList2:nAt,1],aList2[oList2:nAt,2],aList2[oList2:nAt,3] }}
oList2:Refresh()

Return

// --------------------------------------------------------------------------------
Static Function fQtde()
Local cLike := aList2[oList2:nAt,1]+'%'
Local cPeca := aList1[oList1:nAt,1]
Local lAddSaldo := .f.

aList3 := {}

cAl := getnextalias()

BeginSql alias cAl
	SELECT SUM(ZEJ_QUANT) AS QUANT,ZEK_COD,ZEK_OPERA,ZEK_DESC 
	FROM %TABLE:ZEJ% ZEJ (NOLOCK)
	left join %TABLE:ZEK% ZEK (NOLOCK) ON
	ZEK.ZEK_OPERA = ZEJ.ZEJ_OPERA
	AND ZEK.ZEK_FILIAL = ZEJ.ZEJ_FILIAL
	AND ZEK.ZEK_COD = ZEJ.ZEJ_COD	
	AND ZEK_COD = %Exp:cPeca%		
	AND ZEK.%notDel%
	WHERE ZEJ.%notDel%		
	AND ZEJ_OP LIKE %Exp:cLike%
	GROUP BY ZEK_COD,ZEK_OPERA,ZEK_DESC
	ORDER BY ZEK_OPERA
EndSql	
/*
BeginSql alias cAl
	SELECT SUM(ZEJ_QUANT) AS QUANT,ZEK_COD,ZEK_OPERA,ZEK_DESC 
	FROM %TABLE:ZEJ% ZEJ, %TABLE:ZEK% ZEK
	WHERE ZEK.%notDel%
	AND ZEJ.%notDel%
	AND ZEK_COD = %Exp:cPeca%
	AND ZEK.ZEK_COD = ZEJ.ZEJ_COD
	AND ZEK.ZEK_OPERA *= ZEJ.ZEJ_OPERA
	AND ZEJ_OP LIKE %Exp:cLike%
	GROUP BY ZEK_COD,ZEK_OPERA,ZEK_DESC
	ORDER BY ZEK_OPERA
EndSql
*/

cCodPi := U_f43TEMPI(cPeca)
SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL                                                                                                                                       
If !EMPTY(cCodPI) .AND. SB2->(DbSeek(xFilial("SB2") + cCodPI + "44" ) ) // Pesquisa na tabela saldo de Produtos -- Filial  + Produto + Armazem
	aAdd(aList3,{'SALDO',cCodPi,(SB2->B2_QATU - SB2->B2_QACLASS - SB2->B2_RESERVA - SB2->B2_QTNP),'SALDO ESTOQUE PI'} )	
	lAddSaldo := .t.
EndIf
       
	//-- Verifica qual ้ a segunda operacao (Forja)
	cQuery := " SELECT MIN(ZEK_OPERA) AS SEGUNDA FROM " + RetSqlName("ZEK") + " EK "
	cQuery += " WHERE ZEK_OPERA > 10 AND ZEK_COD = '" + cPeca +"' AND EK.D_E_L_E_T_ = '' AND EK.ZEK_FILIAL = '"+xFilial("ZEK")+"'"
	                                               
	TCQUERY cQuery NEW ALIAS "TRAM"
    MemoWrit('C:\TEMP\NHPCP045.SQL',cQuery)
				
	


While (cAl)->(!Eof() ) 

	//-- DECREMENTA DO SALDO EM ESTOQUE O QUE FOI APONTADO NA OPERACAO DE FORJA
    If TRAM->SEGUNDA == (cAl)->ZEK_OPERA .and. lAddSaldo
		aList3[1][3] -= (cAl)->QUANT 
	Endif
	
	aAdd(aList3,{(cAl)->ZEK_OPERA,(cAl)->ZEK_COD,(cAl)->QUANT,(cAl)->ZEK_DESC} )
	(cAl)->(DbSkip() )
EndDo 

TRAM->(DbCloseArea() )

(cAl)->(DbCloseArea() )

If len(aList3) == 0
	aList3 := {{0,"","",""}}
Endif

oList3:SetArray( aList3 )
//  oList3:bLine := {|| {aList3[oList3:nAt,1],aList3[oList3:nAt,2],aList3[oList3:nAt,3],aList3[oList3:nAt,4] }}
oList3:bLine := {|| aEval(aList3[oList3:nAt],{|z,w| aList3[oList3:nAt,w] } ) }
oList3:Refresh()

Return

// --------------------------------------------------------------------------------
Static Function fDet()

If (ValType(alist3[oList3:nAt][1])=='C' .and. alist3[oList3:nAt][1]=='SALDO')  .OR. ;
   (Empty(aList3[oList3:nAt][1]) .and. empty(aList3[oList3:nAt][2]) .and. empty(aList3[oList3:nAt][3]))
	Return .F.
EndIf

Private nList4
Private aList4 := {}
Private aCab4 := {"Data","Hora Inicial","Tempo","Quantidade","Matrํcula","Hora"}
cAl := getNextAlias()

BeginSql alias cAl
	SELECT ZEJ_DATA,ZEJ_HINI,ZEJ_HORA,ZEJ_QUANT,ZEJ_MAT,ZEJ_TEMPO FROM ZEJFN0
	WHERE ZEJ_OPERA = %Exp:aList3[oList3:nAt,1]%
	AND ZEJ_FILIAL = %xFilial:ZEJ%
	AND %notDel%
EndSql

If (cAl)->(Eof())
	aAdd(aList4,{"","","","","",""})
Else
	While (cAl)->(!Eof() )
		aAdd(aList4,{DTOC(STOD( (cAl)->ZEJ_DATA )),(cAl)->ZEJ_HINI,(cAl)->ZEJ_TEMPO,(cAl)->ZEJ_QUANT,(cAl)->ZEJ_MAT,(cAl)->ZEJ_HORA} )
		(cAl)->(DbSkip() )
	EndDo
EndIf


(cAl)->(DbCloseArea() )
oDlgDet  := MsDialog():New(0,0,500,500,"Detalhes Produ็ใo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oList4 := TWBrowse():New(005,005,235,235,,aCab4,,oDlgDet,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oList4:SetArray( aList4 )
oList4:bLine := {|| {aList4[oList4:nAt,1],aList4[oList4:nAt,2],aList4[oList4:nAt,3],aList4[oList4:nAt,4],aList4[oList4:nAt,5],aList4[oList4:nAt,6]}}

oDlgDet:Activate(,,,.t.,{||.T.},,)

Return
// --------------------------------------------------------------------------------
