/*                                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHMNT023  ³ Autor ³ João Felipe da Rosa    Data ³ 28/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de Itens enviados para conserto					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP			                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch" 
#INCLUDE "protheus.ch"
//#Include "prtopdef.ch"    

User Function nhmnt023()

//mv_par01 de peca
//mv_par02 até peca
//mv_par03 de data
//mv_par04 ate data 
//mv_par05 pendentes / fechados / ambos
//mv_par06 ordenar por: produto / data envio

SetPrvt("CCADASTRO,AROTINA,_aMat,_cNfRet,_cSerRet,_cDtRet,_cCodBem,_cPeca,_nPc,_nQtdRet")

cQuery    := ""
aHeader   := {}
aCols     := {} 
_aMat     := {}
_cNfRet   := ""
_cSerRet  := ""
_cDtRet   := ""
_nQtdRet  := 0
_cCodBem  := "" 
nOpc      := 0  
oDlg      := Nil   
oLbx      := Nil
_cPeca    := Space(15)
_cPerg    := "MNT023" 
_cPesq    := ""
_cOrdn    := ""
_aOrd     := {"Desc. Peca","Desc. Fornecedor","Data Saida","Data Retorno","NF Saida"}
_cVar	  := Space(30)
_aLocaliz := {"Cod. Peca", "Desc. Peca", "Desc. Fornecedor","NF Saida"} 

Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)

IF !Pergunte(_cPerg,.T.)
	Return
EndIf

Processa({|| Gerando() }, OemToAnsi("Gerando Dados..."))

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+

oDlg := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Controle de Manutencao Externa",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

//DEFINE MSDIALOG oDlg TITLE "Controle de Manutencao Externa" FROM 0,0 TO 480,800 PIXEL

@ 048,aPosObj[2,2] LISTBOX oLbx FIELDS HEADER ;
"Orçamento","Cod.Peca","Descricao","Fornecedor","Estoque","Nome","Tel","Dt Saida","NF Saida","Serie S.",;
"Dt Retorno","NF Retorno","Serie R.","Qtd. Ret.","Nº Pedido","Vlr Pedido","Dt Prv Ret.","Nº SC","Vlr SC","Ord Serv","Cod. Bem" ;
   SIZE aPosObj[2,4],(aPosObj[2,3]-50) OF oDlg PIXEL ON DBLCLICK( u_fDet(oLbx:nAt))//,oDlg:End())

oLbx:SetArray( _aMat )
oLbx:bLine := {|| {_aMat[oLbx:nAt,1],;  // PORCAMENTO
                   _aMat[oLbx:nAt,2],;  // PRODUTO 
                   _aMat[oLbx:nAt,3],;  // DESCRICAO
                   _aMat[oLbx:nAt,4],;  // COD FORNECEDOR
                   _aMat[oLbx:nAt,5],;  // ESTOQUE
                   _aMat[oLbx:nAt,6],;  // NOME FORNECEDOR
                   _aMat[oLbx:nAt,7],;  // TEL FORNECEDOR
                   _aMat[oLbx:nAt,8],;  // DT SAIDA
                   _aMat[oLbx:nAt,9],;  // NF SAIDA
                   _aMat[oLbx:nAt,10],;  // SERIE SAIDA
                   _aMat[oLbx:nAt,11],; // DATA RETORNO
                   _aMat[oLbx:nAt,12],; // NF RETORNO
                   _aMat[oLbx:nAt,13],; // SERIE RETORNO 
                   _aMat[oLbx:nAt,14],; // QUANT RETORNO                   
                   _aMat[oLbx:nAt,15],; // PEDIDO
				   _aMat[oLbx:nAt,16],; // vlr PEDIDO
				   _aMat[oLbx:nAt,17],; // dt prv PEDIDO
                   _aMat[oLbx:nAt,18],; // SC
                   _aMat[oLbx:nAt,19],; // vlr SC
                   _aMat[oLbx:nAt,20],; // ORDEM DE SERVICO
                   _aMat[oLbx:nAt,21],; // COD BEM
                   _aMat[oLbx:nAt,22],; // QUANT
                   _aMat[oLbx:nAt,23],; // CEME
                   _aMat[oLbx:nAt,24],; // SC QUANT
                   _aMat[oLbx:nAt,25],; // ITEM SD2
                   _aMat[oLbx:nAt,26],; // ZFE OBS
                   _aMat[oLbx:nAt,27]}} // LOJA D2
oLbx:Refresh()                   
@ 18,010 SAY OemtoAnsi("Pesquisa Por: ") SIZE 100,008 PIXEL OF oDlg 
@ 18,050 COMBOBOX _cPesq ITEMS _aLocaliz SIZE 55,10 object oTipon
@ 33,010 SAY "Localizar : " SIZE 060,008 PIXEL OF oDlg 
@ 33,050 Get _cPeca  Picture "@!" SIZE 060,008 PIXEL OF oDlg VALID fPesq() 
@ 18,120 SAY OemtoAnsi("Ordenar Por: ") SIZE 100,008 PIXEL OF oDlg
@ 18,160 COMBOBOX _cOrdn ITEMS _aOrd SIZE 55,10 object oCOrd
@ 18,216 BUTTON "_Ir" Size 15,10 Action fOrdem(_cOrdn) object oBtn
@ 18,250 BUTTON "Solic. Compras" Size 60,10 Action MATA110() object oBtn2
@ 18,335 BUTTON "Exp. Excel" Size 60,10 Action MNT23XLS(_aMat) object oBtn3

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||U_fDet(oLbx:nAt),nOpc:=1,,.T.},{||oDlg:End()}) CENTERED

Return 

//+-------------------------------------------------+
//| Seleciona os dados a serem mostrados no listbox |
//+-------------------------------------------------+

Static Function Gerando()

/*
cQuery := "SELECT D2.D2_COD, B1.B1_DESC, D2.D2_CLIENTE, D2.D2_LOJA, A2.A2_NOME, A2.A2_TEL, D2.D2_DOC, "
cQuery += " D2.D2_SERIE, D2.D2_QUANT, D2.D2_TES, D2.D2_EMISSAO, B5.B5_CEME,"
//cQuery += " C1.C1_NUM, C1.C1_ORDSERV, C1.C1_PEDIDO, C1.C1_QUANT, B6.B6_IDENT"
cQuery += " C1.C1_NUM, C1.C1_OS, C1.C1_PEDIDO, C1.C1_QUANT, C1.C1_VUNIT,B6.B6_IDENT, C7.C7_DATPRF, C7.C7_PRECO"
cQuery += " FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SC1")+" C1 LEFT JOIN "+RetSqlName("SC7")+" C7 ON "
cQuery += " C1_PEDIDO=C7_NUM AND C1_ITEMPED=C7_ITEM AND C7.D_E_L_E_T_ = '' C7.C7_FILIAL=C1.C1_FILIAL "	
cQuery += " , "+RetSqlName("SB6")+" B6, "
cQuery += RetSqlName("SB1")+" B1, "+RetSqlName("SA2")+" A2 ,"+RetSqlName("SB5")+" B5 "
//cQuery += " WHERE D2.D2_TP = 'MM'"
cQuery += " WHERE B1.B1_COD = D2.D2_COD" 
cQuery += " AND B1.B1_COD = B5.B5_COD"
cQuery += " AND D2.D2_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND D2.D2_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
cQuery += " AND D2.D2_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQuery += " AND D2.D2_LOJA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
cQuery += " AND D2.D2_TES = '552'"
cQuery += " AND A2.A2_COD = D2.D2_CLIENTE AND A2.A2_LOJA = D2.D2_LOJA"
cQuery += " AND D2.D2_DOC = B6.B6_DOC"
cQuery += " AND D2.D2_SERIE = B6.B6_SERIE"
cQuery += " AND D2.D2_COD = B6.B6_PRODUTO"
cQuery += " AND D2.D2_QUANT = B6.B6_QUANT"
cQuery += " AND D2.D_E_L_E_T_ = ' ' AND D2.D2_FILIAL = '"+XFilial("SD2")+"'"
cQuery += " AND B6.D_E_L_E_T_ = ' ' AND B6.B6_FILIAL = '"+XFilial("SB6")+"'"
cQuery += " AND C1.D_E_L_E_T_ = ' ' AND C1.C1_FILIAL = '"+XFilial("SC1")+"'"
cQuery += " AND B5.D_E_L_E_T_ = ' ' AND B5.B5_FILIAL = '"+XFilial("SB5")+"'"
cQuery += " AND D2.D2_DOC *= C1.C1_NFSAIDA "
cQuery += " AND D2.D2_SERIE *= C1.C1_SERSAI "
cQuery += " GROUP BY D2.D2_COD, D2.D2_DOC, D2.D2_SERIE, D2.D2_QUANT, D2.D2_TES, D2.D2_EMISSAO, B1.B1_DESC, B5.B5_CEME,"
//cQuery += " C1.C1_NUM,B6.B6_IDENT, C1.C1_ORDSERV,D2.D2_CLIENTE, D2.D2_LOJA, A2.A2_NOME, A2.A2_TEL, D2.D2_DOC,C1.C1_PEDIDO, C1.C1_QUANT"
cQuery += " C1.C1_NUM,B6.B6_IDENT, C1.C1_OS,D2.D2_CLIENTE, D2.D2_LOJA, A2.A2_NOME, A2.A2_TEL, D2.D2_DOC,C1.C1_PEDIDO, C1.C1_QUANT"
If mv_par06 == 1 
	cQuery += " ORDER BY D2.D2_COD"
ElseIf mv_par06 == 2
	cQuery += " ORDER BY D2.D2_EMISSAO"
EndIf
*/

