/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³INTERNET  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Demostracao de comunicacao com a internet                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RDMake <Programa.Ext> -w                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Exemplo  ³RDMake RDDemo.prw -w                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
@0,0 TO 380,520 DIALOG oDlg TITLE "Comunica‡„o com INTERNET"
@10,10 BITMAP SIZE 110,40 FILE "RDDEMO.BMP"
@60,5 TO 165,255
@075,010 Say "Este Programa Exemplo serve como demonstra‡„o do SIGA ADVANCED conectado a"
@085,010 Say "INTERNET, sendo que este tem por objetivo buscar os E-MAILS vinculados ao usu rio"
@095,010 Say "que deve ser configurado nos parametros a serem passados na fun‡„o RXMESSAGE que est "
@105,010 Say "dispon¡vel para uso em programas RDMAKE. O Exemplo aqui a ser mostrado ‚ de gera‡„o de "
@115,010 Say "Pedidos de Venda a partir de alguns E-MAILS j  colocados previamente em nosso Site SNET,"
@125,010 Say "‚ importante salientar que dever„o ser customizadas as p ginas tanto no SITE de acesso,"
@135,010 Say "como no Rdmake, afinal estas devem ser personalizadas de acordo com a necessidade de "
@145,010 Say "cada um dos usu rios."
@172,190 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@172,218 BMPBUTTON TYPE 1 ACTION Execute(GeraPed)
ACTIVATE DIALOG oDlg CENTERED
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GeraPed   ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina para gera‡„o do pedido de vendas com a InterNet      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RDMake <Programa.Ext> -w                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Exemplo  ³RDMake RDDemo.prw -w                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function GeraPed

aFiles := RxMessage("\SIGAADV\EMAIL","advanced","siga0000","snet.com.br")
nx:=0

SetRegua(Len(aFiles))

For _ni:= 1 to Len(aFiles)

    aItens := {}
    IncRegua()

    cFile := aFiles[_ni]
    cTexto := MemoRead(cFile)
    For j:=1 To MlCount(cTexto,200)             // 200 Maior Linha ??
        cLine:=MemoLine(cTexto,200,j)
        If Upper(SubStr(cLine,1,6)) == "CODIGO"
            cCodCli := UPPER(Alltrim(SubStr(cLine,9,6)))
        Elseif Upper(SubStr(cLine,1,4)) == "LOJA"
            cLojaCli:= Alltrim(SubStr(cLine,7,2))
        Elseif Upper(SubStr(cLine,1,4)) == "NOME"
            cNomeCli := Alltrim(SubStr(cLine,7,40))
        Elseif Upper(SubStr(cLine,1,8)) == "ENDERECO"
            cEndCli := Alltrim(SubStr(cLine,12,40))
		Elseif Upper(SubStr(cLine,1,9)) == "MUNICIPIO"
			cMunCli := Alltrim(SubStr(cLine,12,20))
		Elseif Upper(SubStr(cLine,1,6)) == "ESTADO"
			cEstCli := Alltrim(SubStr(cLine,1,2))
		Elseif Upper(SubStr(cLine,1,3)) == "CEP"
			cCepCli := Alltrim(SubStr(cLine,6,9))
		Elseif Upper(SubStr(cLine,1,3)) == "TEL"
			cTelCli := Alltrim(SubStr(cLine,6,9))
		Elseif Upper(SubStr(cLine,1,3)) == "FAX"
			cFaxCli := Alltrim(SubStr(cLine,6,15))
		Elseif Upper(SubStr(cLine,1,6)) == "E-MAIL"
			cMailCli := Alltrim(SubStr(cLine,9,15))
		Elseif Upper(SubStr(cLine,1,7)) == "CONTATO"
			cContCli := Alltrim(SubStr(cLine,10,20))
		Elseif Upper(SubStr(cLine,1,7)) == "CGC/CPF"
			cCgcCli := Alltrim(SubStr(cLine,10,20))
		Elseif Upper(SubStr(cLine,1,8)) == "VENDEDOR"
			cVendedo:= UPPER(Alltrim(SubStr(cLine,11,6)))
		Elseif Upper(SubStr(cLine,1,7)) == "PRODUTO"
			cProduto:= Alltrim(SubStr(cLine,10,15))
			Aadd(aItens,{ cProduto,0," ",0,0} )
			nX:=nX+1
		Elseif Upper(SubStr(cLine,1,10)) == "QUANTIDADE"
			nQuant := Val(SubStr(cLine,13,6))
			aItens[nX][2] := nQuant
		Elseif Upper(SubStr(cLine,1,2)) == "UN"
			cUM := SubStr(cLine,5,2)
			aItens[nX][3] := UPPER(cUM)
		Elseif Upper(SubStr(cLine,1,14)) == "PRECO UNITARIO"
			nPrUnit := Val(SubStr(cLine,17,6))
			aItens[nX][4] := nPrUnit
		Elseif Upper(SubStr(cLine,1,11)) == "PRECO TOTAL"
			nPrTot := Val(SubStr(cLine,14,6))
			aItens[nX][5] := nPrTot
		EndIf
	Next j

// se n„o ler nenhum produto, vou fixar 1 para que se possa 
// verificar o pedido gerado para efeito de demonstracao

	If Len(aItens) == 0
		Aadd(aItens,{ "PROD TESTE",1,"PC",1000,1000} )
	End

	If Len(aItens) > 0		//  se ha'produto
   	dbSelectArea("SB1")
		dbSetOrder(1)
		cPedido:=GetSX8Num("SC5")
		dbSelectArea("SC5")
		RecLock("SC5",.T.)
		Replace C5_FILIAL 	With xFilial()
		Replace C5_NUM    	With cPedido     
		Replace C5_TIPO   	With "N"
		Replace C5_CLIENTE	With cCodCli
		Replace C5_LOJAENT 	With cLojaCli
		Replace C5_LOJACLI 	With cLojaCli
      Replace C5_VEND1    With cVendedo
		MsUnlock()
		For i:=1 to Len(aItens)
			dbSelectArea("SB1")
			dbSeek(xFilial()+aItens[i,1])
			RecLock("SC6",.T.)
			Replace C6_FILIAL 	With xFilial()
			Replace C6_ITEM    	With StrZero(i,2)     
            Replace C6_PRODUTO  With aItens[i,1]
				Replace C6_QTDVEN 	With aItens[i,2]
            Replace C6_UM       With aItens[i,3]
				Replace C6_PRCVEN 	With aItens[i,4]
            Replace C6_VALOR    With aItens[i,5]
            Replace C6_CLI      With cCodCli
            Replace C6_NUM      With cPedido
            Replace C6_TES      With SB1->B1_TS
			MsUnlock()
		Next i
		nx:=0
		aItens:={}
    End
Next _ni	
