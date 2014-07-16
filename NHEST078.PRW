/*                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST078        ³ Fabio Willian Nico    ³ Data ³ 06/09/06 ³±±
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

User Function NHEST078()    
SetPrvt("cEmbalagem,nQtdeEmb,cCodPro,aEtiq,cPorta,_CODBARRA")
	cPorta      := "LPT1"     
AjustaSx1()

If !Pergunte('EST004',.T.)
   Return(nil)
Endif                        

If !IsPrinter(cPorta)
	alert("erro na porta")
    Return
Endif

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
    
	_CodBar := substr(_cod2,0,11)+strzero(cC15,5)+'FZA011109'

	MSCBPRINTER("S600","LPT1",,20,.f.,,,)   // 20= ALTURA DA ETIQUETA
	MSCBCHKSTATUS(.f.)
	MSCBBEGIN(1,4,50)
                                                                          
    MSCBBOX(02,05,96,135)
	MSCBSAY(15,07,"FPT","N","A","032,035")    
	MSCBSAY(55,10,"WHB","N","A","032,035")    
    MSCBSAY(10,15,"POWERTRAIN TECNOLOGIES","N","A","012,008")
        
    MSCBLineH(02,020,96,3)
    MSCBSAY(05,21,"DATA","N","A","015,008")
    MSCBSAY(50,21,"COD.FORNECEDOR","N","A","015,008")
    MSCBSAY(05,24,DTOC(STOD(cC11)),"N","0","032,035") 
	MSCBSAY(52,24,'011109',"N","0","032,035")     
    
    MSCBLineH(02,030,96,3)
    MSCBSAY(05,31,"Denominacao","N","A","015,008")
    MSCBSAY(50,31,"N.Doc.Fiscal(BAM)","N","A","015,008")
	MSCBSAY(05,34,cC13,"N","A","015,008")     
	MSCBSAY(52,34,cC14,"N","0","032,035")     
	    
    MSCBLineH(02,040,96,3)
	MSCBSAY(05,41,"Desenho","N","A","015,008")
	MSCBSAY(05,45,_cod2,"N","A","032,035")
    MSCBSAYBAR(05,50,_CodBar,"N","3",10,,,,,2,2,,,,)    
    
    MSCBLineH(02,065,96,3)
    MSCBSAY(05,66,"Data Prod. do Lote","N","A","015,008")
	MSCBSAY(50,66,"Codigo da Embalagem","N","A","015,008")
	MSCBSAY(55,69,"FZA","N","0","032,035")     
		
    MSCBLineH(02,075,96,3)            
	MSCBSAY(05,76,"No.Lote","N","A","012,008")
	MSCBSAY(32,76,"Quant do Lote","N","A","012,008")
	MSCBSAY(62,76,"Quant da Embalagem","N","A","012,008")    
	MSCBSAY(65,79,strzero(cC15,5),"N","0","032,035")     

    MSCBLineH(02,085,96,3) 
	MSCBSAY(05,86,"Classe Funcional","N","A","012,008")
	MSCBSAY(32,86,"Vinculo","N","A","012,008")
	MSCBSAY(62,86,"Indicacao Suplementar","N","A","012,008")    
	MSCBSAY(35,89,"V","N","0","032,035")     
		
	MSCBLineH(02,095,96,3)
	MSCBSAY(05,96,"Tipo de Veiculo","N","A","015,008")
	MSCBSAY(50,96,"Ponto de Entrega","N","A","015,008")
		
	MSCBLineH(02,105,96,3)         
	MSCBSAY(05,106,"Embarque Controlado","N","A","012,008")
	MSCBSAY(42,106,"Lote Sob Desvio","N","A","012,008")
	MSCBSAY(72,106,"DUM","N","A","012,008")    
	MSCBSAY(45,110,"NAO","N","0","032,035")     	
	
	MSCBLineH(02,115,96,3) 
	MSCBSAY(40,116,"Localizacao","N","A","015,008")
	MSCBSAY(15,120,"Almoxarifado","N","A","015,008")
	MSCBSAY(65,120,"Linha","N","A","015,008")
	MSCBLineV(48,05,40)
	MSCBLineV(48,65,75)
	MSCBLineV(30,75,95)
	MSCBLineV(60,75,95)
	MSCBLineV(48,95,105)	
	MSCBLineV(40,105,115)
	MSCBLineV(70,105,115)
    MSCBBOX(04,123,46,130)	
    MSCBBOX(50,123,94,130)    

    MSCBEND()                                                                 
    MSCBClosePrinter()      
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
   cQuery += "         FROM " +RetSqlName('SA2') +" A2 (NOLOCK) " 
   cQuery += "         WHERE A2.D_E_L_E_T_ = ' ' AND A2.A2_COD = D1.D1_FORNECE  AND A2.A2_FILIAL = '" + xFilial("SA2")+ "'"
   cQuery += "         AND A2.A2_LOJA = D1.D1_LOJA) "
   cQuery += "   ELSE "
   cQuery += "        (SELECT A1.A1_NREDUZ "
   cQuery += "         FROM " +RetSqlName('SA1') +" A1 (NOLOCK) " 
   cQuery += "         WHERE A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = D1.D1_FORNECE AND A1.A1_FILIAL = '" + xFilial("SA1")+ "'"
   cQuery += "         AND A1.A1_LOJA = D1.D1_LOJA) "
   cQuery += "END "   

   cQuery += " FROM " + RetSqlName( 'SD1' ) +" D1 (NOLOCK) "
   
   cQuery += "INNER JOIN " + RetSqlName( 'SF1' ) +" F1 (NOLOCK) ON "
   cQuery += "F1.F1_FILIAL =  D1.D1_FILIAL "
   cQuery += "AND F1.F1_DOC = D1.D1_DOC AND F1.F1_SERIE = D1.D1_SERIE"
   cQuery += "AND F1.F1_FORNECE = D1.D1_FORNECE " 
   cQuery += "AND F1.F1_LOJA = D1.D1_LOJA "
   cQuery += "AND F1.F1_DTDIGIT = D1.D1_DTDIGIT "
   cQuery += "AND F1.D_E_L_E_T_ = ' ' "              

   cQuery += "INNER JOIN " + RetSqlName( 'SB1' ) +" B1 (NOLOCK) ON "
   cQuery += "B1.B1_FILIAL = '" + xFilial("SB1")+ "'"
   cQuery += "AND D1.D1_COD = B1.B1_COD "	   
   cQuery += "AND B1.D_E_L_E_T_ = ' ' "

   cQuery += "LEFT JOIN " + RetSqlName( 'SB5' ) +" B5 (NOLOCK) ON "   
   cQuery += "B5.B5_FILIAL = '" + xFilial("SB5")+ "'"
   cQuery += "AND D1.D1_COD = B5.B5_COD AND B5.D_E_L_E_T_ = ' ' "   

   cQuery += "LEFT JOIN " + RetSqlName( 'QEK' ) +" QEK (NOLOCK) ON "   
   cQuery += "QEK.QEK_FILIAL = '" + xFilial("QEK")+ "'"
   cQuery += "AND QEK.D_E_L_E_T_ = ' ' "   
   cQuery += "AND D1.D1_DOC = QEK.QEK_NTFISC AND D1.D1_SERIE = QEK.QEK_SERINF "
   cQuery += "AND D1.D1_COD = QEK.QEK_PRODUT AND D1.D1_FORNECE = QEK.QEK_FORNEC " 
   cQuery += "AND D1.D1_LOJA = QEK.QEK_LOJFOR AND D1.D1_DTDIGIT = QEK.QEK_DTENTR "
   cQuery += "AND D1.D1_QUANT = QEK.QEK_TAMLOT " 

   cQuery += " WHERE D1.D1_FILIAL = '" + xFilial("SD1")+ "' "
   cQuery += " AND D1.D1_DTDIGIT BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "' "
   cQuery += " AND D1.D1_DOC = '" + mv_par01 + "' AND D1.D_E_L_E_T_ = '' "
   cQuery += " AND D1.D1_SERIE = '" + Mv_par02 + "' "
   cQuery += " AND D1.D1_FORNECE = '" + mv_par05 + "' "
   cQuery += " AND D1.D1_LOJA = '" + mv_par06 + "' "

   cQuery += "GROUP BY D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,"
   cQuery += "D1.D1_PEDIDO,D1.D1_ITEMPC,D1.D1_ITEM,"
   cQuery += "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,"
   cQuery += "F1.F1_TIPO,B1.B1_CODAP5,"
   cQuery += "B5.B5_QE1,B5.B5_EMB1,QEK.QEK_NTFISC,QEK.QEK_SERINF,QEK.QEK_FORNEC,QEK.QEK_LOJFOR,QEK.QEK_VERIFI" 
   cQuery += " ORDER BY D1.D1_PEDIDO,D1.D1_ITEMPC ASC"
//    MemoWrit('C:\TEMP\ETQFIAT.SQL',cQuery)
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

