#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

/*                                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NMNT028  ³ Autor ³ João Felipe da Rosa    Data ³ 01/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ APROVA E GERA PRE-REQUISICOES DE MATERIAIS DE MANUTENCAO   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Preset	                                              	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT028() 

SetPrvt("CCADASTRO,AROTINA,_cFer,_cFerDesc,_cPeca,_cPcDesc,_cParam,_cData,_cCC,_cPar")

_cFiltro := "SCP->CP_ORDEM <> ' '"

cCadastro := OemToAnsi("Aprovação de Insumos")
aRotina := {{ "Pesquisa"		,"AxPesqui"     , 0 , 1},;
			{ "Visualiza"		,"AxVisual"     , 0 , 2},;
            { "Aprovação"		,'U_fINSUM()'   , 0 , 3}}

DbSelectArea("SCP")

Set Filter To &(_cFiltro)

mBrowse( 6, 1,22,75,"SCP",,,,,,DebCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

USER Function fINSUM()                                           

_cProd  := SCP->CP_PRODUTO
_cPDesc := SCP->CP_DESCRI
_cCC    := SCP->CP_CC
_cOs    := SCP->CP_ORDEM
_nQuant := SCP->CP_QUANT

	//Verifica se já está encerrada
	If SCP->CP_STATUS == 'E'
		MsgBox("Requisicao ja baixada no estoque","Encerrada","STOP")
		Return
	EndIf

	DEFINE FONT oFont NAME "Arial" SIZE 12, -12

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CONSTRÓI A TELA DE APROVACAO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Define MsDialog oDialog Title OemToAnsi("Gera Pre-Requisicao de Insumos") From 000,000 To 160,440 Pixel 
	
	@ 010,005 Say "O.S.: " Size 40,8 Object olResp
	@ 010,040 Get _cOs Picture "@!" When .F. Size 40,8 Object oOs

	@ 025,005 Say "Produto: " Size 060,8 Object olFer
	@ 025,040 Get _cProd  Picture "@!" When .F. Size 70,8 Object oProd
	@ 025,115 Get _cPDesc Picture "@!" When .F. Size 100,8 Object oProDesc
	
	@ 040,005 Say "C.Custo: " Size 040,8 Object olCC
	@ 040,040 Get _cCC Picture "@!" When .F.  Size 40,8 Object oCC
	
	@ 040,100 Say "Qtde: " Size 040,8 Object olCC
	@ 040,115 Get _nQuant Picture "@e 99999" When .F. Size 40,8 Object oQtd

    @ 060,105 BUTTON "_Aprovar" SIZE 30,15 ACTION fOk()  OBJECT OOK
    @ 060,145 BUTTON "_Rejeitar" SIZE 30,15 ACTION fEnd() OBJECT OREJ
	@ 060,185 BUTTON "_Cancelar" SIZE 30,15 ACTION Close(oDialog) OBJECT OCANC
	Activate MsDialog oDialog Center
                                                 
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida a baixa da Ferramenta ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fValBaixa()
Local _cMsgOS := "" 
Local _CPRec

	//Pega o nome do usuario que esta logado no sistema
	If !Upper(Alltrim(cUserName))$"CLAUDIOSA/JOAOFR/VILSONJ/ALTEVIRMS"
		ALERT("USUARIO SEM PERMISSAO")
		RETURN .F.
	EndIf
	
	If SCP->CP_QUANT == 0
		MsgBox("Solicitacao possui saldo zerado.","Saldo Zerado","STOP")
		Return .F.
	EndIf
	
	If SCP->CP_QUANT < _nQuant
		MsgBox("Quantidade insuficiente para baixa.","Insuficiente","STOP")
		Return .F.
	EndIf
	
	If _nQuant <= 0
		MsgBox(OemToAnsi("Quantidade inválida para baixa."),OemToAnsi("Inválida"),"STOP")
	EndIf
	
	If Len(AllTrim(_cCC)) <> 6
		MsgBox(OemToAnsi("Centro de Custo deve ter 6 dígitos. Verifique no cadastro da Peça."),"C.Custo Invalido","ALERT")	
		Return .F.
	ElseIf Empty(_cCC)
		MsgBox(OemToAnsi("Centro de Custo não pode ser branco. Verifique no cadastro da Peça."),"C.Custo Invalido","ALERT")	
		Return .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SALDO NO SB2³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_CPRec := SCP->(Recno())
	_cOrd  := SCP->CP_ORDEM
	
	DbSelectArea("SB2")
	DbSetORder(1)//B2_FILIAL+B2_COD+B2_LOCAL
	
	SCP->(DbSetOrder(2)) //CP_FILIAL+CP_PRODUTO+CP_NUM+CP_ITEM
	
	If DbSeek(xFilial("SB2")+_cProd)
		//Quantidade - Quantidade Empenhada
		If SB2->B2_QATU - (SB2->B2_QEMP - _nQuant) < _nQuant
			
			MsgBox("Produto "+ALLTRIM(_cProd)+" com saldo insuficiente."+ chr(13) + chr(10);
				   +"Não será possível aprovar até que tenha saldo.","Sem Saldo","STOP")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ AVISA QUAL ORDEM ESTÁ USANDO ESTE INSUMO, SE NÃO ESTIVER ENCERRADA³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cQuery := "SELECT CP_ORDEM FROM "+RetSqlName("SCP")
			cQuery += " WHERE CP_PRODUTO = '"+_cProd+"'"
			cQuery += " AND CP_ORDEM <> '"+_cOrd+"'"
			cQuery += " AND CP_STATUS <> 'E'"
			cQuery += " AND D_E_L_E_T_ = '' AND CP_FILIAL = '"+xFilial('SCP')+"'"
			
			TCQUERY cQuery NEW ALIAS "TMP"
			
			TMP->(DBGOTOP())
			
			WHILE TMP->(!EOF())
				
				_cMsgOs += "Existe uma solic. deste produto para O.S.: "+TMP->CP_ORDEM + chr(13) + chr(10)
			
				TMP->(DBSKIP())
			
			ENDDO
			
			TMP->(DBCLOSEAREA())			
			
			//se tiver O.S.			
			If _cMsgOS <> ""
				MsgBox(_cMsgOS,"Ordem de Servico","INFO")
			EndIf
	       
			Return .F. //Nao deixa aprovar
		EndIf
	Else
		Alert("Erro")
	EndIf
	
	SCP->(DBGOTO(_CPRec))
	
Return.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rejeita a Requisicao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fEnd()

    If MsgYesNo("Tem certeza que deseja excluir a solicitacao e o insumo da O.S.?")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REMOVE DO B2 A QUANTIDADE EMPENHADA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IF SCP->CP_PREREQU == 'S'
			
			DbSelectArea("SB2")
			DbSetORder(1)//B2_FILIAL+B2_COD+B2_LOCAL
		     
			
			If DbSeek(xFilial("SB2")+SCP->CP_PRODUTO)
				If SB2->B2_QEMP >= SCP->CP_QUANT
					RecLock("SB2",.F.)
						SB2->B2_QEMP -= SCP->CP_QUANT
					MsUnLock("SB2")
				EndIf		
	
				If SB2->B2_QEMPSA >= SCP->CP_QUANT
					RecLock("SB2",.F.)
						SB2->B2_QEMPSA -= SCP->CP_QUANT
					MsUnLock("SB2")
				EndIf		 
			EndIf
	
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REMOVE O INSUMO DA O.S.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		STL->(DbSetOrder(1))//TL_FILIAL+TL_ORDEM+TL_PLANO+TL_TAREFA+TL_TIPOREG+TL_CODIGO+TL_SEQRELA
		IF STL->(DBSEEK(XFILIAL("STL")+SCP->CP_ORDEM))
		    
			WHILE STL->(!EOF()) .AND. STL->TL_ORDEM == SCP->CP_ORDEM
				IF STL->TL_CODIGO == SCP->CP_PRODUTO
					RecLock("STL",.F.)
						STL->(DbDelete())
					MsUnLock("STL")			
			    ENDIF 
				STL->(DBSKIP())
			ENDDO
		ENDIF
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REMOVE SOLICITACAO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
		RecLock("SCP",.F.)
			SCP->(DbDelete())
		MsUnLock("SCP")

	EndIf

	Close(oDialog)
	
Return          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONFIRMA DADOS DA REQUISICAO              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fOk()

//Local _nRec   := SCP->(RecNo())
Local _cItem  := SCP->CP_ITEM //"01"
Local _cPNum  := SCP->CP_NUM
Local _cUni   := SCP->CP_UM
Local _cDTprf := SCP->CP_DATPRF
Local _cLocal := SCP->CP_LOCAL
Local _cConta := SCP->CP_CONTA
Local _cEmiss := SCP->CP_EMISSAO	
Local _cSegun := SCP->CP_SEGUM
Local _cQtSeg := SCP->CP_QTSEGUM
Local _cRespNome := SCP->CP_SOLICIT   

If !fValBaixa()
	Return
EndIf

/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pega o número do ítem da pre-requisição a ser gerada ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SCP")
	Set Filter To //Remove o filtro na SCP
	DbSetOrder(1) //FILIAL + NUM + ITEM + SEQ
	If DbSeek(xFilial("SCP")+_cPNum)
		While _cPNum == SCP->CP_NUM
			_cItem := StrZero(Val(SCP->CP_ITEM)+1,2)
			DbSkip()
		EndDo
	EndIf	 
	
	DbGoTo(_nRec) //Volta o registro onde estava


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Descrementa do SCP a quantidade que foi gerada pré-requisicao ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/	
	RecLock("SCP",.F.)
//		SCP->CP_QUANT -= _nQuant
//		If SCP->CP_QUANT == 0
//			SCP->CP_STATUS  := "E"
		    SCP->CP_PREREQU := "S"   
	    	SCP->CP_SOLICIT := _cRespNome 
//		EndIf
	MsUnLock("SCP")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Pre-Requisicao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
	DbSelectArea("SCQ")
	RecLock("SCQ",.T.)
		SCQ->CQ_FILIAL  := xFilial("SCQ")
		SCQ->CQ_NUM     := SCP->CP_NUM
		SCQ->CQ_ITEM    := _cItem
		SCQ->CQ_PRODUTO := SCP->CP_PRODUTO
		SCQ->CQ_DESCRI  := SCP->CP_DESCRI
		SCQ->CQ_LOCAL   := SCP->CP_LOCAL
		SCQ->CQ_UM      := SCP->CP_UM
		SCQ->CQ_QUANT   := _nQuant
		SCQ->CQ_QTSEGUM := SCP->CP_QTSEGUM
		SCQ->CQ_SEGUM   := SCP->CP_SEGUM
		SCQ->CQ_NUMSQ   := "01"
   		SCQ->CQ_ITSC    := SCP->CP_ITSC
		SCQ->CQ_NUMSC   := SCP->CP_NUMSC
		SCQ->CQ_DATPRF  := SCP->CP_DATPRF
		SCQ->CQ_CC      := _cCC
		SCQ->CQ_CONTA   := SCP->CP_CONTA
	 	SCQ->CQ_ITEMCTA := SCP->CP_ITEMCTA
 	 	SCQ->CQ_CLVL    := SCP->CP_CLVL
 		SCQ->CQ_PECA    := _cPeca
	MsUnLock("SCQ") 

	RecLock("SCP",.T.)
		SCP->CP_FILIAL  := xFilial("SCQ")
		SCP->CP_NUM     := _cPNum
		SCP->CP_ITEM    := _cItem
		SCP->CP_PRODUTO := _cProd
		SCP->CP_DESCRI  := _cPDesc
		SCP->CP_UM      := _cUni
		SCP->CP_QUANT   := _nQuant
		SCP->CP_CC      := _cCC
		SCP->CP_DATPRF  := _cDTprf
		SCP->CP_LOCAL   := _cLocal
		SCP->CP_CONTA   := _cConta
		SCP->CP_EMISSAO := _cEmiss
		SCP->CP_SOLICIT := _cRespNome
		SCP->CP_SEGUM   := _cSegun
		SCP->CP_QTSEGUM := _cQtSeg
		SCP->CP_PREREQU := "S"
// 		SCP->CP_PECA    := _cPeca
	MsUnLock("SCQ")
*/	
	Set Filter To &(_cFiltro) //retorna o filtro retirado acima
	Close(oDialog)
	
	DbSelectArea("SB2")
	DBSETORDER(1)
	DBSEEK(XFILIAL('SB2')+_cProd)
	RecLock("SB2",.F.)
		SB2->B2_QEMPSA += _nQuant
		SB2->B2_QEMP   += _nQuant
	MsUnLock("SB2")
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Legendas	                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                             

Static Function DebCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"  },;
  					  {"BR_VERMELHO" , "Aprovado"  }}

Local uRetorno := {}
Aadd(uRetorno, { 'CP_PREREQU = " " ' , aLegenda[1][1] })
Aadd(uRetorno, { 'CP_PREREQU = "S" ' , aLegenda[2][1] })

Return(uRetorno)   

User Function M185CAMP()
Local cCampo   := PARAMIXB[1]  //-- Nome do campo que esta sendo processado
Local z        := PARAMIXB[2]  //-- Numero da linha posicionada no aCols
Local nX       := PARAMIXB[3]  //-- Dimensão de posição do array A185Dados ('Array onde esta os movimentos a serem gerados')
Local i        := PARAMIXB[4]  //-- Dimensão do campo dentro do aCols.

If cCampo$"D3_ORDEM" 
	aCols[z][i] := SCP->CP_ORDEM
EndIf

Return Nil 

