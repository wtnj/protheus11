/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST010 ³Autor  ³ Marcos R. Roquitski   ³ Data ³ 10/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo do Estoque de Seguranca.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHEST010()
	SetPrvt("lEnd,_dDatai,_dDataf,_aSb1,_nPer,_nMedPer,_lPrimeiro,_cFornece,_nCont")
	
   AjustaSx1()

   If !Pergunte('EST010',.T.)
      Return(nil)
   Endif   


	If !MsgBox("Confirma calculo do estoque de Seguranca","Estoque","YESNO")
		Return
	Endif		

   _aDem := {}
   AADD(_aDem,{"FORNECE","C",06,0})
   AADD(_aDem,{"PRODUTO","C",15,0})
   AADD(_aDem,{"PERCENT","N",10,3})

   _cArqDem := CriaTrab(_aDem)
   USE (_cArqDem) ALIAS TRC New Exclusive

   DbSelectArea("TRC")
   IndRegua("TRC",_cArqDem,"PRODUTO",,,"Criando indice...")
   TRC->(DbSetOrder(1))

   _aSB1 := {}
   AADD(_aSB1,{"MARCA","C",02,0})
   AADD(_aSB1,{"PRODUTO","C",15,0})
   AADD(_aSB1,{"COMP","C",15,0})
   AADD(_aSB1,{"DESCRIC","C",40,0})
   AADD(_aSB1,{"QUANT","N",14,3})
   AADD(_aSB1,{"ESTOQ","N",14,3})
                                                                                                                       
   _cArqSB1 := CriaTrab(_aSB1)
   USE (_cArqSB1) ALIAS TRB New Exclusive

   DbSelectArea("TRB")
   IndRegua("TRB",_cArqSB1,"COMP",,,"Criando indice...")
   TRB->(DbSetOrder(1))


	Processa({|| fGeraTs() }, "Gerando Previsao de Venda SC4")
	Processa({|| fGeraSc4() }, "Gerando Previsao de Venda SC4")
	Processa({|| fGeraSc7() }, "Gerando Pedido de Venda em Aberto SC7")

	MsAguarde ( {|lEnd| fCalcSc4() },"Processando","Aguarde...",.T.)
	MsAguarde ( {|lEnd| fCalcSc7() },"Processando","Aguarde...",.T.)
	MsAguarde ( {|lEnd| fCalcTax() },"Processando","Aguarde...",.T.)
	MsAguarde ( {|lEnd| fCalcEst() },"Processando","Aguarde...",.T.)
	// MostraC4()
	fDadosEstoq()
	DbSelectArea("TMPA")
	DbCloseArea()

	DbSelectArea("TMPB")
	DbCloseArea()

	DbSelectArea("TMPC")
	DbCloseArea()

	DbSelectArea("TRB")
	DbCloseArea()

	DbSelectArea("TRC")
	DbCloseArea()

Return

Static Function fGeraSc7()
	_dDatai := Ctod( "01/" + Substr(Dtos(dDataBase),5,2) + "/" + Substr(Dtos(dDataBase),1,4) )
	_dDataf := UltimoDia(dDataBase)
	cQuery := " SELECT C7.C7_PRODUTO,C7.C7_DESCRI,C7.C7_QUANT,C7.C7_DATPRF "
	cQuery := cQuery + " FROM " + RetSqlName( 'SC7' ) + " C7 "
   cQuery := cQuery + " WHERE C7.C7_DATPRF  BETWEEN '" + Dtos(_dDatai) + "' AND '" + Dtos(_dDataf) + "' AND C7.D_E_L_E_T_ <> '*' "  
	TCQUERY cQuery NEW ALIAS "TMPB"
Return


Static Function fGeraSc4()
	_dDatai := Ctod( "01/" + Substr(Dtos(dDataBase),5,2) + "/" + Substr(Dtos(dDataBase),1,4) )
	_dDataf := UltimoDia(dDataBase)
	cQuery := " SELECT C4.C4_PRODUTO,C4.C4_QUANT,B1.B1_COD,B1.B1_DESC,B1.B1_TIPO,C4_DATA"
	cQuery := cQuery + " FROM " + RetSqlName( 'SB1' ) + " B1, " + RetSqlName( 'SC4' ) +  " C4 "
	cQuery := cQuery + " WHERE C4.C4_PRODUTO = B1.B1_COD AND C4.D_E_L_E_T_ <> '*' "
	cQuery := cQuery + " AND C4.C4_DATA  BETWEEN '" + Dtos(_dDatai) + "' AND '" + Dtos(_dDataf) + "' AND B1.D_E_L_E_T_ <> '*' "  
	TCQUERY cQuery NEW ALIAS "TMPA"
Return



