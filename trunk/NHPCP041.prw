
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP041 Autor  ³José H Medeiros Felipetto  Data ³ 08/30/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CÓDIGO DE BARRAS AAM EDI                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHPCP041()
Private oRelato
Private aPergs := {}
Private lRet	

oRelato := Relatorio():New() // Instancia na variavel oRelato a Classe Relatorio.
	
oRelato:cPerg := "PCP041"
aAdd(aPergs,{"Documento"       ,"C", 09,0,"G",""      ,""       ,"","","","SF2"   ,""    }) //mv_par01

oRelato:AjustaSx1(aPergs) // Funcao que pega o Array aPergs e cadastra as perguntas no SX1	
	
If Pergunte(oRelato:cPerg,.T.)
	lRet := fVerVazios(mv_par01)
	If lRet
		Processa( {|| fQuery() }, "Aguarde Gerando Dados para Etiqueta...")
		TRA1->(DbCloseArea() )
	Else
		Return .F.
	EndIf
Else
	Return .F.
EndIf

Return

Static Function fQuery()
	
	cQuery := "SELECT ZQ_EMISSAO,B1_COD,B1_DESC,D2_DOC,D2_QUANT,D2_COD, D2_LOTECTL " 
	cQuery += " FROM " + RetSqlName("SD2") + " D2 , " + RetSqlName("SB1") + " B1 , " + RetSqlName("SZQ") + " ZQ " 
	cQuery += " WHERE D2_COD  = B1_COD AND D2_ORDLIB = ZQ_NUM AND D2_DOC = '" + mv_par01 + "'" 
	cQuery += " AND D2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND ZQ.D_E_L_E_T_ = '' "
	cQuery += " AND D2.D2_FILIAL = '" + xFilial("SD2") + "' AND B1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " AND ZQ.ZQ_FILIAL = '" + xFilial("SZQ") + "' "
	
	MemoWrit("D:\temp\QueryPCP041.sql",cQuery)
	TCQUERY cQuery NEW ALIAS  "TRA1"
	TcSetField("TRA1","ZQ_EMISSAO","D")  // Muda a data de string para date    
	
	DbSelectArea("TRA1")
	Processa( {|| RptDetail() }, "Aguarde Gerando Etiqueta...")

Return

