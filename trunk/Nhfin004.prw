/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Nhfin004 ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 26/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime relatorio de borderos                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Contas a Pagar - SisPag                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch" 

User Function Nhfin004()

SetPrvt("W_PAR06,W_PAR07,W_PAR08,CTESTBANCO,RARQUIVO,CHAMAPROG")
SetPrvt("ASTRUCT,CARQ,CIND,LGPS,CSTRING,CDESC1")
SetPrvt("CDESC2,CDESC3,CTAMANHO,ARETURN,CNOMEPROG,ALINHA")
SetPrvt("NLASTKEY,LEND,CTITULO,CABEC1,CABEC2,CABEC3")
SetPrvt("CCANCEL,M_PAG,CPERG,WNREL,NLIMITE,LI")
SetPrvt("COCORRENCIA,DPREPDATA,DBAIXA,NTIPO,MRETORNO,WSOMA01")
SetPrvt("WSOMA02,WSOMA03,WSOMA04,WQTD01,WQTD02,WQTD03")
SetPrvt("WQTD04,BBORDERO,BTOTAL,BMATRIZ,XTOTAL,XQTD")
SetPrvt("WBUSPAG,ANUMBOR,MNUMBOR,CRETORNO,NVLREFE,CGPSCDP")
SetPrvt("WVALOR,CNOMEFOR,ARO,WBUSFOR,")

If !Pergunte("AFI300",.T.)
  Return
Endif
   
SX1->(DbSeek("AFI30006"))
w_PAR06 := Subst(SX1->X1_CNT01,1,3)
SX1->(DbSeek("AFI30007"))
w_PAR07 := Subst(SX1->X1_CNT01,1,5)
SX1->(DbSeek("AFI30008"))
w_PAR08 := Subst(SX1->X1_CNT01,1,10)

SA6->(DbSetOrder(1))
SA6->(DbSeek(xFilial("SA6")+w_PAR06+w_PAR07+w_PAR08,.F.))
If !SA6->(Found())
  MsgBox("Banco / Agencia / Conta nao Encontrado(s)","Atencao","INFO")
  Return
Endif

cTESTBANCO := SA6->A6_COD

rArquivo := Trim(mv_PAR04)
If !File(rArquivo)
   MsgBox("Arquivo de Entrada nao Localizado: "+ rArquivo,"ERRO","INFO")
   Return

Endif

CHAMAPROG := .F.

SA2->(DbSetOrder(1))
SE2->(DbSetOrder(1))
SEB->(DbSetOrder(1))
SEA->(DbSetOrder(1))
SED->(DbSetOrder(1))

aStruct:={{ "FILLER01","C",013,0},;
          { "SEGMENTO","C",001,0},;
          { "FILLER02","C",226,0}}
cArq := CriaTrab(aStruct,.t.)
cInd := Left(cArq,8)+".NTX"
USE &cArq Alias TRB New Exclusive
Append From (rArquivo) SDF

Dele For SEGMENTO <> "N"
Pack
TRB->(DbGotop())

If Reccount() > 0
   lGps := .T.

Else

   Append From (rArquivo) SDF
   Dele For SEGMENTO <> "A"  .and. SEGMENTO <> "J"
   Pack
   TRB->(DbGotop())
   lGps := .F.

Endif


TRB->(DbGoTop())
INDEX ON SUBSTR(TRB->FILLER02,217,2) TO &cInd

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cString   := "TRB"
cDesc1    := "Listagem Retorno - SisPag."
cDesc2    := "Este programa gera o relat¢rio com as ocorrencias do Arquivo Retorno"
cDesc3    := "Sispag. Se houver, titulos pagos, baixa e contabiliza os mesmos."
cTamanho  := IIF(lGps,"G","M")
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cNomeprog := "NHFIN004"
aLinha    := { }
nLastKey  := 0 
lEnd      := .f. 
cTitulo   := IIF(lGps,"Relatorio de Ocorrencias - GPS  I.N.S.S "+Trim(mv_par04),"Relatorio de Ocorrencias - Retorno SisPag "+Trim(mv_par04))
cabec1    := ""
cabec2    := ""
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
m_pag     := 1  //Variavel que acumula numero da pagina
cPerg     := "NFIN004"
wnrel     := "NFIN004"
nLimite   := IIF(lGps,220,132)
li        := 99
cOcorrencia := " "
dPrepData := Ctod(Space(08))
dBaixa     := Ctod(Space(08))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",,cTamanho)
If nLastKey == 27
   Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o tipo do relat¢rio                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))


