/*                                   
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHTRM002 ºAutor  ³João Felipe da Rosa  º Data ³  14/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TREINAMENTO                                                º±±
±±º          ³ MATRIZ DE VERSATILIDADE                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RH                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch" 
#INCLUDE "MSOLE.CH"
#include "AP5MAIL.CH" 

User Function NHTRM002()  

Private cAlias    := "ZB0"
Private aRotina   := {}
Private lRefresh  := .T.
Private cCadastro := "C.Custo x Atividades"
Private aButtons  := {}
Private _cUsrAdm  := "JUCINEIAT/ANDREIARB/KARINERM/ADMINISTRADOR/ADMIN/JOAOFR/ALECSANDRAH/SIMARARO/TAINARAFF/JOSEBO/LEOB"

aAdd( aRotina, {"Pesquisar"    ,"AxPesqui"    ,0,1} )
aAdd( aRotina, {"Visualizar"   ,"U_fTRM02(2)" ,0,2} )
aAdd( aRotina, {"Incluir"      ,"U_fTRM02(3)" ,0,3} )
aAdd( aRotina, {"Alterar"      ,"U_fTRM02(4)" ,0,4} )
aAdd( aRotina, {"Excluir"      ,"U_fTRM02(5)" ,0,5} )  
aAdd( aRotina, {"Matriz"       ,"U_fTRM02M()" ,0,4} ) 
//aAdd( aRotina, {"Atu CC 2011"  ,"U_ATUCC2011()" ,0,4} ) 
//aAdd( aRotina, {"Atu Atv"  ,"U_ATUATV()" ,0,4} ) 
//aAdd( aRotina, {"Atu Fun"  ,"U_ATUFUN()" ,0,4} ) 

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CADASTRO DE ATIVIDADES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fTRM02(nParam)
Local _cCampo

Private aCols    := {}
Private aHeader  := {}
Private nPar     := nParam
Private _cCC     := SPACE(9)
Private _cAtivid := SPACE(250)
Private _cCodAtv := SPACE(6)
Private _cArea   := Space(6)
Private aZB0Area := ZB0->(GETAREA())
		
	//AHEADER 
	Aadd(aHeader,{"C.Custo"    , "ZB0_CC"	  ,"@!"   ,09,0,"U_fDescCC()","","C","ZB0"}) 
	Aadd(aHeader,{"Descrição"  , "CTT_DESC01" ,"@!"   ,50,0,".F.","","C","CTT"}) 
	Aadd(aHeader,{"Area"       , "ZB0_AREA"   ,"@!"   ,06,0,".T.","","C","ZB0"}) 
	Aadd(aHeader,{"Generica"   , "ZB0_GENERI" ,"@!"   ,01,0,".T.","","C","ZB0"}) 
	
	//Fontes
	DEFINE FONT oFont NAME "Arial" SIZE 12, -12
	
	//Inicializa os dados
	If nPar==2 .or. nPar==4 .or. nPar==5 //Visualizar, alterar, excluir
	
		_cCodAtv    := ZB0->ZB0_CODATV	
		_cAtivid    := ZB0->ZB0_ATIVID  
	
		CTT->(DBSETORDER(1)) //FILIAL + CC
		CTT->(DBSEEK(XFILIAL("CTT")+ZB0->ZB0_CC))
		aAdd(aCols,{ZB0->ZB0_CC,CTT->CTT_DESC01,ZB0->ZB0_AREA,ZB0->ZB0_GENERI,.F.})
	
	EndIf
	
	//inclui
	If nPar == 3 
		_cCodAtv := GetSxeNum("ZB0","ZB0_CODATV")
	EndIf
	
	//Constrói a tela do CADASTRO DE ATIVIDADES 
	DEFINE MSDIALOG oDlg TITLE "C.Custo x Atividades" FROM 0,0 TO 330,600 PIXEL
	
	@ 010,010 TO 140,290 LABEL "Atividade" OF oDlg PIXEL
	
	@ 020,015 SAY "Num. Atividade: "    Size 040,008 Object olCodAtv
	@ 020,055 SAY _cCodAtv          Size 040,008 Object oCodAtv
	oCodAtv:Setfont(oFont)
	
	@ 035,015 SAY "Desc. Atividade: " Size 040,008 Object olAtivid
	@ 035,055 GET _cAtivid Picture "@!" When(nPar==3 .or. nPar==4) Size 170,008 Object oAtivid
	
	//Multiline
	DbSelectArea('ZB0')
	@ 050,010 TO 140,290 MULTILINE MODIFY DELETE OBJECT oMline
	
	IF nPar == 2 //Visualizar
		oMline:nMax := len(aCols) //nao deixa o usuario adicionar mais uma linha no mline
	EndIf
	
	@ 145,205 BUTTON "&Ok"       SIZE 40,15 PIXEL ACTION fOk()
	@ 145,250 BUTTON "&Cancelar" SIZE 40,15 PIXEL ACTION fEnd()
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	ZB0->(restArea(aZB0Area))
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A DESCRICAO DO C.CUSTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fDescCC()
	DbSelectArea("CTT")
	DbSetOrder(1) //filial + CC
	If(DbSeek(xFilial("CTT")+M->ZB0_CC))//aCols[n][1]))
		aCols[n][2] := CTT->CTT_DESC01
		oMline:Refresh()
	Else
		Alert("C.Custo não encontrado!")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄ¿
//³ OK ³
//ÀÄÄÄÄÙ
Static Function fOk()
Private lOk := .F.

	If nPar == 2     //Visualiza
		lOk := .T.
	ElseIf nPar == 3 //Incluir
		fGrv()
	ElseIf nPar == 4 //Alterar
		fAlt()
	ElseIf nPar == 5 //Excluir
		fExcl()
	EndIf

	If lOk
		oDlg:End()
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³ CANCELAR ³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEnd()
	
	RollBackSx8()
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fGrv()

	ZB0->(DBSETORDER(1)) //FILIAL + ATV + CC
	
	For _x:= 1 to len(aCols)

   		If !aCols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
	
			If !fVal()
				Return
			EndIf
	
			RecLock("ZB0",.T.)
				ZB0->ZB0_FILIAL := xFilial("ZB0")
				ZB0->ZB0_CODATV := _cCodAtv
				ZB0->ZB0_CC     := aCols[_x][1]
				ZB0->ZB0_ATIVID := _cAtivid
				ZB0->ZB0_AREA   := aCols[_x][3]
				ZB0->ZB0_GENERI := aCols[_x][4]
			MsUnlock("ZB0")

			ConfirmSx8()
	
			lOk := .T.
		EndIf
	Next
	
Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAlt()

	ZB0->(DBSETORDER(1)) //FILIAL + ATV + CC
	
	For _x:= 1 to len(aCols)

   		If !aCols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
	
			If !fVal()
				Return
			EndIf
	
			IF ZB0->(DBSEEK(XFILIAL('ZB0')+_cCodAtv+aCols[_x][1])) .and. ;//Atv + CC
			   ZB0->ZB0_AREA == aCols[_x][3]			
				RecLock("ZB0",.F.)
					ZB0->ZB0_CODATV := _cCodAtv
					ZB0->ZB0_CC     := aCols[_x][1]
					ZB0->ZB0_ATIVID := _cAtivid
					ZB0->ZB0_AREA   := aCols[_x][3]
					ZB0->ZB0_GENERI := aCols[_x][4]
				MsUnlock("ZB0")
				
		    ELSE  //se ainda não tiver, insere um novo registro
				RecLock("ZB0",.T.)
					ZB0->ZB0_FILIAL := xFilial("ZB0")
					ZB0->ZB0_CODATV := _cCodAtv
					ZB0->ZB0_CC     := aCols[_x][1]
					ZB0->ZB0_ATIVID := _cAtivid
					ZB0->ZB0_AREA   := aCols[_x][3]
					ZB0->ZB0_GENERI := aCols[_x][4]
				MsUnlock("ZB0")

			ENDIF

		EndIf

		lOk := .T.
	Next

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExcl()

	If !UPPER(Alltrim(cusername))$_cUsrAdm
		MsgBox("Usuário sem permissão para excluir esta atividade","Sem permissao","INFO")
		lOk := .T.
		Return
	Endif
	
	ZB0->(DBSETORDER(1)) //FILIAL + ATV + CC
	ZB1->(DBSETORDER(1)) //FILIAL + MAT + ATV + CC
	ZRG->(DBSETORDER(2)) //FILIAL + ZRG_CC + ZRG_MAT	

	If MsgYesNo("Tem certeza de que deseja excluir esta Atividade e todas as qualificações de funcionários para esta Atividade?","Confirmação")
		For _x:= 1 to len(aCols)
			
			//Exclui as qualificacoes dos funcionarios na tabela ZB1
			ZRG->(DBSEEK(XFILIAL('ZRG')+aCols[_x][1]))
			 
			While ZRG->(!EOF()) .AND. aCols[_x][1]$ZRG->ZRG_CC      

				If ZB1->(DbSeek(xFilial("ZB1")+ZRG->ZRG_MAT+_cCodAtv))
					RecLock('ZB1',.F.)
						ZB1->(DbDelete())
					MsUnLock('ZB1')
				EndIf					
            	
            	ZRG->(DBSKIP())
            ENDDO
            
            //Exclui a Atividade na tabela ZB0
			IF ZB0->(DBSEEK(XFILIAL('ZB0')+_cCodAtv+aCols[_x][1])) //ATV + CC
				While ZB0->(!EOF()) .AND. ZB0->ZB0_CODATV==_cCodAtv .AND. ZB0->ZB0_CC==aCols[_x][1]
				
					If ZB0->ZB0_AREA==aCols[_x][3]
						RecLock("ZB0",.F.)
							ZB0->(DbDelete())
						MsUnlock("ZB0")
						exit
					EndIf
									
					ZB0->(dbSkip())
				EndDo
				
			ENDIF

		Next
	EndIf
	
	lOk := .T.

Return
    
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fVal()
	
	For _y:= 1 to len(aCols)

   		If !aCols[_y][len(aHeader)+1]  //nao pega quando a linha esta deletada
			If Empty(aCols[_y][1])
				MsgBox("Informe um C.Custo!","C.Custo em branco","INFO")
				Return .F.
			EndIf
		
			If !ExistCpo("CTT",aCols[_y][1])
				MsgBox("C.Custo informado não existe no cadastro. Verifique!","C.Custo não existe","INFO")
				Return .F.
			EndIf
		EndIf
	
	Next
	
	If Empty(_cAtivid)
		MsgBox("Informe uma atividade!","Atividade em branco","INFO")
		Return .F.
	EndIf	
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ MATRIZ DE VERSATILIDADE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
User Function fTRM02M()
//variáveis
Local aRotina := {}
_cUsr      := Upper(CUSERNAME)
AHEADER    := {}  
ACOLS      := {}
_cCCMat    := space(9)
_cTurno    := space(3) 
_cCCDMat   := ""
_lCanc     := .F.  
_aLin      := {}   
//_aTurno    := {"","001 - 1º Turno","002 - 2º Turno","003 - 3º Turno","004 - 4º Turno","005 - Administrativo","007 - 401 A","008 - 402 B","009 - 403 C","010 - 404 D"}

_CDESCATV  := ""
_cArea     := SPACE(6)
_cAreaDesc := ""
_cNome := UsrFullName(__cUserID)

//Constrói a tela de pergunta 
DEFINE MSDIALOG oDlg2 TITLE "C.Custo" FROM 0,0 TO 180,415 PIXEL

//@ 005,005 TO 065,205 OF oDlg2 PIXEL

@ 015,010 SAY "C.Custo: " Size 040,008 Object olCC 
@ 015,040 GET _cCCMat F3 "CTT" Size 040,008 Object oCC valid fDescCC()
@ 015,085 GET _cCCDMat WHEN .F. Size 115,008 Object oCCDM

@ 030,010 SAY "Turno: " Size 040,008 Object olCC
//@ 030,040 MSCOMBOBOX oCombo1 VAR _cTurno ITEMS _aTurno SIZE 070,010 OF oDlg2 PIXEL
@ 030,040 GET _cTurno F3 "SR6" Size 030,008 Object oCC valid fTurno()//DescCC()

@ 045,010 SAY "Area: " Size 040,008 Object olArea
@ 045,040 GET _cArea F3 "ARE" Size 040,008 Object oArea valid fDescArea()
@ 045,085 GET _cAreaDesc WHEN .F. Size 115,008 Object oAreaDesc

@ 070,005 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION Processa({||fGeraMat()},"Gerando Matriz")
@ 070,045 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg2:End()

ACTIVATE MSDIALOG oDlg2 CENTER

Return

Static function fTurno()

	SR6->(dbsetorder(1))
	IF !SR6->(dbseek(xfilial("SR6")+_cTurno))
		Alert("Turno não encontrado!")
		return .f.
	Endif

Return .t.

Static Function fGeraMat()

	//-- Monta o AHEADER
	Aadd(aHeader,{"Matrícula"    , "ZB1_MAT"	,"@!"       	 , 6,0,".F.","","C","ZB1"}) 
	Aadd(aHeader,{"Nome"         , "ZB1_NOME"	,"@!"       	 ,50,0,".F.","","C","ZB1"}) 
	
	DbSelectArea("ZB0")
	DbSetOrder(2) //FILIAL + CC 
	If DbSeek(xFilial('ZB0')+_cCCMat)
	
		//-- Adiciona as atividades no aheader
		While ZB0->(!EOF()) .AND. ALLTRIM(ZB0->ZB0_CC) == AllTrim(_cCCMat)
			IF ALLTRIM(ZB0->ZB0_AREA) == ALLTRIM(_cArea)
				Aadd(aHeader,{ZB0->ZB0_CODATV, "ZB1_QUALIF"	,"@!", 2,0,"U_TRM00201()","","C","ZB1"})
			Endif
			ZB0->(DBSKIP())
		EndDo
		
	Else
		Alert("C.Custo não possui Atividades Cadastradas!")
		aHeader := {}
		aCols   := {}
		Return .F.
	EndIf
	
	//-- ACOLS
	ZB1->(DBSETORDER(1)) //FILIAL + MAT + ATV + CC
	
	DBSELECTAREA('ZRG')
	DBSETORDER(2) //FILIAL + ZRG_CC + ZRG_MAT
	DBSEEK(XFILIAL('ZRG')+_cCCMat)
	
	//-- Adiciona no aCols os funcionários cadastrados na ZRG
	While ZRG->(!EOF()) .AND. AllTrim(_cCCMat)$ZRG->ZRG_CC
		
		IF substr(_cTurno,1,3)$ALLTRIM(ZRG->ZRG_TURNO)
		
			If ZRG->ZRG_AREA != _cArea
				ZRG->(DbSkip())
				Loop
			EndIf
	
			_aLin := {}
			
			//Adiciona o funcionário
			aAdd(_aLin,ZRG->ZRG_MAT)
			aAdd(_aLin,ZRG->ZRG_NOME)
			
			//Adiciona as atividades do funcionario
			For _y := 3 to len(aHeader)
				If ZB1->(DbSeek(xFilial("ZB1")+ZRG->ZRG_MAT+aHeader[_y][1]+ZRG->ZRG_CC))
					aAdd(_aLin,ZB1->ZB1_QUALIF)
				Else
					aAdd(_aLin,"NA")
				EndIf
			Next
			
			aAdd(_aLin,.F.) //flag do acols se está deletado / não deletado
			
			aAdd(aCols,_aLin)
			
		EndIf
	
		ZRG->(DBSKIP())
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVA OS DADOS DA MATRIZ NA LEITURA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZB1->(DBSETORDER(1)) //FILIAL + MAT + ATV + CC
	
	//percorre o acols para gravar todas as linhas
	For _x:= 1 to len(aCols)
	
	   If !aCols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
	
			//Grava as atividades do funcionario
			For _y := 3 to len(aHeader)
				If !ZB1->(DbSeek(xFilial("ZB1")+aCols[_x][1]+aHeader[_y][1]+_cCCMat))
					RecLock("ZB1",.T.)
						ZB1->ZB1_FILIAL := xFilial("ZB1")
						ZB1->ZB1_MAT    := aCols[_x][1]   // matricula
						ZB1->ZB1_NOME   := aCols[_x][2]   // nome do funcionario
						ZB1->ZB1_ATIVID := aHeader[_y][1] // Código da atividade
						ZB1->ZB1_QUALIF := aCols [_x][_y] // Qualificacao
						ZB1->ZB1_IMPOTJ := "S"            // Imprime On The Job? Sim
						ZB1->ZB1_CC     := _cCCMat
					MsUnlock("ZB1")
				EndIf
			Next 
			
		EndIf 
	
	Next
	      
	oDlg2:End()

	fMostraMat()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³TELA DA MATRIZ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fMostraMat()
Local bOk         := {||fGrvMat()}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Local aButtons    := {}
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)

	aAdd(aButtons,{"RELATORIO",{||fMontaOTJ()},"Imprime o formulário On The Job"  ,"On The Job"})
	aAdd(aButtons,{"PMSCOLOR" ,{||fTRM02I()},"Imprime a Matriz de Versatilidade","Matriz"    })
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,aButtons)}
	
	//DEFINE MSDIALOG oDlg TITLE "Matriz de Versatilidade" FROM 0,0 TO 400,695 PIXEL
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Matriz de Versatilidade",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//@ 005,005 TO 175,345 LABEL "Matriz" OF oDlg PIXEL
	
	@ 020,015 SAY "C.Custo: " 		Size 040,008 Object olCCm
	@ 020,045 SAY _cCCMat           Size 040,008 Object oCCM
	
	@ 020,100 SAY "Turno: "       	Size 040,008 Object olTurno
	@ 018,120 GET _cTurno           When .F. Size 070,008 Object oTurno
	 
	@ 020,200 SAY "Responsável: " 	Size 040,008 Object olResp
	@ 018,240 GET _cUsr    When .F. Size 040,008 Object oResp
	
	//Multiline
	DbSelectArea('ZB0')
	@ 038,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY OBJECT oMultiline
	
	oMultiline:nMax := len(aCols) //nao deixa o usuario adicionar mais uma linha no mline
	
	@ 180,015 SAY "Para ver a DESCRIÇÃO DA ATIVIDADE pressione F12 "Size 300,008 Object olF12
	SET KEY VK_F12 TO fAtvDesc()
	
	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
	
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ DESCRICAO DO CC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fDescCC()

	DbSelectArea('CTT')
	DbSetOrder(1)//filial + cc
	If DbSeek(xFilial("CTT")+_cCCMat)
		_cCCDMat := CTT->CTT_DESC01
		oCCDM:Refresh()
	ENDIF

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A DESCRICAO DA AREA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fDescArea()
	DbSelectArea("SX5")
	Dbgotop()
	DbSetOrder(1) //FILIAL + TABELA + CHAVE
	If DbSeek(xFilial("SX5")+"ZV"+_cArea) //AREAS
    	_cAreaDesc := SX5->X5_DESCRI
    	oAreaDesc:Refresh()
 	Else
 		If !Empty(_cArea)
 			Alert("Area não existente!")
	 		Return .F.
	 	EndIf
 	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A DESCRICAO DA ATIVIDADE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fAtvDesc()
Local _nColuna := oMultiline:OBrowse:ColPos//retorna a coluna em que o cursor está focando
Private _cAtv  := AHEADER[_nColuna][1]

	If _nColuna > 2 //se está posicionado em cima de um campo de atividade
		//Constrói a tela da matriz
		DEFINE MSDIALOG oDlgD TITLE "Descricao da Atividade" FROM 0,0 TO 180,390 PIXEL
		
		//@ 005,005 TO 175,345 OF oDlg PIXEL
		
		@ 010,010 SAY "Atividade: " Size 040,008 Object olAtv
		@ 010,045 SAY _cAtv         Size 040,008 Object oAtv
		
		DbSelectArea("ZB0")
		DBSETORDER(1)//FILIAL + CODATV + CC
		DbSeek(xfilial('ZB0')+_cAtv+_cCCMat)
		
		_cDescAtv := ZB0->ZB0_ATIVID
		
		@ 020,010 SAY "Descrição: "	Size 040,008 Object olDescAtv
		@ 030,010 Get oDescAtv VAR _cDescAtv MEMO When .F. SIZE 180,035 PIXEL OF oDlgD
		
		@ 070,155 BUTTON "&Fechar"  SIZE 36,16 PIXEL ACTION oDlgD:End()
		
		ACTIVATE MSDIALOG oDlgD CENTER
	Else
		MsgBox("Posicione o cursor sobre o campo da atividade","Posicione o cursor","INFO")
	EndIf
	
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA OS DADOS DA MATRIZ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvMat()
Local lAbreOTJ := .F.
Local nRecV := 0

ZB1->(DBSETORDER(1)) //FILIAL + MAT + ATV + CC

//percorre o acols para gravar todas as linhas
For _x:= 1 to len(aCols)

   If !aCols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada

		//Grava as atividades do funcionario
		For _y := 3 to len(aHeader)
			
			If ZB1->(DbSeek(xFilial("ZB1")+aCols[_x][1]+aHeader[_y][1]+_cCCMat))
			
				nRecV := ZB1->(Recno())
				
				RecLock("ZB1",.F.)
					ZB1->ZB1_QUALIF := aCols [_x][_y]
				MsUnlock("ZB1")
				
			
			Else
				RecLock("ZB1",.T.)
					ZB1->ZB1_FILIAL := xFilial("ZB1")
					ZB1->ZB1_MAT    := aCols[_x][1]   //matricula
					ZB1->ZB1_NOME   := aCols[_x][2]   //nome do funcionario
					ZB1->ZB1_ATIVID := aHeader[_y][1] //Código da atividade
					ZB1->ZB1_QUALIF := aCols [_x][_y] //Qualificacao
					ZB1->ZB1_IMPOTJ := "S"            //Imprime On The Job? Sim
					ZB1->ZB1_CC     := _cCCMat        //Centro de Custo
				MsUnlock("ZB1")
			EndIf
			
		Next 
		
	EndIf 

Next 

If SM0->M0_CODIGO=="NH" //EMPRESA USINAGEM

	//SOLICITACAO DA ANDREIA - CHAMADO 000579 
	//ALGUNS CENTROS DE CUSTO E AREAS NAO DEVEM IMPRIMIR ON THE JOB
	IF !((ALLTRIM(_cCCMat)$"104001" .AND. ALLTRIM(_cArea)$"000021") .OR.;
	   (ALLTRIM(_cCCMat)$"103001" .and. ALLTRIM(_cArea)$"000012/000011/000010") .OR.;
	   (ALLTRIM(_cCCMat)$"103002" .and. ALLTRIM(_cArea)$"000013/000014") .OR.;
	   (ALLTRIM(_cCCMat)$"306003/105002/306001/105001/302003/302001") .OR.;
	   (ALLTRIM(_cCCMat)$"304001" .AND. ALLTRIM(_cArea)$"000016") .OR.;
	   (ALLTRIM(_cCCMat)$"304004" .AND. (ALLTRIM(_cArea)$"000016" .OR. Empty(_cArea))))
	   
	 	lAbreOTJ := .T.	
	
	EndIf
	
ElseIf SM0->M0_CODIGO=="FN" //EMPRESA FUNDICAO
	//CHAMADO 005658 - HELPDESK
	If !(AllTrim(_cCCMat)$"23002001" .AND. ALLTRIM(_cArea)$"000005")
	 	lAbreOTJ := .T.
	EndIf
EndIf  

//If lAbreOTJ
	fAbreOnTheJob()//funcao que verifica se deve abrir ON THE JOB 
//EndIf

If MsgYesNo("Fechar Matriz?")
	oDlg:End()
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³ VERIFICA QUANTOS DOCUMENTOS ONTHEJOB SERAO ABERTOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù
Static Function fAbreOnTheJob()
Local aOTJAA  := {} //matriz on the job apto
Local aOTJET  := {} //matriz on the job em treinamento
Local laAddAA := .F.
Local laAddET := .F.

If UPPER(Alltrim(cusername))$"SIMARARO"
	Return
Endif

ZB1->(DBSETORDER(1)) //FILIAL + MAT + ATV + CC
ZB0->(DBSETORDER(1)) //FILIAL + CODATV + CC
CTT->(DbSetOrder(1)) //filial + cc

//percorre o acols para gravar todas as linhas
For _x:= 1 to len(aCols)

   	If !aCols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
		For _y := 3 to len(aHeader)
			
			laAddAA := .F. //aciciona no array aOTJAA? sim ou nao
			laAddET := .F. //aciciona no array aOTJET? sim ou nao
						
			If AllTrim(aCols[_x][_y])$"ET/AA/NP" //Indica que o Supervisor deve imprimir e preencher a ficha OnTheJob
		   	
	   			ZB1->(dbSeek(xFilial("ZB1")+aCols[_x][1]+aHeader[_y][1]+_cCCMat)) 
				ZB0->(dbSeek(xfilial("ZB0")+aHeader[_y][1]+_cCCMat))//Traz a descricao da atv
		   		CTT->(dbSeek(xFilial("CTT")+_cCCMat))//traz a desc do cc.
			   				   		
				If AllTrim(aCols[_x][_y])$"ET" .and. ZB1->ZB1_IMPOTJ=="S" //Imprime On the Job? S ou N

					laAddET := .T.

					RecLock("ZB1",.F.)
						ZB1->ZB1_IMPOTJ := "N"
					MsUnlock("ZB1")

			 	ElseIf AllTrim(aCols[_x][_y])$"AA/NP" .and. ZB1->ZB1_IMPOTJ != "I" //Imprime On the Job? S ou N	
					
/*
                    If MsgYesNo("Você definiu o funcionário "+ALLTRIM(aCols[_x][2])+"como "+;
                    			Iif(AllTrim(aCols[_x][_y])$"NP","Não","")+" Apto"+;
	                             " para a atividade "+ZB0->ZB0_CODATV+" - "+ALLTRIM(ZB0->ZB0_ATIVID)+"."+;
    	                         " Para que seja confirmada esta alteração é necessário encaminhar "+;
        	                     " o formulário ON THE JOB ao setor de RH. Deseja Imprimir o formulário agora?","Imprimir ON THE JOB?")
*/        	                     
				   		
				   		laAddAA := .T.

						RecLock("ZB1",.F.)
							ZB1->ZB1_IMPOTJ := "I" //Impresso
						MsUnlock("ZB1")
	        	           
