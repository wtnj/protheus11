/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHPCP011  ³ Autor ³ João Felipe da Rosa    Data ³ 13/08/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RELEASE X FORNECEDORES                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function nhpcp011()

SetPrvt("CCADASTRO,AROTINA,")

Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5 } 
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private cD1Emissao
Private cD1Serie
Private cD1Doc

Processa({||fAtualiza()},"Atualizando Release...")

cCadastro := OemToAnsi("Programação de Entregas")
aRotina := {{ "Pesquisa"		,"AxPesqui"     , 0 , 1},;
            { "Visualizar"   	,'U_fPCP11(1)' 	, 0 , 2},;
            { "Incluir"   		,'U_fPCP11(2)'  , 0 , 3},;
            { "Alterar"   		,'U_fPCP11(3)'  , 0 , 5},;
            { "Excluir"   		,'U_fPCP11(4)'	, 0 , 4},;
            { "Imprimir"   		,'U_fPCPIMP()'	, 0 , 3},;
            { "Rel. Obs"        ,'U_NHPCP016()' , 0 , 3},;
            { "Atualizar"  		,'U_fPCP11(5)'	, 0 , 3},;
            { "T-System"   		,'U_fPCPX01()'	, 0 , 3},;
            { "Layout"   		,'U_NHPCP039()'	, 0 , 3},;
            { "Legenda"  		,'U_FLegRel()'	, 0 , 2}}            
            
mBrowse( 6, 1,22,75,"ZA9",,,,,,fCriaCor())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENCERRA OS RELEASES CUJO MES É MENOR QUE O MES ATUAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fAtualiza()
Local dDtIni
Local dDtFim
Local aQtd := {}
Local nTotEnt
Local nTotRel
Local nDif    := 0
Local nAtraso := 0

	//seleciona itens pendentes com mes menor do que o mes atual
	cQuery := "SELECT ZA9.ZA9_NUM, ZA0.ZA0_ITEM, ZA0.ZA0_PROD, ( "
	For x:=1 to 31
		cQuery += " ZA0.ZA0_PREV"+STRZERO(x,2)
		cQuery += Iif(x!=31,"+","")
	Next
	cQuery += ") AS TOTREL, ZA9.ZA9_STATUS, ZA9.ZA9_MES, ZA9.ZA9_ANO, ZA9.ZA9_FORNEC,ZA9.ZA9_LOJA"
	cQuery += " FROM "+RetSqlName("ZA0")+" ZA0, "+RetSqlName("ZA9")+" ZA9"
	cQuery += " WHERE ZA9.ZA9_NUM = ZA0.ZA0_NUM"
	cQuery += " AND ZA9.ZA9_MES < '"+STRZERO(MONTH(dDataBase),2)+"'" //DTFIM < '"+DtoS(Date())+"'"
	cQuery += " AND ZA9.ZA9_ANO < '"+STRZERO(YEAR(dDataBase),4)+"'"
	cQuery += " AND ZA9.ZA9_STATUS != 'E'"
	cQuery += " AND ZA9.D_E_L_E_T_ = ' ' AND ZA9.ZA9_FILIAL = '"+xFilial("ZA9")+"'"
	cQuery += " AND ZA0.D_E_L_E_T_ = ' ' AND ZA0.ZA0_FILIAL = '"+xFilial("ZA0")+"'"
	cQuery += " ORDER BY CAST(ZA9.ZA9_ANO AS VARCHAR)+CAST(ZA9.ZA9_MES AS VARCHAR) ASC"

	TCQUERY cQuery NEW ALIAS "ATU"

	ATU->(DbGoTop())
	
	ZA0->(dbSetOrder(1)) // filial + num + item
	ZA9->(DbSetOrder(1)) //filial + num

	While ATU->(!EoF())
	
		nDif    := fCalcDif(ATU->ZA9_NUM, ATU->ZA0_ITEM)
		nAtraso := fAtraso(ATU->ZA9_NUM, ATU->ZA0_ITEM)
		    
		//GRAVA O ATRASO NO ITEM DO RELEASE
		If ZA0->(dbSeek(xFilial("ZA0")+ATU->ZA9_NUM+ATU->ZA0_ITEM))
			RecLock("ZA0",.F.)
				ZA0->ZA0_ATRASO := nDif + nAtraso
			MsUnlock("ZA0")
		EndIf

        //ENCERRA O RELEASE
		If ZA9->(dbSeek(xFilial("ZA9")+ATU->ZA9_NUM))
			RecLock("ZA9",.F.)
				ZA9->ZA9_STATUS := "E"
			MsUnlock("ZA9")
		EndIf
		
		ATU->(DbSkip())

	EndDo
	ATU->(DbCloseArea())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fPCP11(nParam)

Local bOk         := {||fOk()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}
Local aButtons    := {}

SetPrvt("_cContat,_cForn,_cLoja,_cPedido,lEnd,_cMens")
nPar 	    := nParam
_cNum		:= ""
_cForn		:= Space(06)
_cLoja		:= Space(02)
_cForDesc	:= Space(20)
_cContat	:= ""
_cTel		:= ""
_cEmail		:= ""
_nMes       := 0
_nAno       := 0
_aMeses     := {}
_nEstoq		:= 0
_cUltNF		:= ""
_cPedido	:= ""
aHeader     := {}
aCols		:= {}
_aDias		:= {}
_aQtdEntr	:= {}
_cMens      := Space(50)
_n			:= 0

For x:=1 to 12
	aAdd(_aMeses,MesExtenso(x))
Next
	
	Aadd(aHeader,{"Item"         , "ZA0_ITEM"	,"@!"       	 , 4,0,".F.","","C","ZA0"}) 
	Aadd(aHeader,{"Produto"      , "ZA0_PROD"	,"@!"       	 ,15,0,"U_fDesc1()","","C","ZA0"}) 
	Aadd(aHeader,{"Descricao"    , "ZA0_DESC" 	,Repli("!",30)	 ,30,0,".T.","","C","ZA0"})
	Aadd(aHeader,{"Estoque"  	 , "SB2_QATU"  	,"999999999" 	 , 9,0,".F.","","N","SB2"})
	Aadd(aHeader,{"Atraso"		 , "ZA0_ATRASO" ,"99999999999" 	 ,11,0,".T.","","N","ZA0"})
	Aadd(aHeader,{"Diferenca"  	 , "SB2_QATU"   ,"99999999999" 	 ,11,0,".F.","","N","SB2"})
	Aadd(aHeader,{"NF Ref."   	 , "SD1_DOC" 	,"@!"	      	 , 6,0,".F.","","C","SD1"}) 
	Aadd(aHeader,{"Tipo Ped."  	 , "ZA0_TIPO" 	,"@!"	      	 , 1,0,".T.","","C","ZA0"}) 
	Aadd(aHeader,{"Pedido"       , "ZA0_PEDIDO"	,"@!"            , 6,0,".F.","","C","ZA0"})
	Aadd(aHeader,{"Frequencia"   , "ZA0_FREQ"	,"@!"			 , 1,0,".T.","","C","ZA0"}) 

	For x:=1 to 31           
		cx := strzero(x,2)
		Aadd(aHeader,{"Dia "+cx  , "ZA0_PREV"+cx ,"999999999"    ,9,0,".T.","","N","ZA0"}) 
	Next

	Aadd(aHeader,{"Prev.Mes1" 	 , "ZA0_PRMES1"	,"99999999999"   ,11,0,".T.","","N","ZA0"})   
	Aadd(aHeader,{"Prev.Mes2" 	 , "ZA0_PRMES2"	,"99999999999"   ,11,0,".T.","","N","ZA0"})   
	Aadd(aHeader,{"Prev.Mes3" 	 , "ZA0_PRMES3"	,"99999999999"   ,11,0,".T.","","N","ZA0"})   
	Aadd(aHeader,{"Cond.Pgto" 	 , "ZA0_COND"	,"@!"            ,03,0,".F.","","C","ZA0"})   
	Aadd(aHeader,{"Item"         , "ZA0_ITEMPE"	,"@!"            ,04,0,".F.","","C","ZA0"})   
	DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  

	If nPar==1 //visualiza
		aAdd(aButtons,{"SDUSETDEL",{||fAprovar()},"Aprova Release","Aprovar"})
		fCarrega()
	ElseIf nPar==2 //inclui
		aAdd(aButtons,{"MENURUN",{||Processa({||fCarreg()},"Carregando ítens... Aguarde")},"Carrega ítens do último release","Carrega"})
		_cNum := GetSXENum("ZA9","ZA9_NUM")
	ElseIf nPar==3 //altera
		fCarrega()
	ElseIf nPar==4 //exclui
		fCarrega()
	EndIf
	
	//ÚÄÄÄÄÄÄ¿
	//³ TELA ³
	//ÀÄÄÄÄÄÄÙ
	
	aAdd(aButtons,{"CRITICA",{||fObs()},"Inclui observação","Observação"})
    
	bEnchoice := {||EnchoiceBar(oDialog,bOk,bCanc,,aButtons)}

	//Monta a tela do release
	oDialog := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Release x Recebimento",,,,,CLR_BLACK,CLR_WHITE,,,.T.)	
	
	@ 020,015 Say "Número: " Color CLR_HBLUE Size 040,8 Object olRel
	@ 020,045 Say _cNum Size 040,8 Object oCod
	oCod:Setfont(oFont) 

	@ 020,100 Say "Fornecedor: " Color CLR_HBLUE Size 040,8 Object olForn 
	@ 018,138 Get _cForn Picture "@!" F3 "SA2" When(nPar == 2 .OR. nPar == 3) Size 40,8 Valid fForn()
	@ 018,180 Get _cLoja Picture "@!" When(nPar == 2  .OR. nPar == 3) Size 10,8 Valid fLoja() Object oLoja
	@ 018,194 Get _cForDesc Picture "@!" When .F. Size 160,8 Object oForDesc

	@ 032,015 Say "Contato: " Size 040,8 Object olCon
	@ 030,045 Get _cContat Picture "@!" When .F. Size 100,8	Object oContat
	@ 032,153 Say "Telefone: " Size 040,8 Object olTel
	@ 030,180 Get _cTel Picture "@!" When .F. Size 90,8 Object oTel
	@ 032,275 Say "Email: " Size 040,8 Object olEmail
	@ 030,290 Get _cEmail Picture "@!" When .F. Size 100,8 Object oEmail

	@ 044,015 Say "Mês:" Color CLR_HBLUE Size 040,8 Object olMes
	oCombo2 := TComboBox():New(42,45,{|u| if(Pcount() > 0,_nMes := u,_nMes)},;
		_aMeses,80,20,oDialog,,{||.T.},,,,.T.,,,,{|| nPar==2 .Or. nPar==3},,,,,"_nMes")

	@ 044,153 Say "Ano: " Color CLR_HBLUE Size 040,8 Object olAno
	@ 042,180 Get _nAno Picture "@e 9999" When(nPar==2 .OR. nPar==3) Size 30,8 Object oAno

	@ 056,015 Say "Mensagem: " Size 040,8 Object oMens 
	@ 054,045 Get _cMens Picture "@!" When(nPar==2 .OR. nPar==3) Size 200,8 Object ocMens
	
	DbSelectArea('ZA9')
	@ 68,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY DELETE OBJECT oMultiline

	If nPar==1 .Or. nPar==4  //visualiza ou exclui 
   		oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
	Endif

	oDialog:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA OS DADOS PARA VISUALIZAÇÃO, EXCLUSÃO OU ALTERAÇÃO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()