If lGps
   RptStatus ({|| fDetalheg() })
Else
   RptStatus ({|| fDetalhes() })
Endif

Return

Static Function fDetalhes()
******************

   mRETORNO := .T.
   wSOMA01  := wSOMA02 := wSOMA03 := wSOMA04 := 0
   wQTD01   := wQTD02  := wQTD03  := wQTD04  := 0
   bBORDERO := bTOTAL  := 0
   bMatriz  := {  }
   xTOTAL   := xQTD := 0
   wBUSPAG  := SPACE(19)

   If TRB->SEGMENTO == "A"
      wBUSPAG := Substr(TRB->FILLER02,60,19)
   Elseif TRB->SEGMENTO == "J"
      wBUSPAG := Substr(TRB->FILLER02,183,19)
   Elseif TRB->SEGMENTO == "N"
      wBUSPAG := Substr(TRB->FILLER02,182,19)
   Endif
   SE2->(DbSeek(xFilial("SE2")+wBUSPAG))
   If SE2->(Found())
      mNUMBOR := SE2->E2_NUMBOR  
  	   aNUMBOR := SE2->E2_NUMBOR  
      Alert(wBUSPAG)
   Else 
	   If Empty(SE2->E2_NUMBOR)
   	   SEA->(DbSetOrder(1))
	      SEA->(DbSeek(xFilial("SEA")+wBUSPAG))
   	   If SEA->(Found())
      	   aNUMBOR := SEA->EA_NUMBOR
	      Endif
	   Endif
	Endif   

   mNUMBOR := SE2->E2_NUMBOR
   TRB->(Dbgotop())
   SetRegua(TRB->(RecCount()))

   While !TRB->(Eof())

      wBUSPAG  := SPACE(19)
      cRetorno := SPACE(02)

      If TRB->SEGMENTO == "A"
         wBUSPAG := Substr(TRB->FILLER02,60,19)
         nVlrEfe := Substr(TRB->FILLER02,149,20)
      Elseif TRB->SEGMENTO == "J"
         wBUSPAG := Substr(TRB->FILLER02,169,19)
         nVlrEfe := Substr(TRB->FILLER02,139,15)
      Elseif TRB->SEGMENTO == "N"
         wBUSPAG  := Substr(TRB->FILLER02,182,19)
      Endif
      cRetorno := Substr(TRB->FILLER02,217,02)

      SE2->(DbSeek(xFilial("SE2")+wBUSPAG))
      If !SE2->(Found())
         TRB->(DbSkip())
         Loop
      Endif

      SED->(DbSeek("  "+SE2->E2_NATUREZ))
      If SED->(Found())
         cGpsCdp := SED->ED_CODGPS
      Else
         cGpsCdp := "2100"
      Endif


      If Empty(SE2->E2_NUMBOR)
         SEA->(DbSetOrder(1))
         SEA->(DbSeek(xFilial("SEA")+wBUSPAG))
         If SEA->(Found())
            aNUMBOR := SEA->EA_NUMBOR
         Else
            aNUMBOR := "!!!!!!"
         Endif
      Endif

      If SE2->E2_NUMBOR <> mNUMBOR .and. mRETORNO == .T.
         li := li + 2
         @ li,02 pSay "TOTAL BORDERO "+mNUMBOR+"............: "
         @ li,pCol()+3 pSay TRANSFORM(bBORDERO,"@E 9,999")
         @ li,48     pSay TRANSFORM(bTOTAL,"@E 99,999,999.99")
         li := li + 2
         @ li,00 pSay " "
         bBORDERO := 0
         bTOTAL   := 0
      Endif

      If Substr(TRB->FILLER02,217,2) <> cRetorno .AND. mRetorno == .T.
         li := li + 1
         @ li,02 pSay "TOTAL - "+Left(SEB->EB_DESCRI,29)
         @ li,pCol() pSay TRANSFORM(xQTD,"@E 9,999")
         @ li,48     pSay TRANSFORM(xTOTAL,"@E 99,999,999.99")
         If Substr(TRB->FILLER02,217,2) <> "00"
            mRetorno := .F.
         Endif
         xTOTAL := xQTD := 0
      Endif

      If dPrepData <> dBAIXA .and. cRetorno == "00"
         @ pRow()+2,02 pSay "TOTAL TITULOS AGENDADOS......: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD01,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA01,"@E 99,999,999.99")
         @ pRow()+1,02 pSay "TOTAL TITULOS PAGOS..........: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD02,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA02,"@E 99,999,999.99")
         @ pRow()+1,02 pSay "TOTAL TITULOS REJEITADOS.....: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD03,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA03,"@E 99,999,999.99")
         @ pRow()+1,02 pSay "TOTAL OUTRAS OCORRENCIAS.....: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD04,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA04,"@E 99,999,999.99")
         wSOMA01 := wSOMA02 := wSOMA03 := wSOMA04 := 0
         wQTD01 := wQTD02 := wQTD03 := wQTD04 := 0
         bBORDERO := bTOTAL := 0
         xQTD   :=  0
         xTOTAL := 0
         li := 64
      Endif
   
      If li >= 59 .or. SUBSTR(FILLER02,217,2) <> cRetorno
         Cabec(cTitulo,Cabec1,Cabec2,cNomeProg,cTamanho,nTipo)
         @ li,000 pSay replicate("*",132)
         @ li+1,000 pSay "* Tipo   Pref/Titulo/Parc Venc/Pagto Bordero       Valor       Fornecedor                       Ocorrencia          "
         @ li+1,131 pSay "*"
         @ li+2,000 pSay replicate("*",132)
         li := li + 3
      Endif
      li := li + 1
   
      If TRB->SEGMENTO == "N"
         @ li,03 pSay cGpsCdp
      Else
         @ li,03 pSay W_PAR06
      Endif

      @ li,11 pSay SE2->E2_PREFIXO + " " + SE2->E2_NUM + " " + SE2->E2_PARCELA

      dPrepData := SE2->E2_VENCREA
      @ li,27 pSay dPrepData
      @ li,38 pSay SE2->E2_NUMBOR

      wVALOR  := Round( SE2->E2_VALOR + SE2->E2_MULTA - SE2->E2_DESCONT, 2 )
      nVlrEfe := Round( ( Val(nVlrEfe) / 100 ) ,2)

      //ALteracao feita p/ Verificar o retorno do banco com a Base SE2.

      If Round(wValor - nVlrEfe,2) == 0
         wValor := nVlrEfe
      Else
         cRetorno := "DF" // DF - Tipo criado manual p/ocorrencia de retorno do banco verso SE2
      Endif

      @ li,47 pSay TRANSFORM(wVALOR,"@E 999,999,999.99")

      cNomeFor := SPACE(30)
      If TRB->SEGMENTO == "N"
         cNomeFor := SE2->E2_HIST
         If !Empty(SE2->E2_FORORIG)
            SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORORIG+SE2->E2_LOJORIG))
            If SA2->(Found())
               cNomeFor := Left(SA2->A2_NOME,30)
            Endif
         Endif

      Else
         SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE + SE2->E2_LOJA))
         If SA2->(Found())
            cNomeFor := Left(SA2->A2_NOME,30)
         Endif
      Endif
      @ li,63 pSay cNomeFor


      fOcorrencia()// Substituido pelo assistente de conversao do AP5 IDE em 25/03/02 ==>       Execute(fOcorrencia)
      @ li,96 pSay cRetorno + " " + cOcorrencia


      xTOTAL := xTOTAL + wVALOR
      xQTD   := xQTD + 1

      If     Subst(TRB->FILLER02,217,2) == "BD"
         wQTD01   := wQTD01 + 1
         wSOMA01  := wSOMA01 + wVALOR
         bBORDERO := bBORDERO + 1
         bTOTAL   := bTOTAL + wVALOR

      Elseif Subst(TRB->FILLER02,217,2) == "00"

         dPrepData := SE2->E2_VENCREA
         dBAIXA    := dPrepData

         wQTD02   := wQTD02 + 1
         wSOMA02  := wSOMA02 + wVALOR
         bBORDERO := bBORDERO + 1
         bTOTAL   := bTOTAL + wVALOR

      Elseif Subst(TRB->FILLER02,217,2) == "RJ"
         wQTD03   := wQTD03 + 1
         wSOMA03  := wSOMA03 + wVALOR

      Else
         wQTD04   := wQTD04 + 1
         wSOMA04  := wSOMA04 + wVALOR

      Endif

      cRetorno := SUBSTR(TRB->FILLER02,217,2)
      mNumbor  := SE2->E2_NUMBOR
    
      TRB->(DbSkip())
      dPrepData := SE2->E2_VENCREA
      IncRegua()

   Enddo
   
   If li > 50
      Eject
      Cabec(cTitulo,Cabec1,Cabec2,cNomeProg,cTamanho,nTipo)
      @ li,000 pSay replicate("*",132)
      @ li+1,000 pSay "* Tipo   Pref/Titulo/Parc Venc/Pagto Bordero       Valor       Fornecedor                       Ocorrencia          "
      @ li+1,131 pSay "*"
      @ li+2,000 pSay replicate("*",132)
      li := li + 2
   Endif
   
   If mRETORNO == .T.
      li := li + 2
      @ li,02 pSay "TOTAL BORDERO "+mNUMBOR+"............: "
      @ li,pCol()+3 pSay TRANSFORM(bBORDERO,"@E 9,999")
      @ li,48     pSay TRANSFORM(bTOTAL,"@E 99,999,999.99")
      li := li + 2
      @ li,00 pSay " "
      @ li,02 pSay "TOTAL - "+Left(SEB->EB_DESCRI,29)
      @ li,pCol() pSay TRANSFORM(xQTD,"@E 9,999")
      @ li,48     pSay TRANSFORM(xTOTAL,"@E 99,999,999.99")
      bBORDERO := bTOTAL := 0
   Endif
   
   @ pRow()+2,02 pSay "TOTAL TITULOS AGENDADOS......: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD01,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA01,"@E 99,999,999.99")
   @ pRow()+1,02 pSay "TOTAL TITULOS PAGOS..........: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD02,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA02,"@E 99,999,999.99")
   @ pRow()+1,02 pSay "TOTAL TITULOS REJEITADOS.....: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD03,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA03,"@E 99,999,999.99")
   @ pRow()+1,02 pSay "TOTAL OUTRAS OCORRENCIAS.....: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD04,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA04,"@E 99,999,999.99")
   
   aRo := SA2->A2_BANCO
   If aReturn[5] == 1
      Set Printer TO
      dbcommitAll()
      ourspool(wnrel)
   Endif
   MS_FLUSH()
   DbSelectArea("TRB")
   DbCloseArea()

   fErase(cArq+".DBF")
   fErase(cInd)