//       				EndIf
       			EndIf

       			If laAddAA
			   		aAdd(aOTJAA,{aCols[_x][1],; //matricula
  			   				     aCols[_x][2],; //nome funcionario
			   		             aHeader[_y][1]+" - "+ZB0->ZB0_ATIVID,; //cod atividade + desc atividade
			   		             _cCCMat +" - "+CTT->CTT_DESC01,;
			   		             _cTurno,;
	   				             _cNome})
	   			EndIf
	   			
	   			If laAddET
			   		aAdd(aOTJET,{aCols[_x][1],; //matricula
  			   				     aCols[_x][2],; //nome funcionario
			   		             aHeader[_y][1]+" - "+ZB0->ZB0_ATIVID,; //cod atividade + desc atividade
			   		             _cCCMat +" - "+CTT->CTT_DESC01,;
			   		             _cTurno,;
	   				             _cNome})
	   			EndIf
	   	    EndIf
	   	Next
	   	
	   	If Len(aOTJAA)>0 .and. MsgYesNo("Você alterou as atividades do funcionário "+;
	   		AllTrim(aCols[_x][2])+"!"+CHR(13)+CHR(10)+"Deseja imprimir ON THE JOB para o funcionário?")
	   			fImpOTJ(aOTJAA)
	   	EndIF
	   	
		If Len(aOTJET)>0 .and. MsgYesNo("Você alterou as atividades do funcionário "+;
	   		AllTrim(aCols[_x][2])+"!"+CHR(13)+CHR(10)+"Deseja imprimir ON THE JOB para o funcionário?")
		   		fImpOTJ(aOTJET)
		EndIf
		
	   	aOTJAA := {}
	   	aOTJET := {}
   	EndIf
