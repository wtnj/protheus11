#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP029     ºAutor  ³Felipe Ciconini  º Data ³  02/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE ALERTA DE CRITICIDADE/PARADA DE LINHA          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHPCP029()

cString		:= "ZDU"
cDesc1		:= "Este relatorio tem como objetivo imprimir"
cDesc2		:= "o resumo de alertas"
cDesc3		:= ""
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHPCP029"
nLastKey	:= 0
titulo		:= OemToAnsi("ALERTA DE CRITICIDADE E PARADA DE LINHA")
cabec1		:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHPCP029"
_cPerg		:= ""

//Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
	Set Filter to
	Return
EndIf

SetDefault (aReturn,cString)

nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV ("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| Gerando() },"Gerando Dados para Impressao")
Processa({|| RptDetail() },"Imprimindo...")

Set Filter to
If aReturn[5] == 1
	Set Printer to
	Commit
	Ourspool(wnrel)
EndIf
MS_FLUSH()

Return

Static Function Gerando()
Local cQuery

	//_-_-_-_-_-_-_-_-_-_-_-_
	//_-_MONTANDO A QUERY-_-_
	//_-_-_-_-_-_-_-_-_-_-_-_
	
	cQuery := "SELECT ZDU.ZDU_NUM, ZDU.ZDU_TIPO, ZDU.ZDU_MAT, ZDU.ZDU_CLIFOR, ZDU.ZDU_CF, ZDU.ZDU_LOJA, QAA.QAA_NOME, ZDU.ZDU_DATA, ZDU.ZDU_PROM, "
	cQuery += " ZDU.ZDU_OBS, ZDU.ZDU_PROBL, ZDV.ZDV_NUM, ZDV.ZDV_ITEM, ZDV.ZDV_PROD, SB1.B1_DESC, "
	cQuery += " CLIENTE = "
	cQuery += " CASE "
	cQuery += " 	WHEN ZDU.ZDU_CF = 'F' THEN "
	cQuery += " 		(SELECT SA2.A2_NOME FROM "+RetSqlName('SA2')+" SA2 "
	cQuery += " 		WHERE SA2.D_E_L_E_T_ = ' ' AND SA2.A2_COD = ZDU.ZDU_CLIFOR "
	cQuery += " 		AND SA2.A2_LOJA = ZDU.ZDU_LOJA) "
	cQuery += " 	ELSE "
	cQuery += " 		(SELECT SA1.A1_NOME FROM "+RetSqlName('SA1')+" SA1 "
	cQuery += " 		WHERE SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = ZDU.ZDU_CLIFOR "
	cQuery += " 		AND SA1.A1_LOJA = ZDU.ZDU_LOJA) "
	cQuery += " END "
	cQuery += " FROM "+RetSqlName( 'ZDU' )+" ZDU, "+RetSqlName( 'ZDV' )+" ZDV, "+RetSqlName( 'QAA' )+" QAA, "+RetSqlName( 'SB1' )+" SB1 "
	cQuery += " WHERE ZDU.ZDU_NUM = ZDV.ZDV_NUM "
	cQuery += " AND ZDU.ZDU_NUM = '"+ZDU->ZDU_NUM+"'"
	cQuery += " AND ZDU.ZDU_MAT = QAA.QAA_MAT "
	cQuery += " AND ZDV.ZDV_PROD = SB1.B1_COD "
	
	cQuery += " AND ZDU.D_E_L_E_T_ = ' ' "
    cQuery += " AND ZDV.D_E_L_E_T_ = ' ' "
    cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += " AND QAA.D_E_L_E_T_ = ' ' "
    cQuery += " AND ZDU.ZDU_FILIAL = '"+xFilial("ZDU")+"'"
    cQuery += " AND ZDV.ZDV_FILIAL = '"+xFilial("ZDV")+"'"
    cQuery += " AND SB1.B1_FILIAL  = '"+xFilial("SB1")+"'"
    cQuery += " AND QAA.QAA_FILIAL = '"+xFilial("QAA")+"'"

	MemoWrit('C:\TEMP\NHPCP029.SQL', cQuery)
	TCQUERY cQuery NEW ALIAS "TMP1"
	TMP1->(DbGoTop())
	TcSetField("TMP1","ZDU_DATA","D")

Return

Static Function RptDetail()
Local _nLin

Titulo := OemToAnsi("RELATÓRIO DE ALERTAS DE CRITICIDADE, PARADA DE LINHA E ALERTA LOGÍSTICO")

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

If TMP1->ZDU_TIPO == "C"
	@Prow()+2,055 psay "ALERTA DE CRITICIDADE"
	@Prow()+2,015 psay OemToAnsi("PARADA:")
	@Prow()  ,075 psay OemToAnsi("CRITICIDADE: 10")
ElseIf TMP1->ZDU_TIPO == "P"
	@Prow()+2,055 psay "PARADA DE LINHA"
	@Prow()+2,015 psay OemToAnsi("PARADA: 40")
	@Prow()  ,075 psay OemToAnsi("CRITICIDADE:")
Else
	@Prow()+2,055 psay "ALERTA LOGÍSTICO"
	@Prow()+2,015 psay OemToAnsi("PONTUAÇÃO: 10")
EndIf

//TEXTO EXPLICATIVO

If TMP1->ZDU_TIPO == "L"
	@Prow()+3,015 PSAY OemToAnsi("Os impactos logísticos gerados são de responsabilidade do fornecedor/Cliente e serão ")
	@Prow()+1,015 PSAY OemToAnsi("tratados conforme procedimento de Falhas logísticas. ")
	@Prow()+2,015 PSAY OemToAnsi("Alerta Logístico: O fornecedor/Cliente deve apresentar ação de contenção imediata")
	@Prow()+1,015 PSAY OemToAnsi("para evitar o impacto à linha de produção. Haverá demérito na performance do fornecedor ")
	@Prow()+1,015 PSAY OemToAnsi("de 10 pontos equivalente a 1%.")
	@Prow()+2,015 PSAY OemToAnsi("Caso haja parada de linha, contenção, transbordo (entre outros) gerará débito. ")
Else
	@Prow()+3,015 psay OemtoAnsi("Os impactos logísticos gerados são de responsabilidade do Fornecedor/Cliente e serão tratados conforme ")
	@Prow()+1,015 psay OemtoAnsi("procedimentos de falhas logísticas.")
	@Prow()+1,015 psay OemtoAnsi("ALERTA DE CRITICIDADE: O Fornecedor/Cliente deve apresentar uma ação de contenção imediata para evitar ")
	@Prow()+1,015 psay OemtoAnsi("impacto à linha de produção. Haverá demérito na performance do Fornecedor de 10(dez) pontos ")
	@Prow()+1,015 psay OemtoAnsi("equivalente a 1%(um porcento).")
	@Prow()+1,015 psay OemtoAnsi("ALERTA DE FALTA DE PEÇAS E PARADA DE LINHA: O Fornecedor deve reestabelecer o fluxo imediatamente e ")
	@Prow()+1,015 psay OemtoAnsi("apresentar um plano de ação em 24 horas a partir do recebimento do alerta. Haverá demérito na ")
	@Prow()+1,015 psay OemtoAnsi("performance do Fornecedor de 40(quarenta) pontos, equivalente a 4%(quatro porcento).")
	@Prow()+1,015 psay OemToAnsi("TODA PARADA DE LINHA GERARÁ DÉBITO.")
EndIf

@Prow()+3,015 psay OemtoAnsi("Alerta Nº")
@Prow()  ,060 psay TMP1->ZDU_NUM
@Prow()+2,015 psay "Data"
@Prow()  ,060 psay TMP1->ZDU_DATA
@Prow()+2,015 psay "Aprivisionador"
@Prow()  ,060 psay TMP1->ZDU_MAT+ " - " +TMP1->QAA_NOME
@Prow()+2,015 psay "Fornecedor/Cliente"
@Prow()  ,060 psay TMP1->ZDU_CLIFOR+ " - " +TMP1->ZDU_LOJA+ " - " +TMP1->CLIENTE
@Prow()+2,015 psay "Promessa"
@Prow()  ,060 psay TMP1->ZDU_PROM   
@Prow()+2,015 psay OemToAnsi("Descrição do Problema")
@Prow()  ,060 psay TMP1->ZDU_PROBL

@Prow()+2,015 psay OemToAnsi("Observação")

_nLin := MlCount(AllTrim(TMP1->ZDU_OBS),40)
For i:=1 to _nLin
	@Prow() + Iif(i=1,0,1) ,060 psay MemoLine(TMP1->ZDU_OBS,40,i)
Next

@Prow()+2,000 psay __PrtThinLine()

@Prow()+2,060 psay "RELAÇÃO DE ITENS"
@Prow()+1,005 psay "                                 Nº     ITEM      CÓDIGO              DESCRIÇÃO"
While TMP1->(!Eof())
	@Prow()+1,034 psay TMP1->ZDV_NUM
	@Prow()  ,044 psay TMP1->ZDV_ITEM
	@Prow()  ,054 psay TMP1->ZDV_PROD
	@Prow()  ,074 psay TMP1->B1_DESC
	TMP1->(DbSkip())
EndDo

@Prow()+3,000 psay __PrtThinLine()

@Prow()+1,005 psay OemToAnsi("WHB Fundição")
@Prow()  ,090 psay "WHB Usinagem"
@Prow()+1,005 psay "Rua Wiegando Olsen, 1600 - CIC"
@Prow()  ,090 psay "Rua Wiegando Olsen, 1000 - CIC"
@Prow()+1,005 psay "Curitiba - PR - Brasil - CEP 81460-070"
@Prow()  ,090 psay "Curitiba - PR - Brasil - CEP 81460-070"
@Prow()+1,005 psay "Fone:(41)3341-1800   Fax:(41)3348-3641" 
@Prow()  ,090 psay "Fone:(41)3341-1900   Fax:(41)3348-3605"

TMP1->(DbCloseArea())

Return(nil)