cQuery := "SELECT D2.D2_COD, B1.B1_DESC, D2.D2_CLIENTE, D2.D2_LOJA, D2.D2_ITEM, A2.A2_NOME, A2.A2_TEL, D2.D2_DOC,  D2.D2_SERIE, D2.D2_QUANT, "
cQuery += " D2.D2_TES, D2.D2_EMISSAO, B5.B5_CEME, C1.C1_NUM, C1.C1_OS, C1.C1_PEDIDO, C1.C1_QUANT, C1.C1_VUNIT,B6.B6_IDENT, "
cQuery += " C7.C7_DATPRF, C7.C7_PRECO "
cQuery += " FROM "+RetSqlName("SD2")+" D2 LEFT JOIN "+RetSqlName("SC1")+" C1 ON "
cQuery += " D2.D2_DOC = C1.C1_NFSAIDA  AND D2.D2_SERIE = C1.C1_SERSAI AND D2.D2_COD = C1.C1_PRODUTO "
cQuery += " AND C1.D_E_L_E_T_ = ' ' AND C1.C1_FILIAL = '"+XFilial("SC1")+"' "
cQuery += " LEFT JOIN "+RetSqlName("SC7")+" C7 ON  C1_PEDIDO=C7_NUM AND C1_ITEMPED=C7_ITEM AND C7.D_E_L_E_T_ = '' and C7.C7_FILIAL=C1.C1_FILIAL "  
//cQuery += " LEFT JOIN "+RetSqlName("ZFE")+" ZFE ON D2.D2_DOC = ZFE.ZFE_DOC AND D2.D2_SERIE=ZFE.ZFE_SERI AND D2.D2_CLIENTE=ZFE.ZFE_CLIE AND "
//cQuery += " D2.D2_LOJA=ZFE.ZFE_LOJA AND D2.D2_ITEM= ZFE.ZFE_ITEM AND ZFE.ZFE_FILIAL = D2.D2_FILIAL and ZFE.D_E_L_E_T_ = ''"
cQuery += ", "+RetSqlName("SB6")+" B6, "+RetSqlName("SB1")+" B1, "+RetSqlName("SA2")+" A2 ,"+RetSqlName("SB5")+" B5 "
cQuery += " WHERE B1.B1_COD = D2.D2_COD AND B1.B1_COD = B5.B5_COD AND D2.D2_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += " AND D2.D2_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' AND D2.D2_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
cQuery += " D2.D2_LOJA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' AND D2.D2_TES = '552' AND A2.A2_COD = D2.D2_CLIENTE AND A2.A2_LOJA = D2.D2_LOJA "
cQuery += " AND D2.D2_DOC = B6.B6_DOC AND D2.D2_SERIE = B6.B6_SERIE AND D2.D2_CLIENTE = B6.B6_CLIFOR AND D2.D2_LOJA=B6.B6_LOJA "
cQuery += " AND D2.D2_COD = B6.B6_PRODUTO AND D2.D2_QUANT = B6.B6_QUANT AND D2.D2_NUMSEQ = B6.B6_IDENT " 
cQuery += " AND D2.D_E_L_E_T_ = ' ' AND D2.D2_FILIAL = '"+XFilial("SD2")+"'"
cQuery += " AND B6.D_E_L_E_T_ = ' ' AND B6.B6_FILIAL = '"+XFilial("SB6")+"'"
cQuery += " AND B5.D_E_L_E_T_ = ' ' AND B5.B5_FILIAL = '"+XFilial("SB5")+"'"
cQuery += " AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = '"+XFilial("SB1")+"'"

