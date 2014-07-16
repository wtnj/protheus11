/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST017        ³ Alexandre R. Bento    ³ Data ³ 21.09.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da Relação do RMR(relatorio mensal de refugo)   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "Rwmake.ch"      
#include "Topconn.ch"

User Function NhEst017()  

cString   :="SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o ")
cDesc2    := OemToAnsi("Relatorio Mensal de Refugo")
cDesc3    := OemToAnsi(" ")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST017"
nLastKey  := 0
titulo    :="RELATORIO MENSAL DE REFUGO"
Cabec1    :=""
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1              //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST017"      //Nome Default do relatorio em Disco
_cPerg    := "EST017"       //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
aRMR      := {}          
nTotRef   := 0
cLocal    := " "
cFornece  := " "
cLoja     := " "
cCod      := " "                               
lOK       := .F.
_num	  := 1     
aQtdEstru := {}
nTotProd  := 0

	// Parametros Utilizados
	// mv_par01 = Data de emisao inicial
	// mv_par02 = Data de emisao final
	// mv_par03 = codigo do produto inicial
	// mv_par04 = codigo do produto final
	// mv_par05 = Operacao inicial
	// mv_par06 = Operacao final
	// mv_par07 = Fornecedor inicial
	// mv_par08 = Fornecedor final
	// mv_par09 = Loja inicial
	// mv_par10 = Loja final
	// mv_par11 = Gera Numeração (Sim/Nao)
	
	pergunte(_cPerg,.F.)
	
	SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 

	If nLastKey == 27
	    Set Filter To
	    Return
	Endif
	
	SetDefault(aReturn,cString)
             
	nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
	
	//VALIDACAO DO MES

	/*
	If Month(mv_par01) <> Month(mv_par02)
	   MsgBox(OemToAnsi("Atenção Relatório só pode sair dentro do mês","Refugo","STOP"))
	EndIf
    */
    
	Processa( {|| Gerando()  },"Gerando Dados") //se não existe gera os dados
	Processa( {|| fGerar()   },"Gerando Dados para a Impressao") //se não existe gera os dados	

	If Empty(TMP->D3_COD)
	   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
	   DbSelectArea("TMP")
	   DbCloseArea()
	   Return
	Endif  

	Processa( {|| fVerifi()  },"Gerando Dados para a Impressao")	//verifica se RMR já existe
		
	TMP->(DbgoTop())

	If Select("TRC") > 0
	   TRC->(DbCloseArea())	     
	Endif

    Processa( {|| RptDetail() },"Imprimindo...") //nao existe na tabela zac e zab
    
	If Select("TMP") > 0
	   TMP->(DbCloseArea())	     
	Endif
		
	Set Filter To
	If aReturn[5] == 1
		Set Printer To
		Commit
	   ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool

	Return

Return

