/*                              
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHEST004        � Marcos R. Roquitski   � Data � 26/02/03 ���
������������������������������������������������������������������������Ĵ��
���Descricao � Etiquetas de Recebimento para Identificacao do Produto.   ���
������������������������������������������������������������������������Ĵ��
���Uso       � SigaEst                                                   ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function etiqfiat()    
SetPrvt("cEmbalagem,nQtdeEmb,cCodPro,aEtiq,cPorta,_CODBARRA")
cPorta      := "LPT1"     
AjustaSx1()

If !Pergunte('EST004',.T.)
   Return(nil)
Endif                        

//If !IsPrinter(cPorta)
//	alert("erro na porta")
//    Return
//Endif

Processa({|| Gerando()  },"Gerando Dados para a Impressao")
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
      nQtSal  := 2,;
      nEtiqImp:= 0,;
      nPag    := 0,;
      cInsp   := Space(16),;
      cC11,cC21,cC12,cC22,cC13,cC23,cC14,cC24,cC15,cC16,cC17,cC25,cC26,cC27
        
	oFonteG1 := TFont():New("Arial",,20,,.t.,,,,,.f.)
	oFonteG2 := TFont():New("Arial",,40,,.t.,,,,,.f.)
	oFonteG3 := TFont():New("Arial",,50,,.t.,,,,,.f.)
	oFonteG4 := TFont():New("Arial",,35,,.t.,,,,,.f.)
	oFonteP  := TFont():New("Arial",,10,,.t.,,,,,.f.)
	oFonteP2 := TFont():New("Arial",,07,,.t.,,,,,.f.)  
	oFont08  := TFont():New("Arial",,8,,.F.)	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont20  := TFont():New("Arial",,20,,.F.)
	oFont36  := TFont():New("Arial",,36,,.F.)
	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)
	
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

         AADD(aEtiq,{TMP->D1_DTDIGIT,TMP->D1_FORNECE+"/"+TMP->D1_LOJA,TMP->D1_DESCRI,TMP->D1_DOC,nQtImp,TMP->B1_CODAP5}) // Substr(TMP->CLIENTE,1,18),TMP->D1_COD,TMP->D1_LOTECTL,nQtImp,TMP->D1_SERIE})
         nQtEti--
        nEtiqImp++

	   Next   
      i += 2
    Next
    TMP->(Dbskip())
     
   Enddo
   

   For m := 1 to Len(aEtiq)

         cC11 := Space(10)
         cC12 := Space(10)
         cC13 := Space(08)
         cC14 := Space(10)      
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

            
         cC11 := aEtiq[m,1]
         cC12 := aEtiq[m,2]
         cC13 := aEtiq[m,3]
         cC14 := aEtiq[m,4]
         cC15 := aEtiq[m,5]
         cC16 := aEtiq[m,6]

         If (m + 1) <= Len(aEtiq)
            cC21 := aEtiq[m+1,1]
            cC22 := aEtiq[m+1,2] 
            cC23 := aEtiq[m+1,3] 
            cC24 := aEtiq[m+1,4] 
            cC25 := aEtiq[m+1,5] 
            cC26 := aEtiq[m+1,6]             
         Endif
         m++

                 
    _codap5 = len(alltrim(cC16))
    _cod2   = Replicate("0",11-_codap5)+cC16
	_CodBar := substr(_cod2,0,11)+strzero(cC15,5)+space(3)+'19424'


	IncProc("Imprimindo Etiqueta PSA")
    
    //  CAIXA 001
	oPr:Line(0050,0100,0050,1600) // Horizontal 1� linha 
	oPr:Line(0050,0100,2350,0100) // vertical DIREITA  1
	oPr:Line(0050,0850,0650,0850) // vertical PARTE 1
	oPr:Line(0050,1600,2350,1600) // vertical ESQUERDA 1

	oPr:Line(0250,0100,0250,1600) // Horizontal 2� linha 
	oPr:Line(0450,0100,0450,1600) // Horizontal 3� linha 
	oPr:Line(0650,0100,0650,1600) // Horizontal 4� linha 
	oPr:Line(1150,0100,1150,1600) // Horizontal 5� linha 
	oPr:Line(1350,0100,1350,1600) // Horizontal 6� linha 
	oPr:Line(1550,0100,1550,1600) // Horizontal 7� linha 
	oPr:Line(1750,0100,1750,1600) // Horizontal 8� linha 
	oPr:Line(1950,0100,1950,1600) // Horizontal 9� linha 		
	oPr:Line(2150,0100,2150,1600) // Horizontal 10� linha 
	oPr:Line(2350,0100,2350,1600) // Horizontal 11 linha 		

	oPr:Line(1150,0850,1350,850) // vertical DIREITA  1
	
	oPr:Line(1350,0550,1750,0550) //
	oPr:Line(1350,1080,1750,1080) //

	oPr:Line(1350,2250,1750,2250) // vertical DIREITA  1
	oPr:Line(1350,2790,1750,2790) // vertical DIREITA  1

	oPr:Line(1750,0850,1950,0850) // vertical DIREITA  1
	oPr:Line(1750,2450,1950,2450) // vertical DIREITA  1

	oPr:Line(1950,0550,2150,0550) //       AQUI
	oPr:Line(1950,1080,2150,1080) //

	oPr:Line(1950,2250,2150,2250) // 
	oPr:Line(1950,2790,2150,2790) //
	
    //  CAIXA 002    
	oPr:Line(0050,1700,0050,3200) // Horizontal 1� linha 
	oPr:Line(0050,1700,2350,1700) // vertical DIREITA  2
	oPr:Line(0050,2450,0650,2450) // vertical PARTE 1
	oPr:Line(0050,3200,2350,3200) // vertical ESQUERDA 2
	
	oPr:Line(0250,1700,0250,3200) // Horizontal 2� linha 
	oPr:Line(0450,1700,0450,3200) // Horizontal 3� linha 
	oPr:Line(0650,1700,0650,3200) // Horizontal 4� linha 
	oPr:Line(0050,2450,0650,2450) // vertical PARTE 2
	oPr:Line(1150,1700,1150,3200) // Horizontal 5� linha 
	oPr:Line(1350,1700,1350,3200) // Horizontal 6� linha 
	oPr:Line(1550,1700,1550,3200) // Horizontal 7� linha 
	oPr:Line(1750,1700,1750,3200) // Horizontal 8� linha 
	oPr:Line(1950,1700,1950,3200) // Horizontal 9� linha 		
	oPr:Line(2150,1700,2150,3200) // Horizontal 10� linha 
	oPr:Line(2350,1700,2350,3200) // Horizontal 11 linha 		
    
   	oPr:Line(1150,2450,1350,2450) // vertical DIREITA  1


    //  LINHA 001
   
    oPr:Say(0060,0120,OemtoAnsi("FPT"), oFonteG1)
    oPr:Say(0150,0120,OemtoAnsi("POWERTRAIN TECNOLOGIES"), oFont12N)
    oPr:Say(0100,0900,OemtoAnsi("WHB DO BRASIL S.A."), oFont12N)    

    oPr:Say(0060,1750,OemtoAnsi("FPT"), oFonteG1)
    oPr:Say(0150,1750,OemtoAnsi("POWERTRAIN TECNOLOGIES"), oFont12N)
    oPr:Say(0100,2460,OemtoAnsi("WHB DO BRASIL S.A."), oFont12N)    

    oPr:Say(0260,0120,OemtoAnsi("Data:"), oFont08)    
    oPr:Say(0260,1740,OemtoAnsi("Data:"), oFont08)    
    oPr:Say(0260,0900,OemtoAnsi("Cod. Fornecedor:"), oFont08)    
    oPr:Say(0260,2460,OemtoAnsi("Cod. Fornecedor::"), oFont08)    

    oPr:Say(0320,0170,OemtoAnsi(DTOC(Date())),oFont18N)    
    oPr:Say(0320,1100,OemtoAnsi("19424"),oFont18N)    
    oPr:Say(0320,1790,OemtoAnsi(DTOC(Date())),oFont18N)    
    oPr:Say(0320,2700,OemtoAnsi("19424"),oFont18N)    

    oPr:Say(0460,0120,OemtoAnsi("Denominacao:"), oFont08)    
    oPr:Say(0460,1740,OemtoAnsi("Denominacao:"), oFont08)    
    oPr:Say(0460,0900,OemtoAnsi("No. Doc.Fiscal (BAM):"), oFont08)    
    oPr:Say(0460,2460,OemtoAnsi("No. Doc.Fiscal (BAM):"), oFont08)    

    oPr:Say(0520,0120,cC13,oFont12N)    
    oPr:Say(0520,1720,cC13,oFont12N)    
                                           
    oPr:Say(0520,1100,cC14,oFont18N)    
    oPr:Say(0520,2700,cC14,oFont18N)    

    oPr:Say(0660,0120,OemtoAnsi("Desenho:"), oFont08)    
    oPr:Say(0660,1740,OemtoAnsi("Desenho:"), oFont08)    
    
    oPr:Say(0700,0700,cC16,oFont18N)    
    oPr:Say(0700,2200,cC16,oFont18N)    

	MSBAR("CODE128",3.8,1.2,Alltrim(_CodBar),oPr,NIL,NIL,NIL,0.0130,1,NIL,oFont08,,.F.) //imprime cod. de barra do produto
	MSBAR("CODE128",3.8,8,Alltrim(_CodBar),oPr,NIL,NIL,NIL,0.0130,1,NIL,oFont08,,.F.) //imprime cod. de barra do produto

    oPr:Say(1050,0500,_CodBar,oFont14N)    
    oPr:Say(1050,2050,_CodBar,oFont14N)    

    oPr:Say(1160,0120,OemtoAnsi("Data Producao do Lote:"), oFont08)    
    oPr:Say(1160,1740,OemtoAnsi("Data Producao do Lote:"), oFont08)    
    oPr:Say(1160,0900,OemtoAnsi("Codigo da Embalagem:"), oFont08)    
    oPr:Say(1160,2460,OemtoAnsi("Codigo da Embalagem:"), oFont08)    

    oPr:Say(1350,0120,OemtoAnsi("No.Lote:"), oFont08)    
    oPr:Say(1350,1740,OemtoAnsi("No.Lote:"), oFont08)    
    oPr:Say(1350,0560,OemtoAnsi("Qtde do Lote:"), oFont08)    
    oPr:Say(1350,2260,OemtoAnsi("Qtde do Lote:"), oFont08)    
    oPr:Say(1350,1090,OemtoAnsi("Qtde da Embalagem:"), oFont08)    
    oPr:Say(1350,2800,OemtoAnsi("Qtde da Embalagem:"), oFont08) 
    
    oPr:Say(1420,1150,strzero(cC15,5),oFont18N)    
    oPr:Say(1420,2850,strzero(cC15,5),oFont18N)    


    oPr:Say(1550,0120,OemtoAnsi("Classe Funcional:"), oFont08)    
    oPr:Say(1550,1740,OemtoAnsi("Classe Funcional:"), oFont08)    
    oPr:Say(1550,0560,OemtoAnsi("Vinculo:"), oFont08)    
    oPr:Say(1550,2260,OemtoAnsi("Vinculo:"), oFont08)    
    oPr:Say(1550,1090,OemtoAnsi("Indicacao Suplementar:"), oFont08)    
    oPr:Say(1550,2800,OemtoAnsi("Indicacao Suplementar:"), oFont08)    

    oPr:Say(1610,0170,OemtoAnsi("1"),oFont18N)    
    oPr:Say(1610,1820,OemtoAnsi("1"),oFont18N)    

    oPr:Say(1610,0650,OemtoAnsi("V"),oFont18N)    
    oPr:Say(1610,2350,OemtoAnsi("V"),oFont18N)    

    oPr:Say(1610,1150,OemtoAnsi("1S"),oFont18N)    
    oPr:Say(1610,2850,OemtoAnsi("1S"),oFont18N)    

    oPr:Say(1760,0120,OemtoAnsi("Tipo de Veiculo:"), oFont08)    
    oPr:Say(1760,1740,OemtoAnsi("Tipo de Veiculo:"), oFont08)    
    oPr:Say(1760,0900,OemtoAnsi("Ponto de Entrega:"), oFont08)    
    oPr:Say(1760,2460,OemtoAnsi("Ponto de Entrega:"), oFont08)    

    oPr:Say(1800,0950,OemtoAnsi("G.08-FILE"),oFont18N)    
    oPr:Say(1800,2650,OemtoAnsi("G.08-FILE"),oFont18N)    

    oPr:Say(1950,0120,OemtoAnsi("Embarque Controlado:"), oFont08)    
    oPr:Say(1950,1740,OemtoAnsi("Embarque Controlado:"), oFont08)    
    oPr:Say(1950,0560,OemtoAnsi("Lote Sob Desvio:"), oFont08)    
    oPr:Say(1950,2260,OemtoAnsi("Lote Sob Desvio:"), oFont08)    
    oPr:Say(1950,1090,OemtoAnsi("DUM:"), oFont08)    
    oPr:Say(1950,2800,OemtoAnsi("DUM"), oFont08)    

    oPr:Say(2000,0170,OemtoAnsi("NAO"),oFont18N)    
    oPr:Say(2000,1820,OemtoAnsi("NAO"),oFont18N)    

    oPr:Say(2000,0650,OemtoAnsi("PWT815"),oFont18N)    
    oPr:Say(2000,2350,OemtoAnsi("PWT815"),oFont18N)    
    
    oPr:Say(2160,0750,OemtoAnsi("Localizacao:"), oFont08)    
    oPr:Say(2160,2400,OemtoAnsi("Localizacao:"), oFont08)    

    oPr:Say(2200,0400,OemtoAnsi("Lote Sob Desvio"), oFont08)    
    oPr:Say(2200,1000,OemtoAnsi("Linha"), oFont08)    
    
    oPr:Say(2200,1850,OemtoAnsi("Lote Sob Desvio"), oFont08)    
    oPr:Say(2200,2700,OemtoAnsi("Linha"), oFont08)    

    
                                                          
	oPr:Preview()
	oPr:End()

    Next
    DbSelectArea("TMP")
    DbCloseArea()
    MS_FLUSH()
 
          
Return(.T.)

//-----------------------------------------------------------------------------------------------------
// GERANDO DADOS ARQUIVO TMP
//-----------------------------------------------------------------------------------------------------
Static Function Gerando()
   cQuery := "SELECT D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_ITEM,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,F1.F1_TIPO,"
   cQuery += "B5.B5_QE1,B5.B5_EMB1,QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI," 
   cQuery += "B1.B1_CODAP5," 
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
   cQuery += " FROM " + RetSqlName( 'SD1' ) +" D1, " + RetSqlName( 'SF1' ) +" F1, " + RetSqlName( 'SB5' ) +" B5, "
   cQuery += RetSqlName( 'QEK' ) +" QEK, " +  RetSqlName( 'SB1' ) + " B1 "
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
   cQuery += " AND D1.D1_COD *= B1.B1_COD"	   
   cQuery += " AND B1.D_E_L_E_T_ = ' ' "
   cQuery += " AND QEK.D_E_L_E_T_ = ' ' "
   cQuery += " AND D1.D_E_L_E_T_ = ' ' "   
   cQuery += " AND F1.D_E_L_E_T_ = ' ' "   
   cQuery += "GROUP BY D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,"
   cQuery += "D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_ITEM,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,"
   cQuery += "F1.F1_TIPO,B1.B1_CODAP5,"
   cQuery += "B5.B5_QE1,B5.B5_EMB1,QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI" 
   cQuery += " ORDER BY D1.D1_PEDIDO,D1.D1_ITEMPC ASC"
    MemoWrit('C:\TEMP\ETQFIAT.SQL',cQuery)
   // Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"

Return

//----------------------------------------------------------------------------------
//                                   Ajusta SX1                                                                                  
//----------------------------------------------------------------------------------

Static Function AjustaSX1()
SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := "EST004"
aRegs   := {}
aadd(aRegs,{cPerg,"01","Nota             ?","Nota             ?","Nota             ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Serie            ?","Serie            ?","Serie            ?","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Fornecedor       ?","Fornecedor       ?","Fornecedor       ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})        
aadd(aRegs,{cPerg,"06","Loja             ?","Loja             ?","Loja             ?","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})        

cUltPerg := aRegs[Len(aRegs)][2]

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
dbSelectArea(_sAlias)
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

