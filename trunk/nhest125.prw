/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST125        ³ Felipe Ciconini       ³ Data ³ 17/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas de Produto Acabado Chamado Nº 013309            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaEst                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEst125()

   	SetPrvt("cEmbalagem,nQtdeEmb,cCodPro,aEtiq")

   	If !Pergunte('EST125',.T.)
      	Return(nil)
   	Endif

   	Processa({|| Gerando() },"Gerando Dados para a Impressao")
   	Processa({|| EtiqMark() }, "Etiqueta de Produto")

Return(nil)

Static Function EtiqMark()
Local nPagina := 1,;
      i       := 0,;
      j       := 0,;
      m       := 0,;
      nQuant  := 0,;
      nQtImp  := 0,;
      nQtEtq  := 0,;
      nQtEtf  := 0,;
      nQtEti  := 0,;
      nUlEtq  := 0,;
      nLin    := 140,;
      nPol	  := 1.0,;
      nQtSal  := 2,;
      nEtiqImp:= 0,;
      nPag    := 0,;
      cInsp   := Space(16),;
      cC11,cC21,cC12,cC22,cC13,cC23,cC14,cC24,cC15,cC16,cC17,cC25,cC26,cC27
        
	oFonteG1 := TFont():New("Arial"		,,15,,.T.,,,,,.F.)
   	oFonteG2 := TFont():New("Arial"		,,40,,.T.,,,,,.F.)
   	oFonteG3 := TFont():New("Arial"		,,50,,.T.,,,,,.F.)
   	oFonteG4 := TFont():New("Arial"		,,35,,.T.,,,,,.F.)
   	oFonteP  := TFont():New("Arial"		,,10,,.T.,,,,,.F.)
   	oFonteP2 := TFont():New("Arial"		,,07,,.T.,,,,,.F.)
   	//Fontes editadas: 23/09/2010
   	oFonteN1 := TFont():New("Arial"			,,13,,.T.,,,,,.F.)       //fornec,qtd,cod,nf,desc
   	oFonteN2 := TFont():New("Arial"			,,08,,.T.,,,,,.F.)
   	oFonteN3 := TFont():New("Arial"			,,13,,.F.,,,,,.F.)
   	oFonteN4 := TFont():New("Arial"			,,15,,.T.,,,,,.F.)
   	oFonteN5 := TFont():New("Arial"			,,30,,.T.,,,,,.F.)       //data
   	oFonteN6 := TFont():New("Verdana"		,,25,,.T.,,,,,.F.)       //codigo produto
   	oFonteN7 := TFont():New("Courier New"	,,45,,.T.,,,,,.F.)       //No QUANTIDADE
   	

   	oPr := tAvPrinter():New("Protheus")
   	oPr:StartPage()
   	aEtiq := {}
    
   	TMP1->(DbGoTop())
   	
   	ProcRegua(TMP1->(RecCount()))
   	
   	While TMP1->(!Eof())
		nQtdeEmb := 0
	    nQtdeEmb := TMP1->B5_QE1

	    EntraDados()
	
		If nQtdeEmb <=0
    		TMP1->(Dbskip())
        	Loop
		Endif

    	nEtiqImp := 0
    
	    If (TMP1->D1_QUANT < nQtdeEmb )
    	    nQtEtq := 1
        	nQtImp := TMP1->D1_QUANT
	        nUlEtq := 0
    	Else
	        nQuant := TMP1->D1_QUANT
	        nQtEtq := Int(TMP1->D1_QUANT / nQtdeEmb )
	        nQtImp := nQtdeEmb 
	        nUlEtq := TMP1->D1_QUANT - (nQtEtq * nQtdeEmb)
		Endif
	
	    If nUlEtq > 0
	        nQtEtq++
	    Endif
	    
	    nQtEtf := nQtEtq
	    nQtEti := nQtEtq
	
	   	For i := 1 To nQtEtq
	
	      	If i == nQtEtf .And. nUlEtq > 0
	         	nQtImp := nUlEtq
	      	Endif
	   
	      	If     nQtEti == 1
	         	nQtSal := 1
	      	Elseif nQtEti == 2
	         	nQtSal := 2
	      	Else
	        	nQtSal := 3
	      	Endif
	
			For j := 1 To nQtSal
	
				If (nQtEtf - nEtiqImp) == 1 .And. nUlEtq > 0
		        	nQtImp := nUlEtq
	    	    Endif
	
	      		If TMP1->QEK_VERIFI = 1
				   	cInsp := 'Inspecionar    '
				ElseIf TMP1->QEK_VERIFI = 2
		   			cInsp := 'Skip Lote      '
				Else
		   			cInsp := 'Amarracao      '
				Endif
	
	         	aAdd(aEtiq,{cInsp,Substr(TMP1->CLIENTE,1,18),TMP1->D1_DTDIGIT,TMP1->D1_DESCRI,TMP1->D1_COD,TMP1->D1_LOTECTL,nQtImp,TMP1->D1_DOC,TMP1->D1_SERIE,TMP1->D1_FORNECE+"/"+TMP1->D1_LOJA})
	         	nQtEti--
	         	nEtiqImp++
	
		   	Next
	      	
	      	i += 2
		Next
	    
	    TMP1->(Dbskip())
	     
   	Enddo
		
   	For m := 1 To Len(aEtiq)

        cC11 := Space(10)  //INSPECIONA
        cC12 := Space(10)	//NOME CLIENTE
        cC13 := Space(08) 	//DT DIGITACAO
        cC14 := Space(10) 	//D1 DESCRICAO
        cC15 := Space(10)
        cC16 := Space(10)
        cC17 := 0
        cC18 := Space(12)
        cC19 := Space(09)
         
        cC21 := Space(10)
        cC22 := Space(10)
        cC23 := Space(08)
        cC24 := Space(10)
        cC25 := Space(10)
        cC26 := Space(10)
        cC27 := 0
        cC28 := Space(12)
        cC29 := Space(09)
            
        cC11 := aEtiq[m,1]                         		//inspeciona
        cC12 := aEtiq[m,2]                         		//nome cliente
        cC13 := aEtiq[m,3]                         		//data digitação
        cC14 := aEtiq[m,4]                         		//d1_desc
        cC15 := aEtiq[m,5]                         		//d1_cod
        cC16 := aEtiq[m,6]                         		//d1_lotectl
        cC17 := aEtiq[m,7]                         		//nQtImp
        cC18 := aEtiq[m,8]+ " / "+aEtiq[m,9]       		//d1_cod/d1_serie
        cC19 := aEtiq[m,10]                        		//d1_fornec/d1_loja

        If (m + 1) <= Len(aEtiq)
            cC21 := aEtiq[m+1,1]                    	//inspeciona
            cC22 := aEtiq[m+1,2]                    	//nome cliente
            cC23 := aEtiq[m+1,3]                    	//data digitação
            cC24 := aEtiq[m+1,4]                    	//d1_desc
            cC25 := aEtiq[m+1,5]                    	//d1_cod
            cC26 := aEtiq[m+1,6]                    	//d1_lotectl
            cC27 := aEtiq[m+1,7]                    	//nQtImp
            cC28 := aEtiq[m,8]+ " / "+aEtiq[m,9]    	//d1_cod/d1_serie
            cC29 := aEtiq[m,10]                     	//d1_fornec/d1_loja
        Endif
        m++
