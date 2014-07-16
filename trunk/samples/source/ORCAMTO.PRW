#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 06/09/01
#include "orcamto.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ORCAMTO  ³ Autor ³ Andre                 ³ Data ³ 01/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Orcamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ORCAMTO()

SetPrvt("cTamanho,Limite,aOrdem,cTitulo,nLastKey,aReturn")
SetPrvt("cTamanho,cNomProg,cNomeRel,nLastKey,Limite,aOrdem,cAlias")
SetPrvt("cDesc1,cDesc2,cDesc3,lHabil,nOpca,nTipo,aPosGru,Inclui")
SetPrvt("cMarca,cObserv")

cTamanho := "P"                    // P/M/G
Limite   := 80                     // 80/132/220
aOrdem   := {}                    // Ordem do Relatorio
Limite   := 132                    // 80/132/220
cTamanho := "P"
cTitulo  := OemToAnsi(STR0001)
cMarca   := "   "
nLastKey := 0
aReturn  := { OemToAnsi(STR0002), 1,OemToAnsi(STR0003), 2, 1, 1, "",1 }
cNomProg := "ORCAMTO"
cNomeRel := "ORCAMTO"
nLastKey := 0
cAlias   := "VS1"
cDesc1   := OemToAnsi(STR0001)
cDesc2   := ""
cDesc3   := ""
cObserv  := ""
lHabil   := .f.
nOpca    := 0
nTipo    := 18
aPosGru  := {}
Inclui   := .F.
nSemEstoque := 0

if Type("ParamIXB") == "U"
   ParamIXB := Nil
Endif

if ParamIXB == Nil
   Private cCadastro := OemToAnsi(STR0004)
   Private aRotina := { { OemToAnsi(STR0005),"AxPesqui", 0 , 1},;
                         { OemToAnsi(STR0006),"IMPORC"  , 0 , 3}}

   mBrowse( 6, 1,22,75,"VS1")
Else
   FS_ORCAMENTO(ParamIXB[1])
Endif

Return

/////////////////
Function IMPORC()

FS_ORCAMENTO(VS1->VS1_NUMORC)

Return


//////////////////////////////
Static Function FS_ORCAMENTO(cCodigo)

SetPrvt("cTipo,cOrdem,cTpoPad")

if !Pergunte("ORCAMT")
   cOrdem  := 1
   cTpoPad := "S"
   cSeqSer := 1
Else
   cOrdem  := mv_par01
   cTpoPad := if(mv_par02==1,"S","N")
   cSeqSer := mv_par03
Endif

lServer  := .f.
aImp     := RetImpWin(lServer ) // .T. Quando for no SERVER e .F. no CLIENT (Retorna o nome das impressoras instaladas)
cDrive   := "Epson.drv"
cNomeImp := "LPT2"

//cNomeRel := SetPrint(cAlias,cNomeRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil    ,cDrive,.T.  ,lServer,cNomeImp)
cNomeRel := SetPrint(cAlias,cNomeRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil)

if nLastKey = 27
   Return
Endif

//Posicionamento dos Arquivos
DbSelectArea("VS1")
DbSetOrder(1)
DbSeek(xFilial("VS1")+cCodigo)
cMarca   := VS1->VS1_CODMAR

DbSelectArea("VV1")
FG_SEEK("VV1","VS1->VS1_CHAINT",1,.f.)

DbSelectArea("VS1")
FG_Seek("SE4","VS1->VS1_FORPAG",1,.f.)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+VS1->VS1_CLIFAT)

SetDefault(aReturn,cAlias)

RptStatus({|lEnd| FS_ORCAMTO(@lEnd,cNomeRel,cAlias)},cTitulo)

Set Filter To

MS_FLUSH()

Return


//////////////////////////////////////////////
Static Function FS_ORCAMTO(lEnd,wNRel,cAlias)

SetPrvt("lin,Pag,nTotPec,nTotSer,nTotal,nTotDesP,nTotDesS")
SetPrvt("oPr,nX,aDriver,cCompac,cNormal")

aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

nTotal   := 0
nTotPec  := nTotSer  := 0
nTotDesS := nTotDesP := 0

// Impressao do Orcamento
Set Printer to &wNRel
Set Printer On
Set Device  to Printer

lin := 2
Pag := 1

FS_CABEC()
FS_DETALHE()
FS_RODAPE()

Set Printer to
Set Device  to Screen

Return


//////////////////////////
Static Function FS_CABEC()

