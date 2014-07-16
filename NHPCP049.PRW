
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP042 Autor ³Jose Henrique M Felipetto Data ³ 10/28/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Código de Barras com filtro na ordem de produção           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
               
User Function NHPCP049

oFnt1 := TFont():New("Arial"		,,12,,.T.,,,,,.F.)
oFnt2 := TFont():New("Arial"		,,18,,.T.,,,,,.F.)
oFnt3 := TFont():New("Arial"		,,30,,.T.,,,,,.F.)

If !Pergunte("PCP042",.T.)
	Return .F.
EndIf
oPrn:= tmsPrinter():New("Protheus")
oPrn:StartPage()
Cabecalho()
oPrn:EndPage()
oPrn:Preview()
Return (.T.)

Static Function Cabecalho()

Private cStartPath 	:= GetSrvProfString("Startpath","")
nAlt := 0
nAltBar := 2.8
nCont := 1

SC2->(DbSetOrder(1) )
SC2->(DbSeek(xFilial("SC2") + mv_par01))
SB1->(DbSetOrder(1) )
SB1->(DbSeek(xFilial("SB1") + SC2->C2_PRODUTO) )
SA1->(DbSetOrder(1) )
SA1->(DbSeek(xFilial("SA1") + Alltrim(SC2->C2_CODCLI) + Alltrim(SC2->C2_LOJA) ))
SA7->(DbSetOrder(2) )
SA7->(DbSeek(xFilial("SA7") + Alltrim(SC2->C2_PRODUTO) + Alltrim(SC2->C2_CODCLI) + Alltrim(SC2->C2_LOJA) ))

SB5->(DbSeek(xFilial("SB5") + SC2->C2_PRODUTO) )

For x := 1 to 2 

	If nCont == 2
		nAlt := 1650
		nAltBar := 16.3	
	EndIf

	oPrn:SayBitmap(nAlt + 20,1250, cStartPath+"\Whbl.bmp",340,170)	
	oPrn:Say(nAlt + 010,20,"WHB - Fundição",oFnt1)
	oPrn:Say(nAlt + 110,20,"ORDEM DE PRODUÇÃO:  " + mv_par01,oFnt1)
	oPrn:Say(nAlt + 210,20,"EMISSÃO OP:  " + DTOC(SC2->C2_EMISSAO) + "            Qtde Orig.:      " + Transform(SC2->C2_QUANT,"@e 999999"),oFnt1)
	oPrn:Line(nAlt + 540,20,nAlt + 540,2500) 
	
    MSBAR("CODE128",nAltBar,0.2,mv_par01,oPrn,.F., ,.T.  ,0.0690,1.0,NIL,NIL,NIL,.F.,,,.F.)// imprime cod. de barra correto
	oPrn:Say(nAlt + 680,20,"PN WHB:  ",oFnt2)
	oPrn:Say(nAlt + 680,330,SC2->C2_PRODUTO,oFnt2)
	oPrn:Say(nAlt + 710,960,Substr(SB1->B1_DESC,1,20),oFnt3)
	oPrn:Say(nAlt + 800,20,"PN Cliente: " + Alltrim(SA7->A7_CODCLI),oFnt2)
	oPrn:Say(nAlt + 850,1550,"Cliente: " + Substr(SA1->A1_NOME,1,16),oFnt1)

	oPrn:Say(nAlt + 980,20,"Embalagem Padrão: ",oFnt2)
	oPrn:Say(nAlt + 980,750,Alltrim(Str(SB5->B5_QPA)),oFnt2)
	oPrn:Say(nAlt + 1170,20,"Data embalagem:   ____/____/______ ",oFnt1)
	oPrn:Say(nAlt + 1300,20,"Turno:   1º (  )   2º (  )   3º (  )         Resp.: __________________________________________ " ,oFnt1)
	oPrn:Say(nAlt + 1430,20,"C.Custo:  " + SC2->C2_CC,oFnt1)
	
	
	oPrn:Line(nAlt + 1600,20,nAlt + 1600,2500)

	nCont++

Next x

Return




	
	
	

    

