
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST182  ºAutor  ³Felipe Ciconini     º Data ³  13/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao de Divergência de Nota Fiscal - Chamado 3948      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiscal/Estoque                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

User Function NHEST182(nParam)
Private nPar := nParam

If nPar == 1
	Processa({|| EST182() }, "Gerando...")
ElseIf nPar == 2
	Processa({|| EtiqMark() }, "Gerando...")
EndIf

Return

Static Function EST182()
Local nValIpi := 0
Local nValIcm := 0

   	oFonteN1 := TFont():New("Arial",,10,,.T.,,,,,.T.)
   	oFonteN2 := TFont():New("Arial",,10,,.T.,,,,,.F.)
   	oFontN2	 := TFont():New("Arial",,10,,.F.,,,,,.F.)
   	oFontN1	 := TFont():New("Arial",,08,,.F.,,,,,.F.)
   	oFontN3	 := TFont():New("Arial",,10,,.F.,,,,,.F.)
   	oFontN4	 := TFont():New("Arial",,10,,.T.,,,,,.F.)
   	oFontN5	 := TFont():New("Arial",,09,,.F.,,,,,.F.)
   	
   	oFonteN3 := TFont():New("Arial",,13,,.T.,,,,,.F.)
   	
   	oFonteN4 := TFont():New("Arial",,11,,.T.,,,,,.F.)
   	oFonteN5 := TFont():New("Arial",,11,,.F.,,,,,.F.)

	oPr := tAvPrinter():New("Protheus")
   	oPr:StartPage()
   	
   	oPr:Say(150,700,"NOTIFICAÇÃO DE DIVERGÊNCIA DE NOTA FISCAL",oFonteN3)
   	
   	If SM0->M0_CODIGO=="FN"
   		oPr:Say(250,1100,"WHB Fundição S/A",oFonteN4) //M0_NOMECOM
   		oPr:say(300,1050,"CNPJ:01.261681/0001-04",oFonteN5) //M0_CGC
   	Elseif SM0->M0_CODIGO=="NH"
	   	oPr:Say(250,0700,"WHB Componentes Automotivos S/A",oFonteN4)
   		oPr:Say(300,0700,"CNPJ:73.355174/0001-40",oFonteN5)
   	Elseif SM0->M0_CODIGO=="IT"
	   	oPr:Say(250,0700,"Itesapar Fundição S/A",oFonteN4)
   		oPr:Say(300,0700,"CNPJ:17.578354/0001-10",oFonteN5)
								
   	EndIf
   		oPr:Say(450,400,"Nº Débito: "+ZE3->ZE3_NUM,oFontN5)
   		oPr:Say(450,1700,Alltrim(SM0->M0_CIDENT)+", "+StrZero(Day(Date()),2)+" de "+MesExtenso(Month(Date()))+" de "+StrZero(Year(Date()),4),oFontN1)
   	
   	SA2->(DbSelectArea(1))		//filial + cod + loja
   	If SA2->(DbSeek(xFilial("SA2")+ZE3->ZE3_FORNEC+ZE3->ZE3_LOJA))
	    
	    oPr:Say(550,0380,Replicate("-",132),oFonteN4)
	    oPr:Say(600,0400,"Dados Fornecedor:",oFonteN1)
		oPr:Say(680,0420,"Razão Social:",oFonteN2)
		oPr:Say(680,0700,SA2->A2_NOME,oFontN2)
		oPr:Say(720,0420,"Endereço:",oFonteN2)
		oPr:Say(720,0700,SA2->A2_END,oFontN2)
		oPr:Say(760,0420,"Cidade:",oFonteN2)
		oPr:Say(760,0700,AllTrim(SA2->A2_MUN)+" - "+SA2->A2_EST,oFontN2)
		oPr:Say(760,1280,SA2->A2_BAIRRO,oFontN2)
		oPr:Say(800,0420,"CEP:",oFonteN2)
		oPr:Say(800,0700,SubStr(SA2->A2_CEP,1,5)+"-"+SubStr(SA2->A2_CEP,6,2),oFontN2)
		oPr:Say(840,0420,"CNPJ:",oFonteN2)
		oPr:Say(840,0700,SubStr(SA2->A2_CGC,1,2)+"."+SubStr(SA2->A2_CGC,3,6)+"/"+SubStr(SA2->A2_CGC,9,4)+"-"+SubStr(SA2->A2_CGC,13,2),oFontN2)
		oPr:Say(840,1500,"Inscrição Estadual:",oFonteN2)
		If SA2->A2_INSCR <> "ISENTO"
			oPr:Say(840,1850,SubStr(SA2->A2_INSCR,1,3)+"."+SubStr(SA2->A2_INSCR,4,3)+"."+SubStr(SA2->A2_INSCR,7,3)+"."+SubStr(SA2->A2_INSCR,10,3),oFontN2)
		Else
			oPr:Say(840,1850,AllTrim(SA2->A2_INSCR),oFontN2)
		EndIf
		oPr:Say(890,0380,Replicate("-",132),oFonteN4)

	EndIf
	
	oPr:Say(0990,0380,Replicate("-",132),oFonteN4)
	oPr:Say(1040,0400,"Dados da Nota Fiscal:",oFonteN1)
	oPr:Say(1120,0440,"Nº da Nota:",oFonteN2)
	oPr:Say(1120,0700,ZE3->ZE3_NUMNF,oFontN2)
	oPr:Say(1120,1500,"Pedido de Compra:",oFonteN2)
	oPr:Say(1120,1850,ZE3->ZE3_NUMPED,oFontN2)
	oPr:Say(1170,0380,Replicate("-",132),oFonteN4)
	
	
	nValIpi := (ZE3->ZE3_IPI/100)*ZE3->ZE3_DIVERG
	If ZE3->ZE3_BASE == "S"						//CALCULO DIFERENTE SOLICITADO
		nvalIcm := (ZE3->ZE3_ICMS/100)*(ZE3->ZE3_DIVERG+nValIpi)
	Else
		nValIcm := (ZE3->ZE3_ICMS/100)*ZE3->ZE3_DIVERG
	EndIf
	
	oPr:Say(1270,0380,Replicate("-",132),oFonteN4)
	oPr:Say(1320,0400,"Discrepância:",oFonteN1)
	oPr:Say(1400,0400,"Produto:",oFonteN2)
	SB1->(DbSelectArea(1))
	If SB1->(DbSeek(xFilial("SB1")+ZE3->ZE3_PROD))
		oPr:Say(1400,0900,AllTrim(ZE3->ZE3_PROD)+" - "+SB1->B1_DESC,oFontN2)
	Else
		oPr:Say(1400,0900,AllTrim(ZE3->ZE3_PROD),oFontN2)
	EndIf
	oPr:Say(1440,0440,"Preço Unit. do Pedido:",oFonteN2)
	oPr:Say(1440,0900,"R$ "+AllTrim(Str(ZE3->ZE3_PRPED,10,4)),oFontN2)
	oPr:Say(1480,0440,"Preço Unit. da Fatura:",oFonteN2)
	oPr:Say(1480,0900,"R$ "+AllTrim(Str(ZE3->ZE3_PRFAT,10,4)),oFontN2)
	oPr:Say(1520,0440,"Quantidade:",oFonteN2)
	oPr:Say(1520,0900,AllTrim(Str(ZE3->ZE3_QUANT,14,4)),oFontN2)
	oPr:Say(1560,0440,"Total Divergência:",oFonteN2)
	oPr:Say(1560,0900,"R$ "+AllTrim(Str(ZE3->ZE3_DIVERG,14,2)),oFontN2)
	oPr:Say(1600,0440,"Aliquota ICMS:",oFonteN2)
	oPr:Say(1600,0900,AllTrim(Str(ZE3->ZE3_ICMS,7))+"%",oFontN2)
	oPr:Say(1640,0440,"Valor ICMS:",oFonteN2)
	oPr:Say(1640,0900,"R$ "+AllTrim(Str(nValIcm,7,2)),oFontN2)
	oPr:Say(1680,0440,"Aliquota IPI:",oFonteN2)
	oPr:Say(1680,0900,AllTrim(Str(ZE3->ZE3_IPI,7))+"%",oFontN2)
	oPr:Say(1720,0440,"Valor IPI:",oFonteN2)
	oPr:Say(1720,0900,"R$ "+AllTrim(Str(nValIpi,7,2)),oFontN2)
	oPr:Say(1770,0380,Replicate("-",132),oFonteN4)
	
	oPr:Say(1880,0400,"REFERENTE A DIFERENÇA DE PREÇO VERIFICADO NO ITEM E NOTA FISCAL ESPECIFICADOS ",oFontN3)
	oPr:Say(1920,0400,"ACIMA, CUJO O VALOR SERÁ DEDUZIDO POR OCASIÃO DO PAGAMENTO. OPERAÇÃO TEM COMO",oFontN3)
	oPr:Say(1960,0400,"BASE A CONSULTA 61/05 DO SETOR CONSULTIVO DO ESTADO DO PARANÁ",oFontN3)
	
	oPr:Say(2060,0400,"DECLARAÇÃO",oFontN4)
	oPr:Say(2100,0400,"Declaramos para os devidos fins previstos no artigo 166 e demais pertinente ao código tributário nacional (lei Nº 5.172",oFontN5)
	oPr:Say(2140,0400,"de 25/10/66) não havermos aproveitado os créditos referentes ao ICMS e IPI correspondentes a nota fiscal acima",oFontN5)
	oPr:Say(2180,0400,"mencionada, pagos a maior ou indevidamente pelo fornecedor acima.",oFontN5)
	oPr:Say(2220,0400,"Assim sendo, está a mesma, perfeitamente apta a pleitear a restituição dos referidos impostos, na forma da legislação",oFontN5)
	oPr:Say(2260,0400,"vigente.",oFontN5)
	
    oPr:Say(2360,0400,"Emitente:",oFontN4)
    oPr:Say(2460,0400,Replicate("_",30),oFonteN1)
    oPr:Say(2520,0400,"Departamento Fiscal",oFontN1)
    If SM0->M0_CODIGO == "FN"
    	oPr:Say(2550,0400,"WHB Fundição S/A",oFontN1)
        oPr:Say(2580,0400,"(41) 3341-1990",oFontN1)    	
    ElseIf SM0->M0_CODIGO == "NH"
    	oPr:Say(2550,0400,"WHB Componentes Automotivos S/A",oFontN1)
   	    oPr:Say(2580,0400,"(41) 3341-1990",oFontN1)
    ElseIf SM0->M0_CODIGO == "IT"
    	oPr:Say(2550,0400,"Itesapar Fundição S/A",oFontN1)
   	    oPr:Say(2580,0400,"(42) 3252-8547",oFontN1)   	    
    EndIf

    
    oPr:Say(2680,0380,Replicate("_",86),oFonteN1)
    If SM0->M0_CODIGO == "FN"
	    oPr:Say(2730,1080,"WHB FUNDIÇÃO",oFonteN4)
	    oPr:Say(2770,0900,"Rua Wiegando Olsen 1600 - CEP 81460-070",oFontN3) //M0_ENDENT + M0_CEPENT  
	    oPr:Say(2810,1000,"CIC - Curitiba - Paraná - Brasil",oFontN3) // M0_BAIRCOB + M0_CIDENT + M0_ESTENT + BRASIL
	    oPr:Say(2850,0970,"Fone: (41)3348-1800 / Fax: 3348-3641",oFontN3) // M0_TEL + M0_FAX
	ElseIf SM0->M0_CODIGO == "NH"
		oPr:Say(2730,1080,"WHB USINAGEM",oFonteN4)
	    oPr:Say(2770,0900,"Rua Wiegando Olsen 1000 - CEP 81460-070",oFontN3)
	    oPr:Say(2810,1000,"CIC - Curitiba - Paraná - Brasil",oFontN3)
	    oPr:Say(2850,0970,"Fone: (41)3341-1900 / Fax: 3341-1920",oFontN3)
	ElseIf SM0->M0_CODIGO == "IT"
		oPr:Say(2730,1080,"ITESAPAR FUNDIÇÃO S/A",oFonteN4)
	    oPr:Say(2770,0900,"Rua Padre Achieta 112 - CEP 84130-000",oFontN3)
	    oPr:Say(2810,1000,"Vila Vida - Palmeira - Paraná - Brasil",oFontN3)
	    oPr:Say(2850,0970,"Fone: (42)3252-8500 / Fax: 3252-8530",oFontN3)	    
	EndIf
   
	oPr:EndPage()
	oPr:Preview()
	oPr:End()

