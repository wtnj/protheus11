
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT048  ºAutor  ³João Felipe da Rosa º Data ³  02/12/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ALTERA INSUMOS DO PLANO DE LUBRIFICACAO                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "topconn.ch"
#include "protheus.ch"
#include "colors.ch"

User function NHMNT048()

Private aRotina, cCadastro

cCadastro := "Plano de Lubrificacao"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"      , 0 , 1})
aAdd(aRotina,{ ""			    ,""			 	 , 0 , 2})
aAdd(aRotina,{ ""			    ,""			 	 , 0 , 3})
aAdd(aRotina,{ "Quantidade"     ,"U_MNT48()"     , 0 , 4})
aAdd(aRotina,{ ""			    ,""			 	 , 0 , 5})

mBrowse(6,1,22,75,"STI",,,,,,fCriaCor())

Return

User function MNT48()
Local   aPergs := {}
Private oRelato

	oRelato       := Relatorio():New()
    oRelato:cPerg := "MNT048"

	aAdd(aPergs,{"Do  Plano ?"      ,"C",06,0,"G","","","","","","STI",""}) //mv_par01
	aAdd(aPergs,{"Ate Plano ?"      ,"C",06,0,"G","","","","","","STI",""}) //mv_par02
	aAdd(aPergs,{"De  Data ?"       ,"D",08,0,"G","","","","","","","99/99/9999"}) //mv_par03
	aAdd(aPergs,{"Ate Data ?"       ,"D",08,0,"G","","","","","","","99/99/9999"}) //mv_par04
	aAdd(aPergs,{"De  C.Custo ?"    ,"C",06,0,"G","","","","","","CTT",""}) //mv_par05
	aAdd(aPergs,{"Ate C.Custo ?"    ,"C",06,0,"G","","","","","","CTT",""}) //mv_par06
	aAdd(aPergs,{"De  Bem ?"        ,"C",15,0,"G","","","","","","ST9",""}) //mv_par07
	aAdd(aPergs,{"Ate Bem ?"        ,"C",15,0,"G","","","","","","ST9",""}) //mv_par08
	aAdd(aPergs,{"De  C.Trabalho ?" ,"C",06,0,"G","","","","","","SHB",""}) //mv_par09
	aAdd(aPergs,{"Ate C.Trabalho ?" ,"C",06,0,"G","","","","","","SHB",""}) //mv_par10	

	oRelato:AjustaSx1(aPergs)
	
	If !Pergunte("MNT048",.T.)
		Return
	EndIf
	
	Processa({||Gera()},"Gerando dados...")
    fTela()
	
	If Select("TRA1") > 0 
		TRA1->(dbCloseArea())
	EndIf
    
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA OS DADOS QUE IRAO APARECER NO GRID ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gera()
Local cQuery

	cQuery := " SELECT TL.TL_PLANO, TL.TL_ORDEM, TJ.TJ_CODBEM, TJ.TJ_CCUSTO, TL.TL_CODIGO, TL.TL_QUANTID "
	cQuery += " FROM "+RetSqlName("STL")+" TL, "+RetSqlName("STJ")+" TJ, "+RetSqlName("STI")+" TI"
	cQuery += " WHERE TL.TL_ORDEM = TJ.TJ_ORDEM "
	cQuery += " AND TI.TI_PLANO = TL.TL_PLANO "
	cQuery += " AND TI.TI_TERMINO = 'N'"
	cQuery += " AND TI.TI_SITUACA = 'L'"
	cQuery += " AND TL.TL_TIPOREG = 'P'"
	cQuery += " AND TL.TL_PLANO   BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND TI.TI_DATAPLA BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
	cQuery += " AND TJ.TJ_CCUSTO  BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND TJ.TJ_CODBEM  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND TJ.TJ_CENTRAB BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cQuery += " AND TI.TI_FILIAL = '"+xFilial("STI")+"' AND TI.D_E_L_E_T_ = ''"
	cQuery += " AND TL.TL_FILIAL = '"+xFilial("STL")+"' AND TL.D_E_L_E_T_ = ''"
	cQuery += " AND TJ.TJ_FILIAL = '"+xFilial("STJ")+"' AND TJ.D_E_L_E_T_ = ''"
	cQuery += " ORDER BY TL.TL_PLANO, TL.TL_ORDEM "
	
	TCQUERY cQuery NEW ALIAS "TRA1"

