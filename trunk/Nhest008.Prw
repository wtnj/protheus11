/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST008        ³ Antonio Leandro Favero³ Data ³21.12.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Movimentacao das Pecas em Consignacao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³Antonio Leandro Favero - 14/11/01 - Melhorias na Query     ³±±
±±³Alteracoes³Alexandre R. Bento     - 18/05/04 - Melhorias na Busca     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhest008()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,aMatriz,CQUERY1,CQUERY,_nSaldo,M_PAG,cNFSD2,cNFSD1")

CbCont   := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
cabec1 := "                          ENTRADAS                                SAIDAS"
cabec2 := "DATA         N.FISCAL   REM.SIMB.      QUANTIDADE    NF.FATURA  NF.RETORNO        QUANTIDADE         SALDO             NOME CLIENTE"
cabec3 := "-----------  -----------------------------------    -----------------------      --------------     -------------------------------------"
//         XX/XX/XXXX   XXXXXXXXX  000.000.000,00    XXXXXXXXXX  000.000.000,00   000.000.000,00
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//         1         10        20        30        40        50        60        70        80        90        100       110       120       130

nOrdem   := 0
tamanho  := "M"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Movimentacao das Pecas em Consignacao - Faturamento"
cDesc1   := "Movimentacao das Pecas em Consignacao - Faturamento"
cDesc2   := " "
cDesc3   := " "
cString  := "SD1"
nTipo    := 0
nomeprog := "NHEST008"
cPerg    := "EST008"
M_PAG    := 1
nPag     := 1
aMatriz  := {}
cNFSD2   := Space(06)
cNFSD1   := Space(06)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Produto                                         ³
//³ mv_par02     Da Data                                         ³
//³ mv_par03     Ate a Data                                      ³
//³ mv_par04     Saldo Inicial                                   ³
//³ mv_par05     Ultima Nota Fiscal de Entrada                   ³
//³ mv_par06     Ultima Nota Fiscal de Retorno                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.f.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHEST008"

SetPrint("SD1",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ntipo  		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))
nRos		:= SM0->M0_CGC
aDriver 	:= ReadDriver()
cCompac 	:= aDriver[1]
cNormal 	:= aDriver[2]
lPrimeiro 	:= .T.

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

TMPSD1->(DbGoTop())
If Empty(TMPSD1->D1_DOC)
   MsgBox("Não existem NFs de entradas para estes parâmetros...verifique!","Atencao","STOP")
   DbselectArea("TMPSD1")
   DbCloseArea()
Endif

TMPSD2->(DbGoTop())
If Empty(TMPSD2->D2_DOC)
   MsgBox("Não existem NFs de Saida para estes parâmetros...verifique!","Atencao","STOP")
   DbselectArea("TMPSD2")
   DbCloseArea()
Endif


rptStatus({||Imprime()},"Imprimindo...")     


If aReturn[5] == 1
	Set Printer To
	Commit
	Ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()


cQuery := "SELECT SD1.D1_DTDIGIT,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_QUANT,SD1.D1_TES,SD1.D1_COD,SD1.D1_NOTATRI,SD1.D1_SERITRI,SB1.B1_DESC"     
cQuery += " FROM " + RetSqlName( 'SD1' ) +" SD1, " + RetSqlName( 'SB1' ) +" SB1"
cQuery += " WHERE SD1.D1_FILIAL = '" + xFilial("SD1")+ "'"
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
cQuery += " AND SD1.D1_DTDIGIT BETWEEN '" + Dtos(Mv_par02) + "' AND '" + Dtos(Mv_par03) + "' "
cQuery += " AND SD1.D1_COD='" + Mv_par01 + "'"
cQuery += " AND SD1.D1_TES IN ('041','293','193','292')"
cQuery += " AND SD1.D1_COD = SB1.B1_COD"
cQuery += " AND SD1.D_E_L_E_T_<>'*' AND SB1.D_E_L_E_T_<>'*'"
cQuery += " ORDER BY SD1.D1_DTDIGIT,SD1.D1_COD,SD1.D1_DOC"

cQuery1 := "SELECT SD2.D2_EMISSAO,SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_QUANT,SD2.D2_TES,SD2.D2_COD,SB1.B1_DESC,SC6.C6_NUM,SC5.C5_PEDCOM,SC5.C5_NUM,SC5.C5_NOTA,SC5.C5_SERIE"
cQuery1 += " FROM " + RetSqlName( 'SD2' ) +" SD2 (nolock) "

