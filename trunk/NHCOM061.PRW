/*  /
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM061  ºAutor  ³João Felipe da Rosa º Data ³  05/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PEDIDO DE COMPRAS EM ABERTO (NOVO)                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

User Function NHCOM061
Local aFixe :=   { 	{ "Numero"      ,"C3_NUM    " },;		        //"Numero"
					{ "Item"        ,"C3_ITEM   " },;		        //"Item"
					{ "Produto"     ,"C3_PRODUTO" },;		        //"Produto"
					{ "Emissao"     ,"C3_EMISSAO" },;		        //"Emissao"
					{ "Dt. Entrega" ,"C3_DATPRF"  },;		        //"Dt. Entrega"
					{ "Fornecedor"  ,"C3_FORNECE" },;		        //"Fornecedor"
					{ "Quant."      ,"C3_QUANT"   },;	            //"Qt. Entregue"
					{ "Qt. Entregue","C3_QUJE"    } }	            //"Qt. Entregue"

Private cCadastro := "Pedido de Compras em Aberto"
Private aRotina   := {}
Private aCores    := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"      , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_COM61(1)"    , 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_COM61(2)"    , 0 , 3})
aAdd(aRotina,{ "Alterar"		,"U_COM61(3)"    , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_COM61(4)"    , 0 , 5})
//aAdd(aRotina,{ "Revisão"        ,"U_COM61REV()"  , 0 , 5})
Aadd(aRotina,{ "Historico"      ,"U_COM61HIS()"  , 0 , 5})   
Aadd(aRotina,{ "Imprime"        ,"U_NHCOM013()"  , 0 , 5})  
aAdd(aRotina,{ "Legenda"        ,"U_COM61LEG()"  , 0 , 5})


aAdd(aCores,{ '!Empty(C3_RESIDUO)'                     					, 'BR_CINZA'  })	 //Eliminado por Residuo
aAdd(aCores,{ 'C3_CONAPRO=="B".And.C3_QUJE < C3_QUANT' 					, 'BR_AZUL'   }) //Bloqueado
aAdd(aCores,{ 'C3_QUJE==0 .AND. C3_QUANT>0'           					, 'ENABLE'    }) //Pendente
aAdd(aCores,{ 'C3_QUJE<>0.And.C3_QUJE<C3_QUANT'        					, 'BR_AMARELO'}) //Parcialmente Atendido
aAdd(aCores,{ 'C3_QUJE>=C3_QUANT .OR. (C3_QUANT==0 .AND. C3_QUJE==0)' 	, 'DISABLE'   }) //Atendido

mBrowse(6,1,22,75,"SC3",aFixe,,,,,aCores)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DE LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function COM61LEG()

BrwLegenda(cCadastro,"Legenda",{{"ENABLE"    ,"Contrato Pendente" },;
							   	{"BR_AMARELO","Contrato Parcialmente Atendido"},;
								{"DISABLE"   ,"Contrato Atendido" },; 
								{"BR_AZUL"   ,"Contrato Bloqueado"},;
								{"BR_CINZA"  ,"Residuo Eliminado" }})

Return

User Function COM61(nParam)
Local bOk        := {||}
Local bCanc      := {||oDlg1:End()}
Local bEnchoice  := {||}
Local nMax       := 200
Local lDeleta    := .T.
Local aTitles	 := {"Totais","Inf. Fornecedor","Mensagem/Reajuste"}
Private aCols    := {}
Private aHeader  := {}
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)
Private nPar     := nParam
Private cNum     := SC3->C3_NUM
Private dData    := SC3->C3_EMISSAO
Private cForn    := SC3->C3_FORNECE
Private cLoja    := SC3->C3_LOJA
Private cCond    := SC3->C3_COND
Private cConDesc := Posicione("SE4",1,xFilial("SE4")+SC3->C3_COND,"E4_DESCRI")
Private cContato := Posicione("SA2",1,xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA,"A2_CONTATO")
Private cFilEnt  := SC3->C3_FILENT
Private nMoeda   := SC3->C3_MOEDA
Private cMoedDes := SuperGetMv("MV_MOEDA"+AllTrim(Str(nMoeda,2)))
Private cTransp  := SC3->C3_TRANSP
Private dDataRev := SC3->C3_DATAREV
Private cNumRev  := SC3->C3_NUMREV
Private nValMerc := 0
Private cTpFrete := SC3->C3_TPFRETE
Private nValIPI  := 0
Private nValFre  := 0
Private nTotalGe := 0
Private aInfoFor := {'','',ctod('//'),'','',ctod('//')}					
Private cMsg     := SC3->C3_MSG
Private cReajust := SC3->C3_REAJUST
Private cDesMsg  := ''
Private cDesReaj := ''
Private VK_F4    := 115
Private aBotao   := {}

	aAdd(aHeader,{"Item"          , "C3_ITEM"   , PesqPict("SC3","C3_ITEM")    ,04                     ,00, ".F."           ,"","C","SC3"})
	aAdd(aHeader,{"Produto"       , "C3_PRODUTO", PesqPict("SC3","C3_PRODUTO") ,15                     ,00, "U_COM61PRD()"  ,"","C","SC3"})
	aAdd(aHeader,{"Descrição"     , "B1_DESC"   , PesqPict("SB1","B1_DESC")    ,50                     ,00, ".F."           ,"","C","SB1"})
	aAdd(aHeader,{"Quantidade"    , "B2_QATU"  , PesqPict("SC3","C3_QUANT")   ,TamSx3("C3_QUANT")[1]  ,TamSx3("C3_QUANT")[2], "U_COM51TOT()"  ,"","N","SC3"})
	aAdd(aHeader,{"Unidade"       , "C3_UM"     , PesqPict("SC3","C3_UM")      ,TamSx3("C3_UM")[1]     ,00, ".F."  ,"","C","SC3"})
	aAdd(aHeader,{"Dt. Inicial"   , "C3_DATPRI" , PesqPict("SC3","C3_DATPRI")  ,TamSx3("C3_DATPRI")[1] ,00, ".T."  ,"","D","SC3"})
	aAdd(aHeader,{"Dt. Final"     , "C3_DATPRF" , PesqPict("SC3","C3_DATPRF")  ,TamSx3("C3_DATPRF")[1] ,00, ".T."  ,"","D","SC3"})		
	aAdd(aHeader,{"Prc Unitário"  , "D1_CUSTO"  , PesqPict("SC3","C3_PRECO")   ,TamSx3("C3_PRECO")[1]  ,TamSx3("C3_PRECO")[2], "U_COM51TOT()"  ,"","N","SC3"})
	aAdd(aHeader,{"Sigla"         , "C3_SIGLA"  , PesqPict("SC3","C3_SIGLA")   ,TamSx3("C3_SIGLA")[1]  ,00, "U_COM51SIG()"  ,"","C","SC3"})
	aAdd(aHeader,{"Vlr Total"     , "C3_TOTAL"  , PesqPict("SC3","C3_TOTAL")   ,TamSx3("C3_TOTAL")[1]  ,TamSx3("C3_TOTAL")[2], ".F."  ,"","N","SC3"})
	aAdd(aHeader,{"Aliq. IPI"     , "C3_IPI"    , PesqPict("SC3","C3_IPI")     ,TamSx3("C3_IPI")[1]    ,00, "U_COM51TOT()"  ,"","N","SC3"}) //11
	aAdd(aHeader,{"Armazem"       , "C3_LOCAL"  , PesqPict("SC3","C3_LOCAL")   ,TamSx3("C3_LOCAL")[1]  ,00, ".T."  ,"","C","SC3"})
	aAdd(aHeader,{"Observacoes"   , "C3_OBS"    , PesqPict("SC3","C3_OBS")     ,TamSx3("C3_OBS")[1]    ,00, ".T."  ,"","C","SC3"})
	aAdd(aHeader,{"Numero SC"     , "C3_NUMSC"  , PesqPict("SC3","C3_NUMSC")   ,TamSx3("C3_NUMSC")[1]  ,00, "U_COM61SC()"  ,"","C","SC3"})
	aAdd(aHeader,{"Item SC"       , "C3_ITEMSC" , PesqPict("SC3","C3_ITEMSC")  ,TamSx3("C3_ITEMSC")[1] ,00, "U_COM61ISC()" ,"","C","SC3"})
	aAdd(aHeader,{"Transportadora", "C3_TRANSP" , PesqPict("SC3","C3_TRANSP")  ,TamSx3("C3_TRANSP")[1] ,00, "U_COM61TRA()" ,"","C","SC3"})
	aAdd(aHeader,{"Cond. Entrega" , "C3_ENTREGA", PesqPict("SC3","C3_ENTREGA") ,TamSx3("C3_ENTREGA")[1],00, ".T."  ,"","C","SC3"})
	aAdd(aHeader,{"C.Custo"       , "C3_CC"     , PesqPict("SC3","C3_CC")      ,TamSx3("C3_CC")[1]     ,00, ".T."  ,"","C","SC3"})
	aAdd(aHeader,{"Conta"         , "C3_CONTA"  , PesqPict("SC3","C3_CONTA")   ,TamSx3("C3_CONTA")[1]  ,00, ".T."  ,"","C","SC3"})
			
	If nPar<>2
		
		SC3->(dbsetorder(1)) // FIL + NUM + ITEM
		SC3->(dbgotop())
		SC3->(dbseek(xFilial("SC3")+cNum))
		
		WHILE SC3->(!EOF()) .AND. SC3->C3_FILIAL==xFilial("SC3") .AND. SC3->C3_NUM==cNum

			SA2->(dbSetOrder(1))// FILIAL + COD + LOJA
			If SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))
				aInfoFor[1] := SA2->A2_NOME
				aInfoFor[2] := SA2->A2_TEL
				aInfoFor[3] := SA2->A2_PRICOM
				aInfoFor[4] := SA2->A2_END
				aInfoFor[5] := SA2->A2_EST
				aInfoFor[6] := SA2->A2_ULTCOM
			EndIf
			
	    	aAdd(aCols,{SC3->C3_ITEM,;
	    			    SC3->C3_PRODUTO,;
	    			    SC3->C3_DESCRI,;
	    			    SC3->C3_QUANT,;
	    			    SC3->C3_UM,;
	    			    SC3->C3_DATPRI,;
	    			    SC3->C3_DATPRF,;
	    			    SC3->C3_PRECO,;
	    			    SC3->C3_SIGLA,;
	    			    SC3->C3_TOTAL,;
	    			    SC3->C3_IPI,;
	    			    SC3->C3_LOCAL,;
	    			    SC3->C3_OBS,;
	    			    SC3->C3_NUMSC,;
						SC3->C3_ITEMSC,;
						SC3->C3_TRANSP,;
						SC3->C3_ENTREGA,;
						SC3->C3_CC,;
						SC3->C3_CONTA,;
						.F.})

			SC3->(dbskip())
		
		ENDDO   
		
	ENDIF	
	
	If nPar==1     //visualizar
	    bOk := {|| oDlg1:End()}

	ElseIf nPar==2 //incluir 
	
		//inicializa as variáveis
		cNum     := GetSxENum("SC3","C3_NUM")
		
		SC3->(dbSetOrder(1))
		While SC3->(dbSeek(xFilial("SC3")+cNum))
			cNum := Soma1(cNum)
		Enddo
		
		dData    := dDatabase
		cForn    := space(6)
		cLoja    := Space(2)
		cCond    := Space(3)
		cConDesc := ''
		cContato := Space(15)
		cFilEnt  := '01'
		nMoeda   := 1
		cMoedDes := SuperGetMv("MV_MOEDA"+AllTrim(Str(nMoeda,2)))
		cTransp  := space(6)
		dDataRev := Ctod('  /  /  ')
		cNumRev  := space(2)
		nValMerc := 0
		cTpFrete := ''
		nValIPI  := 0
		nValFre  := 0
		nTotalGe := 0
		cMsg     := space(3)
		cReajust := space(3)
		cDesMsg  := ''
		cDesReaj := ''
		
		bOk      := {|| Processa({||fInclui()},"Incluíndo")}
		bCanc    := {||RollBackSx8(), oDlg1:End()}
		
	ElseIf nPar==3 //alterar

		bOk := {|| fAltera()}
	
	ElseIf nPar==4 //excluir

		bOk := {|| fExclui()}

	EndIf

	aBotao := {{'PROJETPMS',{||maComView(aCols[n][2])},"Hist. Prd", "Hist. Prd" }}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)

	bEnchoice := {||EnchoiceBar(oDlg1,bOk,bCanc,,aBotao)}
			
	oDlg1 := MsDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	TSay():New(8,10,{||"Número"},oDlg1,,,,,,.T.,,)
	TSay():New(8,45,{||cNum},oDlg1,,oFont1,,,,.T.,,)

	TSay():New(8,150,{||"Emissão"},oDlg1,,,,,,.T.,,)
	TGet():New(6,195,{|u| if(Pcount() > 0, dData := u,dData)},oDlg1,45,8,"99/99/9999",{||.T.},,,,,,.T.,,,{||.F.})

	TSay():New(8,255,{||"Fornecedor"},oDlg1,,,,,,.T.,,)
	TGet():New(6,295,{|u| if(Pcount() > 0, cForn := u,cForn)},oDlg1,45,8,"@!",{||fValForn()},,,,,,.T.,,,{||.T.},,,,,,CpoRetF3('C3_FORNECE'))
	TGet():New(6,342,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlg1,10,8,"@!",{||fValLoja()},,,,,,.T.,,,{||.T.})

	TSay():New(23,10,{||"Cond. Pagto"},oDlg1,,,,,,.T.,,)
	TGet():New(21,45,{|u| if(Pcount() > 0, cCond := u,cCond)},oDlg1,30,8,"@!",{||fValCond()},,,,,,.T.,,,{||.T.},,,,,,CpoRetF3('C3_COND'))
	oConDesc := TGet():New(21,80,{|u| if(Pcount() > 0, cConDesc := u,cConDesc)},oDlg1,60,8,"@!",{||.T.},,,,,,.T.,,,{||.F.})
	
	TSay():New(23,150,{||"Contato"},oDlg1,,,,,,.T.,,)
	oContato := TGet():New(21,195,{|u| if(Pcount() > 0, cContato := u,cContato)},oDlg1,50,8,"@!",{||.T.},,,,,,.T.,,,{||.T.})
	
	TSay():New(23,255,{||"Filial p/ Entrega"},oDlg1,,,,,,.T.,,)
	TGet():New(21,295,{|u| if(Pcount() > 0, cFilEnt := u,cFilEnt)},oDlg1,20,8,"@!",{||.T.},,,,,,.T.,,,{||.T.},,,,,,CpoRetF3('C3_FILENT'))

	TSay():New(38,10,{||"Moeda"},oDlg1,,,,,,.T.,,)
	TGet():New(36,45,{|u| if(Pcount() > 0, nMoeda := u,nMoeda)},oDlg1,20,8,PesqPict("SC3","C3_MOEDA"),{||.T.},,,,,,.T.,,,{||.T.})
	TGet():New(36,80,{|u| if(Pcount() > 0, cMoedDes := u,cMoedDes)},oDlg1,60,8,"@!",{||.F.},,,,,,.T.,,,{||.F.})

	TSay():New(38,150,{||"Transportadora"},oDlg1,,,,,,.T.,,)
	TGet():New(36,195,{|u| if(Pcount() > 0, cTransp := u,cTransp)},oDlg1,20,8,PesqPict("SC3","C3_TRANSP"),{||fValTransp()},,,,,,.T.,,,{||.T.},,,,,,CpoRetF3('C3_TRANSP'))

	TSay():New(38,255,{||"Data Revisão"},oDlg1,,,,,,.T.,,)
	TGet():New(36,295,{|u| if(Pcount() > 0, dDataRev := u,dDataRev)},oDlg1,45,8,"99/99/9999",{||.T.},,,,,,.T.,,,{||.F.})
	TGet():New(36,342,{|u| if(Pcount() > 0, cNumRev := u,cNumRev)},oDlg1,10,8,"@!",{||.T.},,,,,,.T.,,,{||.F.})

	SetKey( VK_F4 , { || Processa({||ShowF4()},'Buscando SC ...') } )

    // cria o getDados
	oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 55    ,; //superior
	                           aPosObj[2,2]     ,; //esquerda
	                           aPosObj[2,3]-75  ,; //inferior
	                           aPosObj[2,4]     ,; //direita
	                           4                ,; // nOpc
	                           "U_COM61LOK()"   ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           "+C3_ITEM"       ,; // CINICPOS
	                           lDeleta          ,; // LDELETA
	                           nil              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           nMax             ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg1              ; // oWnd
	                          )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define a area do rodape da rotina                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFolder := TFolder():New(aPosObj[2,3]-70,aPosObj[2,2],aTitles,,oDlg1,,,, .T., .F.,aPosObj[2,4]-5,70,)
	
	//-- FOLDER 01
	
	TSay():New(10,10,{||"Valor da Mercadoria"},oFolder:aDialogs[1],,,,,,.T.,,)
	oMerc := TGet():New( 8,65,{|u| if(Pcount() > 0, nValMerc := u,nValMerc)},oFolder:aDialogs[1],60,8,PesqPict('SC3','C3_TOTAL',17,nMoeda),{||.F.},,,,,,.T.,,,{||.f.})
	
	TSay():New(10,200,{||"Valor do IPI"},oFolder:aDialogs[1],,,,,,.T.,,)
	oIpi := TGet():New( 8,255,{|u| if(Pcount() > 0, nValIpi := u,nValIpi)},oFolder:aDialogs[1],60,8,PesqPict('SC3','C3_TOTAL',17,nMoeda),{||.F.},,,,,,.T.,,,{||.f.})

	TSay():New(25,10,{||"Tipo do Frete"},oFolder:aDialogs[1],,,,,,.T.,,)
	
	//combobox
	oCombo:= TComboBox():New(23,65,{|u| if(Pcount() > 0,cTpFrete := u,cTpFrete)},;
		{"","C=CIF","F=FOB"},50,20,oFolder:aDialogs[1],,{||},,,,.T.,,,,{|| .T.})
	
	TSay():New(25,200,{||"Valor do Frete"},oFolder:aDialogs[1],,,,,,.T.,,)
	TGet():New(23,255,{|u| if(Pcount() > 0, nValFre := u,nValFre)},oFolder:aDialogs[1],60,8,PesqPict('SC3','C3_TOTAL',17,nMoeda),{||.F.},,,,,,.T.,,,{||.f.})		
    
	//contorno
	tGroup():New(036,010,38,aPosObj[2,4]-15,,oFolder:aDialogs[1],,,.T.)

	TSay():New(45,200,{||"Total do Contrato"},oFolder:aDialogs[1],,,,,,.T.,,)
	oTotalGe := TGet():New(43,255,{|u| if(Pcount() > 0, nTotalGe := u,nTotalGe)},oFolder:aDialogs[1],60,8,PesqPict('SC3','C3_TOTAL',17,nMoeda),{||.F.},,,,,,.T.,,,{||.f.})		

	//-- FOLDER 02
	
	TSay():New(10, 5,{||"Nome"},oFolder:aDialogs[2],,,,,,.T.,,)
	TGet():New( 8,35,{|u| if(Pcount() > 0, aInfoFor[1] := u,aInfoFor[1])},oFolder:aDialogs[2],120,8,"@!",{||.F.},,,,,,.T.,,,{||.f.})
	
	TSay():New(10,220,{||"Tel"},oFolder:aDialogs[2],,,,,,.T.,,)
	TGet():New( 8,240,{|u| if(Pcount() > 0, aInfoFor[2] := u,aInfoFor[2])},oFolder:aDialogs[2],80,8,"@!",{||.F.},,,,,,.T.,,,{||.f.})

	TSay():New(10,325,{||"1a Compra"},oFolder:aDialogs[2],,,,,,.T.,,)
	TGet():New( 8,360,{|u| if(Pcount() > 0, aInfoFor[3] := u,aInfoFor[3])},oFolder:aDialogs[2],40,8,"99/99/99",{||.F.},,,,,,.T.,,,{||.f.})

	TSay():New(25, 5,{||"Endereço"},oFolder:aDialogs[2],,,,,,.T.,,)
	TGet():New(23,35,{|u| if(Pcount() > 0, aInfoFor[4] := u,aInfoFor[4])},oFolder:aDialogs[2],180,8,"@!",{||.F.},,,,,,.T.,,,{||.f.})
	
	TSay():New(25,220,{||"Estado"},oFolder:aDialogs[2],,,,,,.T.,,)
	TGet():New(23,240,{|u| if(Pcount() > 0, aInfoFor[5] := u,aInfoFor[5])},oFolder:aDialogs[2],40,8,"@!",{||.F.},,,,,,.T.,,,{||.f.})

	TSay():New(25,325,{||"Ult. Compra"},oFolder:aDialogs[2],,,,,,.T.,,)
	TGet():New(23,360,{|u| if(Pcount() > 0, aInfoFor[6] := u,aInfoFor[6])},oFolder:aDialogs[2],40,8,"99/99/99",{||.F.},,,,,,.T.,,,{||.f.})
                                            
	//@ 042,aPosGet[6,5] BUTTON STR0028 SIZE 030,010  FONT oDlg1:oFont ACTION A120ToFC030()  OF oFolder:aDialogs[2] PIXEL // "Mais Inf."

	//-- FOLDER 03
	
	//contorno
	tGroup():New(02,010,55,((aPosObj[2,4]-15) / 2)-2,"Mensagem",oFolder:aDialogs[3],,,.T.)
	tGroup():New(02, ((aPosObj[2,4]-15) / 2)+2,55,aPosObj[2,4]-15 ,"Reajuste",oFolder:aDialogs[3],,,.T.)	

	TSay():New(15,020,{||"Cod. Formula"},oFolder:aDialogs[3],,,,,,.T.,,)
	TGet():New(13,170,{|u| if(Pcount() > 0, cMsg := u,cMsg)},oFolder:aDialogs[3],30,8,PesqPict('SC3','C3_MSG'),{||.F.},,,,,,.T.,,,{||.T.},,,,,,CpoRetF3('C3_MSG'))
	TGet():New(30,020,{|u| if(Pcount() > 0, cDesMsg := u,cDesMsg)},oFolder:aDialogs[3],180,8,"@!",{||.F.},,,,,,.T.,,,{||.f.})
	
	TSay():New(15,((aPosObj[2,4]-15) / 2)+10 ,{||"Cod. Formula"},oFolder:aDialogs[3],,,,,,.T.,,)
	TGet():New(13,((aPosObj[2,4]-15) / 2)+160,{|u| if(Pcount() > 0, cReajust := u,cReajust)},oFolder:aDialogs[3],30,8,PesqPict('SC3','C3_REAJUS'),{||.F.},,,,,,.T.,,,{||.T.},,,,,,CpoRetF3('C3_REAJUS'))
	TGet():New(30,((aPosObj[2,4]-15) / 2)+10 ,{|u| if(Pcount() > 0, cDesReaj := u,cDesReaj)},oFolder:aDialogs[3],180,8,"@!",{||.F.},,,,,,.T.,,,{||.f.})

	fTotal()		

	oDlg1:Activate(,,,.F.,{||.T.},,bEnchoice)
	
	Set Key VK_F4 To //Desabilita a tecla F4
	
	SC3->(dbseek(xFilial("SC3")+cNum))

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ controle dos totais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function COM51TOT()
Local nTot := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="C3_TOTAL"})
Local nPrc := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="D1_CUSTO"})
Local nQtd := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="B2_QATU"})
Local nIPI := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="C3_IPI"})

Local nVal_Qtd := Iif(ALLTRIM(UPPER(ReadVar()))$'M->B2_QATU' ,M->B2_QATU ,aCols[n][nQtd])
Local nVal_Prc := Iif(ALLTRIM(UPPER(ReadVar()))$'M->D1_CUSTO',M->D1_CUSTO,aCols[n][nPrc])
Local nVal_IPI := Iif(ALLTRIM(UPPER(ReadVar()))$'M->C3_IPI'  ,M->C3_IPI  ,aCols[n][nIPI])

	aCols[n][nTot] := nVal_Qtd * nVal_Prc
	oGetD:Refresh()
	
	fTotal()
	
Return .T.

Static Function fTotal()
Local nTotal  := 0
Local nTot := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="C3_TOTAL"})
Local nPrc := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="D1_CUSTO"})
Local nQtd := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="B2_QATU"})
Local nIPI := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="C3_IPI"})

Local nVal_Qtd := Iif(ALLTRIM(UPPER(ReadVar()))$'M->B2_QATU' ,M->B2_QATU ,aCols[n][nQtd])
Local nVal_Prc := Iif(ALLTRIM(UPPER(ReadVar()))$'M->D1_CUSTO',M->D1_CUSTO,aCols[n][nPrc])
Local nVal_IPI := Iif(ALLTRIM(UPPER(ReadVar()))$'M->C3_IPI'  ,M->C3_IPI  ,aCols[n][nIPI])
    
    nTotalGE := 0
    nValIPI  := 0
    nValMerc := 0
    
	For xT:=1 to Len(aCols)
		If !aCols[xT][len(aHeader)+1]
			if n==xT
				nValMerc += nVal_Prc * nVal_Qtd
				nValIPI  += (nVal_Prc/100 * nVal_IPI) * nVal_Qtd
			else
				nValMerc += aCols[xT][nPrc] * aCols[xT][nQtd]
				nValIPI  += (aCols[xT][nPrc]/100 * aCols[xT][nIPI]) * aCols[xT][nQtd]
			EndIf
		Endif
	Next

	nTotalGe := nValMerc + nValIPI
	
	oIPI:Refresh()
	oMerc:Refresh()
	oTotalGe:Refresh()
		
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValForn()

	SA2->(dbSetOrder(1))// FILIAL + COD + LOJA
	If !SA2->(dbSeek(xFilial("SA2")+cForn)) .AND. !Empty(cForn)
		Alert("Fornecedor não encontrado!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA DO FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValLoja()

	If Empty(cLoja)
		Return .T.
	EndIf
	
	SA2->(dbSetOrder(1))// FILIAL + COD + LOJA
	If !SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))
		Alert("Fornecedor / Loja não encontrado!")
		Return .F.
	Else
		aInfoFor[1] := SA2->A2_NOME
		aInfoFor[2] := SA2->A2_TEL
		aInfoFor[3] := SA2->A2_PRICOM
		aInfoFor[4] := SA2->A2_END
		aInfoFor[5] := SA2->A2_EST
		aInfoFor[6] := SA2->A2_ULTCOM
		
		oFolder:Refresh()	
		
		cContato := SA2->A2_CONTATO
		oContato:Refresh()
		
		If Empty(cCond) .and. !Empty(SA2->A2_COND)
			cCond := SA2->A2_COND
			fValCond()
		Endif
		
	EndIf
	
Return .T.	

Static Function fValCond()

	SE4->(dbsetorder(1))
	If !SE4->(dbseek(xFilial("SE4")+cCond))
		Alert("Condição de Pagamento não encontrada no cadastro!")
		Return .F.
	Else
		cConDesc := SE4->E4_DESCRI
		oConDesc:Refresh()
	Endif

Return .T.

Static Function fValTransp()

	SA4->(dbsetorder(1))
	If !SA4->(dbseek(xFilial("SA4")+cTransp)) .and. !empty(cTransp)
		Alert("Transportadora não encontrada no cadastro!")
		Return .F.
	Endif
	
Return .T.

User Function COM61TRA()
    
	SA4->(dbsetorder(1))
	If !SA4->(dbseek(xFilial("SA4")+M->C3_TRANSP))
		Alert("Transportadora não encontrada no cadastro!")
		Return .F.
	Endif
	
Return .T.

User Function COM61PRD()
Local nDesc := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="B1_DESC"})
Local nUM   := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="C3_UM"})

	SB1->(DBSETORDER(1))
	If SB1->(DBSEEK(XFILIAL("SB1")+M->C3_PRODUTO))
		aCols[n][nDesc] := SB1->B1_DESC
		aCols[n][nUM]   := SB1->B1_UM
		oGetD:Refresh()
	Else
		Alert("Produto não encontrado!")
		Return .F.
	Endif

Return .T.

User Function COM51SIG()
	If !ExistCpo("SX5","ZE"+M->C3_SIGLA)
		Alert('Sigla não encontrada!')
		Return .f.
	Endif
Return .T.

User Function COM61SC()

	SC1->(dbsetorder(1)) //fil + num + it
	If !SC1->(dbseek(xFilial('SC1')+M->C3_NUMSC))
		Alert('SC não encontrada!')
		Return .f.
	Else
		If SC1->C1_CONTRAT<>'S'
			Alert('Favor selecionar uma SC de Contrato!')
			Return .f.
		Endif
		
		If SC1->C1_QUANT==SC1->C1_QUJE
			Alert('SC já encerrada!')
			Return .f.
		Endif
		
		If SC1->C1_RESIDUO=='S'
			Alert('SC Eliminada p/ Residuo!')
			Return .f.
		Endif
	
	Endif
	
Return .T.

User Function COM61ISC()
Local nSC := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="C3_NUMSC"})

	SC1->(dbsetorder(1)) //fil + num + it
	If !SC1->(dbseek(xFilial('SC1')+ACols[n][nSC]+M->C3_ITEMSC))
		Alert('SC + Item não encontrado!')
		Return .f.
	Else
		If SC1->C1_CONTRAT<>'S'
			Alert('Favor selecionar uma SC de Contrato!')
			Return .f.
		Endif
		
		If SC1->C1_QUANT==SC1->C1_QUJE
			Alert('SC já encerrada!')
			Return .f.
		Endif
		
		If SC1->C1_RESIDUO=='S'
			Alert('SC Eliminada p/ Residuo!')
			Return .f.
		Endif

	Endif
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDAÇÃO GERAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Valida()
Local _nProd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_PRODUTO"}) 
Local _nQtde    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B2_QATU"}) 
Local _nLocal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_LOCAL"}) 
Local _nCC      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CC"}) 
Local _nConta   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CONTA"}) 
Local _nPreco   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CUSTO"}) 
Local _nSigla   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_SIGLA"}) 

	If Empty(cForn)
		Alert('Informe o Fornecedor!')
		Return .F.
	Endif

	If Empty(cLoja)
		Alert('Informe a Loja!')
		Return .F.
	Endif
	
	If Empty(cCond)
		Alert('Informe a Cond. Pagto!')
		Return .F.
	Endif
	
	If Empty(nMoeda)
		Alert('Informe a Moeda!')
		Return .F.
	Endif
	
	numItens := 0
	
	For nX:=1 to len(acols)
		iF !aCols[nX][len(aHeader)+1]
			if(!empty(acols[nX][_nProd]))
				numItens++
			endif
		endif
	next
           
	if numItens==0
		alert('Pelo menos um item deve ser incluído!')
		return .f.
	endif

	For nX:=1 to len(acols)
		iF !aCols[nX][len(aHeader)+1]

			If Empty(aCols[nX][_nProd])
				Alert('Informe o produto do item '+alltrim(str(nx))+'!')
				Return .F.
			Endif
			
			If Empty(aCols[nX][_nQtde])
				Alert('Informe a quantidade do item '+alltrim(str(nx))+'!')
				Return .F.
			Endif
			
			If Empty(aCols[nX][_nLocal])
				Alert('Informe o local do item '+alltrim(str(nx))+'!')
				Return .F.
			Endif
			
			If Empty(aCols[nX][_nCC])
				Alert('Informe o C.Custo do item '+alltrim(str(nx))+'!')
				Return .F.
			Endif
		
			If Empty(aCols[nX][_nConta])
				Alert('Informe a Conta Contábil do item '+alltrim(str(nx))+'!')
				Return .F.
			Endif
		
			If Empty(aCols[nX][_nPreco])
				Alert('Informe o Valor Unitário do item '+alltrim(str(nx))+'!')
				Return .F.
			Endif
			
			If Empty(aCols[nX][_nSigla])
				Alert('Informe a Sigla do item '+alltrim(str(nx))+'!')
				Return .f.
			endif
			
		endif
	next
	
Return .T.

User Function COM61LOK()
Local _nProd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_PRODUTO"}) 
Local _nQtde    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B2_QATU"}) 
Local _nLocal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_LOCAL"}) 
Local _nCC      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CC"}) 
Local _nConta   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CONTA"}) 
Local _nPreco   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CUSTO"}) 
Local _nSigla   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_SIGLA"}) 

	iF aCOLS[n][len(aheader)+1]
		return .t.
	endif

	fTotal()
	
	If Empty(aCols[n][_nProd])
		Alert('Informe o produto!')
		Return .F.
	Endif
	
	If Empty(aCols[n][_nQtde])
		Alert('Informe a quantidade!')
		Return .F.
	Endif
	
	If Empty(aCols[n][_nLocal])
		Alert('Informe o local!')
		Return .F.
	Endif
	
	If Empty(aCols[n][_nCC])
		Alert('Informe o C.Custo!')
		Return .F.
	Endif

	If Empty(aCols[n][_nConta])
		Alert('Informe a Conta Contábil!')
		Return .F.
	Endif

	If Empty(aCols[n][_nPreco])
		Alert('Informe o Valor Unitário!')
		Return .F.
	Endif
	
	If Empty(aCols[n][_nSigla])
		Alert('Informe a Sigla!')
		Return .f.
	endif
Return .T.                                                                                     


Static Function fInclui(lValida)
Local aCab   := {}
Local aItens := {}  
Local nX     := 0 
Local aLinha := {}
//Local aItemZero := {}
Default lValida := .T.
Private	lMsErroAuto := .F.

	If lValida
		If !Valida()
			Return .F.
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// Verifica numero do PA
	If nPar==2 //-- inclui
		SC3->(dbSetOrder(1))
		While SC3->(dbSeek(xFilial("SC3")+cNum))
			cNum := Soma1(cNum)
		Enddo
	Endif
		
	aCab := getCab()

	For nX := 1 To len(aCols)

		If !aCols[nX][len(aheader)+1]
	
			aLinha := {}
			
			If aCols[nX][4]==0
				Loop
			Endif
			
			//-- quantidade nao pode ser zero
			
			//-- tratativa para nao dar lmserroauto
			/*
			If aCols[nX][4]==0 //-- quantidade nao pode ser zero
				aAdd(aItemZero,{cNum,aCols[nX][1]})
				aCols[nX][4] := 1 // entao inclui com 1, depois executa update para zerar
			Endif
			*/
			
			aadd(aLinha,{"C3_FILIAL"  ,xFilial("SC3"),Nil})
			aadd(aLinha,{"C3_ITEM"    ,aCols[nX][1]  ,Nil})  	
			aadd(aLinha,{"C3_PRODUTO" ,aCols[nX][2]  ,Nil})
			aadd(aLinha,{"C3_QUANT"   ,aCols[nX][4]  ,Nil})
			aadd(aLinha,{"C3_PRECO"   ,aCols[nX][8]  ,Nil})
			aadd(aLinha,{"C3_TOTAL"   ,aCols[nX][10] ,Nil})
			aadd(aLinha,{"C3_DATPRI"  ,aCols[nX][6]  ,Nil})
			aadd(aLinha,{"C3_DATPRF"  ,aCols[nX][7]  ,Nil})
			
			aadd(aLinha,{"C3_DESCRI"  ,aCols[nX][3]  ,Nil})
			aadd(aLinha,{"C3_UM"      ,aCols[nX][5]  ,Nil})
			aadd(aLinha,{"C3_SIGLA"   ,aCols[nX][9]  ,Nil})
			aadd(aLinha,{"C3_IPI"     ,aCols[nX][11] ,Nil})
			aadd(aLinha,{"C3_LOCAL"   ,aCols[nX][12] ,Nil})
			aadd(aLinha,{"C3_OBS"     ,aCols[nX][13] ,Nil})
			aadd(aLinha,{"C3_NUMSC"   ,aCols[nX][14] ,Nil})
			aadd(aLinha,{"C3_ITEMSC"  ,aCols[nX][15] ,Nil})
			aadd(aLinha,{"C3_TRANSP"  ,aCols[nX][16] ,Nil})
			aadd(aLinha,{"C3_ENTREGA" ,aCols[nX][17] ,Nil})
			aadd(aLinha,{"C3_CC"      ,aCols[nX][18] ,Nil})
			aadd(aLinha,{"C3_CONTA"   ,aCols[nX][19] ,Nil})
			aadd(aLinha,{"C3_FILENT"  ,cFilEnt       ,NIL})
			aadd(aLinha,{"C3_NUMREV"  ,cNumRev       ,NIL})
			aadd(aLinha,{"C3_DATAREV" ,dDataRev      ,NIL})
			aadd(aLinha,{"C3_TPFRETE" ,cTpFrete      ,NIL})			
			
			aadd(aItens,aLinha)
		Endif
		
	Next nX
	
	If len(aItens)<=0
		Alert('Impossível gerar revisão, pedido já foi atendido!')
		Return .f.
	Endif
	
	MSExecAuto( {|x,y,z| mata125(x,y,z)},aCab,aItens,3)
	
	If lMsErroAuto 
		MostraErro()
		Return .f.
	Endif  
	
	ConfirmSx8()
	
   	SC3->(dbSetOrder(1)) // FILIAL + NUM + ITEM

	For xZ:=1 to len(aItens)
		If SC3->(dbSeek(xFilial("SC3")+cNum+aItens[xZ][2][2]))		
			Reclock("SC3",.F.)
				SC3->C3_IPI := aCols[xZ][11] //-- TIVE QUE FORÇAR POIS NO EXECAUTO NAO ESTAVA GRAVANDO
				SC3->C3_TPFRETE := cTpFrete  //-- TIVE QUE FORÇAR POIS NO EXECAUTO NAO ESTAVA GRAVANDO
			MsUnlock()
		Endif
	Next
	
	oDlg1:End()	