Return

//ÚÄÄÄÄÄÄ¿
//³ TELA ³
//ÀÄÄÄÄÄÄÙ
Static Function fTela()
Local bOk        := {||Processa({||fGrv()},"Atualizando saldos...")}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Local aButtons   := {}
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)
Private aCols    := {}
Private aHeader  := {}

	aAdd(aHeader,{"Plano"     , "TL_PLANO"    , PesqPict("STL","TL_PLANO")   , 06,00, ".F."           ,"","C","STL"}) // 1
	aAdd(aHeader,{"Ordem"     , "TL_ORDEM"    , PesqPict("STL","TL_ORDEM")   , 06,00, ".F."           ,"","C","STL"}) // 1
	aAdd(aHeader,{"Bem"       , "TJ_CODBEM"   , PesqPict("STJ","TJ_CODBEM")  , 15,00, ".F."           ,"","C","STJ"}) // 2
	aAdd(aHeader,{"C.Custo"   , "TJ_CCUSTO"   , PesqPict("STJ","TJ_CCUSTO")  , 09,00, ".F."           ,"","C","STJ"}) // 3
	aAdd(aHeader,{"Produto"   , "TL_CODIGO"   , PesqPict("STL","TL_CODIGO")  , 15,00, ".F."           ,"","C","STL"}) // 4
	aAdd(aHeader,{"Qtd Prev." , "TL_QUANTID"  , PesqPict("STL","TL_QUANTID") , 09,02, ".F."           ,"","N","STL"}) // 5
	aAdd(aHeader,{"Qtd Real"  , "TL_QUANTID"  , PesqPict("STL","TL_QUANTID") , 09,02, ".T."           ,"","N","STL"}) // 6
	
	aAdd(aButtons,{"S4WB010N",{||Processa({||fImp()},"Imprimindo... Aguarde")},"Imprime relação de insumos e quantidades","Imprime"})

				
	While TRA1->(!EOF())
		aAdd(aCols,{TRA1->TL_PLANO,;
			 TRA1->TL_ORDEM,;
		     TRA1->TJ_CODBEM,;
		     TRA1->TJ_CCUSTO,;
		     TRA1->TL_CODIGO,;
		     TRA1->TL_QUANTID,;
		     0,.F.})
	
		TRA1->(dbSkip())
	EndDo
	
	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,aButtons)}
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Insumos",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

    // cria o getDados
	oGeTD := MsGetDados():New( 20                 ,; //superior
	                           aPosObj[2,2]       ,; //esquerda
	                           aPosObj[2,3]       ,; //inferior
	                           aPosObj[2,4]       ,; //direita
	                           4                  ,; // nOpc
	                           "AllwaysTrue"      ,; // CLINHAOK
	                           "AllwaysTrue"      ,; // CTUDOOK
	                           ""                 ,; // CINICPOS
	                           .T.                ,; // LDELETA
	                           nil                ,; // aAlter
	                           nil                ,; // uPar1
	                           .F.                ,; // LEMPTY
	                           200                ,; // nMax
	                           nil                ,; // cCampoOk
	                           "AllwaysTrue()"    ,; // CSUPERDEL
	                           nil                ,; // uPar2
	                           "AllwaysTrue()"    ,; // CDELOK
	                           oDlg                ; // oWnd
	                          )

	oGetD:nMax := len(aCols) //nao deixa adicionar mais uma linha no acols
	
	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
	
Return

Static Function fImp()

	oRelato:cString  := ""
    oRelato:cPerg    := ""
	oRelato:cNomePrg := "NHMNT048"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Apresenta os insumos do plano"
	oRelato:cDesc2   := ""
	oRelato:cDesc3   := ""
	
	//tamanho
	oRelato:cTamanho := "M"  //default "M"

	//titulo
	oRelato:cTitulo  := "INSUMOS DO PLANO DE LUBRIFICACAO"

	//cabecalho
	oRelato:cCabec1  := " Plano   Ordem   Bem              C.Custo    Insumo           Descrição                           Quant. Prev      Quant. Real"

	oRelato:Run({||Imprime()})