Return

Static Function fDetalheg()

   mRETORNO := .T.
   wSOMA01  := wSOMA02 := wSOMA03 := wSOMA04 := 0
   wQTD01   := wQTD02  := wQTD03  := wQTD04  := 0
   bBORDERO := bTOTAL  := 0
   bMatriz  := {  }
   xTOTAL   := xQTD := 0
   wBUSPAG  := SPACE(19)

   wBUSPAG := Substr(TRB->FILLER02,182,19)
   SE2->(DbSeek(xFilial("SE2")+wBUSPAG))

   If Empty(SE2->E2_NUMBOR)
      SEA->(DbSetOrder(1))
      SEA->(DbSeek(xFilial("SEA")+wBUSPAG))
      If SEA->(Found())
         aNUMBOR := SEA->EA_NUMBOR
      Endif
   Endif

   mNUMBOR := SE2->E2_NUMBOR
   TRB->(Dbgotop())
   SetRegua(TRB->(RecCount()))

   While !TRB->(Eof())

      wBUSPAG  := SPACE(19)
      cRetorno := SPACE(02)

      wBUSPAG  := Substr(TRB->FILLER02,182,19)
      cRetorno := Substr(TRB->FILLER02,217,02)

      SE2->(DbSeek(xFilial("SE2")+wBUSPAG))
      If !SE2->(Found())
         TRB->(DbSkip())
         Loop
      Endif


      SED->(DbSeek("  "+SE2->E2_NATUREZ))
      If SED->(Found())
         cGpsCdp := SED->ED_CODGPS
      Else
         cGpsCdp := "2100"
      Endif


      If Empty(SE2->E2_NUMBOR)
         SEA->(DbSetOrder(1))
         SEA->(DbSeek(xFilial("SEA")+wBUSPAG))
         If SEA->(Found())
            aNUMBOR := SEA->EA_NUMBOR
         Else
            aNUMBOR := "!!!!!!"
         Endif
      Endif

      If SE2->E2_NUMBOR <> mNUMBOR .and. mRETORNO == .T.
         li := li + 2
         @ li,02 pSay "TOTAL BORDERO "+mNUMBOR+"............: "
         @ li,pCol()+3 pSay TRANSFORM(bBORDERO,"@E 9,999")
         @ li,48     pSay TRANSFORM(bTOTAL,"@E 99,999,999.99")
         li := li + 2
         @ li,00 pSay " "
         bBORDERO := 0
         bTOTAL   := 0
      Endif

      If Substr(TRB->FILLER02,217,2) <> cRetorno .AND. mRetorno == .T.
         li := li + 1
         @ li,02 pSay "TOTAL - "+Left(SEB->EB_DESCRI,29)
         @ li,pCol() pSay TRANSFORM(xQTD,"@E 9,999")
         @ li,48     pSay TRANSFORM(xTOTAL,"@E 99,999,999.99")
         If Substr(TRB->FILLER02,217,2) <> "00"
            mRetorno := .F.
         Endif
         xTOTAL := xQTD := 0
      Endif

      If dPrepData <> dBAIXA .and. cRetorno == "00"
         @ pRow()+2,02 pSay "TOTAL TITULOS AGENDADOS......: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD01,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA01,"@E 99,999,999.99")
         @ pRow()+1,02 pSay "TOTAL TITULOS PAGOS..........: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD02,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA02,"@E 99,999,999.99")
         @ pRow()+1,02 pSay "TOTAL TITULOS REJEITADOS.....: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD03,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA03,"@E 99,999,999.99")
         @ pRow()+1,02 pSay "TOTAL OUTRAS OCORRENCIAS.....: "
         @ pRow(),pCol()+6 pSay TRANSFORM(wQTD04,"@E 9,999")
         @ pRow(),48     pSay TRANSFORM(wSOMA04,"@E 99,999,999.99")
         wSOMA01 := wSOMA02 := wSOMA03 := wSOMA04 := 0
         wQTD01 := wQTD02 := wQTD03 := wQTD04 := 0
         bBORDERO := bTOTAL := 0
         xQTD   :=  0
         xTOTAL := 0
         li := 64
      Endif
   
      If li >= 59 .or. SUBSTR(FILLER02,217,2) <> cRetorno
         Cabec(cTitulo,Cabec1,Cabec2,cNomeProg,cTamanho,nTipo)
         @ li,000 pSay replicate("*",nLimite)
         @ li+1,000 pSay "* GPS    Pref/Titulo/Parc Venc/Pagto Bordero         Vl.Multa         Vl.Entidade            Vl.Total  Fornecedor                      CGC/CPF/CEI                                            Ocorrencia"
         @ li+1,219 pSay "*"
         @ li+2,000 pSay replicate("*",nLimite)
         li := li + 3
      Endif
      li := li + 1

      If !Empty(SE2->E2_FORORIG)
         wBUSFOR := SE2->E2_FORORIG + SE2->E2_LOJORIG
      Else
         wBUSFOR := SE2->E2_FORNECE + SE2->E2_LOJA
      Endif

      @ li,03 pSay cGpsCdp
      @ li,11 pSay SE2->E2_PREFIXO + " " + SE2->E2_NUM + " " + SE2->E2_PARCELA
      @ li,27 pSay SE2->E2_VENCREA
      @ li,38 pSay SE2->E2_NUMBOR

      @ li,47 pSay TRANSFORM(SE2->E2_MULTA,"@E 999,999,999.99")
      @ li,87 pSay TRANSFORM(SE2->E2_VALOR+SE2->E2_MULTA,"@E 999,999,999.99")

      wVALOR   := SE2->E2_VALOR + SE2->E2_MULTA

      // colocar condicao aqui....

      cNomeFor := SPACE(30)

      SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORORIG+SE2->E2_LOJORIG))
      If SA2->(Found())
          cNomeFor := Left(SA2->A2_NOME,30)
      Endif
      @ li,103 pSay cNomeFor + "  " + Substr(TRB->FILLER02,16,14)

      fOcorrencia()// Substituido pelo assistente de conversao do AP5 IDE em 25/03/02 ==>       Execute(fOcorrencia)
      @ li,190 pSay cRetorno + " " + cOcorrencia

      xTOTAL := xTOTAL + wVALOR
      xQTD   := xQTD + 1

      If Subst(TRB->FILLER02,217,2) == "BD"
         wQTD01   := wQTD01 + 1
         wSOMA01  := wSOMA01 + wVALOR
         bBORDERO := bBORDERO + 1
         bTOTAL   := bTOTAL + wVALOR

      Elseif Subst(TRB->FILLER02,217,2) == "00"

         dPrepData := SE2->E2_VENCREA
         dBAIXA    := dPrepData

         wQTD02   := wQTD02 + 1
         wSOMA02  := wSOMA02 + wVALOR
         bBORDERO := bBORDERO + 1
         bTOTAL   := bTOTAL + wVALOR

      Elseif Subst(TRB->FILLER02,217,2) == "RJ"
         wQTD03   := wQTD03 + 1
         wSOMA03  := wSOMA03 + wVALOR

      Else
         wQTD04   := wQTD04 + 1
         wSOMA04  := wSOMA04 + wVALOR

      Endif

      cRetorno := SUBSTR(TRB->FILLER02,217,2)
      mNumbor  := SE2->E2_NUMBOR
    
      TRB->(DbSkip())
      dPrepData := SE2->E2_VENCREA
      IncRegua()

   Enddo
   
   If li > 50
      Eject
      Cabec(cTitulo,Cabec1,Cabec2,cNomeProg,cTamanho,nTipo)
      @ li,000 pSay replicate("*",nLimite)
      @ li+1,000 pSay "* GPS    Pref/Titulo/Parc Venc/Pagto Bordero         Vl.Multa         Vl.Entidade            Vl.Total  Fornecedor                      CGC/CPF/CEI      Obs.Gps                               Ocorrencia"
      @ li+1,219 pSay "*"
      @ li+2,000 pSay replicate("*",nLimite)
      li := li + 2
   Endif
   
   If mRETORNO == .T.
      li := li + 2
      @ li,02 pSay "TOTAL BORDERO "+mNUMBOR+"............: "
      @ li,pCol()+3 pSay TRANSFORM(bBORDERO,"@E 9,999")
      @ li,48     pSay TRANSFORM(bTOTAL,"@E 99,999,999.99")
      li := li + 2
      @ li,00 pSay " "
      @ li,02 pSay "TOTAL - "+Left(SEB->EB_DESCRI,29)
      @ li,pCol() pSay TRANSFORM(xQTD,"@E 9,999")
      @ li,48     pSay TRANSFORM(xTOTAL,"@E 99,999,999.99")
      bBORDERO := bTOTAL := 0
   Endif
   
   @ pRow()+2,02 pSay "TOTAL TITULOS AGENDADOS......: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD01,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA01,"@E 99,999,999.99")
   @ pRow()+1,02 pSay "TOTAL TITULOS PAGOS..........: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD02,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA02,"@E 99,999,999.99")
   @ pRow()+1,02 pSay "TOTAL TITULOS REJEITADOS.....: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD03,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA03,"@E 99,999,999.99")
   @ pRow()+1,02 pSay "TOTAL OUTRAS OCORRENCIAS.....: "
   @ pRow(),pCol()+6 pSay TRANSFORM(wQTD04,"@E 9,999")
   @ pRow(),48     pSay TRANSFORM(wSOMA04,"@E 99,999,999.99")
   
   aRo := SA2->A2_BANCO
   If aReturn[5] == 1
      Set Printer TO
      dbcommitAll()
      ourspool(wnrel)
   Endif
   MS_FLUSH()
   DbSelectArea("TRB")
   DbCloseArea()
   fErase(cArq)
   fErase(cInd)

