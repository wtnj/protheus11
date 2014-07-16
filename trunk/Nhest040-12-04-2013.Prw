/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³NHEST040  ³ Autor ³ Alexandre R. Bento    ³ Data ³ 02.01.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Gatilho que Cria o codigo dos Produtos Automaticamente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Whb                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualiz. ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "rwmake.ch"
                        
User Function Nhest040()
Public lFlag    := .F.
Public cGrupo   := Alltrim(M->B1_GRUPO)  // Variavel que guarda o Grupo
Public cCod     := " "                                   
Public cLocal   := Space(02)
Public nRegSB1  := SB1->(Recno())                                                 
Public cFamilia := '' //Alltrim(M->B1_FAMFER) // Campo p/ Guardar Familia de Ferramentas
Public cFamForj := '' //AllTrim(M->B1_FAMFOR) // Campo p/ Guardat a Famila de Ferramentas da Forjaria
Public cCodSeq  := Space(06)
Public cCodAP5  := '' //Alltrim(M->B1_CODAP5) // Campo p/ Guardar o cod Ap5 de Ferramentas
Public cTabela  := Space(06)
Public lFE      := .F.
Public lCodAp5  := .F.
Public lAchou   := .F.

If SM0->M0_CODIGO$'FN/NH/IT'

	cFamilia := Alltrim(M->B1_FAMFER) // Campo p/ Guardar Familia de Ferramentas
	cFamForj := AllTrim(M->B1_FAMFOR) // Campo p/ Guardat a Famila de Ferramentas da Forjaria
	cCodAP5  := Alltrim(M->B1_CODAP5) // Campo p/ Guardar o cod Ap5 de Ferramentas

	If Empty(cFamilia) .and. Subs(cGrupo,1,2) == "FE"  // Nao deixa entrar o codigo sem digitar a familia 
	   MsgBox("Atenção Usuario da Ferramentaria tem que Digitar a FAMILIA DA FERRAMENTA","Atencao","STOP")
	   Return(cCod) 
	Endif

	If SM0->M0_CODIGO$'FN/NH'	
	
		//-- controle de usuario x grupo de produtos
		SX5->(DbSetOrder(1))
		SX5->(DbSeek(xFilial("SX5")+"ZU")) // Tabela de validação de Usuarios, Grupos e Local Padrão                  
		While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZU"
		
		   If Alltrim(Substr(SX5->X5_DESCRI,1,15)) == Upper(Alltrim(cUserName)) //Verifica se o Usuario é o mesmo da tabela ZU no SX5
		      If Upper(AllTrim(Subs(SX5->X5_DESCRI,16,4))) == cGrupo //Verifica se o Usuario pode cadastrar este grupo 
		         lFlag := .T. //Flag de Controle          
		         cLocal:= Subs(SX5->X5_DESCRI,20,2) // Guarda o Almoxarifado Padrao   
		         Exit
		      Endif   
		   Endif
		   SX5->(DbSkip())
		Enddo   
	    lFlag := .T. //Flag de Controle          
		
		If !lFlag  // Usuario sem permissão para cadastrar o Grupo
		   MsgBox("Usuario sem Permissão para Utilizar este Grupo","Atencao","STOP")
		   Return(cCod)  // retorna
		Endif                        

    Endif
		
Endif

If SM0->M0_CODIGO == "NH"      
	If Subs(cGrupo,1,4) $ "MM05"
	   M->B1_COD := Subs(cGrupo,1,4)+Alltrim(M->B1_CODAP5)
	   M->B1_CODAP5 := Space(15)
	   Return(M->B1_COD)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O CÓDIGO DE FERRAMENTAS DA FORJARIA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SM0->M0_CODIGO == "FN/IT"

	If Empty(cFamForj) .and. Subs(cGrupo,1,4) $ "FJ40/FJ46"  // Nao deixa entrar o codigo sem digitar a familia 
	   MsgBox("Atenção para Ferramenta da Forjaria tem que Digitar a FAMILIA DA FERRAMENTA DA FORJARIA","Atencao","STOP")
	   Return(cCod)
	Endif
	
	If Substr(cGrupo,1,4) $ "FJ40/FJ46"
		cCodSeq := "000"
		While .T.
			cCodSeq := StrZero(Val(cCodSeq)+1,3)
			If !SB1->(dbSeek(xFilial("SB1")+Substr(cGrupo,1,4)+"."+Alltrim(Substr(cFamForj,1,3))+cCodSeq))
				M->B1_COD := Substr(cGrupo,1,4)+"."+Alltrim(Substr(cFamForj,1,3))+cCodSeq
				Return(M->B1_COD)
			EndIf
		EndDo
	EndIf
	
	If Substr(cGrupo,1,4) $ "FJ41/FJ42/FJ43/FJ44/FJ45/FJ47"
		Return M->B1_COD
	EndIf
	