Return .T.

Static Function fAltera()
Local aCab       := {}
Local aItens     := {}  
Local aItensDel  := {}  
Local aItensInc  := {}  
Local aC3DelRec  := {}
Local aRecZB2Del := {}
Local _aPedAb    := {}
Local nPosQuant  := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="B2_QATU"})
Local nPosPrc    := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="D1_CUSTO"})
Local nPosTot    := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="C3_TOTAL"})

Private	lMsErroAuto := .F.
	
	If !Valida()
		Return .F.
	Endif
	       
	If !MsgYesNo("Esta alteração irá gerar uma nova revisão! "+CHR(10)+CHR(13)+;
			     "Os ítens totalmente atendidos serão gravados no histórico e removidos da nova versão!"+chr(10)+chr(13)+;
			     "Deseja continuar?")
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄ¿
	//³ REVISAO ³
	//ÀÄÄÄÄÄÄÄÄÄÙ
		
	SC3->(dbsetorder(1))
	If !SC3->(dbseek(xFilial("SC3")+cNum))
		Alert("Erro ao alterar! Documento não encontrado!")
		Return
	Endif
	
	//Numero da Revisao
	If !empty(SC3->C3_NUMREV)
		cNumRev := Soma1(SC3->C3_NUMREV)
	Else
		cNumRev := '01'
	endif

	dDataRev := ddatabase
	  
	BEGIN TRANSACTION          
	
	aRecC3Del := {}
	
	While SC3->(!EOF()) .AND. SC3->C3_NUM==cNum
	
		RecLock("ZB2",.T.) 
		
			ZB2->ZB2_FILIAL 	 := SC3->C3_FILIAL
			ZB2->ZB2_NUM    	 := SC3->C3_NUM
			ZB2->ZB2_FORNEC      := SC3->C3_FORNECE
			ZB2->ZB2_LOJA        := SC3->C3_LOJA
			ZB2->ZB2_ITEM        := SC3->C3_ITEM
			ZB2->ZB2_PRODUT      := SC3->C3_PRODUTO
			ZB2->ZB2_DESCRI      := SC3->C3_DESCRI
			ZB2->ZB2_QUANT       := SC3->C3_QUANT
			ZB2->ZB2_UM          := SC3->C3_UM
			ZB2->ZB2_DATPRI      := SC3->C3_DATPRI
			ZB2->ZB2_DATPRF      := SC3->C3_DATPRF                '
			ZB2->ZB2_PRECO       := SC3->C3_PRECO
			ZB2->ZB2_SIGLA       := SC3->C3_SIGLA
			ZB2->ZB2_COND        := SC3->C3_COND
			ZB2->ZB2_CONTAT      := SC3->C3_CONTATO
			ZB2->ZB2_FILENT      := SC3->C3_FILENT
			ZB2->ZB2_EMISSA      := SC3->C3_EMISSAO
			ZB2->ZB2_TOTAL       := SC3->C3_TOTAL
			ZB2->ZB2_IPI         := SC3->C3_IPI
			ZB2->ZB2_LOCAL       := SC3->C3_LOCAL
			ZB2->ZB2_RESIDU      := SC3->C3_RESIDUO
			ZB2->ZB2_MSG         := SC3->C3_MSG
			ZB2->ZB2_ENCER       := SC3->C3_ENCER
			ZB2->ZB2_FRETE       := SC3->C3_FRETE
			ZB2->ZB2_EMITID      := SC3->C3_EMITIDO
		    ZB2->ZB2_OK          := SC3->C3_OK
			ZB2->ZB2_OBS         := SC3->C3_OBS
			ZB2->ZB2_QUJE        := SC3->C3_QUJE
			ZB2->ZB2_REAJUS      := SC3->C3_REAJUST
			ZB2->ZB2_TPFRET      := SC3->C3_TPFRETE
			ZB2->ZB2_MOEDA       := SC3->C3_MOEDA
			ZB2->ZB2_VALFRE      := SC3->C3_VALFRE
			ZB2->ZB2_NUMSC       := SC3->C3_NUMSC
			ZB2->ZB2_ITEMSC      := SC3->C3_ITEMSC
			ZB2->ZB2_TRANSP      := SC3->C3_TRANSP
			ZB2->ZB2_ENTREG      := SC3->C3_ENTREGA
			ZB2->ZB2_NUMREV      := SC3->C3_NUMREV
			ZB2->ZB2_TXMOED      := SC3->C3_TXMOEDA
			ZB2->ZB2_CC          := SC3->C3_CC
			ZB2->ZB2_DATARE      := SC3->C3_DATAREV
			ZB2->ZB2_USER        := SC3->C3_USER
			ZB2->ZB2_APROV       := SC3->C3_APROV
			ZB2->ZB2_GRUPCO      := SC3->C3_GRUPCOM
			ZB2->ZB2_CONAPR      := SC3->C3_CONAPRO
			ZB2->ZB2_CONTA       := SC3->C3_CONTA
			ZB2->ZB2_GRADE       := SC3->C3_GRADE
			ZB2->ZB2_ITEMGR      := SC3->C3_ITEMGRD
			ZB2->ZB2_SEGUM       := SC3->C3_SEGUM
			ZB2->ZB2_AVISTA      := SC3->C3_AVISTA
			ZB2->ZB2_QTSEGU      := SC3->C3_QTSEGUM
			ZB2->ZB2_QTIMP       := SC3->C3_QTIMP
			     
			//-- subtrai a quantidade ja entregue da quantidade
			_n := Ascan(aCols,{|x| x[1]==SC3->C3_ITEM })
			
			/*
			If _n<>0
				aCols[_n][nPosQuant] := SC3->C3_QUANT - SC3->C3_QUJE
				aCols[_n][nPosTot]   := aCols[_n][nPosQuant] * aCols[_n][nPosPrc]
			Endif
			*/
			
		MsUnLock("ZB2")
		
		aAdd(aRecZB2Del,ZB2->(Recno()))
                       
		aAdd(aRecC3Del,SC3->(Recno()))
		                       
		Reclock("SC3",.F.)
			SC3->(DBDELETE())
		MsUnlock()

		SC3->(dbSkip())

	ENDDO

	SC3->(dbseek(xFilial("SC3")+cNum))
  
	If !fInclui(.F.)
		For xE:=1 to len(aRecC3Del)
			cQuery := "UPDATE "+Retsqlname("SC3")+" SET D_E_L_E_T_ = '' WHERE R_E_C_N_O_ = "+alltrim(str(aRecC3Del[xE]))
			TCSQLEXEC(cQuery)
		Next
		For xE:=1 to len(aRecZB2Del)
			cQuery := "UPDATE "+Retsqlname("ZB2")+" SET D_E_L_E_T_ = '*' WHERE R_E_C_N_O_ = "+alltrim(str(aRecZB2Del[xE]))
			TCSQLEXEC(cQuery)
		Next
	Endif

	END TRANSACTION

	oDlg1:End()	

