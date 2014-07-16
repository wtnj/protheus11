/*
+----------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                !
+----------------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                                    !
+------------------+---------------------------------------------------------------+
!Modulo            ! END - Endividamento                                           !
+------------------+---------------------------------------------------------------+
!Nome              ! NHEND003.PRW                                                  !
+------------------+---------------------------------------------------------------+
!Descricao         ! Gerar Parcelamento Contratos                                  +
+------------------+---------------------------------------------------------------+
!Autor             ! Edenilson Santos                                              !
+------------------+---------------------------------------------------------------+
!Data de Criacao   ! 24/01/2014                                                    !
+------------------+---------------------------------------------------------------+
!ATUALIZACOES                                                                      !
+-------------------------------	------------+---------------+-----------+----------+
!Descricao detalhada da atualizacao         !Nome do        ! Analista  !Data da   !
!                                           !Solicitante    ! Respons.  !Atualiz.  !
+-------------------------------------------+---------------+-----------+----------+
!                                           !Alexandrevm    !           !          !
+-------------------------------------------+---------------+-----------+----------+
*/
#include "protheus.ch"
#include "colors.ch"
#include "topconn.ch"
#include "rwmake.ch"

User Function NHEND003()
Private oDlg,cQuery,aResCols,_dFinDat,_cForn,_cLoja,_cNat,_nSequenc,cContrato,_cContr
_cContr  := space(20)
aResCols := {}

