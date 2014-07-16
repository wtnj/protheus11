/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA650TOK  ºAutor  ³João Felipe da Rosa º Data ³  11/24/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza a hora e data das ops posteriores                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MA650TOK()
Local lRet := .T.
Local cProd := M->C2_PRODUTO   // Hora inicial nova
Local cCorrWhb := M->C2_CORRWHB   // Hora inicial nova

If empty(AllTrim(cCorrWhb))
   DbSelectArea("SB1")	   
   SB1->(DBSETORDER(1)) // FILIAL + COD
   
   if SB1->(DbSeek(xFilial("SB1")+cProd))
  	  if AllTrim(SB1->B1_GRUPO)$'PA04/TR04'	   
  	  	 Alert("Preencher o campo CORRIDA WHB para produtos do grupo PA04/TR04 (Forjaria) !")
		 lRet := .F. 
  	  endif
   else
       Alert("Produto Não Válido !","Atencao - MA650TOK","ALERT")
	   lRet := .F.
   endif
   	
EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³             A T E N Ç Ã O                ³
	//³ Incluir as validações acima desta função ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	lRet := fAtuPeriodos()  
Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA OS PERIODOS DAS OPS POSTERIORES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
Static Function fAtuPeriodos()
Local lRet    := .T.
Local cHrAnte := SC2->C2_OPHRINI // Hora inicial anterior
Local dDtAnte := SC2->C2_DATPRI  // Data inicial anterior
Local cHrNova := M->C2_OPHRINI   // Hora inicial nova
Local dDtNova := M->C2_DATPRI    // Data inicial nova
Local cAl     := getNextAlias()
Local nDdif   := 0
Local nHdif   := 0
Local aAtu    := {}

	If !Empty(M->C2_OPHRINI) .AND. !EMPTY(M->C2_OPHRFIM)
	
		If M->C2_DATPRI==M->C2_DATPRF .AND. M->C2_OPHRINI >= M->C2_OPHRFIM
			Alert("Hora final deve ser maior que a Hora inicial!")
			Return .F.
		EndIf
	
		//-- Verifica se o horário inicial foi alterado
		If cHrAnte<>cHrNova .or. dDtAnte<>dDtNova
		
			//-- Traz as OP's posteriores ao novo período informado para esta OP
			beginSql Alias cAl
			
				SELECT 
					R_E_C_N_O_ REC
				FROM 
					%Table:SC2% C2 (NOLOCK)
				WHERE
					C2_DATPRI >= %Exp:DtoS(M->C2_DATPRF)%
				AND C2_OPHRINI >= %Exp:M->C2_OPHRINI%
				AND C2_TPOP = 'F' // Firme
				AND R_E_C_N_O_ <> %Exp:SC2->(Recno())%
				AND C2_FILIAL = %Exp:xFilial("SC2")%
				AND C2_DISA = %Exp:M->C2_DISA%
				AND %NotDel%
			
			endSql
			
			//-- calcula a diferença em dias do adiantamento da op
			If dDtAnte<>dDtNova
				nDdif := dDtNova - dDtAnte
			EndIf
	
			//-- calcula a diferença em horas do adiantamento da op
			If cHrAnte<>cHrNova
				nHDif := HoraToInt(cHrNova) - HoraToInt(cHrAnte)
			EndIf
	
			nOldRec := SC2->(RecNo()) // guarda a posicao da tabela SC2
			
			//-- percorre todas as ops posteriores
	
			While (cAl)->(!Eof())
				
				SC2->(dbGoTo((cAl)->REC))
	            
	            aAtu := {}
	            
				aAdd(aAtu,SC2->C2_DATPRI + nDdif)
				aAdd(aAtu,SC2->C2_DATPRF + nDdif)
				aAdd(aAtu,IntToHora(HoraToInt(SC2->C2_OPHRINI) + nHdif))
				aAdd(aAtu,IntToHora(HoraToInt(SC2->C2_OPHRFIM) + nHdif))
				
				//-- Adianta o período das ops adiantando ou atrazando a data em nDdif e a hora em nHdif
				RecLock("SC2",.F.)
					SC2->C2_DATPRI  := aAtu[1]
					SC2->C2_DATPRF  := aAtu[2]
					SC2->C2_OPHRINI := aAtu[3]
					SC2->C2_OPHRFIM := aAtu[4]
				MsUnLock("SC2")
	
				(cAl)->(dbSkip())
	        EndDo
	        
	        SC2->(dbGoTo(nOldRec)) // retorna a posicao da tabela
	        
	   EndIf
	EndIf
		
Return lRet
*/