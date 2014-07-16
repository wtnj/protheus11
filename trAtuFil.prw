#include "protheus.ch"
#DEFINE NL CHR(13)+CHR(10)
// Exemplo de como ajustar o tamanho de um campo "a quente" no Protheus
// Utiliza a função TCALTER para realizar a modificação
// Exemplo:
// lOk := TCAlter(cTable,aOldStru,aNewStru,@nTopErr)
// lOK -> .T. se conseguiu alterar a tabela
// cTable -> Nome físico da tabela no banco (ex: SB1010)
// aOldStru -> Estrutura atual da tabela
// aNewStru -> Nova estrutura da tabela
// @nTopErr -> Se der erro, retorna o código numérico do erro no TOP
*=====================================*
User Function trAtuFil()
	Processa({||fAtuFil()},"Aguarde...")
Return

Static Function fAtuFil()
Local aX3, aStru, nTopErr := 0
Local _cLog := ""
Local nCount := 0

	SX2->(DbgoTop())
	ProcRegua(SX2->(RecCount()))
	
	While SX2->(!Eof())
		IncProc(SX2->X2_ARQUIVO)

		aStru := (SX2->X2_CHAVE)->(DBSTRUCT())
		(SX2->X2_CHAVE)->(DBCLOSEAREA())
		
		
		// Monta a estrutura em SX3 p/ comparação
		SX3->(DBSETORDER(1))
		SX3->(DBSEEK(SX2->X2_CHAVE+"01"))  
		aX3 := {}
		While SX3->(!EOF() .and. X3_ARQUIVO==SX2->X2_CHAVE)
			IF SX3->X3_CONTEXT <> "V"
				If "_FILIAL" $ SX3->X3_CAMPO .AND. SX3->X3_TAMANHO == 2
					RecLock("SX3", .F.)
						SX3->X3_TAMANHO := 3
					SX3->(MSUNLOCK())				
				EndIf
				
				_n := aScan(aX3,{|x| x[1]==Alltrim(SX3->X3_CAMPO)})
				If _n == 0
		  			SX3->( AADD( aX3, {X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL} ))
		  		Else
		  			_cLog += SX3->X3_CAMPO + " - Duplicado" +NL
		  		Endif
			ENDIF
		SX3->(DBSKIP())
		Enddo
		IF ! TcCanOpen(SX2->X2_ARQUIVO)
			 _cLog += SX2->X2_ARQUIVO + " - Não pôde abrir" + NL
			 SX2->(DbSkip())
			 Loop			 
		Endif
		IF !ChkFile(SX2->X2_CHAVE, .T.)  // Tenta abrir a tabela em modo exclusivo para alterar
			_cLog += SX2->X2_ARQUIVO + " - Não pode abrir exclusivo" +NL
			 SX2->(DbSkip())
			 Loop
		ENDIF
		IF TCAlter( Alltrim(SX2->X2_ARQUIVO), aStru, aX3, @nTopErr)
			_cLog += SX3->X3_CAMPO + " - Alterado com sucesso" +NL
		Else
			_cLog += SX3->X3_CAMPO + " - Erro ao alterar - " + ALLTRIM(STR(nTopErr)) +NL
		Endif	
		(SX2->X2_CHAVE)->(DbCloseArea())
		SX2->(DbSkip())
		nCount++	
	EndDo
	MemoWrit('C:\TEMP\LogAtuFil.txt',_cLog)
Return