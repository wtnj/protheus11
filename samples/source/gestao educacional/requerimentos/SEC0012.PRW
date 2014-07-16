#Include "TOPCONN.CH"    //PADRAO
#Include "RWMAKE.CH"    //PADRAO
#Include "MSOLE.CH"    //PADRAO

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SEC0012	    ³ Autor ³  ALAN S. R. OLIVEIRA  ³ Data ³ 19/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ DECLARACAO DE SEMESTRALIDADE              		       	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Financeiro 							              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0012()

Local lRet 		:= .T.
Local nLastKey	:= 0

Private check		:= 0
Private _cArqTmp	:= ""

If nLastKey == 27
	Set Filter To
	Return
EndIf

// Chamada da rotina de armazenamento de dados...
Processa({||ACATRB0012() })
      
if check > 0	//ESTA VERIFCACAO E FEITA, PARA QUE QUANDO NAO HOUVER TITULOS GERADOS PARA O ALUNO
				//EXIBA UMA MENSSAGEM PARA O ATENDENTE
	// Chamada da rotina de impressao do relat¢rio...
	Processa({||U_PREL0012() })
	                                         
else
		
	MsgBox("Não existem títulos gerados para este aluno.")
	lRet := .F.
		
endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos tempor rios				    	             |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	DbSelectArea("SQJ")
	DbCloseArea()
#ENDIF
                                    
DbSelectarea("TRB")
DbCloseArea()

#IFNDEF TOP
	Ferase(_cArqTmp+".DBF")
	Ferase(_cArqTmp+OrdBagExt())
#ENDIF
      
DbSelectArea("JA2")	//CADASTRO DE ALUNOS
RetIndex("JA2")
DbSelectArea("JAH")	//CADASTRO DE CURSO
RetIndex("JAH")
DbSelectArea("JBH")	//HEADER DA SOLICITACAO DO REQUERIMENTO
RetIndex("JBH")
DbSelectArea("JC7")	//ITENS DA ALOCACAO DO ALUNO
RetIndex("JC7")
DbSelectArea("JBE")	//HEADER DA ALOCACAO DO ALUNO
RetIndex("JBE")
DbSelectArea("SE1") //DADOS TITULOS X ALUNOS
RetIndex("SE1")

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACATRB0012| Autor ³ Alan S. R. Oliveira   ³ Data ³ 19/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Armazenamento e Tratamento dos dados 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	 ³ Especifico Academico              				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³								            ³ Data ³  		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION ACATRB0012()