/*
cQuery += " GROUP BY D2.D2_COD, D2.D2_DOC, D2.D2_SERIE, D2.D2_QUANT, D2.D2_TES, "
cQuery += " D2.D2_EMISSAO, B1.B1_DESC, B5.B5_CEME, C1.C1_NUM,B6.B6_IDENT, C1.C1_VUNIT,C7.C7_DATPRF, C7.C7_PRECO, "
cQuery += " C1.C1_OS,D2.D2_CLIENTE, D2.D2_LOJA, A2.A2_NOME, A2.A2_TEL, D2.D2_DOC,C1.C1_PEDIDO, C1.C1_QUANT, D2.D2_ITEM  "
*/

If mv_par06 == 1 
	cQuery += " ORDER BY D2.D2_COD"
ElseIf mv_par06 == 2
	cQuery += " ORDER BY D2.D2_EMISSAO"
EndIf

TCQUERY cQuery NEW ALIAS "TRA1"
MemoWrit('C:/TEMP/NHMNT023.SQL',cQuery)

SB6->(DbSetOrder(3)) //filial + ident + produto + poder3
STJ->(DbSetOrder(1)) //filial + ordem + plano + tipo
ZFE->(dbsetorder(2)) //fil + doc + ser + cli + loj + item

ProcRegua(RecCount("TRA1"))

