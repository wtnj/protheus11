#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "ACAWUSER.CH"

/* ==================================================================================

USER FUNCTION : CALCULO DOS VALORES POSICAO FINANCEIRA

USO : CUSTOMIZACAO PELO CLIENTE DO CALCULO DOS VALORES DA POSICAO FINANCEIRA

AUTOR. WILKER A VALLADARES

-------------------------------------------------------------------------------------
PARAMETROS :
-------------------------------------------------------------------------------------

³ ExpA[2]       - Array: Titulos do aluno
³ ExpA[2][i][1] - String: Parcela
³ ExpA[2][i][2] - Data  : Vencimento
³ ExpA[2][i][3] - Number: Valor do Titulo
³ ExpA[2][i][4] - Number: Descontos
³ ExpA[2][i][5] - Number: Bolsa
³ ExpA[2][i][6] - Number: Multa
³ ExpA[2][i][7] - Number: Juros
³ ExpA[2][i][8] - Number: Valor Pago
³ ExpA[2][i][9] - Data  : Data de Pagamento
³ ExpA[2][i][10]- Number: Saldo a Pagar
³ ExpA[2][i][11]- String: Historico do Titulo
======================================================================================== */

USER FUNCTION PF(aParms)
Local i := 0
Local bHabilitado := .F.

if bHabilitado
	//ocorrencias financeiro na posicao 2 do array
	for i := 1 to len(aParms[2])
		//valor
		aPF[2][i][3]  :=	aPF[2][i][3] + 0
		//desconto
		aPF[2][i][4]  :=	aPF[2][i][4] + 0
		//bolsa
		aPF[2][i][5]  :=	aPF[2][i][5] + 0
		//multa
		aPF[2][i][6]  :=	aPF[2][i][6] + 0
		//juros
		aPF[2][i][7]  :=	aPF[2][i][7] + 0
		//valor pago
		aPF[2][i][8]  :=	aPF[2][i][8] + 0
		//valor a pagar
		aPF[2][i][10] :=	aPF[2][i][10] + 0
	next i
endif

RETURN aParms

// Ponto de entrada para inspetor de envoronment no webadmin
User Function CfgCheck()
Return {"WebFilial","WebEmpresa","MenuAlu","MenuPro","PastaMenu", "PastaMenuEsc","TituloPg","UrlPopProvas"}

User Function codregra()

Local cRet := GetMv("MV_WEBREG",,"MK0001")

If HttpSession->ra <> Nil
		HttpCookies->APRESPONSEJOB := "T_ACADEMICO"
Endif
Return cRet

USER FUNCTION codprof(cCodigo)
if cCodigo != "-1"
		HttpCookies->APRESPONSEJOB := "T_ACADEMICO"
else
	HttpCookies->APRESPONSEJOB := "T_ACADEMICO"
endif
RETURN nil

USER FUNCTION codvest(cOpcao_Thread)
Local 	cRet := GetMv("MV_WEBREG",,"MK0001")
Default cOpcao_Thread := ""

if alltrim(cOpcao_Thread) == "01"
		HttpCookies->APRESPONSEJOB := "T_ACADEMICO"  
		cRet := "MK0001"
else
		HttpCookies->APRESPONSEJOB := "T_ACADEMICO"
		cRet := GetMv("MV_WEBREG",,"MK0001")
endif
RETURN cRet

/*
WDESCREQ()
USER FUNCTION CRIADA PARA RETORNAR DESCRICOES COMPLEMENTARES NO COMBO DE REQUERIMENTOS - WEB
AUTOR. WILKER
12/08/2003
*/


USER FUNCTION WDESCREQ(cTipo)
Local aValidos := {}
Local nPos     := 0
Local cRet     := "" // retorno da funcao

// inserir as descricoes complementares, para cada tipo de requerimento ( codigo, descricao )
AADD( aValidos, {"000006",STR0001} ) //"Valor por Disciplina"
// -----

npos := Ascan(aValidos,{|aVal| aVal[1] == alltrim(cTipo) })

if npos > 0
	cRet := aValidos[npos][2]
endif
Return cRet


/*
ponto de entrada para mensagens genericas para o popup de login
autor. wilker.

Sera executado a partir destes eventos :

1 - o email cadastrado esta em branco
2 - aniversario aluno
3 - cpf gravado na base esta inconsistente

*/
USER FUNCTION ALLMSGS(cOpcao)
Local cRetorno := ""

If !Empty(cOpcao)
	
	if cOpcao == "1" // email em branco
		cRetorno := STR0002 //"O seu email esta em branco. Por favor, atualize-o na opção Dados Cadastrais"
	elseif cOpcao == "2" // aniversário
		cRetorno := STR0003 //"Parabéns!! Feliz Aniversário e muitos anos de vida.<br><br>São os votos desta Instituição"
	elseif cOpcao == "3" // cpf
		cRetorno := STR0004 //"O seu CPF esta errado. Por favor, atualize-o na opção Dados Cadastrais"
	endif
	
Endif
RETURN cRetorno