Return

Static Function fExclui()
Local aCab   := {}
Local aItens := {}  
Local cAE    := ""
Private	lMsErroAuto := .F.

    //-- VERIFICA SE EXISTEM AE ABERTAS
   	SC7->(dbSetOrder(22)) //C7_FILIAL+C7_NUMSC+C7_ITEMSC
   	If SC7->(dbSeek(xFilial("SC7")+SC3->C3_NUM))

   		While SC7->(!Eof()) .AND. SC7->C7_NUMSC==SC3->C3_NUM

   			If SC7->C7_QUJE < SC7->C7_QUANT .AND. SC7->C7_RESIDUO<>'S' .AND. ; //somente pedidos em aberto
   			   SC7->C7_FORNECE+SC7->C7_LOJA==SC3->C3_FORNECE+SC3->C3_LOJA .AND. ; //somente mesmo fornecedor e loja
   			   SC7->C7_TIPO==2 //somente autorizacao de entrega

              	If !SC7->C7_NUM$cAe
	              	cAE += SC7->C7_NUM+CHR(13)+CHR(10)
	        	Endif

   			EndIf

   			SC7->(dbSkip())
   		EndDo
   	EndIf
   	
   	If !empty(cAe)
   		Alert("Para excluir este Pedido em Aberto as seguintes Autorizações de Entrega precisam ser excluídas:"+chr(13)+chr(10)+cAe)
   		Return
   	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Exclusão                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aCab := getCab()
	
	For nX := 1 To len(aCols)

		aLinha := {}
		aadd(aLinha,{"C3_FILIAL"  ,xFilial("SC3"),Nil})	
		aadd(aLinha,{"LINPOS","C3_ITEM",aCols[nX][1]  ,Nil})  
		aadd(aLinha,{"AUTDELETA","N",Nil})		
		aadd(aLinha,{"C3_PRODUTO" ,aCols[nX][2]  ,Nil})
		aadd(aLinha,{"C3_QUANT"   ,aCols[nX][4]  ,Nil})	
		aadd(aLinha,{"C3_PRECO"   ,aCols[nX][8]  ,Nil})	
		aadd(aLinha,{"C3_TOTAL"   ,aCols[nX][10] ,Nil})			
		aadd(aLinha,{"C3_DATPRI"  ,aCols[nX][6]  ,Nil})	
		aadd(aLinha,{"C3_DATPRF"  ,aCols[nX][7]  ,Nil})	
		aadd(aItens,aLinha)

	Next nX 	
	
	MSExecAuto( {|x,y,z| mata125(x,y,z)},aCab,aItens,5) 
	
	If lMsErroAuto 
		MostraErro()
		Return
	Endif  

	oDlg1:End()	

