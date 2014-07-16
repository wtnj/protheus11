/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN026  ºAutor  ³Marcos R. Roquitski º Data ³  02/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra relacionamento Nota fiscal com Fatura.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico WHB.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhfin026()

SetPrvt("NRECNO,NORDER,CPREFIXO,CNUM,CPARCELA,CFATURA")
SetPrvt("CCLIENTE,CLOJA,LSAIDA,NTOTPAI,NTOTFILHO,ASTRUCT")
SetPrvt("MARQTRAB,MINDTRAB,ASTRU2,MARQTRAC,ACAMPOS1,ACAMPOS2")
SetPrvt("AROTINA,CCADASTRO,LCANCELA,CSTRING,CDESC1,CDESC2")
SetPrvt("CDESC3,CTAMANHO,ARETURN,CNOMEPROG,ALINHA,NLASTKEY")
SetPrvt("LEND,CTITULO,CABEC1,CABEC2,CABEC3,CCANCEL")
SetPrvt("M_PAG,CPERG,WNREL,NAPS,NTIPO,NLIN")

nRecno    := SE1->(Recno())
nOrder    := SE1->(IndexOrd())
cPrefixo  := SE1->E1_PREFIXO
cNum      := SE1->E1_NUM
cParcela  := SE1->E1_PARCELA
cFatura   := SE1->E1_FATURA
cCliente  := SE1->E1_CLIENTE 
cLoja     := SE1->E1_LOJA
lSaida    := .F.
nTotPai   := 0
nTotFilho := 0

aStruct  := {}
AADD(aStruct,{"DT_PREFIXO",  "C",03,0})
AADD(aStruct,{"DT_NUM",      "C",06,0})
AADD(aStruct,{"DT_PARCELA",  "C",01,0})
AADD(aStruct,{"DT_TIPO",     "C",03,0})
AADD(aStruct,{"DT_CLIENTE",  "C",06,0})
AADD(aStruct,{"DT_LOJA",     "C",02,0})
AADD(aStruct,{"DT_VALLIQ",   "N",14,2})
AADD(aStruct,{"DT_DESCONT",  "N",14,2})
AADD(aStruct,{"DT_JUROS",    "N",14,2})
AADD(aStruct,{"DT_MULTA",    "N",14,2})
AADD(aStruct,{"DT_VALOR",    "N",14,2})
AADD(aStruct,{"DT_CC",       "C",09,0})
AADD(aStruct,{"DT_CC2",      "C",04,0})
AADD(aStruct,{"DT_MOEDA",    "N",02,0})
AADD(aStruct,{"DT_PAGTO",    "D",08,0})
AADD(aStruct,{"DT_NUMBOR",   "C",06,0})
AADD(aStruct,{"DT_MARCA",    "C",01,0})
AADD(aStruct,{"DT_NATUREZ",  "C",10,0})
AADD(aStruct,{"DT_PORTADO",  "C",03,0})
AADD(aStruct,{"DT_NOMFOR",   "C",20,0})
AADD(aStruct,{"DT_EMISSAO",  "D",08,0})
AADD(aStruct,{"DT_VENCTO",   "D",08,0})
AADD(aStruct,{"DT_VENCREA",  "D",08,0})
AADD(aStruct,{"DT_SALDO",    "N",14,2})
AADD(aStruct,{"DT_PLNCUST",  "C",15,0})
AADD(aStruct,{"DT_VENCORI",  "D",08,0})
AADD(aStruct,{"DT_LOJORIG",  "C",02,0})
AADD(aStruct,{"DT_FATURA",   "C",06,0})
AADD(aStruct,{"DT_VLRENT",   "N",14,2})
AADD(aStruct,{"DT_CGC",      "C",14,0})
AADD(aStruct,{"DT_FORORIG",  "C",06,0})
mArqTrab := CriaTrab(aStruct,.t.)
mIndTrab := Left(mArqTrab,8)+".NTX"
USE &mArqTrab Alias DET New Exclusive
Index on DET->DT_PREFIXO + DET->DT_NUM + DET->DT_PARCELA to &mIndTrab
DbSelectArea("DET")
DbCloseArea()

Use &mArqTrab index &mIndTrab Alias DET New Exclusive

aStru2 := {}
AADD(aStru2,{"DF_PREFIXO",  "C",03,0})
AADD(aStru2,{"DF_NUM",      "C",06,0})
AADD(aStru2,{"DF_PARCELA",  "C",01,0})
AADD(aStru2,{"DF_TIPO",     "C",03,0})
AADD(aStru2,{"DF_VENCTO",   "D",08,0})
AADD(aStru2,{"DF_VALOR",    "N",14,2})
AADD(aStru2,{"DF_FATURA",   "C",06,0})
AADD(aStru2,{"DF_CLIENTE",  "C",06,0})
AADD(aStru2,{"DF_LOJA",     "C",02,0})
AADD(aStru2,{"DF_VALLIQ",   "N",14,2})
AADD(aStru2,{"DF_CC",       "C",09,0})
AADD(aStru2,{"DF_CC2",      "C",04,0})

