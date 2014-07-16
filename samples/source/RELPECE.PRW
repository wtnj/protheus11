/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ RELPECE  ³ Autor ³  Emilton              ³ Data ³ 10/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime Relacao de Pecas em Formulario especifico          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RELPECE()
**********************

SetPrvt("cDesc1,cDesc2,cDesc3,cAlias,aRegistros,cString,cTitulo,cTamanho,aReturn")
SetPrvt("cNomProg,cNomRel,cDrive,cNumOsv,cTipTem,cTipFor")

//RETURN .T.

cAlias     :="VEK"

Private nLin := 1
Private aPag := 1
Private nIte := 1
Private aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cNumOsv := ParamIxb[1]
cTipTem := ParamIxb[2]
cTipFor := ParamIxb[3]

cDesc1     :=""         	
cDesc2     :=""
cDesc3     :=""
cString    :="SD1"
aRegistros := {}
cTitulo    := OemToAnsi("Emissao da Relacao das Pecas Aplicadas")
aReturn    :=  { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cNomProg   := "RELPECE"
nLastKey   := 0
cNomRel    := cTipFor
cDrive     := GetMv("MV_DRVRLP")
cNomeImp   := GetMv("MV_PORRLP")

/*
[1] Reservado para Formulario
[2] Reservado para nro de Vias
[3] Destinatario
[4] Formato => 1-Comprimido 2-Normal
[5] Midia   => 1-Disco 2-Impressora
[6] Porta ou Arquivo 1-LPT1... 4-COM1...
[7] Expressao do Filtro
[8] Ordem a ser selecionada
[9]..[10]..[n] Campos a Processar (se houver)
*/

Private cTamanho:= "P"           // P/M/G
Private Limite  := 132           // 80/132/220
Private aOrdem  := {}           // Ordem do Relatorio
Private nLastKey:= 0

lServer  := .f.

//cNomRel := SetPrint(cString,cNomRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil    ,cDrive,.T.  ,lServer,cNomeImp)
cNomRel := SetPrint(cString,cNomRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,,.F.)
If nLastKey == 27
   Set Filter To
   Return
Endif

SetDefault(aReturn,cAlias)

RptStatus({|lEnd| ImprimeRP(@lEnd,cNomRel,cAlias,cNumOSv,cTipTem,cTipFor)},cTitulo)

Set Filter To

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ IMPRIMERP³ Autor ³  Emilton              ³ Data ³ 11/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime Relacao de Pecas em Formulario especifico          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImprimeRP(lEnd,cNomRel,cAlias,cNumOsv,cTipTem,cTipFor)
*********************************************************

SetPrvt("cNomEmp,cCGCFil,cEndEmp,cCEPFil,cTelFil,cFaxFil,cInsFil,cCidFil")
SetPrvt("cEstFil,nValTot,nValDes,nBasICM,nValICM,nNumLin,lFlgImp")
SetPrvt("oPr","nX","aDriver","lVez","nValor1")
SetPrvt("cNomeEmp","cEndeEmp","cNomeCid","cEstaEmp","cCep_Emp","cFoneEmp")
SetPrvt("cFax_Emp","cCNPJEmp","cInscEmp")

aDriver := LeDriver()                    
cCompac := aDriver[1]
cNormal := aDriver[2]
Private cCompac := aDriver[1]
Private cNormal := aDriver[2]
Private cExpand := aDriver[3]

If cTipFor == "RELPECN"   && Formulario Comum

Else                       && Formulario Especifico

   Set Printer to &cNomRel
   Set Printer On
   Set Device  to Printer                                  

   nNumLin := 70
   nPag    := 1   

   lFlgImp := .f.
   cNomEmp := left(SM0->M0_NOMECOM,30)
   cCGCFil := transform(left(SM0->M0_CGC,14),"@R 99.999.999/9999-99")

   cEndEmp := left(SM0->M0_ENDENT,30)
   cCEPFil := transform(SM0->M0_CEPENT,"@R 99999-999")
   cTelFil := SM0->M0_TEL
   cFaxFil := SM0->M0_FAX
   cInsFil := SM0->M0_INSC

   cCidFil := SM0->M0_CIDENT
   cEstFil := SM0->M0_ESTENT
 
   nValTot := nValDes := nBasICM := nValICM := 0

   cKeyAce := cNumOsv+cTipTem

   dbSelectArea("VEC")
   dbSetOrder(5)
   If dbSeek(xFilial("VEC")+cKeyAce)

      while cKeyAce == VEC->VEC_NUMOSV+VEC->VEC_TIPTEM .and. !eof()
 
         If nNumLin > 65     //linha 64
            if !lFlgImp
               lFlgImp := .t.
               nPag := nPag + 1
          //     @ 66,78        pSay OemToAnsi("Segue na proxima pagina .......")
          //     eject
            endif

            FG_SEEK("SF2","VEC->VEC_NUMNFI+VEC->VEC_SERNFI",1,.f.)
            FG_SEEK("SE4","SF2->F2_COND",1,.f.)

            @ 01,01         pSay &cNormal + " "
            @ 01,69         pSay strzero(val(VEC->VEC_NUMREL),8)    
        	  	@ 03,01         pSay &cNormal + " "
            @ 03,01         pSay cEndEmp+" "+cCidFil+" "+cEstFil+" "+cCepFil
            @ 04,01         pSay "CNPJ:"+cCGCFil+" IE:"+cInsFil+"Fone:"+cTelFil+"/"+cFaxFil
            @ 04,71         pSay dtoc(VEC->VEC_DATVEN)
            @ 06,10         pSay &cExpand 
            @ 06,12         pSay VEC->VEC_NUMOSV
            @ 06,33         pSay &cExpand
            @ 06,36         pSay VEC->VEC_NUMNFI
            @ 06,pcol()+01 pSay &cNormal 
         // @ 06,pcol()+07 pSay SE4->E4_DESCRI
            @ 06,60         pSay SE4->E4_DESCRI
            @ 07,01         pSay &cCompac

            nNumLin := 08

         EndIf

         nNumLin ++
      
         If !Empty(VEC->VEC_ALQICM)
            nBasICM += VEC->VEC_VALVDA
            nValICM += VEC->VEC_VALICM
         // nValTot += VEC->VEC_VALBRU
         // nValDes += VEC->VEC_VALDES
         EndIf     
         
         nValTot += VEC->VEC_VALBRU
         nValDes += VEC->VEC_VALDES

         FG_SEEK("SB1","VEC->VEC_GRUITE+VEC->VEC_CODITE",7,.f.)
         FS_VERPEC()       
         
         @ nNumLin,01 pSay &cCompac+" "
      // @ nNumLin,01 pSay VEC->VEC_NUMREL+"  "+"      "+"   "+VEC->VEC_GRUITE+VEC->VEC_CODITE+" "+SB1->B1_DESC+" "+SB1->B1_ORIGEM+"  "+transform(VEC->VEC_QTDITE,"@ez 99999")+space(04)+transform(VEC->VEC_VALVDA/VEC->VEC_QTDITE,"@ez 9999,999,999.99")+space(10)+transform(VEC->VEC_VALVDA,"@ez 999,999,999.99")+" "+transform(VEC->VEC_ALQICM,"@ez 99.9")
         @ nNumLin,01 pSay "      "+"      "+"     "+VEC->VEC_GRUITE+VEC->VEC_CODITE+" "+SB1->B1_DESC+" "+SB1->B1_ORIGEM+"  "+transform(VEC->VEC_QTDITE,"@ez 99999")+space(03)+transform(VEC->VEC_VALVDA/VEC->VEC_QTDITE,"@ez 9999,999,999.99")+space(10)+transform(VEC->VEC_VALVDA,"@ez 999,999,999.99")+" "+transform(VEC->VEC_ALQICM,"@ez 99.9")
         dbSkip()

      EndDo

      @ 61,28         pSay Transform(nBasICM,"@ez 999,999,999,999.99")
      @ 61,pcol()+01 pSay Transform(nValICM,"@ez 999,999,999,999.99")
      @ 61,pcol()+09 pSay Transform(nValTot - nValDes,"@ez 999,999,999,999.99")
   // @ 61,pcol()+01 pSay Transform(nValDes,"@ez 999,999,999,999.99")
      @ 61,pcol()+23 pSay Transform(nValTot - nValDes,"@ez 999,999,999,999.99")

   // eject

      nNumLin := 65

   endif
   MS_Flush()
   OurSpool(cNomRel)
EndIf   

return

Static Function FS_VERPEC()
***************************
                                
Local cSelect := Alias()

FG_SEEK("VO2","VEC->VEC_NUMOSV")
dbSelectArea("VO2")

While VEC->VEC_NUMOSV == VO2->VO2_NUMOSV .and. !eof()

   If VO2->VO2_TIPREQ == "S"
      dbSkip()
      loop
   EndIf

   FG_SEEK("VO3","VO2->VO2_NOSNUM+VEC->VEC_TIPTEM")
   dbSelectArea("VO3")

   While VO2->VO2_NOSNUM+VEC->VEC_TIPTEM == VO3->VO3_NOSNUM+VO3->VO3_TIPTEM .and. !eof()

      If VO3->VO3_CODITE == VEC->VEC_CODITE
         Exit
      EndIf
      dbSkip()

   EndDo              
   
   dbSelectArea("VO2")
   dbSkip()

EndDo                     

dbSelectArea(cSelect)

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LeDriver ³ Autor ³ Tecnologia            ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Emissao da Nota Fiscal de Balcao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LEDriver()
**************************
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
Return aSettings