Local aQtd    := {}
Local nDif    := 0
Local nAtraso := 0

	_cNum    := ZA9->ZA9_NUM
    _cForn   := ZA9->ZA9_FORNEC
    _cLoja   := ZA9->ZA9_LOJA
	_cMens   := ZA9->ZA9_OBS
	_nMes    := ZA9->ZA9_MES
	_nAno    := ZA9->ZA9_ANO
	_cMens   := ZA9->ZA9_OBS

	DbSelectArea('SA2')
	SA2->(DbSetOrder(1)) //Filial + Cod + loja
	SA2->(DbSeek(xFilial('SA2')+AllTrim(_cForn)+AllTrim(_cLoja)))
	If SA2->(Found())
		_cForDesc := SA2->A2_NOME
		_cContat  := SA2->A2_CONTATO
		_cTel     := SA2->A2_TEL
		_cEmail   := SA2->A2_EMAIL
	EndIf
	
	ZA0->(DbSetOrder(1)) //filial + num  +item
	SB1->(DbSetOrder(1)) //filial + doc
	//ZAJ->(DbSetOrder(1)) //filial + produto

	If ZA0->(dbSeek(xFilial('ZA0')+_cNum))
	
		While ZA0->ZA0_NUM == _cNum
			If SB1->(dbSeek(xFilial('SB1')+ZA0->ZA0_PROD))
			
				nDif   := fCalcDif(ZA0->ZA0_NUM, ZA0->ZA0_ITEM)
//				If ZA9->ZA9_STATUS=="E"
					nAtraso := ZA0->ZA0_ATRASO
/*
				Else
					If Empty(ZA0->ZA0_ATRASO)
						nAtraso := fAtraso(ZA0->ZA0_NUM, ZA0->ZA0_ITEM)
					Else
						nAtraso := ZA0->ZA0_ATRASO
					EndIf
				EndIf
*/
				aAdd(Acols,{ZA0->ZA0_ITEM,;
							ZA0->ZA0_PROD,;
							SB1->B1_DESC,;
							U_NHSALDO(ZA0->ZA0_PROD,""),; //U_NHSALDO retorna o saldo no estoque, parametros: prod e local
							nAtraso,;
							nDif,;
						    fUltNF(ZA0->ZA0_PROD,_cForn,_cLoja),;
						    ZA0->ZA0_TIPO,;
						    ZA0->ZA0_PEDIDO,;
						    ZA0->ZA0_FREQ,;
						    ZA0->ZA0_PREV01,;
						    ZA0->ZA0_PREV02,;
						    ZA0->ZA0_PREV03,;
						    ZA0->ZA0_PREV04,;
						    ZA0->ZA0_PREV05,;
						    ZA0->ZA0_PREV06,;
						    ZA0->ZA0_PREV07,;
						    ZA0->ZA0_PREV08,;
						    ZA0->ZA0_PREV09,;
						    ZA0->ZA0_PREV10,;
						    ZA0->ZA0_PREV11,;
						    ZA0->ZA0_PREV12,;
						    ZA0->ZA0_PREV13,;
						    ZA0->ZA0_PREV14,;
						    ZA0->ZA0_PREV15,;
						    ZA0->ZA0_PREV16,;
						    ZA0->ZA0_PREV17,;
						    ZA0->ZA0_PREV18,;
						    ZA0->ZA0_PREV19,;
						    ZA0->ZA0_PREV20,;
						    ZA0->ZA0_PREV21,;
						    ZA0->ZA0_PREV22,;
						    ZA0->ZA0_PREV23,;
						    ZA0->ZA0_PREV24,;
						    ZA0->ZA0_PREV25,;
						    ZA0->ZA0_PREV26,;
						    ZA0->ZA0_PREV27,;
						    ZA0->ZA0_PREV28,;
						    ZA0->ZA0_PREV29,;
						    ZA0->ZA0_PREV30,;
						    ZA0->ZA0_PREV31,;
						    ZA0->ZA0_MES1,;
						    ZA0->ZA0_MES2,;
						    ZA0->ZA0_MES3,;
						    ZA0->ZA0_COND,;
						    ZA0->ZA0_ITEMPE,;
						    .F.})
						    
			EndIf
			
			ZA0->(DbSkip())
		EndDo	
	EndIf
	
	If nPar == 1 .Or. nPar == 4 //visualiza ou exclui
		
		For x:=1 to Len(aHeader)
			aHeader[x][6] := ".F."
		Next

	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ O PROXIMO ITEM DO RELEASE CHAMADO NO SX3 DO CAMPO ZA0_ITEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fZA0ITM()
Local cItem := ""
Local nItem := n

    For x:=1 to Len(aCols)-1
    	If Val(aCols[x][1]) >= nItem
	    	nItem := Val(aCols[x][1])+1
	    EndIf
	Next    

	cItem := StrZero(nItem,4)

Return(cItem)
          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fForn()  

	SA2->(DbSetOrder(1)) //filial + cod + loja
	SA2->(DbSeek(xFilial("SA2")+AllTrim(_cForn)))
	If !SA2->(Found())
		Alert("Fornecedor não cadastrado.Verifique!")
		Return .F.
	EndIf

Return(.T.)
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fLoja()
	DbSelectArea('SA2')
	DbSetOrder(1) //Filial + Cod + loja
	DbSeek(xFilial('SA2')+AllTrim(_cForn)+AllTrim(_cLoja))
	If SA2->(Found())
		_cForDesc := SA2->A2_NOME
		_cContat  := SA2->A2_CONTATO
		_cTel     := SA2->A2_TEL
		_cEmail   := SA2->A2_EMAIL
		oForDesc:Refresh()
		oContat:Refresh()
		oTel:Refresh()
		oEmail:Refresh()
	Else
		Alert("Loja não cadastrada. Verifique!")
		Return(.F.)
	EndIf
	If empty(_cLoja)
		Return .F.
	EndIf
Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³COMPLEMENTA O FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fDesc1()
Local cProd   := M->ZA0_PROD
Local _aCompl  := {}
Local _lRet    := .T.

	If Empty(_cForn) .Or. Empty(_cLoja)
		Alert("Por favor, digite o fornecedor e loja!")
		_lRet := .F.
	EndIf

	If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
	   	
	    SB1->(DbSetOrder(1))
	    If !SB1->(DbSeek(xFilial("SB1")+cProd))
	    	_lRet := .F.
		Endif
		
		Acols[n][4]  := U_NHSALDO(cProd,"")
	    Acols[n][7]  := fUltNF(cProd,_cForn,_cLoja)
	    
		DbSelectArea("SX7")
	Endif
	
	oMultiline:Refresh()                                    
	
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHSALDO  ºAutor  ³João Felipe da Rosa º Data ³  06/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRAZ O SALDO DO PRODUTO PASSADO COMO PARAMETRO             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHSaldo(cProd,cLocal)
Local nSaldo := 0
	
	If Empty(cLocal)
		SB1->(DbSetOrder(1)) //filial + cod
		SB1->(DbSeek(xFilial("SB1")+cProd))

   		If SM0->M0_CODIGO == 'NH' // WHB USINAGEM
    		If SB1->B1_TIPO$"MC/CC"  //materia prima consignada ou componente consignado
	    		cLocal := "03"
			Else
			    If SB1->B1_TIPO$"MP/CP/EB" //materia prima, componente comprado, embalagem
			   		cLocal := "02"
		   	 	Else
		    		cLocal := "01"
		    	EndIf
			EndIf
		ElseIf SM0->M0_CODIGO == 'FN' // WHB FUNDICAO
			cLocal := "32"
		EndIf
	EndIf
	
	cQuery := "SELECT TOP 1 (B2_QATU-B2_QEMPSA) AS SALDO"
	cQuery += " FROM "+RetSqlName('SB2')
	cQuery += " WHERE B2_COD = '"+cProd+"'"
	cQuery += " AND B2_LOCAL = '"+cLocal+"'"
	cQuery += " AND D_E_L_E_T_ = ''"

	TCQUERY cQuery NEW ALIAS 'TMP'      
	
	nSaldo := Iif(!Empty(TMP->SALDO),TMP->SALDO,0)

	TMP->(DbCloseArea())

Return nSaldo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A ULTIMA NOTA DE ENTRADA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fUltNF(cProd,cForn,cLoja)

	cQuery := "SELECT TOP 1 D1.D1_DOC,D1.D1_EMISSAO,D1.D1_SERIE"
	cQuery += " FROM "+RetSqlName("SD1") + " D1, " + RetSqlName( 'SF4' ) +" F4 "
	cQuery += " WHERE D1.D1_FORNECE = '"+cForn+"'"
	cQuery += " AND D1.D1_LOJA = '"+cLoja+"'"
	cQuery += " AND D1.D1_COD = '"+cProd+"'"
	cQuery += " AND D1.D1_TES = F4.F4_CODIGO"
	cQuery += " AND F4.F4_ESTOQUE = 'S'" //somente pega as notas que atualizam estoque
	cQuery += " AND D1.D1_TES != '196'" //Chamado 005229 do helpdesk
	cQuery += " AND D1.D_E_L_E_T_ = ' '"
	cQuery += " AND F4.D_E_L_E_T_ = ' '"
//	cQuery += " ORDER BY D1.D1_DTDIGIT DESC, D1.R_E_C_N_O_ DESC"
	cQuery += " ORDER BY D1.D1_DTDIGIT DESC, D1.D1_DOC DESC"
	
	TCQUERY cQuery NEW ALIAS "TMP"

	cUltNF     := Iif(!Empty(TMP->D1_DOC) ,TMP->D1_DOC ,"")
	cD1Emissao := TMP->D1_EMISSAO
	cD1Serie   := TMP->D1_SERIE
	cD1Doc     := TMP->D1_DOC

	TMP->(DbCloseArea())

Return cUltNF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO CHAMADA PELO GATILHO DO CAMPO ZA0_PEDIDO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fPed()
Local cQuery3
Local _cTipo   := M->ZA0_TIPO
Local _cFreq   := "1" //M->ZA0_FREQ
Local _nPosPro := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZAO_PROD" })  
Local _cCond   := Space(03)

	If _cTipo$"1"
		cQuery3 := " SELECT TOP 1 E4.E4_DESCRI AS DCOND,C7.C7_NUM AS PEDIDO,C7.C7_COND AS COND,C7.C7_ITEM AS ITEM"
		cQuery3 += " FROM "+RetSqlName('SC7') + " C7, " + RetSqlName( 'SE4' ) +" E4 "
		cQuery3 += " WHERE C7.C7_PRODUTO = '"+Acols[n][2]+"'"
		cQuery3 += " AND C7.D_E_L_E_T_ = ' '"
		cQuery3 += " AND E4.D_E_L_E_T_ = ' '"
//		cQuery3 += " AND C7.C7_FORNECE = '"+_cForn+"'"
//		cQuery3 += " AND C7.C7_LOJA = '"+_cLoja+"'"
		cQuery3 += " AND C7.C7_RESIDUO = ' '"
		cQuery3 += " AND C7.C7_COND =  E4.E4_CODIGO"				
		cQuery3 += " AND C7.C7_QUANT <> C7.C7_QUJE"				
	    cQuery3 += " ORDER BY C7.C7_EMISSAO DESC"
		TCQUERY cQuery3 NEW ALIAS "TMU"      	    
	ElseIf _cTipo$"2"
		cQuery3 := " SELECT TOP 1 E4.E4_DESCRI AS DCOND,C3.C3_NUM AS PEDIDO,C3.C3_COND AS COND,C3.C3_ITEM AS ITEM "
		cQuery3 += " FROM "+RetSqlName('SC3') + " C3, " + RetSqlName( 'SE4' ) +" E4 "
		cQuery3 += " WHERE C3.C3_PRODUTO = '"+Acols[n][2]+"'"
//		cQuery3 += " AND C3.C3_FORNECE = '"+_cForn+"'"
//		cQuery3 += " AND C3.C3_LOJA = '"+_cLoja+"'"
		cQuery3 += " AND C3.C3_RESIDUO = ' '"
		cQuery3 += " AND C3.C3_QUANT <> C3.C3_QUJE"
		cQuery3 += " AND C3.C3_COND =  E4.E4_CODIGO"
		cQuery3 += " AND C3.D_E_L_E_T_ = ' '"
		cQuery3 += " AND E4.D_E_L_E_T_ = ' '"
	    cQuery3 += " ORDER BY C3.C3_EMISSAO DESC"
		TCQUERY cQuery3 NEW ALIAS "TMU"      	    
	ElseIf _cTipo$"3" //Nada release somente p/ previsao
		acols[n][9]  := ""  
		acols[n][46] := ""  		
		_cCond := ""       

	Endif

	If Select('TMU') > 0	
	    If !Empty(TMU->PEDIDO)
			acols[n][9]  := TMU->PEDIDO                                    
			acols[n][46] := TMU->ITEM                                    		
			_cCond := TMU->COND 
		Else
			acols[n][9]  := ""  
			acols[n][46] := ""  		
			_cCond := ""       
		EndIf            
	
		TMU->(DbCloseArea())	
	EndIf
	
    oMultiline:Refresh()                                    	
	DbSelectArea("SX7")
