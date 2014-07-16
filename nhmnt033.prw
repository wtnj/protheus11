/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT033 ºAutor  ³João Felipe da Rosa  º Data ³  10/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CADASTRO DE TEMPO DE TRABALHO DAS LINHAS                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO                                                 º±±
±±ºUso       ³ RELATORIO NHMNT023                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                              
#Include "Protheus.Ch"
#include "rwmake.ch"

User Function NHMNT033()

Private cAlias    := "ZAW"
Private aRotina   := {}
Private lRefresh  := .T.
Private cCadastro := "Tempo de Trabalho das Linhas"
Private aButtons  := {}

aAdd( aRotina, {"Pesquisar" ,"AxPesqui"    ,0,1} )
aAdd( aRotina, {"Visualizar","U_fMNT33(2)" ,0,2} )
aAdd( aRotina, {"Incluir"   ,"U_fMNT33(3)" ,0,3} )
aAdd( aRotina, {"Alterar"   ,"U_fMNT33(4)" ,0,4} )
aAdd( aRotina, {"Excluir"   ,"U_fMNT33(5)" ,0,5} )

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function fMNT33(nParam)
Local _cCampo

Private nPar     := nParam
Private _cCC     := SPACE(9)
Private _cHrIni  := SPACE(5)
Private _cHrFim  := SPACE(5)
Private _dDtFim  := CTOD('  /  /  ')
Private _dDtIni  := CTOD('  /  /  ') 
Private _cCCDesc := "" 

Private lChk1,lChk2,lChk3,lChk4,lChk5,lChk6,lChk7 

//Fontes
DEFINE FONT oFont NAME "Arial" SIZE 12, -12

//Inicializa os dados
If nPar==2 .or. nPar==4 .or. nPar==5 //Visualizar, alterar, excluir
	
	_cCC     := ZAW->ZAW_CC
	_cHrIni  := ZAW->ZAW_HRINI
	_cHrFim  := ZAW->ZAW_HRFIM
	_dDtIni  := ZAW->ZAW_DTINI
	_dDtFim  := ZAW->ZAW_DTFIM
	_cSemana := ZAW->ZAW_SEMANA

	//Reverte o campo semana para os checkbox
	For _x := 1 to 7
		_cCampo := "lChk"+StrZero(_x,1)
		&(_cCampo):= Iif(Substr(_cSemana,_x,1)=="1",.T.,.F.) 
	Next
	
EndIf

//Constrói a tela
DEFINE MSDIALOG oDlg TITLE "Tempo de Trabalho da Linha" FROM 0,0 TO 255,480 PIXEL

@ 015,015 SAY "Linha: " 		Size 040,008 Object olCC
If nPar == 3 //incluir
	@ 015,045 GET _cCC F3 "CTT" Size 040,008 Object oCC valid fDescCC()
Else
	@ 015,045 SAY _cCC          Size 040,008 Object oCC
	oCC:Setfont(oFont)
EndIf

@ 015,100 GET _cCCDesc When .F.        Size 120,008 Object olCCDesc

@ 030,015 SAY "Hora Inicial: " Size 040,008 Object olHrIni
@ 030,045 GET _cHrIni Picture "99:99" When(nPar==3 .or. nPar==4) Size 020,008 VALID NGVALHORA(_cHrIni) Object oHrIni 
@ 045,015 SAY "Hora Final: " Size 040,008 Object olHrFin
@ 045,045 GET _cHrFim Picture "99:99" When(nPar==3 .or. nPar==4) Size 020,008 VALID NGVALHORA(_cHrFim) Object  oHrFim 

@ 030,110 SAY "Data Inicial: " Size 040,008 Object olDtIni
@ 030,140 GET _dDtIni Picture "99/99/99" When(nPar==3 .or. nPar==4) Size 040,008 VALID NGVALHORA(_cHrIni) Object oHrIni 
@ 045,110 SAY "Data Final: " Size 040,008 Object olDtFin
@ 045,140 GET _dDtFim Picture "99/99/99" When(nPar==3 .or. nPar==4) Size 040,008 VALID NGVALHORA(_cHrFim) Object  oHrFim 

@ 060,015 TO 100,230 LABEL "Dias da Semana" OF oDlg PIXEL

@ 070,020 SAY "Domingo" Size 040,008 Object olDom
@ 070,050 SAY "Segunda" Size 040,008 Object olSeg
@ 070,080 SAY "Terça"   Size 040,008 Object olTer
@ 070,110 SAY "Quarta"  Size 040,008 Object olQua
@ 070,140 SAY "Quinta"  Size 040,008 Object olQui
@ 070,170 SAY "Sexta"   Size 040,008 Object olSex
@ 070,200 SAY "Sábado"  Size 040,008 Object olSab