Static Function Gerando()
Local cQuery1   

	//-- PEGA A PRODUCAO
	/*
	cAliasSD3 := GetNextAlias()	            

	BeginSql Alias cAliasSD3    
		SELECT SD3.D3_COD,SUM(SD3.D3_QUANT) AS D3_QUANT 
		FROM %Table:SD3% SD3 (NOLOCK)
		WHERE 
		SD3.D3_COD = %Exp:(mv_par03)% AND	     
		SD3.D3_EMISSAO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:Dtos(mv_par02)% AND
		SD3.D3_CF		= 'PR0' AND  //So busca apontamento de produção
		SD3.D3_ESTORNO = ' ' AND
		SD3.%NotDel% AND	    
		SD3.D3_FILIAL 	= %xFilial:SD3% 
		GROUP BY SD3.D3_COD
		ORDER BY SD3.D3_COD
	EndSql
	     	
	(cAliasSD3)->(Dbgotop())
	
	While (cAliasSD3)->(!Eof()) 
	   nTotProd += (cAliasSD3)->D3_QUANT
	   (cAliasSD3)->(Dbskip())
	Enddo
	
	(cAliasSD3)->(DbCloseArea()) //Fecha area aberta
	*/

	cAliasZAU := GetNextAlias()	            

	BeginSql Alias cAliasZAU

		SELECT 
			SUM(ZAG_EMBAL1+ZAG_EMBAL2+ZAG_EMBAL3) quant 
		FROM 
			%Table:ZAG% ZAG (NOLOCK),
			%Table:ZAU% ZAU (NOLOCK)
		WHERE
			ZAG_NUM = ZAU_NUM
			AND ZAU_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:Dtos(mv_par02)%
			AND ZAG_PROD = %Exp:(mv_par03)%
			AND ZAG.%NotDel%
			AND ZAU.%NotDel%
		
	ENDSQL
	
	nTotProd := Iif( (cAliasZAU)->(!Eof()),(cAliasZAU)->quant,0)
	
	(cAliasZAU)->(DbCloseArea()) //Fecha area aberta
	
   cQuery1 := "SELECT SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT,SG1.G1_OPERACA"
   cQuery1 += " FROM " + RetSqlName( 'SG1' ) +" SG1 (NOLOCK),"+ RetSqlName( 'SB1' ) +" SB1 (NOLOCK)"
   cQuery1 += " WHERE G1_FILIAL = '" + xFilial("SG1")+ "'"   
   cQuery1 += " AND B1_FILIAL = '" + xFilial("SB1")+ "'"         
   cQuery1 += " AND SG1.G1_COD = '" + mv_par03 + "'" // PA
   cQuery1 += " AND SG1.G1_FIM >= '" + DTOS(mv_par02) + "' "
   cQuery1 += " AND SG1.G1_COMP = SB1.B1_COD"                		
   cQuery1 += " AND SUBSTRING(SG1.G1_COMP,7,1) <> '6'"
   cQuery1 += " AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD'"        
   cQuery1 += " AND SG1.D_E_L_E_T_ = ' ' "   
   cQuery1 += " AND SB1.D_E_L_E_T_ = ' ' "      
   cQuery1 += " ORDER BY SG1.G1_COMP ASC" 
   MemoWrit('C:\TEMP\EST017E.SQL',cQuery1)
   TCQUERY cQuery1 NEW ALIAS "TMPA"   
   
   TMPA->(Dbgotop())   
   If !Empty(TMPA->G1_COMP)   
      While TMPA->(!Eof())   

         aAdd(aQtdEstru,{TMPA->G1_COMP,TMPA->G1_QUANT,STRZERO(TMPA->G1_OPERACA,3)})
         TMPA->(Dbskip())

      Enddo

   Endif   
   TMPA->(DbCloseArea())	

Return                                   

Static Function fGerar()
	
	cQuery := " SELECT SD3.D3_COD,SD3.D3_TM,MONTH(SD3.D3_EMISSAO) AS 'MES',YEAR(SD3.D3_EMISSAO),SD3.D3_LOCAL,"
	cQuery += " SD3.D3_OPERACA,SB1.B1_CODAP5,SB1.B1_DESC,SD3.D3_FORNECE,SD3.D3_LOJA,SUM(SD3.D3_QUANT) AS 'QTDE'" 
	cQuery += " FROM " + RetSqlName( 'SD3' ) +" SD3, " + RetSqlName( 'SB1' ) +" SB1"
	cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3")+ "'"
	cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
	cQuery += " AND SD3.D3_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND  '" + DtoS(mv_par02) +"'"   
    cQuery += " AND SD3.D3_COD = '" + mv_par04 + "'" // PRODUTO BRUTO
	cQuery += " AND SD3.D3_OPERACA BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'" 
	cQuery += " AND SD3.D3_FORNECE BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'" 
	cQuery += " AND SD3.D3_LOJA BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'" 
	cQuery += " AND SD3.D3_COD = SB1.B1_COD AND SD3.D3_TM IN ('499','002') "
    
    If SM0->M0_CODIGO == "NH"			
	   cQuery += " AND SD3.D3_LOCAL IN ('99','00')"  
	   cQuery += " AND SD3.D3_LOCORIG NOT IN ('02','03') "
	ElseIf SM0->M0_CODIGO == "FN"			
	   cQuery += " AND SD3.D3_LOCAL IN ('39','30','59','50')"  
	   cQuery += " AND SD3.D3_LOCORIG NOT IN ('22') "
	Endif
	
	cQuery += " AND SD3.D_E_L_E_T_ = ' '"
	cQuery += " AND SB1.D_E_L_E_T_  = ' ' AND SD3.D3_ESTORNO <> 'S'" 
	cQuery += " GROUP BY SD3.D3_COD,SD3.D3_TM,MONTH(SD3.D3_EMISSAO),YEAR(SD3.D3_EMISSAO),SD3.D3_LOCAL,SD3.D3_OPERACA,SB1.B1_CODAP5,SB1.B1_DESC,SD3.D3_FORNECE,SD3.D3_LOJA"
	cQuery += " ORDER BY SD3.D3_COD,MONTH(SD3.D3_EMISSAO),SD3.D3_FORNECE,SD3.D3_LOJA,SD3.D3_LOCAL,SD3.D3_OPERACA ASC"

	MemoWrit('C:\TEMP\EST017.SQL',cQuery)

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"     
	//TcSetField("TMP","D3_EMISSAO","D")  // Muda a data de string para date    
	TMP->(DbGoTop())	
	