Next

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA AS MOVIMENTACOES DA MATRIZ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function TRM00201()
Local _nCl     := oMultiline:OBrowse:ColPos//retorna a coluna em que o cursor está focando
Local _cAtiv   := AHEADER[_nCl][1] //atividade
Local _cMt     := aCols[n][1] // matricula
Local _cQualif := "" 
Local _cUsrAdm := "JUCINEIAT/ANDREIARB/KARINERM/ADMINISTRADOR/ADMIN/JOAOFR/ALECSANDRAH/SIMARARO/TAINARAFF/JOSEBO/LEOB"
                                                          
ZB1->(DbSetOrder(1)) //filial + mat + atv + CC
ZB1->(DbSeek(xFilial("ZB1")+_cMt+_cAtiv+_cCCMat))

_cQualif := ZB1->ZB1_QUALIF

If UPPER(Alltrim(cusername))$_cUsrAdm
	Return .T.
Endif

//Bloqueia o status (OK) 
IF M->ZB1_QUALIF == "OK" .OR. _cQualif == "OK"
	Alert("Permitido apenas para controle do RH")
	Return .F.
ENDIF

/*
AA = APTO
AR = APTO COM RESTRICAO
AT = A TREINAR
ET = EM TREINAMENTO
NP = NAO APTO
NA = NAO SE APLICA
*/

