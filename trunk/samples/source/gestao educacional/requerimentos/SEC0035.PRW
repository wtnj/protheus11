#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0035   ºAutor  ³Thiago Volpi        º Data ³  02/Jan/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibe as disciplinas que o aluno esta com dependencia       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SEC0035F()

Local oDlg, oBtOk, oBtCancel, oOrder, oChave, oSelect
Local nOpc		:= 0
Local cQuery	:= ""
Local aOrders	:= {"Nome","Codigo"}
Local cOrder	:= "Codigo"
Local aCpoBrw	:= {}
Local cFilter	:= ""
Local cTitle	:= "Seleção de Disciplinas - Dependentes"
Local cString	:= ""
Local cIndCond 	:= ""             
Local cArqNtx1 	:= ""
Local cArqNtx2 	:= ""
Local lret 		:= .F.
Local aRet    	:= ACScriptReq( JBH->JBH_NUM )

//Retorna as disciplinas que estao como reprova
cQuery += " SELECT JC7.JC7_DISCIP, JAE.JAE_DESC, MAX(JC7.R_E_C_N_O_) R_E_C_"
cQuery += " FROM  " + RetSqlName("JC7") + " JC7,  "
cQuery += RetSqlName("JAE") + " JAE "
cQuery += " WHERE JC7_NUMRA = '"+Substr(M->JBH_CODIDE,1,15)+"' "
cQuery += " AND JAE_CODIGO = JC7_DISCIP"
cQuery += " AND JC7_SITUAC = '3'"
cQuery += " AND JC7.D_E_L_E_T_ = ' '"
cQuery += " AND JAE.D_E_L_E_T_ = ' '"
cQuery += " AND JC7_SITDIS IN ('002','010')" //DP / Matriculado
cQuery += " AND JC7_CODCUR = '"+JBE->JBE_CODCUR+"' "
cQuery += " GROUP BY JC7_DISCIP, JAE_DESC"

Memowrite('c:\teste.txt',CQuery)

IF SELECT("TRB2") > 0
	DBCLOSEAREA( "TRB2" )
ENDIF

dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB2", .F., .T. )

dbselectarea("TRB2")
TRB2->(DBGOTOP())

cArq := CriaTrab(NIL,.f.)
copy to &cArq
dbCloseArea("TRB2")

IF SELECT("TRB1") > 0
	DBCLOSEAREA("TRB1")
ENDIF

DbUseArea(.T.,,cArq,"TRB1",.F.,.F.)
cIndCond := "JC7_DISCIP"
cArqNtx1 := SUBSTR(cArq,1,7)+'1'
IndRegua("TRB1",cArqNtx1,cIndCond,,,"Selecionando Registros...")
cIndCond := "JC7_DISCIP"
cArqNtx2 := SUBSTR(cArq,1,7)+'2'
IndRegua("TRB1",cArqNtx2,cIndCond,,,"Selecionando Registros...")
dbselectarea("TRB1")
dbSetIndex(cArqNtx1 + OrdBagExt())
dbSetIndex(cArqNtx2 + OrdBagExt())

cChave	:= PadR( &( ReadVar() ), TamSX3("JC7_DISCIP")[1] )
cChave2	:= PadR( &( ReadVar() ), TamSX3("JAE_DESC")[1] )

SX3->( dbSetOrder(2) )
SX3->( dbSeek( "JC7_DISCIP" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
SX3->( dbSeek( "JAE_DESC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )


define msDialog oDlg title cTitle from 000,000 to 300,400 pixel

oSelect := MsSelect():New("TRB1",,,aCpoBrw,,,{ 003, 003, 117, 166 },,,oDlg)
oSelect:bAval := {|| nOpc := 1, oDlg:End() }
oSelect:oBrowse:Refresh()

@ 125,004 SAY "Ordenar por:" size 40,08 of oDlg pixel
@ 125,042 combobox oOrder var cOrder items aOrders size 125,08 of oDlg pixel;
valid ( TRB1->( dbSetOrder(oOrder:nAt)), oSelect:oBrowse:Refresh(), .T.)

@ 137,004 say "Localizar:" size 40,08 of oDlg pixel
IF (oOrder:nAt) == 1
	@ 137,042 get oChave var cChAvE size 125,08 of oDlg pixel valid (TRB1->( dbSeek( RTrim( cChAvE ), .T. )), oSelect:oBrowse:Refresh(), .T.)
ELSEIF (oOrder:nAt) == 2
	@ 137,042 get oChave var cChAvE2 size 125,08 of oDlg pixel valid (TRB1->( dbSeek( cChAvE2, .T. )), oSelect:oBrowse:Refresh(),.T.)
ENDIF

define sbutton oBtOk     from 003,170 type 1 enable action ( nOpc := 1, oDlg:End() ) of oDlg pixel
define sbutton oBtCancel from 017,170 type 2 enable action ( nOpc := 0, oDlg:End() ) of oDlg pixel

activate msDialog oDlg centered

IF nOpc == 1
	DBSELECTAREA("JC7")
	JC7->(dbgoto(TRB1->R_E_C_))
	lret := .T.
ELSE
	lret := .F.
ENDIF

dbSELECTArea("TRB1")
dbCloseArea("TRB1")
FErase(cArq+GetDBExtension())
FErase(cArqNtx1+OrdBagExt())
FErase(cArqNtx2+OrdBagExt())

Return(lret)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0035   ºAutor  ³Thiago Volpi        º Data ³  02/Jan/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Se o requerimento for aprovado, altera o status da discipli-º±±
±±º          ³na                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SEC0035PW()

local aRet	:= {}
local lRet	:= .F. 			//Verifica se houve alteracao de disciplina
aRet	:= ACScriptReq( JBH->JBH_NUM )


/*

aRet[01] CURSO
aRet[02] DESCRICAO
aRet[03] PERIODO LETIVO
aRet[04] HABILITACAO
aRet[05] DESCRICAO
aRet[06] TURMA ATUAL
aRet[07] DISCIPLINA
aRet[08] DESCRICAO
aRet[09] NOTA
aRet[10] NOTA MINIMA
aRet[11] NOTA CONSELHO CLASSE


*/

dbSelectArea("JC7")
dbSetOrder(3)
If dbSeek(xFilial("JC7")+Substr(JBH->JBH_CODIDE,1,15)+aRet[07])
	While ! JC7->(Eof()) .And. xFilial("JC7")+Substr(JBH->JBH_CODIDE,1,15)+aRet[07] == ;
		JC7->JC7_FILIAL+JC7->JC7_NUMRA+JC7->JC7_DISCIP

			// Se for Mesmo Curso
			If JC7->JC7_CODCUR == aRet[01]

				RecLock("JC7",.F.)
					JC7->JC7_MEDANT	:= JC7->JC7_MEDFIM
					JC7->JC7_MEDFIM	:= Val(aRet[10])
					JC7->JC7_SITUAC	:= '2' //Aprovado
				JC7->(MsUnlock())			
				lRet := .T.
			Endif
		
		
		JC7->(dbSkip())
	Enddo
Else
	MsgAlert("Nao Foi Possivel Localizar a Disciplina")	
Endif

Return( lRet )
