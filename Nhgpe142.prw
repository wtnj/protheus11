/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE142  ºAutor  ³Marcos R Roquitski  º Data ³  16/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conferencia Adiantamento de Salario.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhgpe142()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "M"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Conferencia Adiantamento Salarial"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE142"
cPerg     := "GPE105"
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 
aOrdem    := { 'Matricula','Centro de Custo','Nome' }


If !Pergunte(cPerg,.T.) //ativa os parametros
	Return(nil)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHGPE142"

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrdem,,tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->RA_MAT)
   MsgBox("Nenhum Ocorrencia ","Atençao","ALERT")  
   DbSelectArea("TMP")
   DbCloseArea("TMP")
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMP")
DbCloseArea("TMP")
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()
Local nOrdem := aReturn[8]
Local _cZemp := Space(01)

	cQuery  := " SELECT * FROM " + RetSqlName( 'SRA' ) + " RA "
    cQuery  += " WHERE RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
    cQuery  += " AND RA.RA_CC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
    cQuery  += " AND RA.RA_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
    cQuery  += " AND RA.RA_SITFOLH <> 'D' "
    cQuery  += " AND RA.RA_CATFUNC IN ('H','M') "
    cQuery  += " AND RA.D_E_L_E_T_ = ' ' "

	
	_cZemp := mv_par05


	If Mv_par05 $ '2/3/4/5' // 2-fundicao/3-usinagem/4-forjaria/5-virabrequim
	    cQuery  += " AND RA.RA_ZEMP = '" + _cZemp + "' "

	Elseif Mv_par05 == '7'
	    cQuery  += " AND RA.RA_ZEMP IN ('2','4','5') "

	Endif


	If nOrdem == 1 // Codigo
	    cQuery  += "ORDER BY RA.RA_MAT "
			
	Elseif nOrdem == 2 // Centro de Custo
	    cQuery  += "ORDER BY RA.RA_CC "

	Elseif nOrdem == 3 // Nome              
	    cQuery  += "ORDER BY RA.RA_NOME "

	Endif

	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.
	TcSetField("TMP","RA_DTASME","D") // Muda a data de string para date.
	TcSetField("TMP","RA_NASC","D") // Muda a data de string para date.
	DbSelectArea("TMP")

Return

Static Function Imprime()
Local lRet := .t.
Local _nSalario := _nAfas := _nDif := _nRece := _nFerias := _nFaltas := _nRecno := _nExperi := _nAdt := _nDiaPro := _nFerPro := 0
Local _dDtExp, _cMat
Local _nTotadt := _nTotSal40 := nTotDif := 0
Local _nTotDif := 0
Local _dDati   := Ctod(Space(08))
Local _dDatf   := Ctod(Space(08))
Local _cTipo   := Space(01)
Local _nSalMes := 0
Local _nSal40  := 0

SR8->(DbSetOrder(1))
TMP->(Dbgotop())
Cabec1 := "Mat.      Nome                                    Admissao               Salario  40% Calculado      40% Folha      Diferenca     Observacao"
SRC->(DbSetOrder(1))                        
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While !TMP->(eof()) 

	If Prow() > 56 
		nPag := nPag + 1 
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif 

	@ Prow() + 1, 000 Psay TMP->RA_MAT 
	@ Prow()    , 010 Psay TMP->RA_NOME 

	_nSalMes := 0 
	If TMP->RA_CATFUNC = 'H'	
		_nSalMes := TMP->RA_SALARIO * TMP->RA_HRSMES 
	Else 
	    _nSalMes := TMP->RA_SALARIO 
	Endif 
	@ Prow()    ,  50 Psay TMP->RA_ADMISSA 
	@ Prow()    ,  62 Psay TMP->RA_CATFUNC 
	
	SRC->(DbSeek(xFilial("SRC")+TMP->RA_MAT)) 
	While !SRC->(Eof()) .and. SRC->RC_MAT == TMP->RA_MAT 
		If SRC->RC_PD == "442"  
			_nAdt += SRC->RC_VALOR 
		Endif	
		SRC->(DbSkip())			
	Enddo
	_nTotAdt += _nAdt

	If TMP->RA_CATFUNC = 'H'
		_nDiaMes := Day(Ultimodia(dDataBase))
		_nSalbas := (TMP->RA_SALARIO * TMP->RA_HRSMES)
        _nSalBas := ((_nSalBas * _nDiaMes)/30)
		_nSal40  := ((_nSalBas * 40) / 100)
	Else
		_nSal40 := ((TMP->RA_SALARIO * 40) / 100)
	Endif
	_nTotSal40 += _nSal40


	@ Prow()    ,  70 Psay _nSalMes Picture "@E 999,999.99"
	@ Prow()    ,  85 Psay _nAdt    Picture "@E 999,999.99"
	@ Prow()    , 100 Psay _nSal40  Picture "@E 999,999.99"

	_nDif := 0
	If _nAdt >= 0
		_nDif := (_nSal40 - _nAdt)
		_nTotDif += _nDif
		If _nDif > 0
			@ Prow()    , 115 Psay _nDif Picture "@E 999,999.99"	
			_nDif := 0
		Endif	
	Endif	
	_dDati  := Ctod(Space(08))
	_dDatf  := Ctod(Space(08))
	_cTipo  := Space(01)
	_nAdt   := 0
	_nSal40 := 0

	If Alltrim(TMP->RA_SITFOLH) == 'A'
		SR8->(Dbseek(xFilial("SR8")+TMP->RA_MAT))
		While !SR8->(Eof()) .AND. SR8->R8_MAT == TMP->RA_MAT
			_dDati := SR8->R8_DATAINI
			_dDatf := SR8->R8_DATAFIM
			_cTipo := SR8->R8_TIPO			
			SR8->(DbSkip())
		Enddo
		@ Prow()    , 130 Psay _cTipo + " "+DTOC(_dDati) + ' ate '+DTOC(_dDatf)
		_nAfas++
	Endif
 
	If Alltrim(TMP->RA_SITFOLH) == 'F' 
		SR8->(Dbseek(xFilial("SR8")+TMP->RA_MAT))
		While !SR8->(Eof()) .AND. SR8->R8_MAT == TMP->RA_MAT
			_dDati := SR8->R8_DATAINI
			_dDatf := SR8->R8_DATAFIM
			_cTipo := SR8->R8_TIPO			
			SR8->(DbSkip())
		Enddo
		@ Prow()    , 130 Psay _cTipo + " "+DTOC(_dDati) + ' ate '+DTOC(_dDatf)
		_nFerPro++
	Endif	

	If Substr(dtos(TMP->RA_ADMISSA),1,6)  == Substr(Dtos(dDataBase),1,6)
		@ Prow()    , 130 Psay 'Proporcional Admissao'
		_nDiaPro++
	Endif

	TMP->(Dbskip())

Enddo
@ Prow() + 1,00  Psay __PrtThinLine()
@ Prow() + 1,55  Psay 'TOTAL:'

@ Prow()    ,83   Psay _nTotAdt   Picture "@E 9,999,999.99"
@ Prow()    ,98   Psay _nTotSal40 Picture "@E 9,999,999.99"
@ Prow()    ,113  Psay _nTotDif   Picture "@E 9,999,999.99"

@ Prow() + 1,000 Psay __PrtThinLine()

@ Prow() + 3,001 Psay 'Afastados..................:'+Transform(_nAfas,"99999")
@ Prow() + 1,001 Psay 'Ferias.....................:'+Transform(_nFerPro,"99999")
@ Prow() + 1,001 Psay 'Proporcional Admissao......:'+Transform(_nDiaPro,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()

Return
			