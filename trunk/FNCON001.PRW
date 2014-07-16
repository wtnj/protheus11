/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fncon001         ³ Osmar Schimitberger  ³ Data ³18.08.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Gatilho p/gravar conta no Fornecedor e PC Contab.Gerencial ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ESPECÍFICO PARA FUNDIÇÃO NEW HÜBNER LTDA                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#Include "rwmake.ch"
#Include "prtopdef.ch"

User Function  fncon001()
Local cCod    := Substr(M->A2_COD,3,6)
Local cCodC   := " "
Local cNome   := M->A2_NOME

If M->A2_EST=="EX" //fornecedores exportacao
	cCodC:="20101002" //conta sintetica

Elseif Alltrim(Substr(M->A2_COD,2,1)) $ '1/2/3/4/5/6/7/8/9'
	cCod    := Alltrim(Substr(M->A2_COD,2,5))
	cCodC   := "20101004" //conta /sintetica

Else //fornecedores nacionais
	cCodC:="20101001" //conta /sintetica
Endif

DbSelectArea("CT1")
CT1->(DbSetOrder(1)) //filial+cod
CT1->(DbSeek(xFilial("CT1") + cCodc + cCod))
If !CT1->(Found())
	RecLock("CT1",.T.)
	CT1->CT1_FILIAL   := xFilial("CT1")
	CT1->CT1_CONTA    := cCodC+cCod
	CT1->CT1_DESC01   := cNome
	CT1->CT1_CLASSE   := "2"
	CT1->CT1_NORMAL   := "2"
	If M->A2_EST=="EX"
		CT1->CT1_RES      := "FI"+cCod //fornecedores importacao
	Else
		CT1->CT1_RES      := "FN"+cCod //fornecedores nacionais
	Endif
    CT1->CT1_NTSPED   := "02" //Contas de passivo
	CT1->CT1_BLOQ     := "2"
	CT1->CT1_CVD02    := "1"
	CT1->CT1_CVD03    := "1"
	CT1->CT1_CVD04    := "1"
	CT1->CT1_CVD05    := "1"
	CT1->CT1_CVC02    := "1"
	CT1->CT1_CVC03    := "1"
	CT1->CT1_CVC04    := "1"
	CT1->CT1_CVC05    := "1"
	If M->A2_EST=="EX"
		CT1->CT1_CTASUP   :="20101002"
	Else

		If Alltrim(Substr(M->A2_COD,2,1)) $ '1/2/3/4/5/6/7/8/9'
			cCod    := Alltrim(Substr(M->A2_COD,2,5))
			cCodC   := "20101004" //conta /sintetica

		Else	
			CT1->CT1_CTASUP   :="20101001"

		Endif	
	Endif                 
	CT1->CT1_DTEXIS   := Ctod("01/01/1990")	
	MsUnLock("CT1")

	RecLock("CVD",.T.)
	CVD_FILIAL := xFilial("CVD")
	CVD_ENTREF := '10'
	CVD_CTAREF := "2.01.01.01.00"
	CVD_CONTA  := cCodC+cCod
	CVD_CODPLA := '001'
	MsUnLock("CVD")

    CT1->(DbSkip())

Else

	RecLock("CT1",.F.)
	CT1->CT1_DESC01   := cNome
	MsUnLock("CT1")

Endif


Return(cCodC+cCod) 
