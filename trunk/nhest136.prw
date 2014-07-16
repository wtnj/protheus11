/*   
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST136   �Autor  �Jo�o Felipe        � Data �  08/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � ORDEM DE LIBERACAO DE RECEBIMENTO                          ���
���          � AVISO DE DIVERG�NCIA                                       ���
�������������������������������������������������������������������������͹��
���Uso       � PCP / RECEBIMENTO / PORTARIA                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
������������������������������������d����������������������������������������
*/

#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function NHEST136()  

SetPrvt("cCadastro, aRotina") 

cCadastro := OemToAnsi("Ordem de Libera��o de Recebimento de Materiais")
aRotina   := {{"Pesquisar"    ,"AxPesqui"        , 0 , 1},;
             { "Visualizar"   ,"U_E136RECEBE(1)" , 0 , 2},;             //{ "Importar"     ,"U_E136IMPORT()"  , 0 , 3},;
             { "Receber"      ,"U_E136RECEBE(2)" , 0 , 3},;
             { "Encerrar"     ,"U_E136RECEBE(4)" , 0 , 4},;  
             { "Alterar"      ,"U_E136RECEBE(5)" , 0 , 4},;    
             { "Enc. V�rios"  ,"U_NHEST196()"    , 0 , 4},;
             { "Portaria"     ,"U_E136RECEBE(3)" , 0 , 5},;             //{ "Imprimir"     ,"U_EST136IM(1)"   , 0 , 5},;             { "Receb. OK"    ,"U_EST136(5)"     , 0 , 5},;             { "Rot. Coleta"  ,"U_EST136ROT()"   , 0 , 5},;
             { "Retornar"     ,"U_E136RETORNA()" , 0 , 4},;    
             { "Legenda"      ,"U_EST136LEG()"   , 0 , 2}}
            
mBrowse( 6, 1,22,75,"ZB8",,,,,,fCriaCor())

Return

//-- importa manualmente os dados da nota para a tabela ZB8
User Function E136IMPORT()

	If !Pergunte("EST136",.T.)
		Return
	EndIf
	
	Processa({|| U_ZB8Importa(mv_par01+mv_par02+mv_par03+mv_par04)},"Importando...")

Return

//-- Importa��o manual da nota
User Function ZB8Importa(cChave)

	nRecSd1 := SD1->(Recno())

	SD1->(DBSETORDER(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SD1->(dbSeek(xFilial("SD1")+cChave))
	
	While SD1->(!EOF()) .AND. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChave

		ZB8->(dbsetorder(1)) // ZB8_FILIAL+ZB8_NFISC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA+ZB8_ITEM

		If !ZB8->(dbSeek(xFilial("ZB8")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM)))
		
			RecLock("ZB8",.T.)
				ZB8->ZB8_FILIAL := xFilial("ZB8")
				ZB8->ZB8_DOC    := SD1->D1_DOC
				ZB8->ZB8_SERIE  := SD1->D1_SERIE
				ZB8->ZB8_FORNEC := SD1->D1_FORNECE
				ZB8->ZB8_LOJA   := SD1->D1_LOJA
				ZB8->ZB8_COD    := SD1->D1_COD
				ZB8->ZB8_ITEM   := SD1->D1_ITEM
				ZB8->ZB8_HRENTR := time()
				ZB8->ZB8_STATUS := 'P'
			MsUnlock("ZB8")

		Endif

		SD1->(dbSkip())
	EndDo

	SD1->(dbGoto(nRecSd1))

return

//-- usado para inicializar os campos virtuais da tabela ZB8
User Function E136INIBRW(cCampo)
Local cVar := ''	
	If cCampo=="B1_DESC"
		cVar := Posicione("SB1",1,xFilial("SB1")+ZB8->ZB8_COD,cCampo)
	Else
		cVar := Posicione("SD1",1,xFilial("SD1")+ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA+ZB8_COD+ZB8_ITEM),cCampo)
	Endif
Return cVar

//-- Inclus�o do Recebimento
User Function E136RECEBE( nParam)
Local bOk         := {||fOk()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}

Local cTransp     := cLojTra := cDesTra := cMotori := cPlaca := ''
Local cChave      := ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA)

Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)

Private aHeader   := {}
Private aCols     := {}
Private aQtd      := {}

