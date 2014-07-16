#Include "NFSERVIC.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ NFSERVIC ³ Autor ³  Manoel               ³ Data ³ 31/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime Nota Fiscal de Servicos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION NFSERVIC()

SetPrvt("aDriver,cTitulo,cDesc1,cDesc2,cDesc3,cNomeImp,lServer,cTamanho,cObserv1,cObserv2,cObserv3,cObserv4,cObserv5,cObserv6")

aReturn :=  { OemToAnsi(STR0001), 1,OemToAnsi(STR0002), 2, 2, 1, "",1 }

aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

cNumNF := ParamIxb[1]
cSerNF := ParamIxb[2]
cTipNF := ParamIxb[3]

if cTipNF == "CFD"
   cDescSrv1 := "Comissao de Venda Direta"
   cDescSrv2 := "Comissao de Venda Direta"
   cDescSrv3 := "Comissao de Venda Direta"
   cDescSrv4 := "Comissao de Venda Direta"
   cDescSrv5 := "Comissao de Venda Direta"
   cDescSrv6 := ""
Endif

cTitulo := cDesc1  := cDesc2 := cDesc3 := ""

cNomeRel :=  "NFSERVIC"
cDrive     := GetMv("MV_DRVNFI")
cNomeImp   := GetMv("MV_PORNFI")
ctamanho := "M"   
cAlias   := "SF2"
lServer  := .f.
nLastKey:= 0

cNomeRel:=SetPrint(cAlias,cNomeRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil    ,cDrive,.T.  ,lServer,cNomeImp)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cAlias)

Set Printer to &cNomeRel
Set Printer On
Set device to Printer

cbTxt    := Space(10)
cbCont   := 0
cString  := "SF2"
Li       := 80
m_Pag    := 1

wnRel    := "VEIVM010"

nomeprog  := "NFSERVIC"
tamanho   := "M"
nCaracter := 15

FG_SEEK("VV0","cNumNF+cSerNF",4,.f.)
FG_SEEK("VVA","VV0->VV0_NUMTRA",1,.f.)
FG_SEEK("VV1","VVA->VVA_CHAINT",1,.f.)
FG_SEEK("VE1","VV1->VV1_CODMAR",1,.f.)
FG_SEEK("SA1","VV0->VV0_CODCLI+VV0->VV0_LOJA",1,.f.)
FG_SEEK("SA3","VV0->VV0_CODVEN",1,.f.)
FG_Seek("SE4","VV0->VV0_FORPAG",1,.f.)
FG_Seek("SD2","VV0->VV0_NUMNFI+VV0->VV0_SERNFI",3,.f.)
FG_Seek("SF2","VV0->VV0_NUMNFI+VV0->VV0_SERNFI",1,.f.)
FG_Seek("SF4","VVA->VVA_CODTES",1,.f.)

if FG_SEEK("SA4","VV0->VV0_CODTRA",1,.f.)
   cEmiFre := "1"
   cNomTra := SA4->A4_NOME
   cEndTra := SA4->A4_END
   cCidTra := SA4->A4_MUN
   cEstTra := SA4->A4_EST
	cCGCTra := transform(left(SA4->A4_CGC,14),"@R 99.999.999/9999-99")
   cINSTra := SA4->A4_INSEST
Else
   cEmiFre := "2"
   cNomTra := Space(1)
   cEndTra := Space(1)
   cCidTra := Space(1)
   cEstTra := Space(1)
	cCGCTra := Space(1)
   cINSTra := Space(1)
Endif

for i:= 1 to 6

    cKeyAce := VVA->VVA_OBSMEM + strzero(i,3)
    cCampo  := "cObserv"+STR(i,1)
    &cCampo := if(FG_SEEK("SYP","cKeyAce",1,.f.),SYP->YP_TEXTO,"")

next

cNomEmp := left(SM0->M0_NOMECOM,30)
cCGCFil := transform(left(SM0->M0_CGC,14),"@R 99.999.999/9999-99")

cEndEmp := left(SM0->M0_ENDENT,30)
cCEPFil := transform(SM0->M0_CEPENT,"@R 99999-999")
cTelFil := SM0->M0_TEL
cFaxFil := SM0->M0_FAX
cInsFil := SM0->M0_INSC
cCidFil := SM0->M0_CIDENT
cEstFil := SM0->M0_ESTENT

cNomPro := left(SA1->A1_NOME,30)
cEndPro := SA1->A1_END
cBaiPro := Subs(SA1->A1_BAIRRO,1,15)
cCepPro := transform(SA1->A1_CEP,"@R 99999-999")
cCGCPro := SA1->A1_CGC
cInsPro := SA1->A1_INSCR
cCidPro := SA1->A1_MUN
cEstPro := SA1->A1_EST
cFonPro := SA1->A1_TEL

cMarca  := Subs(VE1->VE1_DESMAR,1,20)

cVended := SA3->A3_COD + " - " + SA3->A3_NOME
cDesFpg := alltrim(SE4->E4_DESCRI)
cNatOpe := OemToAnsi(STR0003)

aTit  := {}
aTit1 := {}
                               
dbselectArea("SE1")
DbSetOrder(1)
dbgotop()
DbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DUPL)