@ 080,025 CHECKBOX oChk1 VAR lChk1 PROMPT "" When(nPar==3 .or. nPar==4) SIZE 040,008 PIXEL OF oDlg //Dom
@ 080,055 CHECKBOX oChk2 VAR lChk2 PROMPT "" When(nPar==3 .or. nPar==4) SIZE 040,008 PIXEL OF oDlg //Seg
@ 080,085 CHECKBOX oChk3 VAR lChk3 PROMPT "" When(nPar==3 .or. nPar==4) SIZE 040,008 PIXEL OF oDlg //Ter
@ 080,115 CHECKBOX oChk4 VAR lChk4 PROMPT "" When(nPar==3 .or. nPar==4) SIZE 040,008 PIXEL OF oDlg //Qua
@ 080,145 CHECKBOX oChk5 VAR lChk5 PROMPT "" When(nPar==3 .or. nPar==4) SIZE 040,008 PIXEL OF oDlg //Qui
@ 080,175 CHECKBOX oChk6 VAR lChk6 PROMPT "" When(nPar==3 .or. nPar==4) SIZE 040,008 PIXEL OF oDlg //Sex
@ 080,205 CHECKBOX oChk7 VAR lChk7 PROMPT "" When(nPar==3 .or. nPar==4) SIZE 040,008 PIXEL OF oDlg //Sab  	
   	
@ 105,155 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION fOk()
@ 105,195 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER

Return Nil

//ÚÄÄÄÄ¿
//³ OK ³
//ÀÄÄÄÄÙ
      
Static Function fOk()
Private lOk := .F.

	If nPar == 2     //Visualiza
		lOk := .T.
	ElseIf nPar == 3 //Incluir
		fGrv(.T.)
	ElseIf nPar == 4 //Alterar
		fGrv(.F.)
	ElseIf nPar == 5 //Excluir
		fExcl()
	EndIf

	If lOk
		oDlg:End()
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INCLUI e ALTERA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Parametro: lAltInc (.T. para gravação, .F. para alteração)

Static Function fGrv(lAltInc)

	If !fVal()
		Return
	EndIf
	
	_cSemana := fGeraSemana()
	
	RecLock("ZAW",lAltInc)
		ZAW->ZAW_FILIAL := xFilial("ZAW")
		ZAW->ZAW_CC     := _cCC
		ZAW->ZAW_HRINI  := _cHrIni
		ZAW->ZAW_HRFIM  := _cHrFim
		ZAW->ZAW_DTINI  := _dDtIni
		ZAW->ZAW_DTFIM  := _dDtFim
		ZAW->ZAW_SEMANA := _cSemana
	MsUnlock("ZAW")
	
	lOk := .T.

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ

Static Function fExcl()

	If MsgYesNo("Tem certeza de que deseja excluir?","Confirmação")
		RecLock("ZAW")
			ZAW->(DbDelete())
		MsUnlock("ZAW")
	EndIf
	
	lOk := .T.

Return
    
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fVal()
	
	If Empty(_cCC)
		MsgBox("Informe uma linha!","Linha em branco","INFO")
		Return .F.
	EndIf
	
	If !ExistCpo("CTT",_cCC)
		MsgBox("Linha informada não existe no cadastro. Verifique!","Linha não existe","INFO")
		Return .F.
	EndIf
	
	If _dDtIni > _dDtFim
		MsgBox("Data inicial deve ser menor que data final!","Data incorreta","INFO")
		Return .F.
	EndIf 
	
	If _dDtIni == _dDtFim .AND. _cHrIni > _cHrFim
		MsgBox("Hora inicial deve ser menor que hora final!","Hora incorreta","INFO")
		Return .F.
	EndIf
	
	//Verifica se período informado não sobrepõe outro período cadastrado
	If nPar == 3 //inclui	
		DbSelectArea('ZAW')
		DbGoTop()
	
		While ZAW->(!Eof())
			
			If (ZAW->ZAW_CC == _cCC .AND. ;
			    (ZAW->ZAW_DTFIM >= _dDtIni .AND. ZAW->ZAW_DTINI <= _dDtIni .OR. ;
			    ZAW->ZAW_DTINI <= _dDtFim  .AND. ZAW->ZAW_DTFIM >= _dDtFim .OR. ;
			    ZAW->ZAW_DTINI <= _dDtIni  .AND. ZAW->ZAW_DTFIM >= _dDtFim .OR. ;
			    ZAW->ZAW_DTINI >= _dDtIni  .AND. ZAW->ZAW_DTFIM <= _dDtFim ))
			
					MsgBox("Não permitido para este período. Está sendo usado!","Período já utilizado","INFO")
					Return .F. 
			EndIf
			
			ZAW->(DBSKIP())
		
		EndDo 
	EndIf
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA SEMANA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fGeraSemana()
Local _cSem := ""
Local _cVar := ""

	//Funcao que cria uma string com os valores dos checkbox (Ex. "0100101") 1 = sim, 0 = nao
	For _x := 1 to 7
		_cVar := "lChk"+STRZERO(_x,1)
		If &(_cVar)
			_cSem += "1"
		Else
			_cSem += "0"
		EndIf
	Next

Return _cSem       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ DESCRICAO DO CC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fDescCC()

	DbSelectArea('CTT')
	DbSetOrder(1)//filial + cc
	If DbSeek(xFilial("CTT")+_cCC)
		_cCCDesc := CTT->CTT_DESC01
		olCCDesc:Refresh()
	ENDIF

Return NIL