If (_cQualif != M->ZB1_QUALIF) .AND. ;
   ((_cQualif == "NA" .AND. (M->ZB1_QUALIF == "AR" .OR.  M->ZB1_QUALIF == "NP")) .OR. ;
    (_cQualif == "AT" .AND. (M->ZB1_QUALIF != "ET" .AND. M->ZB1_QUALIF != "AA")) .OR. ;
    (_cQualif == "ET" .AND. (M->ZB1_QUALIF != "AA" .AND. M->ZB1_QUALIF != "NP")) .OR. ;
    (_cQualif == "AA" .AND.  M->ZB1_QUALIF != "AR") .OR. ;
    (_cQualif == "AR" .AND.  M->ZB1_QUALIF != "AA") .OR. ;
    (_cQualif == "NP" .AND. (M->ZB1_QUALIF != "ET" .AND. M->ZB1_QUALIF  != "AA")))

	MsgBox("Impossível realizar esta mudança pois não obedece ao fluxo do processo!","Não Permitido","ALERT")
	Return .F.

EndIf  
     
Return .T.   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O ON THE JOB PARA A ATIVIDADE POSICIONADA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fMontaOTJ()
Local aOTJ := {}
Local nCl  := oMultiline:OBrowse:ColPos//retorna a coluna em que o cursor está focando

    



Local _cArqDBF := CriaTrab(NIL,.f.) + ".DBF"
Local _aFields := {}
Local aCampos  := {}   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criando Arquivo Temporario para posterior impressao          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(_aFields,{"OK"        ,"C",  02,0})         // Controle do browse
	AADD(_aFields,{"CODIGO"    ,"C",  06,0})         // COD ATIVIDADE
	AADD(_aFields,{"ATIVIDADE" ,"C", 250,0})         // DESC ATIVIDADE
	
	DbCreate(_cArqDBF,_aFields)
	DbUseArea(.T.,,_cArqDBF,"ATV",.F.)
	
	ZB0->(dbSetOrder(1))//FILIAL + CODATV + CC

	For xH:=3 to Len(aheader)

		If aCols[n][xH]$"AA/ET"

			//Traz a descricao da atv
			ZB0->(dbSeek(xfilial('ZB0')+aHeader[xH][1]+_cCCMat))

			RecLock("ATV",.T.)
		      	ATV->OK        := Space(02)     
		   		ATV->CODIGO    := aHeader[xH][1]
		   		ATV->ATIVIDADE := ZB0->ZB0_ATIVID
			MsUnlock("ATV")
		Endif
	
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Constrói tela para seleção de ítens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos := {}   
	
	Aadd(aCampos,{"OK"        ,"OK"      ,"@!"})
	Aadd(aCampos,{"CODIGO"    ,"Cod"     ,"@!"})
	Aadd(aCampos,{"ATIVIDADE" ,"Ativid"  ,"@!"})
	
	ATV->(DbGoTop())
	
	@ 50,01 TO 400,500 DIALOG oDlgATV  TITLE "Atividades ON THE JOB"
	@ 06,05 TO 150,245 BROWSE "ATV" FIELDS aCampos MARK "OK"
	@ 155,05 BUTTON "_Imprimir" SIZE 40,15 ACTION Close(oDlgATV) Object oBtn
	ACTIVATE DIALOG oDlgATV CENTERED
	

	ZB0->(dbSetOrder(1))//FILIAL + CODATV + CC
	CTT->(dbSetOrder(1))//filial + cc
	ZB1->(dbSetOrder(1))//ZB1_FILIAL+ZB1_MAT+ZB1_ATIVID+ZB1_CC

	ATV->(DbGoTop())
	While ATV->(!EOF())
		If ATV->(MARKED("OK"))

			//traz a desc do cc.
			CTT->(dbSeek(xFilial("CTT")+_cCCMat))
	
			aAdd(aOTJ,{aCols[n][1],aCols[n][2],ATV->CODIGO+" - "+ATV->ATIVIDADE,_cCCMat,_cTurno,_cNome})
			
			If ZB1->(dbSeek(xFilial("ZB1")+aCols[n][1]+ATV->CODIGO+_cCCMat))
				RecLock("ZB1",.F.)
					ZB1->ZB1_IMPOTJ := "I" //Impresso
				MsUnlock("ZB1")
			EndIf		
		EndIf
		ATV->(dbSkip())
	EndDo

	ATV->(dbCloseArea())


