/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE051  ºAutor  ³Marcos R. Roquitski º Data ³  18/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do PPR.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe051()

SetPrvt("_SALARIO,_ABONO,_AVOS,_PERCENT,lEnd,_FALTAS,_nAntecipa")
SetPrvt("_ISENCAO,_REND1,_ALIQ1,_DEDU1,_REND2,_ALIQ2,_DEDU2,_REND3")
SetPrvt("_ALIQ3,_DEDU3,_DEPEN,_LIMIT,_RETMI,_lAchou,_BASE1,_IRPPR,_cSituacao")

AjustaSX1()
If !Pergunte('GPE051',.T.)
   Return(nil)
Endif

_cSituacao  := fSituacao( NIL , .F. )	//Situacoes


If MsgYesNo("Confirma Calculo do PPR","Calculo do PPR")
   MsAguarde ( {|lEnd| fCalcPpr() },"Aguarde","Calculando PPR",.T.)
Endif

Return   


Static Function fCalcPpr()

DbSelectArea("SRX")
DbSetorder(1)
_ISENCAO := 0.00
_REND1   := 0.00
_ALIQ1   := 0.00
_DEDU1   := 0.00
_REND2   := 0.00
_ALIQ2   := 0.00
_DEDU2   := 0.00
_REND3   := 0.00
_ALIQ3   := 0.00
_DEDU3   := 0.00
_DEPEN   := 0
_LIMIT   := 0.00
_RETMI   := 0.00
_lAchou  := .F.
_BASE1   := 0
_IRPPR   := 0
_FALTAS  := 0

SRX->(DbSeek(SRX->RX_FILIAL+"09"+Space(06)+"1"))
If SRX->(Found())
	_lAchou := .T.
Else
	SRX->(DbSeek(SRX->RX_FILIAL+"09"+Substr(Dtos(dDataBase)+"1",1,6)))
	If SRX->(Found())
		_lAchou := .T.
	Endif
Endif

If !_lAchou
	MsgBox("Tabela de IR, Nao Cadastrada","Tabelas","STOP")
	Return
Endif


If _lAchou
	_ISENCAO := Val(Substr(SRX->RX_TXT, 1,12))
	_REND1   := Val(Substr(SRX->RX_TXT,13,12))
	_ALIQ1   := Val(Substr(SRX->RX_TXT,25,5))
	_DEDU1   := Val(Substr(SRX->RX_TXT,31,12))
	_REND2   := Val(Substr(SRX->RX_TXT,43,12))

	SRX->(DbSkip())
	_ALIQ2   := Val(Substr(SRX->RX_TXT,1,6))
	_DEDU2   := Val(Substr(SRX->RX_TXT,7,12))
	_REND3   := Val(Substr(SRX->RX_TXT,19,12))
	_ALIQ3   := Val(Substr(SRX->RX_TXT,31,6))
	_DEDU3   := Val(Substr(SRX->RX_TXT,37,12))

	SRX->(DbSkip())
	_DEPEN   := Val(Substr(SRX->RX_TXT,1,12))
	_LIMIT   := Val(Substr(SRX->RX_TXT,13,2))
	_RETMI   := Val(Substr(SRX->RX_TXT,15,12))
Endif	


DbSelectArea("SRC")
DbSetorder(1)                                                     

