/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN075  บAutor  ณMarcos R. Roquitski บ Data ณ  16/09/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio contas a pagar com diferencas na data de entrada   ฑฑ
ฑฑบ          ณcom a data de pagamento.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhFin075()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nTotVlr,nTotFat")

cString   := "SE1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir, ")
cDesc2    := OemToAnsi("diferencas da Data de digitacao / Data de pagamento.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN030"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "Relatorio de diferencas na Data de digitacao / Data de pagamento"
Cabec1    := " Prf Numero   P Tipo Fornecedor                   Emissao     Vencto      V.Real      Contabil   #Datas  Natureza  Cond.Pagto"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHFIN075"
_cPerg    := "FIN975"
nTotVlr   := 0
nTotFat   := 0
                  
If !Pergunte('FIN975',.T.)
   Return(nil)
Endif

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

If nLastKey == 27
    Set Filter To
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
cNormal := aDriver[2]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

Return

Static Function Gerando()

	cQuery := "SELECT E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_NATUREZ,E2.E2_FORNECE,"
	cQuery += "E2.E2_LOJA,E2.E2_NOMFOR,E2.E2_EMISSAO,E2.E2_VENCTO,E2.E2_VENCREA,F1.F1_DTLANC,F1.F1_COND,E4.E4_DESCRI "
	cQuery += "FROM " + RetSqlName( 'SE2' ) + " E2, " + RetSqlName( 'SF1' ) + " F1," + RetSqlName( 'SE4' ) + " E4 "
	cQuery += "WHERE E2.D_E_L_E_T_ <> '*' "
	cQuery += "AND E2.E2_NUM = F1.F1_DOC " 
	cQuery += "AND E2.E2_PREFIXO = F1.F1_SERIE "
	cQuery += "AND E2.E2_FORNECE = F1.F1_FORNECE "
	cQuery += "AND E2.E2_LOJA = F1.F1_LOJA "
	cQuery += "AND F1.F1_COND = E4.E4_CODIGO "
    cQuery += "AND E2.E2_EMISSAO BETWEEN '" + DTOS(Mv_par09) + "' AND '" + DTOS(Mv_par10) + "' " 
    cQuery += "AND E2.E2_VENCTO BETWEEN '" + DTOS(Mv_par05) + "' AND '" + DTOS(Mv_par06) + "' " 
    cQuery += "AND F1.F1_DTLANC BETWEEN '" + DTOS(Mv_par11) + "' AND '" + DTOS(Mv_par12) + "' " 

	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","E2_EMISSAO","D") // Muda a data de string para date.
	TcSetField("TMP","E2_VENCREA","D") // Muda a data de string para date.
	TcSetField("TMP","E2_VENCTO","D")  // Muda a data de string para date.
	TcSetField("TMP","F1_DTLANC","D")  // Muda a data de string para date.
	
Return    

                                                         		
Static Function RptDetail()
Local nSaldos := 0
Local nTotBar := 0
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())

	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	@ Prow() + 1, 001 Psay TMP->E2_PREFIXO
	@ Prow()    , 005 Psay TMP->E2_NUM
	@ Prow()    , 014 Psay TMP->E2_PARCELA
	@ Prow()    , 016 Psay TMP->E2_TIPO    
	@ Prow()    , 021 Psay TMP->E2_FORNECE+"-"+TMP->E2_LOJA+" "+Substr(TMP->E2_NOMFOR,1,18)
	@ Prow()    , 050 Psay TMP->E2_EMISSAO Picture "99/99/9999"
	@ Prow()    , 062 Psay TMP->E2_VENCTO  Picture "99/99/9999"
	@ Prow()    , 074 Psay TMP->E2_VENCREA Picture "99/99/9999"
	@ Prow()    , 086 Psay TMP->F1_DTLANC  Picture "99/99/9999"
	@ Prow()    , 100 Psay TMP->F1_DTLANC - TMP->E2_EMISSAO Picture "999"
	@ Prow()    , 105 Psay Substr(TMP->E2_NATUREZ,1,8)
	@ Prow()    , 115 Psay TMP->F1_COND + " "+Substr(TMP->E4_DESCRI,1,100)
	TMP->(DbSkip())

Enddo
@ Prow()+01,001 Psay __PrtThinLine() 

DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return(nil)
