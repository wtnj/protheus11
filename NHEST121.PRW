#include "rwmake.ch"
#include "Topconn.ch" 
#include "font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST121        ³ João Felipe da Rosa   ³ Data ³ 04.07.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Browse para RMR's gravadas							     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST121()  

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Relação Mensal de Refugo")
aRotina := {{ "Pesquisa"     ,"AxPesqui"     ,0,1},;
            { "Visualizacao" ,'U_EST121(1)'  ,0,2},;
            { "Exclui"       ,'U_EST121(2)'  ,0,4},;       
            { "Imprimir"     ,'U_ImpRMR()'   ,0,5}}
            
mBrowse(6,1,22,75,"ZAB",,,,,,) 

Return     

/*******************
* FUNCAO PRINCIPAL *
*******************/

User Function EST121(_cParam)

//Define as variáveis da rotina
aHeader := {}
aCols   := {}
_cPar   := _cParam
_cPeca  := ZAB->ZAB_COD
_cDesc  := ""    

//busca descricao da peça
DbSelectArea("SB1")
DbSetOrder(1) // filial + cod
If DbSeek(xFilial("SB1")+_cPeca)
	_cDesc := SB1->B1_DESC
Else
	MsgAlert(OemToAnsi("Esta peça não existe no cadastro. Verifique!"))
	Return .F.
EndIf

_cMes   := UPPER(OemToAnsi(MesExtenso(Substr(ZAB->ZAB_MESANO,1,2)))) + " / " + Substr(ZAB->ZAB_MESANO,5,2)
_nQtdeU := 0 //quantidade usinado
_nQtdeF := 0 //quantidade fundido
_cForn  := ZAB->ZAB_FORNEC
_cLoja  := ZAB->ZAB_LOJA
_cFDesc := ""

//busca a descricao do fornecedor
DbSelectArea("SA1")
DbSetOrder(1) //filial + cod + loja
If DbSeek(xFilial("SA1")+_cForn+_cLoja)
	_cFDesc := SA1->A1_NOME
Else
	MsgAlert(OemToAnsi("Este fornecedor não existe no cadastro. Verifique!"))
EndIf

//Constroi o aHeader
Aadd(aHeader,{"Item"         , "ZAC_ITEM"	,"@!"        , 4,0,".F.","","C","ZAC"}) 
Aadd(aHeader,{"Local"      	 , "ZAC_LOCAL"	,"@!"        , 2,0,".F.","","C","ZAC"}) 
Aadd(aHeader,{"Operacao"     , "ZAC_OPERAC"	,"@!"	 	 , 3,0,".F.","","C","ZAC"})
Aadd(aHeader,{"Quantidade" 	 , "ZAC_QUANT" 	,"999999999" , 9,0,".F.","","N","ZAC"})

//Define as fontes da rotina
DEFINE FONT oFont NAME "Arial" SIZE 12, -12
                 
//Inicializa acols com os ítens da RMR (ZAC)
DbSelectArea("ZAC")
DbSetOrder(1) // filial + num + item
If DbSeek(xFilial("ZAC")+ZAB->ZAB_NUM+"0001")
	While ZAC->ZAC_NUM == ZAB->ZAB_NUM
		aAdd(aCols,{ZAC->ZAC_ITEM,ZAC->ZAC_LOCAL,ZAC->ZAC_OPERAC,ZAC->ZAC_QUANT,.F.})

		//incrementa as quantidades de usinado e fundido
		If ZAC->ZAC_LOCAL$"00"
			_nQtdeF += ZAC->ZAC_QUANT
		Else
			If ZAC->ZAC_LOCAL$"99"
				_nQtdeU += ZAC->ZAC_QUANT			
			EndIf
		EndIf
		
		DbSkip()
	EndDo
Else
	MsgAlert(OemToAnsi("Não foram encontrados Ítens para esta RMR."))
EndIf

//Constrói a tela 
Define MsDialog oDialog Title OemToAnsi("Relação Mensal de Refugo") From 020,030 To 385,636 Pixel 
@ 005,005 To 55,300 Title OemToAnsi(" Dados da RMR")

@ 020,020 Say OemToAnsi("Número: ") Size 30,8 Object olNum
@ 020,045 Say ZAB->ZAB_NUM Size 35,8 Object oNum
oNum:Setfont(oFont)
@ 020,090 Say OemToAnsi("Peça: ") Size 40,8 Object olPeca
@ 020,110 Get _cPeca When .F. Size 50,8 Object oPeca
@ 020,165 Get _cDesc When .F. Size 120,8 Object oDesc
@ 035,020 Say OemToAnsi("Mês: ") Size 20,8 Object olMes
@ 035,040 Say _cMes Size 40,8 Object oMes
@ 035,075 Say "Fornecedor:" Size 040,8 Object olForn
@ 035,110 Get _cForn When .F. Size 30,8 Object oForn
@ 035,145 Get _cFDesc When .F. Size 120,8 Object oFDesc  