DbSelectArea("SRA")
DbSetorder(1)
SRA->(DbSeek(SRA->RA_FILIAL+mv_par06,.T.))
While SRA->(!Eof()) .And. SRA->RA_MAT>=mv_par06 .And. SRA->RA_MAT<=mv_par07
	
   _SALARIO   := 0.00
   _ABONO     := 0.00
   _AVOS      := 12
   _PERCENT   := 100.00
   _nAntecipa := 0

   If (SRA->RA_SITFOLH $ _cSituacao)
	
		If SRA->RA_CC >= mv_par08 .And. SRA->RA_CC <= mv_par09
		
			MsProcTxt(SRA->RA_MAT + " "+Substr(SRA->RA_NOME,1,30))

	      If Year(SRA->RA_ADMISSA) >= Year(dDataBase)
   	   	If Day(SRA->RA_ADMISSA) > 15
					If Month(SRA->RA_ADMISSA) == 12
		      		_AVOS := 0
					Elseif Month(SRA->RA_ADMISSA) == 11
		      		_AVOS := 1
					Else
	      			_AVOS := (12 - Month(SRA->RA_ADMISSA))
					Endif
	      	Else
					If Month(SRA->RA_ADMISSA) == 12
		      		_AVOS := 1
					Else
	   	   		_AVOS := (12 - (Month(SRA->RA_ADMISSA)-1))
					Endif
				Endif				
			Endif
			If SRA->RA_FALTAS <= 4
				_FALTAS := 20
			Elseif SRA->RA_FALTAS == 5
				_FALTAS := 15		
			Elseif SRA->RA_FALTAS == 6
				_FALTAS := 10
			Elseif SRA->RA_FALTAS == 7
				_FALTAS := 5
			Elseif SRA->RA_FALTAS > 7
				_FALTAS := 0
			Endif

			_PERCENT := (mv_par01 + mv_par02) + _FALTAS
			_SALARIO := SRA->RA_SALARIO
	 
			IF SRA->RA_CATFUNC == 'H'
				_SALARIO := SRA->RA_SALARIO * 220
			Endif
		
			// Pesquisa PPR Antecipado
	      SRD->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+Substr(Dtos(dDataBase),1,4),.T.))
			While  !SRD->(Eof()) .And. SRD->RD_MAT == SRA->RA_MAT
		      If SRD->RD_FILIAL==SRA->RA_FILIAL .AND. SRD->RD_MAT==SRA->RA_MAT .AND. SRD->RD_PD=='138'
					_nAntecipa += SRD->RD_VALOR
		      Endif
		      SRD->(DbSkip())
			Enddo

			// Calcula parcela
			_SALARIO := ((_SALARIO * _AVOS)/12)
			_PPR     := (((_SALARIO * _PERCENT)/100))
			_BASE1   := 0
			_BASE1   := _PPR - (Val(SRA->RA_DEPIR) * _DEPEN)
			_PPR     := (_PPR - _nAntecipa)
			_IRPPR   := 0
			_ALIQAP  := 0

			If _BASE1 > _ISENCAO .AND. _BASE1 <= _REND1
				_IRPPR := ((_BASE1 * _ALIQ1)/100) - _DEDU1
            _ALIQAP := _ALIQ1
			Elseif _BASE1 > _REND1
				_IRPPR := ((_BASE1 * _ALIQ2)/100) - _DEDU2
            _ALIQAP := _ALIQ2
			Endif
			
			If _PPR > 0
			
				* Grava em valores extras
		      SR1->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+Space(02)+mv_par04,.T.))
		      If SR1->R1_FILIAL==SRA->RA_FILIAL .AND. SR1->R1_MAT==SRA->RA_MAT .AND. SR1->R1_PD==mv_par04
   		      RecLock("SR1",.F.)
	      	   SR1->R1_VALOR   := (_PPR - _IRPPR)
		         SR1->R1_DATA    := mv_par03
		         MsUnLock("SR1")
	   	   Else
		         RecLock("SR1",.T.)
	   	      SR1->R1_FILIAL  := SRA->RA_FILIAL
	      	   SR1->R1_MAT     := SRA->RA_MAT
		         SR1->R1_PD      := mv_par04
		         SR1->R1_TIPO1   := 'V'
		         SR1->R1_VALOR   := (_PPR - _IRPPR)
		         SR1->R1_DATA    := mv_par03
		         SR1->R1_CC      := SRA->RA_CC
		         SR1->R1_PARCELA := 0
		         SR1->R1_TIPO2   := 'G'
		         MsUnLock("SR1")
		      Endif
         

			   * Grava no movimento mensal Provento
		      SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+mv_par04,.t.))
		      If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD==mv_par04
   		      RecLock("SRC",.F.)
		         SRC->RC_VALOR:=_PPR
		         SRC->RC_DATA := mv_par03
		         MsUnLock("SRC")
   		   Else
		         RecLock("SRC",.T.)
		         SRC->RC_FILIAL  := SRA->RA_FILIAL
		         SRC->RC_MAT     := SRA->RA_MAT
		         SRC->RC_PD      := mv_par04
		         SRC->RC_TIPO1   := 'V'
		         SRC->RC_VALOR   := _PPR
		         SRC->RC_PARCELA := 0
		         SRC->RC_CC      := SRA->RA_CC
		         SRC->RC_TIPO2   := 'I'
		         SRC->RC_DATA    := mv_par03
		         MsUnLock("SRC")
		      Endif

			   * Grava no movimento mensal Desconto
		      SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+mv_par11,.t.))
		      If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD==mv_par11
   		      RecLock("SRC",.F.)
		         SRC->RC_VALOR:=(_PPR - _IRPPR)
		         SRC->RC_DATA := mv_par03
		         MsUnLock("SRC")
   		   Else
		         RecLock("SRC",.T.)
		         SRC->RC_FILIAL  := SRA->RA_FILIAL
		         SRC->RC_MAT     := SRA->RA_MAT
		         SRC->RC_PD      := mv_par11
		         SRC->RC_TIPO1   := 'V'
		         SRC->RC_VALOR   := (_PPR - _IRPPR)
		         SRC->RC_PARCELA := 0
		         SRC->RC_CC      := SRA->RA_CC
		         SRC->RC_TIPO2   := 'I'
		         SRC->RC_DATA    := mv_par03
		         MsUnLock("SRC")
		      Endif

				* Grava Imposto de Renda
				If _IRPPR >= _RETMI
			      SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+mv_par12,.T.))
			      If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD==mv_par12
		   	      RecLock("SRC",.F.)
			         SRC->RC_FILIAL  := SRA->RA_FILIAL
			         SRC->RC_MAT     := SRA->RA_MAT
			         SRC->RC_PD      := mv_par12
			         SRC->RC_TIPO1   := 'V'
			         SRC->RC_VALOR   := _IRPPR
			         SRC->RC_PARCELA := 0
			         SRC->RC_CC      := SRA->RA_CC
			         SRC->RC_TIPO2   := 'I'
			         SRC->RC_DATA    := mv_par03
						SRC->RC_HORAS   := _ALIQAP
			         MsUnLock("SRC")
		   	   Else
			         RecLock("SRC",.T.)
			         SRC->RC_FILIAL  := SRA->RA_FILIAL
			         SRC->RC_MAT     := SRA->RA_MAT
			         SRC->RC_PD      := mv_par12
			         SRC->RC_TIPO1   := 'V'
			         SRC->RC_VALOR   := _IRPPR
			         SRC->RC_PARCELA := 0
			         SRC->RC_CC      := SRA->RA_CC
			         SRC->RC_TIPO2   := 'I'
			         SRC->RC_DATA    := mv_par03
						SRC->RC_HORAS   := _ALIQAP
			         MsUnLock("SRC")
			      Endif
				Endif
			Endif	


			/*
			* Grava Imposto de Renda
			If _IRPPR >= _RETMI
		      SR1->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+Space(02)+"417",.T.))
		      If SR1->R1_FILIAL==SRA->RA_FILIAL .AND. SR1->R1_MAT==SRA->RA_MAT .AND. SR1->R1_PD=='417'
	   	
	   	      RecLock("SR1",.F.)
		         SR1->R1_FILIAL  := SRA->RA_FILIAL
		         SR1->R1_MAT     := SRA->RA_MAT
		         SR1->R1_PD      := '417'
		         SR1->R1_TIPO1   := 'V'
		         SR1->R1_VALOR   := _IRPPR
		         SR1->R1_PARCELA := 0
		         SR1->R1_CC      := SRA->RA_CC
		         SR1->R1_TIPO2   := 'G'
		         SR1->R1_DATA    := mv_par03
					SR1->R1_HORAS   := _ALIQAP
		         MsUnLock("SR1")
	   	   Else
		         RecLock("SR1",.T.)
		         SR1->R1_FILIAL  := SRA->RA_FILIAL
		         SR1->R1_MAT     := SRA->RA_MAT
		         SR1->R1_PD      := '417'
		         SR1->R1_TIPO1   := 'V'
		         SR1->R1_VALOR   := _IRPPR
		         SR1->R1_PARCELA := 0
		         SR1->R1_CC      := SRA->RA_CC
		         SR1->R1_TIPO2   := 'I'
		         SR1->R1_DATA    := mv_par03
					SR1->R1_HORAS   := _ALIQAP
		         MsUnLock("SRC")
		      Endif
			Endif

			   * Grava no movimento mensal 
		      SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+"138",.t.))
		      If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD=='138'
   		      RecLock("SRC",.F.)
		         SRC->RC_VALOR:=_PPR
		         SRC->RC_DATA := mv_par03
		         MsUnLock("SRC")
   		   Else
		         RecLock("SRC",.T.)
		         SRC->RC_FILIAL  := SRA->RA_FILIAL
		         SRC->RC_MAT     := SRA->RA_MAT
		         SRC->RC_PD      := '138'
		         SRC->RC_TIPO1   := 'V'
		         SRC->RC_VALOR   := _PPR
		         SRC->RC_PARCELA := 0
		         SRC->RC_CC      := SRA->RA_CC
		         SRC->RC_TIPO2   := 'I'
		         SRC->RC_DATA    := mv_par03
		         MsUnLock("SRC")
		      Endif
      
				* Grava no movimento mensal (Desconto)
		      SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+"426",.t.))
		      If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD=='426'
   		      RecLock("SRC",.F.)
		         SRC->RC_VALOR:=_PPR
		         SRC->RC_DATA := mv_par03
		         MsUnLock("SRC")
   		   Else
		         RecLock("SRC",.T.)
		         SRC->RC_FILIAL  := SRA->RA_FILIAL
		         SRC->RC_MAT     := SRA->RA_MAT
		         SRC->RC_PD      := '426'
		         SRC->RC_TIPO1   := 'V'
		         SRC->RC_VALOR   := _PPR
		         SRC->RC_PARCELA := 0
		         SRC->RC_CC      := SRA->RA_CC
		         SRC->RC_TIPO2   := 'I'
		         SRC->RC_DATA    := mv_par03
		         MsUnLock("SRC")
		      Endif

			Endif	      
         
	
			* Grava Imposto de Renda
			If _IRPPR >= _RETMI
		      SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+mv_par11,.t.))
		      If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD==mv_par11
	   	      RecLock("SRC",.F.)
		         SRC->RC_FILIAL  := SRA->RA_FILIAL
		         SRC->RC_MAT     := SRA->RA_MAT
		         SRC->RC_PD      := mv_par11
		         SRC->RC_TIPO1   := 'V'
		         SRC->RC_VALOR   := _IRPPR
		         SRC->RC_PARCELA := 0
		         SRC->RC_CC      := SRA->RA_CC
		         SRC->RC_TIPO2   := 'I'
		         SRC->RC_DATA    := mv_par03
					SRC->RC_HORAS   := _ALIQAP
		         MsUnLock("SRC")
	   	   Else
		         RecLock("SRC",.T.)
		         SRC->RC_FILIAL  := SRA->RA_FILIAL
		         SRC->RC_MAT     := SRA->RA_MAT
		         SRC->RC_PD      := mv_par11
		         SRC->RC_TIPO1   := 'V'
		         SRC->RC_VALOR   := _IRPPR
		         SRC->RC_PARCELA := 0
		         SRC->RC_CC      := SRA->RA_CC
		         SRC->RC_TIPO2   := 'I'
		         SRC->RC_DATA    := mv_par03
					SRC->RC_HORAS   := _ALIQAP
		         MsUnLock("SRC")
		      Endif
			Endif
         
			*/
			
		Endif		
	Endif
   SRA->(DbSkip())      