While TRA1->(!EoF())   
	
	IncProc(TRA1->D2_COD)
	SB6->(DbSeek(xFilial("SB6")+TRA1->B6_IDENT+TRA1->D2_COD+"D")) //verifica se existe a devolucao
	If SB6->(Found()) //Se existe adiciona os dados nas variaveis
		_cNfRet  := SB6->B6_DOC
		_cSerRet := SB6->B6_SERIE	
		_cDtRet	 := DtoC(SB6->B6_EMISSAO)
		_nQtdRet := SB6->B6_QUANT
		
	Else //senao nao adiciona nada
		_cNfRet   := ""
		_cSerRet  := ""
		_cDtRet   := ""
		_nQtdRet  := 0
	EndIf              
	
//	STJ->(DbSeek(xFilial("STJ")+TRA1->C1_ORDSERV))	//verifica o codigo do bem em cima do numero da ordem, quando tem SC
	STJ->(DbSeek(xFilial("STJ")+TRA1->C1_OS))	//verifica o codigo do bem em cima do numero da ordem, quando tem SC
	If STJ->(Found())
		_cCodBem := STJ->TJ_CODBEM
	Else
	    _cCodBem := ""
	EndIf	
	    
    SB2->(DbSetOrder(1)) //FILIAL + COD
    If SB2->(DbSeek(xFilial("SB2")+TRA1->D2_COD))
    	_nEstq := SB2->B2_QATU
    EndIf


	If (mv_par05 == 1 .AND. _cNFRet == "") .OR. (mv_par05 == 2 .AND. _cNFRet != "") .OR. mv_par05==3
		
		cNumOrc1 := space(20)
		cZFEObs1 := ''
	
		If ZFE->(dbseek(xFilial("ZFE")+TRA1->D2_DOC+ TRA1->D2_SERIE+TRA1->D2_CLIENTE+TRA1->D2_LOJA+TRA1->D2_ITEM))
			cNumOrc1 := ZFE->ZFE_NUMORC
			cZFEObs1 := ZFE->ZFE_OBS                                                                              
		Endif
	
		Aadd(_aMat,{cNumOrc1,TRA1->D2_COD, TRA1->B1_DESC, TRA1->D2_CLIENTE, Transform(_nEstq,"@e 99999"), TRA1->A2_NOME, TRA1->A2_TEL,;
		            DtoC(StoD(TRA1->D2_EMISSAO)), TRA1->D2_DOC, TRA1->D2_SERIE, _cDtRet, _cNFRet, _cSerRet,_nQtdRet,;
		            TRA1->C1_PEDIDO,TRA1->C7_PRECO, DtoC(StoD(TRA1->C7_DATPRF)), TRA1->C1_NUM, TRA1->C1_VUNIT,TRA1->C1_OS,;
		             _cCodBem, TRA1->D2_QUANT, TRA1->B5_CEME, TRA1->C1_QUANT,TRA1->D2_ITEM, cZFEObs1, TRA1->D2_LOJA})
	EndIf
		
	TRA1->(DbSkip())

EndDo

TRA1->(DBCLOSEAREA())

// Se o select não retornar valor adiciona um vetor vazio para não dar erro.
If Empty(_aMat)
	aAdd(_aMat,{"","","","","","","","","","","","","","","","","","","","","","","","","","",""})
EndIf

Return

//+-------------------------------------------------+
//| Mostra os detalhes de cada item do listbox      |
//+-------------------------------------------------+

User Function fDet(oItem)

Local _cForn
Local nLin := 60
Private oDlg2
Private cNumOrc := _aMat[oItem][1]
Private cZFEObs := _aMat[oItem][26]