Static Function RptDetail()
	// Declaração de Variáveis

	SetPrvt("nColInic,nAltInic,oFnt1,oPrn")
	
	oFnt1 		:= TFont():New("Arial"		,,12,,.F.,,,,,.F.) 
	oFnt2 		:= TFont():New("Arial"		,,14,,.T.,,,,,.F.) 
	oFnt3 		:= TFont():New("Arial"		,,10,,.T.,,,,,.F.) 
	oFnt4 		:= TFont():New("Arial"		,,12,,.T.,,,,,.F.) 
	oFnt5 		:= TFont():New("Arial"		,,20,,.T.,,,,,.F.) 
	oFnt6 		:= TFont():New("Arial"		,,16,,.T.,,,,,.F.) 
	oFnt7 		:= TFont():New("Arial"		,,16,,.T.,,,,,.F.) 
	oFnt8 		:= TFont():New("Arial"		,,08,,.F.,,,,,.F.) 
	oFnt9 		:= TFont():New("Arial"		,,11,,.T.,,,,,.F.) 


	// Atribuições de valores Iniciais
	nColInic := 20
	nAltInic := 20

	oPrn := tAvPrinter():New("Protheus") // Transformação de oPrn em Objeto
	//oPrn:SetPortrait()
	oPrn:SetLandScape()

	oPrn:StartPage() // Começa a página

	// QUADRO 1 -- FROM / TO 
	oPrn:Line(nAltInic,nColInic * 88,nAltInic + 1610,nColInic * 88)
	oPrn:Line(nAltInic,nColInic,nAltInic,nColInic * 88)
	oPrn:Say(nAltInic + 20,nColInic + 20,"FROM",oFnt1)
	oPrn:Say(nAltInic + 72,nColInic + 40,"WHB COMP. AUTOMOTIVOS.",oFnt9)
	oPrn:Line(nAltInic, (nColInic * 70)/2, nAltInic + 240, (nColInic * 70)/2) // Linha vertical do campo FROM/TO

	oPrn:Say(nAltInic + 20,((nColInic * 72)/2) + 5,"TO",oFnt1)
	oPrn:Say(nAltInic + 72,((nColInic * 72)/2) + 15,"AAM DO BRASIL - ARAUCÁRIA.",oFnt2)
	oPrn:Say(nAltInic + 112,((nColInic * 72)/2) + 15,"AV. DAS NACOES,2051",oFnt2)
	oPrn:Say(nAltInic + 162,((nColInic * 72)/2) + 15,"Araucaria - PR",oFnt2)
	oPrn:Line(nAltInic + 240,nColInic,nAltInic + 240,nColInic * 88)

	// QUADRO 2   CR1/LOTE
	//oPrn:Say(nAltInic + 260,nColInic + 20,"CR1/LOTE",oFnt1)
	//oPrn:Say(nAltInic + 350,nColInic + 20,TRA1->D2_LOTECTL,oFnt4)
    //MSBAR("CODE3_9",3.4,0.3,UPPER("P")+Alltrim(TRA1->D2_LOTECTL),oPrn,.F., ,.T.  ,0.0311,0.9,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
	oPrn:Line(nAltInic + 520,nColInic,nAltInic + 520,nColInic * 88)

	//QUADRO 3  QUANTITY
	oPrn:Say(nAltInic + 520,nColInic + 20,"QUANTITY",oFnt1)
	oPrn:Say(nAltInic + 580,nColInic + 20,Alltrim(STR(TRA1->D2_QUANT)),oFnt4)
	MSBAR("CODE3_9",5.3,0.3,UPPER("Q")+Alltrim(Str(TRA1->D2_QUANT)),oPrn,.F., ,.T.  ,0.0311,0.9,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
	oPrn:Line(nAltInic + 750,nColInic,nAltInic + 750,nColInic * 88)

	// QUADRO 4 SHIPMENT DATE
	oPrn:Say(nAltInic + 780,nColInic,"SHIPMENT DATE",oFnt1)
	oPrn:Say(nAltInic + 830,nColInic,DTOC(TRA1->ZQ_EMISSAO),oFnt5)
	oPrn:Say(nAltInic + 910,nColInic,"REV LEVEL",oFnt1)
	oPrn:Line(nAltInic + 960,nColInic,nAltInic + 960,nColInic * 88)

	// QUADRO 5 CUST PART
	oPrn:Say(nAltInic + 1020,nColInic,"Cust Part",oFnt1)
	oPrn:Say(nAltInic + 1100,nColInic,TRA1->B1_COD,oFnt5)
	MSBAR("CODE3_9",09.8,0.1,UPPER("P") + Alltrim(TRA1->B1_COD),oPrn,.F., ,.T.  ,0.0311,0.9,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
	oPrn:Say(nAltInic + 1300,nColInic ,"Part Desc:",oFnt1)
	oPrn:Say(nAltInic + 1300,nColInic + 200,"              " + TRA1->B1_DESC,oFnt6)
	oPrn:Line(nAltInic + 1400,nColInic,nAltInic + 1400,nColInic * 88)

	// QUADRO PKG N.F EMPILHAMENTO
	oPrn:Say(nAltInic + 1450,nColInic,"PKG - ID - UNIT",oFnt1)
	oPrn:Say(nAltInic + 1510,nColInic + 10,"1 / 3",oFnt5)
	oPrn:Say(nAltInic + 1450,nColInic * 24,"N.F",oFnt1)
	oPrn:Say(nAltInic + 1510,nColInic * 21,TRA1->D2_DOC,oFnt5)
	oPrn:Say(nAltInic + 1450,nColInic * 47,"EMPILHAMENTO",oFnt1)
	oPrn:Say(nAltInic + 1510,nColInic * 51,"3.0",oFnt5)
	oPrn:Line(nAltInic + 1440,nColInic * 65,nAltInic + 1550,nColInic * 65)
	oPrn:Say(nAltInic + 1460,nColInic * 70,"AAM Quality Position",oFnt8)
	oPrn:Say(nAltInic + 1500,nColInic * 69,"Posição Qualidade AAM",oFnt8)

	oPrn:Line(nAltInic + 1610,nColInic,nAltInic + 1610,nColInic * 88)

	oPrn:Preview() // Visualiza a página
	oPrn:End() // Finaliza a página
Return

Static Function fVerVazios(parametro)
If Empty(parametro)
	alert("Campo documento deve ser preenchido! ")
	Return .F.
EndIf
Return .T.