Local _aCampos   := {}
Local cQuery     := ""
Local aTamRA     := TamSX3("JA2_NUMRA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a variavel com o Numero do RA de acordo com o tamanho do  ³
//³ campo JA2_NUMRA (Numero do RA).				                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRA := Left(JBH_CODIDE,aTamRA[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna um vetor com os conteudos dos campos do script          ³
//³na ordem que foi configurada no tipo do requerimento.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumReq := JBH->JBH_NUM
aRet := ACScriptReq( cNumReq )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho			       				     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(_aCampos,{"NOMCURS"   	,"C",030,0})
Aadd(_aCampos,{"RA"        	,"C",030,0})
Aadd(_aCampos,{"SEXO"      	,"C",001,0})
Aadd(_aCampos,{"NOMEAL"    	,"C",060,0})
Aadd(_aCampos,{"BAIXA"    	,"D",008,0})
Aadd(_aCampos,{"DTMES"    	,"D",008,0})
Aadd(_aCampos,{"VALPGTO"   	,"N",008,0})
Aadd(_aCampos,{"SALDO"     	,"N",008,0})
Aadd(_aCampos,{"PAGTO1" 	,"N",008,0})
Aadd(_aCampos,{"PAGTO2" 	,"N",008,0})
Aadd(_aCampos,{"PAGTO3" 	,"N",008,0})   
Aadd(_aCampos,{"MES"	   	,"C",009,0})
Aadd(_aCampos,{"SEMPGTO"   	,"C",002,0})
Aadd(_aCampos,{"ANOPGTO"   	,"C ",004,0})
Aadd(_aCampos,{"DHABILI"    ,"C",100,0})

_cArqTmp := CriaTrab(_aCampos,.T.)
dbUseArea( .T.,, _cArqTmp, "TRB", .F., .F. )

cQuery := "SELECT "
cQuery += "SE1.E1_VENCTO DTMES , SE1.E1_BAIXA BAIXA , SE1.E1_VALOR VALOR, "
cQuery += "JA2.JA2_NOME NOME , JB5.JB5_PAGTO1 PAGTO1 , JB5.JB5_PERC1 PERC1 , "
cQuery += "JB5.JB5_PAGTO2 PAGTO2 , JB5.JB5_PERC2 PERC2 , JB5.JB5_PAGTO3 PAGTO3 , "
cQuery += "JB5.JB5_PERC3 PERC3 , JA2.JA2_SEXO SEXO , SE1.E1_SALDO SALDO , SE1.E1_VALLIQ VALLIQ " 

cQuery += "FROM " + RetSQLName("JA2") + " JA2, " + RetSQLName("SE1") + " SE1, "
cQuery +=  RetSQLName("JB5") + " JB5, " + RetSQLName("JBE") + " JBE "

cQuery += "WHERE JA2.JA2_FILIAL = '" + xFilial("JA2") + "' AND "
cQuery += "SE1.E1_FILIAL  		= '" + xFilial("SE1") + "' AND "
cQuery += "JB5.JB5_FILIAL 		= '" + xFilial("JB5") + "' AND "
cQuery += "JBE.JBE_FILIAL 		= '" + xFilial("JBE") + "' AND "

cQuery += "JA2.JA2_NUMRA  		= '" + cRA + "' AND "
cQuery += "JBE.JBE_NUMRA  		= '" + cRA + "' AND "
cQuery += "JBE.JBE_CODCUR 		=  '" + aRet[1] + "' AND "
cQuery += "JBE.JBE_ATIVO  		= '1' AND "
cQuery += "JB5.JB5_CODCUR 		= '" + aRet[1] + "' AND "
cQuery += "SE1.E1_CLIENTE 		= JA2.JA2_CLIENT AND "
cQuery += "SE1.E1_VALOR 		= JB5.JB5_VALOR AND "
cQUERY += "JB5.JB5_PERLET		= '"+ aRet[3] + "' AND "
cQUERY += "JB5.JB5_HABILI       = '"+ aRet[4] + "' AND "

cQuery += "JA2.D_E_L_E_T_ <> '*' AND "
cQuery += "SE1.D_E_L_E_T_ <> '*' AND "
cQuery += "JB5.D_E_L_E_T_ <> '*' AND "
cQuery += "JBE.D_E_L_E_T_ <> '*' "

cQuery += "GROUP BY SE1.E1_VENCTO , SE1.E1_BAIXA , SE1.E1_VALOR , JA2.JA2_NOME , "
cQuery += "JA2.JA2_SEXO , JB5.JB5_PAGTO1 , JB5.JB5_PERC1 , "
cQuery += "JB5.JB5_PAGTO2 , JB5.JB5_PERC2 , JB5.JB5_PAGTO3 , JB5.JB5_PERC3 , "
cQuery += "SE1.E1_SALDO , SE1.E1_VALLIQ "

cQuery += "ORDER BY SE1.E1_SALDO , SE1.E1_VENCTO "

cQuery := ChangeQuery(cQuery)   

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQJ", .F., .T.)

TcSetField("SQJ","BAIXA"	,"D",8,0) 
TcSetField("SQJ","DTMES"	,"D",8,0)
TcSetField("SQJ","VALOR"	,"N",8,0) 
TcSetField("SQJ","VALLIQ"	,"N",8,0) 
TcSetField("SQJ","SALDO"	,"N",8,0)  
TcSetField("SQJ","PERC1"	,"N",8,0)  
TcSetField("SQJ","PERC2"	,"N",8,0)  
TcSetField("SQJ","PERC3"	,"N",8,0)    
  
DbSelectArea("SQJ")
While !Eof()
	check += 1
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
			
	TRB->NOMCURS		:= aRet[2] 
	TRB->RA				:= cRA
	TRB->SEXO			:= IF(SQJ->SEXO = "1","o","a")
	TRB->NOMEAL			:= SQJ->NOME
	TRB->BAIXA			:= SQJ->BAIXA
	TRB->VALPGTO		:= SQJ->VALLIQ
	TRB->SALDO			:= SQJ->SALDO
	TRB->PAGTO1			:= SQJ->VALOR - ((SQJ->VALOR * SQJ->PERC1) / 100)
	TRB->PAGTO2			:= SQJ->VALOR - ((SQJ->VALOR * SQJ->PERC2) / 100)
	TRB->PAGTO3 		:= SQJ->VALOR - ((SQJ->VALOR * SQJ->PERC3) / 100)
	TRB->DTMES			:= SQJ->DTMES
	TRB->SEMPGTO		:= aRet[8]
	TRB->ANOPGTO		:= aRet[7]
	TRB->DHABILI        := Iif(Empty(aRet[4]), " ", ", Habilitação " + AllTrim(aRet[5]))

	MsUnlock() 
	DbSelectArea("SQJ")
	Dbskip()
ENDDO    
  
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³  PREL0012³ Autor ³  Alan S. R. Oliveira  ³ Data ³ 19/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do WORD  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³		                                    ³ Data ³  		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function PREL0012()      

Private nCntFor
Private nCntFor1

nCntFor 	:= 0
nCntFor1 	:= 0                                              

			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando link de comunicacao com o word                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

hWord := OLE_CreateLink()
OLE_SetProperty ( hWord, oleWdVisible, .T.) //VISUALIZAR O DOT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seu Documento Criado no Word                                          ³
//³ A extensao do documento tem que ser .DOT                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArqDot  := "SEC0012.DOT" // Nome do Arquivo MODELO do Word
cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD

//Local HandleWord
Private cPathEst:= Alltrim(GetMv("MV_DIREST")) // PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO
MontaDir(cPathEst)

If !File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgBox("Atencao... SEC0012.DOT nao encontrado no Servidor")
	Return NIL
EndIf

// Caso encontre arquivo ja gerado na estacao
//com o mesmo nome apaga primeiramente antes de gerar a nova impressao
If File( cPathEst + cArqDot )
	Ferase( cPathEst + cArqDot )
EndIf

CpyS2T(cPathDot,cPathEst,.T.) // Copia do Server para o Remote, eh necessario
//para que o wordview e o proprio word possam preparar o arquivo para impressao e
// ou visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da
// estacao , por exemplo C:\WORDTMP


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gerando novo documento do Word na estacao                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_NewFile( hWord, cPathEst + cArqDot)

DbSelectArea("TRB")
DbGoTop()

	OLE_SetDocumentVar(hWord, "cNOME"       , Alltrim(TRB->NOMEAL))
	OLE_SetDocumentVar(hWord, "nRA"         , Alltrim(TRB->RA))
	OLE_SetDocumentVar(hWord, "cSEXO"		, Alltrim(TRB->SEXO ))
	OLE_SetDocumentVar(hWord, "cNOMCURS"	, Alltrim(TRB->NOMCURS))
	OLE_SetDocumentVar(hWord, "nDIA"     	, Day(dDataBase))
	OLE_SetDocumentVar(hWord, "cANO"     	, Year(dDataBase))
	OLE_SetDocumentVar(hWord, "cMESATU"    	, Alltrim(MesExtenso(Month(dDataBase))))
	OLE_SetDocumentVar(hWord, "cSEMPGTO"  	, TRB->SEMPGTO)
	OLE_SetDocumentVar(hWord, "cANOPGTO"  	, TRB->ANOPGTO)   
	OLE_SetDocumentVar(hWord, "cNOMHABILI"  , Iif(Empty(TRB->DHABILI), " ", Alltrim(TRB->DHABILI)))
	
While !Eof()
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando variaveis do documento                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_SetDocumentVar(hWord, "cMESPGTO1" , "  ")
		OLE_SetDocumentVar(hWord, "cPG1" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA1" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO2" , "  ")
		OLE_SetDocumentVar(hWord, "cPG2" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA2" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO3" , "  ")
		OLE_SetDocumentVar(hWord, "cPG3" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA3" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO4" , "  ")
		OLE_SetDocumentVar(hWord, "cPG4" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA4" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO5" , "  ")
		OLE_SetDocumentVar(hWord, "cPG5" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA5" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO6" , "  ")
		OLE_SetDocumentVar(hWord, "cPG6" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA6" , "  ")  
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR11", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO11" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO12" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO13" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR22", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO21" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO22" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO23" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR33", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO31" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO32" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO33" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR44", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO41" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO42" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO43" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR55", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO51" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO52" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO53" , "  ")
		
	While !Eof() .AND. TRB->SALDO = 0
	
	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gerando variaveis do documento                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		nCntFor += 1
	
							
		IF nCntFor == 1
		
		OLE_SetDocumentVar(hWord, "cMESPGTO1" ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG1" , "R$" + STR(TRB->VALPGTO,6,2))
		OLE_SetDocumentVar(hWord, "dBAIXA1" , TRB->BAIXA)
			   
		ELSEIF nCntFor == 2
		
		OLE_SetDocumentVar(hWord, "cMESPGTO2" ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG2" , "R$" + STR(TRB->VALPGTO,6,2))
		OLE_SetDocumentVar(hWord, "dBAIXA2" , TRB->BAIXA)
					
		ELSEIF nCntFor == 3
		                                                     
		OLE_SetDocumentVar(hWord, "cMESPGTO3"   ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG3" , "R$" + STR(TRB->VALPGTO,6,2))
		OLE_SetDocumentVar(hWord, "dBAIXA3"	, TRB->BAIXA)
					
		ELSEIF nCntFor == 4
		                                                     
		OLE_SetDocumentVar(hWord, "cMESPGTO4"   ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG4" , "R$" + STR(TRB->VALPGTO,6,2))
		OLE_SetDocumentVar(hWord, "dBAIXA4" , TRB->BAIXA)
		
		ELSEIF nCntFor == 5
					                                                                     
		OLE_SetDocumentVar(hWord, "cMESPGTO5",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG5",  "R$" + STR(TRB->VALPGTO,6,2))
		OLE_SetDocumentVar(hWord, "dBAIXA5"	, TRB->BAIXA)
		
		ELSEIF nCntFor == 6
		
		OLE_SetDocumentVar(hWord, "cMESPGTO6",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG6"	, "R$" + STR(TRB->VALPGTO,6,2))
		OLE_SetDocumentVar(hWord, "dBAIXA6" , TRB->BAIXA)
		
		ENDIF
		
	
		DbSkip()
		
	ENDDO
	
	
	While !Eof() .AND. TRB->SALDO > 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gerando variaveis do documento tabela dos nao pagos                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		nCntFor1 += 1
		
		IF nCntFor1 == 1
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR11",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO11" , "R$" + STR(TRB->PAGTO1,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO12" , "R$" + STR(TRB->PAGTO2,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO13" , "R$" + STR(TRB->PAGTO3,6,2))
		
		ELSEIF nCntFor1 == 2
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR22",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO21" , "R$" + STR(TRB->PAGTO1,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO22" , "R$" + STR(TRB->PAGTO2,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO23" , "R$" + STR(TRB->PAGTO3,6,2))
		
		ELSEIF nCntFor1 == 3
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR33",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO31" , "R$" + STR(TRB->PAGTO1,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO32" , "R$" + STR(TRB->PAGTO2,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO33" , "R$" + STR(TRB->PAGTO3,6,2))
		
		ELSEIF nCntFor1 == 4
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR44",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO41" , "R$" + STR(TRB->PAGTO1,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO42" , "R$" + STR(TRB->PAGTO2,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO43" , "R$" + STR(TRB->PAGTO3,6,2))
		
		ELSEIF nCntFor1 == 5
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR55",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO51" , "R$" + STR(TRB->PAGTO1,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO52" , "R$" + STR(TRB->PAGTO2,6,2))
		OLE_SetDocumentVar(hWord, "cPGTO53" , "R$" + STR(TRB->PAGTO3,6,2))
		
		ENDIF
							
		DbSkip()
	ENDDO
	
ENDDO	   
			
OLE_UpdateFields(hWord)

Return