Return      

Static Function getCab()
Local aCabec := {}

	aadd(aCabec,{"C3_FILIAL"  , xFilial("SC3"),NIL})
	aadd(aCabec,{"C3_NUM"     ,cNum           ,NIL})
	aadd(aCabec,{"C3_EMISSAO" ,dData          ,NIL})
	aadd(aCabec,{"C3_FORNECE" ,cForn          ,NIL})
	aadd(aCabec,{"C3_LOJA"    ,cLoja          ,NIL})
	aadd(aCabec,{"C3_COND"    ,cCond          ,NIL})
	aadd(aCabec,{"C3_MOEDA"   ,nMoeda         ,NIL})

Return aCabec

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DE CONSULTA DAS SCS DO FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ShowF4()
Local  _lStatus  := .T.
Local aArea      := GetArea()
Private bF4Ok    := {||fF4Ok()}
Private bF4Canc  := {||fF4Canc()} 
Private oF4Dlg   := Nil
Private cMarca   := getmark()
Private _cArqDBF := CriaTrab(NIL,.f.)
Private _aDBF    := {}
Private aFields  := {}

	PROCREGUA(0)
	
	Processa({|| GeraSol() }, OemToAnsi("Busca Solicitação"))

	TMPCOM061->(DBGotop())       

	//-- monta arquivo dbf
	AADD(_aDBF,{"OK",          "C",02,0})
	AADD(_aDBF,{"DT_NUM",      "C",06,0})
	AADD(_aDBF,{"DT_ITEM",     "C",04,0})
	AADD(_aDBF,{"DT_PRODUTO",  "C",15,0})
	AADD(_aDBF,{"DT_QUANT",    "N",14,4})
	AADD(_aDBF,{"DT_EMISSAO",  "D",08,0})
		
	DbCreate(_cArqDBF,_aDBF)
	DbUseArea(.T.,,_cArqDBF,"XDET",.F.) 

	index ON XDET->DT_NUM+XDET->DT_ITEM TO (_cArqDBF)

	DBSELECTAREA("XDET")
	ZAP
	
	//-- verifica aprovação
	SZU->(DbSetOrder(2))             
	While !TMPCOM061->(EOF())   
	
		INCPROC()
    
	    _lStatus := .T.
		SZU->(DbSeek(xFilial("SZU")+TMPCOM061->C1_NUM+TMPCOM061->C1_ITEM))
		
		While !SZU->(Eof()) .And. SZU->ZU_FILIAL==xFilial("SZU") .AND. SZU->ZU_NUM+SZU->ZU_ITEM == TMPCOM061->C1_NUM+TMPCOM061->C1_ITEM
			If SZU->ZU_STATUS$"B/C" 
	        	_lStatus := .F.
		   	  	Exit
		   	Endif
	  
		   	If Empty(SZU->ZU_STATUS) .AND. SZU->ZU_ORIGEM=='SC1' .And. Val(SZU->ZU_NIVEL) < 9
	          	_lStatus := .F.
		   	  	Exit
		   	Endif	  
	       	SZU->(Dbskip())
	 	Enddo  
	 	
	 	If _lStatus

			RecLock("XDET",.T.)
	 			XDET->DT_NUM     := TMPCOM061->C1_NUM
	 			XDET->DT_ITEM    := TMPCOM061->C1_ITEM
	 			XDET->DT_PRODUTO := TMPCOM061->C1_PRODUTO
	 			XDET->DT_QUANT   := TMPCOM061->C1_QUANT
	 			XDET->DT_EMISSAO := TMPCOM061->C1_EMISSAO
	 		MsUnlock("XDET")
	 			
	    Endif        
	   
	   	TMPCOM061->(Dbskip())
	   	
	Enddo   
	
	XDET->(dbgotop())
	
	IF XDET->(EOF())
	   MsgBox(OemToAnsi("Nenhuma Solicitação Encontrada"),OemToAnsi("Atenção"),"ALERT") 
	   TMPCOM061->(DbCloseArea()) //Fecha a area da consulta
	   return
	Endif     

	aFields := {}
	Aadd(aFields,{"OK"           ,"C",""})
	Aadd(aFields,{"DT_NUM"       ,"C",OemToAnsi("Num SC") })    
	Aadd(aFields,{"DT_ITEM"      ,"C",OemToAnsi("Item") })
	Aadd(aFields,{"DT_PRODUTO"   ,"C",OemToAnsi("Produto") })   
	Aadd(aFields,{"DT_QUANT"     ,"N",OemToAnsi("Qtde"),"@E 999999999.9999"})
	Aadd(aFields,{"DT_EMISSAO"   ,"D",OemToAnsi("Emissao") })
		
	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	oF4Dlg := MsDialog():New(0,0,400,500,"Consulta SC",,,,,,,,,.T.)
	
	oMark := MsSelect():New("XDET","OK",nil,aFields,.F.,@cMarca,{10, 05 ,175,247})

    oBt1 := tButton():New(185,182,"Ok",oF4Dlg,bF4Ok,30,10,,,,.T.)      
    oBt2 := tButton():New(185,218,"Cancelar",oF4Dlg,bF4Canc,30,10,,,,.T.)

	oF4Dlg:Activate(,,,.T.,{||.T.},,)

	TMPCOM061->(DbCloseArea()) //Fecha a area da consulta                              
	XDET->(DbCloseArea())
	
	RestArea(aArea)
		