DEFINE MSDIALOG oDlg2 TITLE "Detalhes da Manutencao Externa" FROM 0,0 TO 390,605 PIXEL

	@ nLin-55,010 Say OemtoAnsi("Orçamento: ") Size 080,8 OBJECT oLNUMORC
	oGet1 := tGet():New(nLin-55,050,{|u| if(Pcount() > 0, cNumOrc := u,cNumOrc)},oDlg2,40,8,PesqPict("ZFE","ZFE_NUMORC"),{||.T.},;
		,,,,,.T.,,,{||.T.},,,,,,,"cNumOrc")

	@ nLin-40,010 Say OemtoAnsi("Observação: ") Size 040,8 OBJECT oLOBS
	oMemo1 := tMultiget():New(nLin-40,50,{|u|if(Pcount()>0,cZFEObs:=u,cZFEObs)},;
		oDlg2,250,40,,,,,,.T.,,,{||.T.}) 

	@ nLin,005 To nLin+25,300 Title " Material " 
	@ nLin+5,015 Say OemtoAnsi("Peça: ") Size 040,8 OBJECT oLPeca
	@ nLin+5,050 Say ALLTRIM(_aMat[oItem][2])+" - "+_aMat[oItem][3] Size 240,8 Object oPeca//peça + descricao
	@ nLin+15,015 Say OemtoAnsi("Complemento: ") Size 040,8 OBJECT oLCompl
	@ nLin+15,050 Say ALLTRIM(_aMat[oItem][23]) Size 240,8 Object oCompl//peça + descricao

	@ nLin+30,005 To nLin+55,300 Title " Destino " 
	@ nLin+35,015 Say OemtoAnsi("Fornecedor: ") Size 040,8 Object oLForn
    @ nLin+35,050 Say ALLTRIM(_aMat[oItem][4])+" - "+_aMat[oItem][5]+" - "+_aMat[oItem][6] Size 200,8 Object oData
    @ nLin+45,015 Say OemToAnsi("Telefone: ") Size 040,8 Object oLTel
    @ nLin+45,050 Say _aMat[oItem][7] Size 200,8 Object oData    

	@ nLin+60,005 To nLin+85,148 Title " Envio " 
	@ nLin+65,015 Say OemtoAnsi("NF: ") Size 040,8 Object oLNFS
	@ nLin+65,050 Say _aMat[oItem][9]+" - "+_aMat[oItem][10] Size 040,8 Object oNFS//nf saida + Serie
    @ nLin+65,110 Say OemtoAnsi("Qtde: ") Size 040,8 Object oLQtde
    @ nLin+65,125 Say _aMat[oItem][22] Size 040,8 Object oQtde
    @ nLin+75,015 Say OemtoAnsi("Data: ") Size 040,8 Object oLData
    @ nLin+75,050 Say _aMat[oItem][8] Size 040,8 Object oData

	@ nLin+60,152 To nLin+85,300 Title OemToAnsi(" Retorno ")
	@ nLin+65,160 Say OemtoAnsi("NF: ") Size 040,8 Object oLNFS2
	@ nLin+65,195 Say _aMat[oItem][12]+" - "+_aMat[oItem][13] Size 040,8 Object oNFS2//nf retorno + Serie
    @ nLin+65,255 Say OemtoAnsi("Qtde: ") Size 040,8 Object oLQtdeR
    @ nLin+65,270 Say _aMat[oItem][14] Size 040,8 Object oQtdeR
    @ nLin+75,160 Say OemtoAnsi("Data: ") Size 040,8 Object oLData2
    @ nLin+75,195 Say _aMat[oItem][11] Size 040,8 Object oData2

	@ nLin+90,005 To nLin+115,148 Title OemToAnsi(" Compras ")
    @ nLin+95,015 Say OemtoAnsi("SC: ") Size 040,8 Object oLSC2
    @ nLin+95,050 Say _aMat[oItem][18] Size 040,8 Object oSC2
    @ nLin+95,110 Say OemToAnsi("Qtde: ") Size 040,8 Object oLScQ
	@ nLin+95,125 Say _aMat[oItem][24] Size 040,8 Object oQtdeSC    
    @ nLin+105,015 Say OemtoAnsi("Pedido: ") Size 040,8 Object oLPed2
    @ nLin+105,050 Say _aMat[oItem][15] Size 040,8 Object oPed2

	@ nLin+90,152 To nLin+115,300 Title OemToAnsi(" Ordem de Serviço ")
	@ nLin+95,160 Say OemtoAnsi("OS: ") Size 40,8 Object oLOS
	@ nLin+95,195 Say _aMat[oItem][20] Size 40,8 Object oOS
	@ nLin+105,160 Say OemtoAnsi("Bem: ") Size 40,8 Object oLBem
	@ nLin+105,195 Say _aMat[oItem][21] Size 60,8 Object oBem

//	@ 015,055 Get Forn Picture "@!" F3 "SA2" When(_cPar == 2) Size 40,8 Valid fForn()
	@ nLin+120,260 BUTTON "_Gravar"   Size 40,12 ACTION fGrvZFE(oItem) object oBtn1
	@ nLin+120,210 BUTTON "_Imprimir" Size 40,12 Action {fIMPMNT23(oItem),Close(oDlg2)} object oBtn2

	ACTIVATE MSDIALOG oDlg2 CENTER