@ 060,155 To 160,300 Title OemToAnsi(" Totais ")
@ 075,160 Say "Usinado: " Size 040,8 Object olUsin
@ 075,190 Say _nQtdeU Size 040,8 Object oUsin
@ 090,160 Say "Fundido: " Size 040,8 Object olFund
@ 090,190 Say _nQtdeF Size 040,8 Object oFund
@ 105,160 Say "Produzido: " Size 040,8 Object olProd
@ 105,190 Say ZAB->ZAB_QUANT Size 040,8 Object oProd
oProd:Setfont(oFont)

@ 060,005 To 160,150 Title OemToAnsi(" Itens da RMR ")
@ 070,005 TO 155,149 MULTILINE MODIFY DELETE OBJECT oMultiline
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline

@ 165,270 BMPBUTTON TYPE 01 ACTION fOk()

Activate MsDialog oDialog Center 

Return

Static Function fOk()
	
	If _cPar == 2 //Exclui
		If MsgYesNo("Tem certeza que deseja excluir esta RMR?")

			//Exclui RMR de ZAB
			RecLock("ZAB",.F.)
				ZAB->(DbDelete())
			MsUnlock("ZAB")

            //Exclui itens da RMR de ZAC
			DbSelectArea("ZAC")
			DbSetOrder(1) // filial + num + item
			If DbSeek(xFilial("ZAC")+ZAB->ZAB_NUM+"0001")
				While ZAC->ZAC_NUM == ZAB->ZAB_NUM
					RecLock("ZAC",.F.)
							ZAC->(DbDelete())
					MsUnlock("ZAC")
					DbSkip()
				EndDo
			EndIf

		EndIf
	EndIf

	Close(oDialog)

Return

User Function ImpRMR()
	
	//Variáveis padrões do relatório
	cDesc1  := OemToAnsi("Este relatorio tem como objetivo Imprimir o ")
	cDesc2  := OemToAnsi("Relatorio Mensal de Refugo")
	cDesc3  := OemToAnsi(" ")
	Titulo  := OemToAnsi("RELATÓRIO MENSAL DE REFUGO")
	aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
	M_PAG   := 1
	Cabec1  := ""
	Cabec2  := ""
	wnrel   := "NHEST121"
	
	//Variáveis da rotina
	_num    := 0
	_cDesen := ""
	_cMes   := UPPER(OemToAnsi(MesExtenso(Substr(ZAB->ZAB_MESANO,1,2)))) + " / " + Substr(ZAB->ZAB_MESANO,5,2)	
	_nTotRF := 0  //total de refugo fundido
	_nTotRU := 0  //total de refugo usinado
	
	pergunte("",.F.)
	
	SetPrint("ZAB",wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.T.,"",,"M") 
	//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
	If nLastKey == 27
	    Set Filter To
	    Return
	Endif
	
	SetDefault(aReturn,"ZAB")
	
    Processa( {|| RptDetail() },"Imprimindo...") //nao existe na tabela zac e zab
    
	Set Filter To
	
	If aReturn[5] == 1
		Set Printer To
		Commit
	    ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool
Return