Return .T.

Static Function fF4Ok()
Local _nNumSC   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_NUMSC"}) 
Local _nItemSC  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_ITEMSC"}) 
Local _nProd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_PRODUTO"}) 
Local _nDescri  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_DESC"}) 
Local _nQtde    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B2_QATU"}) 
Local _nLocal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_LOCAL"}) 
Local _nCC      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CC"}) 
Local _nConta   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_CONTA"}) 
Local _nUM      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_UM"}) 
Local _nOBS     := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_OBS"}) 
Local _nPreco   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CUSTO"}) 
Local _nTotal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C3_TOTAL"}) 

DbSelectArea("SC3")
SC1->(dbsetorder(1))

//aCOLS:={}

XDET->(dbgotop())

While XDET->(!EOF())
	
	If XDET->(MARKED("OK"))

		If SC1->(dbseek(xFilial("SC1")+XDET->DT_NUM+XDET->DT_ITEM))

	    	If Empty(aCols[len(aCols)][_nProd])
//		    	aCols[len(aCols)][1]        := STRZERO(val(aCols[LEN(ACOLS)][1])+1,4)
		    	aCols[len(aCols)][_nProd]   := SC1->C1_PRODUTO
		    	aCols[len(aCols)][_nDescri] := SC1->C1_DESCRI
		    	aCols[len(aCols)][_nQtde]   := SC1->C1_QUANT
		    	aCols[len(aCols)][_nUM]     := Iif(empty(SC1->C1_UM),space(2),SC1->C1_UM)
		    	aCols[len(aCols)][6]        := dDatabase
		    	aCols[len(aCols)][7]        := dDatabase
		    	aCols[len(aCols)][_nPreco]  := SC1->C1_VUNIT
		    	aCols[len(aCols)][9]        := Iif(Empty(SC1->C1_SIGLA),space(3),SC1->C1_SIGLA)
		    	aCols[len(aCols)][_nTotal]  := SC1->C1_QUANT * SC1->C1_VUNIT
		    	aCols[len(aCols)][11]       := 0
		    	aCols[len(aCols)][_nLocal]  := SC1->C1_LOCAL
		    	aCols[len(aCols)][_nOBS]    := SC1->C1_OBS
		    	aCols[len(aCols)][_nNumSC]  := SC1->C1_NUM
		    	aCols[len(aCols)][_nItemSC] := SC1->C1_ITEM
		    	aCols[len(aCols)][16]       := SPACE(6)
		    	aCols[len(aCols)][17]       := Space(TamSx3("C3_ENTREGA")[1])
		    	aCols[len(aCols)][_nCC]     := SC1->C1_CC
		    	aCols[len(aCols)][_nConta]  := SC1->C1_CONTA
		    	aCols[len(aCols)][len(aHeader)+1] := .F.
	    	Else
		    	aAdd(aCols,{STRZERO(val(aCols[LEN(ACOLS)][1])+1,4),;
		    			    SC1->C1_PRODUTO,;
		    			    SC1->C1_DESCRI,;
		    			    SC1->C1_QUANT,;
		    			    Iif(empty(SC1->C1_UM),space(2),SC1->C1_UM),;
		    			    dDatabase,;
		    			    dDatabase,;
		    			    SC1->C1_VUNIT,;
		    			    Iif(Empty(SC1->C1_SIGLA),space(3),SC1->C1_SIGLA),;
		    			    SC1->C1_QUANT * SC1->C1_VUNIT,;
		    			    0,;
		    			    SC1->C1_LOCAL,;
		    			    SC1->C1_OBS,;
		    			    SC1->C1_NUM,;
							SC1->C1_ITEM,;
							SPACE(6),;
							Space(TamSx3("C3_ENTREGA")[1]),;
							SC1->C1_CC,;
							SC1->C1_CONTA,;
							.F.})
			Endif	
		Endif
	Endif
	
	XDET->(dbskip())
	
