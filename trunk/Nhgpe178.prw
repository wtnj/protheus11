/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE178  ºAutor  ³Marcos R. Roquitski º Data ³  18/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa CTT para SI3.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe178()

SetPrvt("_cTipo, _cOrigem, _lSai, _aStruct, _cTr1, _cSituacao, lEnd")

_cOrigem  := Space(50)

//AjustaSX1()

lEnd      := .T.


DbSelectArea("CTT")
DbSetorder(1)

If MsgYesNo("Confirma Importar CTT para QAD","Importa CTT -> QAD")
   MsAguarde ( {|lEnd| fCalcPpr() },"Aguarde","Importando",.T.)
Endif

Return   


Static Function abreLanc(cSrc)
Local _cZempde  := StrZero(mv_par05,1)
Local _cZempAte := StrZero(mv_par05,1)

If mv_par05 == 3
	_cZempde  := ' '
	_cZempAte := 'Z'
Endif	

//--Fecha Alias Temporario se estiver aberto
If Select(cSrc) > 0
	dbSelectArea(cSrc)
	dbCloseArea()
Endif

//--Consulta as Previsões de venda
beginSql Alias cSrc
	select SRC.RC_MAT,
	       SRA.RA_NOME,
	       SRA.RA_CC,
	       SRA.RA_DEMISSA,
	       SRC.RC_PD,
	       SRA.RA_ZEMP
	from 
		%table:SRC% SRC
	inner join
			%table:SRA% SRA
	on
		SRA.RA_FILIAL  = %xFilial:SRA%					
	and SRD.RC_MAT     = SRA.RA_MAT
	and SRA.RA_DEMISSA = ' '          
	and SRA.D_E_L_E_T_ = ' '        
	and SRA.RC_PD      = %Exp:mv_par06% 	
	and SRA.RA_CC   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	and SRA.RA_MAT  BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
	and SRA.RA_ZEMP BETWEEN %Exp:_cZempde% AND %Exp:_cZempAte%

	where              
		SRC.RC_FILIAL  = %xFilial:SRC%
	and SRC.D_E_L_E_T_ = ' '		
	order by
		SRC.RC_MAT
endSql

Processa( {|| RptTmp() },"Imprimindo...") 

Return 




Static Function fCalcPpr()

QAD->(DbSetOrder(1))      	
DbSelectArea("CTT")
CTT->(DbgoTop())
While !CTT->(Eof())

	If !QAD->(DbSeek(xFilial("QAD")+CTT->CTT_CUSTO))
    
		RecLock("QAD",.T.)
		QAD->QAD_FILIAL  := CTT->CTT_FILIAL
		QAD->QAD_CUSTO   := CTT->CTT_CUSTO
		QAD->QAD_DESC    := CTT->CTT_DESC01
		QAD->QAD_STATUS  := '1'
		QAD->QAD_FILMAT  := CTT->CTT_FILIAL
		MsUnLock("QAD")

    Endif
    CTT->(DbSkip())
	
Enddo

Return
