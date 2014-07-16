	/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fncon002         ³ Osmar Schimitberger  ³ Data ³21.10.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Gatilho p/gravar conta Cliente SA1 e CT1                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ESPECÍFICO PARA FUNDIÇÃO NEW HÜBNER LTDA                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#Include "rwmake.ch"
#Include "prtopdef.ch"

User Function  fncon002()
Local cCod    := Substr(M->A1_COD,3,6)
Local cCodC   := " "
Local cNome   := M->A1_NOME

If M->A1_EST=="EX" //clientes exportacao
	cCodC:="10102002"
Else //clientes nacionais
	cCodC:="10102001"
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
	If Substr(cCodc,1,1) == "1"
		CT1->CT1_NORMAL   := "1"	
	Else
		CT1->CT1_NORMAL   := "2"
	Endif	
	If M->A1_EST=="EX"
		CT1->CT1_RES      := "CE"+cCod //clientes exportacao
	Else
		CT1->CT1_RES      := "CN"+cCod //clientes nacionais
	Endif
	CT1->CT1_NTSPED   := "01"
	CT1->CT1_BLOQ     := "2"
	CT1->CT1_CVD02    := "1"
	CT1->CT1_CVD03    := "1"
	CT1->CT1_CVD04    := "1"
	CT1->CT1_CVD05    := "1"
	CT1->CT1_CVC02    := "1"
	CT1->CT1_CVC03    := "1"
	CT1->CT1_CVC04    := "1"
	CT1->CT1_CVC05    := "1"
	If M->A1_EST=="EX"
		CT1->CT1_CTASUP   :="10102002"
	Else
		CT1->CT1_CTASUP   :="10102001"
	Endif                 
	CT1->CT1_DTEXIS   := Ctod("01/01/1990")
	MsUnLock("CT1")

	RecLock("CVD",.T.)
	CVD_FILIAL := xFilial("CVD")
	CVD_ENTREF := '10'
	CVD_CTAREF := '1.01.05.02.00'
	CVD_CONTA  := cCodC+cCod
	CVD_CODPLA := '001'
	MsUnLock("CVD")

    CT1->(DbSkip())

Endif
Return(cCodC+cCod)     