Return


Static function fOcorrencia()

  If cRetorno == "00"
     cOcorrencia := "PAGAMENTO EFETUADO"

  Elseif cRetorno == "AE"
     cOcorrencia := "DATA DE PAGAMENTO ALTERADA"

  Elseif cRetorno == "AH"
     cOcorrencia := "NUMERO SEQUENCIAL DO REGISTRO NO LOTE INVALIDO"

  Elseif cRetorno == "AJ"
     cOcorrencia := "TIPO DE MOVIMENTO INVALIDO"

  Elseif cRetorno == "AL"
     cOcorrencia := "CODIGO DO BANCO FAVORECIDO INVALIDO"

  Elseif cRetorno == "AM"
     cOcorrencia := "AGENCIA DO FAVORECIDO INVALIDA"

  Elseif cRetorno == "AN"
     cOcorrencia := "CONTA CORRENTE DO FAVORECIDO INVALIDA"

  Elseif cRetorno == "AO"
     cOcorrencia := "NOME DO FAVORECIDO INVALIDO"

  Elseif cRetorno == "AP"
     cOcorrencia := "DATA DE LANCAMENTO/PAGAMENTO/ARRECADACAO INVALIDA"

  Elseif cRetorno == "AR"
     cOcorrencia := "VALOR ARRECADADO INVALIDO"

  Elseif cRetorno == "BC"
     cOcorrencia := "NOSSO NUMERO INVALIDO"

  Elseif cRetorno == "BD"
     cOcorrencia := "PAGAMENTO AGENDADO"

  Elseif cRetorno == "BE"
     cOcorrencia := "PAGAMENTO AGENDADO COM FORMA ALTERADA PARA OP"

  Elseif cRetorno == "CD"
     cOcorrencia := "Cod. Barra Valor do Titulo Invalido"

  Elseif cRetorno == "CE"
     cOcorrencia := "Cod. Barra - campo livre invalido"

  Elseif cRetorno == "CC"
     cOcorrencia := "COD. DE BARRAS DIG. VERIFICADOR INVALIDO"

  Elseif cRetorno == "DV"
     cOcorrencia := "DOC / BLOQUETO DE COBRANCA DEVOLVIDO PELO BANCO FAVORECIDO"

  Elseif cRetorno == "EM"
     cOcorrencia := "CONFIRMACAO DE OP EMITIDA"

  Elseif cRetorno == "EX"
     cOcorrencia := "DEVOLUCAO DE  OP NAO SACADA PELO FAVORECIDO"

  Elseif cRetorno == "IB"
     cOcorrencia := "VALOR DO TITULO INVALIDO"

  Elseif cRetorno == "IC"
     cOcorrencia := "VALOR DO ABATIMENTO INVALIDO"

  Elseif cRetorno == "ID"
     cOcorrencia := "VALOR DO DESCONTO INVALIDO"

  Elseif cRetorno == "IE"
     cOcorrencia := "VALOR DA MORA INVALIDO"

  Elseif cRetorno == "IF"
     cOcorrencia := "VALOR DA MULTA INVALIDO"

  Elseif cRetorno == "IG"
     cOcorrencia := "VALOR DA DEDUCAO INVALIDO"

  Elseif cRetorno == "IH"
     cOcorrencia := "VALOR DO ACRESCIMO INVALIDO"

  Elseif cRetorno == "II"
     cOcorrencia := "DATA DE VENCIMENTO INVALIDA"

  Elseif cRetorno == "IJ"
     cOcorrencia := "COMPETENCIA INVALIDA"

  Elseif cRetorno == "IK"
     cOcorrencia := "TRIBUTO NAO LIQUIDAVEL VIA SISPAG OU NAO CONVENIADO COM ITAU"

  Elseif cRetorno == "IL"
     cOcorrencia := "CODIGO DE PAGAMENTO INVALIDO"

  Elseif cRetorno == "IM"
     cOcorrencia := "TIPO X FORMA NAO COMPATIVEL"

  Elseif cRetorno == "IN"
     cOcorrencia := "BANCO/AGENCIA NAO CADASTRADOS"

  Elseif cRetorno == "IP"
     cOcorrencia := "DIGITO VERIFICADOR  DO CODIGO DE BARRAS INVALIDO"

  Elseif cRetorno == "IR"
     cOcorrencia := "PAGAMENTO ALTERADO"

  Elseif cRetorno == "IS"
     cOcorrencia := "CONCESSIONARIA NAO CONVENIADA COM ITAU"

  Elseif cRetorno == "IT"
     cOcorrencia := "VALOR DO TRIBUTO INVALIDO"

  Elseif cRetorno == "LA"
     cOcorrencia := "DATA DE PAGAMENTO DE UM LOTE ALTERADA"

  Elseif cRetorno == "LC"
     cOcorrencia := "LOTE DE PAGAMENTOS CANCELADO"

  Elseif cRetorno == "NA"
     cOcorrencia := "PAGAMENTO  CANCELADO POR FALTA DE  AUTORIZADO"

  Elseif cRetorno == "NR"
     cOcorrencia := "OPERACAO NAO REALIZADA"

  Elseif cRetorno == "RJ"
     cOcorrencia := "REGISTRO REJEITADO"

  Elseif cRetorno == "SS"
     cOcorrencia := "PAGAMENTO CANCELADO POR INSUFICIENCIA DE SALDO"

  Elseif cRetorno == "TA"
     cOcorrencia := "LOTE NAO ACEITO - TOTAIS DO LOTE COM DIFERENCA"

  Elseif cRetorno == "TI"
     cOcorrencia := "TITULARIDADE INVALIDA"

  Elseif cRetorno == "DF"  // Tipo criado manual
     cOcorrencia := "DIFERENCA ENTRE VALOR PAGO X BASE" // Diferenca entre valor pago e a base SE2 (Contas a Pagar)

  Else
     cOcorrencia := " "

  Endif

Return(.T.)