Return

Static Function fVerifi()

Local _cCod   := Space(15) 
Local _cFor   := Space(06)
Local _cLoja  := Space(02)
Local _nTotal := 0
aRMR          := {}          

	titulo    += "  Data Inicial: "+Dtoc(mv_par01)+ " Ate " + Dtoc(mv_par02)
	
	ProcRegua(TMP->(RecCount()))                         
    SB1->(DbSetOrder(1))//filial + COD
	TMP->(DbGoTop())    
	
	While TMP->(!EoF())

	    //select para verificar se existe a RMR nas tabelas ZAC e ZAB
		
		cQuery2 := " SELECT * FROM " +RetSqlName ('ZAC') + " ZAC, " + RetSqlName('ZAB') + " ZAB "
		cQuery2 += " WHERE ZAB.ZAB_NUM = ZAC.ZAC_NUM"
		cQuery2 += " AND ZAB.D_E_L_E_T_  = ' '"		
		cQuery2 += " AND ZAC.D_E_L_E_T_  = ' '"
		cQuery2 += " AND ZAB.ZAB_COD = '"+TMP->D3_COD+"'"
		cQuery2 += " AND ZAC.ZAC_OPERAC = '"+TMP->D3_OPERACA+"'"                      
		cQuery2 += " AND ZAB.ZAB_FORNEC = '"+TMP->D3_FORNECE+"'"  
		cQuery2 += " AND ZAC.ZAC_LOCAL = '"+TMP->D3_LOCAL+"'"
		cQuery2 += " AND ZAB.ZAB_LOJA = '"+TMP->D3_LOJA+"'"                      				
		cQuery2 += " AND ZAB.ZAB_MESANO = '" + Substr(DtoS(mv_par01),5,2) + Substr(DtoS(mv_par01),1,4) + "'"
		cQuery2 += " ORDER BY ZAB_COD, ZAB_MESANO"

		TCQUERY cQuery2 NEW ALIAS "TRC"

		TRC->(DbGoTop())

     	If Empty(TRC->ZAB_NUM)
		    If _cCod <> TMP->D3_COD .And. _cFor <> TMP->D3_FORNECE .And. _cLoja <> TMP->D3_LOJA
		    
		        _cCod  := TMP->D3_COD
		        _cFor  := TMP->D3_FORNECE		        
		        _cLoja := TMP->D3_LOJA

			Endif	
			
  		    IncProc("Processando Produtos... " + TMP->D3_COD)
	        
		    Aadd(aRMR,{TMP->D3_COD,;
	    		 	   TMP->D3_LOCAL,;
		    		   TMP->D3_OPERACA,;
		    		   MesExtenso(TMP->MES),;
		    		   TMP->B1_CODAP5,;
		               TMP->B1_DESC,;
		               TMP->D3_FORNECE,;
		               TMP->D3_LOJA,;
		               TMP->QTDE,;
		               "N",;
		               0})

           		       nTotProd += TMP->QTDE
    	Else
	    
  		    IncProc("Processando Produtos... " + TRC->ZAB_COD)
	      	SB1->(DbSeek(xFilial("SB1")+TRC->ZAB_COD))

	      	Aadd(aRMR,{TRC->ZAB_COD,;
	      			   TRC->ZAC_LOCAL,;
	      			   TRC->ZAC_OPERAC,;
	      			   MesExtenso(Substr(TRC->ZAB_MESANO,1,2)),;
	      			   SB1->B1_CODAP5,;
		      		   SB1->B1_DESC,;
		      		   TRC->ZAB_FORNEC,;
		      		   TRC->ZAB_LOJA,;
		      		   TRC->ZAC_QUANT,;
		      		   TRC->ZAB_NUM,;
		      		   TRC->ZAB_QUANT})
	    EndIf
	    
        TRC->(DbCloseArea())	    
		TMP->(Dbskip())
	EndDo
Return