Enddo

RetIndex("SRC")

Return



Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "GPE051"
aRegs   := {}

aadd(aRegs,{cPerg,"01","% Producao       ?","% Producao       ?","% Prodicao       ?","mv_ch1","N",05,2,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","% Refugo         ?","% Refugo         ?","% Refugo         ?","mv_ch2","N",05,2,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Data de Pagto    ?","Data de Pagto    ?","Data de Pagto    ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Verba Prov. PPR  ?","Verba            ?","Verba            ?","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRV",""})
aadd(aRegs,{cPerg,"05","Antecipacao      ?","Antecipacao      ?","Antecipacao      ?","mv_ch5","N",14,2,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Matricula de     ?","Matricula de     ?","Matricula de     ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aadd(aRegs,{cPerg,"07","Matricula Ate    ?","Matricula Ate    ?","Matricula Ate    ?","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aadd(aRegs,{cPerg,"08","Centro de Custo de  ?","Centro de Custo de ?","Centro de Custo de  ?","mv_ch8","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
aadd(aRegs,{cPerg,"09","Centro de Custo Ate ?","Centro de Custo Ate ?","Centro de Custo Ate ?","mv_ch9","C",09,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
aadd(aRegs,{cPerg,"10","Situacao         ?","Situacao         ?","Situacao         ?","mv_cha","C",01,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"11","Verba Desc. PPR  ?","Verba Desc. PPR  ?","Verba            ?","mv_chb","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SRV",""})
aadd(aRegs,{cPerg,"12","Verba Desc. IR   ?","Verba Desc. IR   ?","Verba            ?","mv_chc","C",03,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SRV",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
   	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf                   

dbSelectArea(_sAlias)

Return
