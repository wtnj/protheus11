/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST112 ³ Autor ³ Joao Felipe da Rosa     Data ³ 14/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ GRAVACAO DE RMA                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento WHB                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#INCLUDE "PROTHEUS.CH"

User Function nhest112()

SetPrvt("CCADASTRO,AROTINA,cNum")

cCadastro := OemToAnsi("RMA")
aRotina := {{ "Pesquisa"		,"AxPesqui"      , 0 , 1},;
            { "Visualizacao"	,"U_fest112(1)"  , 0 , 2},;
            { "Inclui"   		,"U_fest112(2)"  , 0 , 3},;
            { "Altera"   		,"U_fest112(3)"  , 0 , 5},;
            { "Exclui"   		,"U_fest112(4)"	 , 0 , 4},;
            { "Relatorio" 		,"U_NHEST156()"  , 0 , 5}}

mBrowse( 6, 1,22,75,"ZAH",,,,,,)
Return

User Function fEST112(nParam)

cNum      := ""
aHeader   := {}
aCols 	  := {}
cCli      := Space(6)
cLoja	  := Space(2)
cDesc     := ""
dData     := Date()
cMat      := Space(6)
cResp     := ""
cCttClie  := Space(20)
cTel      := Space(20)  
nPar      := nParam
cTipoDev  := ""
aTipoDev  := {"1=Refugo de Usinado","2=Refugo de Fundido","3=Retrabalho","4=Teste"}
nTipoDev  := 1

Aadd(aHeader,{"Item"  		  	, "ZAI_ITEM"		,"@!"       	 , 4,0,".F.","","C","ZAI"}) 
Aadd(aHeader,{"Cod. Produto"    , "ZAI_PROD"		,"@!"       	 ,15,0,".T.","","C","ZAI"}) 
Aadd(aHeader,{"Quantidade"      , "ZAI_QUANT"		,"9999999999"  	 ,10,0,".T.","","N","ZAI"}) 
Aadd(aHeader,{"Volume"        	, "ZAI_VOLUME"		,"9999"       	 , 4,0,".T.","","N","ZAI"}) 
Aadd(aHeader,{"N.F."    	  	, "ZAI_DOC" 		,"@!"	 		 , 6,0,".T.","","C","ZAI"})
Aadd(aHeader,{"Motivo"  	  	, "ZAI_MOTIVO"  	,"@!" 	 		 ,20,0,".T.","","C","ZAI"})
Aadd(aHeader,{"Detalhe"  	  	, "ZAI_DETALH" 		,"@!" 	 		 ,15,0,".T.","","C","ZAI"})

DEFINE FONT oFont NAME "Arial" SIZE 12, -12

If nPar == 1 .Or. nPar == 3 .Or. nPar == 4 //visualiza , altera ou exclui

	cNum 	  := ZAH->ZAH_NUM
	cCli	  := ZAH->ZAH_CLIE
	cLoja	  := ZAH->ZAH_LOJA
	nTipoDev  := ZAH->ZAH_TDEV

	SA1->(DbSetOrder(1))//filial + clie + A1_LOJA
	SA1->(DbSeek(xFilial('SA1')+AllTrim(cCli)+AllTrim(cLoja)))
	If SA1->(Found())
		cDesc := SA1->A1_NOME
	EndIf

	dData    := ZAH->ZAH_DATA
	cMat     := ZAH->ZAH_RESP
   	
   	QAA->(DbSetOrder(1)) // filial + mat
   	QAA->(DbSeek(xFilial("QAA")+AllTrim(cMat)))
   	If QAA->(Found())
		cResp := 	QAA->QAA_NOME
	EndIf
			
	cCttClie := ZAH->ZAH_CONTAT
	cTel     := ZAH->ZAH_TEL

	ZAI->(DbSetOrder(1))//filial + num  +item
	If ZAI->(DBSeek(xfilial('ZAI')+cNum))
		While ZAI->ZAI_NUM == cNum
			aAdd(Acols,{ZAI->ZAI_ITEM,;	
				    	ZAI->ZAI_PROD,;   
						ZAI->ZAI_QUANT,;  
			    		ZAI->ZAI_VOLUME,; 
			    		ZAI->ZAI_DOC,;    
				    	ZAI->ZAI_MOTIVO,;	
			    	  	ZAI->ZAI_DETALH,.F.})
			ZAI->(DbSkip())
		EndDo	
	EndIf

	If nPar == 1 .Or. nPar == 4 //visualiza ou exclui
		aHeader[1][6] := ".F."
		aHeader[2][6] := ".F."
		aHeader[3][6] := ".F."
		aHeader[4][6] := ".F."
		aHeader[5][6] := ".F."
		aHeader[6][6] := ".F."
		aHeader[7][6] := ".F."
	EndIf