@ lin,001 pSay &cNormal+OemToAnsi(STR0007)+VS1->VS1_NUMORC+OemToAnsi(STR0008) + DtoC(dDataBase) + OemToAnsi(STR0009) + StrZero(Pag,5)
lin+=2
@ lin,001 pSay OemToAnsi(STR0010)
lin++
@ lin,001 pSay OemToAnsi(STR0011)
lin++
@ lin,001 pSay repl([-],79)
lin++
@ lin,001 pSay OemToAnsi(STR0012) + DTOC(VS1->VS1_DATORC)
@ lin,052 pSay OemToAnsi(STR0013) + DTOC(VS1->VS1_DATVAL)
lin++
@ lin,001 pSay OemToAnsi(STR0014) + VS1->VS1_CLIFAT + "   " + SA1->A1_NOME
// If !Empty(VS1->VS1_CLIRES)
//    lin++
//    @ lin,020 pSay "Atencao de " + VS1->VS1_CLIRES
// EndIf
lin++
@ lin,001 pSay OemToAnsi(STR0015) + SA1->A1_END
@ lin,052 pSay SA1->A1_MUN+" "+SA1->A1_EST
lin++
@ lin,001 pSay OemToAnsi(STR0016) + SA1->A1_TEL
@ lin,052 pSay OemToAnsi(STR0017) + SA1->A1_TEL
lin++

if VS1->VS1_TIPORC == "2"
   @ lin,001 pSay OemToAnsi(STR0018) + VV1->VV1_CHASSI + OemToAnsi(STR0019) + VV1->VV1_PLAVEI
   lin++
   @ lin,001 pSay OemToAnsi(STR0020) + VV1->VV1_MODVEI + OemToAnsi(STR0021) + VV1->VV1_FABMOD
   lin++
endif

lin+=2

Return


////////////////////////////
Static Function FS_DETALHE()

Local bCampo := { |nCPO| Field(nCPO) }

SetPrvt("nSubTot,cGrupo,aStru,cTipSer,nSaldo")

nSubtot := 0

if VS1->VS1_TIPORC == "2"

   aStru := {}
   DbSelectArea("SX3")
   DbSetOrder(1)
   DbSeek("VS4")
   Do While !Eof() .And. x3_arquivo == "VS4"
      if x3_context # "V"
         Aadd(aStru,{x3_campo,x3_tipo,x3_tamanho,x3_decimal})
      Endif
      DbSkip()
   EndDo

   cArqTemp := CriaTrab(aStru)
   dbUseArea( .T.,,cArqTemp,"TRB", .F. , .F. )
   if cSeqSer == 2
      cChave  := "VS4_FILIAL+VS4_NUMORC+VS4_TIPSER+VS4_GRUSER+VS4_CODSER"
   Else
      cChave  := "VS4_FILIAL+VS4_NUMORC+VS4_SEQUEN"
   Endif
   IndRegua("TRB",cArqTemp,cChave,,,OemToAnsi(STR0022))
   DbSelectArea("TRB")
   DbSetOrder(1)

   DbSelectArea("VS4")
   DbSeek(xFilial("VS4")+VS1->VS1_NUMORC)
   Do While !Eof() .and. VS4->VS4_NUMORC == VS1->VS1_NUMORC
      DbSelectArea("TRB")
      RecLock("TRB",.T.)
      For i := 1 to FCOUNT()
          cCpo := aStru[i,1]
          TRB->(&cCpo) := VS4->&(Field(i))
      Next
      MsUnlock()
      DbSelectArea("VS4")
      DbSkip()
   EndDo

   DbSelectArea("TRB")
   DbGotop()

Endif

//Pecas

DbSelectArea("VS3")
DbGotop()
DbSetOrder(1)
if cOrdem == 2
   DbSetOrder(2)
Endif

if DbSeek(xFilial("VS3")+VS1->VS1_NUMORC)

   @ lin,000 pSay &cCompac+" "
   @ lin,001 pSay OemToAnsi(STR0023)
   lin+=2
   @ lin,001 pSay repl([=],132)
   lin++
   @ lin,001 pSay OemToAnsi(STR0024)
