/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST004        ³ Marcos R. Roquitski   ³ Data ³ 26/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas de Recebimento para Identificacao do Produto.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaEst                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEst4gra()  

   	SetPrvt("cEmbalagem,nQtdeEmb,cCodPro,aEtiq")

   	If !Pergunte('EST004',.T.)
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
    
   	TMP->(DbGoTop())
   	
   	ProcRegua(TMP->(RecCount()))
   	
   	While TMP->(!Eof())
		nQtdeEmb := 0
	    nQtdeEmb := TMP->B5_QE1

	    EntraDados()
	
		If nQtdeEmb <=0 
    		TMP->(Dbskip())
        	Loop			  
		Endif

    	nEtiqImp := 0
    
	    If (TMP->D1_QUANT < nQtdeEmb )
    	    nQtEtq := 1
        	nQtImp := TMP->D1_QUANT
	        nUlEtq := 0
    	Else
	        nQuant := TMP->D1_QUANT
	        nQtEtq := Int(TMP->D1_QUANT / nQtdeEmb )
	        nQtImp := nQtdeEmb 
	        nUlEtq := TMP->D1_QUANT - (nQtEtq * nQtdeEmb) 
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
	
	      		If TMP->QEK_VERIFI = 1
				   	cInsp := 'Inspecionar    '
				ElseIf TMP->QEK_VERIFI = 2 
		   			cInsp := 'Skip Lote      '
				Else
		   			cInsp := 'Amarracao      '                         
				Endif                                                       
	
	         	aAdd(aEtiq,{cInsp,Substr(TMP->CLIENTE,1,18),TMP->D1_DTDIGIT,TMP->D1_DESCRI,TMP->D1_COD,TMP->D1_LOTECTL,nQtImp,TMP->D1_DOC,TMP->D1_SERIE,TMP->D1_FORNECE+"/"+TMP->D1_LOJA})
	         	nQtEti--
	         	nEtiqImp++
	
		   	Next   
	      	
	      	i += 2
		Next
	    
	    TMP->(Dbskip())
	     
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

// 	    oPr:Say(nLin+260,1300,"Selo Verde    - Aprovado",oFonteN12)
//	    oPr:Say(nLin+260,1300,"Lote",oFonteN12)

//	    oPr:Say(nLin+310,100,"Selo Laranja  - Impedido",oFonteN12)
//		oPr:Say(nLin+290,100,cC16,oFonteG4) // LOTE

//	    oPr:Say(nLin+310,1300,"Selo Laranja  - Impedido",oFonteN12)
//		oPr:Say(nLin+290,1300,cC16,oFonteG4) // LOTE
	    
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
   DbSelectArea("TMP")
   DbCloseArea()

   MS_FLUSH()

Return(nil)
         

