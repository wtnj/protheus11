#Include "RWMAKE.CH"

#define TOT_DOC		20		// Total de documentos pendentes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณReqPGeral บAutor  ณGustavo Henrique    บ Data ณ  12/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIntegracao com o Microsoft Word para criacao do protocolo   บฑฑ
ฑฑบ          ณgeral dos requerimentos.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ EXPN1 - Posicao no script que indica se eh permuta de RA   บฑฑ
ฑฑบ          ณ EXPC1 - Documento referente ao protocolo de permuta de RA  บฑฑ
ฑฑบ          ณ EXPN1 - Posicao no script que indica o codigo da discip.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ReqPGeral( nRAPer, cProt, nDiscip )

Local aDados	:= {}
Local aOpcoes	:= {}
Local aRet		:= ACScriptReq( JBH->JBH_NUM )
Local nDias		:= 0
Local nCont		:= 0
Local nInd		:= 0
Local nValor	:= 0
Local cRA		:= PadR(JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1])
Local cUteis	:= ""
Local cDoc      := ""
Local cSituacao := " "

nRAPer  := Iif( nRAPer  == NIL,  0, nRAPer  )
nDiscip := Iif( nDiscip == NIL,  0, nDiscip )
cProt   := Iif( cProt   == NIL, "", cProt   )

If JBH->JBH_TIPSOL == "1"		// Funcionario
	                                      
	SRA->( dbSetOrder( 1 ) )
	SRA->( dbSeek( xFilial( "SRA" ) + Left(JBH->JBH_CODIDE, TamSX3("RA_MAT")[1]) ) )
	
	AAdd( aDados, { "RA"		, "Funcionแrio" 	} )
	AAdd( aDados, { "NOME"		, SRA->RA_NOME		} )
	AAdd( aDados, { "EMAIL"		, SRA->RA_EMAIL  	} )
	AAdd( aDados, { "FCOML"		, " "            	} )
	AAdd( aDados, { "FRESID"	, SRA->RA_TELEFON	} )
	AAdd( aDados, { "PASTA"		, " "           	} )
	AAdd( aDados, { "ARQMOR"	, " "            	} )
	AAdd( aDados, { "CURSO"		, " "				} )
	AAdd( aDados, { "SERIE"		, " "           	} )
	AAdd( aDados, { "TURMA"		, " "				} )
	AAdd( aDados, { "SITUACAO"	, " "				} )
	AAdd( aDados, { "AASS"		, " "				} )
	AAdd( aDados, { "UNIDADE"	, " "				} )

	For nInd := 1 To TOT_DOC
		AAdd( aDados, { "DA" + AllTrim( Str( nInd ) ), " " } )
		AAdd( aDados, { "DS" + AllTrim( Str( nInd ) ), " " } )
	Next nInd

ElseIf JBH->JBH_TIPSOL == "3"	// Candidato
                                  
	JA1->( dbSetOrder( 1 ) )
	JA1->( dbSeek( xFilial( "JA1" ) + Left(JBH->JBH_CODIDE, TamSX3("JA1_CODINS")[1]) ) )

	AAdd( aDados, { "RA"		, "Candidato" 		} )
	AAdd( aDados, { "NOME"		, JA1->JA1_NOME		} )
	AAdd( aDados, { "EMAIL"		, JA1->JA1_EMAIL	} )
	AAdd( aDados, { "FCOML"		, JA1->JA1_FCOML 	} )
	AAdd( aDados, { "FRESID"	, JA1->JA1_FRESID	} )
	AAdd( aDados, { "PASTA"		, " "           	} )
	AAdd( aDados, { "ARQMOR"	, " "           	} )
	AAdd( aDados, { "CURSO"		, " "				} )
	AAdd( aDados, { "SERIE"		, " "           	} )
	AAdd( aDados, { "TURMA"		, " "				} )
	AAdd( aDados, { "SITUACAO"	, " "				} )
	AAdd( aDados, { "AASS"		, " "				} )
	AAdd( aDados, { "UNIDADE"	, " "				} )

	For nInd := 1 To TOT_DOC
		AAdd( aDados, { "DA" + AllTrim( Str( nInd ) ), " " } )
		AAdd( aDados, { "DS" + AllTrim( Str( nInd ) ), " " } )
	Next nInd