Static Function RptDetail()
Local _nx
Local _cProd := Space(15)
Local _cLoc  := Space(02)
Local _nQtde := 0

    If Len(aRMR) == 0
	   MsgBox("O Produto Bruto Digitado Nao Existe na Estrutura do Produto Acabado","Atencao","STOP")
	   Return
    Endif
    
    aRMR := ASort(aRMR,,, { |x, y| x[7]+X[8]+x[2] > y[7]+Y[8]+y[2]}) //Ordena a matriz por fornecedor+loja+almoxarifado  	
	
	ProcRegua(Len(aRMR))                         
	
	Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 

	SA2->(DbSetOrder(1)) //filial + fornece + loja
	ZAC->(DbSetOrder(1)) //filial + num
    
	cCod     := ''
	cFornece := ''
	cLoja    := ''
    cLocal   := ''
	_ARMCNEW := {}
	nRMR     := 0
	
	For _x:= 1 to Len(aRMR)
       
		IncProc(aRMR[_x][1])
		
		If PROW() > 60
	        _NPAG := _NPAG + 1
	    	CABEC(TITULO, CABEC1, CABEC2,NOMEPROG, TAMANHO, NTIPO)        
	    Endif

		If cFornece+cLoja <> aRMR[_x][7]+aRMR[_x][8]
    
		    SB1->(DbSeek(xFilial("SB1")+mv_par04))
			@ Prow() + 1, 001 Psay "Codigo : " + SB1->B1_COD +"  Desenho: " +AllTrim(SB1->B1_CODAP5)+ " - " + SB1->B1_DESC
		
			SA2->(Dbseek(xfilial("SA2")+aRMR[_x][7]+aRMR[_x][8]))
			@ Prow() + 1, 001 Psay "Fornecedor: " + aRMR[_x][7] + " - " + aRMR[_x][8] + " - " + Subs(Alltrim(SA2->A2_NOME),1,30)
			/*
			cAl := getnextalias()
			
			beginSql Alias cAl
				SELECT TOP 1 ZAB_NUM  AS NUM
				FROM ZABFN0 
				WHERE ZAB_COD = %Exp:SB1->B1_COD%
				AND ZAB_MESANO=%Exp:'102011'%
				AND ZAB_FORNEC = %Exp:aRMR[_x][7]%
				AND ZAB_LOJA = %Exp:aRMR[_x][8]%
				AND %NotDel% 
				ORDER BY R_E_C_N_O_ DESC
			endSQl
			
			If !Empty((cAl)->NUM) .and. aRMR[_x][10] == "N"
				nRMR := Val((cAl)->NUM)
			Else
			*/
			If aRMR[_x][10] <> "N" //RMR já existente
				nRMR :=  Val(aRMR[_x][10])
			Else
			
			    If Mv_par11 == 1
		
					nRMR := Val(GetMv("MV_RMR"))+1 //Pega o numero da RMR mais 1
				
					//Grava a proximo numero    
					SX6->(DbSeek(xFilial('SX6')+"MV_RMR"))
					RecLock("SX6",.F.)
					    SX6->X6_CONTEUD:= Alltrim(StrZero(nRMR))
					MsUnlock("SX6")	
					
					If Day(mv_par01) == 1 .And. Day(UltimoDia(mv_par02)) == Day(mv_par02) .And. Mv_par11 == 1
		
					    RecLock("ZAB",.T.)    //Abre tabela ZAB para gravação
					    	ZAB->ZAB_FILIAL := xFILIAL("ZAB")
							ZAB->ZAB_NUM    := Alltrim(StrZero(nRMR,6))
							ZAB->ZAB_COD    := SB1->B1_COD ///aRMR[_x][1] //Codigo do PA
							ZAB->ZAB_MESANO := StrZero(month(mv_par01),2) + Strzero(Year(mv_par01),4)
							ZAB->ZAB_QUANT  := nTotProd //qtde produzida
							ZAB->ZAB_FORNEC := aRMR[_x][7] //fornecedor
							ZAB->ZAB_LOJA   := aRMR[_x][8] //loja
						MsUnLock("ZAB")
					EndIf
					
		 		EndIf
			EndIf
			
			//(cAL)->(DBCLOSEAREA())            

		 	@ Prow() , 100 Psay "Numero da RMR : " + STRZERO(nRMR,6)
			@ Prow() + 1, 001 Psay OemToAnsi("Mês : ") + aRMR[_x][4] +" / " +StrZero(Year(mv_par01),4)+Space(20)+"Material Consignado" 
			@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina
			@ Prow() + 2, 001 Psay OemToAnsi("Total de Peças Produzidas   : ") + Transform(nTotProd,"@E 999,999")
		
			cCod     := aRMR[_x][1]
			cFornece := aRMR[_x][7]
			cLoja    := aRMR[_x][8]
	        cLocal   := " "//aRMR[_x][2]
        
			_num := 1   		
   	
		EndIf
		
		While ( _x <= len(aRMR) .and. cFornece+cLoja == aRMR[_x][7]+aRMR[_x][8] )
	
			IF cLocal <> aRMR[_x][2]
       			cLocal := aRMR[_x][2]
	        	
                If SM0->M0_CODIGO == "NH"
		    		If cLocal == '00'
			    		cFunUsi := "FUNDIDO"
			    	ElseIf cLocal == '99'
			    		cFunUsi := "USINAGEM"
			    	Endif
				ElseIf SM0->M0_CODIGO == "FN"				        	 
		    		IF cLocal$'30/50'
			    		cFunUsi := "FUNDIDO"
			    	ElseIf cLocal$'39/59'
			    		cFunUsi := "USINAGEM"
			    	Endif
				Endif
		
	    		@ PROW() + 2, 001 PSAY OEMTOANSI("TOTAL DE REFUGO DE "+cFunUsi+" : ")

   			Endif    		

   			While( _x <= len(aRMR) .and. cLocal==aRMR[_x][2] .and. cFornece+cLoja == aRMR[_x][7]+aRMR[_x][8])
   			
	   			If aRMR[_x][10] == "N" //rmr nao existe
					IF DAY(MV_PAR01) == 1 .AND. DAY(ULTIMODIA(MV_PAR02)) == DAY(MV_PAR02) .AND. MV_PAR11 == 1
						RECLOCK("ZAC",.T.)
					    	ZAC->ZAC_FILIAL := XFILIAL("ZAC")
				  			ZAC->ZAC_NUM    := ALLTRIM(STRZERO(nRMR,6))	      
					    	ZAC->ZAC_ITEM   := STRZERO(_num,4) //ITEM
						    ZAC->ZAC_LOCAL  := aRMR[_X][2] //ALMOXARIFADO
						    ZAC->ZAC_OPERAC := aRMR[_X][3] //NUMERO OPERACAO
						    ZAC->ZAC_QUANT  := aRMR[_X][9] //QTDE OPERACAO
						MSUNLOCK("ZAC") 
					ENDIF
	
					_num++
	
				EndIf

				//-- MONTA O ARRAY COM OS COMPONENTES
				For x:=1 to Len(aQtdEstru)
					If aRMR[_x][3] >= aQtdEstru[x][3] 
						aAdd( _aRMCNew, { cLocal, aQtdEstru[x][1] , aQtdEstru[x][2] * aRMR[_x][9], aQtdEstru[x][3] })
					Endif
				Next

                @ PROW() +1, 015 PSAY OEMTOANSI("OPERAÇÃO  ") +aRMR[_x][3] + " : "  + TRANSFORM(aRMR[_x][9],"@E 999,999")
  			
   				nTotRef += aRMR[_x][9]

   				_x++
   				
   			EndDo
   			
    		IF nTotRef > 0
	       		@ PROW() + 1, 023 PSAY "TOTAL : "+ TRANSFORM(nTotRef,"@E 999,999")
	           	nTotRef := 0
         	ENDIF

			If ( _x <= len(aRMR) .and. cFornece+cLoja <> aRMR[_x][7]+aRMR[_x][8] ) .or. _x > len(aRMR)
			
			    fRodape(Prow())
			    
				fComp(aRMR[_x-1])
			
			EndIf
				
		EndDo
	Next	