Return

//------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------IMPRESSAO DE CARTA PARA ENVIO--------------------------

Static Function EtiqMark()

   	oFonteN1 := TFont():New("Arial"			,,13,,.T.,,,,,.F.)
   	oFonteN2 := TFont():New("Arial"			,,08,,.T.,,,,,.F.)
   	oFonteN3 := TFont():New("Arial"			,,13,,.F.,,,,,.F.)
   	oFonteN4 := TFont():New("Arial"			,,15,,.T.,,,,,.F.)
   	oFonteN5 := TFont():New("Arial"			,,20,,.F.,,,,,.F.)
   	oFonteN6 := TFont():New("Verdana"		,,20,,.T.,,,,,.F.)

	oPr := tAvPrinter():New("Protheus")
   	oPr:StartPage()
   	
   	SA2->(DbSelectArea(1))		//filial + cod + loja
   	If SA2->(DbSeek(xFilial("SA2")+ZE3->ZE3_FORNEC+ZE3->ZE3_LOJA))
	   	oPr:Say(450,0600,SA2->A2_NOME,oFonteN6)
	   	oPr:Say(520,0600,SA2->A2_END,oFonteN5)
	   	oPr:Say(590,0600,AllTrim(SA2->A2_MUN)+" - "+SA2->A2_EST,oFonteN5)
	   	oPr:Say(590,1400,SA2->A2_BAIRRO,oFonteN5)
	   	oPr:Say(660,0600,SA2->A2_CEP,oFonteN5)
	   	oPr:Say(730,0600,"A/C: FINANCEIRO-CONTAS A RECEBER")
	EndIf
    
	oPr:EndPage()
	oPr:Preview()
	oPr:End()

Return