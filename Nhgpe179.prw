/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE179  ºAutor  ³Marcos R. Roquitski º Data ³  26/01/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera valores das verbas.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe179()

SetPrvt("_cTipo, _cOrigem, _lSai, _aStruct, _cTr1, _cSituacao, lEnd, cSrc")

If !Pergunte('NHGPE179',.T.)
   Return(nil)
Endif

lEnd      := .T.
cSrc      := "TMP_SRC"

DbSelectArea("SRA")
DbSetorder(1)

If MsgYesNo("Confirma atualizacao no movimento mensal SRC ?","Movimento mensal")
	Processa( {||  SrcGpe179(cSrc) },"Atualizando tabela SRC")
Endif

Return   


//
Static Function fAltSrc()
Local _nSalMs := 0

DbSelectArea(cSrc)
(cSrc)->(dbgotop())

If Mv_par05 == 1
	_cEmpr := '3'
Elseif mv_par05 == 2	
	_cEmpr := '2/4/5/6'
Endif
	 

While (cSrc)->(!eof())
     
	* Grava no movimento mensal Desconto
	SRC->(DbSeek(xFilial("SRC") + (cSrc)->RC_MAT,.T.))
	While !SRC->(Eof())	.AND. SRC->RC_MAT == (cSrc)->RA_MAT


		If (cSrc)->RA_ZEMP == _cEmpr // Usinagem

			If SRC->RC_PD==mv_par06
				RecLock("SRC",.F.)
				SRC->RC_VALOR := MV_PAR07          
				MsUnLock("SRC")
			Endif
			
		Endif
		
		If (cSrc)->RA_ZEMP $ _cEmpr // Fundicao/Vira/Forjaria

			If (cSrc)->RA_CATFUNC == 'H'
				_nSalMs := (cSrc)->RA_SALARIO * 200
			Else
				_nSalMs := (cSrc)->RA_SALARIO
			Endif
			
			If _nSalMs <= 3127.00

				If SRC->RC_PD==mv_par06
					RecLock("SRC",.F.)
					SRC->RC_VALOR := MV_PAR07          
					MsUnLock("SRC")
				Endif
			Endif	
			
		Endif
	
		SRC->(DbSkip())

	Enddo		

	(cSrc)->(DbSkip())

Enddo

Return



Static Function SrcGpe179(cSrc)
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
		   SRA.RA_MAT,	
	       SRA.RA_ZEMP,
	       SRA.RA_CATFUNC,
	       SRA.RA_SALARIO
	from 
		%table:SRC% SRC
	inner join
			%table:SRA% SRA
	on
		SRA.RA_FILIAL  = %xFilial:SRA%					
	and SRC.RC_MAT     = SRA.RA_MAT
	and SRA.RA_DEMISSA = ' '          
	and SRA.D_E_L_E_T_ = ' '        
	and SRA.RA_CC   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	and SRA.RA_MAT  BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%

	where              
		SRC.RC_FILIAL  = %xFilial:SRC%
	and SRC.RC_PD      = %Exp:mv_par06% 	
	and SRC.D_E_L_E_T_ = ' '		
	order by
		SRC.RC_MAT
endSql

Processa( {|| fAltSrc() },"Gravando...") 

Return 