//-----------------------------------------------------------------\\

	    oPr:Say(nLin+065,100,"WHB",oFonteG2)
	    oPr:Say(nLin+080,900,"CONTROLE",oFonteN1)

	    oPr:Say(nLin+065,1300,"WHB",oFonteG2)
	    oPr:Say(nLin+080,2080,"CONTROLE",oFonteN1)
		
		oPr:Say(nLin+120,0895,"QUALIDADE",oFonteN1)
	    oPr:Say(nLin+120,2075,"QUALIDADE",oFonteN1)
		
	    oPr:Say(nLin+165,0925,Upper(cC11),oFonteN2)		//INSPECIONA
	    oPr:Say(nLin+165,2105,Upper(cC21),oFonteN2)		//INSPECIONA

//	    oPr:Say(nLin+200,100 ,Replicate("-",2000),oFonteN1)
//-----------------------------------------------------------------\\

		oPr:Say(nLin+250,100,"Fornecedor:",oFonteN1)
	    oPr:Say(nLin+290,100,cC19, oFonteN1)
	    oPr:Say(nLin+290,325,Upper(cC12), oFonteN1) //NOME CLIENTE

//	    oPr:Say(nLin+260,100,"Selo Verde    - Aprovado",oFonteN12)
//	    oPr:Say(nLin+260,100,"Lote",oFonteN12)
	    
   	    oPr:Say(nLin+250,1300,"Fornecedor:",oFonteN1)
	    oPr:Say(nLin+290,1300,cC29,oFonteN1)
	    oPr:Say(nLin+290,1525,Upper(cC22), oFonteN1) //NOME CLIENTE
