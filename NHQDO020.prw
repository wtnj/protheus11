/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ NHQDO020  ºAutor ³ Guilherme D. Camargo  ºData ³ 27/08/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³          TELA QUE PERMITE DELETAR DOCUMENTOS               º±±
±±º          ³          MESMO NAO SENDO RESPONSAVEL POR ELE               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³       	CONTROLE DE DOCUMENTOS                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.ch"
#INCLUDE "qdo.ch"

User Function NHQDO020()
	Private oGet1, oGet2
	Private oDlg, oButton1, oButton2, oFont, oSay1, oSay2, oCheck1
	Private cDoc := Space(16), cRev := Space(3) 
	Private lCheck1 := .F.

	If Upper(cUserName) $ RespArea	//Verifica no INCLUDE se o usuário está cadastrado na constante RespArea
		Define MSDialog oDlg From 0,0 To 150,430 Pixel Title 'Deletar Documento'
		oFont:=TFont():New("Courrier New",,-14,.T.)
		oSay1 := tSay():New(3,10,{||"Código do Documento"},oDlg,,,,,,.T.,CLR_HBLUE,)					         					
		oGet1 := tGet():New(11,10,{|u| if(Pcount() > 0, cDoc := u,cDoc)},oDlg,80,10,"@!",{||.T.},;
							,,,,,.T.,,,{|| .T. },,,,,,"QDH","cDoc")
		oSay2 := tSay():New(26,10,{||"Revisão do Documento"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oGet2 := tGet():New(34,10,{|u| if(Pcount() > 0, cRev := u,cRev)},oDlg,20,10,"@!",{||.T.},;
							,,,,,.T.,,,{|| .T. },,,,,,,"cRev")
		oButton1 := tButton():New(50,70,"Confirmar",oDlg,{||DelDoc()},60,15,,,,.T.)
		oButton2 := tButton():New(50,140,"Cancelar",oDlg, {|| oDlg:End()},60,15,,,,.T.)
		oCheck1 := TCheckBox():New(015,120,'Reutilizar Código',{|u|if(pcount()>0,lCheck1:=u,lCheck1)},oDlg, 100,210,,,oFont,,CLR_HBLUE,CLR_RED,,.T.,,,) 
		Activate MSDialog oDlg Centered
	Else
		Alert("Usuário sem permissão! Favor entrar em contato com o responsável pela planta!")
		Return
	EndIf

Return .T.


Static Function DelDoc()
Local cQuery
	If(Empty(cDoc) .OR. Empty(cRev))
		Alert("Favor informar o código do Documento e Revisão!")
		Return
	EndIf
	
	QDH->(DbSetOrder(1))//QDH_FILIAL+QDH_DOCTO+QDH_RV
	If !QDH->(DbSeek(xFilial("QDH") + SubStr(cDoc,1,16) + SubStr(cRev,1,3)))
		Alert("Documento não encontrado!")
		Return
	EndIf
	
	If(lCheck1)// SE ESTIVER 'CHECKADO', DELETA O REGISTRO
		cQuery := " DELETE FROM QDHFN0 WHERE QDH_DOCTO = '" + cDoc + "' AND QDH_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QD0FN0 WHERE QD0_DOCTO = '" + cDoc + "' AND QD0_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QD1FN0 WHERE QD1_DOCTO = '" + cDoc + "' AND QD1_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QD4FN0 WHERE QD4_DOCTO = '" + cDoc + "' AND QD4_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QD6FN0 WHERE QD6_DOCTO = '" + cDoc + "' AND QD6_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QD7FN0 WHERE QD7_DOCTO = '" + cDoc + "' AND QD7_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QD9FN0 WHERE QD9_DOCTO = '" + cDoc + "' AND QD9_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDBFN0 WHERE QDB_DOCTO = '" + cDoc + "' AND QDB_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDEFN0 WHERE QDE_DOCTO = '" + cDoc + "' AND QDE_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDGFN0 WHERE QDG_DOCTO = '" + cDoc + "' AND QDG_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDJFN0 WHERE QDJ_DOCTO = '" + cDoc + "' AND QDJ_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDRFN0 WHERE QDR_DOCTO = '" + cDoc + "' AND QDR_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDSFN0 WHERE QDS_DOCTO = '" + cDoc + "' AND QDS_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDUFN0 WHERE QDU_DOCTO = '" + cDoc + "' AND QDU_RV = '" + cRev + "'"
		cQuery += " DELETE FROM QDZFN0 WHERE QDZ_DOCTO = '" + cDoc + "' AND QDZ_RV = '" + cRev + "'"
	Else // SENAO MARCA COMO DELETADO
		cQuery := " UPDATE QDHFN0 SET D_E_L_E_T_ = '*' WHERE QDH_DOCTO = '" + cDoc + "' AND QDH_RV = '" + cRev + "'"
		cQuery += " UPDATE QD0FN0 SET D_E_L_E_T_ = '*' WHERE QD0_DOCTO = '" + cDoc + "' AND QD0_RV = '" + cRev + "'"
		cQuery += " UPDATE QD1FN0 SET D_E_L_E_T_ = '*' WHERE QD1_DOCTO = '" + cDoc + "' AND QD1_RV = '" + cRev + "'"
		cQuery += " UPDATE QD4FN0 SET D_E_L_E_T_ = '*' WHERE QD4_DOCTO = '" + cDoc + "' AND QD4_RV = '" + cRev + "'"
		cQuery += " UPDATE QD6FN0 SET D_E_L_E_T_ = '*' WHERE QD6_DOCTO = '" + cDoc + "' AND QD6_RV = '" + cRev + "'"
		cQuery += " UPDATE QD7FN0 SET D_E_L_E_T_ = '*' WHERE QD7_DOCTO = '" + cDoc + "' AND QD7_RV = '" + cRev + "'"
		cQuery += " UPDATE QD9FN0 SET D_E_L_E_T_ = '*' WHERE QD9_DOCTO = '" + cDoc + "' AND QD9_RV = '" + cRev + "'"
		cQuery += " UPDATE QDBFN0 SET D_E_L_E_T_ = '*' WHERE QDB_DOCTO = '" + cDoc + "' AND QDB_RV = '" + cRev + "'"
		cQuery += " UPDATE QDEFN0 SET D_E_L_E_T_ = '*' WHERE QDE_DOCTO = '" + cDoc + "' AND QDE_RV = '" + cRev + "'"
		cQuery += " UPDATE QDGFN0 SET D_E_L_E_T_ = '*' WHERE QDG_DOCTO = '" + cDoc + "' AND QDG_RV = '" + cRev + "'"
		cQuery += " UPDATE QDJFN0 SET D_E_L_E_T_ = '*' WHERE QDJ_DOCTO = '" + cDoc + "' AND QDJ_RV = '" + cRev + "'"
		cQuery += " UPDATE QDRFN0 SET D_E_L_E_T_ = '*' WHERE QDR_DOCTO = '" + cDoc + "' AND QDR_RV = '" + cRev + "'"
		cQuery += " UPDATE QDSFN0 SET D_E_L_E_T_ = '*' WHERE QDS_DOCTO = '" + cDoc + "' AND QDS_RV = '" + cRev + "'"
		cQuery += " UPDATE QDUFN0 SET D_E_L_E_T_ = '*' WHERE QDU_DOCTO = '" + cDoc + "' AND QDU_RV = '" + cRev + "'"
		cQuery += " UPDATE QDZFN0 SET D_E_L_E_T_ = '*' WHERE QDZ_DOCTO = '" + cDoc + "' AND QDZ_RV = '" + cRev + "'"
	EndIf
	If TCSQLExec(cQuery) < 0 //Executa a query
		cErro := TCSQLERROR()
		ALERT(cErro)
	Else
		Alert("Documento Deletado!")
		cDoc := Space(16)
		cRev := Space(3) 
 	Endif
Return