oDlg     := MsDialog():New(0,0,125,205,"Gerar Parcelamento Contrato",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

//oSay1b   := TSay():New(20,10,{||"Digite o número do conrato que que deseja verificar as parcelas"},oDlg,,,,,,.T.,CLR_BLACK,)
oSay2b   := TSay():New(10,25,{||"Número do Contrato"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet2b   := tGet():New(20,25,{|u| if(Pcount() > 0, _cContr := u,_cContr)},oDlg,60,8,"@!",{|| .T. } ,;
,,,,,.T.,,,{|| /* When */},,,,,,"ZF8","_cContr")

oButton  := tButton():New(35,25,"Confirmar",oDlg,{|| Processa({|| fFindEnd() } , "Procurando contratos...")},60,15,,,,.T.)

oDlg:Activate(,,,.T.,{||.T.},,)

Return

Static Function fFindEnd()

IncProc()
RecCount(0)

If Select("TRA") > 0
	TRA->( DbCloseArea() )
EndIf

If Select("XDBF") > 0
	XDBF->( DbCloseArea() )
EndIf

fQuery()
While TRA->( !Eof() )
	fCalculo()
	TRA->( DbSkip() )
EndDo
MontaGrid()

Return

Static Function fQuery()
/*
Local cQuery := ""
cQuery := " SELECT * FROM " + RetSqlName("ZF8") + " (NOLOCK)"
cQuery += " WHERE ZF8_CONTRA  = '" + _cContr + "' "
cQuery += " AND D_E_L_E_T_ = ''  "
cQuery += " AND ZF8_FILIAL 	   = '" + xFilial("ZF8") + "' "
TCQUERY cQuery NEW ALIAS "TRA"
//TRA->( DbGoTop() )
*/
BeginSql Alias "TRA"
	SELECT *
	FROM
	%Table:ZF8% ZF8(NOLOCK)
	WHERE
	ZF8_CONTRA = %Exp:_cContr% AND
	ZF8_FILIAL = %xFilial:ZF8% AND
	ZF8.%NotDel%
EndSql
Return

Static Function fCalculo()
Local 	_nAux 	  	 := 0
Local 	_aAuxCols 	 := {}
Local 	_dData 	  	 := _dData1 := CTOD(space(8))
Local 	_lTemLib  	 := .F.
Local 	_nPot,_nPrim := 0
Private _nJuros 	    := 0

aResult := {}

/* Carrega Cabecalho */
cNumEnd    := TRA->ZF8_NUM
cContrato  := TRA->ZF8_CONTRA
nVlrFinan  := TRA->ZF8_VLRFIN
nJurBNDES  := TRA->ZF8_JUBNDS
nJurBanco  := TRA->ZF8_JUBANC
nJurTot    := TRA->ZF8_JURTOT
nPrazo	  := TRA->ZF8_PRAZO
nCarencia  := TRA->ZF8_CARENC
cContC     := TRA->ZF8_CONTAC
_cForn 	  := TRA->ZF8_FORN
_cLoja 	  := TRA->ZF8_LOJA
_cNat 	  := TRA->ZF8_NATUR
_nSequenc  := TRA->ZF8_SEQ

_nNumDia   := 200
_dPrimLib  := Date()
_nSomJur   := 0
_nAuxCont  := 0
_nCareDias := nCarencia * 30
_nAuxMes   := 0
_dLastData := CTOD(Space(8))

/* Carrega Itens e cálculo da dívida. */
ZF9->( DbSetOrder(2) )
ZF9->( DbSeek(xFilial("ZF9") + cNumEnd))

While ZF9->( !Eof() ) .and. ZF9->ZF9_NUM == cNumEnd
	If Alltrim(ZF9->ZF9_DESC) == "1"
		aAdd(aResult,{"Liberação",ZF9->ZF9_VALOR,ZF9->ZF9_BASE,ZF9->ZF9_DATA,"","",0,0,0,ZF9->ZF9_VALOR} )
		cSaldDev := ZF9->ZF9_VALOR
		_dData   := _dPrimLib := ZF9->ZF9_BASE
		_lTemLib := .T.
		exit
	Endif
	ZF9->( DbSkip() )
EndDo

_lTemPag  := .F.
_lPagDB   := .F.
_lTemLib2 := .F.
_nPrim2   := 0
_nPrim3   := 0
//_dLastDia := _dData1	//bloqueado e inserido no trecho abaixo
_lHavPag  := .T. // incluido 
If _lTemLib
	ZF9->( DbSetOrder(3) )  //ZF9_FILIAL+ZF9_BASE+ZF9_NUM -> Data+Numero                                                           
	_dLastDia := _dData1	//incluido aqui e bloqueado em cima
	_dData1:= (_dData + 1)
	_nDia  := _dData1 - _dData
	
	/* Calcula valores até a data do final da carência */
	For i := 1 to _nCareDias
		If i > 1
			_dLastDia := LastDate(_dData1)
			If _dData1 == _dLastDia
				_nDia    := _dData1 - aResult[Len(aResult)][3]
				_nAux    := nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				cSaldDev += _nJuros
				_nAuxMes := 0
				_nSomJur += _nJuros
			EndIf

			If ZG0->(DbSeek(xFilial("ZG0") + cNumEnd + DTOS(_dData1) ))
				/* Gera título de pagamento dos juros */
				_nDia    := _dData1 - aResult[Len(aResult)][3]
				_nAux    := nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				cSaldDev += _nJuros
				_nAuxMes := 0
				_nSomJur += _nJuros
				cSaldDev -= _nSomJur
				aAdd(aResult,{"Pagamento de Juros",0,_dData1,"",_nDia,"",0,_nJuros * 100,_nSomJur,cSaldDev} )
				_nSomJur := 0
				_lTemPag := .T.
				ZG0->( DbSkip() )
			EndIf
			
			If !_lTemPag .and. _dData1 == _dLastDia
				aAdd(aResult,{"Apropriação de Juros",0,_dData1,"",_nDia,"",0,_nJuros * 100,0,cSaldDev} )
				_nAuxCont := 0
			EndIf
			
			/* Verifica se há uma liberação no dia */
			If ZF9->( DbSeek(xFilial("ZF9") + DTOS(_dData1) + cNumEnd ))
				_nDia 	:= ZF9->ZF9_BASE - aResult[Len(aResult)][3]
				_nAux 	:= nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				cSaldDev += _nJuros
				_nSomJur += _nJuros
				aAdd(aResult,{"Liberação",ZF9->ZF9_VALOR,ZF9->ZF9_BASE,ZF9->ZF9_DATA,_nDia,"",0,_nJuros * 100,0,cSaldDev,_nSomJur} )
				cSaldDev += ZF9->ZF9_VALOR
			EndIf
			
			_lTemPag := .F.
			_dData1++
			_nAuxCont++
			_nAuxMes++
		EndIf
	Next i
	
	SE2->( DbSetOrder(1) )
	nFinanDias := (nPrazo * 31)
	nVlrParc   := nVlrFinan/nPrazo
	_lTemPag   := .F.
	_nPag      := 0
	//_nParcela  := 0
	_nParcela  := 1
	_cAuxCon   := ""
	_nJurCer   := 0
	lSJnot	  := .F. // variável que verifica se a soma dos juros não é igual 0, ou seja, teve uma apropriação depois da última amortização
	
	If _nSomJur != 0
		lSJnot := .T.
	EndIf
	
	//_dData1    := aResult[Len(aResult)][3]
	/* Calcula valores do fim da carência até a data do final da dívida */
	For i := 1 to nFinanDias

		if _nParcela = 2
		Endif
		
		/* Verifica se há uma liberação no dia */
		If ZF9->( DbSeek(xFilial("ZF9") + DTOS(_dData1) + cNumEnd ))
			_nDia 	:= ZF9->ZF9_BASE - aResult[Len(aResult)][3]
			_nAux 	:= nJurTot/100
			_nPrim2  := Round(1 + _nAux,4)
			_nPrim3  := _nDia/360
			_nPrim   := _nPrim2 ** _nPrim3 - 1
			cSaldDev := Round(cSaldDev,2)
			_nJuros  := cSaldDev * _nPrim
			cSaldDev += _nJuros
			_nSomJur += _nJuros
			aAdd(aResult,{"Liberação",ZF9->ZF9_VALOR,ZF9->ZF9_BASE,ZF9->ZF9_DATA,_nDia,"",0,_nJuros * 100,0,cSaldDev,_nSomJur} )
			cSaldDev += ZF9->ZF9_VALOR
		EndIf
		
		// Realiza um pagamento da parcela + Juros
		If _nParcela <= nPrazo

			If Day(_dData1) == 15
				
				If isFeriado(_dData1)
					_dData1++
				EndIf
				
				If verificaDia(_dData1) == 7
					_dData1 += 2 //
				ElseIf verificaDia(_dData1) == 1
					_dData1++
				EndIf
				
				//If verificaDia(_dData1)	!= 7 .or. verificaDia(_dData1)	!= 1
				//	_nParcela++
					_nDia 	:= _dData1 - aResult[Len(aResult)][3]
					_nAux 	:= nJurTot/100
					_nPrim2  := Round(1 + _nAux,4)
					_nPrim3  := _nDia/360
					_nPrim   := _nPrim2 ** _nPrim3 - 1
					cSaldDev := Round(cSaldDev,2)
					_nJuros  := cSaldDev * _nPrim

					cSaldDev += _nJuros
					_nPag    := Round(nVlrParc,2) + _nJuros					
					
					//If lSJnot
					//	_nJuros:= 	(cSaldDev * _nPrim) + _nSomJur
					//	lSJnot := .F.
					//EndIf

					If lSJnot
						_nPag  := Round(nVlrParc,2) + _nJuros + _nSomJur
						lSJnot := .F.
					EndIf
					
					
					//cSaldDev += _nJuros
					//_nPag    := Round(nVlrParc,2) + _nJuros
					cSaldDev -= _nPag
					_nSomJur += _nJuros
					
					aAdd(aResult,{"Principal + Juros ",0,_dData1,"",_nDia,_nParcela,nVlrParc,_nJuros,_nPag,cSaldDev} )
			      If _nParcela <= nPrazo 
					aAdd(aResCols,{cContrato,_dData1,_nPag,_nParcela,_nJuros,nVlrParc,_nSequenc,_cForn,_cLoja,_cNat} )
					EndIf
					
//					If _nParcela == 49
//					Alert('parar processo')
//					EndIf
					_nSomJur := 0
					_lTemPag := .T.
					_nParcela++					
				//EndIf
			EndIf
		EndIf
		
		_nAuxCont++
		_lTemPag := .F.
		_dData1++
	Next i
EndIf

Return

Static Function VerificaDia(Datta)

_nNumDia := DoW(Datta)

If _nNumDia == 1 .or. _nNumDia == 7
	Return _nNumDia
EndIf

Return 12

Static Function MontaGrid()

Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5 }
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)

If Len(aResCols) <= 0
	alert("Nenhum dado encontrado. Favor, verifique e tente novamente.")
	Return .F.
EndIf

If Select("XDBF") > 0
	XDBF->( DbCloseArea() )
EndIf

cMarca := getMark()
_cArqXDBF := CriaTrab(NIL,.f.)
_aXDBF    := {}

aCampos := {}
Aadd(aCampos,{"OK"        ,"C", "  "          ,"@!"	 	  		   })
Aadd(aCampos,{"Contrato"  ,"C", "Contrato"    ,"@!"		  		   })
Aadd(aCampos,{"Datta"     ,"D", "Data"        ,"99/99/9999"		   })
Aadd(aCampos,{"Parcela"   ,"N", "Parcela"     ,"@E 999"		      })
Aadd(aCampos,{"Juros" 	  ,"N", "Juros"     	 ,"@E 999,999,999.99"})
Aadd(aCampos,{"Principal" ,"N", "Principal"   ,"@E 999,999,999.99"})
Aadd(aCampos,{"Valor" 	  ,"N", "Valor"     	 ,"@E 999,999,999.99"})
Aadd(aCampos,{"Fornecedor","C", "Fornecedor"  ,"@!"				   })
Aadd(aCampos,{"Loja" 	  ,"C", "Loja"     	 ,"@!"				   })
Aadd(aCampos,{"Natureza"  ,"C", "Natureza"    ,"@!"				   })
Aadd(aCampos,{"Sequencial","N", "Sequencial"  ,"@E 9999"			   })

AADD(_aXDBF,{"OK"         ,"C", 02,0})
AADD(_aXDBF,{"Contrato"   ,"C", 15,0})
AADD(_aXDBF,{"Parcela"    ,"N", 03,0})
AADD(_aXDBF,{"Datta"      ,"D", 08,0})
AADD(_aXDBF,{"Valor" 	  ,"N", 09,2})
AADD(_aXDBF,{"Juros" 	  ,"N", 12,2})
AADD(_aXDBF,{"Principal"  ,"N", 09,2})
AADD(_aXDBF,{"Fornecedor" ,"C", 06,0})
AADD(_aXDBF,{"Loja"   	  ,"C", 02,0})
AADD(_aXDBF,{"Natureza"   ,"C", 10,0})
AADD(_aXDBF,{"Sequencial" ,"N", 04,0})

DbCreate(_cArqXDBF,_aXDBF)
DbUseArea(.T.,,_cArqXDBF,"XDBF",.F.)

cAl    := getNextAlias()
_cNum  := ""
_cNum2 := ""

For i := 1 to Len(aResCols)
	_cNum  := Alltrim(Str(aResCols[i][7])) + "P" + StrZero(aResCols[i][4],3) + "P"
	_cNum2 := Alltrim(Str(aResCols[i][7])) + "J" + StrZero(aResCols[i][4],3) + "P"
	
	beginSql Alias cAl
		SELECT
		E2_NUM
		FROM
		%Table:SE2%
		WHERE
		E2_PREFIXO = 'END' AND
		E2_NUM IN(%Exp:_cNum%,%Exp:_cNum2%) AND
		E2_TIPO = '01' AND
		E2_FORNECE = %Exp:aResCols[i][8]% AND
		E2_LOJA = %Exp:aResCols[i][9]% AND
		E2_FILIAL = %xFilial:SE2% AND
		%notDel%
	EndSql
	
	If (cAl)->(Eof() )
		RecLock("XDBF",.T.)
		XDBF->OK 	    := ""
		XDBF->CONTRATO  := aResCols[i][1]
		XDBF->DATTA     := aResCols[i][2]
		XDBF->VALOR     := aResCols[i][3]
		XDBF->Parcela   := aResCols[i][4]
		XDBF->Juros     := aResCols[i][5]
		XDBF->Principal := aResCols[i][6]
		XDBF->Sequencial:= aResCols[i][7]
		XDBF->Fornecedor:= aResCols[i][8]
		XDBF->Loja		 := aResCols[i][9]
		XDBF->Natureza  := aResCols[i][10]
		
		MsUnLock("XDBF")
	Else
		While (cAl)->(!Eof() )
			If Substr( (cAl)->E2_NUM,6,3) == Strzero(aResCols[i][4],3)
				(cAl)->( DbSkip() )
			Else
				RecLock("XDBF",.T.)
				XDBF->OK 	    := ""
				XDBF->CONTRATO  := aResCols[i][1]
				XDBF->DATTA     := aResCols[i][2]
				XDBF->VALOR     := aResCols[i][3]
				XDBF->Parcela   := aResCols[i][4]
				XDBF->Juros     := aResCols[i][5]
				XDBF->Principal := aResCols[i][6]
				XDBF->Sequencial:= aResCols[i][7]
				XDBF->Fornecedor:= aResCols[i][8]
				XDBF->Loja	    := aResCols[i][9]
				XDBF->Natureza  := aResCols[i][10]
				MsUnLock("XDBF")
				(cAl) ->( DbSkip() )
			EndIf
		EndDo
	EndIf
	(cAl)->( DbCloseArea() )
	cAl := getNextAlias()
Next i

XDBF->( DbGoTop() )
DbSelectArea("XDBF")
Index On XDBF->CONTRATO to (_cArqXDBF)

/*
aRotina := { {"Marca Tudo"     ,'U_fMarcavk()', 0 , 4 },;
{"Desmarca Tudo"  ,'U_fDesmarvk()', 0 , 1 },;
{"Gera Financeiro",'U_geraFin()', 0 , 1 } }

MarkBrow("XDBF","OK" ,"XDBF->OK",aCampos,,cMarca)
*/

oDialog := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Endividamento | Gerar Parcelamento Contrato",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oBtn1 := tButton():New(05, 05,"Gerar Financeiro" ,oDialog,{||U_geraFin()  },50,10,,,,.T.)
oBtn2 := tButton():New(05, 60,"Marcar Todos"    ,oDialog,{||fTdFNM(.t.)  },50,10,,,,.T.)
oBtn3 := tButton():New(05,115,"Desmarcar Todos" ,oDialog,{||fTdFNM(.f.)  },50,10,,,,.T.)
oBtn4 := tButton():New(05,170,"Fechar"          ,oDialog,{||oDialog:End()},50,10,,,,.T.)

oMark := MsSelect():New("XDBF","OK",nil,aCampos,.F.,@cMarca,{20, aPosObj[2,2] ,aPosObj[2,3],aPosObj[2,4]})

oDialog:Activate(,,,.F.,{||.T.},,)

Return


//Marca todas as notas
Static Function fTdFNM(lMarca)

XDBF->(DbGoTop())
While !XDBF->(eof())
	
	RecLock("XDBF")
	XDBF->OK := Iif(lMarca,cMarca,space(2))
	MsUnlock("XDBF")
	XDBF->(Dbskip())
Enddo

XDBF->(dbgotop())

oMark:oBrowse:Refresh()
Return

User Function geraFin()
Private _cNomFor := ""
ZF8->( DbSetOrder(1) )                                   '

XDBF->( DbGoTop() )

While XDBF->( !Eof() )
	If !Empty(XDBF->OK)
		ZF8->(DbSeek(xFilial("ZF8") + XDBF->CONTRATO ))
		If SA2->(DbSeek(xFilial("SA2") +  ZF8->ZF8_FORN + ZF8->ZF8_LOJA))
			_cNomFor  := SA2->A2_NREDUZ
		EndIf
		geraJur()
		GeraPar()
	EndIf
	XDBF->( DbSkip() )
EndDo

MsgiNFO("Títulos gerados com sucesso!","Títulos")
oDlg:End()

Return

Static Function GeraJur()

RecLock("SE2",.T.)
SE2->E2_FILIAL	 := xFilial("SE2")
SE2->E2_PREFIXO := "END" // Prefixo para ENDIVIDAMENTO
SE2->E2_NUM     := Alltrim(Str(XDBF->Sequencial)) + "J" + Strzero(XDBF->PARCELA,3) + "P" // Número do contrato + caracter de controle (J = Pagamento de Juros; P = Pagamento de Parcelas ) + parcela( @E 999)
SE2->E2_TIPO    := "01" // Modalidade do endividamento. 01 = Finame
SE2->E2_NATUREZ := XDBF->Natureza
SE2->E2_FORNECE := XDBF->Fornecedor
SE2->E2_LOJA    := XDBF->Loja
SE2->E2_NOMFOR  := _cNomFor
SE2->E2_EMISSAO := dDataBase
SE2->E2_VENCTO  := XDBF->DATTA
SE2->E2_VENCREA := XDBF->DATTA
SE2->E2_VENCORI := XDBF->DATTA
SE2->E2_VALOR   := XDBF->Juros
SE2->E2_EMIS1   := XDBF->DATTA
SE2->E2_SALDO   := XDBF->Juros
SE2->E2_MOEDA   := 1
SE2->E2_FATURA  := ""
SE2->E2_VLCRUZ  := XDBF->Juros
SE2->E2_ORIGEM  := ""
SE2->E2_CC      := "IMOBILIZ"
SE2->E2_FLUXO   := "S"
SE2->E2_FILORIG := xFilial("SE2")
SE2->E2_DESDOBR := "N"
SE2->E2_RATEIO  := "N"
SE2->E2_HIST	 := Alltrim(XDBF->CONTRATO)
MsUnlock("SE2")

Return

Static Function GeraPar()

RecLock("SE2",.T.)
SE2->E2_FILIAL	 := xFilial("SE2")
SE2->E2_PREFIXO := "END" // Prefixo para ENDIVIDAMENTO
SE2->E2_NUM     := Alltrim(Str(XDBF->Sequencial)) + "P" + Strzero(XDBF->PARCELA,3) + "P" // Número do contrato + caracter de controle (J = Pagamento de Juros; P = Pagamento de Parcelas ) + parcela( @E 999)
SE2->E2_TIPO    := "01" // Modalidade do endividamento. 01 = Finame
SE2->E2_NATUREZ := XDBF->Natureza
SE2->E2_FORNECE := XDBF->Fornecedor
SE2->E2_LOJA    := XDBF->Loja
SE2->E2_NOMFOR  := _cNomFor
SE2->E2_EMISSAO := dDataBase
SE2->E2_VENCTO  := XDBF->DATTA
SE2->E2_VENCREA := XDBF->DATTA
SE2->E2_VENCORI := XDBF->DATTA
SE2->E2_VALOR   := XDBF->Principal
SE2->E2_EMIS1   := XDBF->DATTA
SE2->E2_SALDO   := XDBF->Principal
SE2->E2_MOEDA   := 1
SE2->E2_FATURA  := ""
SE2->E2_VLCRUZ  := XDBF->Principal
SE2->E2_ORIGEM  := ""
SE2->E2_CC      := "IMOBILIZ"
SE2->E2_FLUXO   := "S"
SE2->E2_FILORIG := xFilial("SE2")
SE2->E2_DESDOBR := "N"
SE2->E2_RATEIO  := "N"
SE2->E2_HIST	 := Alltrim(XDBF->CONTRATO)
MsUnlock("SE2")

Return

Static Function isFeriado(Datta)

ZG4->( DbSetOrder(1) )
If ZG4->( DbSeek(xFilial("ZG4") + DTOS(Datta) ))
	Return .T.
EndIf

Return .F.