Static Function Gerando()

   cQuery := "SELECT D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_ITEM,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,F1.F1_TIPO,D1.D1_NUMSEQ,"
   cQuery += "B5.B5_QE1,B5.B5_EMB1,QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI,D1.D1_LOCAL,"

   cQuery += "(SELECT TOP 1 D5.D5_LOTECTL
   cQuery += "	 FROM "+RetSqlName("SD5")+" D5 (NOLOCK) "
   cQuery += "	 WHERE D5.D5_NUMSEQ = D1.D1_NUMSEQ "
   cQuery += "	 AND SUBSTRING(D5.D5_PRODUTO,1,3) = 'VWB'"
   cQuery += "	 AND D5.D_E_L_E_T_ <> '*'"
   cQuery += "	 AND D5.D5_FILIAL = '"+xFilial("SD5")+"'"
   cQuery += ") LOTECTL,
   cQuery += "'CLIENTE' = "
   cQuery += "CASE "
   cQuery += "   WHEN F1.F1_TIPO = 'N' THEN "
   cQuery += "        (SELECT A2.A2_NREDUZ "
   cQuery += "         FROM " +RetSqlName('SA2') +" A2 (NOLOCK) "
   cQuery += "         WHERE A2.D_E_L_E_T_ = ' ' AND A2.A2_COD = D1.D1_FORNECE "
   cQuery += "         AND A2.A2_LOJA = D1.D1_LOJA) "
   cQuery += "   ELSE "
   cQuery += "        (SELECT A1.A1_NREDUZ "
   cQuery += "         FROM " +RetSqlName('SA1') +" A1 (NOLOCK) "
   cQuery += "         WHERE A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = D1.D1_FORNECE "
   cQuery += "         AND A1.A1_LOJA = D1.D1_LOJA) "
   cQuery += "END "
  
   cQuery += " FROM "+RetSqlName('SD1')+" D1 (NOLOCK) "
   
   cQuery += " INNER JOIN "+RetSqlName('SF1')+" F1 (NOLOCK) ON 
   cQuery += "  	F1.F1_FILIAL = D1.D1_FILIAL "
   cQuery += " AND F1.F1_DOC     = D1.D1_DOC "
   cQuery += " AND F1.F1_SERIE   = D1.D1_SERIE "
   cQuery += " AND F1.F1_FORNECE = D1.D1_FORNECE
   cQuery += " AND F1.F1_LOJA    = D1.D1_LOJA "  
   cQuery += " AND F1.F1_DTDIGIT = D1.D1_DTDIGIT "
   cQuery += " AND F1.D_E_L_E_T_ = '' "

   cQuery += " LEFT JOIN "+RetSqlName('SB5')+" B5 (NOLOCK) ON "
   cQuery += " 	   B5.B5_FILIAL = '" + xFilial("SB5")+ "'"
   cQuery += " AND D1.D1_COD = B5.B5_COD AND B5.D_E_L_E_T_ = ' ' "
   
   cQuery += " LEFT JOIN "+RetSqlName('QEK')+" QEK (NOLOCK) ON "
   cQuery += "     D1.D1_FILIAL = QEK.QEK_FILIAL " 
   cQuery += " AND D1.D1_DOC    = QEK.QEK_NTFISC AND D1.D1_SERIE   = QEK.QEK_SERINF"
   cQuery += " AND D1.D1_COD    = QEK.QEK_PRODUT AND D1.D1_FORNECE = QEK.QEK_FORNEC"
   cQuery += " AND D1.D1_LOJA   = QEK.QEK_LOJFOR AND D1.D1_DTDIGIT = QEK.QEK_DTENTR"
   cQuery += " AND D1.D1_QUANT  = QEK.QEK_TAMLOT"
   cQuery += " AND QEK.D_E_L_E_T_ = ' ' "

   cQuery += " WHERE D1.D1_DTDIGIT BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "' "
   cQuery += " AND D1.D1_FILIAL  = '" + xFilial("SD1")+ "'"
   cQuery += " AND D1.D1_DOC     = '" + mv_par01 + "' "
   cQuery += " AND D1.D1_SERIE   = '" + Mv_par02 + "' "
   cQuery += " AND D1.D1_FORNECE = '" + mv_par05 + "' "
   cQuery += " AND D1.D1_LOJA    = '" + mv_par06 + "' "
   cQuery += " AND D1.D_E_L_E_T_ = '' "

   cQuery += "GROUP BY D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_ITEM,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,F1.F1_TIPO,D1.D1_NUMSEQ,"
   cQuery += "B5.B5_QE1,B5.B5_EMB1,QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI,D1.D1_LOCAL"

   cQuery += " ORDER BY D1.D1_PEDIDO,D1.D1_ITEMPC ASC"
                                      
