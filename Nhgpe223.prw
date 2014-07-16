/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Nhgpe223  ºAutor  ³Marcos R. Roquitski º Data ³  25/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recalcula INSS empresa na Rescisao SRR.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function NhGpe223()

SetPrvt("_nPerc,_aStruct,_cTr1,lEnd,cSrr") 

cSrr     := "TMP_SRR"
lEnd     := .T.
_cMat    := Space(06)
_nPerc   := 0.00

If !Pergunte("NHGPE223",.T.) 
	Return 
Endif

_nPerc := MV_PAR01

SRR->(DbSetOrder(1))

If MsgBox("Confirma processamento % INSS Empresa: "+TRANSFORM(_nPerc,'@E 999.99'),"Desoneracao","YESNO")

	Processa( {|| abreSrr(cSrr) },"Gerando Dados SRR.......") 

	DbSelectArea(cSrr) 
	(cSrr)->(dbgotop())

	While (cSrr)->(!eof())

		_cMat     := (cSrr)->RR_MAT
		_dData    := (cSrr)->RR_DATA
		_cCc      := (cSrr)->RR_CC
		_dDatapag := (cSrr)->RR_DATAPAG
		_nBase    := 0

		While (cSrr)->(!eof()) .and. (cSrr)->RR_MAT == _cMat
			if 	(cSrr)->RR_PD $ '715/716/718/719'
				_nBase  += (cSrr)->RR_VALOR
			Endif		
			(cSrr)->(DbSkip())		
		Enddo

		If _nBase > 0
		
			If !SRR->(DbSeek(xFilial("SRR") +  _cMat + 'R' + _dData + '778' + _cCc))

				// Movimento mensal - Provento
				DbSelectArea("SRR")
				RecLock("SRR",.T.)
				SRR->RR_FILIAL  := xFilial("SRR")
				SRR->RR_MAT     := _cMat
				SRR->RR_PD      := "778"
				SRR->RR_TIPO1   := "V"
				SRR->RR_HORAS   := 0
				SRR->RR_VALOR   := ((_nBase * 20 /100) * _nPerc / 100)
				SRR->RR_DATA    := Ctod( Substr(_dData,7,8) + '/' + Substr(_dData,5,2) + '/' + Substr(_dData,1,4) )
				SRR->RR_CC      := _cCc
				SRR->RR_TIPO2   := "R" 
				SRR->RR_TIPO3   := "R"		
				SRR->RR_DATAPAG := Ctod( Substr(_dDatapag,7,8) + '/' + Substr(_dDatapag,5,2) + '/' + Substr(_dDatapag,1,4) ) // _dDatapag
				MsUnlock("SRR")
			Endif	
		Endif	

	Enddo
	
	dbSelectArea(cSrr)
	dbCloseArea()

Endif

Return


// 
static Function abreSrr(cSrr)
Local _cMesi,_cMesf
Local _dUdm, _cAno, _cMes, _cDia

_cDia  := "01"
_cAno  := Substr(Dtos(dDataBase),1,4)
_cMes  := Substr(Dtos(dDataBase),5,2)
_dUdm  := UltimoDia( Ctod(_cDia+"/"+_cMes+"/"+_cAno) )
_cMesi := Substr(Dtos(dDataBase),1,6) + '01' // aaaammdd
_cMesf := Dtos(_dUdm)

//--Fecha Alias Temporario se estiver aberto
If Select(cSrr) > 0
	dbSelectArea(cSrr)
	dbCloseArea()
Endif

//--Consulta as Previsões de venda
beginSql Alias cSrr
	select SRR.RR_MAT,
	       SRR.RR_PD,
	       SRR.RR_VALOR,
		   SRR.RR_DATA,
		   SRR.RR_DATAPAG,
		   SRR.RR_CC
	from 
		%table:SRR% SRR
	where              
	SRR.RR_FILIAL = %xFilial:SRR%
	and %notDel%
	and SRR.RR_TIPO3 = 'R'
	and SRR.RR_PD IN ('715','716','718','719')
	and SRR.RR_DATA BETWEEN %Exp:_cMesi% AND %Exp:_cMesf%
	order by SRR.RR_MAT

endSql

Return 
