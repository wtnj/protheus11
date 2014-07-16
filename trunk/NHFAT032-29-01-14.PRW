/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFAT032  ºAutor  ³João Felipe da Rosa º Data ³  17/03/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESSAO DA NOTA DE DEBITO AO FORNECEDOR                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch" 

User Function NHFAT032()

Local _nLin 
Local _nCol
Private oPrint
Private cStartPath 	:= GetSrvProfString("Startpath","")

cStartPath += Iif(Right(cStartPath,1)=="\","","\")

//CRIA OS OBJETOS DE IMPRESSÃO
oPrint := TMSPrinter():New("NOTA DE DÉBITO")
oPrint:SetPortrait() //SetLandScape
	
//define as fontes
oFont10  := TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFont10s := TFont():New("Arial" ,10,10,,.F.,,,,.T.,.T.)
oFont10b := TFont():New("Arial" ,10,10,,.T.,,,,.T.,.F.)

oFont12  := TFont():New("Arial" ,12,12,,.F.,,,,.T.,.F.)
oFont14b := TFont():New("Arial" ,14,14,,.T.,,,,.T.,.F.)

//_nLin := _nCol := 100
              
oPrint:SayBitmap(120,930,cStartPath+"WHBL.bmp",600,270)   //logo whb

oPrint:Say(550,1000,"NOTA DE DÉBITO",oFont14b)

If SM0->M0_CODIGO=="FN"
	oPrint:Say(430,1020,"WHB Fundição S/A",oFont12)	
	oPrint:Say(710,950,"CNPJ: 01.261.681/0001-04",oFont12)
ElseIf SM0->M0_CODIGO=="NH"	
	oPrint:Say(430,860,"WHB Componentes Automotivos S/A",oFont12)	
	oPrint:Say(710,950,"CNPJ: 73.355.174/0001-40",oFont12)
EndIf

nLin := 850

fPrintBox(nLin,100,nLin+500,2280) //caixa 01 
nLin += 520
fPrintBox(nLin,100,nLin+450,2280) //caixa 02
nLin += 470
fPrintBox(nLin,100,nLin+450,2280) //caixa 03
nLin += 470
fPrintBox(nLin,100,nLin+350,2280) //caixa 04
           
//-- dados da caixa 1
nLin := 880

oPrint:Say(nLin,  130 ,"Dados do Fornecedor:",oFont10s)	
nLin += 100
oPrint:Say(nLin,  130 ,"Fornecedor:"         ,oFont10b)	
oPrint:Say(nLin,  460 ,ZDM->ZDM_FORNEC       ,oFont10)	
oPrint:Say(nLin, 1250 ,"Loja:"               ,oFont10b)	
oPrint:Say(nLin, 1600 ,ZDM->ZDM_LOJFOR       ,oFont10)	
nLin += 60

SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+ZDM->ZDM_FORNEC+ZDM->ZDM_LOJFOR))

oPrint:Say(nLin,  130 ,"Razão Social:"       ,oFont10b)	
oPrint:Say(nLin,  460 ,SA2->A2_NOME          ,oFont10)
nLin += 60

oPrint:Say(nLin,  130 ,"Endereço:"           ,oFont10b)
oPrint:Say(nLin,  460 ,SA2->A2_END           ,oFont10)
nLin += 60

oPrint:Say(nLin,  130 ,"Cidade:"             ,oFont10b)
oPrint:Say(nLin,  460 ,SA2->A2_MUN           ,oFont10)
nLin += 60

oPrint:Say(nLin,  130 ,"CEP:"                ,oFont10b)
oPrint:Say(nLin,  460 ,SA2->A2_CEP           ,oFont10)
nLin += 60

oPrint:Say(nLin,  130 ,"CNPJ:"               ,oFont10b)
oPrint:Say(nLin,  460 ,SA2->A2_CGC           ,oFont10)
oPrint:Say(nLin, 1250 ,"Inscrição Estadual:" ,oFont10b)
oPrint:Say(nLin, 1600 ,SA2->A2_INSCR         ,oFont10)

//-- dados da caixa 2
nLin := 1400
oPrint:Say(nLin,  130 ,"Dados do Débito:"    ,oFont10s)
nLin += 100
oPrint:Say(nLin,  130 ,"Nº Débito:"          ,oFont10b)
oPrint:Say(nLin,  460 ,ZDM->ZDM_DOC+" - "+ZDM->ZDM_SERIE ,oFont10)

SF2->(dbSetOrder(1)) //FILIAL + NF + SERIE + FORN + LOJA
SF2->(dbSeek(xFilial("SF2")+ZDM->ZDM_DOC+ZDM->ZDM_SERIE+ZDM->ZDM_CLI+ZDM->ZDM_LOJCLI))
oPrint:Say(nLin, 1250 ,"Emissão ND:"         ,oFont10b)	
oPrint:Say(nLin, 1600 ,Iif(SF2->(Found()),DtoC(SF2->F2_EMISSAO),"") ,oFont10)
nLin += 60