Static Function fGeraTs()
	_Mes := Month(dDataBase)
	If _Mes == 2
		_Mes    := 12
		_Ano    := Year(dDataBase) - 1
		_dDatai := Ctod( "01/" + StrZero(_Mes,2) + "/" + StrZero(_Ano,4))
		_Mes    := 1
		_dDataf := UltimoDia( Ctod( "01/" + StrZero(_Mes,2) + "/" + Substr(Dtos(dDataBase),1,4) ) )
	Elseif _Mes == 1
		_Mes    := 11
		_Ano    := Year(dDataBase) - 1
		_dDatai := Ctod( "01/" + StrZero(_Mes,2) + "/" + StrZero(_Ano,4))
		_Mes    := 12
		_dDataf := UltimoDia( Ctod( "01/" + StrZero(_Mes,2) + "/" + StrZero(_Ano,4) ) )
	Else
		_Mes    := _Mes - 2
		_dDatai := Ctod( "01/" + StrZero(_Mes,2) + "/" + Substr(Dtos(dDataBase),1,4))
		_Mes    := _Mes + 1
		_dDataf := UltimoDia( Ctod( "01/" + StrZero(_Mes,2) + "/"  + Substr(Dtos(dDataBase),1,4) ))
	Endif

	cQuery := "SELECT SC7.C7_NUM,SC7.C7_ITEM,SC7.C7_PRODUTO,SC7.C7_DESCRI,SC7.C7_QUANT,SC7.C7_QUJE,SC7.C7_RESIDUO,"
	cQuery += "SC7.C7_DATPRF,SA2.A2_COD,SA2.A2_LOJA,SA2.A2_NOME,SD1.D1_DTDIGIT,SD1.D1_QUANT,SD1.D1_DOC,SC7.C7_ITEM,SA2.A2_QUALIF"
	cQuery += " FROM " + RetSqlName( 'SC7' ) +" SC7 (NOLOCK) "
	
	cQuery += " INNER JOIN " + RetSqlName( 'SA2' ) + " SA2 ON "
	cQuery += " 	SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
	cQuery += " AND	SC7.C7_FORNECE = SA2.A2_COD "
	cQuery += " AND SC7.C7_LOJA = SA2.A2_LOJA "
	cQuery +=  "AND SA2.D_E_L_E_T_ = '' "
	
	cQuery += " LEFT JOIN " + RetSqlName( 'SD1' ) + " SD1 ON "
	cQuery += " 	SC7.C7_FILIAL  = SD1.D1_FILIAL "
	cQuery += " AND SC7.C7_NUM     = SD1.D1_PEDIDO"
	cQuery += " AND SC7.C7_PRODUTO = SD1.D1_COD"
	cQuery += " AND SC7.C7_ITEM    = SD1.D1_ITEMPC"
	cQuery += " AND SC7.C7_FORNECE = SD1.D1_FORNECE"
	cQuery += " AND SC7.C7_LOJA    = SD1.D1_LOJA"
	cQuery += " AND SD1.D_E_L_E_T_ = '' "
		
	cQuery += " WHERE SC7.C7_DATPRF BETWEEN '" + DtoS(_dDatai) + "' AND '" + DtoS(_dDataf) + "'"
	cQuery += " AND SC7.D_E_L_E_T_ = '' and SC7.C7_FILIAL = '" + xFilial("SC7") + "'"  
	cQuery += " ORDER BY SC7.C7_FORNECE,SC7.C7_LOJA,SC7.C7_PRODUTO,SC7.C7_ITEM"

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMPC"
	TcSetField("TMPC","D1_DTDIGIT","D") // Muda a data de digitaçao de string para date
	TcSetField("TMPC","C7_DATPRF","D")  // Muda a data de preferencia de string para date

Return



Static Function MostraC4()

SetPrvt("AFIELDS,AROTINA,CDELFUNC,CCADASTRO,CMARCA,CCOORD")
SetPrvt("ACAMPOS,TITULO")

DbSelectArea("TRB")
TRB->( DbGotop())

aFields := {}
Aadd(aFields,{"MARCA"    ,"C",OemToAnsi("Marca") })
Aadd(aFields,{"PRODUTO"  ,"C",OemToAnsi("Produto") })
Aadd(aFields,{"COMP"     ,"C",OemToAnsi("Componente") })
Aadd(aFields,{"DESCRIC"  ,"C",OemToAnsi("Descricao") })
Aadd(aFields,{"QUANT"    ,"N",OemToAnsi("Quant") })
Aadd(aFields,{"ESTOQ"    ,"N",OemToAnsi("Estoque") })


aRotina   := {}
cDelFunc  := ".T."
cCadastro := OemToAnsi("Selecione - <ENTER> Marca/Desmarca")
cMarca    := getmark()
                