EndIf			      

If nPar == 2 //inclui
	DbSelectArea('ZAH')
	cNum := GetSXENum("ZAH","ZAH_NUM")
EndIf
  
	Define MsDialog oDialog Title OemToAnsi("RMA - Autorizacao de Retorno de Material") From 000,000 To 402,653 Pixel
	
	@ 010,010 Say "RMA Nº:" Size 040,8 Object olNum
	@ 008,040 Say cNum Size 040,8 Object oCod
	oCod:Setfont(oFont)
	@ 010,105 Say "Cliente: " Size 040,8 Object olCli
	@ 008,130 Get cCli Picture "@!" F3 "SA1" When(nPar == 2) Size 40,8 Valid fClie() Object oCli
	@ 008,173 Get cLoja Picture "@!" When(nPar == 2) Size 10,8 Valid fLoja() Object oLoja
	@ 008,188 Get cDesc Picture "@!" When(.F.) Size 132,8 Object oDesc
	@ 022,010 Say "Data: " Size 040,8 Object olData
	@ 020,030 Get dData Picture "99/99/9999" When(nPar == 2) Size 40,8 Object oData
	@ 022,105 Say "Matricula: " Size 040,8 Object olMat
	@ 020,130 Get cMat  Picture "@!" F3 "QAA" When(nPar == 2) Size 40,8 Valid fMat() Object oMat
	@ 022,200 Say "Responsavel: " Size 045,8 Object olResp
	@ 020,235 Get cResp Picture "@!" When(.F.) Size 85,8 Object oResp
	@ 034,010 Say "Contato Cliente: " Size 040,8 Object olContat
	@ 032,055 Get cCttClie Picture "@!" When(nPar == 2) Size 120,8 object oContat
	@ 034,235 Say "Fone: " Size 040,8 Object olFone
	@ 032,250 Get cTel Picture "@!" When(nPar == 2) Size 70,8 Object oTel
	@ 046,010 Say "Tipo de Devolução: " Size 060,8 Object olTipo
	@ 044,070 MSCOMBOBOX oCbx VAR cTipoDev ITEMS aTipoDev When(nPar == 2) SIZE 065, 65 OF oDialog PIXEL ON CHANGE nTipoDev := oCbx:nAt 

	DbSelectArea("ZAI")
	@ 060,010 TO 180,320 MULTILINE MODIFY DELETE OBJECT oMultiline

	If nPar == 1 .OR. nPar == 3 .OR. nPar == 4
		oCbx:nAt := nTipoDev
   		oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
	Endif

	@ 185,260 BMPBUTTON TYPE 01 ACTION fOk()
	@ 185,295 BMPBUTTON TYPE 02 ACTION fEnd() 
	
	Activate MsDialog oDialog Center Valid fValida()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDA O CLIENTE E A LOJA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fLoja()
	SA1->(DbSetOrder(1))//filial + clie + A1_LOJA
	SA1->(DbSeek(xFilial('SA1')+AllTrim(cCli)+AllTrim(cLoja)))
	If SA1->(Found())
		cDesc := SA1->A1_NOME
		oDesc:Refresh()
	Else
		MsgAlert("Cliente nao encontrado!")    	
		Return(.F.)	
	EndIf
Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A LOJA PADRAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fClie()
	cLoja:= "01" //recebe a loja padrao
	oLoja:Refresh()
Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A MATRICULA DO FUNCIONARIO E TRAZ O NOME ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fMat()
   	QAA->(DbSetOrder(1)) // filial + mat
   	QAA->(DbSeek(xFilial("QAA")+AllTrim(cMat)))
   	If QAA->(Found())  
   		cResp := QAA->QAA_NOME
    	oResp:Refresh() 
	Else
		MsgAlert("Matricula nao encontrada!")    	
		Return(.F.)
   	EndIf
Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONFIRMA A INCLUSAO DA RMA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fOK() 
	If nPar == 4 // excluir
		
		If MsgYesNo("Tem certeza que deseja excluir a RMA?")
			RecLock("ZAH",.F.)
				ZAH->(DbDelete())
			MsUnlock()
		   	
		   	ZAI->(DbSetOrder(1))//filial + num  +item
			If ZAI->(DBSeek(xfilial('ZAI')+AllTrim(cNum)))
		    	RecLock("ZAI",.F.)
					While ZAI->ZAI_NUM == ZAH->ZAH_NUM
		    			ZAI->(DbDelete())
		    			ZAI->(DbSkip())
					EndDo		   		
				MsUnlock("ZAI")
			EndIf
		EndIf
			
	EndIf

	If nPar == 3//alterar
	    If fValida()
	   		ZAI->(DbSetOrder(1))//filial + num  +item
			For x:= 1 to Len(Acols)
				If ZAI->(DBSeek(xfilial('ZAI')+AllTrim(cNum)+StrZero(x,4)))
				  RecLock("ZAI",.F.)
				  	ZAI->ZAI_PROD   := Acols[x][2]
					ZAI->ZAI_QUANT  := Acols[x][3]
			    	ZAI->ZAI_VOLUME := Acols[x][4]
			    	ZAI->ZAI_DOC    := Acols[x][5]
	    			ZAI->ZAI_MOTIVO	:= Acols[x][6]
    			  	ZAI->ZAI_DETALH	:= Acols[x][7]
					ZAI->(DbSkip())
	   			  MsUnlock("ZAI")
				EndIf
			Next
		EndIf
	EndIf
	
	If nPar == 2 //inserir
		If fValida()
			RecLock("ZAH",.T.)
				ZAH->ZAH_FILIAL := xFilial("ZAH")
				ZAH->ZAH_NUM 	:= cNum
				ZAH->ZAH_DATA	:= dData
				ZAH->ZAH_CLIE	:= cCli
				ZAH->ZAH_LOJA	:= cLoja
				ZAH->ZAH_RESP   := cMat
				ZAH->ZAH_CONTAT := cCttClie
				ZAH->ZAH_TEL	:= cTel
				ZAH->ZAH_TDEV   := nTipoDev
			MsUnlock("ZAH")
		    
	    	For x:= 1 to len(Acols)
				RecLock("ZAI",.T.)
			    	ZAI->ZAI_FILIAL := xFilial("ZAI")
			    	ZAI->ZAI_NUM	:= cNum
			    	ZAI->ZAI_ITEM	:= Acols[x][1]
			    	ZAI->ZAI_PROD   := Acols[x][2]
					ZAI->ZAI_QUANT  := Acols[x][3]
			    	ZAI->ZAI_VOLUME := Acols[x][4]
			    	ZAI->ZAI_DOC    := Acols[x][5]
			    	ZAI->ZAI_MOTIVO	:= Acols[x][6]
		    	  	ZAI->ZAI_DETALH	:= Acols[x][7]
				MsUnlock("ZAI")
			Next
	       //inclusao
	        fRMAMail() //envia e-mail de aviso
		EndIf
	EndIf
	
	ConfirmSX8()
	Close(oDialog)
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENCERRA A TELA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEnd() 

	RollBackSX8()
   	Close(oDialog) 
   	lDialog := .T.

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A TELA DE CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValida()
	
	If nPar <> 4 //dif. exclusao
		SB1->(DbSetOrder(1)) //filial + cod
		For x=1 to len(Acols)
			If !SB1->(DbSeek(xFilial('SB1')+Acols[x][2]))
				MsgAlert("Produto nao encontrado: "+Acols[x][2]+". Verifique!")		
				Return(.F.)
			EndIf
		Next
		SA1->(DbSetOrder(1)) //FILIAL + CLIE + LOJA	
    	SA1->(DbSeek(xFilial("SA1")+AllTrim(cCli)+AllTrim(cLoja)))
    	If SA1->(!Found())
			MsgAlert("Cliente nao encontrado!")    	
			Return(.F.)
    	EndIf
    	QAA->(DbSetOrder(1)) // filial + mat
    	QAA->(DbSeek(xFilial("QAA")+AllTrim(cMat)))
    	If QAA->(!Found())
			MsgAlert("Matricula nao encontrada!")    	
			Return(.F.)
    	EndIf
	EndIf
	
Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³ ENVIA E-MAIL DE AVISO DE INCLUSAO OU ALTERACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
Static Function fRMAMail()
Local cMsg

	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="100%" border="1">'

	cMsg += '<tr>'
	cMsg += '<td colspan="4" style="background:#ccc">'

	If nPar==2 //inclusao
	
	   ZAH->(dbSetOrder(1)) //NUM + ITEM
	   ZAH->(dbSeek(xFilial("ZAH")+cNum)) //posiciona o arquivo ZAH
	   
	   cMsg += 'RMA - INCLUSÃO - '+ZAH->ZAH_NUM
	ElseIf nPar==4 //alteracao
		cMsg += 'RMA - ALTERAÇÃO - '+ZAH->ZAH_NUM
	EndIf 
	
	cMsg += '</td>'
	cMsg += '</tr>
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Número</td>'
	cMsg += '<td>'+ZAH->ZAH_NUM+'</td>'
	cMsg += '<td style="background:#abc">Data</td>'
	cMsg += '<td>'+DTOC(ZAH->ZAH_DATA)+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Cliente</td>'
	cMsg += '<td>'+ZAH->ZAH_CLIE+'</td>'
	cMsg += '<td style="background:#abc">Loja</td>'
	cMsg += '<td>'+ZAH->ZAH_LOJA+'</td>'
	cMsg += '</tr>'	

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Nome Cliente</td>'
	SA1->(dbSetOrdeR(1)) //FILIAL + COD + LOJA
	If SA1->(dbSeek(xFilial("SA1")+ZAH->ZAH_CLIE+ZAH->ZAH_LOJA))
		cMsg += '<td colspan="3">'+SA1->A1_NOME+'</td>'
	Else
		cMsg += '<td colspan="3">&nbsp;</td>'
	EndIf
	cMsg += '</tr>'	

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Matricula</td>'
	cMsg += '<td>'+ZAH->ZAH_RESP+'</td>'
	cMsg += '<td style="background:#abc">Responsável</td>'
	SRA->(dbSetOrder(1)) // filial + mat
	If SRA->(dbSeek(xFilial("SRA")+ZAH->ZAH_RESP))
		cMsg += '<td>'+SRA->RA_NOME+'</td>'
	Else
		cMsg += '<td>&nbsp;</td>'
	EndIf
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Contato Cliente</td>'
	cMsg += '<td>'+ZAH->ZAH_CONTAT+'</td>'
	cMsg += '<td style="background:#abc">Fone</td>'
	cMsg += '<td>'+ZAH->ZAH_TEL+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Tipo de Devolução</td>'
	cMsg += '<td colspan="3">'
	If ZAH->ZAH_TDEV==1		//Usinado
		cMsg += 'Refugo de Usinado'
	ElseIf ZAH->ZAH_TDEV==2		//Fundido
		cMsg += 'Refugo de Fundido'
	ElseIf ZAH->ZAH_TDEV==3		//Retrabalho
		cMsg += 'Retrabalho'
	ElseIf ZAH->ZAH_TDEV==4		//Teste
		cMsg += 'Teste'
	EndIf
	cMsg += '</td>'
	cMsg += '</tr>'
	
	cMsg += '</table><br />'
	cMsg += 'Itens'
	
	cMsg += '<table width="100%" border="1">'	
	
	cMsg += '<tr style="background:#abc">'
	cMsg += '<td>Item</td>'
	cMsg += '<td>Produto</td>'
	cMsg += '<td>Descricao</td>'
	cMsg += '<td>Quant</td>'
	cMsg += '<td>Volume</td>'
	cMsg += '<td>NF</td>'
	cMsg += '<td>Motivo</td>'
	cMsg += '<td>Detalhes</td>'
	cMsg += '</tr>'
	
	ZAI->(dbSetOrder(1)) //NUM + ITEM
	ZAI->(dbSeek(xFilial("ZAI")+ZAH->ZAH_NUM))
	
	SB1->(dbSetOrder(1)) // filial + cod
	
	WHILE ZAI->(!EOF()) .AND. ZAI->ZAI_NUM==ZAH->ZAH_NUM
	
		cMsg += '<tr>'
		cMsg += '<td>'+ZAI->ZAI_ITEM+'</td>'
		cMsg += '<td>'+ZAI->ZAI_PROD+'</td>'
		
		SB1->(dbSeek(xFilial("SB1")+ZAI->ZAI_PROD))
		
		cMsg += '<td>'+SB1->B1_DESC+'</td>'
		cMsg += '<td>'+STR(ZAI->ZAI_QUANT)+'</td>'
		cMsg += '<td>'+STR(ZAI->ZAI_VOLUME)+'</td>'
		cMsg += '<td>'+ZAI->ZAI_DOC+'</td>'
		cMsg += '<td>'+ZAI->ZAI_MOTIVO+'</td>'
		cMsg += '<td>'+ZAI->ZAI_DETALH+'</td>'
		cMsg += '</tr>'
	     
		ZAI->(dbSkip())
		
	EndDo
	
	cMsg += '</table><br />'		
	
	cMsg += '</body>'
	cMsg += '</html>
		    
	cTo := ""
	
	If SM0->M0_CODIGO=="FN"

		//cTo += "andresd@whbfundicao.com.br;"
		cTo += "antoniocw@whbusinagem.com.br;"
		cTo += "aroldor@whbfundicao.com.br;"
		//cTo += "claudecisj@whbfundicao.com.br;"
		cTo += "diegoah@whbbrasil.com.br;"
		//cTo += "elvisfm@whbfundicao.com.br;"
		//cTo += "evaldomc@whbfundicao.com.br;"
		cTo += "fabiovs@whbfundicao.com.br;"
		cTo += "luizfr@whbfundicao.com.br;"
		cTo += "luizgb@whbfundicao.com.br;"
		cTo += "luizh@whbusinagem.com.br;"
		//cTo += "luizvs@whbfundicao.com.br;"	
		//cTo += "marcelodm@whbfundicao.com.br;" 
		//cTo += "patriciasa@whbbrasil.com.br;"
		//cTo += "robsonst@whbfundicao.com.br;"
		cTo += "cleversoncc@whbbrasil.com.br;"
		cTo += "andersonri@whbbrasil.com.br;"
		cTo += "samuelc@whbbrasil.com.br;"
		cTo += "darlenesc@whbbrasil.com.br;"
		cTo += "andreiap@whbusinagem.com.br;"
		cTo += "amabilict@whbbrasil.com.br;"
		cTo += "cristianepo@whbbrasil.com.br;"
		cTo += "wagnersf@whbfundicao.com.br;"
		cTo += "guilhermelf@whbusinagem.com.br;"
		cTo += "fabianapm@whbbrasil.com.br;"
		cTo += "renatab@whbfundicao.com.br;"
//		cTo += "allanpr@whbusinagem.com.br;"
		cTo += "josiass@whbfundicao.com.br;"
		cTo += "eltongf@whbfundicao.com.br;"
		cTo += "jessefc@whbfundicao.com.br;"
		cTo += "renatoc@whbbrasil.com.br;"
		cTo += "karinalr@whbbrasil.com.br;"
		cTo += "josefc@whbbrasil.com.br;"
		cTo += "denisws@whbfundicao.com.br;"
			
	ElseIf SM0->M0_CODIGO=="NH" //USINAGEM

		cTo :=""

	EndIf
		
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := '*** INCLUSÃO DE RMA - '+ZAH->ZAH_NUM+' ***'
	oMail:cTo      := cTo
	
	If !Empty(cTo)
		oMail:Envia()
	EndIf

Return