Private cDoc
Private cObs      := ""
Private lImp      := .F.
Private nPar      := nParam

	If nPar==2
		If ZB8->ZB8_STATUS<>'P'
			Alert('Recebimento n�o est� pendente!')
			return .f.
		EndIf
	EndIf
	/*ElseIf nPar==1
		If ZB8->ZB8_STATUS=='R'
			Alert('Recebimento est� pendente!')
			return .f.
		EndIf*/

	
	//-- C A B E C A L H O 
	//-- Posiciona a tabela de NF
	SF1->(dbsetorder(1))
	SF1->(dbSeek(xFilial("SF1")+cChave))

	cDoc     := ZB8->ZB8_DOC+'/'+ZB8->ZB8_SERIE
	dEmissao := SF1->F1_EMISSAO
	cHrEntr  := ZB8->ZB8_HRENTR

	SF8->(dbsetOrder(2)) // F8_FILIAL+F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA
	If SF8->(dbSeek(xFilial("SF8")+cChave))
		SA2->(dbsetorder(1)) // filial + cod + loja
		If SA2->(dbSeek(xFilial("SA2")+SF8->F8_TRANSP + SF8->F8_LOJTRAN))
			cTransp := SA2->A2_COD
			cLojTra := SA2->A2_LOJA
			cDesTra := SA2->A2_NOME
		EndIf
	Endif

	cForn := ZB8->ZB8_FORNEC
	cLoja := ZB8->ZB8_LOJA
	cDesFor := ''

	If SF1->F1_TIPO$'N'
		SA2->(dbsetorder(1)) // filial + cod + loja
		If SA2->(dbSeek(xFilial("SA2")+ZB8->ZB8_FORNEC + ZB8->ZB8_LOJA))
			cDesFor := SA2->A2_NOME
		EndIf
	Else
		SA1->(dbsetorder(1)) // filial + cod + loja
		If SA1->(dbSeek(xFilial("SA1")+ZB8->ZB8_FORNEC + ZB8->ZB8_LOJA))
			cDesFor := SA1->A1_NOME
		EndIf
	Endif

	If !Empty(SF1->F1_CODPLAC)
		If SO5->(dbSeek(xFilial("SO5")+SF1->F1_CODPLAC))
			cMotori := SO5->O5_DESCRI
			cPlaca  := SO5->O5_PLACA
		Endif
	Endif

	//-- I T E N S
	//adiciona os itens da nota no A C O L S
	//cria o array aQtd, que ir� conter as quantidades reais da nf para verifica��o da diverg�ncia

	aMatAnt := {}

	If nPar==2 //-- receber
		SD1->(dbSetOrder(1)) // FILIAL + DOC + SERIE + FORNECE + LOJA
		SD1->(dbSeek(xFilial("SD1")+cChave))

		WHILE SD1->(!EOF()) .AND. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA)
		      
    	    aAdd(aMatAnt,{SD1->D1_ITEM, SD1->D1_COD, SD1->D1_DESCRI, 0,SD1->D1_PEDIDO}) // CARREGA O ACOLS
			aAdd(aQtd, {SD1->D1_ITEM, SD1->D1_QUANT, SD1->D1_PEDIDO}) //quantidade dos itens

			SD1->(dbSkip())
		EndDo 
		
		aSort(aMatAnt,,,{|x,y| x[5]+x[1] < y[5]+y[1]}) //ordena o acols por pedido + item
		aSort(aQtd,,, {|x,y| x[3]+x[1] < y[3]+y[1]}) //ordena o aQtd  por pedido + item

		for xA:=1 to len(aMatAnt)
			aAdd(aCols,{ aMatAnt[xA][1],aMatAnt[xA][2],aMatAnt[xA][3],aMatAnt[xA][4],.f.})
		next

	ElseIf nPar==1 .or. nPar==3 //-- visual ou portaria
		cObs := ZB8->ZB8_OBS
		nRecZB8 := ZB8->(Recno())
	   	ZB8->(dbsetorder(1))
	   	SB1->(dbsetorder(1))
	   	ZB8->(dbSeek(xFilial("ZB8")+cChave))

		WHILE ZB8->(!EOF()) .AND. ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA)==cChave

			SB1->(dbSeek(xFilial("SB1")+ZB8->ZB8_COD))

    	    aAdd(aCols,{ZB8->ZB8_ITEM, ZB8->ZB8_COD, SB1->B1_DESC, ZB8->ZB8_QTDDIG,.F.}) // CARREGA O ACOLS

			ZB8->(dbSkip())
		EndDo

		ZB8->(dbgoto(nRecZB8))
	ElseIf nPar == 4 // Encerrar
		If !Alltrim(Upper(cUserName)) $ "LEANDROJS/HESSLERR/ADILSONMJ"
			alert("Apenas os usu�rios LEANDROJS/HESSLERR/ADILSONMJ podem utilizar esta fun��o! ")
			Return .F.
		EndIf
		If ZB8->ZB8_STATUS == "R" .AND. !Empty(ZB8->ZB8_HRPORT)
				alert("Ordem de Libera��o j� est� encerrada! Favor verifique. ")
				Return .F.
		EndIf
		If MsgYesNo("Deseja realmente excluir esta ordem de libera��o ? ")
			Begin Transaction
     			RecLock("ZB8",.F.)
     				ZB8->ZB8_STATUS := "R"
     				ZB8->ZB8_HRPORT := "99:99"
     			MsUnLock("ZB8")
   			End Transaction
   			MsgInfo("Ordem de libera��o exclu�da com sucesso!")
   			Return 
		Else
			Return
		EndIf
	ElseIf nPar == 5 // Alterar (apenas Observa��o)
		cObs := ZB8->ZB8_OBS
		nRecZB8 := ZB8->(Recno())
	   	ZB8->(dbsetorder(1))
	   	SB1->(dbsetorder(1))
	   	ZB8->(dbSeek(xFilial("ZB8")+cChave))
	   	
		While ZB8->(!EOF()) .AND. ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA)==cChave
			SB1->(dbSeek(xFilial("SB1")+ZB8->ZB8_COD))
    	    aAdd(aCols,{ZB8->ZB8_ITEM, ZB8->ZB8_COD, SB1->B1_DESC, ZB8->ZB8_QTDDIG,.F.}) // CARREGA O ACOLS
			ZB8->(dbSkip())
		EndDo 
		
		ZB8->(dbgoto(nRecZB8))
		bOk := {|| fAltera(cObs) }
	EndIf
			
	//-- A H E A D E R
	Aadd(aHeader,{"Item"       , "ZB8_ITEM"    ,PesqPict("ZB8","ZB8_ITEM")   ,04,0,".F.","","C","ZB8"}) //01
	Aadd(aHeader,{"Produto"    , "ZB8_COD"     ,PesqPict("ZB8","ZB8_COD")    ,15,0,".F.","","C","ZB8"}) //02
	Aadd(aHeader,{"Descri��o"  , "B1_DESC"     ,PesqPict("ZB8","B1_DESC")    ,40,0,".F.","","C","SB1"}) //03
	Aadd(aHeader,{"Quantidade" , "ZB8_QTDDIG"  ,PesqPict("ZB9","ZB9_QTDDIG") ,14,5,Iif(npar==2,".T.",".F."),"","N","ZB8"}) //04
		
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,)}

	oDlg := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Libera��o de Recebimento de Materiais",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	@ 020,010 Say "NF/Serie" Size 40,8 Object olNF
	@ 020,050 Get cDoc When .f. Size 50,8 Object oNF
	@ 020,140 Say "Emiss�o" Size 30,8 Object olEmissa
	@ 020,170 Get dEmissao Picture "99/99/9999" When .F. Size 40,8 Object oEmissa
	@ 020,310 Say "Hora Entrada" Size 30,8 Object olHora
	@ 020,335 Get cHrEntr Picture "99:99" When .F. Size 25,8 Object oHora

	@ 034,010 Say "Fornecedor" Size 040,8 Object olForn
	@ 032,050 Get cForn   Picture "@!" When .F.  Size 040,8 Object oForn
	@ 032,095 Get cLoja   Picture "@!" When .F.  Size 020,8 Object oLoja
	@ 032,120 Get cDesFor Picture "@!" When .F.  Size 200,8 Object oDForn	

	@ 046,010 Say "Transportadora:" Size 040,8 Object olTransp
	@ 044,050 Get cTransp When .f. Size 040,8 Object oTransp
	@ 044,095 Get cLojTra When .f. Size 020,8 Object oLojTra
	@ 044,120 Get cDesTra When .f. Size 200,8 Object oDesTra	

	@ 058,010 Say "Motorista" Size 40,8 Object olMotori
	@ 056,050 Get cMotori When .f. Size 70,8 Object oMotori
	@ 058,140 Say "Placa" Size 30,8 Object olPlaca
	@ 056,170 Get cPlaca Picture "!!!-9999" When .F. Size 40,8 Object oPlaca

	@ 070,010 Say "Observa��o" Size 40,8 Object olObs
	@ 068,050 Get oOBS VAR cObs When nPar == 2 .or. nPar == 5 MEMO Size 260,056 PIXEL OF oDlg

    // cria o getDados
	oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 126     ,; //superior
	                           aPosObj[2,2]     ,; //esquerda
	                           aPosObj[2,3]     ,; //inferior
	                           aPosObj[2,4]     ,; //direita
	                           4                ,; // nOpc
	                           "AllwaysTrue"    ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .T.              ,; // LDELETA
	                           nil              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           200              ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd
	                          )

	oGetD:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

