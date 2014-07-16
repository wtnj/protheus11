/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE112  ºAutor  ³Marcos R. Roquitski º Data ³  05/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta de Contrato de Trabalho.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhgpe112()

   SetPrvt("lRet,aEtiq")

   If !Pergunte('GPE055',.T.)
      Return(nil)
   Endif   

	Processa({|| Gerando() },"Gerando Dados para a Impressao")
	Processa({|| ImpEtiq() }, "Imprimindo etiquetas de contratos de trabalho")

Return(nil)


Static Function ImpEtiq()
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
        
	oFonteG1 := TFont():New("Arial",,08,,.t.,,,,,.f.)
	oFonteG2 := TFont():New("Courier",,08,,.t.,,,,,.f.)
	oFonteG3 := TFont():New("Courier",,07,,.t.,,,,,.f.)
	oPr := tAvPrinter():New("Protheus")
	oPr:StartPage()
	aEtiq := {}
	    
	TMP->(DbGoTop())
	ProcRegua(TMP->(RecCount()))
	While TMP->(!Eof())
		AADD(aEtiq,{TMP->RA_CODFUNC +" - "+TMP->RJ_DESC,TMP->RA_CBO,TMP->RA_ADMISSA,TMP->RA_MAT,TMP->RA_SALARIO,TMP->RA_CATFUNC})
		TMP->(Dbskip())
	Enddo
   

	For m := 1 To Len(aEtiq)

		cC11 := Space(30)       // Cargo
		cC12 := Space(10)       // CBO
		cC13 := Ctod(Space(08)) // Data de Emissao
		cC14 := Space(06)       // Matricula
		cC15 := 0               // Salario
		cC16 := Space(01)       // Categoria de pagamento

		    
		cC21 := Space(30)
		cC22 := Space(10)
		cC23 := Ctod(Space(08))
		cC24 := Space(06)    
		cC25 := 0
		cC26 := Space(01) 
		
		cC31 := Space(30)
		cC32 := Space(10)
		cC33 := Ctod(Space(08))            
		cC34 := Space(06)    
		cC35 := 0
		cC36 := Space(01) 
           

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
         
		If (m + 1) <= Len(aEtiq)
			cC31 := aEtiq[m+1,1]
			cC32 := aEtiq[m+1,2] 
			cC33 := aEtiq[m+1,3]  
			cC34 := aEtiq[m+1,4] 			
			cC35 := aEtiq[m+1,5] 			
			cC36 := aEtiq[m+1,6] 			
		Endif
		m++
            
		oPr:Say(nLin+050, 050,"Empregador:",oFonteG1)
		oPr:Say(nLin+050, 210,SM0->M0_NOMECOM,oFonteG2)
		oPr:Say(nLin+050, 880,"Empregador:",oFonteG1)
		oPr:Say(nLin+050,1040,SM0->M0_NOMECOM,oFonteG2)
		oPr:Say(nLin+050,1690,"Empregador:",oFonteG1)
		oPr:Say(nLin+050,1870,SM0->M0_NOMECOM,oFonteG2)				


		oPr:Say(nLin+100,  50,"CGC.............:",oFonteG1)
		oPr:Say(nLin+100, 210,TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFonteG2)
		oPr:Say(nLin+100, 880,"CGC.............:",oFonteG1)
		oPr:Say(nLin+100,1040,TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFonteG2)
		oPr:Say(nLin+100,1690,"CGC.............:",oFonteG1)
		oPr:Say(nLin+100,1870,TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFonteG2)
		

		oPr:Say(nLin+150,  50,"Endereco..:",oFonteG1)
		oPr:Say(nLin+150, 210,SM0->M0_ENDCOB,oFonteG2)
		oPr:Say(nLin+150, 880,"Endereco..:",oFonteG1)
		oPr:Say(nLin+150,1040,SM0->M0_ENDCOB,oFonteG2)
		oPr:Say(nLin+150,1690,"Endereco..:",oFonteG1)
		oPr:Say(nLin+150,1870,SM0->M0_ENDCOB,oFonteG2)


		oPr:Say(nLin+200,  50,"Municipio.:",oFonteG1)
		oPr:Say(nLin+200, 210,SM0->M0_CIDCOB+" UF: "+SM0->M0_ESTCOB,oFonteG2)
		oPr:Say(nLin+200, 880,"Municipio.:",oFonteG1)
		oPr:Say(nLin+200,1040,SM0->M0_CIDCOB+" UF: "+SM0->M0_ESTCOB,oFonteG2)
		oPr:Say(nLin+200,1690,"Municipio.:",oFonteG1)
		oPr:Say(nLin+200,1870,SM0->M0_CIDCOB+" UF: "+SM0->M0_ESTCOB,oFonteG2)


		oPr:Say(nLin+250,  50,"Esp. do Estabelimento:",oFonteG1)
		oPr:Say(nLin+250, 340,"INDUSTRIA",oFonteG2)
		oPr:Say(nLin+250, 880,"Esp. do Estabelicimento:",oFonteG1)
		oPr:Say(nLin+250,1180,"INDUSTRIA",oFonteG2)
		oPr:Say(nLin+250,1690,"Esp. do Estabelecimento:",oFonteG1)
		oPr:Say(nLin+250,1990,"INDUSTRIA",oFonteG2)



		oPr:Say(nLin+350,  50,"Cargo..: ",oFonteG1)
		oPr:Say(nLin+350, 210,cC11,oFonteG2)
		oPr:Say(nLin+350, 880,"Cargo..: ",oFonteG1)
		oPr:Say(nLin+350,1040,cC21,oFonteG2)
		oPr:Say(nLin+350,1690,"Cargo..: ",oFonteG1)
		oPr:Say(nLin+350,1870,cC31,oFonteG2)

		oPr:Say(nLin+400,  50,"CBO No.: ",oFonteG1)
		oPr:Say(nLin+400, 210,cC12,oFonteG2)
		oPr:Say(nLin+400, 880,"CBO No.: ",oFonteG1)
		oPr:Say(nLin+400,1040,cC22,oFonteG2)
		oPr:Say(nLin+400,1690,"CBO No.: ",oFonteG1)
		oPr:Say(nLin+400,1870,cC32,oFonteG2)


		oPr:Say(nLin+450,  50,"Data de Admissao:",oFonteG1)
		oPr:Say(nLin+450, 280,DTOC(cC13),oFonteG2)
		oPr:Say(nLin+450, 880,"Data de Admissao:",oFonteG1)
		oPr:Say(nLin+450,1110,DTOC(cC23),oFonteG2)
		oPr:Say(nLin+450,1690,"Data de Admissao:",oFonteG1)
		oPr:Say(nLin+450,1930,DTOC(cC33),oFonteG2)
		
		oPr:Say(nLin+500,  50,"Registro No.",oFonteG1)
		oPr:Say(nLin+500, 210,cC14,oFonteG2)
		
		oPr:Say(nLin+500, 880,"Registro No.",oFonteG1)
		oPr:Say(nLin+500,1040,cC24,oFonteG2)

		oPr:Say(nLin+500,1690,"Registro No.",oFonteG1)
		oPr:Say(nLin+500,1870,cC34,oFonteG2)

		oPr:Say(nLin+550,  50,"Renumeracao:",oFonteG1)
		oPr:Say(nLin+550, 220,"R$"+TRANSFORM(cC15,"@E 99,999.99")+" P\"+IIF(cC16=="M","MES","HORA"),oFonteG2)
		oPr:Say(nLin+580,  50,"("+Extenso(cC15)+" P\"+IIF(cC16=="M","MES","HORA")+" )",oFonteG3)

		oPr:Say(nLin+550, 880,"Renumeracao:",oFonteG1)
		oPr:Say(nLin+550,1050,"R$"+TRANSFORM(cC25,"@E 99,999.99")+" P\"+IIF(cC26=="M","MES","HORA"),oFonteG2)
		oPr:Say(nLin+580, 880,"("+Extenso(cC25)+" P\"+IIF(cC26=="M","MES","HORA")+" )",oFonteG3)

		oPr:Say(nLin+550,1690,"Renumeracao:",oFonteG1)
		oPr:Say(nLin+550,1870,"R$"+TRANSFORM(cC35,"@E 99,999.99")+" P\"+IIF(cC36=="M","MES","HORA"),oFonteG2)
		oPr:Say(nLin+580,1690,"("+Extenso(cC35)+" P\"+IIF(cC36=="M","MES","HORA")+" )",oFonteG3)

		nLin += 920 
		nPag++
         
		If nPag >= 3
			oPr:EndPage()
			oPr:StartPage()
			nLin := 160 
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
	cQuery  := "SELECT * FROM " + RetSqlName( 'SRA' ) + " RA, " + RetSqlName( 'SRJ' ) + " RJ "
	cQuery  := cQuery + " WHERE RA.RA_SITFOLH <> 'D'"
	cQuery  := cQuery + " AND RA.RA_CODFUNC = RJ.RJ_FUNCAO "
	cQuery  := cQuery + "AND RA.RA_MAT BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
	cQuery  := cQuery + "ORDER BY RA.RA_MAT"
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.	
Return
                                     