Return(_cCond)

Static Function fQtdEntr(cProd,cForn,cLoja,dDtIni,dDtFim)
Local aQtd   := {} 
Local dDtRef := dDtIni

	If dDtFim < dDtIni
		alert("dDtFim < dDtIni! Funcao fQtdEntr - NHPCP011")
		return
	EndIf

	While(dDtRef <= dDtFim)
		aAdd(aQtd,{DtoC(dDtRef),0})
		dDtRef++
	EndDo
		
	If Select('TMV') > 0
		TMV->(DbCloseArea())
	EndIF			
	
	IF SM0->M0_CODIGO == "FN" .AND. ;
	   cForn == '999999' .AND. cLoja == '01' //Se for para fundição, pega da ZBB

		cQuery := " SELECT ZBA.ZBA_DATA AS DTDIGIT, SUM(ZBB.ZBB_QUANT) AS QUANT "
		cQuery += " FROM ZBAFN0 ZBA, ZBBFN0 ZBB" //TEM QUE SER DA FUNDICAO
		cQuery += " WHERE ZBA.ZBA_NUM = ZBB.ZBB_NUM"
		cQuery += " AND ZBA.ZBA_DATA BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFim)+"'"
		cQuery += " AND ZBB.ZBB_COD = '"+cProd+"'"
		cQuery += " AND ZBA.ZBA_STATUS = 'E'"
		cQuery += " AND ZBB.ZBB_FILIAL = '"+XFILIAL("ZBB")+"' AND ZBB.D_E_L_E_T_ = ''"
		cQuery += " AND ZBA.ZBA_FILIAL = '"+XFILIAL("ZBA")+"' AND ZBA.D_E_L_E_T_ = ''"
		cQuery += " GROUP BY ZBA.ZBA_DATA"
		cQuery += " ORDER BY ZBA.ZBA_DATA" 
	Else
		cQuery := "SELECT D1_DTDIGIT AS DTDIGIT, SUM(D1.D1_QUANT) AS QUANT "
		cQuery += " FROM "+RetSqlName("SD1") + " D1, " + RetSqlName( 'SF4' ) +" F4 "
		cQuery += " WHERE D1.D1_COD = '"+cProd+"'"
		cQuery += " AND D1.D1_FORNECE = '"+cForn+"' AND D1.D1_LOJA = '"+cLoja+"'"
		cQuery += " AND D1.D1_DTDIGIT BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFim)+"'"
	    cQuery += " AND D1.D1_TES = F4.F4_CODIGO"	
	    cQuery += " AND F4.F4_ESTOQUE = 'S'" //somente pega as notas que atualizam estoque
		cQuery += " AND D1.D_E_L_E_T_ = ' '"
	    cQuery += " AND F4.D_E_L_E_T_ = ' '"   
	    cQuery += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
	    cQuery += " AND F4.F4_FILIAL = '"+xFilial("SF4")+"'"
	    cQuery += " GROUP BY D1_DTDIGIT"
	    cQuery += " ORDER BY D1_DTDIGIT"
	EndIf
				
	TCQUERY cQuery NEW ALIAS 'TMV'
	         
	TcSetField("TMV","DTDIGIT","D")  // Muda a data de string para date    
	                   
	While !TMV->(EOF())
		_n := aScan(aQtd,{|x| x[1] == DtoC(TMV->DTDIGIT)})
		If _n!=0
			aQtd[_n][2] := TMV->QUANT
			TMV->(dbSkip())
		EndIf
	EndDo

Return(aQtd)

//ÚÄÄÄÄÄÄ¿
//³GRAVA ³
//ÀÄÄÄÄÄÄÙ
Static Function fOK()

	If (nPar==2 .Or. nPar==3) .and. !fValida()
		Return
	EndIf

	If nPar==2
		fInclui()
	ElseIf nPar==3 
		fAltera()
	ElseIf nPar==4
		fExclui()
	EndIf
	
	Processa({||fAtualiza()},"Atualizando Release...")

	oDialog:End()
	
Return
    
//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()
	
	RecLock("ZA9",.T.)
		ZA9->ZA9_FILIAL := xFilial("ZA9")
		ZA9->ZA9_NUM	:= _cNum
		ZA9->ZA9_FORNEC	:= _cForn
		ZA9->ZA9_LOJA	:= _cLoja
		ZA9->ZA9_FNOME	:= _cForDesc
		ZA9->ZA9_DATA	:= Date()
		ZA9->ZA9_MES    := oCombo2:nAt
		ZA9->ZA9_ANO    := _nAno
		ZA9->ZA9_STATUS := "P"
		ZA9->ZA9_RESP   := Upper(cUserName)
		ZA9->ZA9_OBS    := _cMens
	MsUnLock('ZA9')
		
	For x:=1 to len(Acols)
		
		If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][2])
			RecLock('ZA0',.T.)
				ZA0->ZA0_FILIAL := xFilial('ZA0')
				ZA0->ZA0_NUM	:= _cNum
				ZA0->ZA0_ITEM   := Acols[x][1]
				ZA0->ZA0_DATA	:= Date()
				ZA0->ZA0_PROD   := Acols[x][2]
				ZA0->ZA0_ATRASO := Acols[x][5]
				ZA0->ZA0_TIPO   := Acols[x][8]
				ZA0->ZA0_PEDIDO := Acols[x][9]
				ZA0->ZA0_FREQ	:= Acols[x][10]

				For y:=1 to 31
					cCmd := "ZA0->ZA0_PREV"+STRZERO(y,2)+" := Acols[x]["+StrZero(y+10,2)+"]"
					&(cCmd)
				Next

				ZA0->ZA0_MES1   := Acols[x][42]
				ZA0->ZA0_MES2   := Acols[x][43]
				ZA0->ZA0_MES3   := Acols[x][44]
				If ValType(Acols[x][45]) == "C"
					ZA0->ZA0_COND   := Acols[x][45]
				Else
					ZA0->ZA0_COND   := ""
				EndIf
				ZA0->ZA0_ITEMPE := Acols[x][46]
			
			MsUnLock('ZA0')
			
			fAtuAtraso(_cNum, Acols[x][1],Acols[x][5]) //grava o atraso no release anterior
			
		Endif
	Next 
	
	
	ConfirmSX8()
	
Return
 
//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()
			
	If Upper(Alltrim(cUserName)) <> Upper(Alltrim(ZA9->ZA9_RESP))
		If !(Upper(Alltrim(cUserName))$"MARIOCP/EMERSONDP") //usuarios liberados para alterar qualquer release
			Alert("Usuário sem permissão para alterar.")
			Return .F.
		EndIf
	EndIf
	
/*
	If ZA9->ZA9_STATUS=='E'
		Alert("Release já encerrado!")
		Return .F.
	EndIf
*/

	RecLock("ZA9",.F.)
		ZA9->ZA9_FORNEC	:= _cForn
		ZA9->ZA9_LOJA	:= _cLoja
		ZA9->ZA9_MES    := oCombo2:nAt
		ZA9->ZA9_ANO    := _nAno
		ZA9->ZA9_OBS    := _cMens
	MsUnlock("ZA9")

	ZA9->(DbSetOrder(1)) //filial + num
	ZA0->(DbSetOrder(1)) //filial + num + ITEM
	
	For x:=1 to len(Acols)
		ZA0->(DbSeek(xFilial("ZA0")+_cNum+Acols[x][1]))
		If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][1])
			If ZA0->(Found())
				
				RecLock('ZA0',.F.)
					ZA0->ZA0_ITEM := Acols[x][1]
					ZA0->ZA0_PROD   := Acols[x][2]
					ZA0->ZA0_ATRASO := Acols[x][5]
					ZA0->ZA0_TIPO   := Acols[x][8]
					ZA0->ZA0_PEDIDO := Acols[x][9]
					ZA0->ZA0_FREQ   := Acols[x][10]

					For y:=1 to 31
						cCmd := "ZA0->ZA0_PREV"+STRZERO(y,2)+" := Acols[x]["+StrZero(y+10,2)+"]"
						&(cCmd)
					Next
					
					ZA0->ZA0_MES1   := Acols[x][42]
					ZA0->ZA0_MES2   := Acols[x][43]
					ZA0->ZA0_MES3   := Acols[x][44]
					ZA0->ZA0_COND   := Acols[x][45]
					ZA0->ZA0_ITEMPE := Acols[x][46]
				MsUnLock('ZA0')
				
				fAtuAtraso(_cNum, Acols[x][1],Acols[x][5]) //grava o atraso no release anterior				

			Else
				RecLock('ZA0',.T.)
					ZA0->ZA0_FILIAL := xFilial('ZA0')
					ZA0->ZA0_NUM	:= _cNum
					ZA0->ZA0_ITEM   := Acols[x][1]
					ZA0->ZA0_DATA	:= Date()
					ZA0->ZA0_PROD   := Acols[x][2]
					ZA0->ZA0_ATRASO := Acols[x][5]
					ZA0->ZA0_TIPO   := Acols[x][8]
					ZA0->ZA0_PEDIDO := Acols[x][9]
					ZA0->ZA0_FREQ	:= Acols[x][10]
	
					For y:=1 to 31
						cCmd := "ZA0->ZA0_PREV"+STRZERO(y,2)+" := Acols[x]["+StrZero(y+10,2)+"]"
						&(cCmd)
					Next
	
					ZA0->ZA0_MES1   := Acols[x][42]
					ZA0->ZA0_MES2   := Acols[x][43]
					ZA0->ZA0_MES3   := Acols[x][44]
					If ValType(Acols[x][45]) == "C"
						ZA0->ZA0_COND   := Acols[x][45]
					Else
						ZA0->ZA0_COND   := ""
					EndIf
					ZA0->ZA0_ITEMPE := Acols[x][46]
				
				MsUnLock('ZA0')

				fAtuAtraso(_cNum, Acols[x][1],Acols[x][5]) //grava o atraso no release anterior						
				
			EndIf
		Else //Exclui do arquivo ZA0 a linha qdo esta deletada
			
			If ZA0->(Found())	
				RecLock("ZA0",.F.)
  					ZA0->(DbDelete())
				MsUnLock("ZA0")
			EndIf
		EndIf	
	Next
	
Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()
	If Upper(Alltrim(CUSERNAME)) <> Upper(Alltrim(ZA9->ZA9_RESP))	        
	   	Alert("Usuário sem permissão para excluir.")
	   	Return .F.
	EndIf

	If MsgYesNo("Tem certeza que deseja excluir a programação?")
		RecLock("ZA9",.F.)
			ZA9->(DbDelete())
		MsUnLock("ZA9")
		ZA0->(DbSetOrder(1))//filial + num + item
		ZAJ->(DbSetOrder(1)) //filial + produto
		For x:=1 to Len(Acols)
			If ZA0->(DbSeek(xFilial('ZA0')+_cNum+Acols[x][1]))
				RecLock("ZA0",.F.)
					ZA0->(DbDelete())
				MsUnLock("ZA0")
			EndIf
			