*                  1     7                           35                             66    72      80             95      103            118
   lin++
   @ lin,001 pSay repl([=],132)
   lin++

   DbSelectArea("SB1")
   DbSetOrder(7)
   DbSelectArea("SB5")
   DbSelectArea("VS3")

   cGrupo := VS3->VS3_GRUITE

   Do While !EOF() .and. VS3->VS3_NUMORC == VS1->VS1_NUMORC

      DbSelectArea("SB1")
      DbGotop()
      DbSeek(xFilial("SB1")+VS3->VS3_GRUITE+VS3->VS3_CODITE)

      DbSelectArea("SB5")
      DbGotop()
      DbSeek(xFilial("SB5")+SB1->B1_COD)

      DbSelectArea("SBM")
      DbGotop()
      DbSeek(xFilial("SBM")+VS3->VS3_GRUITE)

      DbSelectArea("SB2")
      DbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
      nSaldo := SaldoSB2()

      DbSelectArea("VS3")

      @ lin,001 pSay VS3->VS3_GRUITE
      @ lin,007 pSay VS3->VS3_CODITE
      @ lin,035 pSay SB1->B1_DESC
      @ lin,066 pSay Subs(SB5->B5_LOCALIZ,1,6)
      @ lin,072 pSay Transform(VS3->VS3_QTDITE,"@E 99,999")
      if nSaldo <= 0
         nSemEstoque++
         @ lin,079 pSay "**"
      Endif
      @ lin,081 pSay Transform(VS3->VS3_VALPEC,"@E 999,999,999.99")
      @ lin,095 pSay Transform(VS3->VS3_PERDES,"9999.99")
      @ lin,104 pSay Transform(VS3->VS3_VALDES,"@E 999,999,999.99")
      @ lin,119 pSay Transform(VS3->VS3_VALTOT,"@E 999,999,999.99")

      nTotPec  := nTotPec  + VS3->VS3_VALTOT
      nTotDesP := nTotDesP + VS3->VS3_VALDES

      if cOrdem == 2
         nSubTot := nSubTot + VS3->VS3_VALTOT
      Endif
      
      DbSkip()

      if cGrupo # VS3->VS3_GRUITE .and. cOrdem == 2
         lin++
         @ lin,001 pSay repl([-],132)
         lin++
         @ lin,001 pSay OemToAnsi(STR0025) + SBM->BM_DESC
         @ lin,060 pSay OemToAnsi(STR0026)
         @ lin,085 pSay Transform(nSubTot,"@E 999,999,999.99")
         nSubTot := 0
      Endif

      lin++

      if lin > 66
         lin := 1
         Pag := Pag + 1
         @ lin,001 pSay &cNormal+" "
         FS_CABEC()
      Endif

   EndDo

   @ lin,001 pSay repl([-],132)
   lin++
   @ lin,021 pSay OemToAnsi(STR0027)
   @ lin,042 pSay Transform(nTotDesP,"@E 999,999,999.99")
   @ lin,094 pSay OemToAnsi(STR0028)
   @ lin,119 pSay Transform(nTotPec,"@E 999,999,999.99")
   lin++

Endif

//Servicos

aTipoSer := {}

if VS1->VS1_TIPORC == "2" .and. DbSeek(xFilial("VS1")+VS1->VS1_NUMORC)
   
   lin++
   
   @ lin,000 pSay &cCompac+" "
   @ lin,001 pSay OemToAnsi(STR0029)
   lin+=2
   @ lin,001 pSay repl([=],132)
   lin++
   if cTpoPad == "N"
      @ lin,001 pSay OemToAnsi(STR0030)
*                     1     7                           35                             66    72      80             95      103            118
   Else
      @ lin,001 pSay OemToAnsi(STR0030)
*                     1     7                           35                             66    72      80             95      103            118
   Endif
   lin++
   @ lin,001 pSay repl([=],132)
   lin++

   DbSelectArea("SB1")
   DbSetOrder(7)
   DbSelectArea("TRB")

   nSubTot := 0
   cTipSer := TRB->VS4_TIPSER
   Do While !EOF() .and. TRB->VS4_NUMORC == VS1->VS1_NUMORC

      DbSelectArea("VO6")
      DbSetOrder(2)
      DbGotop()
      DbSeek(xFilial("VO6")+cMarca+TRB->VS4_CODSER)

      DbSelectArea("VOK")
      DbSetOrder(1)
      DbGotop()
      DbSeek(xFilial("VS4")+TRB->VS4_TIPSER)

      DbSelectArea("TRB")

      @ lin,001 pSay TRB->VS4_GRUSER
      @ lin,007 pSay TRB->VS4_CODSER
      @ lin,035 pSay VO6->VO6_DESSER
      @ lin,066 pSay TRB->VS4_TIPSER
      if cTpoPad == "S"