cQuery1 += " INNER JOIN " + RetSqlName( 'SC6' ) +" SC6 (NOLOCK) ON "
cQuery1 += "     SC6.C6_FILIAL = SD2.D2_FILIAL "
cQuery1 += " AND SD2.D2_COD = SC6.C6_PRODUTO"
cQuery1 += " AND SD2.D2_DOC = SC6.C6_NOTA"
cQuery1 += " AND SD2.D2_SERIE = SC6.C6_SERIE"
cQuery1 += " AND SD2.D2_NFORI = SC6.C6_NFORI"
cQuery1 += " AND SD2.D2_CLIENTE = SC6.C6_CLI"
cQuery1 += " AND SD2.D2_LOJA = SC6.C6_LOJA"
cQuery1 += " AND SD2.D2_EMISSAO = SC6.C6_DATFAT"
cQuery1 += " AND SD2.D2_IDENTB6 = SC6.C6_IDENTB6"
cQuery1 += " AND SD2.D2_PEDIDO = SC6.C6_NUM"     
cQuery1 += " AND SD2.D2_ITEMPV = SC6.C6_ITEM"     
cQuery1 += " AND SD2.D2_SERIORI = SC6.C6_SERIORI"
cQuery1 += " AND SC6.D_E_L_E_T_ = ''"

cQuery1 += " INNER JOIN " + RetSqlName( 'SB1' ) +" SB1 (NOLOCK) ON "
cQuery1 += "     SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
cQuery1 += " AND SD2.D2_COD = SB1.B1_COD"
cQuery1 += " AND SB1.D_E_L_E_T_=''" 

cQuery1 += " LEFT JOIN " + RetSqlName( 'SC5' ) +" SC5 (NOLOCK) ON "
cQuery1 += "     SC5.C5_FILIAL = '" + xFilial("SC5")+ "'"
cQuery1 += " AND SC6.C6_NUM    = SC5.C5_PEDCOM " //traz o c5_pedcom se existir
cQuery1 += " AND SC5.D_E_L_E_T_ = ''"

cQuery1 += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2")+ "'"
cQuery1 += " AND SD2.D2_EMISSAO BETWEEN '" + Dtos(Mv_par02) + "' AND '" + Dtos(Mv_par03) + "' "
cQuery1 += " AND SD2.D2_COD = '" + Mv_par01 + "' "
cQuery1 += " AND SD2.D2_TES IN ('694','597','594' )"
//cQuery1 += " AND SD2.D2_QUANT = SC6.C6_QTDVEN"

cQuery1 += " AND SD2.D_E_L_E_T_ = ''"
cQuery1 += " ORDER BY SD2.D2_EMISSAO,SD2.D2_COD,SD2.D2_DOC,SD2.D2_ITEM"

//memoWrit('C:\TEMP\EST008.SQL',cQuery1)
//memoWrit('C:\TEMP\EST008a.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery  NEW ALIAS "TMPSD1"
TCQUERY cQuery1 NEW ALIAS "TMPSD2"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Imprime         ³ ANTONIO LEANDRO FAVERO³ Data ³21.12.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao dos Dados                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Imprime()

lPRIMEIRO 	:= .T.
_nSaldo 	:= mv_par04

If Select("TMPSD1") > 0
	cNFSD1 := StrZero(Val(TMPSD1->D1_DOC)-1,6)// Numero da primeira nota fiscal de entrada
	TMPSD1->(DbGoTop())
	ProcRegua(TMPSD1->(RecCount()))
	
	// Le as notas de entrada selecionadas no parametro
	While !TMPSD1->(Eof())
	
		Aadd(aMatriz,{TMPSD1->D1_DTDIGIT,"E",TMPSD1->D1_DOC,TMPSD1->D1_SERIE,TMPSD1->D1_COD,TMPSD1->B1_DESC,Round(TMPSD1->D1_QUANT,2),TMPSD1->D1_NOTATRI,TMPSD1->D1_SERITRI})
	
	  	TMPSD1->(DbSkip())                                
	  	IncProc("Lendo arquivo de Entrada de Notas: " + TMPSD1->D1_DOC)
	Enddo  	     
	
	DbselectArea("TMPSD1")
	DbCloseArea()

Endif
	