/*
			ZAJ->(DbSeek(xFilial("ZAJ")+Acols[x][2]))
			If ZAJ->(Found())
				RecLock('ZAJ',.F.)
					ZAJ->(DbDelete())
				MsUnlock('ZAJ')
			EndIf
*/			
		Next
	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENCERRA A JANELA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEnd() 

	If nPar==2 //inclui
		RollBackSx8()
	EndIf
   	oDialog:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CADASTRO DO RELEASE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValida()
	
	If Empty(_cForn) .or. Empty(_cLoja)
		Alert("Informe o fornecedor e a loja!")
		REturn .F.
	EndIf
	
	If Empty(oCombo2:nAt)
		Alert("Informe o mês do release!")
		Return .F.
	EndIf
	
	If Empty(_nAno)
		Alert("Informe o ano do release!")
		Return .F.
	EndIf
	
	If nPar <> 4 //diferente de excluir
		For x:=1 to len(Acols)         
		
		   If !Acols[x][len(aHeader)+1] .AND. !Empty(aCols[x][2])
		
			  If !Acols[x][10]$"1/2/3/4/5/6"
			 	 MsgAlert("Frequencia deve ser 1,2,3,4,5 ou 6. Verifique!")
				 Return(.F.)
			  EndIf

           Endif
	    Next

		If nPar == 2 //inclui
		
			//verifica se já não existe release para este fornecedor/loja mes/ano
			cQuery := " SELECT COUNT(*) AS QTD FROM "+RetSqlName("ZA9")
			cQuery += " WHERE ZA9_MES  = "+Alltrim(Str(oCombo2:nAt))
			cQuery += " AND ZA9_ANO    = "+AllTrim(Str(_nAno))
			cQuery += " AND ZA9_FORNEC = '"+_cForn+"'"
			cQuery += " AND ZA9_LOJA   = '"+_cLoja+"'"
			cQuery += " AND D_E_L_E_T_ = ''"
			cQuery += " AND ZA9_FILIAL = '"+xFilial("ZA9")+"'"
			
			TCQUERY cQuery NEW ALIAS "TRA1"
			
			If TRA1->QTD > 0
				Alert("Já existe um release programado para este mes/ano para este fornecedor/loja!")
				TRA1->(dbCloseArea())
				return .F.
			EndIf
			
			TRA1->(dbCloseArea())
		EndIf
	EndIf
Return .T.
                                           
Static Function fCriaCor()       

	Local aLegenda :=	{ {"BR_VERDE"    , "Aprovada"  },;
	  					  {"BR_VERMELHO" , "Encerrada" },;
	  					  {"BR_AMARELO"  , "Pendente"  }}

	Local uRetorno := {}
	Aadd(uRetorno, { 'ZA9_STATUS = "A"' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZA9_STATUS = "E"' , aLegenda[2][1] } )
	Aadd(uRetorno, { 'ZA9_STATUS = "P"' , aLegenda[3][1] } )
	
Return(uRetorno)          

Static Function fAprovar()
lEnd  := .T.

   MsAguarde ( {|lEnd| fGeraAE() },"Processando","Aguarde Gerando AE/SC...",.T.)
   
Return   
   
Static Function fGeraAE() //Gera autorizacao de entrega e solicitacao de compras
Local _nx
Local _cProd  := Space(15) 
Local _cAlmox := Space(02)
Local _dtIni 
Local aCabAE  := {}
Local aCabSC  := {}
Local aItemAE := {} 
Local aItemSC := {} 
Local nopc    :=3 //inclusao      
Local _cNumAE := Space(06)
Local _cNumSC := Space(06)
Local _lGeraAE:= .F.
Local _lGeraSC:= .F.                    

Local _lCabAE := .F. //Cabeçalho da autorizacao de entrega gerado
Local _lCabSC := .F. //Cabeçalho da solicitacao de compras gerada

Private lMsHelpAuto := .t.  // se .t. direciona as mensagens de help para o arq. de log
Private lMsErroAuto := .f. //necessario a criacao, pois sera  atualizado quando houver                         

If ZA9->ZA9_STATUS == "E"
   MsgBox( "Release finalizado!", "Atencao", "ALERT" )	
   Return(.F.)
ElseIf ZA9->ZA9_STATUS == "A"
   MsgBox( "Release aprovado!", "Atencao", "ALERT" )	
   Return(.F.)
EndIf

//gerar rotina automatica do mata125     

SB1->(DbSetOrder(1)) //filial + cod
SC3->(DbSetOrder(1)) //filial + cod

For _nx:=1 to len(Acols)

	If !Acols[_nx][len(aHeader)+1] .And. !Empty(Acols[_nx][1])

	  If Acols[_nx][8]$"2" // Autorizacao de entrega 						       
	  
	     If !_lCabAE  //Cabeçalho da autorizacao de entrega gerado
	        _lCabAE := .T. //Cabecalho A.E. gerado
		    _cNumAE := GetSX8Num("SC7","C7_NUM")
			aCabAE:={{"C7_NUM" ,_cNumAE ,Nil},;   // Data de Emissao
				   {"C7_EMISSAO" ,dDataBase ,Nil},; // Data de Emissao
				   {"C7_FORNECE" ,_cForn ,Nil},;  // Fornecedor
				   {"C7_LOJA"    ,_cLoja ,Nil},;  // Loja do Fornecedor
				   {"C7_CONTATO" ,_cContat,Nil},; // Contato
				   {"C7_COND"    ,Acols[_nx][45] ,Nil},; // Condicao de pagamento
				   {"C7_FILENT"  ,"01" ,Nil}}   // Filial Entrega
	     Endif
		 SB1->(DbSeek(xFilial("SB1")+Acols[_nx][2]))
		 If SM0->M0_CODIGO == 'NH' // WHB USINAGEM
		    If SB1->B1_TIPO$"MC/CC"  //materia prima consignada ou componente consignado
    	          _cAlmox := "03"	
 	  	    Else
		  	   If SB1->B1_TIPO$"MP/CP/EB" //materia prima, componente comprado, embalagem
		          _cAlmox := "02"
		       Else
		          _cAlmox := "01"
		       Endif   
		    Endif	   
		 ElseIf SM0->M0_CODIGO == 'FN' // WHB FUNDICAO
		    _cAlmox := "32"
	     EndIf

		SC3->(DbSeek(xFilial("SC3")+Acols[_nx][9]+Acols[_nx][46]))
		If SC3->(Found())
		   _dtIni  :=  CtoD("01/"+strzero(ZA9->ZA9_MES,2)+"/"+strzero(ZA9->ZA9_ANO,4))  //Data inicial p/ gerar a primeira A.E. na segunda

		   RecLock("SB1",.F.)
		      SB1->B1_CONTRAT := "S"
		   MsUnlock("SB1")

  	       For _x :=1 to 31//val(_cQtdSem)  // Qtde de semanas, 4 ou 5

  	           If Acols[_nx][10+_x] > 0 // So gera A.E. p/ qtde maior que zero
  	              _lGeraAE := .T. //Confirma a geracao da autorizacao de entrega
  	                 
			      Aadd(aItemAE,{{"C7_ITEM" ,Iif(len(aItemAE)==0,"0001",StrZero(Len(aItemAE)+1,4)),  Nil},; //Numero do Item
							    {"C7_PRODUTO",Acols[_nx][2],Nil},; //Codigo do Produto                             
							    {"C7_QUANT"  ,Acols[_nx][10+_x],Nil},; //Quantidade Semana1,Semana2,Semana3,Semana4
							    {"C7_PRECO"  ,SC3->C3_PRECO,Nil},; //Preco
							    {"C7_NUMSC"  ,SC3->C3_NUM  ,Nil},; //numero do pedido em aberto
						    	{"C7_ITEMSC" ,SC3->C3_ITEM ,Nil},; //item do pedido em aberto  
 							    {"C7_DATPRF" ,_dtIni ,      Nil},; //Data De Entrega
							    {"C7_SIGLA"  ,SC3->C3_SIGLA,Nil},; // sigla								  
					            {"C7_CC"     ,SC3->C3_CC,   Nil},; //centro de custo							  	           	           								  								  
        					    {"C7_CONTA"  ,SC3->C3_CONTA,Nil},; // conta contabil							  							  								  
							    {"C7_LOCAL"  ,_cAlmox ,     Nil}}) //Localizacao 

			   Endif			  
			   _dtIni++ //  mais 1 dia para gerar a A.E.
		   Next _x

	    Else
	  	   MsgBox( "Autorizacao de Entrega nao Foi Gerada por nao Encontrar o Pedido em Aberto!", "Atencao", "STOP" )	
		   Return(.F.)	        
	    Endif
	  
	  Elseif Acols[_nx][8]$"1" // Solicitacao de compras
	  
	         If !_lCabSC  //Cabeçalho da Solicitcao de compras gerada
	             _lCabSC := .T. //Cabecalho SC. gerado
		         _cNumSC  := GetSX8Num("SC1","C1_NUM")
		         
	             aCabSC:= {{"C1_NUM",_cNumSC ,NIL},;  //GetSxeNum("SC1","C1_NUM"),NIL},;
                           {"C1_SOLICIT",Alltrim(Upper(CUSERNAME)),NIL},;
                           {"C1_EMISSAO",ddatabase,NIL}}
	         Endif		         

		     SB1->(DbSeek(xFilial("SB1")+Acols[_nx][2]))
		     If SM0->M0_CODIGO == 'NH' // WHB USINAGEM
		        If SB1->B1_TIPO$"MC/CC"  //materia prima consignada ou componente consignado
    	          _cAlmox := "03"	
 	  	        Else
		  	       If SB1->B1_TIPO$"MP/CP/EB" //materia prima, componente comprado, embalagem
		              _cAlmox := "02"
		           Else
		              _cAlmox := "01"
		           Endif   
		        Endif	   
		     ElseIf SM0->M0_CODIGO == 'FN' // WHB FUNDICAO
		    	    _cAlmox := '32'
	         EndIf
	         
		     RecLock("SB1",.F.)
		        SB1->B1_CONTRAT := "N"
		     MsUnlock("SB1")                                            

		     _dtIni  :=  CtoD("01/"+strzero(ZA9->ZA9_MES,2)+"/"+strzero(ZA9->ZA9_ANO,4))  //Data inicial p/ gerar a primeira A.E. na segunda		     
    	     For _x :=1 to 31

  	            If Acols[_nx][10+_x] > 0 // So gera SC. p/ qtde maior que zero
  	               _lGeraSC := .T. //Confirma a geracao da SC
  	                 
			       Aadd(aItemSC,{{"C1_ITEM" ,Iif(len(aItemSC)==0,"0001",StrZero(Len(aItemSC)+1,4)),  Nil},; //Numero do Item
							     {"C1_PRODUTO",Acols[_nx][2],Nil},; //Codigo do Produto                             
							     {"C1_QUANT"  ,Acols[_nx][10+_x],Nil},; //Quantidade Semana1,Semana2,Semana3,Semana4
 							     {"C1_DATPRF" ,_dtIni ,      Nil},; //Data De Entrega							     
 							     {"C1_CC"     ,Iif(Empty(SB1->B1_CC),Iif(SM0->M0_CODIGO=="FN","ALMOXARI","ALMOXI"),SB1->B1_CC), Nil},; //Centro de custo
							     {"C1_LOCAL"  ,_cAlmox ,     Nil}}) //Localizacao 

			    Endif
			    _dtIni++ // Soma mais 1 dias para GERAR a proxima  a S.C.
		     Next _x
	  Endif
   EndIf	    
Next _nx   

If _lGeraAE
  
   MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},2,aCabAE,aItemAE,3) // AUTORIZACAO DE ENTREGA = 2, PEDIDO DE COMPRA = 1 
   
   If lMsErroAuto 
      RollBackSx8() //volta a numeração do SC7
      mostraerro()
      DisarmTransaction()
      break
   Else
      ConfirmSX8() //confirma a numeração SC7
      Alert("Gerado Autorizacao de Entrega  "+ _cNumAE)
      
      RecLock("ZA9",.F.)
		 ZA9->ZA9_NUMAE := _cNumAE //Guarda o numero da Autorizacao de entrega no cabecalho do release.
   	  MsUnlock("ZA9")

   Endif   
  
   If ZA9->ZA9_STATUS == "P"
	  RecLock("ZA9",.F.)
		ZA9->ZA9_STATUS := "A"	    	
   	  MsUnlock("ZA9")
   	  Close(oDialog)

   ElseIf ZA9->ZA9_STATUS == "E"
	   MsgBox( "Release finalizado!", "Atencao", "ALERT" )	
	   Return(.F.)
   ElseIf ZA9->ZA9_STATUS == "A"
	   MsgBox( "Release aprovado!", "Atencao", "ALERT" )	
	   Return(.F.)
   EndIf
   
