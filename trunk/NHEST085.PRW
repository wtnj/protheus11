/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST085        ³ FABIO NICO            ³ Data ³ 18/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas de Recebimento para Identificacao do Produto.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaEst                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"  
#include "colors.ch"
#include "font.ch"

User Function NHEST085()  
LOCAL _data := date()
SetPrvt("cEmbalagem,nQtdeEmb,cCodPro,aEtiq,cPorta,_CODBARRA")

_cCodigo		:= space(15)
_cLote			:= space(10)
_cLocaliz		:= space(10)
_cQuant			:= space(10)
_cDescri		:= Space(30)
_cQuant			:= Space(6)
_cEtiq			:= Space(3)
_cAlmoxa		:= Space(3)
_cUM			:= space(3)
cPorta      := "LPT1"                                     
_CODBARRA = SPACE(15)             


DEFINE FONT oFont NAME "Arial" SIZE 12, -12

@ 000,007 To 400,700 Dialog DlgDadosEmb Title "Impressao de Codigo de Barras"

@ 040,010 Say "Codigo do Produto:" Size 060,8  Object ocCodigo
@ 055,010 Say "Lote.............:" Size 060,8  Object ocCodigo
@ 070,010 Say "Localizacao......:" Size 060,8  Object ocCodigo
@ 085,010 Say "Almoxarifado.....:" Size 060,8  Object ocCodigo
@ 100,010 Say "Quantidade.......:" Size 060,8  Object ocCodigo
@ 115,010 Say "Numero Etiquetas.:" Size 060,8  Object ocCodigo

@ 040,060 Get _cCodigo 	F3 "XX1"  valid ValCodigo() Size 090,8 object oCodigo
oCodigo:Setfont(oFont)
@ 040,150 Get _cDescri 	Size 180,8 When .F. object oDescri
oDescri:Setfont(oFont)
@ 055,060 Get _cLote 	Size 60,8 object oLote
oLote:Setfont(oFont)
@ 070,060 Get _cLocaliz Size 60,8 object oLocaliz
oLocaliz:Setfont(oFont)
@ 085,060 Get _cAlmoxa  Size 60,8 object oAlmoxa
oAlmoxa:Setfont(oFont)
@ 100,060 Get _cQuant 	Size 60,8 object oQuant
oQuant:Setfont(oFont)
@ 115,060 Get _cEtiq 	Size 60,8 object oEtiq
oEtiq:Setfont(oFont)

@ 150,070 BMPBUTTON TYPE 01 ACTION ImpEtiq()
@ 150,100 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()]
Activate Dialog DlgDadosEmb CENTERED

Return()

//---------------------------------------------------------
Static Function fEnd() 
   Close(DlgDadosEmb) 
Return


//---------------------------------------------------------
Static Function ImpEtiq()

If !IsPrinter(cPorta)
	alert("erro na porta")
    Return
Endif

Processa({|| Gerando() },"Gerando Dados para a Impressao")     
   
IF ALLTRIM(TMP->BF_PRODUTO) = ''
	ALERT("DADOS INVALIDOS IMPOSSIVEL GERAR ETIQUETAS")
	DbSelectArea("TMP")
	DbCloseArea()
	return(nil)
endif

for x = 1 to VAL(_cEtiq)
    _totaletiq = val(_cQuant) / val(_cEtiq)                             // TOTAL POR ETIQUETA
	_CODBARRA := ALLTRIM(_cCodigo)+' '+ALLTRIM(_cLote)+' '+ALLTRIM(_cLocaliz)+' '+ALLTRIM(_cAlmoxa)+' '+ALLTRIM(Transform(_totaletiq,"999999")) //  COMPOSICAO DO CODIGO DE BARRAS
              
	_data := stod(TMP->F1_EMISSAO)

	MSCBPRINTER("S600","LPT1",,20,.f.,,,)   // 20= ALTURA DA ETIQUETA
	MSCBCHKSTATUS(.f.)
	MSCBBEGIN(1,4,50)

	MSCBSAY(05,07,TMP->D1_FORNECE,"N","0","025,035")                  
	MSCBSAY(20,07,TMP->D1_LOJA,"N","0","025,035")
	MSCBSAY(30,07,TMP->CLIENTE,"N","0","025,035")                  	
	MSCBSAY(05,12,TMP->B1_DESC,"N","0","025,035")

	MSCBSAY(60,15,"NF:","N","0","015,035")	
	MSCBSAY(70,15,TMP->D1_DOC,"N","0","015,025")
	MSCBSAY(80,15,"-","N","0","015,035")	
	MSCBSAY(85,15,TMP->D1_SERIE,"N","0","015,025")
	MSCBSAY(60,19,"Data:","N","0","015,035")	
	MSCBSAY(70,19,DTOC(STOD(TMP->F1_EMISSAO)),"N","0","015,025")
	
	
	MSCBSAY(05,17,TMP->BF_PRODUTO,"N","0","045,035")                  		
	
	MSCBSAY(05,25,_cLote,"N","0","045,035")                  		
	MSCBSAY(30,25,_cLocaliz,"N","0","045,035")                  		
	MSCBSAY(45,25,_cAlmoxa,"N","0","045,035")                  			
	MSCBSAY(65,25,TRANSFORM(_totaletiq,"9999999"),"N","0","045,035")                  		
	                                                                          
 //   MSCBSAYBAR(04,30,_CODBARRA,"N","3",14,,.T.,,,1,2,,,,)  // MELHOR ATE AGORA
    MSCBSAYBAR(10,30,_CODBARRA,"N","3",14,,.T.,,,1,6,,,,)  // MELHOR ATE AGORA   
    		
	MSCBEND()                                                                 
	MSCBClosePrinter()      
    
