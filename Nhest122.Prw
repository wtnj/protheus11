/*                                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST122  ³ Autor ³ João Felipe da Rosa    Data ³ 01/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Baixa de ferramentas por peça                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Preset	                                              	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"

User Function nhest122() 

//AXCADASTRO("ZAS")

SetPrvt("CCADASTRO,AROTINA,_cFer,_cFerDesc,_cPeca,_cPcDesc,_cParam,_cData,_cCC,_cPar")

_cFiltro := "SCP->CP_STATUS <> 'E' .AND. Substr(SCP->CP_PRODUTO,1,2) == 'FE' .AND. '305004'$SCP->CP_CC" 

cCadastro := OemToAnsi("Baixa de Ferramentas x Peça")
aRotina := {{ "Pesquisa"		,"AxPesqui"     , 0 , 1},;
            { "Gerar"			,'U_fEST119(1)' , 0 , 2}}

DbSelectArea("SCP")

Set Filter To &(_cFiltro)

mBrowse( 6, 1,22,75,"SCP",,,,,,DebCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function fEST119(_cPar)

_cData	    := Date()
_cHora	    := Time()
_cCC	    := Space(6)
_cPeca	    := Space(15)
_cParam 	:= _cPar
aCols		:= {}
_cCod       := SCP->CP_NUM
_cFer 	    := SCP->CP_PRODUTO
_cFerDesc   := SCP->CP_DESCRI
_nQuant     := 0
_cResp	    := Space(6)
_cRespNome  := ""
_cSolic	    := Space(6)
_cSolicNome  := ""



DEFINE FONT oFont NAME "Arial" SIZE 12, -12

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONSTRÓI A TELA              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Define MsDialog oDialog Title OemToAnsi("Gera Pre-Requisicao de Ferramentas") From 000,000 To 230,440 Pixel 
	
	@ 010,005 Say "Ferramenta: " Size 060,8 Object olFer
	@ 010,040 Get _cFer     Picture "@!" When .F. Size 70,8 Object oFer
	@ 010,115 Get _cFerDesc Picture "@!" When .F. Size 100,8 Object oFerDesc
	
	@ 025,005 Say "Peça: " Size 040,8 Object olPeca
	@ 025,040 Get _cPeca    Picture "@!"  F3 "PA1" Size 70,8 Valid fPeca() Object olPc
	@ 025,115 Get _cPcDesc  Picture "@!" When .F. Size 100,8 Object oPcDesc

	@ 040,005 Say "C.Custo: " Size 040,8 Object olCC
	@ 040,040 Get _cCC Picture "@!" When .F. Size 40,8 Object oCC

	@ 040,155 Say "Data: " Size 040,8 Object olData
	@ 040,175 Get _cData Picture "99/99/99" When .F. Size 40,8 Object oData

	@ 055,155 Say "Hora: " Size 040,8 Object olData
	@ 055,175 Get _cHora Picture "@!" When .F. Size 40,8 Object oData
	
	@ 055,005 Say "Quant.: " Size 40,8 Object olQuant
	@ 055,040 Get _nQuant Picture "@e 99999" Size 40,8 Object oQuant
	
	@ 070,005 Say "Respons.: " Size 40,8 Object olResp
	@ 070,040 Get _cResp Picture "@!" F3 "QAA" Size 40,8 Valid fResp() Object oResp
	@ 070,095 Get _cRespNome Picture "@!" When .F. Size 120,8 Object oRespNome

	@ 085,005 Say "Solicit.: " Size 40,8 Object olSolic
	@ 085,040 Get _cSolic Picture "@!" F3 "QAA" Size 40,8 Valid fSolic() Object oSolic
	@ 085,095 Get _cSolicNome Picture "@!" When .F. Size 120,8 Object oSolicNome
	
	@ 100,155 BMPBUTTON TYPE 01 ACTION fOk()
	@ 100,185 BMPBUTTON TYPE 02 ACTION fEnd() 

	Activate MsDialog oDialog Center
                                                 
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida a baixa da Ferramenta ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fValBaixa()

	If SCP->CP_QUANT == 0
		MsgBox("Solicitacao possui saldo zerado.","Saldo Zerado","ALERT")
		Return .F.
	EndIf
	
	If SCP->CP_QUANT < _nQuant
		MsgBox("Quantidade insuficiente para baixa.","Insuficiente","ALERT")
		Return .F.
	EndIf
	
	If _nQuant < 0
		MsgBox(OemToAnsi("Impossível efetuar a baixa de quantidade inferior a zero."),"Quantidade Zerada","ALERT")	
		Return .F.
	EndIf
	
	If Len(AllTrim(_cCC)) <> 6
		MsgBox(OemToAnsi("Centro de Custo deve ter 6 dígitos. Verifique no cadastro da Peça."),"C.Custo Invalido","ALERT")	
		Return .F.
	ElseIf Empty(_cCC)
		MsgBox(OemToAnsi("Centro de Custo não pode ser branco. Verifique no cadastro da Peça."),"C.Custo Invalido","ALERT")	
		Return .F.
	EndIf
Return.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A PECA E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fPeca()

DbSelectArea("SB1")
DbSetOrder(1) //filial + cod
If DbSeek(xFilial("SB1")+_cPeca)
	If Substr(_cPeca,6,1) <> '1'
		MsgBox(OemToAnsi("Peça deve ser matéria prima."),"Peca invalida","ALERT")	
		Return .F.
	Else
		_cPcDesc := SB1->B1_DESC
		oPcDesc:Refresh()
		_cCC := SB1->B1_CC
		oCC:Refresh()
	EndIf
Else
	MsgBox("Peca nao encontrada no cadastro. Verifique!","Peca Inválida","ALERT")
	Return(.F.)
EndIf

Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA RESPONSAVEL DIGITADO E TRAZ O NOME ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fResp()

DbSelectArea("QAA")
DbSetOrder(1) //filial + mat
If DbSeek(xFilial("QAA")+_cResp)

	//pega o nome se não tiver login na QAA
	If Empty(QAA->QAA_LOGIN)
		_cRespNome := QAA->QAA_NOME
	Else
		_cRespNome := QAA->QAA_LOGIN
	EndIf
	oRespNome:Refresh()
Else
	MsgBox("Funcionario nao encontrado no cadastro. Verifique","Funcionario Invalido","ALERT")
	Return .F.
EndIf

Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA SOLICITANTE DIGITADO E TRAZ O NOME ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fSolic()

DbSelectArea("QAA")
DbSetOrder(1) //filial + mat
If DbSeek(xFilial("QAA")+_cSolic)

	//pega o nome se não tiver login na QAA
	If Empty(QAA->QAA_LOGIN)
		_cSolicNome := QAA->QAA_NOME
	Else
		_cSolicNome := QAA->QAA_LOGIN
	EndIf
	oSolicNome:Refresh()
Else
	MsgBox("Funcionario nao encontrado no cadastro. Verifique","Funcionario Invalido","ALERT")
	Return .F.
EndIf

Return(.T.)

//Encerra a janela 
Static Function fEnd()

	Close(oDialog)

Return          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONFIRMA DADOS DA REQUISICAO              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fOk()

Local _nRec   := SCP->(RecNo())
Local _cItem  := "01"
Local _cPNum  := SCP->CP_NUM
Local _cUni   := SCP->CP_UM
Local _cDTprf := SCP->CP_DATPRF
Local _cLocal := SCP->CP_LOCAL
Local _cConta := SCP->CP_CONTA
Local _cEmiss := SCP->CP_EMISSAO	
Local _cSegun := SCP->CP_SEGUM
Local _cQtSeg := SCP->CP_QTSEGUM   

If !fValBaixa()
	Return
EndIf

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
	
	RecLock("SCP",.F.)
		SCP->CP_QUANT -= _nQuant
		If SCP->CP_QUANT == 0
			SCP->CP_STATUS  := "E"
		    SCP->CP_PREREQU := "S"   
	    	SCP->CP_SOLICIT := _cRespNome 
		EndIf
	MsUnLock("SCP")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Pre-Requisicao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
		SCP->CP_PRODUTO := _cFer
		SCP->CP_DESCRI  := _cFerDesc
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
 		SCP->CP_PECA    := _cPeca
	MsUnLock("SCQ")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os dados da Baixa      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RecLock("ZAS",.T.)
		ZAS->ZAS_FILIAL := xFilial("ZAS")
		ZAS->ZAS_NUM 	:= _cPNum
		ZAS->ZAS_ITEM   := _cItem
		ZAS->ZAS_RESP   := _cResp
		ZAS->ZAS_SOLIC  := _cSolic
		ZAS->ZAS_DATA   := Date()
		ZAS->ZAS_HORA   := Time()
	MsUnLock("ZAS")

	Set Filter To &(_cFiltro) //retorna o filtro retirado acima
	Close(oDialog)
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Legendas	                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                             

Static Function DebCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"  },;
  					  {"BR_VERMELHO" , "Gerado"  }}

Local uRetorno := {}
Aadd(uRetorno, { 'CP_PREREQU = " " ' , aLegenda[1][1] })
Aadd(uRetorno, { 'CP_PREREQU = "S" ' , aLegenda[2][1] })

Return(uRetorno)