EndIf 

If _lGeraSC //Gera solicitacao de compras
  
   MSExecAuto({|x,y,z| mata110(x,y,z)},aCabSC,aItemSC,3) //Inclusao   
   
   If lMsErroAuto 
      RollBackSx8() //volta a numeração do SC7
      mostraerro()
      DisarmTransaction()
      break
   Else
      ConfirmSX8() //confirma a numeração SC7
      Alert("Gerado Solicitcao de compras "+ _cNumSC)
   Endif   
           
   If !_lGeraAE
	   If ZA9->ZA9_STATUS == "P"
		  RecLock("ZA9",.F.)
			ZA9->ZA9_STATUS := "A"	    	
	   	  MsUnlock("ZA9")
	   	  Close(oDialog)
	
	   ElseIf ZA9->ZA9_STATUS == "E"
		   MsgBox( "Release finalizado!", "Atencao", "ALERT" )	
		   Return(.F.)
	   ElseIf ZA9->ZA9_STATUS == "A"
		   MsgBox( "Release aprovado!", "Atencao", "ALERT" )	
		   Return(.F.)
	   EndIf
   Endif
Endif
	
Return
                         
//-------------------------------------------------------
// FUNCAO PARA IMPRESSAO DO RELATORIO DO RELEASE
//-------------------------------------------------------
User Function fPCPimp()
Private aItens := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZA9"
    oRelato:cTamanho := "G"
    oRelato:cPerg    := "PCP011"
	oRelato:cNomePrg := "NHPCP011"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este   relatorio   tem   como   objetivo  Imprimir"
	oRelato:cDesc2   := "a relação dos saldos dos Releases de Fornecedores."
	oRelato:cDesc3   := ""

	//titulo
	oRelato:cTitulo  := "PROGRAMAÇÃO DE ENTREGAS"

	//cabecalho      
	oRelato:cCabec1  := ""
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})
	
Return


Static Function fFilItens()
Local _cArqDBF := CriaTrab(NIL,.f.) + ".DBF"
Local _aFields := {}
Local aCampos  := {}   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criando Arquivo Temporario para posterior impressao          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(_aFields,{"OK"      ,"C", 02,0})         // Controle do browse
	AADD(_aFields,{"ITEM"    ,"C", 04,0})         // Item do Release
	
	DbCreate(_cArqDBF,_aFields)
	DbUseArea(.T.,,_cArqDBF,"ITM",.F.)
	
	ZA0->(dbSetOrder(1)) // filial + num + item
	ZA0->(dbSeek(xFilial("ZA0")+ZA9->ZA9_NUM))
	
	While ZA0->(!EOF()) .AND. ZA0->ZA0_NUM==ZA9->ZA9_NUM
		RecLock("ITM",.T.)
	      	ITM->OK        := Space(02)     
	   		ITM->ITEM      := ZA0->ZA0_ITEM
		MsUnlock("ITM")
	
		ZA0->(dbSkip())
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Constrói tela para seleção de ítens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos := {}   
	
	Aadd(aCampos,{"OK"    ,"OK"     ,"@!"})
	Aadd(aCampos,{"ITEM"  ,"Item"   ,"@!"})
	
	ITM->(DbGoTop())
	
	@ 50,01 TO 300,200 DIALOG oDlg  TITLE "Impressao de Release"
	@ 06,05 TO 100,097 BROWSE "ITM" FIELDS aCampos MARK "OK"
	@ 105,05 BUTTON "_Imprimir" SIZE 40,15 ACTION Close(oDlg) Object oBtn
	ACTIVATE DIALOG oDlg CENTERED
	
	ITM->(DbGoTop())
	While ITM->(!EOF())
		If MARKED("OK")	
			aAdd(aItens,ITM->ITEM)
		EndIf
		ITM->(dbSkip())
	EndDo

	ITM->(dbCloseArea())
	
Return

Static Function Imprime()
Local x          := 0
Local nAtraso    := 0
Private _nTotEnt := 0
Private _nTotRel := 0
Private _nTotPre := 0
Private _cNumAE  := Space(06)
Private dDtIni   := CtoD("01/"+StrZero(ZA9->ZA9_MES,2)+"/"+StrZero(ZA9->ZA9_ANO,4))
Private dDtFim   := UltimoDia(dDtIni)
Private _nSaldo  := 0
Private _nTotalR := 0
Private _nTotalE := 0


	Processa({||fFilItens()},"Gerando itens...")
	
	SetRegua(len(aItens))
   
	oRelato:cTitulo +=  " DO MES DE "+UPPER(MesExtenso(ZA9->ZA9_MES))+" DE "+StrZero(ZA9->ZA9_ANO,4)

	oRelato:Cabec()

	IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM
		@Prow()+1, 001 psay "WHB COMPONENTES AUTOMOTIVOS S\A"
	ElseIf SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
		@Prow()+1, 001 psay "WHB FUNDICAO S\A"
	EndIf

	QAA->(DBSETORDER(6))//LOGIN
	IF QAA->(DBSEEK(UPPER(CUSERNAME)))
		@Prow()  , 040 psay "Enviado por: "+QAA->QAA_NOME+Space(10)+"Email: "+QAA->QAA_EMAIL
	ENDIF

	If !Empty(ZA9->ZA9_NUMAE)
       @Prow()  , 0190 psay "NUMERO A.E: "+ZA9->ZA9_NUMAE
    Endif   
    
	@Prow()+1, 001 psay "Release nº: "+ZA9->ZA9_NUM
	@Prow()	 , 022 psay "Fornecedor: "+ZA9->ZA9_FORNEC+" - "+ZA9->ZA9_LOJA
	SA2->(DBSETORDER(1))//FILIAL + COD + LOJA

	IF SA2->(DBSEEK(XFILIAL("SA2")+ZA9->(ZA9_FORNEC+ZA9_LOJA)))
		@Prow()	 , 050 psay SA2->A2_NOME
		@Prow()+1, 001 psay "Contato: "+SA2->A2_CONTATO
		@Prow()	 , 040 psay "Telefone: "+SA2->A2_TEL
		@Prow()	 , 100 psay "E-mail: "+SA2->A2_EMAIL 
		
	EndIf
	@Prow()+1, 001 psay "Obs. Geral: "+ZA9->ZA9_OBS 
	
	ZA0->(dbSetOrder(1)) //filial + num + item
	SB1->(DbSetOrder(1)) //filial + produto
	For x:=1 to Len(aItens) //itens filtrados do ZA0
                          
		IncRegua()
		
		ZA0->(dbSeek(xFilial("ZA0")+ZA9->ZA9_NUM+aItens[x]))
		
		If Prow() > 55
			oRelato:Cabec()
		EndIf
		
		@Prow()+2, 001 psay "Ítem"
		@Prow()  , 006 psay "Cód. WHB"
		@Prow()  , 027 psay "Cód. Pç. Forn."	
		@Prow()  , 049 psay "Descrição"
		
		If mv_par01 == 1 // imprime nf ? (sim ou nao)
			@Prow()  , 084 psay "Última N.F."
		EndIf
		
		@Prow()  , 104 psay OemToAnsi("Diferença c/ Atrasos")
		@Prow()  , 130 psay OemToAnsi("Pedido")
		                               
		cMes1 := Substr(MesExtenso(Iif(ZA9->ZA9_MES+1>12,ZA9->ZA9_MES+1 - 12,ZA9->ZA9_MES+1)),1,3)
		cMes2 := Substr(MesExtenso(Iif(ZA9->ZA9_MES+2>12,ZA9->ZA9_MES+2 - 12,ZA9->ZA9_MES+2)),1,3)
		cMes3 := Substr(MesExtenso(Iif(ZA9->ZA9_MES+3>12,ZA9->ZA9_MES+3 - 12,ZA9->ZA9_MES+3)),1,3)
		
		@Prow()  , 146 psay OemToAnsi("Prev. 3 meses -->:     "+cMes1+"        "+cMes2+"        "+cMes3)
	
		@Prow()+1, 001 psay ZA0->ZA0_ITEM // item
		@Prow()  , 006 psay ZA0->ZA0_PROD // produto
		SB1->(DbSeek(xFilial("SB1")+ZA0->ZA0_PROD))
		If SB1->(Found())
			@Prow()  , 027 psay SB1->B1_CODAP5
			@Prow()  , 049 psay SB1->B1_DESC // desc
		EndIf
		
		If mv_par01 == 1 // imprime nf ? (sim ou nao)
			@Prow()  , 084 psay fUltNF(ZA0->ZA0_PROD,ZA9->ZA9_FORNEC,ZA9->ZA9_LOJA)
		Endif

		If ZA9->ZA9_STATUS=="E"
			@Prow()  , 110 psay (ZA0->ZA0_ATRASO) * -1
			nAtraso := ZA0->ZA0_ATRASO
		Else
			nDif    := fCalcDif(ZA9->ZA9_NUM,ZA0->ZA0_ITEM)
//			If Empty(ZA0->ZA0_ATRASO)
//				nAtraso := fAtraso(ZA0->ZA0_NUM, ZA0->ZA0_ITEM)
//			Else
				nAtraso := ZA0->ZA0_ATRASO
//			EndIf

			@Prow()  , 110 psay (nDif+nAtraso) * -1
		EndIf
		
		@Prow()  , 130 psay ZA0->ZA0_PEDIDO
		@Prow()  , 162 psay ZA0->ZA0_MES1 picture "@e 99,999,999"
		@Prow()  , 173 psay ZA0->ZA0_MES2 picture "@e 99,999,999"
		@Prow()  , 184 psay ZA0->ZA0_MES3 picture "@e 99,999,999"

		If mv_par04==1 //semanal
			ImpSemana()
		ElseIf mv_par04==2 //dia a dia
			ImpDiadia()
		EndIf

		/***************************************
		* IMPRIME O SALDO DO PEDIDO DE COMPRAS *
		***************************************/
		If MV_PAR02 == 1 //imprime saldo ped? (s / n)

			_cTipo := ZA0->ZA0_TIPO
			
			cQuery := ""
			If _cTipo$"1"
				cQuery := " SELECT C7.C7_NUM AS PEDIDO, (C7.C7_QUANT-C7.C7_QUJE) AS SALDO "
				cQuery += " FROM "+RetSqlName('SC7') + " C7 "
				cQuery += " WHERE C7.C7_PRODUTO = '"+ZA0->ZA0_PROD+"'"
				cQuery += " AND C7.D_E_L_E_T_ = ' '"
				cQuery += " AND C7.C7_FORNECE = '"+ZA9->ZA9_FORNEC+"'"
				cQuery += " AND C7.C7_LOJA = '"+ZA9->ZA9_LOJA+"'"
				cQuery += " AND C7.C7_RESIDUO = ' '"
				cQuery += " AND C7.C7_QUANT <> C7.C7_QUJE"
				cQuery += " ORDER BY C7.C7_EMISSAO DESC"
			ElseIf _cTipo$"2"
				cQuery := " SELECT C3.C3_NUM AS PEDIDO, (C3.C3_QUANT-C3.C3_QUJE) AS SALDO "
				cQuery += " FROM "+RetSqlName('SC3') + " C3 "
				cQuery += " WHERE C3.C3_PRODUTO = '"+ZA0->ZA0_PROD+"'"
				cQuery += " AND C3.C3_FORNECE = '"+ZA9->ZA9_FORNEC+"'"
				cQuery += " AND C3.C3_LOJA = '"+ZA9->ZA9_LOJA+"'"
				cQuery += " AND C3.C3_RESIDUO = ' '"
				cQuery += " AND C3.C3_QUANT <> C3.C3_QUJE"
				cQuery += " AND C3.D_E_L_E_T_ = ' '"
				cQuery += " ORDER BY C3.C3_EMISSAO DESC"
			Endif
			
			TCQUERY cQuery NEW ALIAS "PED"
			
			nTotPed := 0
			
			If !empty(cQuery) .AND. PED->(!EOF())

				@Prow()+2 , 001 psay "  PEDIDO                     SALDO"
				
				While PED->(!EOF())
					@Prow()+1 , 003 psay PED->PEDIDO+space(13)+Transform(PED->SALDO,"@E 9,999,999,999")
					nTotPed += PED->SALDO
					PED->(DbSkip())
				EndDo
				
				@Prow()+1 , 003 psay "TOTAL: "+space(12)+Transform(nTotPed,"@E 9,999,999,999")
				
			EndIf
			
			If Select("PED") > 0
				PED->(DbCloseArea())
			EndIf

		EndIf
				
		@Prow() +2, 001 psay "Total Release: "     + Alltrim(Transform (_nTotalR,"@e 9999999999"))
		@Prow()   , 050 psay "Total Entregue: "    + Alltrim(Transform (_nTotalE,"@e 9999999999"))
		@Prow()   , 090 psay "Difererença: "       + Alltrim(Transform (_nTotalE - _nTotalR,"@e 9999999999"))
		@Prow()   , 125 psay "Atraso mes Anterior: " + Alltrim(Transform (nAtraso*-1,"@e 9999999999"))
		@Prow()   , 160 psay "Performance: "       + Transform(((_nTotalE*100) / _nTotalR),"@e 999") + "%"
					
		_nTotEnt += _nTotalE
		_nTotRel += _nTotalR
			
		@ Prow()+1,000 PSAY __PrtThinLine()  
	
		_nSaldo  := 0
		_nTotalE := 0
		_nTotalR := 0

		ZA0->(DBSKIP())
		
	Next

	@ Prow()+2,000 PSAY __PrtThinLine()
	@ Prow()+1,001 Psay "Performance Geral: " + Transform(((_nTotEnt*100)/_nTotRel),"@e 9999")+"%"

	@ Prow()+2,001 Psay "*** AVISOS IMPORTANTES ***"
	@ Prow()+1,001 Psay "1 - Consideramos a programação como aprovada caso não haja retorno no prazo de 2 dias."
	@ Prow()+1,001 Psay "2 - Reservamo-nos no direito de cancelar as entregas em atraso. "
	@ Prow()+1,001 Psay "3 - Solicitamos sua atenção para cumprimento rigoroso dos prazos de entregas, mostrados neste programa (Sujeito a débito financeiro por atraso e paradas de linhas que ocorrerem.)"