Return

Static Function  fGrvZFE(oItem)

	ZFE->(dbsetorder(2)) //fil + doc + ser + cli + loj + item
	
	If Empty(cNumOrc) .and. Empty(cZFEObs)
	 	return	
	Endif
	
	If ZFE->(dbseek(xFilial("ZFE")+_aMat[oItem][9]+_aMat[oItem][10]+_aMat[oItem][4]+_aMat[oItem][5]+_aMat[oItem][25]))
	
		reclock("ZFE",.F.)
			ZFE->ZFE_NUMORC := cNumOrc
			ZFE->ZFE_OBS    := cZFEObs
		Msunlock("ZFE")
		
	ELSE
	
		reclock("ZFE",.T.)
			ZFE->ZFE_FILIAL := xFilial("ZFE")
			ZFE->ZFE_DOC    := _aMat[oItem][9]
			ZFE->ZFE_SERI   := _aMat[oItem][10]
			ZFE->ZFE_CLIE   := _aMat[oItem][4]
			ZFE->ZFE_LOJA   := _aMat[oItem][27]
			ZFE->ZFE_ITEM   := _aMat[oItem][25]
			ZFE->ZFE_NUMORC := cNumOrc
			ZFE->ZFE_OBS    := cZFEObs
		Msunlock("ZFE")
		
		_aMat[oItem][26] := cZFEObs
		_aMat[oItem][1]  := cNumOrc
		
		fReset()
		
		oLbx:Refresh(.F.)  //atualiza a matriz para mostrar em tela

	Endif

	Close(oDlg2)
Return

Static Function fPesq()
Local _nPc := 0
	If _cPesq == "Cod. Peca"
	    aSort(_aMat,,,{|x,y| x[2]+x[11]+x[9] > y[2]+y[11]+y[9]}) //ordena a matriz por peça, DT RETORNO, NF
	    _nPc := Ascan(_aMat,{|x| AllTrim(_cPeca) == Substr(x[2],1,len(ALLTRIM(_cPeca))) }) //localiza a peca na matriz por codigo
    ElseIf _cPesq == "Desc. Peca"
	    aSort(_aMat,,,{|x,y| x[3]+x[11]+x[9] > y[3]+y[11]+y[9]}) //ordena a matriz por DESC PEÇA, DT RETORNO, NF
	    _nPc := Ascan(_aMat,{|x| AllTrim(_cPeca) == substr(x[3],1,len(ALLTRIM(_cPeca))) }) //localiza a peca na matriz por descricao
	ElseIf _cPesq == "Desc. Fornecedor"
	    aSort(_aMat,,,{|x,y| x[6]+x[11]+x[9] > y[6]+y[11]+y[9]}) //ordena a matriz por DESC FORN., DT RETORNO, NF
		_nPc := Ascan(_aMat,{|x| AllTrim(_cPeca) == Substr(x[6],1,len(ALLTRIM(_cPeca))) }) //localiza a peca na matriz por desc. fornecedor
	ElseIf _cPesq == "NF Saida"
	    aSort(_aMat,,,{|x,y| x[9]+x[11]+x[6] > y[9]+y[11]+y[6]}) //ordena a matriz por NF, DT RETORNO, DESC FORN.
		_nPc := Ascan(_aMat,{|x| AllTrim(_cPeca) == Substr(x[9],1,len(ALLTRIM(_cPeca))) }) //localiza a peca na matriz por desc. fornecedor
	EndIf

	fReset()	                   
	
	If _nPc <> 0
		oLbx:nAt := _nPc //posiciona o registro na matriz
		oLbx:Refresh(.F.)  //atualiza a matriz para mostrar em tela
	EndIf

Return(.T.)