If Select("TMPSD2") > 0
	If TMPSD2->C5_NOTA <> 'NULL'
	   cNFSD2 := StrZero(Val(TMPSD2->C5_NOTA)-1,6)// Numero da primeira nota fiscal de saida fatura
	Else
	   cNFSD2 := StrZero(Val(TMPSD2->D2_DOC)-1,6)// Numero da primeira nota fiscal de saida retorno
	Endif   
	
	TMPSD2->(DbGoTop())                               
	ProcRegua(TMPSD2->(RecCount()))
	
	// Le as notas de saidas selecionadas no parametro
	While !TMPSD2->(Eof())
	
		Aadd(aMatriz,{TMPSD2->D2_EMISSAO,"S",TMPSD2->D2_DOC,TMPSD2->D2_SERIE,TMPSD2->D2_COD,TMPSD2->B1_DESC,Round(TMPSD2->D2_QUANT,2),TMPSD2->C5_NOTA,TMPSD2->C5_SERIE})
	
	  	TMPSD2->(DbSkip())                                             
	  	IncProc("Lendo arquivo de Entrada de Notas: " + TMPSD2->D2_DOC)
	Enddo
	DbselectArea("TMPSD2")
	DbCloseArea()
	
Endif

If Len(aMatriz) == 0
   MsgBox("Não existem NFs para estes parâmetros...verifique!","Atencao","STOP")
   Return
Endif

//orderna a matriz pela data de digitação
aMatriz := ASort(aMatriz,,, { |x, y| x[1]+x[2]+x[3]+x[4]+x[5] < y[1]+y[2]+y[3]+y[4]+y[5]}) //ordena por data,nota, serie, produto, qtde

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
@ Prow() + 1, 001 Psay  "PRODUTO : "+ aMatriz[1][5] + " - " +aMatriz[1][6]
@ Prow() + 01, 001 Psay "SALDO INICIAL: "
@ Prow()     , 020 Psay mv_par04 Picture "@E9,999,999.99"
@ Prow() + 01, 001 Psay "Ultima NF de Entrada Considerada no Inventario Anterior: " + Iif (Empty(mv_par05),cNFSD1,mv_par05)  //mv_par05
@ Prow() + 01, 001 Psay "Ultima NF de Retorno Considerada no Inventario Anterior: " + Iif (Empty(mv_par06),cNFSD2,mv_par06)  //mv_par06
@ Prow() + 01, 001 Psay "OBS: " + mv_par07
@ prow() + 01, 001 Psay " "             

nSaldo := Mv_par04 // pega saldo inicial

For x:=1 to Len(aMatriz)

   _cAnoSD1 := Substr(aMatriz[x][1],01,04)
   _cMesSD1 := Substr(aMatriz[x][1],05,02)
   _cDiaSD1 := Substr(aMatriz[x][1],07,02)
   
   @ Prow() + 1, 001 Psay  _cDiaSd1 +"/"+_cMesSd1+"/"+_cAnoSd1 //data digitação      

   If aMatriz[x][2] == "E" //nota de entrada      
      nSaldo += Round(aMatriz[x][7],2)
      @ Prow()    , 012 Psay  aMatriz[x][3]+"-"+aMatriz[x][4] //doc+serie
      If !Empty(aMatriz[x][8])//imprime somente quando tem a nota triangular
         @ Prow()    , 025 Psay  aMatriz[x][8]+"-"+aMatriz[x][9] //nota triangular +serie triangular
      Endif   
      @ Prow()    , 036 Psay Transform(aMatriz[x][7],"@E 99,999,999") 
   Else //nota de saida igual a S
      nSaldo -= Round(aMatriz[x][7],2)    
      If aMatriz[x][8] <> 'NULL' // se encontrou a nota de fatura
         @ Prow()    , 052 Psay  aMatriz[x][8]+"-"+aMatriz[x][9] //doc+serie da nota de fatura
      Endif         
      @ Prow()    , 064 Psay  aMatriz[x][3]+"-"+aMatriz[x][4] //doc+serie
      
      @ Prow()    , 078 Psay Transform(aMatriz[x][7],"@E 99,999,999") 
   Endif
   @ Prow()    , 096 Psay  Transform(nSaldo,"@E 99,999,999")  

   If pRow() > 56                                 
      M_PAG += 1
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
// 	  nPag += 1
   Endif

Next x	
            

Return