Return

//*****************************************************//
// Funcao que traz o número da semana dentro do ano    //
// usando a data como parametro             		   //
//*****************************************************//
Static Function fCalcSem(dDt)
Local nSem := 1
Local dData := CtoD("01/01/"+Strzero(Year(dDt),4))

	While dData < dDt
		If DoW(dData) == 1 .And. dData<>CtoD("01/01/"+Strzero(Year(dDt),4))
			nSem ++
		EndIf
		dData++
	EndDo

Return(nSem)

Static Function ImpSemana()    
Local aSPrev := {0,0,0,0,0,0}
Local aSEntr := {0,0,0,0,0,0}
Local aPrev  := {}
Local nCol   := 1

	/*******************************************
	* Imprime o cabeçalho dos dias de 1 até 16 *
	*******************************************/
	@Prow()+2, 001 psay "Semana: ----->"
	@Prow()  , 030 psay fCalcSem(dDtIni)    PICTURE("@E 9999999999")
	@Prow()  , 045 psay fCalcSem(dDtIni+7)  PICTURE("@E 9999999999")
	@Prow()  , 060 psay fCalcSem(dDtIni+14) PICTURE("@E 9999999999")
	@Prow()  , 075 psay fCalcSem(dDtIni+21) PICTURE("@E 9999999999")
	@Prow()  , 090 psay fCalcSem(dDtIni+28) PICTURE("@E 9999999999")
	@Prow()  , 105 psay fCalcSem(dDtIni+35) PICTURE("@E 9999999999")

	@Prow()+1, 001 psay "Release:----->"
	
	For y:=1 to 31
		cField := "ZA0->ZA0_PREV"+strzero(y,2)
		aAdd(aPrev,&(cField))
	Next
	
	dDtRef := dDtIni
	aQtd   := fQtdEntr(ZA0->ZA0_PROD,ZA9->ZA9_FORNEC,ZA9->ZA9_LOJA,dDtIni,dDtFim)
	
	While Len(aQtd) < 31
		aAdd(aQtd,{"",0})
	EndDo
	
	For y:=1 to 31
		If Dow(dDtIni+y-1)==1 .And. dDtIni<>dDtFim .AND. y!=1
			nCol++
		EndIf

		aSPrev[nCol] += aPrev[y]
		aSEntr[nCol] += aQtd[y][2]
	Next
	
	@Prow()  , 030 psay aSPrev[1] PICTURE("@E 9999999999")// prev Semana1
	@Prow()  , 045 psay aSPrev[2] PICTURE("@E 9999999999")// prev Semana2
	@Prow()  , 060 psay aSPrev[3] PICTURE("@E 9999999999")// prev Semana3
	@Prow()  , 075 psay aSPrev[4] PICTURE("@E 9999999999")// prev Semana4
	@Prow()  , 090 psay aSPrev[5] PICTURE("@E 9999999999")// prev Semana5
	@Prow()  , 105 psay aSPrev[6] PICTURE("@E 9999999999")// prev Semana6

	@Prow()+1, 001 psay "Entregue:---->"
	@Prow()  , 030 psay aSEntr[1] PICTURE("@E 9999999999")// entregue Semana1
	@Prow()  , 045 psay aSEntr[2] PICTURE("@E 9999999999")// entregue Semana2
	@Prow()  , 060 psay aSEntr[3] PICTURE("@E 9999999999")// entregue Semana3
	@Prow()  , 075 psay aSEntr[4] PICTURE("@E 9999999999")// entregue Semana4
	@Prow()  , 090 psay aSEntr[5] PICTURE("@E 9999999999")// entregue Semana5
	@Prow()  , 105 psay aSEntr[6] PICTURE("@E 9999999999")// entregue Semana6
		
	For y := 1 to 6
		_nTotalR += aSPrev[y]
		_nTotalE += aSEntr[y]
	Next 
	
	aSPrev := {0,0,0,0,0,0}
	aSEntr := {0,0,0,0,0,0}

Return

Static Function ImpDiadia()
		
	/*******************************************
	* Imprime o cabeçalho dos dias de 1 até 16 *
	*******************************************/
	@Prow()+2, 001 psay "Dia: -------->"
	
	For y:= 1 to 16
		@Prow()  , (y*11)+16 psay StrZero(y,2)
	Next
	@Prow()+1, 019 psay Repli("_",180)
	
	/***********************************************
	* Imprime o que foi programado do dia 01 ao 16 *
	***********************************************/
	@Prow()+1, 001 psay "Release:----->"
	For y:= 1 to 16
		cCampo := "ZA0->ZA0_PREV"+StrZero(y,2)
		@Prow()  , (y*11)+8 psay &(cCampo) PICTURE("@E 9999999999")// prev DIA
		_nTotalR += &(cCampo)
	Next
	
	/*********************************************
	* Imprime o que foi entregue do dia 01 ao 16 *
	*********************************************/
	aQtd := fQtdEntr(ZA0->ZA0_PROD,ZA9->ZA9_FORNEC,ZA9->ZA9_LOJA,dDtIni,dDtFim)
	
	While len(aQtd) < 31
		aAdd(aQtd,{"",0})
	EndDo
	
	@Prow()+1, 001 psay "Entregue:---->"
	For y:= 1 to 16
		@Prow()  , (y*11)+8 psay aQtd[y][2] PICTURE("@E 9999999999")// entrada no dia
		_nTotalE += aQtd[y][2]
	Next
	
	/**************************************************
	* Imprime a diferença de entregas do dia 01 ao 16 *
	**************************************************/
	@Prow()+1, 001 psay "Diferenca:--->"
	For y:= 1 to 16
		cCampo  := "ZA0->ZA0_PREV"+STRZERO(y,2)
		_nSaldo += aQtd[y][2] - &(cCampo)
		@Prow()  , (y*11)+8 psay _nSaldo PICTURE("@E 9999999999")// diferenca
	Next
	
	//******************************************//
	// Imprime o cabeçalho dos dias de 16 até 31 //
	//******************************************//
	@Prow()+2, 001 psay "Dia: -------->"
	For y:= 17 to 31
		@Prow()  , ((y-16)*11)+16 psay StrZero(y,2)
	Next
	@Prow()+1, 019 psay Repli("_",180)
	
	//**********************************************//
	// Imprime o que foi programado do dia 17 ao 31 //
	//**********************************************//
	@Prow()+1, 001 psay "Release:----->"
	For y:= 17 to 31
		cCampo := "ZA0->ZA0_PREV"+STRZERO(y,2)
		@Prow()  , ((y-16)*11)+8 psay &(cCampo) PICTURE("@E 9999999999")// prev DIA
		_nTotalR += &(cCampo)
	Next
	
	//********************************************//
	// Imprime o que foi entregue do dia 17 ao 31 //
	//********************************************//
	@Prow()+1, 001 psay "Entregue:---->"
	For y:= 17 to 31
		@Prow()  , ((y-16)*11)+8 psay aQtd[y][2] PICTURE("@E 9999999999")// entr dia01
		_nTotalE += aQtd[y][2]
	Next
	
	//*************************************************//
	// Imprime a diferença de entregas do dia 01 ao 16 //
	//*************************************************//
	@Prow()+1, 001 psay "Diferenca:--->"
	For y:= 17 to 31
		cCampo  := "ZA0->ZA0_PREV"+STRZERO(y,2)
		_nSaldo += aQtd[y][2] - &(cCampo)
		@Prow()  , ((y-16)*11)+8 psay _nSaldo PICTURE("@E 9999999999")// diferenca
	Next

Return

User Function FLegRel()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aprovada"  },;
  					  {"BR_VERMELHO" , "Encerrada" },;
  					  {"BR_AMARELO"  , "Pendente"  }}
  					  