/*
   cQuery := "SELECT D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_ITEM,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,F1.F1_TIPO,"
   cQuery += "B5.B5_QE1,B5.B5_EMB1,QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI," 
   cQuery += "'CLIENTE' = "
   cQuery += "CASE "
   cQuery += "   WHEN F1.F1_TIPO = 'N' THEN "
   cQuery += "        (SELECT A2.A2_NREDUZ "
   cQuery += "         FROM " +RetSqlName('SA2') +" A2 " 
   cQuery += "         WHERE A2.D_E_L_E_T_ = ' ' AND A2.A2_COD = D1.D1_FORNECE "
   cQuery += "         AND A2.A2_LOJA = D1.D1_LOJA) "
   cQuery += "   ELSE "
   cQuery += "        (SELECT A1.A1_NREDUZ "
   cQuery += "         FROM " +RetSqlName('SA1') +" A1 " 
   cQuery += "         WHERE A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = D1.D1_FORNECE "
   cQuery += "         AND A1.A1_LOJA = D1.D1_LOJA) "
   cQuery += "END "   
  
   cQuery += " FROM " + RetSqlName( 'SD1' ) +" D1, " + RetSqlName( 'SF1' ) +" F1, " + RetSqlName( 'SB5' ) +" B5,"+ RetSqlName( 'QEK' ) +" QEK " 
   cQuery += " WHERE D1.D1_FILIAL = '" + xFilial("SD1")+ "'"
   cQuery += " AND F1.F1_FILIAL = '" + xFilial("SF1")+ "'"
    cQuery += " AND B5.B5_FILIAL = '" + xFilial("SB5")+ "'"
   cQuery += " AND QEK.QEK_FILIAL = '" + xFilial("QEK")+ "'"
   cQuery += " AND F1.F1_DTDIGIT BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "' AND F1.D_E_L_E_T_ <> '*' "  
   cQuery += " AND D1.D1_DOC = '" + mv_par01 + "' AND D1.D_E_L_E_T_ <> '*' "
   cQuery += " AND D1.D1_SERIE = '" + Mv_par02 + "' AND D1.D_E_L_E_T_ <> '*' "
   cQuery += " AND F1.F1_DTDIGIT = D1.D1_DTDIGIT "
   cQuery += " AND F1.F1_FORNECE = '" + mv_par05 + "' "
   cQuery += " AND F1.F1_LOJA = '" + mv_par06 + "' "
   cQuery += " AND D1.D1_FILIAL *= B5.B5_FILIAL AND D1.D1_COD *= B5.B5_COD AND B5.D_E_L_E_T_ = ' ' "
   cQuery += " AND F1.F1_DOC = D1.D1_DOC AND F1.F1_SERIE = D1.D1_SERIE"
   cQuery += " AND D1.D1_DOC *= QEK.QEK_NTFISC AND D1.D1_SERIE *= QEK.QEK_SERINF"
   cQuery += " AND D1.D1_COD *= QEK.QEK_PRODUT AND D1.D1_FORNECE *= QEK.QEK_FORNEC" 
   cQuery += " AND D1.D1_LOJA *= QEK.QEK_LOJFOR AND D1.D1_DTDIGIT *= QEK.QEK_DTENTR"
   cQuery += " AND D1.D1_QUANT *= QEK.QEK_TAMLOT"	
   cQuery += " AND QEK.D_E_L_E_T_ = ' ' " 	
   cQuery += "GROUP BY D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_ITEM,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,F1.F1_TIPO,"
   cQuery += "B5.B5_QE1,B5.B5_EMB1,QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI" 
   cQuery += " ORDER BY D1.D1_PEDIDO,D1.D1_ITEMPC ASC"
*/
//    MemoWrit('C:\TEMP\EST004.SQL',cQuery)
   //Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  
	

	
Return



Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := Space(10)
cPerg   := "EST004    "
aRegs   := {}

// VERSAO 508
//
//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
/*
aadd(aRegs,{cPerg,"01","de Nota          ?","de Nota          ?","de Nota          ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","ate Nota         ?","ate Nota         ?","ate Nota         ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","de Serie         ?","de Serie         ?","de Serie         ?","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","ate Serie        ?","ate Serie        ?","ate Serie        ?","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","de Fornecedor    ?","de Fornecedor    ?","de Fornecedor    ?","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})        
aadd(aRegs,{cPerg,"08","ate Fornecedor   ?","ate Fornecedor   ?","ate Fornecedor   ?","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
*/

aAdd(aRegs,{cPerg,"01","Nota             ?","Nota             ?","Nota             ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Serie            ?","Serie            ?","Serie            ?","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Fornecedor       ?","Fornecedor       ?","Fornecedor       ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})        
aAdd(aRegs,{cPerg,"06","Loja             ?","Loja             ?","Loja             ?","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})        

cUltPerg := aRegs[Len(aRegs)][2]

/*
If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
   	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf                   
*/

dbSelectArea(_sAlias)

Return
                           

Static Function TipoEmbal()
   SB5->(DbSetOrder(1)) //filial+cod
   TMP->(DbGoTop())
   While TMP->(!Eof())
      If TMP->B5_QE1 <=0 
         EntraDados()
      Endif
      TMP->(Dbskip())
   Enddo      
   
Return


Static Function EntraDados()
   cEmbalagem := Space(10)
   nQtdeEmb   := 0
	cCodPro    := TMP->D1_COD

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
	SB5->(DbSeek(xFilial("SB5")+TMP->D1_COD))
	If SB5->(Found())
	    RecLock("SB5",.F.)
	    SB5->B5_QE1     := nQtdeEmb
	    SB5->B5_EMB1    := cEmbalagem
	    MsUnLock("SB5")
   Else
       RecLock("SB5",.T.)
       SB5->B5_FILIAL  := xFilial("SB5")
	    SB5->B5_COD     := TMP->D1_COD
	    SB5->B5_CEME    := TMP->D1_DESCRI
	    SB5->B5_QE1     := nQtdeEmb
       SB5->B5_EMB1    := cEmbalagem
	    MsUnLock("SB5")
   Endif

   Close(DlgDadosEmb)

Return(.T.)