Static function fReset()
    oLbx:Reset()
    oLbx:SetArray( _aMat )
    oLbx:bLine := {|| {_aMat[oLbx:nAt,1],;  // orcamento 
    				   _aMat[oLbx:nAt,2],;  // PRODUTO 
	                   _aMat[oLbx:nAt,3],;  // DESCRICAO
	                   _aMat[oLbx:nAt,4],;  // COD FORNECEDOR
	                   _aMat[oLbx:nAt,5],;  // ESTOQUE
	                   _aMat[oLbx:nAt,6],;  // NOME FORNECEDOR
	                   _aMat[oLbx:nAt,7],;  // TEL FORNECEDOR
	                   _aMat[oLbx:nAt,8],;  // DT SAIDA
	                   _aMat[oLbx:nAt,9],;  // NF SAIDA
	                   _aMat[oLbx:nAt,10],;  // SERIE SAIDA
	                   _aMat[oLbx:nAt,11],; // DATA RETORNO
	                   _aMat[oLbx:nAt,12],; // NF RETORNO
	                   _aMat[oLbx:nAt,13],; // SERIE RETORNO                   
		  			   _aMat[oLbx:nAt,14],; // QUANT RETORNO
	                   _aMat[oLbx:nAt,15],; // PEDIDO
					   _aMat[oLbx:nAt,16],; // vlr PEDIDO
					   _aMat[oLbx:nAt,17],; // dt prv PEDIDO
	                   _aMat[oLbx:nAt,18],; // SC
	                   _aMat[oLbx:nAt,19],; // vlr SC
	                   _aMat[oLbx:nAt,20],; // ORDEM DE SERVICO
	                   _aMat[oLbx:nAt,21],; // COD BEM
	                   _aMat[oLbx:nAt,22],; // QUANT
	                   _aMat[oLbx:nAt,23],; // CEME
	                   _aMat[oLbx:nAt,24],; // SC QUANT
	                   _aMat[oLbx:nAt,25],; // ITEM SD2
    	               _aMat[oLbx:nAt,26],; // ZFE OBS
	                   _aMat[oLbx:nAt,27]}} // LOJA D2

Return

Static Function fOrdem(_cOr)
	
	If _cOr == "Desc. Peca"
	    aSort(_aMat,,,{|x,y| x[3] < y[3]}) //ordena a matriz por Peca	
	ElseIf _cOr == "Desc. Fornecedor"
	    aSort(_aMat,,,{|x,y| x[6] < y[6]}) //ordena a matriz por Desc Fornecedor
	ElseIf _cOr == "Data Envio"
	    aSort(_aMat,,,{|x,y| DtoS(CtoD(x[8])) + x[9] < DtoS(CtoD(y[8])) + y[9]}) //ordena a matriz por DT ENVIO
    ElseIf _cOr == "Data Saida"
	    aSort(_aMat,,,{|x,y| DtoS(CtoD(x[11])) + x[9] < DtoS(CtoD(y[11])) + y[9]}) //ordena a matriz por DT RETORNO
	ElseIf _cOr == "NF Saida"
	    aSort(_aMat,,,{|x,y| x[9] + x[11] < y[9] +y[11]}) //ordena a matriz por NF
	EndIf
	
	fReset()
	
	oLbx:Refresh(.F.)  //atualiza a matriz para mostrar em tela]
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ fIMPMNT23   ºAutor ³João Felipe        º Data ³  03/06/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESSAO DA CONSULTA DE ITENS EM MANUTENCAO EXTERNA       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fIMPMNT23(oItm)

