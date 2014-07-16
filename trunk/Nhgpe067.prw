/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE067  ºAutor  ³Marcos R Roquitski  º Data ³  11/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de dependentes por C.Custo.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "topconn.ch"

User Function Nhgpe067()

SetPrvt("cSavCur1,cabec1,nOrdem,tamanho,limite,aReturn,nLastKey,cRodaTxt,nCntImpr,titulo,cDesc1")
SetPrvt("cDesc2,cDesc3,cString,nTipo,m_pag,nomeprog,cPerg")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1    := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "P"
limite    := 132
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Assistencia Medica (Rateio por CC)"
Cabec1    := "CC     Descricao                Apartamento       Enfermaria          TOTAL"
Cabec2    := "                              Titular  Depend   Titular  Depend   Titular Depend
cDesc1    := ""
cDesc2    := ""
cDesc3    := ""
cString   := "SRA"
nTipo     := 0
_nPag     := 1
nomeprog  := "NHGPE067"
cPerg     := "GPE067"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('GPE067',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE067"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

Processa({|| Gerando() },"Criando Arquivo Temporario")

RptStatus({|| fGeraRel()})

Return

Static Function fGeraRel()
Local _lRet := .F., _cCC := Space(06),_nLin := 0, _lRet := .T., _cCc := Space(06), _cNomecc
Local _nApTit := 0, _nApDep := 0, _nEnTit := 0, _nEnDep := 0, _nGeTit := 0, _nGeDep := 0
DbSelectArea("SRB")
DbSetOrder(1)

DbSelectArea("TMP")
TMP->(DbGoTop())
TMP->(SetRegua(RecCount()))
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())

	IncRegua()

	If Prow() > 64
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif


	If _lRet
		SI3->(DbSeek(TMP->RA_FILIAL+TMP->RA_CC))
		If SI3->(Found())
			_cNomecc := Substring(SI3->I3_DESC,1,20)
		Endif
		@ prow()+001,000 psay Substring(TMP->RA_CC,1,6)+" "+ _cNomecc
		_cNomecc := Space(20)
		_lRet := .F.
	Endif
			
	If TMP->RA_ASMEDIC == '01'
		_nApTit++
	Elseif TMP->RA_ASMEDIC == '02'
		_nEnTit++
	Endif

	//_nLin := 0
	SRB->(DbSeek(TMP->RA_FILIAL+TMP->RA_MAT,.T.))
	While SRB->(! Eof()) .and. TMP->RA_FILIAL==SRB->RB_FILIAL .and. TMP->RA_MAT==SRB->RB_MAT
		If !Empty(SRB->RB_ASMEDIC)
			If SRB->RB_ASMEDIC == '01'
				_nApDep++
			Elseif SRB->RB_ASMEDIC == '02'
				_nEnDep++
			Endif
		Endif
		SRB->(DbSkip())
	Enddo

	_cCc := TMP->RA_CC
	TMP->(DbSkip())
	If TMP->RA_CC <> _cCc .OR. TMP->(Eof())
		@ Prow()   ,030 Psay Transform(_nApTit,"9999")
		@ Prow()   ,040 Psay Transform(_nApDep,"9999")
		@ Prow()   ,048 Psay Transform(_nEnTit,"9999")
		@ Prow()   ,057 Psay Transform(_nEnDep,"9999")
		@ Prow()   ,066 Psay Transform(_nApTit+_nEnTit,"9999")
		@ Prow()   ,074 Psay Transform(_nApDep+_nEnDep,"9999")
		_nGeTit += _nApTit + _nEnTit
		_nGeDep += _nApDep + _nEnDep
		_nApTit := _nEnTit := _nApDep := _nEnDep := 0
		_lRet := .T.
		@ Prow()+02,001 Psay __PrtThinLine() 
	Endif

Enddo
@ Prow()+02,001 Psay __PrtThinLine() 
@ prow()+01,001 Psay "TOTAL: "
@ Prow()   ,066 Psay Transform(_nGeTit,"9999")
@ Prow()   ,074 Psay Transform(_nGeDep,"9999")
@ Prow()+02,001 Psay __PrtThinLine() 


If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

DbSelectArea("TMP")
DbCloseArea("TMP")

Return

Static Function Gerando()
	LOCAL nTotReg := 0

	cQuery := "SELECT * FROM " + RetSqlName( 'SRA' ) +" SRA "
	cQuery := cQuery + " WHERE RA_SITFOLH <> 'D' " 
	cQuery := cQuery + " AND RA_CC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery := cQuery + " AND RA_SITFOLH <> 'T' " 
    cQuery := cQuery + " AND D_E_L_E_T_ = ' ' "
    cQuery := cQuery + " ORDER BY RA_CC "
    
   //Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  

Return