Static Function RptDetail()	
	
	ProcRegua(10) //MUDAR
		
	Cabec(Titulo, Cabec1,Cabec2,"NHEST121", "M", nTipo) 

	//pega o codigo do desenho
	DbSelectArea("SB1")
	DbSetOrder(1) //filial + cod
	If DbSeek(xFilial("SB1")+ZAB->ZAB_COD)	
		_cDesen := SB1->B1_CODAP5
		_cDesc  := SB1->B1_DESC
	EndIf

	DbSelectArea("SA2")		
	DbSetOrder(1) //filial + fornece + loja

	DbSelectArea("ZAC")
	DbSetOrder(1) // filial + num + item
	
	If DbSeek(xFilial("ZAC")+ZAB->ZAB_NUM+"0001")
		While ZAC->ZAC_NUM == ZAB->ZAB_NUM        
			_num    := 1
			_nTotRF := 0
			_nTotRU := 0
		
		   	IF PROW() > 58
				Cabec(Titulo, Cabec1,Cabec2,"NHEST121", "M", nTipo) 
		    ENDIF
		
			@ Prow() + 1, 001 Psay "Codigo : " + ZAB->ZAB_COD +"  Desenho: " + _cDesen + " - " + _cDesc
			DbSelectArea("SA2")
			If Dbseek(xfilial("SA2")+ZAB->ZAB_FORNEC+ZAB->ZAB_LOJA)
				@ Prow() + 1, 001 Psay "Fornecedor: " + ZAB->ZAB_FORNEC + " - " + ZAB->ZAB_LOJA + " - " + Subs(Alltrim(SA2->A2_NOME),1,30)
			Else
				MsgAlert("Fornecedor nao encontrado no cadastro.")
			EndIf
					
			@ Prow() , 100 Psay "Numero da RMR : "+ ZAB->ZAB_NUM

			@ Prow() + 1, 001 Psay OemToAnsi("Mês : ") + _cMes + Space(20) + "Material Consignado" 
			@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina
			@ Prow() + 2, 001 Psay OemToAnsi("Total de Peças Produzidas   : ") + Transform(ZAB->ZAB_QUANT,"@E 999,999")
            
       		//IMPRIME REFUGO FUNDIDO
       		@ PROW() + 2, 001 PSAY OEMTOANSI("TOTAL DE REFUGO DE FUNDIDO  : ")
        	While ZAC->ZAC_NUM == ZAB->ZAB_NUM .AND. ZAC->ZAC_LOCAL == '00'
				@ PROW() +1, 015 PSAY OEMTOANSI("OPERAÇÃO  ") +ZAC->ZAC_OPERAC + " : "  + TRANSFORM(ZAC->ZAC_QUANT,"@E 999,999")
				_nTotRF += ZAC->ZAC_QUANT
				ZAC->(DbSkip())
        	EndDo
       		@ PROW() + 1, 023 PSAY "TOTAL : "+ TRANSFORM(_nTotRF,"@E 999,999")

       		//IMPRIME REFUGO USINADO
       		@ PROW() + 2, 001 PSAY OEMTOANSI("TOTAL DE REFUGO DE USINAGEM : ")
        	While ZAC->ZAC_NUM == ZAB->ZAB_NUM .AND. ZAC->ZAC_LOCAL == '99'
				@ PROW() +1, 015 PSAY OEMTOANSI("OPERAÇÃO  ") +ZAC->ZAC_OPERAC + " : "  + TRANSFORM(ZAC->ZAC_QUANT,"@E 999,999")
				_nTotRU += ZAC->ZAC_QUANT
				ZAC->(DbSkip())
        	EndDo
       		@ PROW() + 1, 023 PSAY "TOTAL : "+ TRANSFORM(_nTotRU,"@E 999,999")

			_num++
		
			@ PROW() + 2, 017 PSAY "TOTAL GERAL : " + TRANSFORM(_nTotRF+_nTotRU,"@E 999,999")

			@ 46, 001 PSAY __PRTTHINLINE() // DLINHA ANTES DO TOTAL DO RODAPE DA PAGINA   
			@ 47, 001 PSAY OEMTOANSI("OBSERVAÇÕES")
			@ 52, 001 PSAY __PRTTHINLINE() // LINHA ANTES DO TOTAL DO RODAPE DA PAGINA    
			@ 53, 001 PSAY OEMTOANSI("VISTOS ")                                                                   
			@ 54, 001 PSAY SPACE(15)+ "NOME : _______________________"+SPACE(20)+ "NOME : __________________________________ "  
			@ 56, 001 PSAY SPACE(15)+ "RG   : _______________________"+SPACE(20)+ "RG   : __________________________________ "  
			@ 58, 001 PSAY SPACE(15)+ "ASS  : _______________________"+SPACE(20)+ "ASS  : __________________________________ "  
			@ 59, 001 PSAY SPACE(20)+ "        CLIENTE        "+SPACE(26)+ "    RESIDENTE   -   FORNECEDOR "  
			//@ 62, 001 PSAY SPACE(20)+ "______________________"+SPACE(21)+ "___________________________"  
			//@ 63, 001 PSAY SPACE(20)+ "    ANALISTA - WHB    "+SPACE(21)+ "     RESPONSAVEL - WHB"  
			@ 62, 001 PSAY SPACE(10)+ "_______________________"+SPACE(15)+ "_______________________"+SPACE(15)+"___________________________"  
			@ 63, 001 PSAY SPACE(10)+ "ANALISTA USINAGEM - WHB"+SPACE(15)+ "ANALISTA FUNDIDO - WHB"+SPACE(15)+"    RESPONSAVEL - WHB"  
		EndDo
	Else
		MsgAlert(OemToAnsi("RMR não possui ítens."))
		Return
	EndIf
Return


