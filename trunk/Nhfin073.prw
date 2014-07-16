/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN073  ºAutor  ³Marcos R. Roquitski º Data ³  30/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera vencimento e historico.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhfin073()

If SE2->E2_SALDO <=0
   MsgBox("Titulo baixado. Alteracao do vencimento nao autorizado!","Atencao","INFO")
   Return
Endif

SetPrvt("C_PREFIXO,C_NUM,C_PARCELA,C_TIPO,C_NATUREZA,C_PORTADO")
SetPrvt("C_FORNECEDOR,C_LOJA,D_EMISSAO,D_VENCTO,D_VENCREA,N_VALOR")
SetPrvt("C_CCUSTO1,C_CCUSTO2,C_PLNCUST,C_OBS,C_CODBARRAS,N_DESCONT")
SetPrvt("N_SALDO,C_NMFORNECEDOR,cCodig,nTotal,nConta,nVezes")
SetPrvt("I,nResto,nDv,nValor,nSaldos,nBase,l,_cValord,_cValorp")

c_Prefixo    := SE2->E2_PREFIXO
c_Num        := SE2->E2_NUM
c_Parcela    := SE2->E2_PARCELA
c_Tipo       := SE2->E2_TIPO
c_Natureza   := SE2->E2_NATUREZ
c_Portado    := SE2->E2_PORTADO
c_Fornecedor := SE2->E2_FORNECE
c_Loja       := SE2->E2_LOJA
d_Emissao    := SE2->E2_EMISSAO
d_Vencto     := SE2->E2_VENCTO
d_Vencrea    := SE2->E2_VENCREA
n_Valor      := SE2->E2_VALOR
c_Ccusto1    := SE2->E2_CC
c_Obs        := SE2->E2_OBS  
c_CodBarras  := SE2->E2_CODBAR+" " 
n_Descont    := SE2->E2_DESCONT
n_Saldo      := SE2->E2_SALDO

SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
c_NmFornecedor := Left(SA2->A2_NOME,22)


@ 200,050 To 450,500 Dialog DlgValores Title OemToAnsi("Confirmacao do valor do titulo")

@ 011,020 Say OemToAnsi("Valor Cod.Barra") Size 35,8
@ 025,020 Say OemToAnsi("Vencimento     ") Size 35,8
@ 039,020 Say OemToAnsi("Portador       ") Size 35,8
@ 053,020 Say OemToAnsi("Centro Custo   ") Size 35,8
@ 069,020 Say OemToAnsi("Observacao     ") Size 35,8
    
@ 010,070 Get n_Saldo     PICTURE "@E 999,999,999.99" When .F. Size 65,8
@ 024,070 Get d_Vencto    PICTURE "99/99/99"  Valid(fVenc()) Size 45,8
@ 038,070 Get c_Portado   PICTURE "@!" F3 "SA6" Valid(Vazio() .or. Existcpo("SA6")) Size 35,8
@ 053,070 Get c_cCusto1   PICTURE "@!" F3 "SI3" Valid(Vazio() .or. Existcpo("SI3")) Size 35,8
@ 068,070 Get c_Obs       PICTURE "@!" Size 100,8
     
@ 095,060 BMPBUTTON TYPE 01 ACTION GravaDados()
@ 095,110 BMPBUTTON TYPE 02 ACTION Close(DlgValores)
Activate Dialog DlgValores CENTERED
	
Return


Static Function GravaDados()
	If d_Vencto > SE2->E2_EMIS1
		RecLock("SE2",.F.)
		SE2->E2_VENCTO  := d_Vencto
		SE2->E2_VENCREA := d_Vencto
		SE2->E2_PORTADO := c_Portado
		SE2->E2_CC      := c_Ccusto1
	    SE2->E2_OBS     := c_Obs
		MsUnlock("SE2")
	Else
		MsgBox("** ATENCAO ** Data de vencimento devera ser maior que a data de digitiacao da Nota Fiscal. Verifique","Atencao","ALERT")	
	Endif

	Close(DlgValores)
Return(.T.)


Static Function fVenc()
Local lRet   := .T.
Local _cUser := Alltrim(GetMv("MV_FIND3"))

If Alltrim(cUserName) $  _cUser
	lRet := .T.			

	If (d_Vencto < Date())
		MsgBox("Atencao, Vencimento menor que a data do sistema nao permitido. Verifique!","Atencao","ALERT")
		lRet := .F.
	Endif

Else
	MsgBox("Usuario nao autorizado alterar data de vencimento","Atencao","ALERT")
	lRet := .F.			
Endif	

Return(lRet)