RETURN(NIL)                        	

Static Function fComp(aDados)
                                                                            
titulo  :="LISTA DE COMPONENTES DA RMR  Data Inicial: "+Dtoc(mv_par01)+ " Ate " + Dtoc(mv_par02)
_NPAG   := 1
NTOTREF := 0

	ProcRegua(Len(_aRMCNew))
	
	Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 

	SA2->(DbSetOrder(1)) //filial + fornece + loja
	ZAC->(DbSetOrder(1)) //filial + num

	_xCom:= 1
        
	_num := 1
		
   	SB1->(DbSeek(xFilial("SB1")+mv_par04))		
	@ Prow() + 1, 001 Psay "Codigo : " + SB1->B1_COD +"  Desenho: " +AllTrim(SB1->B1_CODAP5)+ " - " + SB1->B1_DESC
		
	SA2->(Dbseek(xfilial("SA2")+aDados[7]+aDados[8]))
	@ Prow() + 1, 001 Psay "Fornecedor: " + aDados[7] + " - " + aDados[8] + " - " + Subs(Alltrim(SA2->A2_NOME),1,30)
		
 	@ Prow() , 100 Psay "Numero da RMR : " + STRZERO(nRMR,6)
			
	@ Prow() + 1, 001 Psay OemToAnsi("Mês : ") + aDados[4] +" / " +StrZero(Year(mv_par01),4)+Space(20)+"Material Consignado" 
	@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina   
	@ Prow() + 2, 001 Psay OemToAnsi("Total de Peças Produzidas   : ") + Transform(nTotProd,"@E 999,999")
		
	_aRMCNewClone := _aRMCNew
	_aRMCFun := {}
	_aRMCUsi := {}
		
	For _xCom:= 1 to Len(_aRMCNewClone)
		
		If _aRMCNew[_xCom][1]$'30/50/00'
			_n := aScan(_aRMCFun,{|x| x[1]+x[2]==_aRMCNewClone[_xCom][1]+_aRMCNewClone[_xCom][2] })	
		
			If _n<>0
				_aRMCFun[_n][3] += _aRMCNewClone[_xCom][3]
			Else
				aAdd(_aRMCFun,_aRMCNewClone[_xCom])
			Endif
		Else
			_n := aScan(_aRMCUsi,{|x| x[1]+x[2]==_aRMCNewClone[_xCom][1]+_aRMCNewClone[_xCom][2] })	
		
			If _n<>0
				_aRMCUsi[_n][3] += _aRMCNewClone[_xCom][3]
			Else
				aAdd(_aRMCUsi,_aRMCNewClone[_xCom])
			Endif
		
		Endif
	Next   
		
	aSort(_aRMCFun,,,{|x,y|  x[4] < y[4]}) //ordena por operacao
	aSort(_aRMCUsi,,,{|x,y|  x[4] < y[4]}) //ordena por operacao

    _aRMComp := { { "Usinagem" , _aRMCUsi } ,;
    			  { "Fundido"  , _aRMCFun } }
    
  	For x:=1 to Len(_aRMComp)

	    @ PROW() + 2, 001 PSAY OEMTOANSI("Lista Componentes de Refugo de " + _aRMComp[x][1]) 

		For _xA:= 1 to Len(_aRMComp[x][2])
	  	
		   	IF PROW() > 58
	      	  _NPAG := _NPAG + 1
	          CABEC(TITULO, CABEC1, CABEC2,NOMEPROG, TAMANHO, NTIPO)        
	        ENDIF
	
	        @PROW() +1, 01 PSAY _aRMComp[x][2][_xA][2]+" "+Posicione('SB1',1,xFilial('SB1')+_aRMComp[x][2][_xA][2],'B1_DESC') +" (OPERAÇÃO "+_aRMComp[x][2][_xA][4]+") --->"+ TRANSFORM(_aRMComp[x][2][_xA][3],"@E 999,999")
	        
	    Next		
		
	Next
	
	fRodape(46)