/*
	If nCl <= 2
		Alert("Posicione o cursor sobre uma atividade!")
		Return
	EndIf
	
	ZB0->(dbSetOrder(1))//FILIAL + CODATV + CC
	CTT->(dbSetOrder(1))//filial + cc
	ZB1->(dbSetOrder(1))//ZB1_FILIAL+ZB1_MAT+ZB1_ATIVID+ZB1_CC
	
	If aCols[n][nCl]$"AA/ET"
		//Traz a descricao da atv
		ZB0->(dbSeek(xfilial('ZB0')+aHeader[nCl][1]+_cCCMat))
		//traz a desc do cc.
		CTT->(dbSeek(xFilial("CTT")+_cCCMat))

		aAdd(aOTJ,{aCols[n][1],aCols[n][2],aHeader[nCl][1]+" - "+ZB0->ZB0_ATIVID,_cCCMat,_cTurno,_cNome})
		
		ZB1->(dbSeek(xFilial("ZB1")+aCols[n][1]+aHeader[nCl][1]+_cCCMat))

		RecLock("ZB1",.F.)
			ZB1->ZB1_IMPOTJ := "I" //Impresso
		MsUnlock("ZB1")
	Else
		Alert("Atividade deve estar definida como AA-Apto ou ET-Em Treinamento para imprimir OnTheJob!")
		Return
	EndIf
*/
	
	If !Empty(aOTJ) .OR. Len(aOTJ)>0
		fImpOTJ(aOTJ)
	Else
		Alert("Nenhuma atividade definida como AA ou ET foi encontrada para este funcionário!")
	EndIf


Return

Static Function fImpOTJ(aOTJob)
Local nLin
Local nCol

Private oFont8,oFont8N
Private oPrint
Private cStartPath 	:= GetSrvProfString("Startpath","")

	If Right(cStartPath,1) <> "\"
		cStartPath += "\"
	Endif

	//CRIA OS OBJETOS DE IMPRESSÃO
	oPrint := TMSPrinter():New("On The Job")
	oPrint:SetLandScape()
	//oPrint:Setup()
	
	oFont7	 := TFont():New("Arial" , 7, 7,,.F.,,,,.T.,.F.)
	oFont8  := TFont():New("Arial" , 8, 8,,.F.,,,,.T.,.F.)
	oFont8N := TFont():New("Arial" , 8, 8,,.T.,,,,.T.,.F.)
	oFont10  := TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
	oFont10N := TFont():New("Arial" ,10,10,,.T.,,,,.T.,.F.)
	oFont12N := TFont():New("Arial" ,12,12,,.T.,,,,.T.,.F.)
	oFont16N := TFont():New("Arial" ,16,16,,.T.,,,,.T.,.F.)

	fFormOTJ(oPrint)

	oPrint:Say (  300 ,  520 , aOTJob[1][1]+" - "+aOTJob[1][2] ,oFont10) //matricula
	oPrint:Say ( 2250 , 2450 , aOTJob[1][5]                  ,oFont8) //turno
	oPrint:Say ( 2140 ,  400 , aOTJob[1][6]                  ,oFont8) //responsavel
	oPrint:Say ( 2250 , 1850 , Iif(Empty(_cArea),"",_cArea+" - "+_cAreaDesc)  ,oFont8) //area + areadesc

	CTT->(dbSetOrder(1))
	CTT->(dbSeek(xFilial("CTT")+aOTJob[1][4]))
	oPrint:Say ( 2250 , 300  , AllTrim(aOTJob[1][4])+" - "+CTT->CTT_DESC01,oFont8) //c.custo

	nLin := 610
	For x:=1 to Len(aOTJob)                                              
		
		nLinha = MlCount(Lower(Alltrim(aOTJob[x][3])),55)
		
		If nLin + (40*nLinha) > 2000
			oPrint:EndPage()
			oPrint:StartPage()

			oPrint:Say (  300 ,  520 , aOTJob[1][1]+" - "+aOTJob[1][2] ,oFont10) //matricula
			oPrint:Say ( 2250 , 2450 , aOTJob[1][5]                  ,oFont8) //turno
			oPrint:Say ( 2150 ,  400 , aOTJob[1][6]                  ,oFont8) //responsavel
			oPrint:Say ( 2250 , 1850 , _cArea+" - "+_cAreaDesc     ,oFont8) //area + areadesc
					
			fFormOTJ(oPrint) //imprime a "casca" do ON THE JOB
			nLin := 610
		EndIf
		
		If nLin!=610
			oPrint:Line( nLin-20 ,  150 , nLin-20 , 3200 ) //horizontal divide as atividades
		EndIf
		