Return

Static Function Imprime()

 	oRelato:Cabec()     
 	
	ST9->(dbSetOrder(1))
	SB1->(dbSetOrder(1))
	CTT->(dbSetOrder(1))
 	
	For x:=1 to Len(aCols)
		
		If Prow() > 65
			oRelato:Cabec()
		EndIf

		@Prow() +1, 001 psay aCols[x][1]
		@Prow()   , 009 psay aCols[x][2]

		@Prow()   , 017 psay aCols[x][3]
//		ST9->(dbSeek(xFilial("ST9")+aCols[x][3]))
//   	@Prow()   , 034 psay Substr(ST9->T9_NOME,1,20)
		
//		CTT->(dbSeek(xFilial("CTT")+AllTrim(aCols[x][5])))
//		@Prow()   , 083 psay Substr(CTT->CTT_DESC01,1,20)
		
		@Prow()   , 035 psay aCols[x][4] //C.CUSTO

		@Prow()   , 045 psay aCols[x][5] //INSUMO
		SB1->(dbSeek(xFilial("SB1")+AllTrim(aCols[x][5])))
		@Prow()   , 062	psay Substr(SB1->B1_DESC,1,35)

		@Prow()   , 094 psay aCols[x][6] Picture "@e 999999999.99"
		@Prow()   , 115 psay "____________"
	
	Next	

Return

Static Function fGrv()
Local cLocal  := ""
	
	ProcRegua(len(aCols)) 

 	STL->(dbSetOrder(4)) //TL_FILIAL+TL_ORDEM+TL_PLANO+TL_TIPOREG+TL_CODIGO
 	SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
 	SD4->(dbSetOrder(1)) //D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE

	/**
	 * percorre todos as linhas do acols
	 */
	For x:=1 to Len(aCols)
	
		IncProc()
		cLocal  := ""
		
		/**
		 * atualiza o empenho na tabela de insumos de manutencao
		 */
		If STL->(dbSeek(xFilial("STL")+aCols[x][2]+aCols[x][1]+"P"+aCols[x][5]))

			//guarda o local do insumo para dar um seek na tabela SB2
			cLocal := STL->TL_LOCAL

			//grava a nova quantidade
			//utiliza a funcao NGCALCUSTI para calcular o custo da
			//nova quantidade de insumo
			RecLock("STL",.F.)
				STL->TL_QUANTID := aCols[x][7] 
			    STL->TL_CUSTO   := NGCALCUSTI(stl->tl_codigo,stl->tl_tiporeg,;
			                                aCols[x][7],stl->tl_local,stl->tl_tipohor)
			MsUnLock("STL")
			
			/**
			 * atualiza o saldo empenhado na tabela de saldos
			 */
			If SB2->(dbSeek(xFilial("SB2")+aCols[x][5]+cLocal))
			
				//calcula a nova quantidade empenhada no SB2
				//QEMP - (QANTERIOR - QATUAL)
				//trata o valor, caso por algum motivo venha a ficar com saldo menor que zero
				nNewQEMP := SB2->B2_QEMP - (aCols[x][6]-aCols[x][7])
				nNewQEMP := Iif(nNewQEMP<0,0,nNewQEMP)

				RecLock("SB2",.F.)
					SB2->B2_QEMP := nNewQEMP
			    MsUnlock("SB2")
			EndIf
			
			/**
			 * atualiza a tabela de empenhos 
			 */
			If SD4->(dbSeek(xFilial("SD4")+aCols[x][5]+aCols[x][2]))
			
				//calcula a nova quantidade no SD4
				//trata o valor, caso por algum motivo venha a ficar com saldo menor que zero
				nNewQEMP := SD4->D4_QUANT - (aCols[x][6]-aCols[x][7])
				nNewQEMP := Iif(nNewQEMP<0,0,nNewQEMP)
				
				RecLock("SD4",.F.)
					SD4->D4_QUANT := nNewQEMP
				MsUnLock("SD4")
			EndIf			

		EndIf
	Next
	
	oDlg:End()
Return