//-----------------------------------------------------------------\\

//	    oPr:Say(nLin+270,550,"Data:", oFonteN5)
	    oPr:Say(nLin+270,600,DTOC(STOD(cC13)),oFonteN5)
	    
//	    oPr:Say(nLin+270,1750,"Data:", oFonteN5)
	    oPr:Say(nLin+270,1800,DTOC(STOD(cC23)),oFonteN5)
//-----------------------------------------------------------------\\

		oPr:Say(nLin+380,0100,"Codigo Peca:",oFonteN1)
	    oPr:Say(nLin+380,1300,"Codigo Peca:",oFonteN1)

	    oPr:Say(nLin+440,0100,cC15,oFonteN6)
	    oPr:Say(nLin+440,1300,cC25,oFonteN6)

	    oPr:Say(nLin+380,700,"NF:",oFonteN1)
	    oPr:Say(nLin+380,800,cC18,oFonteN1)

	    oPr:Say(nLin+380,1900,"NF:",oFonteN1)
	    oPr:Say(nLin+380,2000,cC28,oFonteN1)
//-----------------------------------------------------------------\\

	    oPr:Say(nLin+540,0100,"Descrição:",oFonteN1)
	    oPr:Say(nLin+540,1300,"Descrição:",oFonteN1)

	    oPr:Say(nLin+540,0350,cC14,oFonteN3) //denominacao da peca
	    oPr:Say(nLin+540,1550,cC24,oFonteN3) //denominacao da peca 