//		oPrint:Say(nLin, 2370,DtoC(date()),oFont8) //DATA INICIAL
		
		For y:=1 to nLinha
			oPrint:Say(nLin, 520,OemToAnsi(MemoLine(aOTJob[x][3],55,y)),oFont10) //DESCRICAO DA ATIVIDADE
			nLin += 40
        Next
		
		nLin += 40
		
	Next
	
	oPrint:EndPage() 		// Finaliza a pagina
	oPrint:Preview()  		// Visualiza antes de imprimir   

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME A CASCA DO ONTHE JOB, OU SEJA, SOMENTE AS LINHAS DA GRADE E INFORMACOES FIXAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fFormOTJ(oPrint)

	/* quadro externo */
	oPrint:Line(  100 ,  150 ,  100 , 3200 ) //HORIZONTAL 0
	oPrint:Line(  100 ,  150 , 2300 ,  150 ) //VERTICAL   0
	oPrint:Line( 2300 ,  150 , 2300 , 3200 ) //HORIZONTAL 2
	oPrint:Line(  100 , 3200 , 2300 , 3200 ) //VERTICAL   2
	
	oPrint:SayBitmap(120,180,cStartPath+"WHBL.bmp",300,140)   //logo whb
	oPrint:Say (  160 , 1500 , "TREINAMENTO - ON THE JOB",oFont12N)
	
	oPrint:Say (  300 ,  190 , "FUNCIONÁRIO"           ,oFont10N)

	oPrint:Say (  370 ,  270 , "DATA"                  ,oFont10N)
	oPrint:Say (  370 ,  990 , "TREINAMENTO"           ,oFont10N)
	oPrint:Say (  340 , 1800 , "DURAÇÃO"               ,oFont10N)
	oPrint:Say (  320 , 2050 , "A SER PREENCHIDO PELO" ,oFont10N)
	oPrint:Say (  380 , 2165 , "SUPERVISOR"            ,oFont10N)
	oPrint:Say (  340 , 2595 , "RESULTADO"             ,oFont10N)
	oPrint:Say (  340 , 2928 , "ASSINATURA"            ,oFont10N)
	oPrint:Say (  410 , 3010 , "DO"                    ,oFont10N)
	oPrint:Say (  480 , 2915 , "FUNCIONÁRIO"           ,oFont10N)
    
	oPrint:Say (  485 ,  190 , "Inicial"               ,oFont10N)
	oPrint:Say (  485 ,  375 , "Final"                 ,oFont10N)
	oPrint:Say (  485 , 1045 , "Conteúdo"              ,oFont10N)
	oPrint:Say (  485 , 1845 , "Horas"                 ,oFont10N)
	oPrint:Say (  445 , 2045 , "A instrução está "     ,oFont10N)
	oPrint:Say (  485 , 2045 , "sendo seguida"         ,oFont10N)
	oPrint:Say (  525 , 2045 , "corretamente?"         ,oFont10N)
	oPrint:Say (  485 , 2400 , "Data"                  ,oFont10N)
	oPrint:Say (  460 , 2650 , "Situação /"            ,oFont10N)
	oPrint:Say (  510 , 2650 , "Parecer"               ,oFont10N)
	
	oPrint:Line(  280 ,  150 ,  280 , 3200 ) //HORIZONTAL 1 abaixo do LOGO
	oPrint:Line(  360 ,  150 ,  360 , 1770 ) //HORIZONTAL 2 abaixo do FUNCIONARIO
	
	oPrint:Line(  440 ,  150 ,  440 , 2890 ) //HORIZONTAL 3 abaixo do DATA
	oPrint:Line(  580 ,  150 ,  580 , 3200 ) //HORIZONTAL 4 abaixo do Inicial | Final
	oPrint:Line( 2000 ,  150 , 2000 , 3200 ) //HORIZONTAL 5 acima de Nome do Coordenador ...
	oPrint:Line( 2100 ,  150 , 2100 , 3200 ) //HORIZONTAL 6 acima de Responsável:
	oPrint:Line( 2200 ,  150 , 2200 , 3200 ) //HORIZONTAL 7 acima de Setor:
	
	oPrint:Line(  440 ,  325 , 2000 ,  325 ) //VERTICAL 1  antes de FINAL
	oPrint:Line(  100 ,  500 , 2000 ,  500 ) //VERTICAL 2  antes de MATR.
    oPrint:Line(  280 , 1770 , 2300 , 1770 ) //VERTICAL 5  antes de HORAS / DURACAO
	oPrint:Line(  280 , 2025 , 2000 , 2025 ) //VERTICAL 6  antes de A INSTRUCAO ESTÁ ...
	oPrint:Line(  440 , 2330 , 2300 , 2330 ) //VERTICAL 7  antes de DATA
	oPrint:Line(  280 , 2560 , 2000 , 2560 ) //VERTICAL 9  antes de SITUACAO / PARECER
	oPrint:Line(  280 , 2890 , 2000 , 2890 ) //VERTICAL 10 antes de ASSINATURA DO FUNCIONARIO
	
	oPrint:Say ( 2030 ,  690 , "Nome do Coordenador / Supervisor:"  ,oFont10N)
	oPrint:Say ( 2015 , 1920 , "Assinatura do"                      ,oFont10N)
	oPrint:Say ( 2050 , 1835 , "Coordenador / Supervisor"           ,oFont10N)
	oPrint:Say ( 2030 , 2600 , "PARECER DO RH:"                     ,oFont10N)
	
	oPrint:Say ( 2150,   170  , "Responsável:"                      ,oFont8N)
	oPrint:Say ( 2150,  2350  , "Obs:"                              ,oFont8N)

	oPrint:Say ( 2250,   170  , "Setor:"                            ,oFont8N)
	oPrint:Say ( 2250,  1790  , "Área:"                             ,oFont8N)
	oPrint:Say ( 2250,  2350  , "Turno:"                            ,oFont8N)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ADICIONA OS FUNCIONARIOS NA TABELA ZRG ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fTRMAF()
