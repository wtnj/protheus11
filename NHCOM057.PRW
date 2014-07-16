/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM057  ºAutor  ³João Felipe da Rosa º Data ³  18/08/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Modificacao da rotina A125Produto que valida o produto     º±±
±±º          ³ dos pedidos em aberto                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHCOM057(cProduto)                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A125Produto³ Autor ³Alexandre Inacio Lemes³Data  ³18/08/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do produto digitado                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := A125Produto(ExpC1)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = produto                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Mata125                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Function A125Produto(cProduto)

Local aArea		 := GetArea()
Local cProdRef   := ""
Local cDescri	 := ""
Local cVar       := &(ReadVar())
Local nPGrade    := aScan(aHeader,{|x| Alltrim(x[2])=="C3_GRADE"})
Local nPQtd      := aScan(aHeader,{|x| Alltrim(x[2])=="C3_QUANT"})
Local nPProduto  := aScan(aHeader,{|x| Alltrim(x[2])=="C3_PRODUTO"})
Local nPItGrd    := aScan(aHeader,{|x| Alltrim(x[2])=="C3_ITEMGRD"})
Local nPosDesc   := 0
Local nX         := 0
Local lRet 		 := .T.
Local lReferencia:= .F.
Local lGrade     := MaGrade()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao do ATUALIZADOR  ³
//³ do dicionario do modulo de Compras necessario para o uso do     |
//| recurso de grade produtos no MP10 Relese I deverá ser retirado  |
//| no proximo Release da Versao quando o dicionario for Atualizado |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("UPDCOM01_V") .And. UPDCOM01_V() >= 20070807)
	Final("Atualizar UPDCOM01_V.PRW ou checar o processamento deste UPDATE !!!")
EndIf

If !inclui .and. cVar # cCampo .and. !Empty(cCampo)
	HELP(" ",1,"A120CANNOT")
	Return(.F.)
Endif
cProdRef:=cProduto
If lGrade
	lReferencia := MatGrdPrrf(@cProdRef)

	If cProduto==GdFieldGet("C3_PRODUTO")
		Return(.T.)
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o AcolsGrade e o AheadGrade para este item     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGrade:MontaGrade(n,cProdRef,.T.,,lReferencia,.T.)

	If ( lReferencia )
		If ( nPGrade > 0 )
			aCols[n][nPGrade] := "S"
			lReferencia := .T.
		EndIf
		aCols[n][nPQtd] := 0
		cDescri := oGrade:GetDescProd(cProdRef)
	Else
		If ( nPGrade > 0 )
			If aCols[n][nPGrade] == "S"
				aCols[n][nPProduto] := Pad(cProdRef, Len(SC3->C3_PRODUTO))
				aCols[n][nPGrade] := "N"
				aCols[n][nPItGrd] := " "
			Endif				
		EndIf
	EndIf
Endif

dbSelectArea("SB1")
dbSetOrder(1)
If MsSeek(xFilial()+cProdRef,.F.)



/********  modificacao por João Felipe da Rosa 18/08/2010 **********

	If SB1->B1_CONTRAT $"N ".And.!lReferencia
		Help(" ",1,"A125CONTR")
		lRet := .F.
	EndIf

*******************************************************************/


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto x fornecedor foi bloqueado pela Qualidade.	                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet.And.!lReferencia
		lRet := QieSitFornec(cA125Forn,cA125Loj,cProduto,.T.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Registro esta Bloqueado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. !RegistroOk("SB1").And.!lReferencia
		lRet := .F.
	EndIf

	If lRet
		cDescri := SB1->B1_DESC
		dbSelectArea("SB5")
		dbSetOrder(1)
		MsSeek(xFilial()+cProduto)
		If !Empty(B5_CEME)
			cDescri := B5_CEME
		EndIf
		dbSelectArea("SB1")
		For nX = 1 to Len(aHeader)
			Do Case
			Case Trim(aHeader[nX][2]) == "C3_LOCAL"   	// Local
				If Empty(aCols[n][nX])
					aCols[n][nX] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
				EndIf
			Case Trim(aHeader[nX][2]) == "C3_DESCRI"	// Descricao
				nPosDesc := nX
			Case Trim(aHeader[nX][2]) == "C3_IPI"     	// Percentual de IPI
				aCols[n][nX] := SB1->B1_IPI
			Case Trim(aHeader[nX][2]) == "C3_SEGUM"    // Percentual de IPI
				aCols[n][nX] := SB1->B1_SEGUM
			EndCase
		Next nX

		If nPosDesc > 0
			If Len(aCols[n][nPosDesc]) > Len(cDescri)
				aCols[n][nPosDesc] := cDescri+Space(Len(aCols[n][nPosDesc])-Len(cDescri))
			Else
				aCols[n][nPosDesc] := SubStr(cDescri,1,Len(aCols[n][nPosDesc]))
			EndIf
		EndIf

	EndIf
Else
	Help("  ",1,"REGNOIS")
	lRet := .F.
EndIf

RestArea(aArea)

Return lRet
