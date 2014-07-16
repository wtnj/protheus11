/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE107  ºAutor  ³Marcos R Roquitski  º Data ³  10/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Declaracao de Assalariado.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe107()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO,_nSalm2")
SetPrvt("M_PAG,NOMEPROG,CPERG,_nAno,_nMes,_cAnoMes,_aDados")
SetPrvt("_nSalf2,_nSale2,_nSalo2,_nSalm1,_aExtras")

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "P"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Declaracao de Assalariado" 
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "NHGPE107"
cPerg    := 'RHGP07'
_nMes    := 0
_nAno    := 0
_cAnoMes := Space(06)
_aDados  := {}
_aExtras := {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('RHGP07',.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "nhgpe107"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| fDeclara()})

Return Nil



Static Function fDeclara()
Local _cDescf := Space(20)
Local i

DbSelectArea("SRA")
DbSetOrder(01)
SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))
SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT>=mv_par03 .and. SRA->RA_MAT<=mv_par04

	_cDescf := Space(20)
	SRJ->(DbSeek(xFilial("SRJ"+SRA->RA_CODFUNC)))
	If SRJ->(Found())
		_cDescf := SRJ->RJ_DESC
	Endif		


	IncRegua()
	//@ 7, 22 pSay "* * "+ SM0->M0_NOMECOM + " * *"
	@ 7, 22 pSay " D E C L A R A C A O     D E      A S S A L A R I A D O"

	@ pRow()+5, 01 pSay "Para fins exclusivos de comprovacoes de renda junto a  Caixa  Economica  Federal,  declaramos  sob as penas da lei que  o"
	@ pRow()+1, 01 pSay "Sr. "+SRA->RA_NOME+" ,portador(a) da Carteira de Trabalho No." + SRA->RA_NUMCP + ", Serie No. " + SRA->RA_SERCP + "e funcionario"
	@ pRow()+1, 01 pSay "desta empresa desde "+Dtoc(SRA->RA_ADMISSA)+" ,encontra-se registrado(o) sob o No. "+SRA->RA_MAT+" na funcao de "+_cDescf
	@ pRow()+1, 01 pSay "com  contrato  de  trabalho  sob  o  regime, CLT  pelo  prazo  INDETERMINADO,  nao  esta  sob  o  Aviso Previo em periodo"
	@ pRow()+1, 01 pSay "experimental ou estagio probatorio e percebendo a renumeracao mensal conforme  abaixo discriminado. Outrossim  informamos"
	@ pRow()+1, 01 pSay "que a data base do dissidio e no mes de DEZEMBRO, e o mesmo esta lotado na cidade de Curitiba estado Parana, pais Brasil."


	@ pRow()+5, 01 pSay "Salario Base: "

	@ pRow()+2, 01 pSay Substr(Dtos(dDataBase),5,2)+"/"+Substr(Dtos(dDataBase),1,4)

	fSalm1()
	@ pRow()+1, 20 pSay "Salario Base    "+Transform(_nSalm1,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Salario-familia "+Transform(_nSalf2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Adic.+H.Extras  "+Transform(_nSale2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Ferias          "+Transform(_nSalo2,"@E 999,999,999.99")

	fSalm2()
	@ pRow()+1, 01 pSay Substr(_cAnoMes,5,2)+"/"+Substr(_cAnoMes,1,4)
	@ pRow()+1, 20 pSay "Salario Base    "+Transform(_nSalm2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Salario-familia "+Transform(_nSalf2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Adic.+H.Extras  "+Transform(_nSale2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Ferias          "+Transform(_nSalo2,"@E 999,999,999.99")

	fSalm2()
	@ pRow()+3, 01 pSay Substr(_cAnoMes,5,2)+"/"+Substr(_cAnoMes,1,4)
	@ pRow()+1, 20 pSay "Salario Base    "+Transform(_nSalm2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Salario familia "+Transform(_nSalf2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Adic.+H.Extras  "+Transform(_nSale2,"@E 999,999,999.99")
	@ pRow()+1, 20 pSay "Ferias          "+Transform(_nSalo2,"@E 999,999,999.99")

	@ pRow()+1, 02 pSay "Descriminacao da horas extras/comissoes recebidas nos ultimos 6 meses:
	@ pRow()+2, 02 pSay ""
	fSalm2()
	fSalm2()
	fSalm2()
	For i := 1 to Len(_aExtras)
		@ pRow()+1, 01 pSay _aExtras[i,1]
		@ pRow()  , 20 pSay _aExtras[i,2] Picture "@E 999,999,999.99"
	Next
  
	SRA->(DbSkip())

Enddo
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel)
Endif
MS_FLUSH()

Return


Static Function fSalm1()

_nSalm1  := 0
_nAno    := Val(Substr(Dtos(dDataBase),1,4))
_nMes    := Val(Substr(Dtos(dDataBase),5,2))
_cAnoMes := StrZero(_nAno,4)+StrZero(_nMes,2)
_nSalf2  := 0
_nSale2  := 0
_nSalo2  := 0


	SRC->(DbSeek(xFilial("SRC")+SRA->RA_MAT))
	While !SRC->(Eof()) .AND. SRC->RC_MAT == SRA->RA_MAT
		If SRC->RC_PD $ '101/102/103/128/130' // Salario-Base
			_nSalm1 += SRC->RC_VALOR
		Endif

		If SRC->RC_PD $ '124' // Salario-familia
			_nSalf2 += SRC->RC_VALOR
		Endif
	
		If SRC->RC_PD $ '105/107/110/111/113/116/122/141/143/145/147' // Adicional Noturno + Horas extras
			_nSale2 += SRC->RC_VALOR
		Endif

		If SRC->RC_PD $ '160/162/164/168/170' // Ferias
			_nSalo2 += SRC->RC_VALOR
		Endif

		SRC->(DbSkip())
	Enddo


	If _nSalm1 <= 0

		_nSalm1  := 0
		_nSalf2  := 0
		_nSale2  := 0
		_nSalo2  := 0

		SRD->(DbSeek(xFilial("SRD")+SRA->RA_MAT+_cAnoMes))
		While !SRD->(Eof()) .AND. SRD->RD_MAT == SRA->RA_MAT .AND. SRD->RD_DATARQ == _cAnoMes
			If SRD->RD_PD $ '101/102/103/128/130'
				_nSalm1 += SRC->RC_VALOR
			Endif

			If SRD->RD_PD $ '124'
				_nSalf2 += SRD->RD_VALOR
			Endif
	
			If SRD->RD_PD $ '105/107/110/111/113/116/122/141/143/145/147'
				_nSale2 += SRD->RD_VALOR
			Endif

			If SRD->RD_PD $ '160/162/164/168/170'
				_nSalo2 += SRD->RD_VALOR
			Endif

			SRD->(DbSkip())
		Enddo
	Endif

	If _nSalm1 <= 0
		_nSalm1 := SRA->RA_SALARIO
		If SRA->RA_CATFUNC == 'H'
			_nSalm1 := SRA->RA_HRSMES * SRA->RA_SALARIO
		Endif
	Endif

	AADD(_aExtras,{_cAnoMes,_nSale2})
Return


Static Function fSalm2()
_nSalm2 := 0
_nSalf2 := 0
_nSale2 := 0
_nSalo2 := 0

If _nMes == 1
	_nAno := _nAno  - 1
	_nMes := 12
Else
	_nMes := _nMes - 1
Endif
_cAnoMes := StrZero(_nAno,4)+StrZero(_nMes,2)

SRD->(DbSeek(xFilial("SRD")+SRA->RA_MAT+_cAnoMes))
While !SRD->(Eof()) .AND. SRD->RD_MAT == SRA->RA_MAT  .AND. SRD->RD_DATARQ == _cAnoMes
	If SRD->RD_PD $ '101/102/103/128/130'
		_nSalm2 += SRD->RD_VALOR
	Endif

	If SRD->RD_PD $ '124'
		_nSalf2 += SRD->RD_VALOR
	Endif
	
	If SRD->RD_PD $ '105/107/110/111/113/116/122/141/143/145/147'
		_nSale2 += SRD->RD_VALOR
	Endif

	If SRD->RD_PD $ '160/162/164/168/170'
		_nSalo2 += SRD->RD_VALOR
	Endif
	
	SRD->(DbSkip())
Enddo
AADD(_aExtras,{_cAnoMes,_nSale2})
Return