BrwLegenda(OemToAnsi("Programação de Entregas"), "Legenda", aLegenda)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PARA INSERÇÃO DE OBSERVAÇÕES NO RELEASE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fObs()
Private cDia := StrZero(oMultiline:OBrowse:ColPos-10,2) //retorna a coluna em que o cursor está focando
Private cItem := ACOLS[N][aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZA0_ITEM"})]
Private cObs  := Space(100)

  	oFont16 := TFont():New("Arial",,16,,.T.)
	
	//Só trás a tela de observação quando o cursor estiver sobre um campo de DIA
	If oMultiline:OBrowse:ColPos >= 11 .And. oMultiline:OBrowse:ColPos <= 41
		ZAT->(DbSetOrder(1)) //filial + numrel + ITEM + dia
		ZAT->(DbSeek(xFilial("ZAT")+_cNum+cItem+cDia))
		If ZAT->(Found())
			cObs := ZAT->ZAT_OBS
		Else
			cObs := Space(100)
		EndIf
	Else
		Alert("Posicione o cursor sobre um campo de Dia do Release.")
		Return
    EndIf

	Define MsDialog oDialog2 Title OemToAnsi("Observacao") From 000,000 To 170,245 Pixel 

	@ 010,005 Say "Dia "+cDia Size 040,8 Object olDia
	olDia:Setfont(oFont16)

	@ 025,005 Say "Obs: " Size 040,8 Object olObs
	@ 025,020 Get ocObs Var cObs MEMO Size 100,40 pixel of oDialog2

	@ 070,060 BMPBUTTON TYPE 01 ACTION fGrvObs()
	@ 070,090 BMPBUTTON TYPE 02 ACTION Close(oDialog2)

	Activate MsDialog oDialog2 Center
		
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PARA GRAVAÇÃO DAS OBSERVAÇÕES DO RELEASE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvObs()
                        
	If nPar == 3//alterar
		ZAT->(DbSetOrder(1)) //filial + numrel + Produto + dia
		ZAT->(DbSeek(xFilial("ZAT")+_cNum+cItem+cDia))
	
		If ZAT->(!Found()) //inserção
			RecLock("ZAT",.T.)
				ZAT->ZAT_FILIAL := xFilial("ZAT")
				ZAT->ZAT_NUMREL := _cNum
				ZAT->ZAT_ITEM   := cItem
				ZAT->ZAT_DIA	:= cDia
				ZAT->ZAT_OBS := Substr(cObs,1,100)
			MsUnlock("ZAT")
		Else //alteracao
			RecLock("ZAT",.F.)
				ZAT->ZAT_OBS := Substr(cObs,1,100)
			MsUnlock("ZAT")
		
		EndIf
	Else
		MsgAlert("Obs. nao foi gravada. Selecione opcao Alterar")
	EndIf
	Close(oDialog2)

Return

/*
Static Function fPedAE()
	If _cTipo$"1"
		cQuery3 := " SELECT TOP 1 E4.E4_DESCRI AS DCOND,C7.C7_NUM AS PEDIDO,C7.C7_COND AS COND,C7.C7_ITEM AS ITEM FROM "+RetSqlName('SC7') + " C7, " + RetSqlName( 'SE4' ) +" E4 "
		cQuery3 += " WHERE C7.C7_PRODUTO = '"+Acols[n][2]+"'"
		cQuery3 += " AND C7.D_E_L_E_T_ = ' '"
		cQuery3 += " AND E4.D_E_L_E_T_ = ' '"		
		cQuery3 += " AND C7.C7_RESIDUO = ' '"		
		cQuery3 += " AND C7.C7_COND =  E4.E4_CODIGO"				
		cQuery3 += " AND C7.C7_QUANT <> C7.C7_QUJE"				
	    cQuery3 += " ORDER BY C7.C7_EMISSAO DESC"
		TCQUERY cQuery3 NEW ALIAS "TMU"      	    
	ElseIf _cTipo$"2"
		cQuery3 := " SELECT TOP 1 E4.E4_DESCRI AS DCOND,C3.C3_NUM AS PEDIDO,C3.C3_COND AS COND,C3.C3_ITEM AS ITEM FROM "+RetSqlName('SC3') + " C3, " + RetSqlName( 'SE4' ) +" E4 "
		cQuery3 += " WHERE C3.C3_PRODUTO = '"+Acols[n][2]+"'"
		cQuery3 += " AND C3.C3_RESIDUO = ' '"		
		cQuery3 += " AND C3.C3_QUANT <> C3.C3_QUJE"				
		cQuery3 += " AND C3.C3_COND =  E4.E4_CODIGO"						
		cQuery3 += " AND C3.D_E_L_E_T_ = ' '"
		cQuery3 += " AND E4.D_E_L_E_T_ = ' '"		
	    cQuery3 += " ORDER BY C3.C3_EMISSAO DESC"
		TCQUERY cQuery3 NEW ALIAS "TMU"      	    
	ElseIf _cTipo$"3" //Nada release somente p/ previsao
		acols[n][9]  := ""  
		acols[n][46] := ""  		
		_cCond := ""       

	Endif

Return
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 26/05/2009 - João Felipe - Carrega os produtos do release anterior ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarreg()
Local cQuery
Local nZA9Rec
Local nItem 

	//verifica se foi digitado o fornecedor e a loja
	If Empty(_cForn)
		Alert("Digite o fornecedor!")
		Return
	EndIf
	
	If Empty(_cLoja)
		Alert("Digite a Loja!")
		Return
	EndIf
	
	//Localiza o último release deste fornecedor e loja	
	ZA9->(DbSetOrder(2)) //FILIAL + FORNEC + LOJA + ANO + MES
	ZA9->(DbSeek(xFilial("ZA9")+_cForn+_cLoja))
	While ZA9->(!EOF()) .AND. ZA9->ZA9_FORNEC==_cForn .AND. ZA9->ZA9_LOJA==_cLoja
	
		If(Empty(ZA9->ZA9_MES) .or.  Empty(ZA9->ZA9_ANO)) //NAO PEGA SE NAO TIVER ANO OU MES INFORMADO (RELEASES ANTIGOS)
			ZA9->(dbSkip())
			Loop			
		EndIf	
	
	    nZA9Rec := ZA9->(RecNo())
		ZA9->(DBSKIP())
	EndDo
	
	If Empty(nZA9Rec)
	    Alert("Não foi possível importar os produtos do último release!")
	    Return
	EndIf

	//Posiciona a tabela ZA9 no registro do último release deste fornecedor e loja	
	ZA9->(DbGoTo(nZA9Rec))
	                    
	ZA0->(DbSetOrder(1)) //filial + num + item
	ZA0->(DbSeek(xFilial("ZA0")+ZA9->ZA9_NUM))
	    
	SB1->(DbSetOrder(1)) // filial + cod
	
	nItem := 0      
	aCols := {}
	
	WHILE ZA0->(!EOF()) .AND. ZA0->ZA0_NUM == ZA9->ZA9_NUM
		
		nItem++
		
//		fQuery(ZA0->ZA0_PROD)
		
		SB1->(DbSeek(xFilial("SB1")+ZA0->ZA0_PROD))
		
		aAdd(aCols,{StrZero(nItem,4),; //item
					ZA0->ZA0_PROD,;    //prod
					SB1->B1_DESC,;     //desc
					U_NHSALDO(ZA0->ZA0_PROD,""),; //U_NHSALDO retorna o saldo no estoque, parametros: prod e local
					ZA0->ZA0_ATRASO,;  //atraso
					0,;			       //diferenca
					fUltNF(ZA0->ZA0_PROD,_cForn,_cLoja),;
					ZA0->ZA0_TIPO,;    //tipo
					"",;               //PEDIDO
					ZA0->ZA0_FREQ,;    //Frequencia de entrega
					0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,;  //previsoes
					ZA0->ZA0_COND,;    //condicao de pagamento
					"",.F.})           //item do pedido, .f.

		ZA0->(DBSKIP())

	ENDDO
	
	oMultiline:Refresh()
	
	ZA9->(dbSetOrder(1))

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CALCULA A DIFERENCA DO ITEM DO RELEASE ³
// PARÂMETROS: 
//		cNum = numero do release
//		cItem = item do release
//		lAtraso = considera o atraso? verdadeiro ou falso
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCalcDif(cNum,cItem)
Local nZA9Rec := ZA9->(Recno())
Local nZA0Rec := ZA0->(Recno())
Local nDif := 0
Local x    := 0

	ZA9->(dbSetOrder(1))
	ZA0->(dbSetOrder(1))
	ZA9->(dbSeek(xFilial("ZA9")+cNum))
	ZA0->(dbSeek(xFilial("ZA0")+cNum+cItem))
	
	If ZA0->(!Found()) .or. ZA9->(!Found())
		Alert("erro")
	Else
	
		//descobre o total do release para este item
		nTotRel := 0
		For x:=1 to 31
			cCampo := "ZA0->ZA0_PREV"+strzero(x,2)
			nTotRel += &(cCampo)
		Next				
				
		//descobre total de entradas no mes deste item
		nTotEnt := 0
		dDtIni  := CtoD("01/"+StrZero(ZA9->ZA9_MES,2)+"/"+StrZero(ZA9->ZA9_ANO,4))
		dDtFim  := UltimoDia(dDtIni)
	
		aQtd := fQtdEntr(ZA0->ZA0_PROD,ZA9->ZA9_FORNEC,ZA9->ZA9_LOJA,dDtIni,dDtFim)
	
		For x:=1 to Len(aQtd)
			nTotEnt += aQtd[x][2] //TOTAL RECEBIDO
		Next
		
		nDif := nTotRel - nTotEnt
		
	EndIf		

	ZA9->(dbGoTo(nZA9Rec))
	ZA0->(dbGoTo(nZA0Rec))
		
Return(nDif)

Static Function fAtraso(cNum, cItem)
Local nZA9Rec := ZA9->(Recno())
Local nZA0Rec := ZA0->(Recno())
Local nAtraso := 0

	ZA9->(dbSetOrder(1))
	ZA0->(dbSetOrder(1))
	ZA9->(dbSeek(xFilial("ZA9")+cNum))
	ZA0->(dbSeek(xFilial("ZA0")+cNum+cItem))
	
	If ZA0->(!Found()) .or. ZA9->(!Found())
		Alert("erro") //nao pode ocorrer
	Else

	    cQuery := "SELECT TOP 1 ZA0.ZA0_ATRASO "
	    cQuery += " FROM "+RetSqlName("ZA0")+" ZA0, "+RetSqlName("ZA9")+" ZA9"
	    cQuery += " WHERE ZA9.ZA9_NUM = ZA0.ZA0_NUM"
	    cQuery += " AND ZA9.ZA9_STATUS = 'E'"
	    cQuery += " AND ZA9.ZA9_FORNEC = '"+ZA9->ZA9_FORNEC+"'"
	    cQuery += " AND ZA9.ZA9_LOJA   = '"+ZA9->ZA9_LOJA+"'"
	    cQuery += " AND ZA0.ZA0_PROD = '"+ZA0->ZA0_PROD+"'"
	    cQuery += " AND CAST(ZA9.ZA9_ANO AS VARCHAR)+CAST(ZA9.ZA9_MES AS VARCHAR) < '"+STRZERO(ZA9->ZA9_ANO,4)+AllTrim(str(ZA9->ZA9_MES))+"'"
	    cQuery += " ORDER BY CAST(ZA9.ZA9_ANO AS VARCHAR)+CAST(ZA9.ZA9_MES AS VARCHAR) DESC "
	    
	    TCQUERY cQuery NEW ALIAS "DIF"
	    
	    If !EMPTY(DIF->ZA0_ATRASO)
	    	nAtraso += DIF->ZA0_ATRASO
	    EndIf
		    
	    If Select("DIF") > 0
	    	DIF->(dbCloseArea())
	    EndIf
	
	EndIf
	
	ZA9->(dbGoTo(nZA9Rec))
	ZA0->(dbGoTo(nZA0Rec))
	
Return nAtraso

Static Function fAtuAtraso(cNum, cItem, nNewValor)
Local nZA9Rec := ZA9->(Recno())
Local nZA0Rec := ZA0->(Recno())
Local aArea   := GetArea()

	ZA9->(dbSetOrder(1))
	ZA0->(dbSetOrder(1))
	ZA9->(dbSeek(xFilial("ZA9")+cNum))
	ZA0->(dbSeek(xFilial("ZA0")+cNum+cItem))
	
	If ZA0->(!Found()) .or. ZA9->(!Found())
		Alert("erro") //nao pode ocorrer
	Else

	    cQuery := "SELECT TOP 1 ZA0.R_E_C_N_O_ AS ZA0_RECNO "
	    cQuery += " FROM "+RetSqlName("ZA0")+" ZA0, "+RetSqlName("ZA9")+" ZA9"
	    cQuery += " WHERE ZA9.ZA9_NUM = ZA0.ZA0_NUM"
	    cQuery += " AND ZA9.ZA9_STATUS = 'E'"
	    cQuery += " AND ZA9.ZA9_FORNEC = '"+ZA9->ZA9_FORNEC+"'"
	    cQuery += " AND ZA9.ZA9_LOJA   = '"+ZA9->ZA9_LOJA+"'"
	    cQuery += " AND ZA0.ZA0_PROD = '"+ZA0->ZA0_PROD+"'"
	    cQuery += " AND ZA0.D_E_L_E_T_ = '' AND ZA0.ZA0_FILIAL = '"+xFilial("ZA0")+"'"
	    cQuery += " AND ZA9.D_E_L_E_T_ = '' AND ZA9.ZA9_FILIAL = '"+xFilial("ZA9")+"'"
	    cQuery += " AND CAST(ZA9.ZA9_ANO AS VARCHAR)+CAST(ZA9.ZA9_MES AS VARCHAR) < '"+STRZERO(ZA9->ZA9_ANO,4)+ALLTRIM(STR(ZA9->ZA9_MES))+"'"
	    cQuery += " ORDER BY CAST(ZA9.ZA9_ANO AS VARCHAR)+CAST(ZA9.ZA9_MES AS VARCHAR) DESC "
	    
	    TCQUERY cQuery NEW ALIAS "ATR"
	    
	    If !EMPTY(ATR->ZA0_RECNO)
	    	ZA0->(dbGoTo(ATR->ZA0_RECNO))
	    	RecLock("ZA0",.F.)
	    		ZA0->ZA0_ATRASO := nNewValor
	    	MsUnlock("ZA0")
	    EndIf
	    
	    ATR->(dbCloseArea())
	EndIf
	
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHPCP016   ºAutor ³João Felipe         º Data ³  16/07/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE OBSERVACOES DO RELEASE X ENTRADAS             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER Function NHPCP016()

cString   := "ZA0"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("as observações inseridas no release dentro  de  um ")
cDesc3    := OemToAnsi("período.")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "PCP016"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("OBSERVAÇÕES DO RELEASE X ENTRADAS")
cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHPCP016"
_cPerg    := "PCP016" 
 
Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()
Local aObs := {}
Local aRls := {}
Local aQtd := {}
Local cItem, cCAMPO
Local x := 1 
Local dDtIni   := CtoD("01/"+StrZero(ZA9->ZA9_MES,2)+"/"+StrZero(ZA9->ZA9_ANO,4))
Local dDtFim   := UltimoDia(dDtIni)

ZA0->(DbSetOrder(1)) //FILIAL + NUM + ITEM + PROD
ZA0->(DbSeek(xFilial("ZA0")+ZA9->ZA9_NUM) )

cabec2    := OemToAnsi(" Dia         Release          Entrada           Observacao")

While ZA0->(!EOF()) .AND. ZA0->ZA0_NUM == ZA9->ZA9_NUM

	cItem := "Item: "+ZA0->ZA0_ITEM + " - " + RTRIM(ZA0->ZA0_PROD) + " - " + ZA0->ZA0_DESC
	
	cabec1    := OemToAnsi(" RI-WHB: ") + ZA9->ZA9_NUM +"   "+cItem

	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		
	//CRIA UMA ARRAY COM AS OBSERVACOES
	ZAT->(DbSetOrder(1)) //filial + num + prod + dia
	For x := 1 to 31
		ZAT->(DbSeek(xFilial("ZAT")+ZA0->ZA0_NUM+ZA0->ZA0_ITEM+STRZERO(x,2)))
		If ZAT->(Found())
			aAdd(aObs,AllTrim(ZAT->ZAT_OBS))
		Else
			aAdd(aObs,"--------------S/ OBS.--------------")
		EndIf
	Next
	
	//CRIA UM ARRAY COM AS ENTRADAS
	aQtd := fQtdEntr(ZA0->ZA0_PROD, ZA9->ZA9_FORNEC, ZA9->ZA9_LOJA, dDtIni, dDtFim)
	
	While len(aQtd) < 31
		aAdd(aQtd,{"",0})
	EndDo
              
	//CRIA UM ARRAY COM OS RELEASES
	DbSelectArea("ZA0")	
    For x:=1 To 31
	    cCAMPO := "ZA0->ZA0_PREV"+strzero(x,2)
        Aadd(aRls,"Dia "+strzero(x,2)+": "+Transform(&(cCAMPO),"@e 999999999")) 
    Next
				
	For x:=1 to 31

	    //Faz o filtro de dia até dia
		If x >= mv_par01 .AND. x <= mv_par02
			@ Prow()+1 , 001 Psay aRls[x]
			@ Prow()   , 025 psay aQtd[x][2] PICTURE("@E 999999999")
			@ Prow()   , 045 Psay aObs[x]
		EndIf

	Next

	aRls := {}
	aQtd := {}
	aObs := {}
                                                                   
	ZA0->(DbSkip())

EndDo

@ Prow()+1,000 PSAY __PrtThinLine()

Return(nil)		



// Gera arquivo TEXTO
User Function fpcpx01()

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,")
SetPrvt("nHdl,cLin,cFnl,_cEdi,_cCam,cArqExp")


If !MsgBox('Confirma geracao do Arquivo','T-System','YESNO')
	Return
Endif	


_cEdi     := Alltrim(GETMV("MV_EDI")) //caminho para envio do EDI   // "V:\mdicom\Parceiro\WHBCOMP\Out\"
_cCam     := "VKF"+Subs(Dtos(dDatabase),7,2)+Subs(Dtos(dDatabase),5,2)+"1.TXT"
             // "V:\mdicom\Parceiro\WHBCOMP\Out\VLK"
cArqExp   := _cEdi + _cCam            


While File(cArqExp)        
   _cCam   := Substr(_cCam,1,7) +  StrZero(Val(Substr(_cCam,8,1))+1,1)+".TXT" 
   cArqExp := _cEdi + _cCam
Enddo

cFnl    := CHR(13)+CHR(10)
nHdl    := fCreate(cArqExp)
lEnd    := .F.

MsAguarde ( {|lEnd| fArqLay() },"Aguarde","Gerando arquivo...",.T.)

Return

// 
Static Function fArqLay()
Local _nSeg   := 1
Local _nTotsa := 0                     
Local _nc     := 0
Local _cA2cgc, _cForn, _cLoja, _cA2Nome

    _cForn   := ZA9->ZA9_FORNEC
    _cLoja   := ZA9->ZA9_LOJA    
    
    _cA2cgc  := Space(14)
	_cA2nome := Space(25)

	DbSelectArea('SA2')
	SA2->(DbSetOrder(1)) //Filial + Cod + loja
	SA2->(DbSeek(xFilial('SA2')+AllTrim(_cForn)+AllTrim(_cLoja)))
	If SA2->(Found())
		_cA2cgc   := SA2->A2_CGC
		_cA2nome  := Substr(SA2->A2_NOME,1,25)
	EndIf

	nlin := 0
	
	** Header
	cLin := "ITP"
	cLin := cLin + "001"
	cLin := cLin + "09"
	cLin := cLin + "00000" 
	cLin := cLin + Substr(Dtos(date()),3,6)
	cLin := cLin + Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2) 
	cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + _cA2cgc
	cLin := cLin + Space(08) 
	cLin := cLin + Space(08) 
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,25)
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,25)                                              
	cLin := cLin + Space(09) 
    _nSeg++
	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))

	_nc := 0
	ZA0->(dbSeek(xFilial("ZA0")+ZA9->ZA9_NUM))		
	While !ZA0->(Eof()) .AND. ZA0->ZA0_NUM == ZA9->ZA9_NUM


		** PE1 Dados do ITEM
		cLin := "PE1" 				// IDENT. DO TIPO DE REGISTRO
		cLin := cLin + "011"  		// COD. FABRICA DE DESTINO 
		cLin := cLin + "001005252" 	// IDENT. PROGRAMA ATUAL
		cLin := cLin + Substr(Dtos(ZA0->ZA0_DATA),3,6) // DATA DO PROGRAMA ATUAL           
		cLin := cLin + Space(09) // IDENT. PROGRAMA ANTERIOR
		cLin := cLin + Space(06) // DATA DO PROGRAMA ANTERIOR        

		_cB1cod := Space(30)
		_cB1um  := Space(02)
		SB1->(DbSeek(xFilial("SB1")+ZA0->ZA0_PROD))
		If SB1->(Found())
			If Substr(SB1->B1_CODAP5,1,1) == 'N'
				_cB1cod := Substr(SB1->B1_CODAP5,1,1) + Space(05) + Substr(SB1->B1_CODAP5,2,14) + space(10)
			Elseif Substr(SB1->B1_CODAP5,1,3) == 'AMV'
				_cB1cod := Substr(SB1->B1_CODAP5,1,3) + Space(03) + Substr(SB1->B1_CODAP5,4,14) + space(10)
			Endif
			_cB1um  := SB1->B1_UM
		Endif
		cLin := cLin + _cB1cod  // COD. ITEM DO CLIENTE             
		cLin := cLin + SB1->B1_COD + space(15)
		cLin := cLin + ZA0->ZA0_PEDIDO + space(06)
		cLin := cLin + '011  '
		cLin := cLin + Space(11) 				
		cLin := cLin + _cB1um				
		cLin := cLin + '0'
		cLin := cLin + 'P'		
        _nSeg++
		
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

		
		fUltNF(ZA0->ZA0_PROD,_cForn,_cLoja)

		** PE2 Inform. de Entregas/Embarque  
		cLin := "PE2"    								  // IDENT. DO TIPO DE REGISTRO       
		cLin := cLin + Substr(cD1Emissao,3,6)             // DATA ULTIMA ENTREGA/EMBARQUE     
		cLin := cLin + StrZero(Val(cD1doc),6)			  // NUMERO ULTIMA NOTA FISCAL        	
		cLin := cLin + cD1Serie + space(01)               // SERIE ULTIMA NOTA FISCAL            
		cLin := cLin + Substr(cD1Emissao,3,6)             // DATA ULTIMA NOTA FISCAL          
		cLin := cLin + StrZero(0,15)                      // QUANT. ULTIMA ENTREGA/EMBARQUE    
		cLin := cLin + StrZero(0,17)                      // QT ENTREGA/EMBARQUE ACUMULADA    
		cLin := cLin + StrZero(0,17)				      // QUANT. NECESS. ACUMULADA         
		cLin := cLin + StrZero(0,15)		              // QUANT. LOTE MINIMO               
		cLin := cLin + Space(03)    					  // COD. FREQUENCIA FORNECIMENTO     
		cLin := cLin + '0000'  							  // DATA LIBERACAO P/ PRODUCAO  
		cLin := cLin + '0000'  							  // DATA LIBERACAO MATERIA PRIMA     
		cLin := cLin + Space(07)    					  // COD. LOCAL DE DESCARGA           	
		cLin := cLin + Space(04)    					  // PERIODO DE ENTREGA/EMBARQUE      
		cLin := cLin + Space(02)    					  // COD. SITUACAO DO ITEM            
		cLin := cLin + Space(01)    					  // IDENT. DO TIPO DE PROGRAMACAO    
		cLin := cLin + Space(13)    					  // PEDIDO DA REVENDA                
		cLin := cLin + Space(01)    					  // QUALIFICACAO DA PROGRAMACAO      
		cLin := cLin + Space(02)    					  // TIPO DE PEDIDO DA REVENDA   
		cLin := cLin + Space(03)    					  // COD. DA VIA DE TRANSPORTE        
		cLin := cLin + Space(07)    					  // ESPACO

        _nSeg++
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

		** PE3 CRONOGRAMA DE ENTREGA/EMBARQUE
		cLin := "PE3"    								  // IDENT. DO TIPO DE REGISTRO       

		For i := 1 To 31
				
            cCampo := 'ZA0->ZA0_PREV' + StrZero(i,2)
			If &cCampo > 0
				cLin := cLin + Substr(StrZero(ZA9->ZA9_ANO,4),3,2) + StrZero(ZA9->ZA9_MES,2) + StrZero(i,2) // DATA ENTREGA/EMBARQUE DO ITEM    
				cLin := cLin + Substr(TIME(),1,2)   // HORA P/ ENTREGA/EMBARQUE ITEM    
				cLin := cLin + StrZero(&cCampo,9)   // QT DE ENTREGA/EMBARQUE DO ITEM   
				_nc++
			Endif

		Next

		For p := 1 to 7 - _nc
			cLin := cLin + '000000'             // DATA ENTREGA/EMBARQUE DO ITEM    
			cLin := cLin + '00'                 // HORA P/ ENTREGA/EMBARQUE ITEM    
			cLin := cLin + '000000000'          // QT DE ENTREGA/EMBARQUE DO ITEM   
		Next
		cLin := cLin + Space(06)      		   // ESPACO

        _nSeg++
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

		ZA0->(DbSkip())

    Enddo


cLin := "FTP" 
cLin := cLin + "00000" 
cLin := cLin + StrZero(_nSeg+1,9) 
cLin := cLin + StrZero(0,17) 
cLin := cLin + Space(01) 
cLin := cLin + Space(93) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 

Return(nil)

