/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MNTA420A ºAutor  ³João Felipe da Rosa º Data ³  30/04/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA QUE PERMITE CRIACAO DE BOTAO ESPECIFICO   º±±
±±º          ³ NO BROWSE DA ROTINA MNTA420                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - MANUTENCAO                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "colors.ch"
#include "protheus.ch"
#include "topconn.ch"                   

User Function MNTA420A()

/*
	aAdd(aRotina,{"Sol. Compras","Processa({||U_MNT420SC()},'Solicitação de Compras')",0,3})

	If AllTrim(UPPER(cUserName))$"ALTEVIRMS/JOAOFR"
		aAdd(aRotina,{"Alt. Data"   ,"U_MNT420AD()",0,3})
	EndIf
*/

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ UMA TELA COM AS SCS DA OS SELECIONADA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
User Function MNT420SC()
Local nAltura    := 300
Local nLargura   := 500
Private aHeader  := {}
Private aCols    := {}

	aAdd(aHeader,{"Num SC"      , "C1_NUM"     , "@!"          , 06,00, ".F."  ,"","C","SC1"})  
	aAdd(aHeader,{"Produto"     , "C1_PRODUTO" , "@!"     	   , 15,00, ".F."  ,"","C","SC1"})  
	aAdd(aHeader,{"Desc."       , "C1_DESCRI"  , "@!"      	   , 40,00, ".F."  ,"","C","SC1"})  
	aAdd(aHeader,{"Quant."      , "C1_QUANT"   , "@E 9,999,999", 09,00, ".F."  ,"","N","SC1"})  
	aAdd(aHeader,{"Entregue"    , "C1_QUJE"    , "@E 9,999,999", 09,00, ".F."  ,"","N","SC1"})
	aAdd(aHeader,{"Pedido"      , "C7_NUM"     , "@!"          , 06,00, ".F."  ,"","C","SC7"})
	aAdd(aHeader,{"Dt. Entrega" , "C7_DATPRF"  , "99/99/99"    , 08,00, ".F."  ,"","D","SC7"})

	cQuery := " SELECT C1.C1_NUM, C1.C1_PRODUTO, C1.C1_DESCRI, C1.C1_QUANT, C1.C1_QUJE, "
	cQuery += " C7.C7_NUM, C7.C7_DATPRF FROM "+RetSqlName("SC1")+" C1, "+RetSqlName("SC7")+" C7 "
	cQuery += " WHERE C1_OS = '"+STJ->TJ_ORDEM+"'"
	cQuery += " AND C1.C1_NUM *= C7.C7_NUMSC"
	cQuery += " AND C1.C1_ITEM *= C7.C7_ITEMSC"
	cQuery += " AND C1.C1_FILIAL = '"+xFilial("SC1")+"'"
	cQuery += " AND C7.C7_FILIAL = '"+xFilial("SC7")+"'"
	cQuery += " AND C7.D_E_L_E_T_ = ''"
	cQuery += " AND C1.D_E_L_E_T_ = ''"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DbGoTop())
	
	If Empty(TRA1->C1_NUM)
		Alert("Não existe S.C. para esta O.S.!")
		TRA1->(DBCLOSEAREA())
		Return
	EndIf
	
	WHILE TRA1->(!eof())
		aAdd(aCols,{TRA1->C1_NUM,TRA1->C1_PRODUTO,SUBSTR(TRA1->C1_DESCRI,1,40),TRA1->C1_QUANT,TRA1->C1_QUJE,TRA1->C7_NUM, STOD(C7_DATPRF),.F.})
		TRA1->(DbSkip())
	ENDDO

	oDlg := MsDialog():New(0,0,nAltura,nLargura,"Solicitação de Compra",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay := tSay():New(10,10 ,{||"OS: "+STJ->TJ_ORDEM}  ,oDlg,,,,,,.T.,,)	

    // cria o getDados
	oGeTD := MsGetDados():New( 25               ,; //superior 
	                           5                ,; //esquerda
	                           (nAltura/2)-27       ,; //inferior
	                           (nLargura/2)-5       ,; //direita 	   
	                           4                ,; // nOpc
	                           "AllwaysTrue"    ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .F.              ,; // LDELETA
	                           .F.              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           Len(aCols)       ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd 
	                          )
	
	oGroup := tGroup():New((nAltura/2)-22,5,(nAltura/2)-20,(nLargura/2)-5,,oDlg,,,.T.)
	
    oBtn1 := tButton():New((nAltura/2)-15,(nLargura/2)-45,"Ok",oDlg,{||oDlg:End()},40,10,,,,.T.)
	
	oDlg:Activate(,,,.T.,{||.T.},,{||})

	TRA1->(DBCLOSEAREA())	

Return	
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE UMA TELA PARA ALTERACAO DA DATA ORIGINAL DA OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT420AD()
Private dDtOrigi  := STJ->TJ_DTORIGI

    oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	oDlg := MsDialog():New(0,0,100,200,"Altera Data Original",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"Ordem"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(10,50,{||STJ->TJ_ORDEM},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(22,10,{||"Dt Original"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(20,50,{|u| if(Pcount() > 0, dDtOrigi := u,dDtOrigi)},oDlg,40,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .T.},,,,,,,"dDtOrigi")

    oBtn1 := tButton():New(34,50,"Ok",oDlg,{||fGrvData()},40,10,,,,.T.)
	
	oDlg:Activate(,,,.T.,{||.T.},,{||})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA A DATA ORIGINAL NA TABELA STJ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvData()

	If AllTrim(UPPER(cUserName))$"ALTEVIRMS/JOAOFR"
		RecLock("STJ",.F.)
			STJ->TJ_DTORIGI := dDtOrigi
        MsUnLock("STJ")
	Else
		Alert("Somente AltevirMS pode alterar a Data Original da OS!")
    EndIf

	oDlg:End()
	
Return
*/