next   


DbSelectArea("TMP")
DbCloseArea()
MS_FLUSH()

Return(nil)
         

Static Function Gerando()
cQuery := "SELECT BF_PRODUTO,BF_LOTECTL,BF_QUANT,B1_DESC,BF_LOCALIZ,BF_LOCAL,D1_FORNECE,D1_LOJA,D1_SERIE,D1_DOC,F1_TIPO,F1_EMISSAO, 'CLIENTE' = "
cQuery += "CASE "
cQuery += "WHEN SF1.F1_TIPO = 'N' THEN "
cQuery += "(SELECT A2.A2_NREDUZ "
cQuery += "		FROM SA2NH0 A2 "
cQuery += "    		WHERE A2.D_E_L_E_T_ = ' ' "
cQuery += "		AND A2.A2_COD = SD1.D1_FORNECE "
cQuery += "    		AND A2.A2_LOJA = SD1.D1_LOJA) "
cQuery += "    	ELSE "
cQuery += "     	(SELECT A1.A1_NREDUZ "
cQuery += "     		FROM SA1NH0 A1 "
cQuery += "     		WHERE A1.D_E_L_E_T_ = ' ' "
cQuery += "		AND A1.A1_COD = SD1.D1_FORNECE "
cQuery += "		AND A1.A1_LOJA = SD1.D1_LOJA) "
cQuery += "END "
cQuery += "FROM " + RetSqlName( 'SBF' ) +" SBF, " + RetSqlName( 'SF1' ) +" SF1, " + RetSqlName( 'SB1' ) +" SB1,"+ RetSqlName( 'SD1' ) +" SD1 " 
cQuery += "WHERE SD1.D1_FILIAL = '" + xFilial("SD1")+ "'"
cQuery += "AND SF1.F1_FILIAL = '" + xFilial("SF1")+ "'"
cQuery += "AND SBF.BF_FILIAL = '" + xFilial("SBF")+ "'"
cQuery += "AND SD1.D1_FILIAL = '" + xFilial("SD1")+ "'"
cQuery += "AND SBF.BF_PRODUTO = '" + _cCodigo + "' "
cQuery += "AND SBF.BF_LOTECTL = '" + _cLote + "' "
cQuery += "AND SBF.BF_LOCALIZ = '" + _cLocaliz + "' "
cQuery += "AND SB1.B1_COD = SBF.BF_PRODUTO "
cQuery += "AND SD1.D1_COD = SBF.BF_PRODUTO "
cQuery += "AND SD1.D1_LOTECTL = SBF.BF_LOTECTL "
cQuery += "AND SF1.F1_DOC = SD1.D1_DOC "
cQuery += "AND SF1.F1_FORNECE = SD1.D1_FORNECE "
cQuery += "AND SBF.D_E_L_E_T_ = '' "
cQuery += "AND SB1.D_E_L_E_T_ = '' "
cQuery += "AND SD1.D_E_L_E_T_ = '' "
cQuery += "AND SF1.D_E_L_E_T_ = '' "
//MemoWrit('C:\TEMP\EST085.SQL',cQuery)
//Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"  
	
Return
                                                   
Static Function ValCodigo()

_cLote := SBF->BF_LOTECTL 
_cLocaliz := SBF->BF_LOCALIZ
_cAlmoxa := SBF->BF_LOCAL

SB1->(DbSeek(xFilial("SB1") + _cCodigo))
_cDescri := SB1->B1_DESC



Return