MarkBrow("TRB","MARCA" ,"TRB->MARCA",afields,,cMarca)

Return(.T.)



Static Function fCalcSc4()
	DbselectArea("TMPA")
	TMPA->(DbGotop())
	While !TMPA->(Eof())
		MsProcTxt("Previsao de Venda: "+TMPA->C4_PRODUTO)
		Estoura(TMPA->C4_PRODUTO,TMPA->C4_QUANT)
		DbselectArea("TMPA")		
		TMPA->(Dbskip())	
	Enddo
Return
                                    
Static Function fCalcSc7()
	DbselectArea("TMPB")
	TMPB->(DbGotop())
	While !TMPB->(Eof())
		MsProcTxt("Pedidos em Aberto: "+TMPB->C7_PRODUTO)

      DbSelectArea("SB1")
      SB1->(DbSetOrder(1))
      If !SB1->(DbSeek(xFilial("SB1")+TMPB->C7_PRODUTO))
         TMPB->(DbSkip())
         Loop
      EndIf

      If !SB1->B1_TIPO$"MP/CP"
         TMPB->(DbSkip())
         Loop
      EndIf

      DbSelectArea("TRB")
		TRB->(DbSeek(TMPB->C7_PRODUTO))
		If !TRB->(Found())
		   RecLock("TRB",.T.)
  			TRB->PRODUTO := TMPB->C7_PRODUTO
			TRB->COMP    := TMPB->C7_PRODUTO
			TRB->DESCRIC := SB1->B1_DESC
			TRB->QUANT   := TMPB->C7_QUANT
   	   MsUnLock("TRB")
		Else
		   RecLock("TRB",.F.)
			TRB->QUANT := TRB->QUANT + TMPB->C7_QUANT
   	   MsUnLock("TRB")
		Endif

		DbselectArea("TMPB")		
		TMPB->(Dbskip())	

	Enddo
Return



Static Function Estoura(_cProdut,_nQuant)
                                                                                                                          
   nEstru      := 0
   cAliasEstru := "ESTRUT"
   cArqTrab    := CriaTrab(nil,.f.)
   cNomeArq    := Estrut2(_cProdut)
                                                                                                                          
   DbSelectArea("ESTRUT")
   ESTRUT->(DbGoTop())

   While ESTRUT->(!Eof())
     
      DbSelectArea("SB1")
      SB1->(DbSetOrder(1))
      If !SB1->(DbSeek(xFilial("SB1")+ESTRUT->COMP,.T.))
         Exit
      EndIf

      If !SB1->B1_TIPO$"MP/CP"
         ESTRUT->(DbSkip())
         Loop
      EndIf
     
      If ESTRUT->QUANT < 0.00000
         ESTRUT->(DbSkip())
         Loop
      EndIf


      DbSelectArea("TRB")
		TRB->(DbSeek(ESTRUT->COMP))
		If !TRB->(Found())
		   RecLock("TRB",.T.)
  			TRB->PRODUTO := _cProdut
			TRB->COMP    := ESTRUT->COMP
			TRB->DESCRIC := SB1->B1_DESC
			TRB->QUANT   := (ESTRUT->QUANT * _nQuant)
   	   MsUnLock("TRB")
		Else
		   RecLock("TRB",.F.)
			TRB->QUANT := TRB->QUANT + (ESTRUT->QUANT * _nQuant)
   	   MsUnLock("TRB")
		Endif
		
		DbSelectArea("ESTRUT")
		ESTRUT->(DbSkip())

	Enddo
	DbSelectArea("ESTRUT")
	DbCloseArea()	
                                                                                                                          
Return


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := Space(10)
cPerg   := "EST010    "
aRegs   := {}