EndIf

If SM0->M0_CODIGO$'FN/NH/IT'

	If Subs(cGrupo,1,2) $ "IM/ZB" 
	
		If Substr(cGrupo,1,4) == 'IM02'

		   SB1->(DbSetOrder(1)) //FILIAL+PRODUTO
		   lCodAp5 := .F.  
		   If Empty(cCodAP5)                                
		      cCodAp5 := "000001"  // primeiro cod. a pesquisar
		   Endif
                                          
		   cCodSeq := "000001"

	  	   	// no caso do im15 foi pego um cosigo inicial para controle das contas, depois segue sequencial
			If !SB1->(DbSeek(xFilial("SB1")+ Subs(cGrupo,1,4)+".000001"))
 	      		cCod := Subs(cGrupo,1,4)+".000001"  //Monta  o primeiro codigo AP6
			Else
 		      	While !lAchou
  	    	     	cCodSeq := StrZero(Val(cCodSeq)+1,6)
	  	         	IF !SB1->(DbSeek(xFilial("SB1")+Subs(cGrupo,1,4)+"."+cCodSeq))
	 	            	cCod := Subs(cGrupo,1,4)+"."+cCodSeq  //Monta codigo AP6 Apartir do codigo AP5
	 	            	lAchou := .T.
	             	Endif   
    	      	Enddo
	  	   	Endif

			SB1->(DbGoto(nRegSB1))  // Volta a posicao do registro no sb1
			m->b1_CODAP5 := cCod
			M->B1_COD := cCod 

			Return(M->B1_COD)

		Endif	
	
		If !Empty(Alltrim(M->B1_CODAP5))
		   M->B1_COD := Alltrim(M->B1_CODAP5)
		   Return(M->B1_COD)
	   Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRUPO FD40 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//-- CHAMADO 012848 do portal
	/*
	If Subs(cGrupo,1,2) == "FE" .Or. Subs(cGrupo,1,4) == "FD40" // Verifica se é um Grupo de Ferramentaria
	
	   If Empty(cFamilia)
	      MsgBox("Atenção Usuario da Ferramentaria tem que Digitar a FAMILIA DA FERRAMENTA","Atencao","STOP")
	      Return(cCod)  // retorna
	   Else
			cCodSeq := "000"
			While .T.
				cCodSeq := StrZero(Val(cCodSeq)+1,3)
				If !SB1->(dbSeek(xFilial("SB1")+Substr(cGrupo,1,4)+"."+Alltrim(Substr(cFamilia,1,3))+cCodSeq))
					M->B1_COD := Substr(cGrupo,1,4)+"."+Alltrim(Substr(cFamilia,1,3))+cCodSeq
					Return(M->B1_COD)
				EndIf
			EndDo
	   Endif
	
	Endif
	*/
	 
	If Subs(cGrupo,1,2) == "FE" .Or. Subs(cGrupo,1,4)$"FD40/FD50" // Verifica se é um Grupo de Ferramentaria
	   
	   If Empty(cFamilia)
	      MsgBox("Atenção Usuario da Ferramentaria tem que Digitar a FAMILIA DA FERRAMENTA","Atencao","STOP")
	      Return(cCod)  // retorna
	   Elseif !Empty(cCodAP5) .And. !Empty(cFamilia)
	      If Subs(cCodAP5,1,3) <> Subs(cFamilia,1,3) 
	         MsgBox("Atenção Codigo da Familia Diferente da Familia Digitada no Codigo AP5","Atencao","STOP")
	         Return(cCod)  // retorna
	      Endif
	   Endif
	
		If Empty(cCodAP5)                                 
	      
	      	If M->B1_TIPO =="FE"
	      
	      		aFeAp5 := {{"FE31.040","115"},;
		      			   {"FE31.045","134"},;
					       {"FE31.051","823"},;
					       {"FE31.081","268"},;
					       {"FE31.090","061"},;
					       {"FE31.092","096"},;
					       {"FE31.094","121"},;
					       {"FE31.096","276"},;
					       {"FE31.099","118"},;
					       {"FE32.051","801"},;
					       {"FE32.052","740"},;
					       {"FE32.062","086"},;
					       {"FE32.064","261"},;
					       {"FE32.067","702"},;
					       {"FE32.102","516"},;
					       {"FE32.103","090"},;
					       {"FE32.104","101"},;
					       {"FE32.105","050"},;
					       {"FE32.110","772"},;
					       {"FE32.112","682"},;
					       {"FE32.166","543"},;
					       {"FE33.065","905"},;
					       {"FE33.166","484"}}
			      
	         	_n := aScan(aFeAp5,{|x| x[1]==cGrupo+"."+cFamilia})
	         	If _n==0
	         		cCodAp5 := cFamilia+"001"  // primeiro cod. a pesquisar            
	         	Else
	         		cCodAp5 := cFamilia+aFeAp5[_n][2]
	         	Endif
			/*	         	
			
			//-- SIMPLIFICADO ACIMA POR JOAOFR
			
         	if cGrupo+"."+cFamilia=="FE31.040"
	            cCodAp5 := cFamilia+"115" 
	         Elseif cGrupo+"."+cFamilia=="FE31.045"
	            cCodAp5 := cFamilia+"134"       
	         Elseif cGrupo+"."+cFamilia=="FE31.051"
	            cCodAp5 := cFamilia+"823"                
	         Elseif cGrupo+"."+cFamilia=="FE31.081"
	            cCodAp5 := cFamilia+"268"                
	         Elseif cGrupo+"."+cFamilia=="FE31.090"
	            cCodAp5 := cFamilia+"061"
	         Elseif cGrupo+"."+cFamilia=="FE31.092"
	            cCodAp5 := cFamilia+"096"
	         Elseif cGrupo+"."+cFamilia=="FE31.094"
	            cCodAp5 := cFamilia+"121"
	         Elseif cGrupo+"."+cFamilia=="FE31.096"
	            cCodAp5 := cFamilia+"276"
	         Elseif cGrupo+"."+cFamilia=="FE31.099"
	            cCodAp5 := cFamilia+"118"
	         Elseif cGrupo+"."+cFamilia=="FE32.051"
	            cCodAp5 := cFamilia+"801"
	         Elseif cGrupo+"."+cFamilia=="FE32.052"
	            cCodAp5 := cFamilia+"740"
	         Elseif cGrupo+"."+cFamilia=="FE32.062"
	            cCodAp5 := cFamilia+"086"
	         Elseif cGrupo+"."+cFamilia=="FE32.064"
	            cCodAp5 := cFamilia+"261"
	         Elseif cGrupo+"."+cFamilia=="FE32.067"
	            cCodAp5 := cFamilia+"702"
	         Elseif cGrupo+"."+cFamilia=="FE32.102"
	            cCodAp5 := cFamilia+"516"
	         Elseif cGrupo+"."+cFamilia=="FE32.103"
	            cCodAp5 := cFamilia+"090"
	         Elseif cGrupo+"."+cFamilia=="FE32.104"
	            cCodAp5 := cFamilia+"101"
	         Elseif cGrupo+"."+cFamilia=="FE32.105"
	            cCodAp5 := cFamilia+"050"
	         Elseif cGrupo+"."+cFamilia=="FE32.110"
	            cCodAp5 := cFamilia+"772"
	         Elseif cGrupo+"."+cFamilia=="FE32.112"
	            cCodAp5 := cFamilia+"682"
	         Elseif cGrupo+"."+cFamilia=="FE32.166"
	            cCodAp5 := cFamilia+"543"
	         Elseif cGrupo+"."+cFamilia=="FE33.065"
	            cCodAp5 := cFamilia+"905"
	         Elseif cGrupo+"."+cFamilia=="FE33.166"
	            cCodAp5 := cFamilia+"484"
	         Else
	            cCodAp5 := cFamilia+"001"  // primeiro cod. a pesquisar            
	         Endif   
	         */
	      Else
	         cCodAp5 := cFamilia+"001"  // primeiro cod. a pesquisar
	      Endif   
	   Endif
	  
	   If cGrupo$"FE05/FE06/FE55/FE56"
	       cCod := Subs(cGrupo,1,4)+"."+cCodAp5  //Monta codigo AP10 Apartir do codigo AP5
	   Else
		   SB1->(DbSetOrder(1)) //FILIAL+PRODUTO
		   While !lFE //Até achar um codigo vazio
		      SB1->(DbSeek(xFilial("SB1")+Subs(cGrupo,1,4)+"."+cCodAp5)) // Posicionar no grupo FE??
		      If SB1->(Found())
		         lFE := .T.
		      Endif
		      
		      If lFE //Encontrou o Codap5 
		         cCodAp5 :=StrZero(Val(cCodAp5)+1,6)  // Pega o Proximo Codigo Livre
		         lFE := .F.
		      Else
		    		Exit // Sair fora do while porque não encontro o produto
		      Endif
		      
		   Enddo //Fim enddo     
		   
		   If !lFE
		      cCod := Subs(cGrupo,1,4)+"."+cCodAP5  //Monta codigo AP6 Apartir do codigo AP5
		   Endif //FE            
	   Endif //fe 
	Endif   