//���������Ŀ
//� CANCELA �
//�����������
Static Function fEnd() 
	oDlg:End()
Return
	
Static Function fValida()
	
Return .T.
	
//�������������������Ŀ
//� GRAVA RECEBIMENTO �
//���������������������
Static Function fOk()
Local aItmDiv := {}
Local _cEnd
Private aDB := {} 
Private _aCabec := {}
Private _aItem := {}
Private _nQuant := space(5)

	If nPar==2 //-- receber
		lImp := .F.
		
		If !fValida()
			Return
		EndIf
	
		For _x := 1 to Len(aCols)
		
			If aQtd[_x][2] != aCols[_x][4]
				If MsgYesNo("Quantidades divergentes da NF! "+chr(13)+chr(10)+;
						    "Item ...................:"+aCols[_x][1]+chr(13)+chr(10)+;
						    "Quant. NF ..............:"+Alltrim(Str(aQtd[_x][2]))+chr(13)+chr(10)+;
						    "Quant. Digit. ..........:"+Alltrim(Str(aCols[_x][4]))+chr(13)+chr(10)+;
						    "Deseja Continuar ?")
					   
					aAdd(aItmDiv,_x)
					lImp := .T.
				Else
					Return .F.			
				EndIf
			EndIf
		Next
	
		nRecZB8 := ZB8->(recno()) // GUARDA O RECNO DO ZB8
		
		ZB8->(dbsetorder(1)) // ZB8_FILIAL+ZB8_NFISC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA+ZB8_ITEM                                                                                                     
		
		For _x:=1 to len(aCols)

			ZB8->(dbSeek(xFilial("ZB8")+ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA+aCols[_x][1])))

			Reclock("ZB8",.F.)
				ZB8->ZB8_QTDDIG := aCols[_x][4]
				ZB8->ZB8_OBS    := cObs
				ZB8->ZB8_STATUS := "R" //-- recebido
				ZB8->ZB8_USROK := alltrim(upper(cUsername))
				ZB8->ZB8_HROK := time()
				ZB8->ZB8_DTOK := date()
			MsUnlock("ZB8")
	
	    Next 
	    
	    For i := 1 to len(aCols)
	    	SB1->(DbSeek(xFilial("SB1") + aCols[i,2]))
	    	If SB1->B1_LOCALIZ == "S"
				SDA->(DbSeek(xFilial("SDA") + ZB8->ZB8_DOC + ZB8->ZB8_SERIE + ZB8->ZB8_FORNEC + ZB8->ZB8_LOJA))
				If SDA->DA_SALDO == 0
					loop
				EndIf
				
				If MsgYesNo("Deseja endere�ar o produto " + Alltrim(aCols[i,2]) + " ? ")
					_cEnd := EndProduto(aCols[i,2])
					SD1->(DbSeek(xFilial("SD1") + ZB8->ZB8_DOC + ZB8->ZB8_SERIE + ZB8->ZB8_FORNEC + ZB8->ZB8_LOJA))
					aAdd(aDB,{aCols[i,2],_cEnd,Val(_nQuant),SD1->D1_EMISSAO,SD1->D1_LOTECTL,SD1->D1_NUMLOTE,SD1->D1_LOCAL,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_TIPO,SD1->D1_ORIGEM,SD1->D1_NUMSEQ,SD1->D1_QTSEGUM,aCols[i,1]})
				EndIf
			EndIf
		Next i

		If Len(aDB) > 0
			For i := 1 to Len(aDB)
				_aCabec := {}
				_aItem  := {}

				SDA->(DbSetOrder(2) )
				SDA->(DbSeek(xFilial("SDA") + aDB[i,8] + aDB[i,9] + aDB[i,10] + aDB[i,11]))

				// Alimenta o Array com as Informa��es da nota
				alert(_nQuant)
				Aadd(_aCabec, {"DA_PRODUTO"	, aDB[i,1]  	   , nil})
	  			Aadd(_aCabec, {"DA_QTDORI"	, aDB[i,3]		   , nil})
				Aadd(_aCabec, {"DA_SALDO"	, aDB[i,3]		   , nil})
				Aadd(_aCabec, {"DA_DATA"	, SDA->DA_DATA     , nil})
				Aadd(_aCabec, {"DA_LOTECTL"	, aDB[i,5]	       , nil})
				Aadd(_aCabec, {"DA_NUMLOTE"	, aDB[i,6]	       , nil})
				Aadd(_aCabec, {"DA_LOCAL"	, aDB[i,7]		   , nil})
				Aadd(_aCabec, {"DA_DOC"		, aDB[i,8]		   , nil})
				Aadd(_aCabec, {"DA_SERIE"	, aDB[i,9]		   , nil})
				Aadd(_aCabec, {"DA_CLIFOR"	, aDB[i,10]	       , nil})
				Aadd(_aCabec, {"DA_LOJA"    , aDB[i,11]		   , nil})
				Aadd(_aCabec, {"DA_TIPONF"	, aDB[i,12]	       , nil})
				Aadd(_aCabec, {"DA_ORIGEM"	, aDB[i,13]	       , nil})
				Aadd(_aCabec, {"DA_NUMSEQ"	, SDA->DA_NUMSEQ   , nil})
				Aadd(_aCabec, {"DA_QTSEGUM"	, aDB[i,15]	       , nil})
				Aadd(_aCabec, {"DA_QTDORI2"	, aDB[i,3]	       , nil})

				Aadd(_aItem, {"DB_ITEM"		, strZero(i)        , nil})
				Aadd(_aItem, {"DB_LOCALIZ"	, aDB[i,2]      	, nil}) //Localizacao fixa
				Aadd(_aItem, {"DB_DATA"		, SDA->DA_DATA     	, nil})
				Aadd(_aItem, {"DB_QUANT"	, aDB[i,3]			, nil})
				Distribui()
			Next i
		EndIf

		If lImp
			fGrvDiv(aItmDiv)
			U_EST136IM()
		EndIf

		ZB8->(dbgoto(nRecZB8)) // - RETORNA A POSICAO DA TABELA ZB8

	ElseIf nPar==3 //-- portaria

		nRecZB8 := ZB8->(recno()) // GUARDA O RECNO DO ZB8
		ZB8->(dbsetorder(1)) // ZB8_FILIAL+ZB8_NFISC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA+ZB8_ITEM

		For _x:=1 to len(aCols)

			ZB8->(dbSeek(xFilial("ZB8")+ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA+aCols[_x][1])))

			Reclock("ZB8",.F.)
				ZB8->ZB8_USRPOR := alltrim(upper(cUsername))
				ZB8->ZB8_HRPORT := time()
				ZB8->ZB8_DTPORT := date()
			MsUnlock("ZB8")

	    Next

		ZB8->(dbgoto(nRecZB8)) // - RETORNA A POSICAO DA TABELA ZB8

	EndIf
	
	oDlg:End()	
	
