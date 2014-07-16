/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHCOM060 ºAutor  ³ Guilherme D. Camargo º Data ³  27/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±  ºDesc.     ³ RETORNO DE SC EXCLUÍDA POR RESÍDUO                         º±±
±±  º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso         ³ COMPRAS		                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include 'topconn.ch'
#include 'colors.ch'

User Function NHCOM060()
Private cCadastro := "Retorno de SC"
Private aRotina   := {}
Private aSize    := MsAdvSize()
Private bOk        := {|| }
Private bCanc      := {||oDlg:End()}

SetPrvt("cMarca,_aXDBF,_cArqXDBF,aCampos,cCadastro,aRotina,oDlgLocalNF,oDlgParamNF,cAl,_dData,_dDataA,aOldRotina,_cArmz,_cScNum")
	aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"       , 0 , 1})
	aAdd(aRotina,{ "Visualizar"	    ,"AxVisual" 	  , 0 , 2})
	aAdd(aRotina,{ "Retornar"       ,"u_com60Ret"     , 0 , 5})
	dbSelectArea("SC1")
	SET FILTER TO SC1->C1_RESIDUO = 'S'
	DBGOTOP()
	mBrowse(6,1,22,75,"SC1",,,,,,)
	dbSelectArea("SC1")
	SET FILTER TO
Return

/* -----------------------------------------------------------------------
   ------ Função carrega a tela para selecionar os itens a retornar ------
   ----------------------------------------------------------------------- */
User Function com60Ret()
Local _cLgAlt
Local _aUser

	bOk := {|| Processa( {|| U_f60Grv() }, "Aguarde!")}
	cMarca := GetMark()
	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)

	// Cria Campos para mostrar no Browser
	_cArqXDBF := CriaTrab(NIL,.f.)

	_aXDBF    := {}
	
	AADD(_aXDBF,{"OK"         	,"C", 02,	0	})
	AADD(_aXDBF,{"NumSC"		,"C", 06,	0	})
	AADD(_aXDBF,{"ItemSC"		,"C", 04,	0	})
	AADD(_aXDBF,{"Produto"		,"C", 15,	0	})
	AADD(_aXDBF,{"Desc" 		,"C", 200,	0	})
	AADD(_aXDBF,{"QtdOrig"		,"N", 13,	4	})
	AADD(_aXDBF,{"CCusto"		,"C", 09,	2	})
	
	AADD(_aXDBF,{"LgnInc"		,"C", 17,	2	})
	AADD(_aXDBF,{"LgnAlt"		,"C", 17,	2	})
	
	If SELECT("XDBF") > 0
		XDBF->(DbCloseArea() )
	EndIf
	
	DbCreate(_cArqXDBF,_aXDBF)
	DbUseArea(.T.,,_cArqXDBF,"XDBF",.F.)
	
	aCampos := {}
	Aadd(aCampos,{"OK"        	,"C", "  "             		,"@!"	 	})
	Aadd(aCampos,{"NumSC"		,"C", "Número da Sc"		,"@!S15" 	})
	Aadd(aCampos,{"ItemSC"		,"C", "Item da SC"			,"@!S10"	})
	Aadd(aCampos,{"Produto"		,"C", "Produto"				,"@!"	 	})
	Aadd(aCampos,{"Desc"		,"C", "Descrição"			,"@!S30" 	})
	Aadd(aCampos,{"QtdOrig"		,"N", "Qtde Orig."			,"@!S10"	})
	Aadd(aCampos,{"CCusto"		,"C", "C. Custo"			,"@!"	 	})
	
	Aadd(aCampos,{"LgnInc"		,"C", "Login Inc."			,"@!"	 	})
	Aadd(aCampos,{"LgnAlt"		,"C", "Login Alt."			,"@!"	 	})
	
	
	_cScNum := SC1->C1_NUM	
	SC1->(DbSetOrder(1)) // Filial + Numero + Item
	SC1->(DbSeek(xFilial("SC1")+_cScNum))	

	If SC1->(!Eof())
		While SC1->C1_NUM == _cScNum
			RecLock("XDBF",.T.)
				XDBF->NumSC		:= SC1->C1_NUM
				XDBF->ItemSC	:= SC1->C1_ITEM
				XDBF->Produto	:= SC1->C1_PRODUTO
				XDBF->Desc		:= SC1->C1_DESCRI
				XDBF->QtdOrig	:= SC1->C1_QTDORIG
				XDBF->CCusto	:= SC1->C1_CC
				
				XDBF->LgnInc	:= Subs(EMBARALHA(SC1->C1_USERLGI,1),1,AT(" ",EMBARALHA(SC1->C1_USERLGI,1)))
				
				_cLgAlt := Subs(EMBARALHA(SC1->C1_USERLGA,1),1,AT(" ",EMBARALHA(SC1->C1_USERLGA,1)))
				_cLgAlt := Substr(_cLgAlt,3,6)
				PswOrder(1) // Pesquisa por Id de usuario
				PswSeek(_cLgAlt,.T.)
				_aUser := PswRet(1)
				XDBF->LgnAlt	:= _aUser[1][2]//Retorna o Login
								
			MsUnLock("XDBF")
			SC1->(DbSkip() )
		Enddo
	Endif

	XDBF->(dbgotop())
                 
	//-- TELA
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
	oDlg := MsDialog():New(20,20,300,780,"Retorno de SC!",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	//-- BOTOES MARCA DESMARCA
	oBtn1 := tButton():New(10 ,10,"Marcar Todos"	, oDlg,{||fMarkAll(oMark1,.T.,"XDBF")},50,10,,,,.T.)
	oBtn2 := tButton():New(10 ,65,"Desmarcar Todos" , oDlg,{||fMarkAll(oMark1,.F.,"XDBF")},50,10,,,,.T.)

	oMark1 := MsSelect():New("XDBF","OK",nil,aCampos,.F.,@cMarca,{25,10,120,380})

	oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)
	
	XDBF->(dbCloseArea())
	