EndDo

fTotal()

oF4Dlg:End()

Return

Static Function fF4Canc()
	oF4Dlg:End()
Return

Static Function Gerasol()
Local cQuery
	
	cQuery := "SELECT SC1.C1_NUM,SC1.C1_ITEM,SC1.C1_PRODUTO,SC1.C1_DESCRI,(SC1.C1_QUANT - SC1.C1_QUJE) AS 'C1_QUANT',* "
	cQuery += "FROM " +  RetSqlName( 'SC1' ) +" SC1 (NOLOCK)"
	cQuery += "WHERE SC1.C1_FILIAL = '" + xFilial("SC1")+ "' " 
	cQuery += "AND SC1.D_E_L_E_T_ =  ' ' "
	cQuery += "AND SC1.C1_CONTRAT = 'S' "   
	cQuery += "AND (SC1.C1_QUANT - SC1.C1_QUJE) > 0 "   
	cQuery += "ORDER BY SC1.C1_NUM,SC1.C1_ITEM"
	
	TCQUERY cQuery NEW ALIAS "TMPCOM061"      
	TcSetField("TMPCOM061","C1_EMISSAO","D")  // Muda a data de string para date    
	
Return
  

//-- exemplo execauto

/*
User Function TMATA125()  
Local aCab   := {}
Local aItens := {}  
Local cDoc   := ""  
Local nX     := 0
Private	lMsErroAuto := .F.   

ConOut(Repl("-",80))
ConOut(PadC("Rotina Automática para o Contrato de Parceria",80))

PREPARE ENVIRONMENT EMPRESA "09" FILIAL "01" MODULO "COM"    

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Verifica numero da CP       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SC3")
	dbSetOrder(1)
	
	MsSeek(xFilial("SC3")+"zzzzzz",.T.)
	dbSkip(-1)
	
	cDoc := SC3->C3_NUM
	If Empty(cDoc)	
		cDoc := StrZero(1,Len(SC3->C3_NUM))
	Else	
		cDoc := Soma1(cDoc)
	EndIf
	
	aadd(aCab,{"C3_FILIAL", xFilial("SC3"), NIL})
	aadd(aCab,{"C3_NUM",cDoc,NIL})
	aadd(aCab,{"C3_EMISSAO",dDataBase})
	aadd(aCab,{"C3_FORNECE" ,"1     " ,NIL})
	aadd(aCab,{"C3_LOJA","01",NIL})
	aadd(aCab,{"C3_COND" ,"001" ,NIL})
	aadd(aCab,{"C3_FILENT" ,"001" ,NIL})	
	aadd(aCab,{"C3_MOEDA","1",NIL})	        
	
	For nX := 1 To 2	
		aLinha := {}       	
		aadd(aLinha,{"C3_FILIAL",xFilial("SC3"),Nil})	
		aadd(aLinha,{"C3_ITEM",StrZero(nX,len(SC3->C3_ITEM)),Nil})  	
		aadd(aLinha,{"C3_PRODUTO"  ,"5",Nil})	
		aadd(aLinha,{"C3_QUANT",2,Nil})	
		aadd(aLinha,{"C3_PRECO",135,Nil})	
		aadd(aLinha,{"C3_TOTAL",270,Nil})			
		aadd(aLinha,{"C3_DATPRI",dDataBase,Nil})	
		aadd(aLinha,{"C3_DATPRF",dDataBase,Nil})	
		aadd(aItens,aLinha)
	Next nX 	  
	
	MSExecAuto( {|x,y,z| mata125(x,y,z)},aCab,aItens,3) 			
	
	If lMsErroAuto 
		MostraErro()
	Else	
		MsgAlert("Incluido com sucesso! "+cDoc)
	Endif  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Alteração                                           |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	aCab   := {}  
	aItens := {}
	aadd(aCab,{"C3_FILIAL", xFilial("SC3"), NIL})
	aadd(aCab,{"C3_NUM",cDoc,NIL})
	aadd(aCab,{"C3_EMISSAO",dDataBase})
	aadd(aCab,{"C3_FORNECE" ,"1     " ,NIL})
	aadd(aCab,{"C3_LOJA","01",NIL})
	aadd(aCab,{"C3_COND" ,"001" ,NIL})
	aadd(aCab,{"C3_MOEDA","1",NIL})	        
	
	For nX := 1 To 2	
		aLinha := {}       	
		aadd(aLinha,{"C3_FILIAL",xFilial("SC3"),Nil})     	
		aadd(aLinha,{"LINPOS","C3_ITEM",StrZero(nX,len(SC3->C3_ITEM)),Nil})    
		aadd(aLinha,{"AUTDELETA","N",Nil})	
		aadd(aLinha,{"C3_PRODUTO"  ,"5",Nil})	
		aadd(aLinha,{"C3_QUANT",3,Nil})	
		aadd(aLinha,{"C3_PRECO",130,Nil})	
		aadd(aLinha,{"C3_TOTAL",390,Nil})			
		aadd(aLinha,{"C3_DATPRI",dDataBase,Nil})	
		aadd(aLinha,{"C3_DATPRF",dDataBase,Nil})	
		aadd(aItens,aLinha)
	Next nX 	  
	
	MSExecAuto( {|x,y,z| mata125(x,y,z)},aCab,aItens,4) 			
	
	If lMsErroAuto 
		MostraErro()
	Else	
		MsgAlert("Alterado com sucesso! "+cDoc)
	Endif             
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Exclusão                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	MSExecAuto( {|x,y,z| mata125(x,y,z)},aCab,aItens,5) 
	
	If lMsErroAuto 
		MostraErro()
	Else	
		MsgAlert("Excluído com sucesso! "+cDoc)
	Endif  
	
	MsgAlert("Fim da Rotina Automática! "+Time())	   
		
	RESET ENVIRONMENT	  	

Return
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXIBE HISTORICO DAS REVISOES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function COM61HIS()
Local aFixe :=   { 	{ "Numero"       ,"ZB2_NUM"    },;		        //"Numero"
					{ "Item"         ,"ZB2_ITEM"   },;
					{ "Revisão"      ,"ZB2_NUMREV" },;
					{ "Dt. Rev."     ,"ZB2_DATARE" },;
                    { "Produto"      ,"ZB2_PRODUT" },;		        //"Produto"
                    { "Emissao"      ,"ZB2_EMISSA" },;		        //"Emissao"
                    { "Dt. Entrega"  ,"ZB2_DATPRF" },;		        //"Dt. Entrega"
                    { "Fornecedor"   ,"ZB2_FORNEC" },;		        //"Fornecedor"  
                    { "Loja"         ,"ZB2_LOJA"   },;
                    { "Qt. Entregue" ,"ZB2_QUJE"   } }		        //"Qt. Entregue"

Local cOldCad := cCadastro
Local aOldRot := aRotina

Private cCadastro
Private aRotina

cCadastro := OemToAnsi('Histórico dos Pedidos em Aberto')

aRotina := {{ "Visualizar"  ,"U_fVisZB2()",0,2}}
           
DbSelectArea("ZB2")
ZB2->(DbSetOrder(1))
DbGoTop()
            
mBrowse(06,01,22,75,"ZB2",aFixe,,,,,{{'' ,'DISABLE'}})   

cCadastro := cOldCad 
aRotina   := aOldRot

Return
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VISUALIZA ITEM DO HISTORICO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function fVisZB2()  
Local _aItem := {}
Local _cNum
Local _cRev
Local _CPDesc
Local cDescMoed
Local _nRec
Local nMoeda

//+-------------------------------------------------------+
//| Monta a tela para usuario visualizar o Ped. em Aberto |
//+-------------------------------------------------------+
DEFINE MSDIALOG oDlgHis TITLE "Historico do Pedido em Aberto - Visualizacao" FROM 0,0 TO 420,730 PIXEL

@ 015,010 TO 060,360 OF oDlgHis PIXEL

@ 020,015 Say OemToAnsi("Número: ")  Size 040,8 Object olNum
@ 020,045 Get ZB2->ZB2_NUM WHEN .F.  Size 040,8 Object oNum
@ 020,140 Say OemToAnsi("Emissão: ") Size 040,8 Object olEmissao
@ 020,180 Get DtoC(ZB2->ZB2_EMISSA)  Size 040,8 Object oEmissao
@ 020,260 Say OemToAnsi("Fornecedor: ") Size 040,8 Object olForn
@ 020,295 Get ZB2->ZB2_FORNEC when .f.  Size 040,8 Object oForn
@ 020,335 Get ZB2->ZB2_LOJA   when .f.  Size 005,8 Object oForn

@ 032,015 Say OemToAnsi("Cond. Pgto: ") Size 040,8 Object olCond
@ 032,045 Get ZB2->ZB2_COND when .f.  Size 020,8 Object oCond

SE4->(DBSETORDER(1))
SE4->(DBSEEK(XFILIAL('SE4')+ZB2->ZB2_COND))
_CPDesc := SE4->E4_DESCRI 

@ 032,070 Get _CPDesc when .f.  Size 060,8 Object oCondDesc
@ 032,140 Say "Contato: " Size 040,8 Object olContat
@ 032,180 Get ZB2->ZB2_CONTAT when .f.  Size 060,8 Object oCond

@ 032,260 Say "Filial p/ Entrega: " Size 040,8 Object olFilEnt
@ 032,335 Get ZB2->ZB2_FILENT when .f.  Size 005,8 Object oFilEnt

nMoeda    := ZB2->ZB2_MOEDA
cDescMoed := SuperGetMv("MV_MOEDA"+AllTrim(Str(nMoeda,2)))

@ 044,015 Say OemToAnsi("Moeda: ") Size 040,8 Object olCond
@ 044,045 Get alltrim(str(ZB2->ZB2_MOEDA)) when .f.  Size 020,8 Object oMoed
@ 044,070 Get cDescMoed when .f.  Size 060,8 Object oDescMoed

@ 044,140 Say "Transportadora: " Size 040,8 Object olTransp
@ 044,180 Get ZB2->ZB2_TRANSP when .f.  Size 040,8 Object oTransp

@ 044,260 Say OemToAnsi("Data Revisão: ") Size 040,8 Object olRev
@ 044,295 Get ZB2->ZB2_DATARE when .f.  Size 040,8 Object oDataRev
@ 044,335 Get ZB2->ZB2_NUMREV when .f.  Size 005,8 Object oNumRev

@ 065,10 LISTBOX oLbx FIELDS HEADER ;
   "Item", "Produto", "Descricao","Quantidade","Unidade","Dt. Inicial","Dt. Final", ;
   "Prc Unitario","Sigla","Vlr. Total","Aliq. IPI","Almoxarifado","Observacoes",;
   "Num. Solicita","Item Solicit","Transportado","Cond. Entrega","Num Revisao","C.Custo",;
   "Data Revisao","Grupo Aprov.","Conta","Grade","Item Grade","Segunda UM","Qtd. 2a UM";
   SIZE 350,120 OF oDlgHis PIXEL 

_cNum := ZB2->ZB2_NUM  
_cRev := ZB2->ZB2_NUMREV

_nRec := ZB2->(RecNo())

ZB2->(DBSETORDER(1))
ZB2->(DBSEEK(XFILIAL('ZB2')+_cNum))

While ZB2->(!EOF()) .AND. ZB2->ZB2_NUM == _cNum .AND. ZB2->ZB2_NUMREV == _cRev
 		aAdd(_aItem, {ZB2->ZB2_ITEM,;
	              ZB2->ZB2_PRODUT,;
                  ZB2->ZB2_DESCRI,;
                  ZB2->ZB2_QUANT,;
                  ZB2->ZB2_UM,;
                  ZB2->ZB2_DATPRI,;
                  ZB2->ZB2_DATPRF,;
                  ZB2->ZB2_PRECO,;
                  ZB2->ZB2_SIGLA,;
                  ZB2->ZB2_TOTAL,;
                  ZB2->ZB2_IPI,;
                  ZB2->ZB2_LOCAL,;
                  ZB2->ZB2_MSG,;
                  ZB2->ZB2_NUMSC,;
                  ZB2->ZB2_ITEMSC,;
                  ZB2->ZB2_TRANSP,;
                  ZB2->ZB2_ENTREG,;
                  ZB2->ZB2_NUMREV,;
                  ZB2->ZB2_CC,;
                  ZB2->ZB2_DATARE,;
                  ZB2->ZB2_APROV,;
                  ZB2->ZB2_CONTA,;
                  ZB2->ZB2_GRADE,;
                  ZB2->ZB2_ITEMGR,;
                  ZB2->ZB2_SEGUM,;
                  ZB2->ZB2_QTSEGU})

	ZB2->(DbSkip())
enddo
oLbx:SetArray( _aItem )

ZB2->(DbGoTo(_nRec))

oLbx:bLine := {|| {_aItem[oLbx:nAt,1],;  // ZB2->ZB2_ITEM
	               _aItem[oLbx:nAt,2],;  // ZB2->ZB2_PRODUT
	               _aItem[oLbx:nAt,3],;  // ZB2->ZB2_DESCRI
                   _aItem[oLbx:nAt,4],;  // ZB2->ZB2_QUANT
                   _aItem[oLbx:nAt,5],;  // ZB2->ZB2_UM
                   _aItem[oLbx:nAt,6],;  // ZB2->ZB2_DATPRI
                   _aItem[oLbx:nAt,7],;  // ZB2->ZB2_DATPRF
                   _aItem[oLbx:nAt,8],;  // ZB2->ZB2_PRECO
                   _aItem[oLbx:nAt,9],;  // ZB2->ZB2_SIGLA
                   _aItem[oLbx:nAt,10],; // ZB2->ZB2_TOTAL
                   _aItem[oLbx:nAt,11],; // ZB2->ZB2_IPI
                   _aItem[oLbx:nAt,12],; // ZB2->ZB2_LOCAL
                   _aItem[oLbx:nAt,13],; // ZB2->ZB2_MSG
                   _aItem[oLbx:nAt,14],; // ZB2->ZB2_NUMSC
                   _aItem[oLbx:nAt,15],; // ZB2->ZB2_ITEMSC
                   _aItem[oLbx:nAt,16],; // ZB2->ZB2_TRANSP
                   _aItem[oLbx:nAt,17],; // ZB2->ZB2_ENTREG
                   _aItem[oLbx:nAt,18],; // ZB2->ZB2_NUMREV
                   _aItem[oLbx:nAt,19],; // ZB2->ZB2_CC
                   _aItem[oLbx:nAt,20],; // ZB2->ZB2_DATARE
                   _aItem[oLbx:nAt,21],; // ZB2->ZB2_APROV
                   _aItem[oLbx:nAt,22],; // ZB2->ZB2_CONTA
                   _aItem[oLbx:nAt,23],; // ZB2->ZB2_GRADE
                   _aItem[oLbx:nAt,24],; // ZB2->ZB2_ITEMGR
                   _aItem[oLbx:nAt,25],; // ZB2->ZB2_SEGUM
                   _aItem[oLbx:nAt,26]}} // ZB2->ZB2_QTSEGU
                   
oLbx:Refresh()                   

ACTIVATE MSDIALOG oDlgHis ON INIT EnchoiceBar(oDlgHis,{||oDlgHis:End(),.T.},{||oDlgHis:End()})

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA REVISAO DO PEDIDO EM ABERTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
User Function COM61Rev()
Local _nRev   := 1
Local _cNum   := SC3->C3_NUM
Local _aPedAb := {}

If !MsgYesNo("Deseja gerar uma revisão?")
	Return
EndIf
		
//Numero da Revisao
If !empty(SC3->C3_NUMREV)
	_nRev := VAL(SC3->C3_NUMREV) + 1
endif

nSC3Rec := SC3->(Recno()) //guarda a posicao do sc3
                          
SC3->(DbSetOrder(1)) //filial + num + item

//Grava histórico de Pedido Aberto
SC3->(DbSeek(xFilial("SC3")+_cNum))

While SC3->(!EOF()) .AND. SC3->C3_NUM==_cNum

	RecLock("ZB2",.T.) 
	
		ZB2->ZB2_FILIAL 	 := SC3->C3_FILIAL
		ZB2->ZB2_NUM    	 := SC3->C3_NUM
		ZB2->ZB2_FORNEC      := SC3->C3_FORNECE
		ZB2->ZB2_LOJA        := SC3->C3_LOJA
		ZB2->ZB2_ITEM        := SC3->C3_ITEM
		ZB2->ZB2_PRODUT      := SC3->C3_PRODUTO
		ZB2->ZB2_DESCRI      := SC3->C3_DESCRI
		ZB2->ZB2_QUANT       := SC3->C3_QUANT
		ZB2->ZB2_UM          := SC3->C3_UM
		ZB2->ZB2_DATPRI      := SC3->C3_DATPRI
		ZB2->ZB2_DATPRF      := SC3->C3_DATPRF
		ZB2->ZB2_PRECO       := SC3->C3_PRECO
		ZB2->ZB2_SIGLA       := SC3->C3_SIGLA
		ZB2->ZB2_COND        := SC3->C3_COND
		ZB2->ZB2_CONTAT      := SC3->C3_CONTATO
		ZB2->ZB2_FILENT      := SC3->C3_FILENT
		ZB2->ZB2_EMISSA      := SC3->C3_EMISSAO
		ZB2->ZB2_TOTAL       := SC3->C3_TOTAL
		ZB2->ZB2_IPI         := SC3->C3_IPI
		ZB2->ZB2_LOCAL       := SC3->C3_LOCAL
		ZB2->ZB2_RESIDU      := SC3->C3_RESIDUO
		ZB2->ZB2_MSG         := SC3->C3_MSG
		ZB2->ZB2_ENCER       := SC3->C3_ENCER
		ZB2->ZB2_FRETE       := SC3->C3_FRETE
		ZB2->ZB2_EMITID      := SC3->C3_EMITIDO
	    ZB2->ZB2_OK          := SC3->C3_OK
		ZB2->ZB2_OBS         := SC3->C3_OBS
		ZB2->ZB2_QUJE        := SC3->C3_QUJE
		ZB2->ZB2_REAJUS      := SC3->C3_REAJUST
		ZB2->ZB2_TPFRET      := SC3->C3_TPFRETE
		ZB2->ZB2_MOEDA       := SC3->C3_MOEDA
		ZB2->ZB2_VALFRE      := SC3->C3_VALFRE
		ZB2->ZB2_NUMSC       := SC3->C3_NUMSC
		ZB2->ZB2_ITEMSC      := SC3->C3_ITEMSC
		ZB2->ZB2_TRANSP      := SC3->C3_TRANSP
		ZB2->ZB2_ENTREG      := SC3->C3_ENTREGA
		ZB2->ZB2_NUMREV      := SC3->C3_NUMREV
		ZB2->ZB2_TXMOED      := SC3->C3_TXMOEDA
		ZB2->ZB2_CC          := SC3->C3_CC
		ZB2->ZB2_DATARE      := SC3->C3_DATAREV
		ZB2->ZB2_USER        := SC3->C3_USER
		ZB2->ZB2_APROV       := SC3->C3_APROV
		ZB2->ZB2_GRUPCO      := SC3->C3_GRUPCOM
		ZB2->ZB2_CONAPR      := SC3->C3_CONAPRO
		ZB2->ZB2_CONTA       := SC3->C3_CONTA
		ZB2->ZB2_GRADE       := SC3->C3_GRADE
		ZB2->ZB2_ITEMGR      := SC3->C3_ITEMGRD
		ZB2->ZB2_SEGUM       := SC3->C3_SEGUM
		ZB2->ZB2_AVISTA      := SC3->C3_AVISTA
		ZB2->ZB2_QTSEGU      := SC3->C3_QTSEGUM
		ZB2->ZB2_QTIMP       := SC3->C3_QTIMP
		
	MsUnLock("ZB2")
	 
	RecLock("SC3",.F.)
		If (SC3->C3_QUANT - SC3->C3_QUJE) > 0
			SC3->C3_QUANT -= SC3->C3_QUJE
			SC3->C3_QUJE  := 0
		EndIf
		
		SC3->C3_TOTAL   := SC3->C3_QUANT * SC3->C3_PRECO
		SC3->C3_NUMREV  := STRZERO(_nRev,2)
		SC3->C3_DATAREV := Date()
	MsUnLock("SC3")
	
	SC3->(dbSkip())

ENDDO

MsgBox("Revisão gerada com sucesso!","Revisao gerada","INFO")

SC3->(dbGoTo(nSC3Rec)) // retorna a posicao do sc3

Return 

*/