nItem     := oItm
cString   := "QM2"
cDesc1    := OemToAnsi("Este   relatório   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("um ítem que está em conserto.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQMT006"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("ÍTEM EM MANUTENÇÃO EXTERNA")
cabec1    := " "
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT023"
_cPerg    := "" 
 
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()

	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

	@Prow()+1, 001 Psay OemToAnsi("Peça:         ")+ ALLTRIM(_aMat[nItem ,2])+" - "+_aMat[nItem,3]  // PEÇA + DESCRICAO
	@Prow()+1, 001 Psay OemToAnsi("Complemento:  ")+ _aMat[nItem,20]  // CEME (COMPLEMENTO)
    @Prow()+1, 001 Psay OemToansi("Fornecedor:   ")+ _aMat[nItem,4]+" - "+_aMat[nItem,6]  // COD FORNECEDOR 
    @Prow()+1, 001 Psay OemToansi("Telefone:     ")+ SUBSTR(_aMat[nItem,7],1,30)  // TEL FORNECEDOR
    @Prow()  , 080 Psay OemToansi("Qtd. Estoque: ")+ _aMat[nItem,5]  // ESTOQUE
    @Prow()+2, 001 Psay OemToansi("Dt. Saída:    ")+_aMat[nItem,8]  // DT SAIDA
	@Prow()  , 030 Psay OemToansi("NF/Série Saída:   ")+_aMat[nItem,9]+" - "+_aMat[nItem,10]  // NF SAIDA + SÉRIE
    @Prow()  , 080 Psay OemToansi("Qtd. NF:      ")+TRANSFORM(_aMat[nItem,22],"@e 999") // QUANTIDADE
    @Prow()+1, 001 Psay OemToansi("Dt. Retorno:  ")+_aMat[nItem,11] // DATA RETORNO
	@Prow()  , 030 Psay OemToansi("NF/Série Retorno: ")+_aMat[nItem,12]+" - "+_aMat[nItem,13] // NF + SERIE RETORNO
    @Prow()  , 080 Psay OemToansi("Qtd. Retorno: ")+TRANSFORM(_aMat[nItem,14],"@E 999")  // QUANT RETORNO
    @Prow()+1, 001 Psay OemToansi("OS:           ")+_aMat[nItem,20] // ORDEM DE SERVICO
    @Prow()  , 030 Psay OemToansi("Pedido : ")+_aMat[nItem,15] // PEDIDO
    @Prow()  , 050 Psay OemToansi("SC: ")+_aMat[nItem,18] // SC
    @Prow()  , 080 Psay OemToAnsi("Qtd. SC:      ")+TRANSFORM(_aMat[nItem,24],"@E 999") //SC QUANT
    @Prow()+1, 001 Psay OemToansi("Cod. Bem:     ")+_aMat[nItem,21] // COD BEM


@ Prow()+1,000 PSAY __PrtThinLine()

Return(nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXPORTA PARA EXCEL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static function MNT23XLS(_aMat)
Local cExcel, _nOutFile 
Local _cLocal := Space(100)
Local _lRet   := .F.

	//define a tela
	oDlg2 := MSDialog():New(0,0,120,310,"Local do Arquivo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
	//contorno
	oGroup := tGroup():New(005,005,40,153,,oDlg2,,,.T.)
		
	oSay4 := TSay():New(20,10,{||"Local"},oDlg2,,,,,,.T.,,)
	
	oGet1 := tGet():New(18,30,{|u| if(Pcount() > 0, _cLocal:= u,_cLocal)},oDlg2,118,8,"@!",/*valid*/,;
		,,,,,.T.,,,/* when */,,,,,,,"_cLocal")
    
	//botoes
    oBt1 := tButton():New(45,88,"Ok",oDlg2,{||oDlg2:End()},30,10,,,,.T.)      
    oBt2 := tButton():New(45,123,"Cancelar",oDlg2,{||_lRet:=.T.,oDlg2:End()},30,10,,,,.T.)

	oDlg2:Activate(,,,.T.,{||,.T.},,{||})

	If _lRet 
		Return
	EndIf	
	
	_cLocal := Alltrim(_cLocal)
	
	If !Right(_cLocal,1)$"\"
		_cLocal += "\"
	EndIf

	_nOutFile := Fcreate(_cLocal+"nhmnt023.xls",0)
	
	If !File(_cLocal+"nhmnt023.xls")
		Alert("Arquivo não pode ser criado. Escolha outro local!")
		Return
	EndIf

	cExcel := '<html>'
	cExcel += '<head></head>'
	cExcel += '<body>'
	cExcel += '<table border="1">'
	
	//Cabecalho
	cExcel += '<tr style="background:#aabbcc">'
	cExcel += '<td>Orçamento</td>'
	cExcel += '<td>Cod.Peca</td>'
	cExcel += '<td>Descricao</td>'
	cExcel += '<td>Fornecedor</td>'
	cExcel += '<td>Estoque</td>'
	cExcel += '<td>Nome</td>'
	cExcel += '<td>Tel</td>'
	cExcel += '<td>Dt Saida</td>'
	cExcel += '<td>NF Saida</td>'
	cExcel += '<td>Serie S</td>'
	cExcel += '<td>Dt Retorno</td>'
	cExcel += '<td>NF Retorno</td>'
	cExcel += '<td>Serie R.</td>'
	cExcel += '<td>Qtd. Ret.</td>'
	cExcel += '<td>Nº Pedido</td>'
	cExcel += '<td>Vlr Pedido</td>'
	cExcel += '<td>Dat Prv Ret.</td>'
	cExcel += '<td>Nº SC</td>'
	cExcel += '<td>Vlr SC</td>'	
	cExcel += '<td>Ord Serv</td>'
	cExcel += '<td>Cod. Bem</td>'
	cExcel += '<td>Qtd. NF</td>'
	cExcel += '<td>Complemento</td>'
	cExcel += '<td>Qtd. SC</td>'
	cExcel += '</tr>'
	
	For _x := 1 to Len(_aMat)
		cExcel += '<tr>'
		
		For _y := 1 to Len(_aMat[_x])
			If ValType(_aMat[_x][_y]) == "C"
				cExcel += '<td>'+_aMat[_x][_y]+'</td>'
			ElseIf ValType(_aMat[_x][_y]) == "N"
				cExcel += '<td>'+Str(_aMat[_x][_y])+'</td>'
			Else
				cExcel += '<td></td>'
			EndIf
		Next
		
		cExcel += '</tr>'
	Next
	
	Fwrite(_nOutFile,cExcel)

	Fclose(_nOutFile)
   
	//Abre a página da ficha técnica
	ShellExecute( "open", "excel.exe",_cLocal+"NHMNT023.xls","",5 )
        
Return