//-----------------------------------------------------------------\\

	    oPr:Say(nLin+600,100,"Quantidade:",oFonteN1)
	    oPr:Say(nLin+600,370,AllTrim(Str(cC17)),oFonteN7)
	   
		oPr:Say(nLin+600,1300,"Quantidade:",oFonteN1)
	    oPr:Say(nLin+600,1570,AllTrim(Str(cC27)),oFonteN7) 
	    
	    
	    MSBAR("CODE128",nPol+6.5,00.8,Alltrim(cC15),oPr,.F., ,.T.  ,0.023,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
	    MSBAR("CODE128",nPol+6.5,10.8,Alltrim(cC25),oPr,.F., ,.T.  ,0.023,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
	    
	    

        nLin += 990  // 1040
        nPol += 8.01
        nPag++
         
        If nPag >= 3
            oPr:EndPage()
	      	oPr:StartPage()
	        nLin := 155 // 0
	        nPag := 0
	    Endif

   Next
   oPr:EndPage()
   oPr:Preview()
   oPr:End()
   DbSelectArea("TMP1")
   DbCloseArea()

   MS_FLUSH()

Return(nil)

Static Function Gerando()
                                      
	cQuery := "SELECT D3_TM,D3_COD,D3_CF,D3_OP,D3_QUANT,D3_EMISSAO,D3_LOCALIZ,D3_LOTECTL,B1_DESC,A7_CLIENTE,A7_LOJA,A1_NOME
	cQuery += " FROM SD3FN0 D3, SB1FN0 B1, SA7FN0 A7, SA1FN0 A1"
	cQuery += " WHERE	D3.D3_COD		= B1.B1_COD"
	cQuery += " AND 	D3.D3_COD		= A7.A7_PRODUTO"
	cQuery += " AND		A7.A7_CLIENTE	= A1.A1_COD"
	cQuery += " AND		A7.A7_LOJA		= A1.A1_LOJA"
	cQuery += " AND		D3.D3_TM		= '101'"
	cQuery += " AND 	D3.D3_CD		= 'PR0'"
	
	cQuery += " AND		A1.D_E_L_E_T_ = ''"
	cQuery += " AND		A7.D_E_L_E_T_ = ''"
	cQuery += " AND		B1.D_E_L_E_T_ = ''"
	cQuery += " AND		D3.D_E_L_E_T_ = ''"
	cQuery += " AND		A1.A1_FILIAL  = '"+xFilial("SA1")+"'"
	cQuery += " AND		A7.A7_FILIAL  = '"+xFilial("SA7")+"'"
	cQuery += " AND		B1.B1_FILIAL  = '"+xFilial("SB1")+"'"
	cQuery += " AND		D3.D3_FILIAL  = '"+xFilial("SD3")+"'"

//    MemoWrit('C:\TEMP\EST004.SQL',cQuery)
   //Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP1"

Return

Static Function TipoEmbal()
   SB5->(DbSetOrder(1)) //filial+cod
   TMP1->(DbGoTop())
   While TMP1->(!Eof())
      If TMP1->B5_QE1 <=0
         EntraDados()
      Endif
      TMP1->(Dbskip())
   Enddo
   
Return


Static Function EntraDados()
   cEmbalagem := Space(10)
   nQtdeEmb   := 0
	cCodPro    := TMP1->D1_COD

   @ 200,050 To 350,410 Dialog DlgDadosEmb Title "Produto: "+cCodPro+", Digite Embalagem e Qtde"

   @ 011,020 Say OemToAnsi("Tipo de embalagem") Size 50,8
   @ 025,020 Say OemToAnsi("Quantidade       ") Size 50,8
      
   @ 010,075 Get cEmbalagem  PICTURE "@!" Size 65,8 F3 "XZB" Valid ValEmbalagem()
   @ 024,075 Get nQtdeEmb    PICTURE "99999" Valid(nQtdeEmb >=0) Size 35,8
      
   @ 058,050 BMPBUTTON TYPE 01 ACTION GravaDados()
   @ 058,090 BMPBUTTON TYPE 02 ACTION Close(DlgDadosEmb)
   Activate Dialog DlgDadosEmb CENTERED

Return

Static Function ValEmbalagem()
Local lReturn := .F.
   If Alltrim(SX5->X5_DESCRI) == Alltrim(cEmbalagem)
      lReturn := .T.
   Else
       MsgBox("Embalagem Nao Econtrada, Verifique !","Tipo de Embalagem","INFO")
   Endif   
Return(lReturn)

Static Function GravaDados()
	SB5->(DbSeek(xFilial("SB5")+TMP1->D1_COD))
	If SB5->(Found())
	    RecLock("SB5",.F.)
	    SB5->B5_QE1     := nQtdeEmb
	    SB5->B5_EMB1    := cEmbalagem
	    MsUnLock("SB5")
   Else
       RecLock("SB5",.T.)
       SB5->B5_FILIAL  := xFilial("SB5")
	    SB5->B5_COD     := TMP1->D1_COD
	    SB5->B5_CEME    := TMP1->D1_DESCRI
	    SB5->B5_QE1     := nQtdeEmb
       SB5->B5_EMB1    := cEmbalagem
	    MsUnLock("SB5")
   Endif

   Close(DlgDadosEmb)

Return(.T.)