oPrint:Say(nLin,  130 ,"Nº da Nota:"         ,oFont10b)
oPrint:Say(nLin,  460 ,ZDM->ZDM_DOCORI+" - "+ZDM->ZDM_SERORI ,oFont10)
SF1->(dbSetOrder(1)) //FILIAL + NF + SERIE + FORN + LOJA
SF1->(dbSeek(xFilial("SF1")+ZDM->ZDM_DOCORI+ZDM->ZDM_SERORI+ZDM->ZDM_FORNEC+ZDM->ZDM_LOJFOR))
oPrint:Say(nLin, 1250 ,"Emissão NF:"         ,oFont10b)
oPrint:Say(nLin, 1600 ,Iif(SF1->(FOUND()),DtoC(SF1->F1_EMISSAO),"") ,oFont10)
nLin += 60

//busca a data de vencimento
SE2->(dbSetOrder(6)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
SE2->(dbSeek(xFilial("SE2")+ZDM->ZDM_FORNEC+ZDM->ZDM_LOJFOR+ZDM->ZDM_SERORI+ZDM->ZDM_DOCORI))
oPrint:Say(nLin,  130 ,"Data Vcto:"          ,oFont10b)	
oPrint:Say(nLin,  460 ,Iif(SE2->(FOUND()),DtoC(SE2->E2_VENCTO),"") ,oFont10)

cMater := ""
cUn    := ""

//busca a descricao do material
SD1->(dbSetOrder(1)) //FILIAL + NF + SERIE + FORN + LOJA
If SD1->(dbSeek(xFilial("SD1")+ZDM->ZDM_DOCORI+ZDM->ZDM_SERORI+ZDM->ZDM_FORNEC+ZDM->ZDM_LOJFOR))
	SB1->(dbSetOrder(1)) //FILIAL + COD
	If SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
		cMater := SB1->B1_DESC
		cUn    := SB1->B1_UM
	EndIf
EndIf

oPrint:Say(nLin, 1250 ,"Material:"           ,oFont10b)
oPrint:Say(nLin, 1600 ,Substr(cMater,1,40)   ,oFont10)
nLin += 60

oPrint:Say(nLin,  130 ,"Unidade:"            ,oFont10b)	
oPrint:Say(nLin,  460 ,cUn                   ,oFont10)
oPrint:Say(nLin, 1250 ,"Solicitante:"        ,oFont10b)
oPrint:Say(nLin, 1600 ,ZDM->ZDM_SOLIC        ,oFont10)
nLin += 60

oPrint:Say(nLin,  130 ,"Vlr Total Débito:"   ,oFont10b)
oPrint:Say(nLin,  460 ,AllTrim(Transform(Iif(SF2->(Found()),SF2->F2_VALBRUT,0),"@e 999,999,999.99")) ,oFont10)

//-- dados da caixa 3
nLin := 1870
oPrint:Say(nLin,  130 ,"Histórico:"          ,oFont10s)

nLinha := MlCount(ZDM->ZDM_MOTIVO,110)
nLin   := 1970
For y:=1 to nLinha
	oPrint:Say(nLin, 130,OemToAnsi(MemoLine(ZDM->ZDM_MOTIVO,110,y)),oFont10)
	nLin += 40
Next

nLin   += 40

nLinha := MlCount(ZDM->ZDM_MOTIV2,110)
For y:=1 to nLinha
	oPrint:Say(nLin, 130,OemToAnsi(MemoLine(ZDM->ZDM_MOTIV2,110,y)),oFont10)
	nLin += 40
Next

//-- dados da caixa 4
nLin := 2340
oPrint:Say(nLin,  130 ,"DECLARAÇÃO"          ,oFont10b)

cDec := "Declaramos para os devidos fins previstos no artigo 166 "+;
"e demais pertinente ao código tributário nacional(lei nº 5.172 de 25/10/66) "+;
"não havermos aproveitado os créditos referentes ao ICMS e IPI correspondentes "+;
"a nota fiscal acima mencionada, pagos a maior ou indevidamente pelo fornecedor "+;
"acima.Assim sendo, está a mesma, perfeitamente apta a pleitear a restituição dos "+;
"referidos impostos, na forma da legislação vigente "

nLinha := MlCount(cDec,120)
nLin   := 2440
For y:=1 to nLinha
	oPrint:Say(nLin, 130,OemToAnsi(MemoLine(cDec,120,y)),oFont10)
	nLin += 40
Next

oPrint:Say(2880,  130 ,"Emitente:"          ,oFont10b)
oPrint:Line(3080, 130 , 3080 , 1000)
oPrint:Say(3100,  130 ,"Gerente de Controladoria"      ,oFont10)
oPrint:Say(3150,  130 ,""         ,oFont10)

oPrint:EndPage()// Finaliza a pagina
	
oPrint:Preview()// Visualiza a pagina  	

Return

Static Function fPrintBox(nY1,nX1,nY2,nX2)

	oPrint:Line(   nY1 ,  nX1  ,  nY1 ,  nX2 ) //HORIZONTAL 1
	oPrint:Line(   nY2 ,  nX1  ,  nY2 ,  nX2 ) //HORIZONTAL 2
	oPrint:Line(   nY1 ,  nX1  ,  nY2 ,  nX1 ) //VERTICAL 1
	oPrint:Line(   nY1 ,  nX2  ,  nY2 ,  nX2 ) //VERTICAL 2

Return