do while !eof() .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM = SF2->F2_FILIAL+SF2->F2_PREFIXO+SF2->F2_DUPL                        
   aAdd(aTit,{SE1->E1_PREFIXO+SE1->E1_NUM+"/"+SE1->E1_PARCELA,transform(SE1->E1_VALOR,"@e 999,999.99"),SE1->E1_VENCTO})
   if SE4->E4_TIPO = "A"
      if SE1->E1_PARCELA = "1"
         n_Razao := SE1->E1_VENCTO - SE1->E1_EMISSAO 
         d_Ant := SE1->E1_VENCTO  
         aAdd(aTit1,strzero(n_Razao,3)) 
      else                                             
         n_Razao := SE1->E1_VENCTO - d_Ant 
         d_Ant := SE1->E1_VENCTO       
         aAdd(aTit1,strzero(n_Razao,3)) 
      endif
   endif
     
   dbselectArea("SE1")
   dbskip()
enddo  

aPag := 1
nQtdPag := 1

cNum := SF2->F2_DOC + " / " + StrZero(aPag,2) + "/" + Strzero(nQtdPag,2) + &cCompac

cDatEmi := Subs(Dtos(SF2->F2_EMISSAO),7,2) + "/" + Subs(Dtos(SF2->F2_EMISSAO),5,2) + "/" + Subs(Dtos(SF2->F2_EMISSAO),1,4)

@ 01,01  psay &cNormal
@ 03,52  psay "X" +space(14)+cNum //1

@ 06,01 psay &cCompac
@ 07,01 psay SF4->F4_TEXTO
@ 07,49 psay SD2->D2_CF    

@ 09,01 psay &cNormal + cNomPro 
@ 09,52 psay cCGCPro 
@ 09,72 psay cDatEmi

@ 10,01 psay cEndPro 
@ 10,44 psay cBaiPro 
@ 10,60 psay cCepPro
@ 10,72 pSay cDatEmi 

@ 12,01 psay cCidPro 
@ 12,33 psay cFonPro 
@ 12,47 psay cEstPro 
@ 12,53 psay cInsPro + &cCompac

FS_FATUR()    // 11

@ 27,002 psay cObserv1
@ 27,129 psay "101.254/0"
@ 28,002 psay cObserv2
@ 29,002 psay cObserv3
@ 30,002 psay cObserv4
@ 31,002 psay cObserv5
@ 32,002 psay cObserv6

@ 44,132 psay Transform(SF2->F2_VALBRUT,"@E 999,999,999.99")
@ 45,132 psay Transform(SF2->F2_VALBRUT,"@E 999,999,999.99")

@ 47,002 psay cNomTra
@ 47,087 psay cEmiFre
@ 47,132 psay cCGCTra
@ 48,002 psay cEndTra
@ 48,092 psay cCidTra
@ 48,121 psay cEstTra
@ 48,132 psay cINSTra

@ 50,035 psay cMarca

if VV0->VV0_OPEMOV ="0"  //venda
   @ 52,002  psay OemToAnsi(STR0007) + cVended  //50
   @ 53,002  psay OemToAnsi(STR0008) + cDesFpg                  
   @ 54,002  psay OemToAnsi(STR0010)  //via de transporte rodoviario
else                  
   @ 52,002  psay OemToAnsi(STR0009) + cVended  //50             
   @ 53,002  psay OemToAnsi(STR0010)  //via de transporte rodoviario
endif                                                
 
FG_Seek("SM4","SF4->F4_FORMULA",1,.F.)   //MENSAGENS DA NOTA FISCAL
@ 55,002  psay subs(SM4->M4_FORMULA,1,64)   
@ 56,002  psay subs(SM4->M4_FORMULA,65,64)      
//FG_Seek("SM4","SF4->F4_FORMUL1",1,.F.)
//@ 57,002  psay subs(SM4->M4_FORMULA,1,64)   
//@ 58,002  psay subs(SM4->M4_FORMULA,65,64)      

@ 61,00 psay &cNormal 
@ 62,66 psay cNum

nlin := 66
@ nlin , 001 pSay " "
SETPRC(0,0)

Set Printer to
Set Printer Off
Set device to Screen

Ms_Flush()

Return


// FUNCAO PARA IMPRIMIR OS TITULOS DA NOTA FISCAL
Static Function FS_FATUR()
***********************
nLin := 14

for xa = 1 to len(aTit)

   if xa = 13
      exit
   endif   
  
   if strzero(xa,2) $ "01/04/07/10"
      @ nLin, 000 pSay aTit[xa,1] //DUPLICATA
      @ nLin, 017 pSay aTit[xa,2] //VALOR
      @ nLin, 032 pSay aTit[xa,3] //VENCTO 
   elseif strzero(xa,2) $ "02/05/08/11"
      @ nLin, 047 pSay aTit[xa,1] 
      @ nLin, 063 pSay aTit[xa,2]
      @ nLin, 078 pSay aTit[xa,3]  
   elseif strzero(xa,2) $ "03/06/09/12"   
      @ nLin, 093 pSay aTit[xa,1] 
      @ nLin, 110 pSay aTit[xa,2]
      @ nLin, 126 pSay aTit[xa,3]  
      nLin++
   endif
  
next

return
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
Static Function LeDriver()

Local aSettings := {}
Local cStr, cLine, i

If !File(__DRIVER)
   aSettings := {"CHR(15)","CHR(18)","CHR(15)","CHR(18)","CHR(15)","CHR(15)"}
Else
   cStr := MemoRead(__DRIVER)
   For i:= 2 to 7
      cLine := AllTrim(MemoLine(cStr,254,i))
      aAdd(aSettings,SubStr(cLine,7))
   Next
EndIf

Return aSettings