Return                                                                

/* ------------------------------------------
   --- Função que Marca/Desmarca os itens ---
   ------------------------------------------ */
Static Function fMarkAll(oObj,lMarca,cTabMark)
Local aOld := getArea()
Local nRecno
	dbSelectArea(cTabMark)
	nRecno := recno()
	dbGotop()
	While !Eof()
		RecLock(cTabMark,.F.)
			If lMarca
				&(cTabMark+"->OK") := cMarca
			Else
				&(cTabMark+"->OK") := "  "
			Endif
		MsUnlock(cTabMark)
		dbSkip()
	EndDo
	dbGoto(nRecno)
	oObj:oBrowse:Refresh()
	dbSelectArea(aOld[1])
	dbSetOrder(aOld[2])
	dbGoTo(aOld[3])
Return

/*	---------------------------------------------------------------
	-- Função que retorna os itens das SC que foram selecionados --
	---------------------------------------------------------------	*/
User Function f60Grv()

	DbSelectArea("XDBF")
	XDBF->(DbGoTop())
	ProcRegua(XDBF->(RecCount()))
	While XDBF->(!Eof())
		If XDBF->OK == cMarca
			f60QryExc(XDBF->ItemSC)
		Endif
		IncProc("Retornando as SC selecionadas...")
		XDBF->(DbSkip())
	Enddo
	oDlg:End()
Return

/*	-----------------------------------------------------------
	-- Função que executa a query de retorno dos itens da SC --
	-----------------------------------------------------------	*/
Static Function f60QryExc(_ItemSC)
Local _cQuery
Local cErro

	_cQuery := "UPDATE " +  RetSqlName( 'SB2' )
	_cQuery += " SET B2_SALPEDI = B2_SALPEDI + C1.C1_QTDORIG"
	_cQuery += " FROM " +  RetSqlName( 'SC1' ) + " C1, " + RetSqlName( 'SB2' ) + " B2"
	_cQuery += " WHERE C1.D_E_L_E_T_ = '' AND B2.D_E_L_E_T_ = ''"
	_cQuery += " AND C1.C1_RESIDUO ='S'"
	_cQuery += " AND C1.C1_LOCAL = B2.B2_LOCAL"
	_cQuery += " AND C1.C1_PRODUTO = B2.B2_COD"
	_cQuery += " AND C1.C1_FILIAL = '" + xFilial("SC1") + "'"
	_cQuery += " AND B2.B2_FILIAL = '" + xFilial("SB2") + "'"
	_cQuery += " AND C1.C1_NUM = '" + _cScNum + "'"
	_cQuery += " AND C1.C1_ITEM = '" + _ItemSC + "'"
	_cQuery += " AND C1.C1_QUANT = 0"
	
	If TCSQLExec(_cQuery) < 0 //Executa a query
	   cErro := TCSQLERROR()
	   ALERT(cErro)
	Endif  
	
	_cQuery := "UPDATE " +  RetSqlName( 'SC1' )
	_cQuery += " SET C1_QUANT = C1_QTDORIG,"
	_cQuery += " C1_RESIDUO = '',"
	_cQuery += " C1_APROV = ''"
	_cQuery += " FROM " + RetSqlName( 'SC1' )
	_cQuery += " WHERE D_E_L_E_T_ = ''"
	_cQuery += " AND C1_NUM = '" + _cScNum + "'"
	_cQuery += " AND C1_ITEM = '" + _ItemSC + "'"
	_cQuery += " AND C1_QUANT = 0"
	_cQuery += " and C1_RESIDUO ='S'"
	
	If TCSQLExec(_cQuery) < 0 //Executa a query
	   cErro := TCSQLERROR()
	   ALERT(cErro)
	Endif
Return