mArqTrac := CriaTrab(aStru2,.t.)
USE &mArqTrac Alias TMP New Exclusive

MsAguarde ( {|lEnd| fDetalhes() },"Processando","Aguarde...",.T.)
DbSelectArea("DET")
DET->(DbGotop())
If Reccount() <=0
   MsgBox("Nao foi encontrado o(s) titulo(s) origem!","Atencao","INFO")
   DbSelectArea("DET")
   DbCloseArea()
   
   DbSelectArea("TMP")
   DbCloseArea()
   
   fErase(mArqTrab)
   fErase(mArqTrac)
   fErase(mIndTrab)
	fRedefina()
   Return
Endif

DbSelectArea("DET")
DET->(DbGotop())
aCampos1 := {}
Aadd(aCampos1,{"DT_PREFIXO","Prefixo","@!" ,"03"})
Aadd(aCampos1,{"DT_NUM","Numero","@!","06"})
Aadd(aCampos1,{"DT_PARCELA","Parcela","@!","01"})
Aadd(aCampos1,{"DT_FATURA","Fatura","@!","06"})
Aadd(aCampos1,{"DT_VENCTO","Vencimento","99/99/99" ,"08"})
Aadd(aCampos1,{"DT_VALOR","Valor","@E 999,999,999.99","14,2"})

DbSelectArea("TMP")
TMP->(DbGotop())
aCampos2 := {}
AADD(aCampos2,{"DF_PREFIXO","Prefixo","@!","03"})
AADD(aCampos2,{"DF_NUM","Numero","@!","06"})
AADD(aCampos2,{"DF_PARCELA","Parcela","@!","01"})
AADD(aCampos2,{"DF_FATURA","Fatura","@!","06"})
AADD(aCampos2,{"DF_VENCTO","Vencimento","99/99/99","08"})
Aadd(aCampos2,{"DF_VALOR","Valor","@E 999,999,999.99","14,2"})

@ 100,041 To 470,575 Dialog dlgComp Title "Relacao N. Fiscal e Fatura(s)"
@ 005,010 Say OemToAnsi("N.Fiscal/Fatura") Size 45,8
@ 068,180 Say OemToAnsi("Total") Size 20,8
@ 068,200 Get nTotPai Pict "@E 999,999,999.99" When .F. Size 50,8

@ 078,010 Say OemToAnsi("N.Fiscal/Fatura") Size 45,8
@ 147,180 Say OemToAnsi("Total") Size 20,8
@ 147,200 Get nTotFilho Pict "@E 999,999,999.99" When .F. Size 50,8

@ 012,10 TO 065,260 Browse "DET" Fields aCampos1
@ 085,10 TO 145,260 Browse "TMP" Fields aCampos2

@ 170,210 Button "_Sair" SIZE 40,10 Action fFecha()

Activate Dialog dlgComp Centered Valid fSaida()

Return

Static Function fFecha()
   lSaida := .T.
   DbSelectArea("DET")
   DbCloseArea()
   DbSelectArea("TMP")
   DbCloseArea()
   Close(dlgComp)
   fErase(mArqTrab)
   fErase(mArqTrac)
   fErase(mIndTrab)
   fRedefina()
Return(.T.)