aadd(aRegs,{cPerg,"01","Dias Uteis       ?","Dias Uteis       ?","Dias Uteis       ?","mv_ch1","N",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Indice Qualidade ?","Indice Qualidade ?","Indice Qualidade ?","mv_ch2","N",05,2,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Variacao Demanda ?","Variacao Demanda ?","Variacao Demanda ?","mv_ch3","N",05,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
                           


Static Function fCalcTax()
_nCont := 0
_nPer := 0
_nMedPer := 0
_lPrimeiro := .t.
_cFornece  := TMPC->A2_COD    // CODIGO DO FORNECEDOR + PRODUTO
_cProduto  := TMPC->C7_PRODUTO

While TMPC->(!Eof())

	MsProcTxt("Indice Taxa Servico: "+TMPC->C7_PRODUTO)

   If TMPC->C7_QUJE == 0 .And. TMPC->C7_RESIDUO == 'S'
      TMPC->(Dbskip())
      Loop
   Endif

	_nPer         := (TMPC->C7_QUANT/TMPC->C7_QUJE) * 100
  	_nMedPer      := _nMedPer + _nPer
  	_nCont        := _nCont + 1
	_cFornece     := TMPC->A2_COD
	_cProduto     := TMPC->C7_PRODUTO

   TMPC->(DbSkip())
         
	If TMPC->C7_PRODUTO <> _cProduto

		// Calcula indice
      DbSelectArea("TRC")
		TRC->(DbSeek(_cProduto))
		If !TRC->(Found())
		   RecLock("TRC",.T.)
  			TRC->FORNECE := _cFornece
  			TRC->PRODUTO := _cProduto
			TRC->PERCENT := (_nMedPer / _nCont)
   	   MsUnLock("TRC")
   	   _nCont   := 0
			_nPer    := 0
		  	_nMedPer := 0
		Endif

	Endif

Enddo




Static Function fCalcEst()

	DbSelectArea("TRB")
	TRB->(DbGotop())

	While !TRB->(Eof())
				 
		MsProcTxt("Estoque de Seguranca: "+TRB->PRODUTO)

		_nLead    := 0
		_nAbc     := 0
		_TaxaServ := 1
		_DiaUteis := mv_par01
		_IndQuali := (mv_par02 / 100)
		_VarDeman := (mv_par03 / 100)
		
		// Obtem o Lead Time B1_PE
		DbSelectArea("SB1")
		SB1->(DbSeek(xFilial("SB1")+TRB->PRODUTO))
		If SB1->(Found())
        	_nLead := SB1->B1_LT
		Endif

		// Obtem o Indice de classificacao ABC
		DbSelectArea("SB3")
		SB3->(DbSeek(xFilial("SB3")+TRB->PRODUTO))
		If SB3->(Found())
			If     SB3->B3_CLASSE == "A"
	        	_nAbc := 1
			Elseif SB3->B3_CLASSE == "B"
	        	_nAbc := 0.95
			Elseif SB3->B3_CLASSE == "C"
	        	_nAbc := 0.8
			Else
	        	_nAbc := 0.8
			Endif	        	
		Endif         	

		// Obtem taxa de servico 
		DbSelectArea("TRC")
		TRC->(DbSeek(TRB->COMP))
		If TRC->(Found())
			_TaxaServ := (TRC->PERCENT / 100)
   	Endif         	

		_nDc := ((_nLead * _IndQuali * _TaxaServ * _VarDeman) / _nAbc)
		_nEs := (TRB->QUANT / _DiaUteis) * _nDc

	   RecLock("TRB",.F.)
		TRB->ESTOQ := INT(_nEs)
  	   MsUnLock("TRB")		

		DbSelectArea("TRB")
		TRB->(DbSkip())
 	   
	 Enddo

Return


Static Function fDadosEstoq()
aCols     := {}
DbSelectArea("TRB")
TRB->(DbGotop())
While !TRB->(Eof())
	AADD(aCols,{TRB->COMP,TRB->DESCRIC,TRB->QUANT,TRB->ESTOQ,Space(1)})
	DbSelectArea("TRB")
	TRB->(DbSkip())
Enddo
	
nMax      := Len(aCols)
aHeader   := {}
Aadd(aHeader,{"Produto"   ,  "UM","@!"            ,15,0,".F.","","C","SC7"})
Aadd(aHeader,{"Descricao",   "UM","@!"           ,40,0,".F.","","C","SC7"})
Aadd(aHeader,{"Demanda",     "UM","@E 99,999,999,999.99" ,16,2,".F.","","N","SC7"})
Aadd(aHeader,{"Estoque" ,    "ESTOQ","@E 99,999,999,999.99" ,16,2,".T.","","N","SC7"})
Aadd(aHeader,{" ",           "UM","@!",1,0,".F.","","C","SC7"})
   
@ 167,098 To 588,785 Dialog dlgEstoque Title "Estoque de Seguranca"
@ 010,006 TO 190,335 MULTILINE MODIFY OBJECT oMultiline
@ 196,280 BmpButton Type 1 Action fGravaEstoq()
@ 196,310 BmpButton Type 2 Action Close(dlgEstoque)
oMultiline:nMax := Len(aCols)
Activate Dialog dlgEstoque
              
Return


Static Function fGravaEstoq()

If MsgBox("Confirma gravacao do Estoque de Seguranca","Estoque de Seguranca","YESNO")
	For i := 1 To Len(aCols)
		DbSelectArea("SB1")
	   SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aCols[i,1]))
		If Found()
		   RecLock("SB1",.F.)
			SB1->B1_ESTSEG := aCols[i,4]
	  	   MsUnLock("SB1")		
		Endif
	Next
Endif	
Close(dlgEstoque)

Return
