/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST183  �Autor  �FELIPE CICONINI     � Data �  26/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � RELATORIO DE SALDO POR ENDERE�O                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

   _______________________________________ 
  |                                       |
  | ~>Variaveis de Perguntas<~            |
  |                                       |
  | * mv_par01 - De Produto?              |
  | * mv_par02 - At� Produto?             |
  | * mv_par03 - De Endere�o?             |
  | * mv_par04 - At� Endere�o?            | 
  |_______________________________________|

*/
#INCLUDE "TOPCONN.CH"

User Function NHEST183()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SB1"
    oRelato:cPerg    := "EST183"
	oRelato:cNomePrg := "NHEST183"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este relat�rio imprime o Saldo de produto"
	oRelato:cDesc2   := "por Endere�o"
	oRelato:cDesc3   := ""
	
	//tamanho        
	oRelato:cTamanho := "M"  //default "M"

	//titulo
	oRelato:cTitulo  := "SALDO POR ENDERE�O"

	aAdd(aPergs,{"Do  Produto ?"      ,"C",15,0,"G","","","","","","SB1",""})
	aAdd(aPergs,{"Ate Produto ?"      ,"C",15,0,"G","","","","","","SB1",""})
	aAdd(aPergs,{"Do  Endere�o ?"     ,"C",15,0,"G","","","","","","",""})
	aAdd(aPergs,{"Ate Endere�o ?"     ,"C",15,0,"G","","","","","","",""})
	aAdd(aPergs,{"Mostra Zerados ?"   ,"N", 1,0,"C","Sim","N�o","","","","",""})
	aAdd(aPergs,{"De Local ?"         ,"C", 2,0,"G","","","","","","",""})
	aAdd(aPergs,{"Ate Local ?"        ,"C", 2,0,"G","","","","","","",""})

	oRelato:AjustaSx1(aPergs)
	
	//cabecalho      
	oRelato:cCabec1  := ""
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

Return

Static Function Imprime()

Processa( {|| Gerando()  },"Gerando Dados para a Impressao")
Processa( {|| RptDetail()  },"Imprimindo...")

Return

Static Function Gerando()
Local cQuery

	cQuery := "SELECT B1.B1_COD, B1.B1_DESC,BF.BF_LOCAL,BF.BF_LOCALIZ,SUM(BF.BF_QUANT) QUANT "
	cQuery += " FROM "+RetSqlName("SB1")+" B1 (NOLOCK), "+RetSqlName("SBF")+" BF (NOLOCK) "
	cQuery += " WHERE B1.B1_COD = BF.BF_PRODUTO "
	cQuery += " AND B1.B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND BF.BF_LOCALIZ BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND BF.BF_LOCAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	If mv_par05 == 2
		cQuery += " AND BF.BF_QUANT <> 0 "
	EndIf
	
	cQuery += " AND B1.D_E_L_E_T_ ='' "
	cQuery += " AND BF.D_E_L_E_T_ ='' "
	cQuery += " AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND BF.BF_FILIAL = '"+xFilial("SBF")+"'"
	cQuery += " GROUP BY B1.B1_COD, B1.B1_DESC,BF.BF_LOCAL,BF.BF_LOCALIZ"
	
	TCQUERY cQuery NEW ALIAS "TMP1"

	TMP1->(DbGoTop())

Return

Static Function RptDetail()

oRelato:cCabec1 := "   CODIGO            DESCRI��O                                      LOCAL       ENDERE�O                      SALDO"
//                  12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                           10        20        30        40        50        60        70        80        90        100       110       120       130       140
oRelato:cCabec2 := ""

oRelato:Cabec()

While TMP1->(!EoF())

	If Prow() > 60
   		oRelato:Cabec()
   	EndIf
	
	@Prow()+1,003 PSAY TMP1->B1_COD
	@Prow()  ,021 PSAY TMP1->B1_DESC
	@Prow()  ,070 PSAY TMP1->BF_LOCAL
	@Prow()  ,080 PSAY TMP1->BF_LOCALIZ
	@Prow()  ,101 PSAY TMP1->QUANT    Picture "@E 999,999,999.99"

	TMP1->(DbSkip())
EndDo

	TMP1->(DbCloseArea())

Return