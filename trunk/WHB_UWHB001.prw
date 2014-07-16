#INCLUDE "protheus.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Update                                                  !
+------------------+---------------------------------------------------------+
!Modulo            ! Genérico                                                !
+------------------+---------------------------------------------------------+
!Nome              ! WHB_UWHB001.PRW                                         !
+------------------+---------------------------------------------------------+
!Descricao         ! Update das tabelas para a lista de preços.              !
+------------------+---------------------------------------------------------+
!Autor             ! Cleverson Funaki                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/06/2012                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+ 
*/
User Function UWHB001

cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 51 // modulo SIGAHSP

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [GH]","Aguarde , processando preparação dos arquivos")

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
		If Alltrim(M0_CODIGO) == "FN" .Or. Alltrim(M0_CODIGO) == "NH"
	  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0
				Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
			EndIf			
		Endif
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
 		nModulo := 51 // modulo SIGAHSP
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			Begin Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += GeraSX2()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Gatilhos...")
			cTexto += GeraSX7()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
			cTexto += GeraSIX()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os Consulta padrao.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Consulta Padrão...")
 		cTexto += GeraSXB()

			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 EndIf
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [GH] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit	
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX2  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX2()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z01","                                        ","Z01FN0  ","TIPOS DE COMPOSICAO           ","TIPOS DE COMPOSICAO           ","TIPOS DE COMPOSICAO           ","                                        ","E","E","E",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              ","                              ","                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z02","                                        ","Z02FN0  ","CABEC. COMPOSICAO DE PRECOS   ","CABEC. COMPOSICAO DE PRECOS   ","CABEC. COMPOSICAO DE PRECOS   ","                                        ","E","E","E",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              ","                              ","                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z03","                                        ","Z03FN0  ","ITENS COMPOSICAO DE PRECOS    ","ITENS COMPOSICAO DE PRECOS    ","ITENS COMPOSICAO DE PRECOS    ","                                        ","E","E","E",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              ","                              ","                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z04","                                        ","Z04FN0  ","ESTRUTURA X PRECOS            ","ESTRUTURA X PRECOS            ","ESTRUTURA X PRECOS            ","                                        ","E","E","E",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              ","                              ","                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX3  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z01","01","Z01_FILIAL","C",02,00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal                 ","Branch of the System     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€€","                                                                                                                                ","      ",01,"þÀ"," "," ","U","N"," "," "," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","033"," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," "," "," ","               ","N  ","N","N","N"})
AADD(aRegs,{"Z01","02","Z01_CODIGO","C",06,00,"Codigo      ","Codigo      ","Codigo      ","Codigo do tipo           ","Codigo do tipo           ","Codigo do tipo           ","@R !!!.!!!                                   ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","ExistChav('Z01')                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","INCLUI                                                      ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z01","03","Z01_DESCRI","C",30,00,"Descricao   ","Descricao   ","Descricao   ","Descricao do tipo        ","Descricao do tipo        ","Descricao do tipo        ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z01","04","Z01_TIPO  ","C",01,00,"Tipo        ","Tipo        ","Tipo        ","Tipo                     ","Tipo                     ","Tipo                     ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","'A'                                                                                                                             ","      ",00,"þÀ"," "," ","U","S","A","R"," ","Pertence('AS')                                                                                                                  "," S=Sintetico;A=Analitico                                                                                                        ","                                                                                                                                ","                                                                                                                                ","                    ","INCLUI                                                      ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z01","05","Z01_ESTRUT","C",01,00,"Estrut.Prod?","Estrut.Prod?","Estrut.Prod?","Utiliza estrut do produto","Utiliza estrut do produto","Utiliza estrut do produto","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","'N'                                                                                                                             ","      ",00,"þÀ"," "," ","U","S","A","R"," ","PERTENCE('SN')                                                                                                                  ","S=Sim;N=Nao                                                                                                                     ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z01","06","Z01_TPPROD","C",02,00,"Tipo Produto","Tipo Produto","Tipo Produto","Tipo produto estrutura   ","Tipo produto estrutura   ","Tipo produto estrutura   ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","02    ",00,"þÀ"," "," ","U","S","A","R"," ","ExistCpo('SX5','02'+M->Z01_TPPROD)                                                                                              ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","IIF(M->Z01_ESTRUT=='S',.T.,.F.)                             ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z02","01","Z02_FILIAL","C",02,00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal                 ","Branch of the System     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€€","                                                                                                                                ","      ",01,"þÀ"," "," ","U","N"," "," "," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","033"," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," "," "," ","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","02","Z02_CODIGO","C",10,00,"Pedido      ","Pedido      ","Pedido      ","Numero do pedido         ","Numero do pedido         ","Numero do pedido         ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","INCLUI                                                      ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","03","Z02_ALTPED","C",10,00,"Alter Pedido","Alter Pedido","Alter Pedido","Num alteracao do pedido  ","Num alteracao do pedido  ","Num alteracao do pedido  ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","04","Z02_TPCONT","C",01,00,"Tp Controle ","Tp Controle ","Tp Controle ","Tipo Controle            ","Tipo Controle            ","Tipo Controle            ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","'A'                                                                                                                             ","      ",00,"þÀ"," "," ","U","S","A","R","€","PERTENCE('AF')                                                                                                                  ","A=Aberto;F=Fechado                                                                                                              ","                                                                                                                                ","                                                                                                                                ","                    ","INCLUI                                                      ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","05","Z02_REVISA","C",03,00,"Revisao     ","Revisao     ","Revisao     ","Revisao                  ","Revisao                  ","Revisao                  ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","'001'                                                                                                                           ","      ",00,"þÀ"," "," ","U","S","V","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","06","Z02_PRODUT","C",15,00,"Produto     ","Produto     ","Produto     ","Codigo do produto        ","Codigo do produto        ","Codigo do produto        ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","SB1   ",00,"þÀ"," ","S","U","S","A","R","€","ExistCpo('SB1')                                                                                                                 ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","INCLUI                                                      ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","07","Z02_DESPRO","C",30,00,"Descricao   ","Descricao   ","Descricao   ","Descricao do produto     ","Descricao do produto     ","Descricao do produto     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","POSICIONE('SB1',1,XFILIAL('SB1')+M->Z02_PRODUT,'B1_DESC')                                                                       ","      ",00,"þÀ"," "," ","U","S","V","V"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","Posicione('SB1',1,xFilial('SB1')+Z02->Z02_PRODUT,'B1_DESC')                     ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","08","Z02_CLIENT","C",06,00,"Cliente     ","Cliente     ","Cliente     ","Codigo do cliente        ","Codigo do cliente        ","Codigo do cliente        ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","SA1   ",00,"þÀ"," ","S","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","INCLUI                                                      ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","09","Z02_LOJA  ","C",02,00,"Loja        ","Loja        ","Loja        ","Loja do cliente          ","Loja do cliente          ","Loja do cliente          ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," ","S","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","INCLUI                                                      ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","10","Z02_NOMCLI","C",15,00,"Nome        ","Nome        ","Nome        ","Nome do cliente          ","Nome do cliente          ","Nome do cliente          ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","POSICIONE('SA1',1,XFILIAL('SA1')+M->Z02_CLIENT+M->Z02_LOJA,'A1_NREDUZ')                                                         ","      ",00,"þÀ"," "," ","U","S","V","V"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","Posicione('SA1',1,xFilial('SA1')+Z02->Z02_CLIENT+Z02->Z02_LOJA,'A1_NREDUZ')     ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","11","Z02_DTINI ","D",08,00,"Data Inicio ","Data Inicio ","Data Inicio ","Data Inicio              ","Data Inicio              ","Data Inicio              ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","12","Z02_DTFIM ","D",08,00,"Data Fim    ","Data Fim    ","Data Fim    ","Data Fim                 ","Data Fim                 ","Data Fim                 ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","13","Z02_VOLUME","N",08,00,"Volume      ","Volume      ","Volume      ","Volume                   ","Volume                   ","Volume                   ","@E 99,999,999                                ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," ","S","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","14","Z02_SALDO ","N",08,00,"Saldo Volume","Saldo Volume","Saldo Volume","Saldo Volume             ","Saldo Volume             ","Saldo Volume             ","@E 99,999,999                                ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","15","Z02_OBS   ","M",10,00,"Observacao  ","Observacao  ","Observacao  ","Observacao               ","Observacao               ","Observacao               ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","16","Z02_USER  ","C",25,00,"Usuario     ","Usuario     ","Usuario     ","Usuario                  ","Usuario                  ","Usuario                  ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","CUSERNAME                                                                                                                       ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","17","Z02_DTALT ","D",08,00,"Dt Inc./Alt.","Dt Inc./Alt.","Dt Inc./Alt.","Data Inclusao / Alteracao","Data Inclusao / Alteracao","Data Inclusao / Alteracao","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","DATE()                                                                                                                          ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z02","18","Z02_HORA  ","C",05,00,"Hora Inc/Alt","Hora Inc/Alt","Hora Inc/Alt","Hora Inclusao/Alteracao  ","Hora Inclusao/Alteracao  ","Hora Inclusao/Alteracao  ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","TIME()                                                                                                                          ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z03","01","Z03_FILIAL","C",02,00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal                 ","Branch of the System     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€€","                                                                                                                                ","      ",01,"þÀ"," "," ","U","N"," "," "," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","033"," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," "," "," ","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","02","Z03_CODIGO","C",10,00,"Tabela      ","Tabela      ","Tabela      ","Codigo da tabela         ","Codigo da tabela         ","Codigo da tabela         ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","03","Z03_ALTPED","C",10,00,"Alter Pedido","Alter Pedido","Alter Pedido","Num alteracao pedido     ","Num alteracao pedido     ","Num alteracao pedido     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","04","Z03_TPCONT","C",01,00,"Tipo Control","Tipo Control","Tipo Control","Tipo Controle            ","Tipo Controle            ","Tipo Controle            ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","05","Z03_REVISA","C",03,00,"Revisao     ","Revisao     ","Revisao     ","Revisao                  ","Revisao                  ","Revisao                  ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","06","Z03_PRODUT","C",15,00,"Produto     ","Produto     ","Produto     ","Codigo do produto        ","Codigo do produto        ","Codigo do produto        ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","07","Z03_CLIENT","C",06,00,"Cliente     ","Cliente     ","Cliente     ","Codigo do cliente        ","Codigo do cliente        ","Codigo do cliente        ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","08","Z03_LOJA  ","C",02,00,"Loja        ","Loja        ","Loja        ","Loja do cliente          ","Loja do cliente          ","Loja do cliente          ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","09","Z03_CODCOM","C",06,00,"Codigo      ","Codigo      ","Codigo      ","Codigo composicao        ","Codigo composicao        ","Codigo composicao        ","@R !!!.!!!                                   ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","Z01   ",00,"þÀ"," ","S","U","S","A","R","€","U_AFAT002B()                                                                                                                    ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","10","Z03_SINTET","C",30,00,"Tipo Sintet.","Tipo Sintet.","Tipo Sintet.","Tipo Sintetico           ","Tipo Sintetico           ","Tipo Sintetico           ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","V"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","11","Z03_DESCRI","C",30,00,"Descricao   ","Descricao   ","Descricao   ","Descricao                ","Descricao                ","Descricao                ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","V"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})
AADD(aRegs,{"Z03","12","Z03_VALOR ","N",15,02,"Valor       ","Valor       ","Valor       ","Valor                    ","Valor                    ","Valor                    ","@E 999,999,999,999.99                        ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","U_AFAT002H()                                                                                                                    ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z04","01","Z04_FILIAL","C",02,00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal                 ","Branch of the System     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€€","                                                                                                                                ","      ",01,"þÀ"," "," ","U","N"," "," "," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","033"," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," "," "," ","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","02","Z04_CODIGO","C",10,00,"Tabela      ","Tabela      ","Tabela      ","Codigo da tabela         ","Codigo da tabela         ","Codigo da tabela         ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","03","Z04_REVISA","C",03,00,"Revisao     ","Revisao     ","Revisao     ","Revisao                  ","Revisao                  ","Revisao                  ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","04","Z04_TPCONT","C",01,00,"Tipo Control","Tipo Control","Tipo Control","Tipo Controle            ","Tipo Controle            ","Tipo Controle            ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R","€","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","05","Z04_PRODUT","C",15,00,"Produto     ","Produto     ","Produto     ","Codigo do produto        ","Codigo do produto        ","Codigo do produto        ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","06","Z04_CLIENT","C",06,00,"Cliente     ","Cliente     ","Cliente     ","Codigo do cliente        ","Codigo do cliente        ","Codigo do cliente        ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","07","Z04_LOJA  ","C",02,00,"Loja        ","Loja        ","Loja        ","Loja do cliente          ","Loja do cliente          ","Loja do cliente          ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","08","Z04_CODCOM","C",06,00,"Codigo      ","Codigo      ","Codigo      ","Codigo composicao        ","Codigo composicao        ","Codigo composicao        ","@R !!!.!!!                                   ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","Z01   ",00,"þÀ"," ","S","U","S","A","R","€","U_AFAT002B()                                                                                                                    ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","09","Z04_CODPRO","C",15,00,"Produto     ","Produto     ","Produto     ","Codigo do produto        ","Codigo do produto        ","Codigo do produto        ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","10","Z04_DESCRI","C",30,00,"Descricao   ","Descricao   ","Descricao   ","Descricao do produto     ","Descricao do produto     ","Descricao do produto     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","11","Z04_VALOR ","N",15,02,"Preco       ","Preco       ","Preco       ","Preco                    ","Preco                    ","Preco                    ","@E 999,999,999,999.99                        ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," ","S","U","S","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z04","12","Z04_ALTPED","C",10,00,"Alter.Pedido","Alter.Pedido","Alter.Pedido","Alteraçao do pedido      ","Alteraçao do pedido      ","Alteraçao do pedido      ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZR","23","ZR_TABPRC ","C",40,00,"Tabela Preco","Tabela Preco","Tabela Preco","Chave tabela preco utiliz","Chave tabela preco utiliz","Chave tabela preco utiliz","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€€","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","N  ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SC6","D3","C6_TABPRC ","C",40,00,"Tab. Preco  ","Tab. Preco  ","Tab. Preco  ","Tabela Preco             ","Tabela Preco             ","Tabela Preco             ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","V"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX7  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX7()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z02_PRODUT","001","Posicione('SB1',1,xFilial('SB1')+M->Z02_PRODUT,'B1_DESC')                                           ","Z02_DESPRO","P","N","   ",00,"                                                                                                    ","                                        ","U"})
AADD(aRegs,{"Z02_PRODUT","002","U_AFAT002G()                                                                                        ","Z02_PRODUT","P","N","   ",00,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z02_CLIENT","001","Posicione('SA1',1,xFilial('SA1')+M->Z02_CLIENT+M->Z02_LOJA,'A1_NOME')                               ","Z02_NOMCLI","P","N","   ",00,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z02_LOJA  ","001","Posicione('SA1',1,xFilial('SA1')+M->Z02_CLIENT+M->Z02_LOJA,'A1_NOME')                               ","Z02_NOMCLI","P","N","   ",00,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z02_VOLUME","001","M->Z02_VOLUME                                                                                       ","Z02_SALDO ","P","N","   ",00,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z03_CODCOM","001","Posicione('Z01',1,xFilial('Z01')+Substr(M->Z03_CODCOM,1,3),'Z01_DESCRI')                            ","Z03_SINTET","P","N","   ",00,"                                                                                                    ","                                        ","U"})
AADD(aRegs,{"Z03_CODCOM","002","Posicione('Z01',1,xFilial('Z01')+M->Z03_CODCOM,'Z01_DESCRI')                                        ","Z03_DESCRI","P","N","   ",00,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z04_VALOR ","001","U_AFAT002F()                                                                                        ","Z04_VALOR ","P","N","   ",00,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX7 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSIX  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSIX()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z01","1","Z01_FILIAL+Z01_CODIGO                                                                                                                                           ","Codigo                                                                ","Codigo                                                                ","Codigo                                                                ","U","                                                                                                                                                                ","          ","S"})
AADD(aRegs,{"Z01","2","Z01_FILIAL+Z01_DESCRI                                                                                                                                           ","Descricao                                                             ","Descricao                                                             ","Descricao                                                             ","U","                                                                                                                                                                ","          ","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z02","1","Z02_FILIAL+Z02_CODIGO+Z02_ALTPED+Z02_TPCONT+Z02_REVISA+Z02_PRODUT+Z02_CLIENT+Z02_LOJA                                                                           ","Pedido+Alter Pedido+Tp Controle+Revisao+Produto+Cliente+Loja          ","Pedido+Alter Pedido+Tp Controle+Revisao+Produto+Cliente+Loja          ","Pedido+Alter Pedido+Tp Controle+Revisao+Produto+Cliente+Loja          ","U","                                                                                                                                                                ","          ","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z03","1","Z03_FILIAL+Z03_CODIGO+Z03_ALTPED+Z03_TPCONT+Z03_REVISA+Z03_PRODUT+Z03_CLIENT+Z03_LOJA+Z03_CODCOM                                                                ","Tabela+Alter Pedido+Tipo Control+Revisao+Produto+Cliente+Loja+Codigo  ","Tabela+Alter Pedido+Tipo Control+Revisao+Produto+Cliente+Loja+Codigo  ","Tabela+Alter Pedido+Tipo Control+Revisao+Produto+Cliente+Loja+Codigo  ","U","                                                                                                                                                                ","          ","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"Z04","1","Z04_FILIAL+Z04_CODIGO+Z04_ALTPED+Z04_REVISA+Z04_TPCONT+Z04_PRODUT+Z04_CLIENT+Z04_LOJA+Z04_CODCOM+Z04_CODPRO                                                     ","Tabela+Alter.+Revisao+Tipo Control+Produto+Cliente+Loja+Codigo+Produto","Tabela+Alter.+Revisao+Tipo Control+Produto+Cliente+Loja+Codigo+Produto","Tabela+Alter.+Revisao+Tipo Control+Produto+Cliente+Loja+Codigo+Produto","U","                                                                                                                                                                ","          ","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSXB  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSXB()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z01   ","1","01","DB","TIPOS DE COMPOSICAO ","TIPOS DE COMPOSICAO ","TIPOS DE COMPOSICAO ","Z01                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","2","01","01","Codigo              ","Codigo              ","Codigo              ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","2","02","02","Descricao           ","Descricao           ","Descricao           ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","4","01","01","Codigo              ","Codigo              ","Codigo              ","Z01_CODIGO                                                                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","4","01","02","Descricao           ","Descricao           ","Descricao           ","Z01_DESCRI                                                                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","4","02","01","Descricao           ","Descricao           ","Descricao           ","Z01_DESCRI                                                                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","4","02","02","Codigo              ","Codigo              ","Codigo              ","Z01_CODIGO                                                                                                                                                                                                                                                ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","5","01","  ","                    ","                    ","                    ","Z01->Z01_CODIGO                                                                                                                                                                                                                                           ","                                                                                                                                                                                                                                                          "})
AADD(aRegs,{"Z01   ","6","01","  ","                    ","                    ","                    ","Z01->Z01_TIPO=='A'                                                                                                                                                                                                                                        ","                                                                                                                                                                                                                                                          "})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SXB : ' + cTexto  + CHR(13) + CHR(10))