ElseIf JBH->JBH_TIPSOL == "4"	// Externo

	JCR->( dbSetOrder( 1 ) )
	JCR->( dbSeek( xFilial( "JCR" ) + PadR(JBH->JBH_CODIDE, TamSX3("JCR_RG")[1]) ) )
                     
	AAdd( aDados, { "RA"      , "Externo" 			} )
	AAdd( aDados, { "NOME"    , JCR->JCR_NOME 		} )
	AAdd( aDados, { "EMAIL"   , JCR->JCR_EMAIL		} )
	AAdd( aDados, { "FCOML"   , " "            		} )
	AAdd( aDados, { "FRESID"  , JCR->JCR_FRESID		} )
	AAdd( aDados, { "PASTA"   , " "           		} )
	AAdd( aDados, { "ARQMOR"  , " "            		} )
	AAdd( aDados, { "CURSO"   , aRet[2]         	} )
	AAdd( aDados, { "SERIE"   , " "           		} )
	AAdd( aDados, { "TURMA"   , " " 				} )
	AAdd( aDados, { "SITUACAO", " "     			} )
	AAdd( aDados, { "AASS"    , " "					} )
	AAdd( aDados, { "UNIDADE" , aRet[8]				} )

	For nInd := 1 To TOT_DOC
		AAdd( aDados, { "DA" + AllTrim( Str( nInd ) ), " " } )
		AAdd( aDados, { "DS" + AllTrim( Str( nInd ) ), " " } )
	Next nInd

