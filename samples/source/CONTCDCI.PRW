/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CONTCDCI ³ Autor ³ Andr‚                 ³ Data ³ 01/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao do Contrato CDCI                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CONTCDCI()
************************

SetPrvt("cTamanho,Limite,aOrdem,cTitulo,nLastKey,aReturn,cTitulo")
SetPrvt("cNomProg,cNomRel,nLastKey,Limite,aOrdem,cAlias,cDrive,lServer")
SetPrvt("cDesc1,cDesc2,cDesc3,lHabil,nOpca,nTipo,aPosGru,Inclui,cString,aRegistros" )

cDesc1     :=""
cDesc2     :=""
cDesc3     :=""
cString    :="SD1"
aRegistros := {}
cTitulo    := OemToAnsi("Emissao do Contrato de CDCI")
cTamanho   := "M"
aReturn    :=  { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cNomprog   := "CONTCDCI"
nLastKey   := 0
cNomRel    := "CONTCDCI"

cDrive     := GetMv("MV_DRVCDC")
cNomeImp   := GetMv("MV_PORCDC")

cTamanho := "P"                    // P/M/G
Limite   := 80                     // 80/132/220
aOrdem   := {}                     // Ordem do Relatorio
cTitulo  := "Contrato CDCI"
nLastKey := 0
aReturn  := { "Zebrado", 1,"Administracao", 2, 1, 1, "",1 }
cTitulo  := "Nota Fiscal de Saida"
cTamanho := "P"
cNomProg := "OFIOR030"
cNomeRel := "CONTCDCI"
nLastKey := 0
Limite   := 132                    // 80/132/220
aOrdem   := {}                     // Ordem do Relatorio
cAlias   := "SEM"
cDesc1   := "Contrato CDCI"
cDesc2   := ""
cDesc3   := ""
lHabil   := .f.
nOpca    := 0
nTipo    := 18
aPosGru  := {}
lServer  := .f.
Inclui   := .F.

If ParamIXB == Nil
   If !PERGUNTE("OFR360")
      Return
   EndIf
Else
   mv_par01 := ParamIXB[1]
//   mv_par02 := ParamIXB[2]
EndIf
/*
DbSelectArea("VS1")
DbSetOrder(3)
DbSeek(xFilial("VS1")+mv_par01+mv_par02)
*/
DbSelectArea("SEM")              
DbSetOrder(1)
DbGotop()
&&if DbSeek(xFilial("SEM")+VS1->VS1_CTCDCI)
//if DbSeek(xFilial("SEM")+MV_PAR01+MV_PAR02)
if DbSeek(xFilial("SEM")+MV_PAR01)
   DbSelectArea("SM0")
   DbGotop()

   DbSelectArea("SEN")
   DbSetOrder(1)
   DbGotop()
   DbSeek(xFilial("SEN")+SEM->EM_PLANO)

   DbSelectArea("SA1")
   DbSeek(xFilial("SA1")+SEM->EM_CLIENTE+SEM->EM_LOJA)

   aImp     := RetImpWin(lServer ) // .T. Quando for no SERVER e .F. no CLIENT (Retorna o nome das impressoras instaladas)

   cNomRel := SetPrint(cString,cNomRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil    ,cDrive,.T.  ,lServer,cNomeImp)

   If nLastKey == 27
      Return
   Endif

   SetDefault(aReturn,cAlias)
   RptStatus({|lEnd| FS_ContCDCI(@lEnd,cNomeRel,cAlias)},cTitulo)
   Set Filter To
Else
&&   MsgInfo("Venda nao possui Contrato de CDCI gerado...","Atencao !")
Endif

Return

Static Function FS_ContCDCI(lEnd,cNomRel,cAlias)
**********************************************

SetPrvt("nValorEnt,nQtdPar,nValorFin,dPriVen,nLin")

nValorEnt  := 0
nQtdPar    := 0
nValorFin  := 0
dPriVen    := cTod("")

// Impressao do Contrato CDCI
Set Printer to &cNomRel
Set Printer On
Set Device  to Printer

nLin:=19

@ nLin, 027 pSay SEM->EM_CONTRAT
@ nLin, 070 pSay SEM->EM_EMISSAO

nLin+=2

// Consumidor

@ nLin, 015 pSay SA1->A1_NOME
@ nLin, 062 pSay SA1->A1_CGC
nLin++
@ nLin, 015 pSay SA1->A1_END
@ nLin, 062 pSay SA1->A1_BAIRRO
nLin++
@ nLin, 015 pSay SA1->A1_MUN
@ nLin, 035 pSay SA1->A1_EST
@ nLin, 042 pSay SA1->A1_CEP
@ nLin, 062 pSay SA1->A1_TEL

nLin+=2

// Vendedora/Interveniente

@ nLin, 015 pSay SM0->M0_NOMECOM
@ nLin, 062 pSay SM0->M0_CGC
nLin++
@ nLin, 015 pSay SM0->M0_ENDCOB
@ nLin, 062 pSay SM0->M0_BAIRCOB
nLin++
@ nLin, 015 pSay SM0->M0_CIDCOB
@ nLin, 035 pSay SM0->M0_ESTCOB
@ nLin, 042 pSay SM0->M0_CEPCOB
@ nLin, 062 pSay SM0->M0_TEL

nLin+=8

@ nLin, 008 pSay transform(SEM->EM_VALOR,"@E 999,999,999.99")
@ nLin, 028 pSay transform(SEM->EM_ENTRADA,"@E 999,999,999.99")
@ nLin, 045 pSay transform(SEM->EM_TOTFIN,"@E 999,999,999.99")
@ nLin, 060 pSay transform((SEM->EM_TOTFIN/100)*SEM->EM_COEFIC,"@E 999,999,999.99")

nLin+=2

@ nLin, 028 pSay transform(SEM->EM_TOTFIN,"@E 999,999,999.99")
@ nLin, 045 pSay transform(SEM->EM_PRESTAC,"@E 999,999,999.99")
@ nLin, 060 pSay transform(SEM->EM_PRESTAC*SEN->EN_MAXPARC,"@E 999,999,999.99")

nLin+=2

@ nLin, 020 pSay transform(SEN->EN_TAXA,"@E 9999.9999")
@ nLin, 035 pSay transform(SEN->EN_COEF,"@E 9999.9999")

nLin+=2

@ nLin, 005 pSay SEM->EM_PLANO
@ nLin, 012 pSay SEN->EN_CARENC
@ nLin, 020 pSay SEN->EN_RAZAO
@ nLin, 025 pSay SEN->EN_MAXPARC
@ nLin, 030 pSay SEM->EM_DTINI
@ nLin, 042 pSay ((SEM->EM_DTINI)+(SEN->EN_CARENC+(SEN->EN_RAZAO*SEN->EN_MAXPARC)))
@ nLin, 055 pSay SEM->EM_NRONOTA+" - "+SEM->EM_SERIE

Set Printer to
Set Device  to Screen

Return