EndIf
	
If ( SM0->M0_CODIGO$'NH/FN/IT' .AND. !Subs(cGrupo,1,2)$"FE/MO/IM" .And. !Subs(cGrupo,1,4)$"MQ03/FD50") .OR. SM0->M0_CODIGO$'ZR'       
	
   SB1->(DbSetOrder(1)) //FILIAL+PRODUTO
   lCodAp5 := .F.  
   If Empty(cCodAP5)                                
      cCodAp5 := "000001"  // primeiro cod. a pesquisar
   Endif
                                          
   cCodSeq := "000001"

	If lCodAp5
	   	If Empty(cCodAp5)                                            
   	   		MsgBox("Atencao o codigo do AP5 nao foi Digitado !!!","Atencao","YESNO")
   	   		Return(cCod) //retorna
	   	Endif
	   
  	   	IF !SB1->(DbSeek(xFilial("SB1")+Subs(cGrupo,1,4)+"."+cCodAp5))
 	      	cCod := Subs(cGrupo,1,4)+"."+cCodAP5  //Monta codigo AP6 Apartir do codigo AP5  
		Else
  	      	While !lAchou
  	         	cCod := StrZero(Val(cCodAP5)+1,6)
  	    	    IF !SB1->(DbSeek(xFilial("SB1")+Subs(cGrupo,1,4)+"."+cCodAp5))
 	        		cCod := Subs(cGrupo,1,4)+"."+cCodAP5  //Monta codigo AP6 Apartir do codigo AP5
 	            	lAchou := .T.
            	Endif   
         	Enddo
  	   	Endif
  	Else        
  	   	// no caso do im15 foi pego um cosigo inicial para controle das contas, depois segue sequencial
  	   	If !SB1->(DbSeek(xFilial("SB1")+ Subs(cGrupo,1,4)+".000001"))
 	      	cCod := Subs(cGrupo,1,4)+".000001"  //Monta  o primeiro codigo AP6
  	   	Else
 	      	While !lAchou
  	         	cCodSeq := StrZero(Val(cCodSeq)+1,6)
  	         	IF !SB1->(DbSeek(xFilial("SB1")+Subs(cGrupo,1,4)+"."+cCodSeq))
 	            	cCod := Subs(cGrupo,1,4)+"."+cCodSeq  //Monta codigo AP6 Apartir do codigo AP5
 	            	lAchou := .T.
             	Endif   
          	Enddo
  	   	Endif
  	Endif   

Endif

SB1->(DbGoto(nRegSB1))  // Volta a posicao do registro no sb1

M->B1_COD    := cCod  // Retorna o Codigo Sequencial                   

If SM0->M0_CODIGO$'FN/NH/IT'
	cTabela      := Tabela("02",Subs(cGrupo,1,2)) // Verificacao do tipo do produto, se valido retorna tipo senao retorna espaco
	
	If Subs(SX5->X5_CHAVE,1,2) == Subs(cGrupo,1,2)
	   M->B1_TIPO := Subs(cGrupo,1,2) // Retorna o Tipo
	Else
	   M->B1_TIPO := Subs(SX5->X5_CHAVE,1,2) // Retorna o Tipo
	Endif    
	
	M->B1_LOCPAD := cLocal   // Retorna o Local Padrao que esta na tabela ZU no SX5
	M->B5_COD  := cCod 
	
	lFE  := .F.
EndIf
	
Return(cCod)
               