Return

Static Function EndProduto(cProd)
Local oDlg
Local _cEnd := Space(08)
	
oDlg  := MsDialog():New(0,0,220,260,"Endere�amento de produto",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Produto: " + cProd},oDlg,,,,,,.T.,,)

	oSay2 := TSay():New(28,10,{||"Endere�o:"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(26,50,{|u| if(Pcount() > 0, _cEnd := u,_cEnd)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_cEnd")
	
	oSay2 := TSay():New(48,10,{||"Quantidade:"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(46,50,{|u| if(Pcount() > 0, _nQuant := u,_nQuant)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQuant")

	oBtn := tButton():New(68,50,"Ok",oDlg,{|| validaQuant(_nQuant) } ,60,10,,,,.T.)

oDlg:Activate(,,,.t.,{||.T.},,)


Return  _cEnd

Static Function validaQuant()

alert(SDA->DA_SALDO)
If Val(_nQuant ) > SDA->DA_SALDO .and. SDA->DA_SALDO != 0
	alert("Saldo Insuficiente para endere�ar. O saldo para endere�amento atual �: " + Val(SDA->DA_SALDO) + " . ")
	return .f.
Else
	oDlg:End()
EndIf

Return

//������������������������������������������������Ŀ
//� GRAVA NA TABELA DE DIVERGENCIAS AS OCORRENCIAS �
//��������������������������������������������������
Static Function fGrvDiv(aItens)
Local cRLF    := chr(13)+chr(10) 
Local aMailTo := {}


	cNum := GETSXENUM("ZDE","ZDE_NUM")

	For _x:=1 to Len(aItens)

		SB1->(dbSeek(xFilial("SB1")+aCols[aItens[_x]][2]))

		RecLock("ZDE",.T.)
			ZDE->ZDE_FILIAL := xFilial("ZDE")
			ZDE->ZDE_NUM    := cNum
			ZDE->ZDE_DOC    := Substr(cDoc,1,9)
			ZDE->ZDE_SERIE  := Substr(cDoc,11,3)
			ZDE->ZDE_ITEMNF := aCols[aItens[_x]][1]
			ZDE->ZDE_FORNEC := cForn
			ZDE->ZDE_LOJA   := cLoja
			ZDE->ZDE_COD    := aCols[aItens[_x]][2]
			ZDE->ZDE_STATUS := "P"
			ZDE->ZDE_DATA   := Date()
			ZDE->ZDE_LOGIN  := Upper(Alltrim(cUserName))
		MsUnLock("ZDE")
		
	Next
	
	confirmsx8()
	
	cMsg := 'Aviso de Diverg�ncia de Recebimento N�: '+cNum+CRLF
	cMsg += 'Empresa: '+ALLTRIM(SM0->M0_NOMECOM)+CRLF//WHB COMPONENTES AUTOMOTIVOS S\A"
	cMsg += "Endere�o: "+ALLTRIM(SM0->M0_ENDCOB)+" Cep:"+alltrim(SM0->M0_CEPCOB)+CRLF//Rua Wiegando Olsen, 1000 CEP 81450-100"
	cMsg += "CGC: "+alltrim(SM0->M0_CGC)+CRLF //73.355.174/0001-40"
	cMsg += ALLTRIM(SM0->M0_BAIRENT)+" - "+ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT)+CRLF//Cidade Industrial de Curitiba - Curitiba - PR"
	cMsg += "Insc. Est.: "+ALLTRIM(SM0->M0_INSC)+CRLF+CRLF

	cChave := Substr(cDoc,1,9)+Substr(cDoc,11,3)+cForn+cLoja
	cLogin := Upper(Alltrim(cUserName))

	cMsg += "<table>"
	cMsg += '<tr><td>Setor Fiscal:</td><td>Telefone: (41) 3341-1990</td><td>Email: lista-fiscal@whbbrasil.com.br</td></tr>'
	cMsg += '<tr><td>Controladoria:</td><td>Telefone: (41) 3341-1340</td><td>Email: lista-controladoria@whbbrasil.com.br</td></tr>'
	cMsg += '<tr><td>Log�stica:</td><td>Telefone: (41) 3341-1328</td><td>Email: lista-logisticainterna@whbbrasil.com.br</td></tr>'
	cMsg += "</table>"+CRLF+CRLF
		
	ZDE->(dbGoTop())
	ZDE->(dbSetOrder(2)) // ZDE_FILIAL+ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA
	ZDE->(dbSeek(xFilial("ZDE")+cChave))

	SF1->(dbSetOrder(1)) // FILIAL + NF + SERIE + FORN + LOJA
	SF1->(dbSeek(xFilial("SF1")+cChave))
	
	cMailCF := ''
	
	If AllTrim(SF1->F1_TIPO)$"B/D"
		SA1->(dbSetOrder(1)) // FILIAL + COD + LOJA
		SA1->(dbSeek(xFilial("SA1")+ZDE->ZDE_FORNEC+ZDE->ZDE_LOJA))
		cNomeF  := SA1->A1_NOME
		cEndF   := SA1->A1_END
		cCGCF   := SA1->A1_CGC
		cMunF   := SA1->A1_MUN
		cEstF   := SA1->A1_EST 
		cInscF  := SA1->A1_INSCR

		if(!empty(SA1->A1_EMAIL))
			aAdd(aMailTo,ALLTRIM(SA1->A1_EMAIL))
		Endif
	Else
		SA2->(dbSetOrder(1)) // FILIAL + COD + LOJA
		SA2->(dbSeek(xFilial("SA2")+ZDE->ZDE_FORNEC+ZDE->ZDE_LOJA))
		cNomeF := SA2->A2_NOME
		cEndF  := SA2->A2_END
		cCGCF  := SA2->A2_CGC
		cMunF  := SA2->A2_MUN
		cEstF  := SA2->A2_EST 
		cInscF := SA2->A2_INSCR

		if(!empty(SA2->A2_EMAIL))
			aAdd(aMailTo,ALLTRIM(SA2->A2_EMAIL))
		Endif

	EndIf

	//-- busca dados do cadastro de veiculos	
	cMotori := ''
	cPlaca  := ''
	cRG     := ''
	If !Empty(SF1->F1_CODPLAC) 
		SO5->(dbsetorder(1))//O5_FILIAL+O5_CODIGO
		If SO5->(dbSeek(xFilial("SO5")+SF1->F1_CODPLAC))
			cMotori := SO5->O5_DESCRI
			cPlaca  := SO5->O5_PLACA
			cRG     := SO5->O5_CHASSI
		Endif
	Endif

	//-- busca dados da transportadora
	cDesTra := ''
	SF8->(dbsetOrder(2)) // F8_FILIAL+F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA
	If SF8->(dbSeek(xFilial("SF8")+cChave))
		SA2->(dbsetorder(1)) // filial + cod + loja
		If SA2->(dbSeek(xFilial("SA2")+SF8->F8_TRANSP + SF8->F8_LOJTRAN))
			cDesTra := SA2->A2_NOME
		EndIf
	Endif

	cMsg += "Empresa:  "+cNomeF+CRLF
	cMsg += "Endere�o: "+cEndF+" CGC: "+cCGCF+CRLF
	cMsg += AllTrim(cMunF)+" - "+cEstF+CRLF
	cMsg += "Insc. Est.: "+cInscF+CRLF+CRLF
	
	cMsg += "Informamos que os documentos abaixo apresentam irregularidades "
	cMsg += "ao dar entrada no recebimento desta empresa na data de: "+DtoC(ZDE->ZDE_DATA)+CRLF+CRLF

	cMsg += '<table border="1"><tr><td>DATA NF.</td><td>Nota Fiscal/Serie</td><td>C�digo Produto</td><td>C�digo WHB</td>'
	cMsg += '<td>Qtd. NF.</td><td>Qtd. F�sico</td><td>Diferen�a</td><TD>Unidade</TD></tr>'
	
	SD1->(dbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SB1->(dbSetOrder(1)) // FILIAL + COD

	nRecZB8 := ZB8->(Recno())
	
	ZB8->(dbsetorder(1))
	SY1->(DbSetOrder(3))
	SC7->(DbSetOrder(1)) 

	WHILE ZDE->(!EOF()) .AND. ZDE->(ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA) == cChave

		SD1->(dbSeek(xFilial("SD1")+cChave+ZDE->(ZDE_COD+ZDE_ITEMNF)))
		ZB8->(dbSeek(xFilial("ZB8")+cChave+ZDE->ZDE_ITEMNF))
                 
		cMsg += '<tr>'
		cMsg += '<td>'+ DtoC(SD1->D1_EMISSAO)+'</td>'
		cMsg += '<td>'+ ZDE->ZDE_DOC+" - "+ZDE->ZDE_SERIE+'</td>'

		SB1->(dbSeek(xFilial("SB1")+ZDE->ZDE_COD))
	
		cMsg += '<td>'+ Iif(Empty(AllTrim(SB1->B1_CODAP5)),"-",AllTrim(SB1->B1_CODAP5))+'</td>'
		cMsg += '<td>'+ AllTrim(SB1->B1_COD)+'</td>'
		cMsg += '<td>'+ transform(SD1->D1_QUANT , "@e 99999999") +'</td>'//quantidade nf
		cMsg += '<td>'+ transform(ZB8->ZB8_QTDDIG, "@e 99999999")+'</td>' //quantidade fisico
		cMsg += '<td>&nbsp;'+ transform((ZB8->ZB8_QTDDIG - SD1->D1_QUANT), "@e 99999999") +'</td>'//diferenca
		cMsg += '<td>'+ SD1->D1_UM +'</td>'//quantidade nf
		
		cMsg += '</tr>'
	       
	    //CHAMADO: 064345                        
		IF SC7->(dbseek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))

			//email do comprador
			If SY1->(DbSeek(xFilial("SY1")+UPPER(SC7->C7_USER)))
				If !empty(SY1->Y1_EMAIL) .AND. ISEMAIL(ALLTRIM(SY1->Y1_EMAIL))
					aAdd(aMailTo, Alltrim(SY1->Y1_EMAIL))
				ENDIF
			ENDIF
		ENDIF	
		//FIM CHAMADO: 064345
				
		ZDE->(dbSkip())
		
	ENDDO
	
	cMsg += "</table>"+crlf+crlf
		
	cMsg += "Conferente: "+cLogin+crlf
	cMsg += "Motorista: "+ cMotori+crlf
    
	cMsg += "RG: "+cRG+crlf
	cMsg += "Transportadora: "+cDesTra+crlf
	cMsg += "Caminh�o / Placa: "+cPlaca+crlf+crlf
	
	cMsg += "** Na hip�tese de material faltante, ser� emitida Nota Fiscal de devolu��o / retorno mencionando o n�mero" 
	cMsg += " deste aviso de diverg�ncia."+crlf
	cMsg += "** Na hip�tese de material excedente, favor enviar sua nota fiscal complementar."+crlf+crlf
	
	aAdd(aMailTo, 'luizwj@whbbrasil.com.br')

	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** AVISO DE DIVERG�NCIA DE RECEBIMENTO (N� "+cNum+") ***"

	oMail:cTo := ''
	for xE:=1 to len(aMailTo)
		oMail:cTo += aMailTo[xE]
		if xE<len(aMailTo)
			oMail:cTo += ';'
		endif
	next

	oMail:Envia() 

Return

//�����������������������������������Ŀ
//� IMPRESSAO DO AVISO DE DIVERGENCIA �
//�������������������������������������
User Function EST136IM(nIMP)

	If nIMP==2
		ZB8->(dbsetorder(1))
		ZB8->(dbSeek(xFilial("ZB8")+ZDE->(ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA)))
	EndIf

	oRelato2          := Relatorio():New()
	
	oRelato2:cString  := "SF1"
    oRelato2:cPerg    := ""
	oRelato2:cNomePrg := "NHEST136"
	oRelato2:wnrel    := oRelato2:cNomePrg

	//descricao
	oRelato2:cDesc1   := "Imprime o aviso de diverg�ncia de recebimento de produto"
	oRelato2:cDesc2   := ""

	//titulo
	oRelato2:cTitulo  := "AVISO DE DIVERG�NCIA EM NOTA FISCAL N�:"+ZDE->ZDE_NUM

	//cabecalho
	oRelato2:cCabec1  := ""
    oRelato2:cCabec2  := ""

	oRelato2:Run({||Imprime2()})

Return

Static Function Imprime2()
Local cChave := ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA)
Local cLogin := ZDE->ZDE_LOGIN
Local cCfr := ''

	oRelato2:Cabec()

	@Prow()+1 , 063 psay "NR.(Lote da Ocorr�ncia): "
	@Prow()+1 , 001 psay "Empresa:  "+ALLTRIM(SM0->M0_NOMECOM)//WHB COMPONENTES AUTOMOTIVOS S\A"
	@Prow()   , 063 psay "STATUS:                  (ABERTO/OK)"
	@Prow()+1 , 001 psay "Endere�o: "+ALLTRIM(SM0->M0_ENDCOB)+" Cep:"+alltrim(SM0->M0_CEPCOB)//Rua Wiegando Olsen, 1000 CEP 81450-100"
	@Prow()   , 063 psay "CGC:                     "+alltrim(SM0->M0_CGC) //73.355.174/0001-40"
	@Prow()+1 , 001 psay "          "+ALLTRIM(SM0->M0_BAIRENT)+" - "+ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT)//Cidade Industrial de Curitiba - Curitiba - PR"
	@Prow()   , 063 psay "Insc. Est.:              "+ALLTRIM(SM0->M0_INSC) //101.97482-07"

	@Prow()+1 , 000 psay __PrtThinLine()

	@Prow()+1 , 001 psay "Setor Fiscal:                    Telefone: (41) 3341-1990            Email: lista-fiscal@whbbrasil.com.br"
	@Prow()+1 , 001 psay "Controladoria:                   Telefone: (41) 3341-1340            Email: lista-controladoria@whbbrasil.com.br"
	@Prow()+1 , 001 psay "Log�stica:                       Telefone: (41) 3341-1328            Email: lista-logisticainterna@whbbrasil.com.br"

	@Prow()+1 , 000 psay __PrtThinLine()

	ZDE->(dbGoTop())
	ZDE->(dbSetOrder(2)) // ZDE_FILIAL+ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA
	ZDE->(dbSeek(xFilial("ZDE")+cChave))

	SF1->(dbSetOrder(1)) // FILIAL + NF + SERIE + FORN + LOJA
	SF1->(dbSeek(xFilial("SF1")+cChave))

	If AllTrim(SF1->F1_TIPO)$"B/D"
		SA1->(dbSetOrder(1)) // FILIAL + COD + LOJA
		SA1->(dbSeek(xFilial("SA1")+ZDE->ZDE_FORNEC+ZDE->ZDE_LOJA))
		cNomeF := SA1->A1_NOME
		cEndF  := SA1->A1_END
		cCGCF  := SA1->A1_CGC
		cMunF  := SA1->A1_MUN
		cEstF  := SA1->A1_EST 
		cInscF := SA1->A1_INSCR
	Else
		SA2->(dbSetOrder(1)) // FILIAL + COD + LOJA
		SA2->(dbSeek(xFilial("SA2")+ZDE->ZDE_FORNEC+ZDE->ZDE_LOJA))
		cNomeF := SA2->A2_NOME
		cEndF  := SA2->A2_END
		cCGCF  := SA2->A2_CGC
		cMunF  := SA2->A2_MUN
		cEstF  := SA2->A2_EST 
		cInscF := SA2->A2_INSCR
	EndIf

	//-- busca dados do cadastro de veiculos	
	cMotori := ''
	cPlaca  := ''
	cRG     := ''
	If !Empty(SF1->F1_CODPLAC) 
		SO5->(dbsetorder(1))//O5_FILIAL+O5_CODIGO
		If SO5->(dbSeek(xFilial("SO5")+SF1->F1_CODPLAC))
			cMotori := SO5->O5_DESCRI
			cPlaca  := SO5->O5_PLACA
			cRG     := SO5->O5_CHASSI
		Endif
	Endif

	//-- busca dados da transportadora
	cDesTra := ''
	SF8->(dbsetOrder(2)) // F8_FILIAL+F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA
	If SF8->(dbSeek(xFilial("SF8")+cChave))
		SA2->(dbsetorder(1)) // filial + cod + loja
		If SA2->(dbSeek(xFilial("SA2")+SF8->F8_TRANSP + SF8->F8_LOJTRAN))
			cDesTra := SA2->A2_NOME
		EndIf
	Endif

	@Prow()+1 , 001 psay "Empresa:  "+cNomeF
	@Prow()+1 , 001 psay "Endere�o: "+cEndF
	@Prow()   , 076 psay "CGC:        "+cCGCF
	@Prow()+1 , 001 psay "          "+AllTrim(cMunF)+" - "+cEstF
	@Prow()   , 076 psay "Insc. Est.: "+cInscF
	
	@Prow()+2 , 010 psay "Informamos que os documentos abaixo apresentam irregularidades"
	@Prow()+1 , 010 psay "ao dar entrada no recebimento desta empresa na data de: "+DtoC(ZDE->ZDE_DATA)

	@Prow()+2 , 000 psay __PrtThinLine()
	
	@Prow()+1 , 000 psay "DATA NF.       Nota Fiscal/Serie   C�digo Produto     C�digo WHB          Qtd. NF.   Qtd. F�sico    Diferen�a      Obs. / NF Triang."
	
	SD1->(dbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SB1->(dbSetOrder(1)) // FILIAL + COD

	nRecZB8 := ZB8->(Recno())
	
	ZB8->(dbsetorder(1))
	
	WHILE ZDE->(!EOF()) .AND. ZDE->(ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA) == cChave
	
		cCfr := ZDE->ZDE_LOGIN
		SD1->(dbSeek(xFilial("SD1")+cChave+ZDE->(ZDE_COD+ZDE_ITEMNF)))
		ZB8->(dbSeek(xFilial("ZB8")+cChave+ZDE->ZDE_ITEMNF))

		@Prow()+1 , 000 psay DtoC(SD1->D1_EMISSAO)
		@Prow()   , 015 psay ZDE->ZDE_DOC+" - "+ZDE->ZDE_SERIE

		SB1->(dbSeek(xFilial("SB1")+ZDE->ZDE_COD))
	
		@Prow()   , 035 psay Iif(Empty(AllTrim(SB1->B1_CODAP5)),"-",AllTrim(SB1->B1_CODAP5))
		@Prow()   , 054 psay AllTrim(SB1->B1_COD)
		@Prow()   , 071 psay SD1->D1_QUANT   Picture "@e 99999999" //quantidade nf
		@Prow()   , 083 psay ZB8->ZB8_QTDDIG Picture "@e 99999999" //quantidade fisico
		@Prow()   , 098 psay (ZB8->ZB8_QTDDIG - SD1->D1_QUANT) Picture "@e 99999999" //diferenca
//		@Prow()   , 115 psay ""
	
		ZDE->(dbSkip())
		
	ENDDO

	@Prow()+1 , 000 psay __PrtThinLine()

	@Prow()+2 , 010 psay "Irregularidades constatadas por:"
	
	@Prow()+3 , 010 psay "________________________________"
	@Prow()   , 090 psay "________________________________"

	//@Prow()+1 , 015 psay "Conferente: "+cLogin
	@Prow()+1 , 015 psay "Conferente: "+cCfr
	@Prow()   , 090 psay "       Motorista: "+ cMotori
    
	If !Empty(cLogin)
		//@Prow()+1 , 015 psay " Matr�cula: " + Posicione("QAA",6,ALLTRIM(UPPER(cLogin)),"QAA_MAT")
		@Prow()+1 , 015 psay " Matr�cula: " + Posicione("QAA",6,ALLTRIM(UPPER(cCfr)),"QAA_MAT")
	Else
		@Prow()+1 , 015 psay ""
	Endif	
		
	@Prow()   , 090 psay "              RG: "+cRG
	@Prow()+1 , 090 psay "  Transportadora: "+cDesTra
	@Prow()+1 , 090 psay "Caminh�o / Placa: "+cPlaca
	
	@Prow()+3 , 001 psay "** Na hip�tese de material faltante, ser� emitida Nota Fiscal de devolu��o / retorno mencionando o n�mero" 
	@Prow()+1 , 001 psay "   deste aviso de diverg�ncia."
	@Prow()+1 , 001 psay "** Na hip�tese de material excedente, favor enviar sua nota fiscal complementar."
	
	@Prow()+2 , 001 psay "+-------------------------------------------+"
	@Prow()+1 , 001 psay "| Recebido:                                 |"
	@Prow()+1 , 001 psay "| ____/____/___________                     |"
	@Prow()+1 , 001 psay "|                                           |"
	@Prow()+1 , 001 psay "| _____________________                     |"
	@Prow()+1 , 001 psay "| Assinatura e Carimbo                      |"
	@Prow()+1 , 001 psay "+-------------------------------------------+"	

	@Prow()+1 , 000 psay __PrtThinLine()	
	
	ZDE->(dbSetOrder(1)) // ZDE_FILIAL+ZDE_NUM

	ZB8->(dbGoTo(nRecZB8))

Return

//���������Ŀ
//� LEGENDA �
//�����������
User Function EST136LEG()

Local aLegenda :=	{ {"BR_VERDE"    , "Receb. Pendente / Portaria Pendente"  },;
  					  {"BR_CINZA"    , "Receb. Pendente / Portaria Ok"        },;
  					  {"BR_AMARELO"  , "Receb. Ok / Portaria Pendente"        },;
  					  {"BR_VERMELHO" , "Receb. Ok / Portaria Ok"              }}
  					  
BrwLegenda(OemToAnsi("Diverg�ncia Recebimento"), "Legenda", aLegenda)

Return

Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Receb. Pendente / Portaria Pendente"  },;
  					  {"BR_CINZA"    , "Receb. Pendente / Portaria Ok"        },;
  					  {"BR_AMARELO"  , "Receb. Ok / Portaria Pendente"        },;
  					  {"BR_VERMELHO" , "Receb. Ok / Portaria Ok"              }}

	Local uRetorno := {}
	Aadd(uRetorno, { 'ZB8->ZB8_STATUS == "P" .and. Alltrim(ZB8->ZB8_HRPORT)==""' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZB8->ZB8_STATUS == "P" .and. Alltrim(ZB8->ZB8_HRPORT)!=""' , aLegenda[2][1] } )
	Aadd(uRetorno, { 'ZB8->ZB8_STATUS == "R" .and. Alltrim(ZB8->ZB8_HRPORT)==""' , aLegenda[3][1] } )
	Aadd(uRetorno, { 'ZB8->ZB8_STATUS == "R" .and. Alltrim(ZB8->ZB8_HRPORT)!=""' , aLegenda[4][1] } )	
	
Return(uRetorno)          

Static Function fAltera(Observacao) 
	
	RecLock("ZB8",.F.)
		ZB8->ZB8_OBS := Observacao
	MsUnLock("ZB8")
	
	oDlg:End()
Return

Static Function Distribui()
		
	//����������������������������������������������������������������Ŀ
	//� Efetua a distribui��o do saldo total para o endere�o informado �
	//� atrav�s da chamada da rotina padr�o autom�tica, dentro de uma  �
	//� transa��o.                                                     �
	//������������������������������������������������������������������
	lMsErroAuto := .F.
	Begin Transaction
		Processa({|| MsExecAuto({|x,y,z|mata265(x,y,z)}, _aCabec, {_aItem}, 3 ) },"Endere�ando Produtos...")
			//����������������������������������������������������������Ŀ
			//� Se houver qualquer problema retornado pela vari�vel      �
			//� "lMsErroAuto", restaura a integridade dos dados gravados �
			//������������������������������������������������������������
		IF lMsErroAuto
			DisarmTransaction()
			Break
		Endif
	End Transaction

	//��������������������������������������������������������������
	//� Havendo a ocorr�ncia do erro, exibe LOG informativo padr�o �
	//��������������������������������������������������������������
	IF lMsErroAuto
		MostraErro()
	Endif
Return

User Function E136RETORNA()
Local cPermissao := "ELIBERTOSO/ADILSONMJ/LEANDROJS"

	If !ALLTRIM(UPPER(cUserName))$(cPermissao+"/ADMIN/ADMINISTRADOR/JOAOFR/ALEXANDRERB/MARCOSR")
		Alert('Usu�rio n�o autorizado!'+chr(13)+chr(10)+;
			  'Permitido apenas para: '+cPermissao)
		Return
	Endif

	If MsgYesNo('Deseja retornar o recebimento para pendente?')
		Reclock("ZB8",.F.)
			ZB8->ZB8_STATUS := "P"
			ZB8->ZB8_HRPORT := ""
			ZB8->ZB8_USRPOR := ''
			ZB8->ZB8_HRPORT := ''
			ZB8->ZB8_DTPORT := CTOD('')
			ZB8->ZB8_QTDDIG := 0
			ZB8->ZB8_OBS    := ''
			ZB8->ZB8_USROK  := ''
			ZB8->ZB8_HROK   := ''
			ZB8->ZB8_DTOK   := CTOD('')
		MsUnlock("ZB8")
	Endif	
	
Return