RETURN(NIL)	

Static Function fRodape( nLin )
	@ nLin += 2, 001 PSAY __PRTTHINLINE() // LINHA ANTES DO TOTAL DO RODAPE DA PAGINA   
	@ nLin += 1, 001 PSAY OEMTOANSI("OBSERVAÇÕES")
	@ nLin += 5, 001 PSAY __PRTTHINLINE() // LINHA ANTES DO TOTAL DO RODAPE DA PAGINA    
	@ nLin += 1, 001 PSAY OEMTOANSI("VISTOS ")                                                                   
	@ nLin += 2, 001 PSAY SPACE(15)+ "NOME : _______________________"+SPACE(20)+ "NOME : __________________________________ "  
	@ nLin += 2, 001 PSAY SPACE(15)+ "RG   : _______________________"+SPACE(20)+ "RG   : __________________________________ "  
	@ nLin += 2, 001 PSAY SPACE(15)+ "ASS  : _______________________"+SPACE(20)+ "ASS  : __________________________________ "  
	@ nLin += 1, 001 PSAY SPACE(20)+ "        CLIENTE        "+SPACE(26)+ "    RESIDENTE   -   FORNECEDOR "  
	@ nLin += 4, 001 PSAY SPACE(10)+ "_______________________"+SPACE(15)+ "_______________________"+SPACE(15)+"___________________________"  
	@ nLin += 1, 001 PSAY SPACE(10)+ "ANALISTA USINAGEM - WHB"+SPACE(15)+ "ANALISTA FUNDIDO - WHB"+SPACE(15)+"    RESPONSAVEL - WHB"  
Return