CTT->(DbSetOrder(1))
SRA->(DbSetOrder(2))
SRJ->(DbSetOrder(1))
ZRG->(DbSetOrder(1))
SRA->(DbGoTop())
While !SRA->(Eof())
	If SRA->RA_SITFOLH <> "D" .AND. Alltrim(SRA->RA_CC) <> '103999'
		ZRG->(DbSeek(xFilial("ZRG")+ALLTRIM(SRA->RA_MAT)))
		If !ZRG->(Found())
			RecLock("ZRG",.T.)
			ZRG->ZRG_FILIAL := xFilial("ZRG")
			ZRG->ZRG_MAT    := ALLTRIM(SRA->RA_MAT)
			ZRG->ZRG_NOME   := SRA->RA_NOME

			CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
			If CTT->(Found())
				ZRG->ZRG_DESC  := CTT->CTT_DESC01
			Endif	
			ZRG->ZRG_CC     := SRA->RA_CC
			ZRG->ZRG_ADMI   := SRA->RA_ADMISSA
			ZRG->ZRG_CODF   := SRA->RA_CODFUNC
			ZRG->ZRG_TURNO  := STRZERO(VAL(SRA->RA_TNOTRAB),3)
			SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
			If SRJ->(Found())
				ZRG->ZRG_DESCF := SRJ->RJ_DESC
			Endif	
			MsUnLock("ZRG")
		Else
			RecLock("ZRG",.F.)
		    If SRA->RA_CC <> ZRG->ZRG_CC
				ZRG->ZRG_CCRH    := SRA->RA_CC
			Endif

			ZRG->ZRG_CODF   := SRA->RA_CODFUNC
			SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
			If SRJ->(Found())
				ZRG->ZRG_DESCF := SRJ->RJ_DESC
			Endif	
			MsUnLock("ZRG")
		Endif
	Else
		If SRA->RA_SITFOLH == "D" 
			ZRG->(DbSeek(xFilial("ZRG")+SRA->RA_MAT))
			If ZRG->(Found())
				RecLock("ZRG",.F.)
				ZRG->(DbDelete())	
				MsUnLock("ZRG")		
			Endif
		Endif	
	Endif
	SRA->(DbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME A MATRIZ DE VERSATILIDADE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fTRM02I()
Local _nLin 
Local _nCol
Local _cMat 
Private oFont8,oFont8N
Private oPrint
Private _aAtv    := {}
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

//VERIFICA SE OS BITMAPS EXISTEM
If 	!File(cStartPath+"MV1.BMP") .OR. ;
	!File(cStartPath+"MV2.BMP") .OR. ;
	!File(cStartPath+"MV3.BMP") .OR. ;
	!File(cStartPath+"MV4.BMP") .OR. ;
	!File(cStartPath+"MV5.BMP") .OR. ;
	!File(cStartPath+"MV6.BMP")

	MsgAlert("Bitmaps nao encontrados !","Atencao !")
	Return
Endif


	//CRIA OS OBJETOS DE IMPRESSÃO
	oPrint := TMSPrinter():New("Matriz de Versatilidade")
	oPrint:SetLandScape()
	//oPrint:Setup()
	
	oFont7	 := TFont():New("Arial" , 7, 7,,.F.,,,,.T.,.F.)
	oFont8N := TFont():New("Arial" , 8, 8,,.T.,,,,.T.,.F.)
	oFont8  := TFont():New("Arial" , 8, 8,,.F.,,,,.T.,.F.)
	
	//imprime o cabecalho
	fTRM02Cabec()

	cQuery := "SELECT ZB1.* FROM "+RetSqlName("ZB1")+" ZB1, "+RetSqlName("ZRG")+" ZRG"
	cQuery += " WHERE ZB1.ZB1_MAT = ZRG.ZRG_MAT"
	cQuery += " AND ZRG.ZRG_CC = '"+_cCCMat+"'"
	cQuery += " AND ZRG.ZRG_TURNO = '"+substr(_cTurno,1,3)+"'"
	cQuery += " AND ZB1.ZB1_CC = ZRG.ZRG_CC " //ADICIONADA 22/04/2010
	cQuery += " AND ZRG.ZRG_FILIAL = '"+xFilial("ZRG")+"'"
	cQuery += " AND ZB1.ZB1_FILIAL = '"+xFilial("ZB1")+"'"
	cQuery += " AND ZRG.ZRG_AREA = '"+_cArea+"'"
	cQuery += " AND ZRG.D_E_L_E_T_ = ''"
	cQuery += " AND ZB1.D_E_L_E_T_ = ''"
	cQuery += " ORDER BY ZB1.ZB1_MAT"
	
    TcQuery cQuery NEW ALIAS "TRA1"
    
    _aFunc := {}
	_nFun  := 1
		
    While TRA1->(!EoF())
   	
    	aAdd(_aFunc,{TRA1->ZB1_MAT})
    	
    	For _x := 1 to Len(_aAtv)
			aAdd(_aFunc[_nFun],"")    	
    	Next    	
    		
        _cMat  := TRA1->ZB1_MAT
        
        WHILE _cMat == TRA1->ZB1_MAT
    		
    		_n := Ascan(_aAtv,{|x| x[1] == TRA1->ZB1_ATIVID })
    		
    		If _n != 0
    			_aFunc[_nFun][_n+1] := TRA1->ZB1_QUALIF
    		EndIf
    		
	    	TRA1->(DbSkip())
	   	EndDo
	   	
	   	_nFun++
    EndDo
               
    _nLin := 390
    _nCol := 80
    
	SRA->(DBSETORDER(1))
	For _x := 1 to Len(_aFunc)

		If SRA->(DBSEEK(XFILIAL("SRA")+ALLTRIM(_aFunc[_x][1])))
			_aFunc[_x][1] += " - "+SRA->RA_NOME
		EndIf
		oPrint:Say(_nLin+5,_nCol,_aFunc[_x][1],oFont7)
		
		_nCol := 600

		For _y := 2 to len(_aFunc[_x])
			
			If _aFunc[_x][_y] == "OK" .OR. _aFunc[_x][_y] == "AA"
				oPrint:SayBitmap(_nLin,_nCol,cStartPath+"mv1.bmp",44,39)  
			ElseIf _aFunc[_x][_y] == "AR"
				oPrint:SayBitmap(_nLin,_nCol,cStartPath+"mv2.bmp",44,39)  
			ElseIf _aFunc[_x][_y] == "AT"
				oPrint:SayBitmap(_nLin,_nCol,cStartPath+"mv3.bmp",44,39)  
			ElseIf _aFunc[_x][_y] == "ET"
				oPrint:SayBitmap(_nLin,_nCol,cStartPath+"mv4.bmp",44,39)  
			ElseIf _aFunc[_x][_y] == "NP"
				oPrint:SayBitmap(_nLin,_nCol,cStartPath+"mv5.bmp",44,39)  
			ElseIf _aFunc[_x][_y] == "NA"                          
				oPrint:SayBitmap(_nLin,_nCol,cStartPath+"mv6.bmp",44,39)  
			EndIf

			_nCol+= 45
		Next
		
		_nLin += 40 
		_nCol := 80
		
		If _nLin > 1950
			oPrint:EndPage() // Finaliza a pagina
			fTRM02Cabec()
		    _nLin := 390
    		_nCol := 80
		EndIf

	Next
         
	TRA1->(DbCloseArea())
	oPrint:EndPage() 		// Finaliza a pagina
	
	TRM002Leg()
	
	oPrint:Preview()  		// Visualiza antes de imprimir   
		
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CABECALHO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
Static function fTRM02Cabec()

	oPrint:Say(100,1400,"MATRIZ DE VERSATILIDADE - "+ALLTRIM(_cCCMat)+" - "+ALLTRIM(_cCCDMat),oFont8N)
	oPrint:Say(130,1450,"TURNO "+UPPER(_cTurno)+" - AREA "+ALLTRIM(_cArea),oFont8N)
	
	cQuery := "SELECT * FROM "+RetSqlName("ZB0")+" ZB0"
	cQuery += " WHERE ZB0.ZB0_CC = '"+_cCCMat+"'"
	cQuery += " AND ZB0.ZB0_FILIAL = '"+xFilial("ZB0")+"'"
	cQuery += " AND ZB0.D_E_L_E_T_ = ''"
	cQuery += " AND ZB0.ZB0_AREA = '"+_cArea+"'"
	cQuery += " ORDER BY ZB0.ZB0_CODATV"
	
	TCQUERY cQuery NEW ALIAS "TRC"
	
	_aAtv := {}
	
	//alimenta o array _aAtv
	WHILE TRC->(!Eof())
		aAdd(_aAtv,{TRC->ZB0_CODATV,ALLTRIM(TRC->ZB0_ATIVID)})
	    TRC->(DbSkip())
	ENDDO
	
    _nLin := 190
    _nCol := 615
    	
	//imrime as atividades do cabec.
	For _xA := 1 to LEN(_aAtv)
	
		For _y := 1 to 6
			oPrint:Say(_nLin,_nCol,Substr(_aAtv[_xA][1],_y,1),oFont7)
			_nLin += 25
		Next
		    
		_nLin := 190
		_nCol += 45
	
	Next 
	
	oPrint:Line( 370, 580, 2200,  580 )   //VERTICAL 1
	oPrint:Line( 370, 060,  370, 3300 )   //HORIZONTAL 1

	TRC->(DbCloseArea())
	
    //rodape
	oPrint:Line( 2000,  60,  2000, 3300 )   //HORIZONTAL 2
    oPrint:Say ( 2020,  80,"Legenda",oFont8N)

    oPrint:SayBitmap( 2020,  650,cStartPath+"mv1.bmp",54,39)
    oPrint:Say(       2025,  720,"APTO",oFont7)

    oPrint:SayBitmap( 2020, 1000,cStartPath+"mv2.bmp",54,39)
    oPrint:Say( 	  2025, 1070,"APTO COM RESTRIÇÃO",oFont7)

//    oPrint:SayBitmap( 2020, 1350,cStartPath+"mv3.bmp",54,39)
//    oPrint:Say( 	  2025, 1420,"A TREINAR",oFont7)

    oPrint:SayBitmap( 2020, 1350,cStartPath+"mv4.bmp",54,39)
    oPrint:Say( 	  2025, 1420,"EM TREINAMENTO",oFont7)

    oPrint:SayBitmap( 2020, 1700,cStartPath+"mv5.bmp",54,39)
    oPrint:Say(		  2025, 1770,"NÃO APTO",oFont7)

    oPrint:SayBitmap( 2020, 2050,cStartPath+"mv6.bmp",54,39)
    oPrint:Say( 	  2025, 2120,"NÃO SE APLICA",oFont7)

	oPrint:Line( 2070,  60,  2070, 3300 )   //HORIZONTAL 3

    oPrint:Say ( 2090,  80,"Nome do Responsável: ",oFont8N)
	oPrint:Say ( 2160,  80,_cNome,oFont8)   

    oPrint:Say ( 2090,  3000,"Data de Emissão: ",oFont8N)
	oPrint:Say ( 2160,  3000,DtoC(Date()),oFont8)   

	oPrint:Line( 2200,  60,  2200, 3300 )   //HORIZONTAL 3

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME LEGENDA DAS ATIVIDADES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function TRM002Leg()

	oPrint:Say(100,1400,"MATRIZ DE VERSATILIDADE - "+ALLTRIM(_cCCDMat)+" - TURNO "+UPPER(_cTurno),oFont8N)
	
	_cLin := 300
	_cCol := 100

	For _xA := 1 to Len(_aAtv)
		oPrint:Say ( _cLin,  _cCol,_aAtv[_xA][1]+": ",oFont8N)
		oPrint:Say ( _cLin,  _cCol+140,_aAtv[_xA][2],oFont8)
		
		_cLin += 40
		
		If _cLin > 2050
		
			oPrint:Line( 2200,  60,  2200, 3300 )   //HORIZONTAL 3
			oPrint:EndPage()
			oPrint:Say(100,1400,"MATRIZ DE VERSATILIDADE - "+ALLTRIM(_cCCDMat)+" - TURNO "+UPPER(_cTurno),oFont8N)
			oPrint:Say(200, 100,"LEGENDA DAS ATIVIDADES:",oFont8N)	

			_cLin := 300
			_cCol := 100
			
		EndIf                                                      
	
	Next

	oPrint:Line( 2200,  60,  2200, 3300 )   //HORIZONTAL 3

Return


User Function ATUCC2011()
	Processa({|| fatu2011() },'processando')
Return

Static Function fatu2011()
Local cAl := getNextAlias()
Local cQl := getNextAlias()

	ZRG->(dbSetOrder(1)) // filial + mat

	beginSql Alias cAl
	
		SELECT count(*) c FROM ZB0NH0 ZB0
			WHERE ZB0.%NotDel%
			AND ZB0_CC != '105002'	
	endSql
	
	ProcRegua((cAl)->c)
	
	(cAl)->(dbCloseArea())
	
	beginSql Alias cAl
	
		SELECT * FROM ZB0NH0 ZB0
			WHERE ZB0.%NotDel%
		ORDER BY ZB0_CODATV
	
	endSql
	
	(cAl)->(dbGoTop())
	
	_cCodAux := ''

	BEGIN TRANSACTION
	
	While (cAl)->(!eof())
	
		IncProc()
		
		If _cCodAux != (cAl)->ZB0_CODATV
		
			_cCodAtv := fPesqAtv((cAl)->ZB0_ATIVID)
		     
			If Empty(_cCodAtv)
				_cCodAtv := GetSxeNum("ZB0","ZB0_CODATV")
			EndIf
			
			_cCodAux := (cAl)->ZB0_CODATV
			
		EndIf
		                                  
		_cCC := fNewCC((cAl)->ZB0_CC)
		
		if(!empty(_cCC))
		
			If !empty((cAl)->ZB0_AREA)
				_cArea := StrZero((Val((cAl)->ZB0_AREA) + 47),6)
			Else
				_cArea := ''
			EndIf
	

			RecLock("ZB0",.T.)
				ZB0->ZB0_FILIAL := xFilial("ZB0")
				ZB0->ZB0_CODATV := _cCodAtv
				ZB0->ZB0_CC     := _cCC
				ZB0->ZB0_ATIVID := (cAl)->ZB0_ATIVID
				ZB0->ZB0_AREA   := _cArea
			MsUnLock("ZB0")

			//funcionarios			
			beginSql Alias cQl
				SELECT * FROM ZB1NH0
				WHERE ZB1_CC   = %Exp:(cAl)->ZB0_CC%
				AND ZB1_ATIVID = %Exp:(cAl)->ZB0_CODATV%
				AND %NotDel%
			endSql
			     
			(cQl)->(dbGoTop())

			while (cQl)->(!eof())
			
				_cMat := fNewMat((cQl)->ZB1_MAT)
				
				If !empty(_cMat)
			
					RecLock("ZB1",.T.)
						ZB1->ZB1_FILIAL := xFilial("ZB1")
						ZB1->ZB1_MAT    := _cMat
						ZB1->ZB1_NOME   := (cQl)->ZB1_NOME   
						ZB1->ZB1_ATIVID := _cCodAtv  // Código da atividade[IFDGJIOFDS
						ZB1->ZB1_QUALIF := (cQl)->ZB1_QUALIF // Qualificacao
						ZB1->ZB1_IMPOTJ := (cQl)->ZB1_IMPOTJ //"S"            // Imprime On The Job? Sim
						ZB1->ZB1_CC     := _cCC // centro de custo
					MsUnlock("ZB1")
					
					// altera a area do funcionario na zrg
					If ZRG->(dbSeek(xFilial("ZRG")+_cMat))
					
						If !Empty((cAl)->ZB0_AREA)
							RecLock("ZRG")
								ZRG->ZRG_AREA := StrZero((Val((cAl)->ZB0_AREA) + 47),6)
							MsUnlock("ZRG")
						EndIf
					
					EndIf

				endif				
			
			
				(cQl)->(dbskip())
			enddo
			
			(cQl)->(dbCloseArea())
			
		endif
				
		(cAl)->(dbSkip())
	EndDo

	END TRANSACTION
		
	(cAl)->(dbCloseArea())

Return

Static Function fPesqAtv(cDesc)
Local cAl  := getNextAlias()
Local cCod := ''

	cDesc := StrTran(cDesc,"'","")
	
	beginSql Alias cAl
		SELECT ZB0_CODATV 
		FROM ZB0FN0 ZB0
		WHERE ZB0_ATIVID = %Exp:cDesc%
		AND ZB0.%NotDel%
	endSql
	
	If (cAl)->(!eof())
		cCod := (cAl)->ZB0_CODATV
	EndIf
	
	(cAl)->(dbCloseArea())

return cCod

Static function fNewCC(cCC)
Local cAl := getNextAlias()
Local cNewCC := ''
        
	beginSql Alias cAl
		SELECT TOP 1 RE_CCP cc
		FROM SRENH0
		WHERE RE_CCD = %Exp:cCC%
		AND %NotDel%
		AND LEN(RE_CCP)=8
		ORDER BY RE_DATA DESC
	endSql
          
	If (cAl)->(!eof())
		if len(alltrim((cAl)->cc))!=8 .and. !alltrim(cCC) $ '104002/104003/106001/305003/401002/401003/401004/401006/401013/401014/401015/405001/406001/406002/406005/407003/407004/407010/408001/409001/410003/412001/414001/415001/416001/416002/417003/417008/417009/419001/420001'
			Alert('cc com tamanho diferente de 8 digitos: D=' +cCC+ ' P=' +(cAl)->cc)
		else
			cNewCC := (cAl)->cc
		endif
	endif
	
	(cAl)->(dbCloseArea())
	
Return cNewCC

Static Function fNewMat(cMat)
Local cAl := getNextAlias()
Local cNewMat := ''

	beginSql Alias cAl
		SELECT TOP 1 RE_MATP mat
		FROM SRENH0
		WHERE RE_MATD = %Exp:cMat%
		AND %NotDel%
		ORDER BY RE_DATA DESC
	endSql
          
	If (cAl)->(!eof())
		cNewMat := (cAl)->mat
	endif
          
	(cAl)->(dbCloseArea())
Return cNewMat

//-- APAGA ATIVIDADES DUPLICADAS

User Function AtuAtv()
	Processa({|| fAtuAtv()},'processando ...')
Return


Static function fAtuAtv()
Local cAl := getNextAlias()
Local ZBORec := 0
Local count := 0

	dbSelectArea("ZB0")
	dbGotop()
	Procregua(RecCount())

	ZBORec := recno()
	While ZB0->(!eof())
		
		incproc()
		
		ZBORec := ZB0->(recno())
		
		beginSql Alias cAl
			select R_E_C_N_O_ AS REC 
			from ZB0FN0
			where
				ZB0_CC = %Exp:ZB0->ZB0_CC%
			and ZB0_AREA = %Exp:ZB0->ZB0_AREA%
			and ZB0_CODATV = %Exp:ZB0->ZB0_CODATV%
			and R_E_C_N_O_ <> %Exp:ZB0->(RecNo())%
		endSql
		
		while (cAl)->(!eof())
			dbgoto((cAl)->REC)
			Reclock('ZB0',.F.)
				ZB0->(dbdelete())
			Msunlock('ZB0')
			
			
			count++
			(cAl)->(dbskip())
		enddo
		
		(cAl)->(dbclosearea())
		
		ZB0->(dbGoTo(ZBORec))
				
		ZB0->(dbskip())
	enddo
	
	alert(str(count))
	
Return


//-- APAGA ATIVIDADES DOS FUNCIONARIOS DUPLICADAS

User Function AtuFun()
	Processa({|| fAtuFun()},'processando ...')
Return


Static function fAtuFun()
Local cAl := getNextAlias()
Local ZB1Rec := 0
Local count := 0

	dbSelectArea("ZB1")
	dbGotop()
	Procregua(RecCount())

	ZB1Rec := recno()
	While ZB1->(!eof())
		
		incproc()
		
		ZB1Rec := ZB1->(recno())
		
		beginSql Alias cAl
			select R_E_C_N_O_ AS REC 
			from ZB1FN0
			where
				ZB1_CC     = %Exp:ZB1->ZB1_CC%
			and ZB1_MAT    = %Exp:ZB1->ZB1_MAT%
			and ZB1_ATIVID = %Exp:ZB1->ZB1_ATIVID%
			and R_E_C_N_O_ <> %Exp:ZB1->(RecNo())%
		endSql
		
		while (cAl)->(!eof())
			dbgoto((cAl)->REC)
			Reclock('ZB1',.F.)
				ZB1->(dbdelete())
			Msunlock('ZB1')
			
			count++
			(cAl)->(dbskip())
		enddo
		
		(cAl)->(dbclosearea())
		
		ZB1->(dbGoTo(ZB1Rec))
				
		ZB1->(dbskip())
	enddo
	
	alert(str(count))
	
Return