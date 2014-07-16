/*   
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST136   ºAutor  ³João Felipe        º Data ³  08/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ORDEM DE LIBERACAO DE RECEBIMENTO                          º±±
±±º          ³ AVISO DE DIVERGÊNCIA                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP / RECEBIMENTO / PORTARIA                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßdßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function NHEST136()  

SetPrvt("cCadastro, aRotina") 

cCadastro := OemToAnsi("Ordem de Liberação de Recebimento de Materiais")
aRotina   := {{"Pesquisar"    ,"AxPesqui"        , 0 , 1},;
             { "Visualizar"   ,"U_E136RECEBE(1)" , 0 , 2},;             //{ "Importar"     ,"U_E136IMPORT()"  , 0 , 3},;
             { "Receber"      ,"U_E136RECEBE(2)" , 0 , 3},;
             { "Encerrar"     ,"U_E136RECEBE(4)" , 0 , 4},;  
             { "Alterar"      ,"U_E136RECEBE(5)" , 0 , 4},;    
             { "Enc. Vários"  ,"U_NHEST196()"    , 0 , 4},;
             { "Portaria"     ,"U_E136RECEBE(3)" , 0 , 5},;             //{ "Imprimir"     ,"U_EST136IM(1)"   , 0 , 5},;             { "Receb. OK"    ,"U_EST136(5)"     , 0 , 5},;             { "Rot. Coleta"  ,"U_EST136ROT()"   , 0 , 5},;
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

//-- Importação manual da nota
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

//-- Inclusão do Recebimento
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
			Alert('Recebimento não está pendente!')
			return .f.
		EndIf
	EndIf
	/*ElseIf nPar==1
		If ZB8->ZB8_STATUS=='R'
			Alert('Recebimento está pendente!')
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
	//cria o array aQtd, que irá conter as quantidades reais da nf para verificação da divergência
	
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
		If !Alltrim(Upper(cUserName)) $ "LEANDROJS/HESSLERR/JOSEMF"
			alert("Apenas os usuários LEANDROJS e HESSLERR podem utilizar esta função! ")
			Return .F.
		EndIf	      
		If ZB8->ZB8_STATUS == "R" .AND. !Empty(ZB8->ZB8_HRPORT)
				alert("Ordem de Liberação já está encerrada! Favor verifique. ")
				Return .F.
		EndIf
		If MsgYesNo("Deseja realmente excluir esta ordem de liberação ? ")
			Begin Transaction
     			RecLock("ZB8",.F.)
     				ZB8->ZB8_STATUS := "R"
     				ZB8->ZB8_HRPORT := "99:99"
     			MsUnLock("ZB8")
   			End Transaction
   			MsgInfo("Ordem de liberação excluída com sucesso!")
   			Return 
		EndIf
	ElseIf nPar == 5 // Alterar (apenas Observação)
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
	Aadd(aHeader,{"Descrição"  , "B1_DESC"     ,PesqPict("ZB8","B1_DESC")    ,40,0,".F.","","C","SB1"}) //03
	Aadd(aHeader,{"Quantidade" , "ZB8_QTDDIG"  ,PesqPict("ZB9","ZB9_QTDDIG") ,14,5,Iif(npar==2,".T.",".F."),"","N","ZB8"}) //04
		
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,)}

	oDlg := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Liberação de Recebimento de Materiais",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	@ 020,010 Say "NF/Serie" Size 40,8 Object olNF
	@ 020,050 Get cDoc When .f. Size 50,8 Object oNF
	@ 020,140 Say "Emissão" Size 30,8 Object olEmissa
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

	@ 070,010 Say "Observação" Size 40,8 Object olObs
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

	oGetD:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ CANCELA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
Static Function fEnd() 
	oDlg:End()
Return
	
Static Function fValida()
	
Return .T.
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA RECEBIMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fOk()
Local aItmDiv := {}

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA NA TABELA DE DIVERGENCIAS AS OCORRENCIAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvDiv(aItens)

	For _x:=1 to Len(aItens)
	
		cNum := GETSXENUM("ZDE","ZDE_NUM")

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
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRESSAO DO AVISO DE DIVERGENCIA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	oRelato2:cDesc1   := "Imprime o aviso de divergência de recebimento de produto"
	oRelato2:cDesc2   := ""

	//titulo
	oRelato2:cTitulo  := "AVISO DE DIVERGÊNCIA EM NOTA FISCAL"

	//cabecalho      
	oRelato2:cCabec1  := ""
    oRelato2:cCabec2  := ""
		    
	oRelato2:Run({||Imprime2()})

Return

Static Function Imprime2() 
Local cChave := ZB8->(ZB8_DOC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA)
Local cLogin := ZDE->ZDE_LOGIN

	oRelato2:Cabec()

	@Prow()+1 , 063 psay "NR.(Lote da Ocorrência): "
	@Prow()+1 , 001 psay "Empresa:  WHB COMPONENTES AUTOMOTIVOS S\A"
	@Prow()   , 063 psay "STATUS:                  (ABERTO/OK)"
	@Prow()+1 , 001 psay "Endereço: Rua Wiegando Olsen, 1000 CEP 81450-100"
	@Prow()   , 063 psay "CGC:                     73.355.174/0001-40"
	@Prow()+1 , 001 psay "          Cidade Industrial de Curitiba - Curitiba - PR"
	@Prow()   , 063 psay "Insc. Est.:              101.97482-07"

	@Prow()+1 , 000 psay __PrtThinLine()
	
	@Prow()+1 , 001 psay "Setor Fiscal:                    Telefone: (41) 3341-1990            Email: lista-fiscal@whbbrasil.com.br"
	@Prow()+1 , 001 psay "Controladoria:                   Telefone: (41) 3341-1340            Email: lista-controladoria@whbbrasil.com.br"
	@Prow()+1 , 001 psay "Logística:                       Telefone: (41) 3341-1328            Email: lista-logisticainterna@whbbrasil.com.br"
	
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
	@Prow()+1 , 001 psay "Endereço: "+cEndF
	@Prow()   , 076 psay "CGC:        "+cCGCF
	@Prow()+1 , 001 psay "          "+AllTrim(cMunF)+" - "+cEstF
	@Prow()   , 076 psay "Insc. Est.: "+cInscF
	
	@Prow()+2 , 010 psay "Informamos que os documentos abaixo apresentam irregularidades"
	@Prow()+1 , 010 psay "ao dar entrada no recebimento desta empresa na data de: "+DtoC(ZDE->ZDE_DATA)

	@Prow()+2 , 000 psay __PrtThinLine()
	
	@Prow()+1 , 000 psay "DATA NF.       Nota Fiscal/Serie   Código Produto     Código WHB          Qtd. NF.   Qtd. Físico    Diferença      Obs. / NF Triang."
	
	SD1->(dbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SB1->(dbSetOrder(1)) // FILIAL + COD

	nRecZB8 := ZB8->(Recno())
	
	ZB8->(dbsetorder(1))
	
	WHILE ZDE->(!EOF()) .AND. ZDE->(ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA) == cChave

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

	@Prow()+1 , 015 psay "Conferente: "+cLogin
	@Prow()   , 090 psay "       Motorista: "+ cMotori
    
	If !Empty(cLogin)
		@Prow()+1 , 015 psay " Matrícula: " + Posicione("QAA",6,ALLTRIM(UPPER(cLogin)),"QAA_MAT")
	Else
		@Prow()+1 , 015 psay ""
	Endif	
		
	@Prow()   , 090 psay "              RG: "+cRG
	@Prow()+1 , 090 psay "  Transportadora: "+cDesTra
	@Prow()+1 , 090 psay "Caminhão / Placa: "+cPlaca
	
	@Prow()+3 , 001 psay "** Na hipótese de material faltante, será emitida Nota Fiscal de devolução / retorno mencionando o número" 
	@Prow()+1 , 001 psay "   deste aviso de divergência."
	@Prow()+1 , 001 psay "** Na hipótese de material excedente, favor enviar sua nota fiscal complementar."
	
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

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function EST136LEG()

Local aLegenda :=	{ {"BR_VERDE"    , "Receb. Pendente / Portaria Pendente"  },;
  					  {"BR_CINZA"    , "Receb. Pendente / Portaria Ok"        },;
  					  {"BR_AMARELO"  , "Receb. Ok / Portaria Pendente"        },;
  					  {"BR_VERMELHO" , "Receb. Ok / Portaria Ok"              }}
  					  
BrwLegenda(OemToAnsi("Divergência Recebimento"), "Legenda", aLegenda)

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


/*






















//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST136(nParam)

Private nPar := nParam

	If nPar==3 //incluir
		Processa( {|| fGerando() } , "Aguarde Pesquisando...")
		Processa( {|| fRptDet()  } , "Gerando...")
	ElseIf nPar==5 
	
		If ZB8->ZB8_STATUS=='E'
			Alert("Recebimento já Encerrado!")
		Else
			If MsgYesNo("Tem certeza de que deseja marcar esta divergência como OK?")
				RecLock("ZB8",.F.)
					ZB8->ZB8_STATUS := "E"
					ZB8->ZB8_DTOK   := date()
					ZB8->ZB8_HROK   := time()
					ZB8->ZB8_USROK  := UPPER(ALLTRIM(cUserName))
				MsUnlock("ZB8")
			Endif
		Endif
	Else
		U_fOrdLib2()
	EndIf
   
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ AS NOTAS FISCAIS QUE NAO FORAM LIBERADAS E QUE O CAMINHAO AINDA NAO SAIU NA PORTARIA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGerando()
Local cQuery 
                 
	ProcRegua(0)
	
	ajustaSx1()

	If !Pergunte("EST136",.T.)
		Return
	EndIf

	cQuery := " SELECT D1.D1_DOC, D1.D1_SERIE, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_DTDIGIT, F1.F1_CODPLAC, " 
	cQuery += " 'A2_NOME' = "
	cQuery += " CASE "
	cQuery += " 	WHEN F1.F1_TIPO = 'B' THEN "
	cQuery += "          (SELECT SA1.A1_NOME FROM "+RetSqlName("SA1")+" SA1 "
	cQuery += "          WHERE SA1.D_E_L_E_T_ = ' ' "
	cQuery += "          AND SA1.A1_COD = D1.D1_FORNECE "
	cQuery += "          AND SA1.A1_LOJA = D1.D1_LOJA) "
	cQuery += "     ELSE "
	cQuery += " 		(SELECT SA2.A2_NOME FROM "+RetSqlName("SA2")+" SA2 "
	cQuery += "  		 WHERE SA2.D_E_L_E_T_ = ' ' "
	cQuery += "          AND SA2.A2_COD = D1.D1_FORNECE "
	cQuery += "          AND SA2.A2_LOJA = D1.D1_LOJA) "
	cQuery += " END "
	cQuery += " FROM "+RetSqlName("SD1")+" D1, "+RetSqlName("SF1")+" F1 " //, "+RetSqlName("SO5")+" O5"
	cQuery += " WHERE "
//	cQuery += " O5.O5_HORASAI = ''" // SO PEGA AS NOTAS QUE O CAMINHAO AINDA NAO SAIU NA PORTARIA
	cQuery += " D1.D1_ORDLIB = '' "
	cQuery += " AND D1.D1_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND D1.D1_SERIE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND D1.D1_FORNECE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND D1.D1_LOJA BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND D1.D1_DTDIGIT > '20090901'"
//	cQuery += " AND F1.F1_CODPLAC = O5.O5_CODIGO"
	cQuery += " AND D1.D1_DOC = F1.F1_DOC"
	cQuery += " AND D1.D1_SERIE = F1.F1_SERIE"
	cQuery += " AND D1.D1_FORNECE = F1.F1_FORNECE"
	cQuery += " AND D1.D1_LOJA = F1.F1_LOJA"
	cQuery += " AND D1.D_E_L_E_T_ = '' AND D1.D1_FILIAL = '"+xFilial("SD1")+"' "
	cQuery += " AND F1.D_E_L_E_T_ = '' AND F1.F1_FILIAL = '"+xFilial("SF1")+"' "
//	cQuery += " AND O5.D_E_L_E_T_ = '' AND O5.O5_FILIAL = '"+xFilial("SO5")+"' "
	cQuery += " GROUP BY D1.D1_DOC, D1.D1_SERIE, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_DTDIGIT, F1.F1_CODPLAC, F1.F1_TIPO"

	TCQUERY cQuery NEW ALIAS "TRA1"
    
    TcSetField("TRA1","D1_DTDIGIT","D")  //Muda a data de string para date

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PARA CRIAR AS PERGUNTAS NO SX1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AjustaSX1()
SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")
_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := PadR("EST136",10)
aRegs   := {}

aadd(aRegs,{cPerg,"01","De N.Fiscal ?"    ,"De N.Fiscal ?"      ,"De N.Fiscal ?  "   ,"mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF1",""})
aadd(aRegs,{cPerg,"02","Ate N.Fiscal ?"   ,"Ate N.Fiscal ?"     ,"Ate N.Fiscal ?"    ,"mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SF1",""})
aadd(aRegs,{cPerg,"03","De Serie ?"       ,"De Serie ?"         ,"De Serie ?"        ,"mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Ate Serie ?"      ,"Ate Serie ?"        ,"Ate Serie ?"       ,"mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","De Fornecedor ?"  ,"De Fornecedor ?"    ,"De Fornecedor ?"   ,"mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aadd(aRegs,{cPerg,"06","Ate Fornecedor ?" ,"Ate Fornecedor ?"   ,"Ate Fornecedor ?"  ,"mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aadd(aRegs,{cPerg,"07","De Loja ?"        ,"De Loja ?"          ,"De Loja ?"         ,"mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Ate Loja ?"       ,"Ate Loja ?"         ,"Ate Loja ?"        ,"mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
                                                                                 
cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))
   	
   	SX1->(DbSeek(cPerg))
   	While SX1->(!EOF()) .AND. SX1->X1_GRUPO == cPerg
   		RecLock('SX1')
      		SX1->(DbDelete())
      	MsUnLock('SX1')
      	
      	SX1->(DbSkip())
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MARK BROWSE PARA SELECAO DAS NOTAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fRptDet()

Local aOldRot
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA UM ARQUIVO TEMPORARIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _cArqDBF := CriaTrab(NIL,.F.)
Private _aFields := {}
_cArqDBF += ".DBF"

AADD(_aFields,{"OK"       ,"C",02,0})        // Controle do browse
AADD(_aFields,{"NOTA"     ,"C",09,0})        // Numero da Nota
AADD(_aFields,{"SERIE"    ,"C",03,0})        // Serie
AADD(_aFields,{"FORNECE"  ,"C",06,0})        // Fornecedor
AADD(_aFields,{"LOJA"     ,"C",02,0})        // Loja
AADD(_aFields,{"NOMEFOR"  ,"C",40,0})        // Nome Fornecedor
AADD(_aFields,{"DTDIGIT"  ,"D",10,0})        // Data da Digitacao
AADD(_aFields,{"CODPLAC"  ,"C",06,0})        // código da tabela SO5 amarrado com a NF de entrada
AADD(_aFields,{"HORASAI"  ,"C",05,0})        // Hora da saida do caminhao
AADD(_aFields,{"PLACA"    ,"C",09,0})        // PLACA DO CAMINHAO
DbCreate(_cArqDBF,_aFields)

DbUseArea(.T.,,_cArqDBF,"ETQ",.F.)

// Criacao de Indice Temporario
_cArqNtx  := CriaTrab(NIL,.f.)
_nOrder   := "NOTA+SERIE+FORNECE+LOJA"

IndRegua("ETQ",_cArqNtx,_nOrder,"Indexando Registros..." )

IF Select("TRA1")==0
	ETQ->(dbclosearea())
	Return
endif

TRA1->(DBGoTop())  

SO5->(dbSetOrder(1))//filial + codigo

While !TRA1->(EOF())	

	IncProc("Gerando Notas a Serem Liberadas...")
	
	SO5->(dbSeek(xFilial("SO5")+TRA1->F1_CODPLAC))
	
	RecLock("ETQ",.T.)
	    ETQ->OK        := Space(02)     
		ETQ->NOTA      := TRA1->D1_DOC
		ETQ->SERIE     := TRA1->D1_SERIE
		ETQ->FORNECE   := TRA1->D1_FORNECE
		ETQ->LOJA      := TRA1->D1_LOJA
		ETQ->NOMEFOR   := TRA1->A2_NOME
		ETQ->DTDIGIT   := TRA1->D1_DTDIGIT
        ETQ->CODPLAC   := TRA1->F1_CODPLAC
        ETQ->HORASAI   := Iif(SO5->(FOUND()) .AND. !EMPTY(ETQ->CODPLAC),SO5->O5_HORASAI,"")
        ETQ->PLACA     := Iif(SO5->(FOUND()) .AND. !EMPTY(ETQ->CODPLAC),SO5->O5_PLACA,"")
	MsUnlock("ETQ")

	TRA1->(DbSkip())

EndDo

cMarca  := GetMark()
aCampos := {}
Aadd(aCampos,{"OK"        ,"C", "  "              ,"@!"})
Aadd(aCampos,{"NOTA"      ,"C", "Nota"            ,"@!"})
Aadd(aCampos,{"SERIE"     ,"C", "Serie"           ,"@!"})
Aadd(aCampos,{"FORNECE"   ,"C", "Fornecedor"      ,"@!"})
Aadd(aCampos,{"LOJA"      ,"C", "Loja"            ,"@!"})
Aadd(aCampos,{"NOMEFOR"   ,"C", "Nome Fornecedor" ,"@!"})
Aadd(aCampos,{"DTDIGIT"   ,"D", "Data Dig."       ,"99/99/9999"})
Aadd(aCampos,{"HORASAI"   ,"C", "Hora saida"      ,"@!"})
Aadd(aCampos,{"PLACA"     ,"C", "Placa"           ,"@!"})

ETQ->(DbGoTop())

cCadastro := OemToAnsi("Selecione a Nota - <ENTER> Marca/Desmarca")

aOldRot := aClone(aRotina)

aRotina := {}
aAdd(aRotina, {"Liberação"        ,"U_fOrdLib2()", 0 , 3 })
aAdd(aRotina, {"Filtro"           ,"U_EST136Fi()", 0 , 4 })
//			 {"Marca Tudo"       ,'U_fMark()'   , 0 , 4 },;
//           {"Desmarca Tudo"    ,'U_fDesmark()', 0 , 1 },;
//           {"Legenda"          ,'U_fLeg()'    , 0 , 1 } }

//MarkBrow("ETQ","OK" ,"ETQ->OK",aCampos,,cMarca)  
MarkBrow("ETQ","OK" ,,aCampos,,cMarca) 

aRotina := aClone(aOldRot)

TRA1->(dbCloseArea())
ETQ->(dbCloseArea()) 

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXECUTA UM FILTRO PARA TRAZER SOMENTE CAMINHAO QUE AINDA NAO SAIU DA EMPRESA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST136Fi()
Local bOkFil := {|| fFilGrv()}
Private cFil := "T"

	oDlgFil := MsDialog():New(0,0,080,320,"Filtro",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

    oSay1 := tSay():New(10,10,{||"Mostrar"},oDlgFil,,,,,,.T.,,)

	oCombo1 := TComboBox():New(08,50,{|u| if(Pcount() > 0,cFil := u,cFil)},;
		{"T=Todos","N=Não saíram na portaria"},080,20,oDlgFil,,{||.T.},,,,.T.,,,,{|| .T.},,,,,"cFil")
	
	oBtn1 := tButton():New(25,070,"Ok",oDlgFil,bOkFil,40,10,,,,.T.)
	oBtn2 := tButton():New(25,115,"Cancelar",oDlgFil,{||oDlgFil:End()},40,10,,,,.T.)
	
	oDlgFil:Activate(,,,.T.,{||.T.},,{||})	

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ APLICA O FILTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fFilGrv()
Local aOldArea := getArea()

	dbSelectArea("ETQ")
	If cFil=="N"
		SET FILTER TO AllTrim(ETQ->HORASAI)=="" .AND. ETQ->PLACA!=""
    Else
        SET FILTER TO
    EndIf
	
    MarkBRefresh()
    
	oDlgFil:End()
    
	RestArea(aOldArea)
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[¿
//³ JANELA DA ORDEM DE LIBERAÇÃO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[Ù
User Function fOrdLib2()
Local lFlag       := .F.
Local nQtdMark    := 0

Local bOk         := {||fOk()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}
Local nRec        := 1
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)

Private _cDoc     := Space(6)
Private _cForn    := Space(6)
Private _cLoja    := Space(2)
Private _cDForn   := ""

Private _dDtConf  := date()
Private _cHrConf  := time()
Private _cTransp  := ""

Private _cPCam    := Space(08)
Private _cPCar    := Space(08)
Private _cMot     := Space(30)
Private _cRG      := Space(10)

Private _cLacre   := Space(50)
Private _cFrete   := Space(06)
Private _cHrJan   := Space(05)
Private _cHrJanF  := Space(05)
Private _cHoraen  := SPACE(5)
Private _dDataen  := CTOD("  /  /  ")
Private _cObsexp  := Space(100)
Private _cObs     := Space(100)

Private _cNf      := Space(9)
Private _cSerie   := Space(3)
Private _cPri     := "1"
Private _cCodPlac := ""

Private _nValFre  := 0
Private _nValPed  := 0
Private _nValICM  := 0
Private _aTPCarg  := {"Total","Parcial","Especial",OemToAnsi("Baudiação")}
Private _cTPCarg  := "1"

Private aHeader := {}
Private aCols   := {}
Private aQtd    := {}

	If nPar == 3 //inclui

		ETQ->(dbGoTop())
		While !ETQ->(eof())
			If MARKED("OK")
				nQtdMark++
				nRec := ETQ->(RecNo())
		    EndIf
		    
		    If nQtdMark > 1
		    	Alert("Favor Selecionar uma NF por vez!")
		    	Return
		    EndIF
		    
			ETQ->(dbSkip())
		EndDo

	    If nQtdMark==0
	    	Return
	    EndIf
		
		ETQ->(dbGoTo(nRec))
	
		//adiciona os itens da nota no acols
		//cria o array aQtd, que irá conter as quantidades reais da nf para verificação da divergência
		SD1->(dbSetOrder(1)) // FILIAL + DOC + SERIE + FORNECE + LOJA
		SD1->(dbSeek(xFilial("SD1")+ETQ->NOTA+ETQ->SERIE+ETQ->FORNECE+ETQ->LOJA))
		
		If SD1->(!FOUND())
			ALERT("NF não encontrada!")
			Return
		EndIf
		
		WHILE SD1->(!EOF()) .AND. ;
		      SD1->D1_DOC == ETQ->NOTA .AND. ;
		      SD1->D1_SERIE == ETQ->SERIE .AND. ;
		      SD1->D1_FORNECE == ETQ->FORNECE .AND. ;
		      SD1->D1_LOJA == ETQ->LOJA 
		      
	        aAdd(aCols,{SD1->D1_ITEM, SD1->D1_COD, SD1->D1_DESCRI, 0,.F.}) // CARREGA O ACOLS
			aAdd(aQtd, {SD1->D1_ITEM, SD1->D1_QUANT}) //quantidade dos itens
		         
			SD1->(dbSkip())
		EndDo 
		
		aSort(aCols,,,{|x,y| x[1] < y[1]}) //ordena o acols por item
		aSort(aQtd,,, {|x,y| x[1] < y[1]}) //ordena o aQtd  por item
				
		_cDoc     := GetSXENum("ZB8","ZB8_DOC") //Traz o novo numero da Ordem de Liberacao de Recebimento
	    _cNF      := ETQ->NOTA
	    _cSerie   := ETQ->SERIE
   	    _cForn    := ETQ->FORNECE
	    _cLoja    := ETQ->LOJA
	    _cDForn   := ETQ->NOMEFOR
	    _cCodPlac := ETQ->CODPLAC
	    
	    SO5->(dbSetOrder(1))
	    SO5->(dbSeek(xFilial("SO5")+ETQ->CODPLAC))
	    
	    If SO5->(Found())
		    _cTransp := SO5->O5_EMPRESA
			_dDataen := SO5->O5_EMISSAO
			_cHoraen := SO5->O5_HORAENT
			_cPCam   := SO5->O5_PLACA
			_cPCar   := SO5->O5_PLACACA
	    	_cMot    := SO5->O5_DESCRI
		    _cRG     := SO5->O5_CHASSI
		EndIf
	    
	EndIf
	
	If nPar == 2 .or. nPar==4 //Visualizar ou excluir
    	_cDoc    := ZB8->ZB8_DOC
	    _cNF      := ZB8->ZB8_NFISC
	    _cSerie   := ZB8->ZB8_SERIE
	   	_cForn   := ZB8->ZB8_FORNEC
	   	_cLoja   := ZB8->ZB8_LOJA

		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+_cForn+_cLoja))
		   	_cDForn := SA2->A2_NOME
		Else
			_cDForn := ""
		EndIf

        _dDtConf := ZB8->ZB8_DTCONF
        _cHrConf := ZB8->ZB8_HRCONF
	   	_dDataEn := ZB8->ZB8_DATAEN
	   	_cHoraen := ZB8->ZB8_HORAEN
		_cHrJan  := ZB8->ZB8_HRJAN
		_cHrJanF := ZB8->ZB8_HRJANF
		_cPri    := ZB8->ZB8_PRIORI
		_cTPCarg := ZB8->ZB8_TPCARG 
		_cFrete  := ZB8->ZB8_FRETE
		_nValFre := ZB8->ZB8_VALFRE 
		_nValPed :=	ZB8->ZB8_VALPED
		_nValICM := ZB8->ZB8_VALICM
		_cLacre  := ZB8->ZB8_LACRE  
		_cObsexp := ZB8->ZB8_OBSEXP
		
	    SO5->(dbSetOrder(1))
	    SO5->(dbSeek(xFilial("SO5")+ZB8->ZB8_CODPLA))

	    If SO5->(found())
		    _cTransp := SO5->O5_EMPRESA
			_dDataen := SO5->O5_EMISSAO
			_cHoraen := SO5->O5_HORAENT
			_cPCam   := SO5->O5_PLACA
			_cPCar   := SO5->O5_PLACACA
		    _cMot    := SO5->O5_DESCRI
		    _cRG     := SO5->O5_CHASSI
		EndIf
			
        ZB9->(DBSETORDER(1))
        If ZB9->(DBSEEK(XFILIAL("ZB9")+_cDoc))
        	While ZB9->(!EOF()) .AND. ZB9->ZB9_DOC == _cDoc
        
        		SD1->(DBSETORDER(1)) // FILIAL + DOC + SERIE + FORNECE + LOJA + ITEM
        		SD1->(DBSEEK(XFILIAL("SD1")+ZB8->ZB8_NFISC+ZB8->ZB8_SERIE+ZB8->ZB8_FORNEC+ZB8->ZB8_LOJA+ZB9->ZB9_COD+ZB9->ZB9_ITEMNF))
        		
  				aAdd(aCols,{ZB9->ZB9_ITEMNF, ZB9->ZB9_COD, SD1->D1_DESCRI, ZB9->ZB9_QTDDIG,.F.})
				
				ZB9->(DBSKIP())
			
			ENDDO
			
		ENDIF
		
		For _x := 1 to Len(aHeader)
			aHeader[_x][6] := ".F."
		Next
	EndIf

	nMax  := Len(aCols)
	
	If nPar != 2 .and. nPar!=4 //visualizar, excluir
		If nMax == 0 //verifica se o usuario selecionou alguma nota fiscal
		   MsgBox("Nao foi Selecionada Nenhuma Nota Fiscal","Atencao","STOP")    
		   ETQ->(DbGoTop())
		   MarkBRefresh()
		   RollBackSx8() //Volta a numeração da Ordem de Liberação Qdo nenhuma NF foi marcada.
		   Return(.F.)     
		Endif
	EndIf
	
	//FONTES
	DEFINE FONT oFont   NAME "Arial" SIZE 12, -12
	DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10
	
	Aadd(aHeader,{"Item"       , "F1_ITEM"    ,"@!"                         ,04,0,".F.","","C","SF1"}) //01
	Aadd(aHeader,{"Produto"    , "D1_COD"     ,"@!"                         ,15,0,".F.","","C","SD1"}) //02
	Aadd(aHeader,{"Descrição"  , "B1_DESC"    ,"@!"                         ,40,0,".F.","","C","SB1"}) //03
	Aadd(aHeader,{"Quantidade" , "ZB9_QTDDIG" ,PesqPict("ZB9","ZB9_QTDDIG") ,06,0,".T.","","N","ZB9"}) //04
		
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,)}

	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Liberação de Recebimento de Materiais",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	@ 020,010 Say "Número: " Size 030,8 object olnum
	@ 020,050 Say _cDoc Size 035,8 Object oDoc
	oDoc:Setfont(oFont)

	@ 020,220 Say "Data:" Size 30,8 Object olData
	@ 018,245 Get _dDtConf Picture "99/99/9999" When .F. Size 45,8 Object oData
	@ 020,310 Say "Hora:" Size 30,8 Object olHora
	@ 018,335 Get _cHrConf Picture "99:99" When .F. Size 25,8 Object oHora
             
	@ 032,010 Say "Nota Fiscal:" Size 40,8 Object olNF
	@ 030,050 Get _cNF Picture "@!" When .F. Size 50,8 Object oNF
	@ 032,110 Say "Serie:" Size 30,8 Object olSERIE
	@ 030,130 Get _cSerie Picture "@!" When .F. Size 15,8 Object oSERIE

	@ 044,010 Say "Fornec. " Size 30,8 Object olForn
	@ 042,050 Get _cForn  Picture "@!" When .F.  Size 40,8 Object oForn
	@ 042,095 Get _cLoja  Picture "@!" When .F.  Size 10,8 Object oLoja
	@ 042,110 Get _cDForn Picture "@!" When .F.  Size 170,8 Object oDForn	
	
	@ 056,010 Say "Transportadora:" Size 050,8 Object olTransp
	@ 054,050 Get _cTransp Picture "@!" When .F. Size 120,8 Object oTransp             
	@ 056,220 Say "Dt Entrada:" Size 030,8 object oDtEntrada
	@ 054,250 Get _dDataEn Picture "99/99/9999" When .F. Size 35,8 Object oDataEn
	@ 056,300 Say "Hr Entrada:" Size 030,8 object oHrEntrada
	@ 054,335 Get _cHoraEn Picture "99:99" When .F. Size 25,8 Object oHoraEn
	
	@ 068,010 Say OemToAnsi("Placa Caminhão:") Size 050,8 Object olplcam
	@ 066,050 Get _cPCam Picture "!!!-!!!!" Size 030,8 When(.F.) Object oPCam // Valid fPlaca(_cPCam)
	//oPCam:SetFocus(oPCam)
	@ 068,095 Say OemToAnsi("Placa Carreta :") Size 050,8 Object olPlCar
	@ 066,135 Get _cPCar Picture "!!!-!!!!" Size 030,8 When (.F.) Object oPCar // Valid fPlaca(_cPCar) 
	
	@ 068,175 Say "Hr.Jan. Ini:" Color CLR_HBLUE Size 025,8  object oHrja
	@ 066,205 Get _cHrJan Picture "!!:!!" Size 10,8 When (nPar == 3) Valid .T. Object oHrJan
	
	@ 068,240 Say "Hr.Jan.Fim:" Color CLR_HBLUE Size 030,8  object oHrjafim
	@ 066,270 Get _cHrJanF Picture "!!:!!" Size 10,8 When (nPar == 3)  Object oHrJanfim
	
	@ 068,310 Say "Prioridade:" Size 040,8 object olPri
//	  oTPri:Setfont(oFont10)
	@ 066,348 Get _cPri Picture "@!" Size 10,8 When (nPar == 3) Object oPri             
	
	@ 080,010 Say "Motorista :" Size 050,8 Object olMot
	@ 078,050 Get _cMot Picture "@!" Size 120,8 When (.F.) Object oMot             
	@ 080,180 Say "RG :" Color CLR_HBLUE  Size 010,8 Object oLRG
	@ 078,195 Get _cRG Picture "@!" Size 050,8 When (.F.) Object oRG          
	@ 080,290 Say "Tipo Carga:" Size 050,8 Object olTpCarg
	@ 078,320 COMBOBOX _cTPCarg ITEMS _aTPCarg SIZE 40,10 object oTPCarg
	
	@ 092,010 Say OemToAnsi("Num Frete :")  Size 050,8 Object olNumFrete
	@ 090,050 Get _cFrete Picture "@!" Size 035,8 When (nPar == 3) Object oFrete
	             
	@ 092,95 Say OemToAnsi("Valor Frete :") Size 050,8 Object olvalfre
	@ 090,125 Get _nValFre Picture "999,999.99" Size 050,8 When (nPar == 3) Object oValFre
	
	@ 092,185 Say OemToAnsi("Valor Pedagio :") Size 050,8 Object oVlrPedagio
	@ 090,220 Get _nValPed Picture "999,999.99" Size 050,8 When (nPar == 3) Object oValPed
	
	@ 092,280 Say OemToAnsi("Valor ICMS :") Size 050,8 Object olIcm
	@ 090,310 Get _nValICM Picture "999,999.99" Size 050,8 When (nPar == 3) Object oValICM
	
	@ 104,010 Say OemToAnsi("Num Lacre :") Size 050,8 Object olLacre
	@ 102,050 Get _cLacre Picture "@!" Size 125,8 When (nPar == 3) Object oLacre
	
	@ 104,180 Say OemToAnsi("Obs Conf.:") Size 050,8 Object olExpObs
	@ 102,210 Get _cObsexp Picture "@!" Size 150,8 When (nPar == 3) Object oObsexp
	
	//******************************************************************************   
	@ 116,006 To 200,362 Title OemToAnsi(" Informações ")   Object olInfo
	//@ 095,015 TO 170,355 MULTILINE MODIFY OBJECT oMultiline    
	@ 126,015 TO 200,355 MULTILINE MODIFY OBJECT oMultiline
	
	oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDACAO PARA AS PLACAS DO CAMINHAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fPlaca(_cPl)
Local _nNum   := 1
Local _lFlag  := .T. 
Local _cPlaca := _cPl
_cPri         := "1"

If !Empty(_cPlaca)
   If Len(Alltrim(_cPlaca)) <> 8
      Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao","ALERT" )  
      Return(.F.)       
      
   Endif

   For _nNum:= 1 to 3
      
      _lFlag := Entre("A","Z",Subs(_cPlaca,_nNum,1))   
      If !_lFlag
         Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao Letras","ALERT" )  
         Return(.F.)       
      Endif      
   Next

   For _nNum:=5 to 8
      
      _lFlag := Entre("0","9",Subs(_cPlaca,_nNum,1))   
      If !_lFlag
         Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao Numeros","ALERT" )  
         Return(.F.)       
      Endif      
   Next 
Endif

Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE AS QTDS. DIGITADAS SAO IGUAIS AS QTDS DAS NFS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValida2()
Local aItmDiv := {} //contém os ítens que possuem divergência
Local lImp := .F.

	If nPar==2 //visualizar
		Return .T.
	Endif
	
	If Empty(_cHrJan)	
		Alert("Informe a janela inicial!")
		Return .F.
	EndIf
	
	If Empty(_cHrJanf)
		Alert("Informe a janela final!")
		Return .F.
	EndIf
	
	For _x := 1 to Len(aCols)

//		If Empty(aCols[_x][4])
//			Alert("Digite a quantidade do item: "+StrZero(_x,4)+"!")
//			Return .F.
//		EndIf
		
	Next
	
	For _x := 1 to Len(aCols)	
	
		If aQtd[_x][2] != aCols[_x][4]
			If MsgYesNo("Quantidades divergentes da NF! "+chr(13)+chr(10)+;
					   "Item ........................:"+aCols[_x][1]+chr(13)+chr(10)+;
					   "Quant.NF ...............:"+Alltrim(Str(aQtd[_x][2]))+chr(13)+chr(10)+;
					   "Quant. Digit. ..........:"+Alltrim(Str(aCols[_x][4]))+chr(13)+chr(10)+;
					   "Deseja Continuar ?")
				   
				aAdd(aItmDiv,_x)
				lImp := .T.
			Else
				Return .F.			
			EndIf
		EndIf
	Next
	
	If lImp
		fGrvDiv(aItmDiv)
		U_EST136IM()
	EndIf
	
	fPriori() //verifica a prioridade se já existe acrescenta um
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA NA TABELA DE DIVERGENCIAS AS OCORRENCIAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvDiv2(aItens)

	SB1->(dbSetOrder(1)) // FILIAL + COD
	
	For _x:=1 to Len(aItens)

		SB1->(dbSeek(xFilial("SB1")+aCols[aItens[_x]][2]))

		RecLock("ZDE",.T.)
			ZDE->ZDE_FILIAL := xFilial("ZDE")
			ZDE->ZDE_NUM    := _cDoc
			ZDE->ZDE_NF     := _cNF
			ZDE->ZDE_SERIE  := _cSerie
			ZDE->ZDE_ITEMNF := aCols[aItens[_x]][1]
			ZDE->ZDE_FORNEC := _cForn
			ZDE->ZDE_LOJA   := _cLoja
			ZDE->ZDE_CODAP5 := SB1->B1_CODAP5
			ZDE->ZDE_COD    := SB1->B1_COD
			ZDE->ZDE_QTDFIS := aQtd[aItens[_x]][2]
			ZDE->ZDE_QTDDIG := aCols[aItens[_x]][4]
			ZDE->ZDE_STATUS := "P"
			ZDE->ZDE_DATA   := Date()
			ZDE->ZDE_SOLUC  := ""
			ZDE->ZDE_OBS    := ""   
			ZDE->ZDE_MOTORI := _cMot
			ZDE->ZDE_LOGIN  := ALLTRIM(UPPER(cUserName))
			ZDE->ZDE_RG 	:= _cRG
			ZDE->ZDE_TRANSP := _cTransp
			ZDE->ZDE_PLACAM := _cPCam
		MsUnLock("ZDE")
	
	Next

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DEFINE A PRIORIDADE DA LIBERACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fPriori()

    cQuery2 := "SELECT MAX(ZB8_PRIORI) AS PRIORI"
    cQuery2 += " FROM "+RetSqlName('ZB8')+" ZB8, "+RetSqlName('SO5')+" O5"
    cQuery2 += " WHERE ZB8.ZB8_CODPLA = O5.O5_CODIGO
    cQuery2 += " AND O5.O5_PLACA    = '" + _cPCam + "'"
	cQuery2 += " AND O5.O5_HORASAI  = ' ' "
	cQuery2 += " AND O5.D_E_L_E_T_  = ' 'AND  O5.O5_FILIAL  = '" + xFilial("SO5")+ "'"
	cQuery2 += " AND ZB8.D_E_L_E_T_ = ' 'AND ZB8.ZB8_FILIAL = '" + xFilial("ZB8")+ "'"

    //TCQuery Abre uma workarea com o resultado da query
    TCQUERY cQuery2 NEW ALIAS "PRI"  
    // DbSelectArea("PRI")
    PRI->(DBGotop())            
    If !Empty(PRI->PRIORI) // Verifica se existe alguma ordem de liberação de materiais
       _cPri := StrZero(Val(PRI->PRIORI)+1,1)         
    Else
       _cPri := "1"                     
    Endif   
    ObjectMethod(oPri, "Refresh()")
    DbSelectArea("PRI")
    DbCloseArea()//fecha o arq. temporario PRI

Return                                     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA A ORDEM DE LIBERACAO DE RECEBIMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fOk2()

	If nPar == 2 //visualizar
		oDlg:End()
		Return
	EndIf

	If nPar==4 //excluir
	
		ZB8->(dbSetOrder(1)) 
		If ZB8->(dbSeek(xFilial("ZB8")+_cDoc))
			Reclock("ZB8",.F.)
				ZB8->(dbDelete())
			MsUnLock("ZB8")
		EndIf
		
		ZB9->(dbSetOrder(1))
		ZB9->(dbSeek(xFilial("ZB9")+_cDoc))
		
		If ZB9->(Found())
			
			SD1->(dbSetOrder(1)) // FILIAL + DOC + SERIE + FORNEC + LOJA
			While ZB9->(!EOF())
			
				//APAGA A ORDEM DE LIBERACAO DA NOTA
				If SD1->(dbSeek(xFilial("SD1")+_cNF+_cSerie+_cForn+_cLoja+ZB9->ZB9_COD+ZB9->ZB9_ITEMNF))
					RecLock("SD1",.F.)
						SD1->D1_ORDLIB := ""
					MsUnLock("SD1")
				EndIf
				
				Reclock("ZB9",.F.)
					ZB9->(dbDelete())
				MsUnLock("ZB9")
 				
			    ZB9->(dbSkip())
			EndDo
		EndIf
	
		Close(oDlg)		
	
	Else

		
		// INCLUIR 
		
		If !fValida()
			Return
		EndIf

		//Begin Transaction
		Reclock("ZB8",.T.)
		
			ZB8->ZB8_FILIAL := xFilial("ZB8")
			ZB8->ZB8_DOC    := _cDoc
			ZB8->ZB8_NFISC  := _cNF
			ZB8->ZB8_SERIE  := _cSerie
			ZB8->ZB8_FORNEC := _cForn
			ZB8->ZB8_LOJA   := _cLoja
			ZB8->ZB8_PRIORI := _cPri
			ZB8->ZB8_HORAEN := _cHoraen
			ZB8->ZB8_DATAEN := Iif(Empty(_dDataen),Ctod("//"),_dDataen)
			ZB8->ZB8_OBS    := _cObs
			ZB8->ZB8_TPCARG := _cTPCarg
			ZB8->ZB8_FRETE  := _cFrete
			ZB8->ZB8_VALFRE := _nValFre
			ZB8->ZB8_VALPED := _nValPed
			ZB8->ZB8_VALICM := _nValICM
			ZB8->ZB8_CODPLA := _cCodPlac
			ZB8->ZB8_LACRE  := _cLacre 
			ZB8->ZB8_STATUS := 'P'
			ZB8->ZB8_OBSEXP := _cObsexp
			ZB8->ZB8_HRJAN  := _cHrJan
			ZB8->ZB8_HRJANF := _cHrJanF
			ZB8->ZB8_CONFER := __cUserID
			ZB8->ZB8_HRCONF := Time()
			ZB8->ZB8_DTCONF := Date()
			
		MsUnlock("ZB8")
		// End Transaction
		
		SD1->(dbSetOrdeR(1))
		For _x:=1 to Len(aCols)
			If !Empty(Acols[_x][1])
				
				Reclock("ZB9",.T.)
				ZB9->ZB9_FILIAL  := xFilial("ZB9")
				ZB9->ZB9_DOC     := _cDoc
				ZB9->ZB9_ITEMNF  := aCols[_x][1] //Item da nota fiscal
				ZB9->ZB9_COD     := aCols[_x][2] //codigo do produto
				ZB9->ZB9_QTDNF   := aQtd[_x][2]
				ZB9->ZB9_QTDDIG  := Acols[_x][4] //quantidade digitada
				MsUnlock("ZB9")
				
				If SD1->(dbSeek(xFilial("SD1")+_cNF+_cSerie+_cForn+_cLoja+aCols[_x][2]+aCols[_x][1]))
					Reclock("SD1",.F.)
						SD1->D1_ORDLIB  := _cDoc //numero da ord. de liberação
					MsUnlock("SD1")
				EndIf
				
				If ETQ->(DbSeek(_cNF+_cSerie+_cForn+_cLoja))
					Reclock("ETQ",.F.)
						ETQ->(DbDelete())
					MsUnlock("ETQ")
				EndIf
				
			Endif
		Next
		
		ConfirmSX8()
		Close(oDlg)

	   	MarkBRefresh()   

	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRESSAO DO AVISO DE DIVERGENCIA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST136IM2()

	oRelato2          := Relatorio():New()
	
	oRelato2:cString  := "SF1"
    oRelato2:cPerg    := ""
	oRelato2:cNomePrg := "NHEST136"
	oRelato2:wnrel    := oRelato2:cNomePrg

	//descricao
	oRelato2:cDesc1   := "Imprime o aviso de divergência de recebimento de produto"
	oRelato2:cDesc2   := ""

	//titulo
	oRelato2:cTitulo  := "AVISO DE DIVERGÊNCIA EM NOTA FISCAL"

	//cabecalho      
	oRelato2:cCabec1  := ""
    oRelato2:cCabec2  := ""
		    
	oRelato2:Run({||Imprime2()})

Return

Static Function Imprime22() 
Local cChave := ZDE->ZDE_NF+ZDE->ZDE_SERIE+ZDE->ZDE_FORNEC+ZDE->ZDE_LOJA

	oRelato2:Cabec()

	@Prow()+1 , 063 psay "NR.(Lote da Ocorrência): "
	@Prow()+1 , 001 psay "Empresa:  WHB COMPONENTES AUTOMOTIVOS S\A"
	@Prow()   , 063 psay "STATUS:                  (ABERTO/OK)"
	@Prow()+1 , 001 psay "Endereço: Rua Wiegando Olsenn, 1000 CEP 81450-100"
	@Prow()   , 063 psay "CGC:                     73.355.174/0001-40"
	@Prow()+1 , 001 psay "          Cidade Industrial de Curitiba - Curitiba - PR"
	@Prow()   , 063 psay "Insc. Est.:              101.97482-07"

	@Prow()+1 , 000 psay __PrtThinLine()
	
	@Prow()+1 , 001 psay "Setor Fiscal:                    Telefone: (41) 3341-1990            Email: lista-fiscal@whbbrasil.com.br"
	@Prow()+1 , 001 psay "Controladoria:                   Telefone: (41) 3341-1340            Email: lista-controladoria@whbbrasil.com.br"
	@Prow()+1 , 001 psay "Logística:                       Telefone: (41) 3341-1328            Email: lista-logisticainterna@whbbrasil.com.br"
	
	@Prow()+1 , 000 psay __PrtThinLine()
	  
	ZDE->(dbGoTop())
	ZDE->(dbSetOrder(2)) // ZDE_FILIAL+ZDE_NF+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA
	ZDE->(dbSeek(xFilial("ZDE")+cChave))

	SF1->(dbSetOrder(1)) // FILIAL + NF + SERIE + FORN + LOJA
	SF1->(dbSeek(xFilial("SF1")+ZDE->ZDE_NF+ZDE->ZDE_SERIE+ZDE->ZDE_FORNEC+ZDE->ZDE_LOJA))

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
		
	@Prow()+1 , 001 psay "Empresa:  "+cNomeF
	@Prow()+1 , 001 psay "Endereço: "+cEndF
	@Prow()   , 063 psay "CGC:                     "+cCGCF
	@Prow()+1 , 001 psay "          "+AllTrim(cMunF)+" - "+cEstF
	@Prow()   , 063 psay "Insc. Est.:              "+cInscF
	
	@Prow()+2 , 010 psay "Informamos que os documentos abaixo apresentam irregularidades"
	@Prow()+1 , 010 psay "ao dar entrada no recebimento desta empresa na data de: "+DtoC(ZDE->ZDE_DATA)

	@Prow()+2 , 000 psay __PrtThinLine()
	
	
	@Prow()+1 , 000 psay "DATA NF.       Nota Fiscal/Serie   Código Produto     Código WHB          Qtd. NF.   Qtd. Físico    Diferença      Obs. / NF Triang."
	
	SD1->(dbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SB1->(dbSetOrder(1)) // FILIAL + COD

	cNum := ZDE->ZDE_NUM
	
	WHILE ZDE->(!EOF()) .AND. ZDE->ZDE_NUM == cNum

		SD1->(dbSeek(xFilial("SD1")+ZDE->ZDE_NF+ZDE->ZDE_SERIE+ZDE->ZDE_FORNEC+ZDE->ZDE_LOJA+ZDE->ZDE_COD+ZDE->ZDE_ITEMNF))

		@Prow()+1 , 000 psay DtoC(SD1->D1_EMISSAO)
		@Prow()   , 015 psay ZDE->ZDE_NF+" - "+ZDE->ZDE_SERIE

		SB1->(dbSeek(xFilial("SB1")+ZDE->ZDE_COD))
	
		@Prow()   , 035 psay Iif(Empty(AllTrim(SB1->B1_CODAP5)),"-",AllTrim(SB1->B1_CODAP5))
		@Prow()   , 054 psay AllTrim(SB1->B1_COD)
		@Prow()   , 071 psay SD1->D1_QUANT   Picture "@e 99999999" //quantidade nf
		@Prow()   , 083 psay ZDE->ZDE_QTDDIG Picture "@e 99999999" //quantidade fisico
		@Prow()   , 098 psay (ZDE->ZDE_QTDDIG - SD1->D1_QUANT) Picture "@e 99999999" //diferenca
		@Prow()   , 115 psay ""
	
		ZDE->(dbSkip())
		
	ENDDO

	@Prow()+1 , 000 psay __PrtThinLine()
	
	@Prow()+2 , 010 psay "Irregularidades constatadas por:"
	
	@Prow()+3 , 010 psay "________________________________"
	@Prow()   , 090 psay "________________________________"

	@Prow()+1 , 015 psay "Conferente: "+ZDE->ZDE_LOGIN
	@Prow()   , 090 psay "       Motorista: "+ ZDE->ZDE_MOTORI

	@Prow()+1 , 015 psay " Matrícula: " + Posicione("QAA",6,ALLTRIM(UPPER(ZDE->ZDE_LOGIN)),"QAA_MAT")
		
	@Prow()   , 090 psay "              RG: "+ZDE->ZDE_RG
	@Prow()+1 , 090 psay "  Transportadora: "+ZDE->ZDE_TRANSP
	@Prow()+1 , 090 psay "Caminhão / Placa: "+ZDE->ZDE_PLACAM
	
	@Prow()+3 , 001 psay "** Na hipótese de material faltante, será emitida Nota Fiscal de devolução / retorno mencionando o número" 
	@Prow()+1 , 001 psay "   deste aviso de divergência."
	@Prow()+1 , 001 psay "** Na hipótese de material excedente, favor enviar sua nota fiscal complementar."
	
	@Prow()+2 , 001 psay "+-------------------------------------------+"
	@Prow()+1 , 001 psay "| Recebido:                                 |"
	@Prow()+1 , 001 psay "| ____/____/___________                     |"
	@Prow()+1 , 001 psay "|                                           |"
	@Prow()+1 , 001 psay "| _____________________                     |"
	@Prow()+1 , 001 psay "| Assinatura e Carimbo                      |"
	@Prow()+1 , 001 psay "+-------------------------------------------+"	

	@Prow()+1 , 000 psay __PrtThinLine()	
	
	ZDE->(dbSetOrder(1)) // ZDE_FILIAL+ZDE_NUM
	
Return

*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONSTRÓI A TELA DE PERGUNTAS PARA INCLUIR A ORD LIB.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
Static Function fEST136P()
Local _lRet

	DEFINE MSDIALOG oDlg TITLE "Dados da Nota" FROM 0,0 TO 160,258 PIXEL
	@ 005,005 TO 060,125 OF oDlg PIXEL
	@ 015,015 SAY "Nota Fiscal:" OBJECT olNF
	@ 015,050 GET _cNf         SIZE 030,008 F3 "SD1" OBJECT oNF
	@ 015,090 GET _cSerie      SIZE 010,008 OBJECT oSerie
	@ 030,015 SAY "Fornecedor:" OBJECT olForn
	@ 030,050 GET _cFornece    SIZE 030,008 OBJECT oForn
	@ 030,090 GET _cLoja       SIZE 010,008 OBJECT oLoja
	@ 65,060 BUTTON "Ok"       SIZE 30,10 ACTION {_lRet := .T., Close(oDlg)} OBJECT oBt1
	@ 65,095 BUTTON "Cancelar" SIZE 30,10 ACTION {_lRet := .F., Close(oDlg)} OBJECT oBt2
	ACTIVATE MSDIALOG oDlg CENTERED	

Return _lRet
*/

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME O ROTEIRO DE COLETA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST136ROT()
Local   lSai    := .F.
Private cPlaca
Private cData   := Space(10)
Private aPlacas := {}
Private aCodigo := {}
Private cCodSO5 := ""
Private cObs    := Space(100)

    oDlg  := MsDialog():New(0,0,122,370,"Parâmetros",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

    oSay1 := tSay():New(10,10,{||"Data"},oDlg,,,,,,.T.,,)
   	oGet1 := tGet():New(08,30,{|u| if(Pcount()>0,cData := u, cData)},oDlg,;
   		 35,8,"99/99/9999",{||fTrazPlc(cData)},,,,,,.T.,,,{||.T.},,,,,,,"cData")
		
    oSay2 := tSay():New(22,10,{||"Placa"},oDlg,,,,,,.T.,,)
	//combobox
	oCombo := TComboBox():New(20,30,{|u| if(Pcount() > 0,cPlaca := u,cPlaca)},;
		aPlacas,90,20,oDlg,,{||},,,,.T.,,,,{||.T.},,,,,"cPlaca")

    oSay2 := tSay():New(34,10,{||"Obs."},oDlg,,,,,,.T.,,)
   	oGet2 := tGet():New(32,30,{|u| if(Pcount()>0,cObs := u, cObs)},oDlg,;
   		 150,8,"@!",{||.T.},,,,,,.T.,,,{||.T.},,,,,,,"cObs")

	oBtn3 := tButton():New(46,95,"Ok",oDlg,{||cCodSO5 := aCodigo[oCombo:nAt],oDlg:End()},40,10,,,,.T.)
	oBtn4 := tButton():New(46,140,"Cancelar",oDlg,{||lSai := .T., oDlg:End()},40,10,,,,.T.)
		
	oDlg:Activate(,,,.T.,{||.T.},,{||})


	If lSai
		Return
	EndIf
	
	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SO5"
    oRelato:cPerg    := ""
	oRelato:cNomePrg := "NHEST136"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este   relatório   apresenta  o  roteiro"
	oRelato:cDesc2   := "de coleta."

	//titulo
	oRelato:cTitulo  := "ROTEIRO DE COLETA"

	//cabecalho      
	oRelato:cCabec1  := ""
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
aModTrans := {"Carreta","Truck","Bug","Outro"}
	
	SO5->(DbSetOrder(1)) //O5_FILIAL+O5_CODIGO
	SO5->(DbSeek(xFilial("SO5")+cCodSO5))
	
	oRelato:Cabec()
	
	@Prow()+1 , 001 psay "Placa: "+SO5->O5_PLACA
	@Prow()   , 050 psay "Motorista: "+ALLTRIM(SO5->O5_DESCRI)
	@Prow()   , 100 psay "RG: "+SO5->O5_CHASSI
	@Prow()+1 , 001 psay "Modalidade: "+aModTrans[Val(SO5->O5_MODTRAN)]
	@Prow()   , 050 psay "Hora Cad Veíc: "+ALLTRIM(SO5->O5_HORAENT)
	@Prow()+1 , 000 psay __PrtThinLine()

	cQuery := "SELECT F1.F1_FORNECE, F1.F1_LOJA, D1.D1_COD, D1.D1_DESCRI, "
	cQuery += " F1.F1_VOLUME, D1.D1_QUANT, F1.F1_DOC, F1.F1_SERIE, F1.F1_TIPO "
	cQuery += " FROM "+RetSqlName("SF1")+" F1, "+RetSqlName("SD1")+" D1 "
	cQuery += " WHERE F1.F1_DTDIGIT = '"+DtoS(CtoD(cData))+"'"
	cQuery += " AND D1.D1_DOC = F1.F1_DOC "
	cQuery += " AND D1.D1_SERIE = F1.F1_SERIE "
	cQuery += " AND D1.D1_FORNECE = F1.F1_FORNECE "
	cQuery += " AND D1.D1_LOJA = F1.F1_LOJA "
	cQuery += " AND D1.D1_DTDIGIT = F1.F1_DTDIGIT "
	cQuery += " AND F1.F1_CODPLAC = '"+SO5->O5_CODIGO+"'"
	cQuery += " AND F1.F1_FILIAL = '"+xFilial("SF1")+"' AND F1.D_E_L_E_T_ = ''"
	cQuery += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"' AND D1.D_E_L_E_T_ = ''"
	cQuery += " ORDER BY F1.F1_FORNECE, F1.F1_LOJA ASC"
		
	TCQUERY cQuery NEW ALIAS "TRC"
	
	TRC->(DbGoTop())  

	While TRC->(!EOF())
	
		If Prow() > 65
			oRelato:Cabec()
		EndIf
		
		@Prow()+1, 001 psay "FORN./LOJA      DESCRIÇÃO"
  
		If TRC->F1_TIPO == "B"
			SA1->(DbSetOrder(1)) //FILIAL + COD + LOJA
			SA1->(DbSeek(xFilial("SA1")+TRC->F1_FORNECE+TRC->F1_LOJA))
	
			@Prow()+1, 001 psay TRC->F1_FORNECE+" - "+TRC->F1_LOJA+"     "+SA1->A1_NOME
			@Prow()+1, 001 psay "Endereço: "+Alltrim(SA1->A1_END)+Space(5)+"Bairro: "+Alltrim(SA1->A1_BAIRRO)+Space(5)+"Cidade: "+Alltrim(SA1->A1_MUN)+Space(5)+"Estado: "+Alltrim(SA1->A1_EST)
			@Prow()+1, 001 psay "Telefone: "+SA1->A1_TEL
			
		ELSE
			SA2->(DbSetOrder(1)) // FILIAL + COD + LOJA
			SA2->(DbSeek(xFilial("SA2")+TRC->F1_FORNECE+TRC->F1_LOJA))
			
			@Prow()+1, 001 psay TRC->F1_FORNECE+" - "+TRC->F1_LOJA+"     "+SA2->A2_NOME
			@Prow()+1, 001 psay "Endereço: "+Alltrim(SA2->A2_END)+Space(5)+"Bairro: "+Alltrim(SA2->A2_BAIRRO)+Space(5)+"Cidade: "+Alltrim(SA2->A2_MUN)+Space(5)+"Estado: "+Alltrim(SA2->A2_EST)
			@Prow()+1, 001 psay "Telefone: "+SA2->A2_TEL
		EndIf			
		
		@Prow()+2, 001 psay "CÓDIGO          DESCRIÇÃO                                               VOLUME           QUANT          NF"

		@Prow()+1, 001 psay ""
		
		cForn := TRC->F1_FORNECE
		cLoja := TRC->F1_LOJA
		
		nTotVol := 0
		
		While TRC->F1_FORNECE==cForn .AND. TRC->F1_LOJA==cLoja
						
			@Prow()+1, 001 psay TRC->D1_COD
			@Prow()  , 017 psay SUBSTR(TRC->D1_DESCRI,1,50)
			@Prow()  , 070 psay TRC->F1_VOLUME Picture "@e 9,999.99"
			nTotVol += TRC->F1_VOLUME
			@Prow()  , 085 psay TRC->D1_QUANT Picture "@e 999,999.99"
			@Prow()  , 100 psay TRC->F1_DOC+" - "+TRC->F1_SERIE
			
			TRC->(DbSkip())
		EndDo
		@Prow()+1, 001 psay "Total: "
		@Prow()  , 068 psay nTotVol Picture "@e 999,999.99"
	     
		@Prow() +1,000 psay __PrtThinLine()
	
	ENDDO
	
	@Prow()+1, 001 psay "Obs.: "+cObs

	@Prow()+3, 010 psay "__________________________________"
	@Prow()  , 080 psay "__________________________________"
	@Prow()+1, 020 psay UPPER(cUserName)
	@Prow()  , 090 psay "RESP. TRANSPORTE"

	TRC->(DbCloseArea())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ AS PLACAS DO DIA PASSADO COMO PARAMETRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fTrazPlc(cData)
Local cQuery  := ""

	If Empty(cData)
		Return .T.
	EndIf

	cQuery := "SELECT O5_CODIGO, O5_PLACA FROM "+RetSqlName("SO5")
	cQuery += " WHERE O5_DTENTRA = '"+DtoS(CtoD(cData))+"'"
	cQuery += " AND D_E_L_E_T_ = ''"
	cQuery += " AND O5_FILIAL = '"+xFilial("SO5")+"'"
	
	TCQUERY cQuery NEW ALIAS "TRB"
	      
	TRB->(DbGoTop())
	
	aPlacas := {}
	
	While TRB->(!EOF())
	    aAdd(aPlacas,TRB->O5_PLACA+" - "+TRB->O5_CODIGO)
	    aAdd(aCodigo,TRB->O5_CODIGO) 
		TRB->(Dbskip())
	ENDDO              
	
	oCombo:Refresh()        
	oCombo:aItems := {}
	oCombo:aItems := aPlacas
	
	TRB->(DbCloseArea())

Return .T.

  
*/