Static Function fDetalhes()

   nTotPai   := 0
   nTotFilho := 0

   DbSelectArea("TMP")
   Zap

   DbSelectArea("DET")
   Zap
   
   If cFatura == "NOTFAT"


		If !Empty(Alltrim(cNum)) .and. !Empty(Alltrim(cFatura))

	      SE1->(DbSetOrder(18))
	      SE1->(DbGotop())
	      SE1->(DbSeek(xFilial("SE1")+cNum))

	      While !SE1->(Eof()) .AND. SE1->E1_FILIAL == xFilial("SE1") ;
   	                       .AND. SE1->E1_FATURA == cNum

	         MsProcTxt("Fatura: "+SE1->E1_FATURA)

	         If SE1->E1_CLIENTE == cCliente .and. SE1->E1_LOJA == cLoja
	            ApTitulos()
	            nTotPai := nTotPai + SE1->E1_VALOR
	         Endif
	         SE1->(DbSkip())

	      Enddo

	      DbSelectArea("DET")
	      DET->(DbGotop())

	      SE1->(DbSetOrder(17))
	      SE1->(DbGotop())
	      SE1->(DbSeek(xFilial("SE1")+DET->DT_FATURA))
	      While !SE1->(Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") ;
	                          .And. SE1->E1_NUM == DET->DT_FATURA
	         MsProcTxt("Titulo: "+SE1->E1_PREFIXO + SE1->E1_NUM)
	         If SE1->E1_CLIENTE == DET->DT_CLIENTE .and. SE1->E1_LOJA == DET->DT_LOJA
	            ApFilhos()
	            nTotFilho := nTotFilho + SE1->E1_VALOR
	         Endif
	         SE1->(DbSkip())
	      Enddo

      Endif

   Else
			
		If !Empty(Alltrim(cNum)) .and. !Empty(Alltrim(cFatura))
				
	      SE1->(DbSetOrder(18))
	      SE1->(DbGotop())
	      SE1->(DbSeek(xFilial("SE1")+cFatura))
	      While !SE1->(Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") ;
   	                       .And. SE1->E1_FATURA == cFatura
	         MsProcTxt("Titulo: "+SE1->E1_PREFIXO + SE1->E1_NUM)
	         If SE1->E1_CLIENTE == cCliente .and. SE1->E1_LOJA == cLoja
	            ApFilhos()
	            nTotFilho := nTotFilho + SE1->E1_VALOR
	         Endif
	         SE1->(DbSkip())
	      Enddo

	      DbSelectArea("TMP")
	      TMP->(DbGotop())

	      SE1->(DbSetOrder(17))
	      SE1->(DbGotop())
	      SE1->(DbSeek(xFilial("SE1")+TMP->DF_FATURA))
	      While !SE1->(Eof()) .AND. SE1->E1_FILIAL == xFilial("SE1") ;
   	                       .AND. SE1->E1_NUM == TMP->DF_FATURA
	         MsProcTxt("Fatura: "+SE1->E1_FATURA)
	         If SE1->E1_CLIENTE == TMP->DF_CLIENTE .and. SE1->E1_LOJA == TMP->DF_LOJA
	            ApTitulos()
	            nTotPai := nTotPai + SE1->E1_VALOR
	         Endif
	         SE1->(DbSkip())
	      Enddo
		Endif
	Endif
Return(.T.)
   
   
Static Function ApTitulos()
   RecLock("DET",.T.)
   DET->DT_PREFIXO   := SE1->E1_PREFIXO
   DET->DT_NUM       := SE1->E1_NUM
   DET->DT_PARCELA   := SE1->E1_PARCELA
   DET->DT_TIPO      := SE1->E1_TIPO
   DET->DT_CLIENTE   := SE1->E1_CLIENTE
   DET->DT_LOJA      := SE1->E1_LOJA
   DET->DT_VALLIQ    := SE1->E1_VALLIQ
   DET->DT_DESCONT   := SE1->E1_DESCONT
   DET->DT_JUROS     := SE1->E1_JUROS
   DET->DT_MULTA     := SE1->E1_MULTA
   DET->DT_VALOR     := SE1->E1_VALOR
   DET->DT_PAGTO     := DATE()
   DET->DT_MARCA     := "*"
   DET->DT_NATUREZ   := SE1->E1_NATUREZ
   DET->DT_PORTADO   := SE1->E1_PORTADOR
   DET->DT_EMISSAO   := SE1->E1_EMISSAO
   DET->DT_VENCTO    := SE1->E1_VENCTO
   DET->DT_VENCREA   := DataValida(SE1->E1_VENCREA)
   DET->DT_SALDO     := SE1->E1_SALDO
   DET->DT_VENCORI   := SE1->E1_VENCORI
   DET->DT_FATURA    := SE1->E1_FATURA 
   MsUnlock("DET")
Return


Static Function ApFilhos()
   RecLock("TMP",.T.)
   TMP->DF_PREFIXO   := SE1->E1_PREFIXO
   TMP->DF_NUM       := SE1->E1_NUM
   TMP->DF_PARCELA   := SE1->E1_PARCELA
   TMP->DF_VALOR     := SE1->E1_VALOR
   TMP->DF_VENCTO    := SE1->E1_VENCTO
   TMP->DF_FATURA    := SE1->E1_FATURA 
   TMP->DF_TIPO      := SE1->E1_TIPO
   TMP->DF_CLIENTE   := SE1->E1_CLIENTE
   TMP->DF_LOJA      := SE1->E1_LOJA
   TMP->DF_VALLIQ    := SE1->E1_VALLIQ
   MsUnlock("TMP")
Return

Static Function fRedefina()
   aRotina := { { "Pesquisar"           , "AxPesqui"  , 0 , 1},;
                { "Visualizar"          , 'U_NHFIN026', 0 , 2}}

   cCadastro := "Refaturamento"

   DbSelectArea("SE1")
   SE1->(DbSetOrder(nOrder))
   SE1->(DbGoTo(nRecno))

Return

Static Function fSaida()
If lSaida 
   Return(.T.)
Else
   Return(.F.)
Endif
Return