*        @ lin,071 pSay Transform(VO6->VO6_TEMFAB,"@R 99:99")
         @ lin,079 pSay Transform(TRB->VS4_VALSER,"@E 9,999,999.99")
         @ lin,091 pSay Transform(TRB->VS4_PERDES,"999.99")
         @ lin,100 pSay Transform(TRB->VS4_VALDES,"@E 9,999,999.99")
         @ lin,119 pSay Transform(TRB->VS4_VALTOT,"@E 999,999,999.99")
      Else
         @ lin,071 pSay Transform(TRB->VS4_VALSER,"@E 9,999,999.99")
         @ lin,091 pSay Transform(TRB->VS4_PERDES,"999.99")
         @ lin,100 pSay Transform(TRB->VS4_VALDES,"@E 9,999,999.99")
         @ lin,119 pSay Transform(TRB->VS4_VALTOT,"@E 999,999,999.99")
      Endif

      nTotSer  := nTotSer  + TRB->VS4_VALTOT
      nTotDesS := nTotDesS + TRB->VS4_VALDES

      if cSeqSer == 2
         nSubTot := nSubTot + TRB->VS4_VALTOT
      Endif

      DbSkip()

      if cTipSer # TRB->VS4_TIPSER .and. cSeqSer == 2
         lin++
         @ lin,001 pSay repl([-],132)
         lin++
         @ lin,001 pSay OemToAnsi(STR0031) + VOK->VOK_DESSER
         @ lin,060 pSay OemToAnsi(STR0026)
         @ lin,085 pSay Transform(nSubTot,"@E 999,999,999.99")
         nSubTot := 0
      Endif

      lin++

      if lin > 66
         lin := 1
         Pag := Pag + 1
         @ lin,001 pSay &cNormal+" "
         FS_CABEC()
      Endif

   EndDo

   @ lin,001 pSay repl([-],132)
   lin++
   @ lin,021 pSay OemToAnsi(STR0032)
   @ lin,042 pSay Transform(nTotDesS,"@E 999,999,999.99")
   @ lin,094 pSay OemToAnsi(STR0033)
   @ lin,119 pSay Transform(nTotSer,"@E 999,999,999.99")

   DbSelectArea("TRB")
   TRB->(DbCloseArea("TRB"))

Endif

if nSemEstoque > 0
   @ lin++,001 pSay OemToAnsi(STR0034)
Endif

@ lin,001 pSay &cNormal+" "

Return


////////////////////
Static Function FS_RODAPE()

lin+=2

if lin > 53
   lin := 1
   Pag := Pag + 1
   FS_CABEC()
   lin++
Endif

if lin < 45
   lin := 45
Endif

@ lin,001 pSay OemToAnsi(STR0035)

cKeyAce := VS1->VS1_OBSMEM + [001]
DbSelectArea("SYP")
DbSetOrder(1)
FG_SEEK("SYP","cKeyAce",1,.f.)

do while xFilial("SYP")+VS1->VS1_OBSMEM == SYP->YP_FILIAL+SYP->YP_CHAVE .and. !eof()

   nPos := AT("\13\10",SYP->YP_TEXTO)
   if nPos > 0
      nPos-=1
   Else
      nPos := Len(SYP->YP_TEXTO)
   Endif
   cObserv := Substr(SYP->YP_TEXTO,1,nPos)

   @ lin,013 pSay cObserv
   lin++

   if lin > 66
      lin := 1
      Pag := Pag + 1
      @ lin,001 pSay &cNormal+" "
      FS_CABEC()
   Endif

   DbSkip()

enddo

nTotal := nTotPec + nTotSer

lin++
@ lin,001 pSay OemToAnsi(STR0036)
lin+=2
@ lin,001 pSay OemToAnsi(STR0037) + Transform(nTotPec,"@E 999,999,999.99")
@ lin,030 pSay OemToAnsi(STR0038) + VS1->VS1_FORPAG + "-" + SE4->E4_DESCRI

lin++
* @ lin,001 pSay OemToAnsi(STR0027)
* @ lin,022 pSay Transform(nTotDesP,"@E 999,999,999.99")
* lin++
@ lin,001 pSay OemToAnsi(STR0039) + Transform(nTotSer,"@E 999,999,999.99")
lin++
* @ lin,001 pSay OemToAnsi(STR0032)
* @ lin,022 pSay Transform(nTotDesS,"@E 999,999,999.99")
* lin++
@ lin,001 pSay OemToAnsi(STR0040) + Transform(nTotal,"@E 999,999,999.99")
lin++

Return


//////////////////////////
Static Function LEDriver()

Local aSettings := {}
Local cStr, cLine, i

if !File(__DRIVER)
        aSettings := {"CHR(15)","CHR(18)","CHR(15)","CHR(18)","CHR(15)","CHR(15)"}
Else
        cStr := MemoRead(__DRIVER)
        For i:= 2 to 7
                cLine := AllTrim(MemoLine(cStr,254,i))
                AADD(aSettings,SubStr(cLine,7))
        Next
Endif

Return(aSettings)
