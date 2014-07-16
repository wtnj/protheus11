/*                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST072        ³ João Felipe da Rosa   ³ Data ³ 06.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ DIVERGENCIA NOTA FISCAL DE ENTRADA X TICKET BALANCA       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NHEST072() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,CCOMPAC,CNORMAL")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CQUERY,_cCodUsr")
SetPrvt("_nValFrete, _aValUnit, _aQuant, _aTotal, _aTotCusto, _aTotalFr ,_aTotTic")

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir as ")
cDesc2    := OemToAnsi("divergencias entre NF e TICKET Balanca")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST072"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.                                                 
titulo    := "RELATORIO DE DIVERGENCIAS ENTRE NF.ENTRADA E TICKET DA BALANCA"
Cabec1    := " Dt.NF       Nr.NF      Fornecedor                                         Val.Frete     Val.Unit           Peso         Ticket         QTde.        Total NF    Total+Frete    ICMS%      IPI%         Custos "
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST072"       //Nome Default do relatorio em Disco
_cPerg    := "EST072"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)

_nValFrete := 0
_aValUnit  := 0
_aQuant    := 0
_aTotal    := 0
_aTotalFr  := 0
_aTotCusto := 0
_aTotTic   := 0

dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif
                                                                                         
If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho) 

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]
cFilterUser:=aReturn[7]

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer

TMP->(DbGoTop())
If Empty(TMP->D1_DTDIGIT)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

//inicio da impressao
Processa( {|| RptDet1() },"Imprimindo...")
     
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()                       
//**********************************
    cQuery := "SELECT D1.D1_DTDIGIT, D1.D1_DOC, D1.D1_FORNECE, D1.D1_LOJA,D1.D1_VALFRE, D1.D1_VUNIT, D1.D1_TOTAL, "
    cQuery += " D1.D1_IPI,D1.D1_PICM,A2.A2_NOME, B1.B1_DESC, D1.D1_COD, D1.D1_QUANT,F1.F1_TICKET,F1.F1_PESOTIC "
	cQuery += " FROM " + RetSqlName('SD1') + " D1, "  + RetSqlName('SA2') + " A2, " + RetSqlName('SB1') + " B1, " + RetSqlName('SF1') + " F1 "
	cQuery += " WHERE D1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " AND D1.D1_FORNECE = A2_COD "    
	cQuery += " AND D1.D1_LOJA = A2_LOJA "
	cQuery += " AND D1.D1_COD = B1.B1_COD " 
	cQuery += " AND D1.D1_TIPO = 'N' "
	cQuery += " AND D1.D1_DTDIGIT BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' "
	cQuery += " AND F1.F1_DOC = D1.D1_DOC "
	cQuery += " AND F1.F1_SERIE = D1.D1_SERIE "
	cQuery += " AND F1.F1_FORNECE = D1.D1_FORNECE "
	cQuery += " AND F1.F1_LOJA = D1.D1_LOJA "
	cQuery += " AND D1.D_E_L_E_T_ = ' ' AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
	cQuery += " AND F1.D_E_L_E_T_ = ' ' AND F1.F1_FILIAL = '"+xFilial("SF1")+"'"
	cQuery += " AND A2.D_E_L_E_T_ = ' ' AND A2.A2_FILIAL = '"+xFilial("SA2")+"'"
	cQuery += " AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " ORDER BY D1.D1_COD, D1.D1_DOC"
	
//    MemoWrit('C:\TEMP\NHEST70.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP"                      
    DbSelectArea("TMP")

Return

Static Function RptDet1()
               
// imprime cabeçalho
Titulo += "(" + dtoc(Mv_par03) + " ate " + dtoc(Mv_par04)+")"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
   
DbSelectArea("TMP") 
dbgotop()
                                               
ProcRegua(0)

While TMP->(!eof())

	IncProc()

	aux_produto := TMP->D1_COD
	
	If Prow() > 56
	   _nPag := _nPag + 1
	   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0) 
	Endif                     
	
 	@ Prow() +1, 001 Psay "Produto:" + TMP->D1_COD + ' - ' + TMP->B1_DESC
       
	While TMP->(!EOF()) .AND. aux_produto == TMP->D1_COD

	   	@ Prow() +1, 001 Psay STOD(TMP->D1_DTDIGIT)
	   	@ Prow()   , 013 Psay TMP->D1_DOC
	   	@ Prow()   , 024 Psay TMP->D1_FORNECE+'-'+TMP->D1_LOJA
	   	@ Prow()   , 034 Psay OemtoAnsi(Substr(TMP->A2_NOME,1,40))
	   	@ Prow()   , 075 Psay TMP->D1_VALFRE  picture "@E 99,999.99"
	   	@ Prow()   , 085 Psay TMP->D1_VUNIT   picture "@E 9,999,999.99"
	   	@ Prow()   , 100 Psay TMP->D1_QUANT   picture "@E 9,999,999.99"
		                                                                  
	   	@ Prow()   , 120 Psay TMP->F1_TICKET  picture "@E 999999"
	   	@ Prow()   , 130 Psay TMP->F1_PESOTIC picture "@E 999,999.99"
		   
	   	@ Prow()   , 145 Psay TMP->D1_TOTAL   picture "@E 9,999,999.99"	   
	   	@ Prow()   , 160 Psay TMP->D1_TOTAL+TMP->D1_VALFRE picture "@E 9,999,999.99"
	   	@ Prow()   , 175 Psay TMP->D1_PICM    picture "@E 99.99%"	   	   
	   	@ Prow()   , 185 Psay TMP->D1_IPI     picture "@E 99.99%"
		   
	   	aux_custom = (TMP->D1_TOTAL+TMP->D1_VALFRE)/TMP->D1_QUANT
	   	aux_custom = ((aux_custom * TMP->D1_PICM) / 100) - aux_custom
	   	aux_custom = ((aux_custom * TMP->D1_IPI) / 100) - aux_custom
		   	   
	   	@ Prow()   , 194 Psay aux_custom   picture "@E 9,999,999.99"  
		   
	   	_nValFrete = _nValFrete + TMP->D1_VALFRE
	   	_aValUnit  = _aValUnit  + TMP->D1_VUNIT
	   	_aQuant    = _aQuant    + TMP->D1_QUANT
	   	_aTotal    = _aTotal    + TMP->D1_TOTAL
	   	_aTotalFr  = _aTotalFr  + TMP->D1_TOTAL+TMP->D1_VALFRE
	   	_aTotCusto = _aTotCusto + aux_custom
	   	_aTotTic   = _aTotTic   + TMP->F1_PESOTIC
	
	    aux_produto = TMP->D1_COD 
	
	    TMP->(dbskip())
	
	Enddo

    @ Prow() +1, 000 PSAY __PrtThinLine()
    @ Prow() +1, 045 Psay "TOTAL POR PRODUTO :"
    @ Prow()   , 072 Psay _nValFrete      picture "@E 9,999,999.99"
    @ Prow()   , 085 Psay _aValUnit       picture "@E 9,999,999.99"
    @ Prow()   , 100 Psay _aQuant         picture "@E 9,999,999.99"
	@ Prow()   , 129 Psay _aTotTic        picture "@E 9,999,999.99"
    @ Prow()   , 145 Psay _aTotal         picture "@E 9,999,999.99"
    @ Prow()   , 160 Psay _aTotalFr       picture "@E 9,999,999.99"
    @ Prow()   , 194 Psay _aTotCusto      picture "@E 9,999,999.99"
    @ Prow() +1, 127 PSAY __PrtThinLine()

	_nValFrete := 0
	_aValUnit  := 0
	_aQuant    := 0
	_aTotalFr  := 0
	_aTotal    := 0
	_aTotCusto := 0
	_aTotTic   := 0

Enddo

Return