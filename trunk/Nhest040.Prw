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
#INCLUDE "topconn.ch"
                        
User Function Nhest040()
Public cGrupo   := Alltrim(M->B1_GRUPO)  // Variavel que guarda o Grupo
Public cCod     := " "                                   
Public cLocal   := Space(02)
Public nRegSB1  := SB1->(Recno())                                                 
Public cFamilia := '' //Alltrim(M->B1_FAMFER) // Campo p/ Guardar Familia de Ferramentas
Public cFamForj := '' //AllTrim(M->B1_FAMFOR) // Campo p/ Guardat a Famila de Ferramentas da Forjaria
Public cCodSeq  := Space(06)
Public cCodAP5  := Space(20) //Alltrim(M->B1_CODAP5) // Campo p/ Guardar o cod Ap5 de Ferramentas
Public cTabela  := Space(06)

	cFamilia := Alltrim(M->B1_FAMFER) // Campo p/ Guardar Familia de Ferramentas
	cFamForj := AllTrim(M->B1_FAMFOR) // Campo p/ Guardat a Famila de Ferramentas da Forjaria
	cCodAP5  := Alltrim(M->B1_CODAP5) // Campo p/ Guardar o cod Ap5 de Ferramentas

	//-- controle de usuario x grupo de produtos
	ZFB->(DbSetOrder(1))
	If !ZFB->(DbSeek(xFilial("ZFB")+Upper(	pad(cUserName,25," "))+cGrupo))	

	   MsgBox("Usuario sem Permissão para Utilizar este Grupo","Atencao","STOP")
	   Return(cCod)  // retorna

	Endif
	
	If len(cGrupo)<>4
		Return cCod
	Endif

	If SM0->M0_CODIGO == "FN"

		If cGrupo$'IM19'
		
		    SB1->(dbsetorder(1))
		    If !SB1->(DbSeek(xFilial("SB1")+M->B1_CODAP5)) 
		    	If len(ALLTRIM(M->B1_CODAP5))==11
				    cCod := M->B1_CODAP5
				Else
					Alert("Código do produto deve ter 11 dígitos!")
					Return ""
	            Endif
			Else
				Alert("Código do produto já existente!")
				Return ""
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
	If ALLTRIM(SM0->M0_CODIGO) $ "FN/IT"
	
		If cGrupo $ "FJ40/FJ46"
		
			If Empty(cFamForj) // Nao deixa entrar o codigo sem digitar a familia 
			   MsgBox("Atenção para Ferramenta da Forjaria tem que Digitar a FAMILIA DA FERRAMENTA DA FORJARIA","Atencao","STOP")
			   Return(cCod)
			Endif
		
			cCodSeq := "000"

			While .T.
				cCodSeq := StrZero(Val(cCodSeq)+1,3)
				If !SB1->(dbSeek(xFilial("SB1")+Substr(cGrupo,1,4)+"."+Alltrim(Substr(cFamForj,1,3))+cCodSeq))
					M->B1_COD := Substr(cGrupo,1,4)+"."+Alltrim(Substr(cFamForj,1,3))+cCodSeq
					Return(M->B1_COD)
	  			EndIf
			EndDo
		EndIf
		
		If cGrupo $ "FJ41/FJ42/FJ43/FJ44/FJ45/FJ47"
			Return M->B1_COD
		EndIf
		
	EndIf

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
	      	cCodAp5 := cFamilia+"001"  // primeiro cod. a pesquisar
		Endif
			 
      	If M->B1_TIPO =="FE"
	        
	      	//-- regra passada pelo usuario
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
      	Endif   
	  
	   	If cGrupo$"FE05/FE06/FE55/FE56"
	       	cCod := Subs(cGrupo,1,4)+"."+cCodAp5  //Monta codigo AP11 Apartir do codigo AP5
	   	Else
		   
		   	//-- procura o proximo codigo livre
		   	SB1->(DbSetOrder(1)) //FILIAL+PRODUTO
		   	While SB1->(DbSeek(xFilial("SB1")+Subs(cGrupo,1,4)+"."+cCodAp5)) // Posicionar no grupo FE??
	         	cCodAp5 := StrZero(Val(cCodAp5)+1,6)  // Pega o Proximo Codigo Livre
		   	Enddo //Fim enddo     
		   
         	cCod    := Subs(cGrupo,1,4)+"."+cCodAp5  // Pega o Proximo Codigo Livre
         	
		Endif //fe 
	Endif   
    

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CODIGO PADRÃO PARA O RESTO DOS PRODUTOS DIFERENTES DOS GRUPOS ACIMA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IF EMPTY(cCod)
	   	cCodSeq := "000001"
			
	   	SB1->(dbsetorder(1))
	   	While SB1->(DbSeek(xFilial("SB1")+Subs(cGrupo,1,4)+"."+cCodSeq))
	   		cCodSeq := StrZero(Val(cCodSeq)+1,6)
	  	Enddo
	
		SB1->(DbGoto(nRegSB1))  // Volta a posicao do registro no sb1
		cCod :=	M->B1_CODAP5 := Subs(cGrupo,1,4)+"."+cCodSeq
	
	ENDIF

	SB1->(DbGoto(nRegSB1))  // Volta a posicao do registro no sb1

	M->B1_CODBAR := cCod
	M->B1_COD    := cCod  // Retorna o Codigo Sequencial                   

	SX5->(dbsetorder(1))//X5_FILIAL+X5_TABELA+X5_CHAVE
	IF SX5->(dbseek(xFilial("SX5")+Subs(cGrupo,1,2)))
		M->B1_TIPO := Subs(SX5->X5_CHAVE,1,2) // Retorna o Tipo
	ENDIF

	M->B1_LOCPAD := cLocal   // Retorna o Local Padrao que esta na tabela ZU no SX5
	M->B5_COD  := cCod   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CONFORME O GRUPO DIGITADO, JÁ ADICIONA O CAMPO B1_LOCALIZ = 'S'     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    // 25/10/13
	// O.S.: 056624 ---------------------------------------------------------
	
	if(cGrupo$"MM32\MM31\PQ31\MX01\MX02\ML01\MK01\MG01")
	   M->B1_LOCALIZ = 'S'	 
	endif   
	
	// ----------------------------------------------------------------------   
	
Return(cCod)