#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SEC0034a บAutor  ณRafael Rodrigues    บ Data ณ  12/09/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Requerimento de Cancelamento de Disciplina                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Pesquisa SXB customizada para exibir as disciplinas do     บฑฑ
ฑฑบ          ณ aluno de acordo com a situacao desejada.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0034a()
Local oDlg, oBtOk, oBtCancel, oSelect
Local nOpc		:= 0
Local aCpoBrw	:= {}
Local cQuery	:= ""
Local aStru		:= {}
Local cTrb

cQuery += "Select Distinct "
cQuery +=   "JAE_CODIGO, "
cQuery +=   "JAE_DESC "
cQuery += "From "
cQuery +=   RetSqlName("JAE")+" JAE, "
cQuery +=   RetSqlName("JC7")+" JC7 "
cQuery += "Where "
cQuery +=   "    JAE_FILIAL = '"+xFilial("JAE")+"' and JAE.D_E_L_E_T_ <> '*' "
cQuery +=   "and JC7_FILIAL = '"+xFilial("JC7")+"' and JC7.D_E_L_E_T_ <> '*' "
cQuery +=   "and JAE_CODIGO = JC7_DISCIP "
cQuery +=   "and JC7_NUMRA  = '"+M->JBH_CODIDE+"' "
cQuery +=   "and JC7_CODCUR = '"+M->JBH_SCP01+"' "
cQuery +=   "and JC7_PERLET = '"+M->JBH_SCP03+"' "
cQuery +=   "and JC7_TURMA  = '"+M->JBH_SCP04+"' "
if M->JBH_SCP08 == "1"
	cQuery += "and JC7_SITDIS = '010' "
else
	cQuery += "and JC7_SITDIS in ('001','002','006') "
endif
cQuery += "Order By JAE_CODIGO"

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL034", .F., .F.)

SX3->( dbSetOrder(2) )
SX3->( dbSeek( "JAE_CODIGO" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
aAdd( aStru  , { RTrim( SX3->X3_CAMPO ), SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
SX3->( dbSeek( "JAE_DESC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
aAdd( aStru  , { RTrim( SX3->X3_CAMPO ), SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )

cTrb := CriaTrab( aStru, .T. )
dbUseArea( .T., "DBFCDX", cTrb, "TRB034", .F., .F. )

SQL034->( dbGoTop() )
while SQL034->( !eof() )
	TRB034->( RecLock("TRB034", .T.) )
	TRB034->JAE_CODIGO := SQL034->JAE_CODIGO
	TRB034->JAE_DESC   := SQL034->JAE_DESC
	TRB034->( msUnlock() )
	SQL034->( dbSkip() )
end

SQL034->( dbCloseArea() )
TRB034->( dbGoTop() )

define msDialog oDlg title "Sele็ใo de Disciplina" from 000,000 to 300,400 pixel

oSelect := MsSelect():New("TRB034",,,aCpoBrw,,,{ 003, 003, 145, 166 },,,oDlg)
oSelect:bAval := {|| nOpc := 1, oDlg:End() }
oSelect:oBrowse:Refresh()

define sbutton oBtOk     from 003,170 type 1 enable action ( nOpc := 1, oDlg:End() ) of oDlg pixel
define sbutton oBtCancel from 017,170 type 2 enable action ( nOpc := 0, oDlg:End() ) of oDlg pixel

activate msDialog oDlg centered

if nOpc == 1
	JAE->( dbSetOrder(1) )
	JAE->( dbSeek( xFilial("JAE")+TRB034->JAE_CODIGO ) )
endif

TRB034->( dbCloseArea() )
FErase( cTrb + GetDBExtension() )

Return nOpc == 1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SEC0034b บAutor  ณRafael Rodrigues    บ Data ณ  12/09/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Requerimento de Cancelamento de Disciplina                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Validacao da disciplina e da situacao escolhida.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0034b()
Local lRet := .T.
Local cSit := if( M->JBH_SCP08 == "1", "010", "001/002/006" )

lRet := Empty( M->JBH_SCP09 ) .or. Posicione("JC7",1,xFilial("JC7")+Subs(M->JBH_CODIDE,1,TamSX3("JC7_NUMRA")[1])+M->JBH_SCP01+M->JBH_SCP03+M->JBH_SCP04+M->JBH_SCP09, "JC7_SITDIS")$cSit

if !lRet
	Aviso( "Problema", "Esta disciplina nใo se enquadra na situa็ใo selecionada.", {"Ok"} )
endif

Return lRet