Else	// Aluno

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona no curso ativo do aluno e o cadastro de alunos ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	JBE->( dbSetOrder( 3 ) )

	If ! JBE->( dbSeek( xFilial( "JBE" ) + "1" + SubStr( JBH->JBH_CODIDE, 1, TamSX3("JA2_NUMRA")[1] ) ) )
	
		JBE->( dbSetOrder( 1 ) )
		JBE->( dbSeek( xFilial( "JBE" ) + SubStr( JBH->JBH_CODIDE, 1, TamSX3("JA2_NUMRA")[1] ) ) )
	
	EndIf
	
	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + JBE->JBE_CODCUR ) )
	
	JA2->( dbSetOrder( 1 ) )
	JA2->( dbSeek( xFilial( "JA2" ) + cRA ) )

	Do Case 
	
		Case JBE->JBE_ATIVO == "1" 
			aOpcoes := RetSx3Box(Posicione("SX3",2,"JBE_SITUAC","X3_CBOX"),,,14)
			If Val(JBE->JBE_SITUAC) >= 1 .and. Val(JBE->JBE_SITUAC) <= Len(aOpcoes)
				cSituacao := aOpcoes[Val(JBE->JBE_SITUAC)][3]
			EndIf	
			
		Case JBE->JBE_ATIVO == "2"
			cSituacao := "Inativo"
			
		Case Val(JBE->JBE_ATIVO) > 2
			aOpcoes := RetSx3Box(Posicione("SX3",2,"JBE_ATIVO","X3_CBOX"),,,14)
			If Val(JBE->JBE_ATIVO) <= Len(aOpcoes)
				cSituacao := aOpcoes[Val(JBE->JBE_ATIVO)][3]
			EndIf
			
	EndCase

	AAdd( aDados, { "RA"      , JBH->JBH_CODIDE															} )
	AAdd( aDados, { "NOME"    , JA2->JA2_NOME															} )
	AAdd( aDados, { "EMAIL"   , JA2->JA2_EMAIL															} )
	AAdd( aDados, { "FCOML"   , JA2->JA2_FCOML															} )
	AAdd( aDados, { "FRESID"  , JA2->JA2_FRESID															} )
	AAdd( aDados, { "PASTA"   , JA2->JA2_PASTA 															} )
	AAdd( aDados, { "ARQMOR"  , JA2->JA2_ARQMOR															} )
	AAdd( aDados, { "CURSO"   , JAH->JAH_DESC															} )
	AAdd( aDados, { "SERIE"   , JBE->JBE_PERLET															} )
	AAdd( aDados, { "HABILI"  , Posicione( "JDK", 1, xFilial("JDK")+JBE->JBE_HABILI,"JDK_DESC")         } )
	AAdd( aDados, { "TURMA"   , JBE->JBE_TURMA															} )
	AAdd( aDados, { "SITUACAO", cSituacao 																} )
	AAdd( aDados, { "AASS"    , JBE->JBE_ANOLET + "-" + JBE->JBE_PERIOD								} )
	AAdd( aDados, { "UNIDADE" , Posicione( "JA3", 1, xFilial("JA3") + JAH->JAH_UNIDAD, "JA3_DESLOC")	} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Preenche os documentos pendentes do prontuario do aluno ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	JC6->( dbSetOrder( 1 ) )
	JC6->( dbSeek( xFilial( "JC6" ) + cRA ) )

	Do While JC6->( ! EoF() .and. xFilial( "JC6" ) == JC6_FILIAL .and. JC6_NUMRA == cRA )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Caso chegue no limite de 20 documentos, encerra a adicao de documentos. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nCont == TOT_DOC
			Exit
		EndIf

		If JC6->JC6_STATUS == "1"		// Pendente
		
			nCont ++
			
			cDoc  := JC6->JC6_DOC + " - " + Tabela( "F0", JC6->JC6_DOC, .F. )

			AAdd( aDados, { "DA" + AllTrim( Str( nCont ) ), cDoc } )
			AAdd( aDados, { "DS" + AllTrim( Str( nCont ) ), cDoc } )
			
		EndIf	

		JC6->( dbSkip() )

	EndDo
	          
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza as opcoes do array que nao serao preenchidas por documentos pendentes ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nCont < TOT_DOC
	
		nCont	:= nCont + 1
		cDoc 	:= " "
		                  
		For nInd := nCont To TOT_DOC
		
			AAdd( aDados, { "DA" + AllTrim( Str( nInd ) ), cDoc } )
			AAdd( aDados, { "DS" + AllTrim( Str( nInd ) ), cDoc } )
		
		Next nInd
	
	EndIf
		
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica numero de dias para entrega ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nDias := A410DtPart( JBH->JBH_DATA, .F., .T. ) 
DO CASE
	CASE ALLTRIM(JBH->JBH_TIPO) == '000015'
  		AAdd( aDados, { "cDescd" 	, "Destino"})
		AAdd( aDados, { "cCurd"    , "Curso: "+ALLTRIM(aRet[11])} )
		AAdd( aDados, { "cTurd"    , "Turno: "+TABELA("F5",ALLTRIM(JAH->JAH_TURNO),.F.)} )
		AAdd( aDados, { "cTurMd"   , "Turma: "+JBE->JBE_TURMA} ) //OK
		AAdd( aDados, { "cUNIDD"   , "Unidade: "+Posicione( "JA3", 1, xFilial("JA3") + JAH->JAH_UNIDAD, "JA3_DESLOC")} ) //OK
	CASE ALLTRIM(JBH->JBH_TIPO) == '000016'
		AAdd( aDados, { "cDESCd" 	, "Destino"})
		AAdd( aDados, { "cCurd"    , "Curso: "+ALLTRIM(aRet[11])} )
		AAdd( aDados, { "cTurd"    , "Turno: "+TABELA("F5",ALLTRIM(JAH->JAH_TURNO),.F.)} )
		AAdd( aDados, { "cTurMd"   , "Turma: "+JBE->JBE_TURMA} ) //OK
		AAdd( aDados, { "cUNIDD"   , "Unidade: "+Posicione( "JA3", 1, xFilial("JA3") + JAH->JAH_UNIDAD, "JA3_DESLOC")} ) //OK
	CASE ALLTRIM(JBH->JBH_TIPO) == '000025'    
		AAdd( aDados, { "cDescd" 	, "Destino"})
		AAdd( aDados, { "cCurd"    , "Curso: "+ALLTRIM(JAH->JAH_DESC)} )
		AAdd( aDados, { "cTurd"    , "Turno: "+TABELA("F5",ALLTRIM(JAH->JAH_TURNO),.F.)} )
		AAdd( aDados, { "cTurMd"   , "Turma: "+JBE->JBE_TURMA} ) //OK
		AAdd( aDados, { "cUNIDD"   , "Unidade: "+ALLTRIM(aRet[10])} ) //OK
	CASE ALLTRIM(JBH->JBH_TIPO) == '000026'    
		AAdd( aDados, { "cDescd" 	, "Destino"})
		AAdd( aDados, { "cCurd"    , "Curso: "+ALLTRIM(JAH->JAH_DESC)} )
		AAdd( aDados, { "cTurd"    , "Turno: "+TABELA("F5",ALLTRIM(JAH->JAH_TURNO),.F.)} )
		AAdd( aDados, { "cTurMd"   , "Turma: "+aRet[8]} ) //OK
		AAdd( aDados, { "cUNIDD"   , "Unidade: "+Posicione( "JA3", 1, xFilial("JA3") + JAH->JAH_UNIDAD, "JA3_DESLOC")} ) //OK
	CASE ALLTRIM(JBH->JBH_TIPO) == '000027'    
		AAdd( aDados, { "cDescd" 	, "Destino"})
		AAdd( aDados, { "cCurd"    , "Curso: "+ALLTRIM(JAH->JAH_DESC)} )
		AAdd( aDados, { "cTurd"    , "Turno: "+aRet[12]} )
		AAdd( aDados, { "cTurMd"   , "Turma: "+JBE->JBE_TURMA} ) //OK
		AAdd( aDados, { "cUNIDD"   , "Unidade: "+Posicione( "JA3", 1, xFilial("JA3") + JAH->JAH_UNIDAD, "JA3_DESLOC")} ) //OK
	OTHERWISE                                  
		AAdd( aDados, { "cDescd" 	, " "})
		AAdd( aDados, { "cCurd"    , " "															} )
		AAdd( aDados, { "cTurd"    , " "															} )
		AAdd( aDados, { "cTurMd"   , " "															} ) //OK
		AAdd( aDados, { "cUNIDD"   , " "															} ) //OK
ENDCASE


If nDias <= 1
	nDias := 1
EndIf	
          
If JBF->JBF_DUTEIS == "1"
	If nDias > 1
		cUteis	:= " dias ๚teis"
	Else
		cUteis	:= " dia ๚til"
	EndIf	
Else
	cUteis := " dia(s)"
EndIf                          

If ! Empty( JBF->JBF_REGVAL )
	nValor := Eval( &( "{ ||" + JBF->JBF_REGVAL + "}" ) )
	If ValType( nValor ) # "N"
		nValor := 0
	EndIf	
Else
	nValor := JBF->JBF_VALOR
EndIf	

AAdd( aDados, { "PROTOCOLO"  , JBH->JBH_NUM } )
AAdd( aDados, { "A_PARTIR_DE", LTrim( Str( nDias ) ) + cUteis } )
AAdd( aDados, { "DESCRICAO"  , RTrim( JBF->JBF_COD ) + " - " + RTrim( JBF->JBF_DESC ) } )
AAdd( aDados, { "VALOR"      , Transform(nValor, "@E 99,999,999.99" ) } )
AAdd( aDados, { "HOJE"       , JBH->JBH_DATA } )
AAdd( aDados, { "FUNCIONARIO", cUserName } )

// Emite o protocolo de permuta caso tenha informado permuta de RA
If nRAPer # 0 .and. aRet[ nRAPer ] == "2" .and. ! Empty( cProt )
	ACImpDoc( cProt, aDados )
ElseIf nDiscip # 0 .And. ! Empty( cProt )
	AAdd( aDados, { "DISCIP", RTrim( aRet[ nDiscip ] ) + " - " + Left( Posicione( "JAE", 1, xFilial("JAE") + aRet[nDiscip], "JAE_DESC" ), 40 ) } )
	ACImpDoc( cProt, aDados )
Else
	ACImpDoc( JBF->JBF_DOCUM, aDados )
EndIf

Return( .T. )
