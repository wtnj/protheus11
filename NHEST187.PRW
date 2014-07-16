
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST187   ºAutor  ³José Henrique M Felipettoº Data ³  06/10/11   
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualização de Dados de NF.                       ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque/Custos                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                         

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.ch"

User Function NHEST187

Private bEnchoice 	:= {||}
Private bOk       	:= {||}
Private dDtDig	  	:= space(12)
Private nDoc 		:= space(12)
Private nSerie 		:= space(4)
Private nVal		:= space(12)
Private dData	    := Date(dDatabase)
Private aCols	  	:= {}
Private aHeader     := {}

cQuery := "Select F1_DTDIGIT,F1_DOC,F1_SERIE,F1_VALMERC "
cQuery += " From SF1FN0 (NoLock) Where D_E_L_E_T_ = ' ' "
cQuery += " AND '" + CNFISCAL + "' = F1_DOC "
cQuery += " AND '" + CA100FOR + "' = F1_FORNECE "
cQuery += " AND '" + CLOJA + "' = F1_LOJA "
cQuery += " AND F1_DTDIGIT BETWEEN'" + Dtos(dDatabase - 180) + "' AND '" + Dtos(dDatabase + 180) + "'"
cQuery += " ORDER BY F1_DTDIGIT "
TCQUERY cQuery NEW ALIAS "TRA1"
DbSelectArea("TRA1")

If (TRA1->F1_DOC == CNFISCAL)
 	fIgual()
EndIf

If Select("TRA1") > 0 //Verifica se o alias esta aberto em uso e fecha
    TRA1->(dbCloseArea())
EndIf

Return(.T.)

Static Function fIgual()

Aadd(aHeader,{"Data de Digitação", "F1_DTDIGIT","@99/99/99",09,0,".F.","","D","SF1"})
Aadd(aHeader,{"Serie","F1_SERIE","@!",02,0,".F.","","C","SF1"})
Aadd(aHeader,{"Valor da Mercadoria","F1_VALMERC","@999,99",10,0,".F.","","C","SF1"})


Do While TRA1->( !EOF() .AND. CNFISCAL == TRA1->F1_DOC )
	aAdd(aCols,{STOD(TRA1->F1_DTDIGIT),TRA1->F1_SERIE,TRA1->F1_VALMERC,.F.})
	TRA1->( DbSkip() )
EndDo

oDlg := MSDialog():New(10,10,300,500,'Visualização de Notas com Números iguais.',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay0 := tSay():New(010,010,{||"Este número de Nota Fiscal já existe. Verifique as informações para continuar:"},oDlg,,,,,,.T.,,) 
	oSay1 := tSay():New(020,010,{||"Número da NF:   " + CNFISCAL},oDlg,,,,,,.T.,,)
	oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 030     ,; //superior
                           010     			,; //esquerda
                           120			    ,; //inferior
                           200				,; //direita
                           4 				,; // nOpc
                           "AllwaysTrue"    ,; // CLINHAOK
                           "AllwaysTrue"    ,; // CTUDOOK
                           ""               ,; // CINICPOS
                           .T.              ,; // LDELETA
                           nil              ,; // aAlter
                           nil              ,; // uPar1
                           .F.              ,; // LEMPTY
                           200              ,; // nMax
                           nil              ,; // cCampoOk
                           "AllwaysTrue()"  ,; // CSUPERDEL
                           nil              ,; // uPar2
                           "AllwaysTrue()"  ,; // CDELOK
                           oDlg              ; // oWnd
                          )  
	oBt1 := tButton():New(125,010,"Ok",oDlg,{||oDlg:End()},30,10,,,,.T.)      

oDlg:Activate(,,,.F.,{||.T.},,)
Return // Return da Static Fuction





