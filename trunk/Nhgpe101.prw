/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE101  ºAutor  ³Marcos R Roquitski  º Data ³  20/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Supervisao X Centro de Custo                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch" 
#INCLUDE "PROTHEUS.CH"  

User Function NhGpe101() 

SetPrvt("cCadastro,aRotina")

cCadastro := 'Cadastro de Supervisao\Centro de Custo"

aRotina := {{ "Pesquisa","AxPesqui"    ,0,1},;
            { "Visual"  ,"AxDeleta"    ,0,2},;
            { "Inclui"  ,"U_GPE101()"  ,0,3},;
            { "Excluir", "AxExclui"    ,0,4},;     // botao excluir            
            { "Altera"  ,"AxAltera"    ,0,3}}

DbSelectArea("ZRJ")
ZRJ->(DbGotop())
mBrowse(,,,,"ZRJ",,,,,,)

Return

User Function GPE101()
SetPrvt("oDlg,bEnchoice,_cLogin,_cCC,_lCheck,oCkeckImg,_cTurno")

_cTurno := ''

bOk       := {|| fInclui(_cLogin,_cCC) }
bCanc     := {|| oDlg:End() }
bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
_cLogin   := space(25)
_cCc	  := space(9)

oDlg := MsDialog():New(0,0,150,500,"Responsável/Centro de Custo - Incluir",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oSay1 := TSay():New(28,10,{||"Login"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet1 := tGet():New(26,30,{|u| if(Pcount() > 0, _cLogin := u,_cLogin)},oDlg,60,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .T. },,,,,,"QUS","_cLogin")

oSay2 := TSay():New(28,120,{||"Centro de Custo"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet2 := tGet():New(26,180,{|u| if(Pcount() > 0, _cCC := u,_cCC)},oDlg,60,8,"@!",{||.T.},;
,,,,,.T.,,,{|| .T. },,,,,,"CTT","_cCC")

oSay3 := TSay():New(48,120,{||"Turno"},oDlg,,,,,,.T.,CLR_HBLUE,)          

oGet3 := TComboBox():New(046,180,{|u| if(Pcount() > 0,_cTurno := u,_cTurno)},;
   {'','1=1 Turno','2=2 Turno','3=3 Turno','4= Todos'},50,10,oDlg,,{||},,,,.T.,,,,{|| .T.},,,,,"_cTurno")

oCheckImg := tCheckBox():New(48,10,"Mais de um CC?",{|u| if(pcount() > 0, _lCheck := u, _lCheck )};
,oDlg,60,8,/*Reservado*/,{|| fMark(_cCC,_cLogin) },,,,,,.T.)


oDlg:Activate(,,,.t.,{||.T.},,bEnchoice)
Return

Static Function fInclui(Login,Custo)  
	
	ZRJ->(dbsetorder(1)) //ZRJ_FILIAL+ZRJ_LOGIN+ZRJ_CC 
	If !ZRJ->(dbseek(xFilial('ZRJ')+PadR(Login,TamSx3("ZRJ_LOGIN")[1])+Custo+_cTurno))

		RecLock("ZRJ",.T.)
			ZRJ->ZRJ_FILIAL := xFilial("ZRJ")
			ZRJ->ZRJ_LOGIN  := Upper(Login)
			ZRJ->ZRJ_CC     := Custo
			ZRJ->ZRJ_TURNO  := _cTurno
		MsUnLock("ZRJ")
	
	Endif
	
	MsgInfo("Centro de Custo para o Login " + Alltrim(Login) + " cadastrados com sucesso! ")
	oDlg:End()
	
Return

Static Function fMark(Custo,Login)

If !_lCheck 
	Return .F.
EndIF

If Empty(Custo) .or. Empty(Login) .or. Empty(_cTurno)
	alert("Primeiro,digite um Login, Centro de Custo e Turno ! ")
	Return .F.
EndIf

SetPrvt("cMarca,_aXDBF,_cArqXDBF,aCampos,cCadastro,aRotina,oDlgLocalNF,oDlgParamNF,cAl,cLike")
cMarca := GetMark()
cAl := getnextAlias()
cLike := (ALLTRIM(Custo) + "%")

cCadastro := OemToAnsi("Selecione o Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Marca Tudo"    ,'U_fMarcavk()' , 0 , 4  },;
{"Desmarca Tudo" ,'U_fDesmarvk()', 0 , 1  },;
{"Legenda"       ,'U_fLegVoks()' , 0 , 1  },;
{"Gravar"       ,'U_fGrvCC(_cLogin)' , 0 , 1  }}

If Select("XDBF") > 0
	XDBF->(DbCloseArea())
Endif

// Cria Campos para mostrar no Browser
_cArqXDBF := CriaTrab(NIL,.f.)
_aXDBF    := {}
// Nome
AADD(_aXDBF,{"OK"       ,"C", 02,0})         // Identificacao Marca
AADD(_aXDBF,{"CC"       ,"C", 09,0})         //  Centro de Custo
AADD(_aXDBF,{"DESCCC"   ,"C", 40,0})         //  Desc CC

DbCreate(_cArqXDBF,_aXDBF)
DbUseArea(.T.,,_cArqXDBF,"XDBF",.F.)

aCampos := {}
Aadd(aCampos,{"OK"        ,"C", "  "             ,"@!"})
Aadd(aCampos,{"CC"        ,"C", "Centro de Custo","@!"})
Aadd(aCampos,{"DESCCC"    ,"C", "Descrição"      ,"@!"})

If Select((cAl)) > 0
	(cAl)->(DbCloseArea() )
EndIf

BeginSql alias cAl
	SELECT CTT_CUSTO,CTT_DESC01 FROM %TABLE:CTT%
	WHERE CTT_CUSTO LIKE %Exp:cLike%
	AND CTT_CLASSE = '2'
	AND CTT_BLOQ != '1'
	AND CTT_FILIAL = %xFilial:CTT%
	AND %notDel%
EndSql

If (cAl)->(eof() )
	alert("Não há nenhum Centro de custo que comece com este número! ")
	Return .F.
EndIf

While (cAl)->(!EOF() )
	RecLock("XDBF",.T.)
		XDBF->OK	 := ""
		XDBF->CC     := (cAl)->CTT_CUSTO
		XDBF->DESCCC := (cAl)->CTT_DESC01
	MsUnLock("XDBF")
	(cAl)->(DbSkip() )
EndDo
XDBF->(DbGoTop())

(cAl)->(DbCloseArea() )

Index On XDBF->CC To (_cArqXDBF)
MarkBrow("XDBF","OK" ,"XDBF->OK",aCampos,,cMarca)

Return

User Function fGrvCC(Login)

XDBF->(DBGOTOP())

ZRJ->(dbsetorder(1)) //ZRJ_FILIAL+ZRJ_LOGIN+ZRJ_CC    

While XDBF->(!EOF() ) 

	If XDBF->(MARKED('OK')) .and. !ZRJ->(dbseek(xFilial('ZRJ')+PAD(Login,25," ")+XDBF->CC+_cTurno))
	
		RecLock("ZRJ",.T.)
			ZRJ->ZRJ_FILIAL := xFilial("ZRJ")
			ZRJ->ZRJ_LOGIN  := UPPER(Login)
			ZRJ->ZRJ_CC 	:= XDBF->CC
			ZRJ->ZRJ_TURNO 	:= _cTurno
		MsUnLock("ZRJ")
	
	Endif

	XDBF->(DbSkip() )

EndDo

MsgInfo("Centros de Custo para o Login " + Alltrim(Login) + " cadastrados com sucesso! ")

oDlg:End()

Return