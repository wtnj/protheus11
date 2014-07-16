#Include "NFENTVEI.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ NFENTVEI ³ Autor ³  Renata               ³ Data ³ 14/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime Nota Fiscal de Veiculos (Entrada) AUDI             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION NFENTVEI()

SetPrvt("aDriver,cTitulo,cDesc1,cDesc2,cDesc3,cNomeImp,lServer,cTamanho")

aReturn :=  { OemToAnsi(STR0010), 1,OemToAnsi(STR0011), 2, 2, 1, "",1 }

aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

cNumNF := ParamIxb[1]
cSerNF := ParamIxb[2]
cCdFor := ParamIxb[3]              
cLojaF := ParamIxb[4]              

cTitulo := cDesc1  := cDesc2 := cDesc3 := ""

cNomeRel :=  "NFENTVEI"
cDrive     := GetMv("MV_DRVNFI")
cNomeImp   := GetMv("MV_PORNFI")
ctamanho := "M"   
cAlias   := "VVF"
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
cString  := "VVF"
Li       := 80
m_Pag    := 1

wnRel    := "VEIVM000"

nomeprog  := "NFENTVEI"
tamanho   := "M"
nCaracter := 15

FG_SEEK("VVF","cCdFor+cLojaF+cNumNF+cSerNF",4,.f.)
FG_SEEK("VVG","VVF->VVF_TRACPA",1,.f.)
FG_SEEK("VV1","VVG->VVG_CHAINT",1,.f.)
FG_SEEK("VV2","VV1->VV1_CODMAR+VV1->VV1_MODVEI",1,.f.)
FG_SEEK("VV8","VV2->VV2_TIPVEI",1,.f.)
FG_SEEK("VVB","VV2->VV2_CATVEI",1,.f.)
FG_SEEK("VVE","VV2->VV2_ESPVEI",1,.f.)
FG_SEEK("VE1","VV1->VV1_CODMAR",1,.f.)
FG_SEEK("SA2","VVF->VVF_CODFOR+VVF->VVF_LOJA",1,.f.)
FG_SEEK("SA3","VVF->VVF_CODCOM",1,.f.)
FG_Seek("SB1","VVG->VVG_CHAINT",1,.f.)
FG_Seek("SE4","VVF->VVF_FORPAG",1,.f.)
FG_Seek("SD1","VVF->VVF_NUMNFI+VVF->VVF_SERNFI+cCdFor+cLojaF",1,.f.)
FG_Seek("SF1","VVF->VVF_NUMNFI+VVF->VVF_SERNFI+cCdFor+cLojaF",1,.f.)
FG_Seek("SF4","VVG->VVG_CODTES",1,.f.)

aTit  := {}
aTit1 := {}
                               
dbselectArea("SE2")
DbSetOrder(1)
dbgotop()
DbSeek(xFilial("SE2")+SF1->F1_PREFIXO+SF1->F1_DUPL)

do while !eof() .and. SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM = SF1->F1_FILIAL+SF1->F1_PREFIXO+SF1->F1_DUPL                        
   if SE2->E2_BAIXA = ctod("  /  /  ")
      aAdd(aTit,{SE2->E2_PREFIXO+SE2->E2_NUM+"/"+SE2->E2_PARCELA,transform(SE2->E2_VALOR,"@e 999,999.99"),SE2->E2_VENCTO})
      if SE4->E4_TIPO = "A"
        if SE2->E2_PARCELA = "1"
            n_Razao := SE2->E2_VENCTO - SE2->E2_EMISSAO 
            d_Ant := SE2->E2_VENCTO  
            aAdd(aTit1,strzero(n_Razao,3)) 
         else                                             
            n_Razao := SE2->E2_VENCTO - d_Ant 
            d_Ant := SE2->E2_VENCTO       
            aAdd(aTit1,strzero(n_Razao,3)) 
         endif
      endif
   endif  
   dbselectArea("SE2")
   dbskip()        
   
enddo  
        
DbSelectArea("SE4")
Dbsetorder(1)
dbgotop()
DbSeek(xFilial("SE4")+SF1->F1_COND)
if SE4->E4_TIPO # "A"
   cDesFpg :=SF1->F1_COND+" - "+SE4->E4_DESCRI  
else                               
   cDescri := ""
   for xz = 1 to len(aTit1)
      cDescri := cDescri + atit1[xz] + ","
   next                           
   cDescri := cDescri + " Dias"
   cDesFpg :=SF1->F1_COND+" - "+cDESCRI
endif

DbSelectArea("VVF")
nSavRec := recno()

if !Empty(VVF->VVF_NUMTRA)
	cNumFre := VVF->VVF_NUMTRA
	FG_SEEK("VVF","cNumFre",5,.f.)
Endif	
	
if FG_SEEK("SA4","VVF->VVF_CODFOR",1,.f.)
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

DbGoto(nSavRec)

cNomEmp := left(SM0->M0_NOMECOM,30)
cCGCFil := transform(left(SM0->M0_CGC,14),"@R 99.999.999/9999-99")

cEndEmp := left(SM0->M0_ENDENT,30)
cCEPFil := transform(SM0->M0_CEPENT,"@R 99999-999")
cInMFil := transform(SM0->M0_CODMUN,"@R 999.999/9")
cTelFil := SM0->M0_TEL
cFaxFil := SM0->M0_FAX
cInsFil := SM0->M0_INSC
cCidFil := SM0->M0_CIDENT
cEstFil := SM0->M0_ESTENT

cNomPro := SA2->A2_NOME
cEndPro := SA2->A2_END
cBaiPro := Subs(SA2->A2_BAIRRO,1,15)
cCepPro := transform(SA2->A2_CEP,"@R 99999-999")
IF sA2->a2_tipo == "J"
   cCGCPro := transform(left(SA2->A2_CGC,14),"@R 99.999.999/9999-99")
Else
   cCGCPro := Space(02)+transform(left(SA2->A2_CGC,14),"@R 999.999.999-99")+Space(02)
Endif   
cInsPro := SA2->A2_INSCR
cCidPro := SA2->A2_MUN
cEstPro := SA2->A2_EST
cFonPro := left(SA2->A2_TEL,15)

cMarca  := Subs(VE1->VE1_DESMAR,1,18)

cChassi := Alltrim(VV1->VV1_CHASSI)
cPlaVei := VV1->VV1_PLAVEI + Space(05)
cNumMot := VV1->VV1_NUMMOT + Space(05)
cDifere := VV1->VV1_TIPDIF + Space(5)
cCMT    := Str(VV1->VV1_CAPTRA,5) + Space(10)
cPotMot := Str(VV1->VV1_POTMOT,5) + Space(10)
cQtdCil := Str(VV1->VV1_QTDCIL,2) + Space(13)
cNumEix := Str(VV1->VV1_QTDEIX,2) + Space(13)
cDisEix := Str(VV1->VV1_DISEIX,6) + Space(09)
cAnoFab := Subs(VV1->VV1_FABMOD,1,4)+ Space(11)
cAnoMod := Subs(VV1->VV1_FABMOD,5,4)+ Space(11)
cRenava := VV1->VV1_RENAVA
cProced := if(VV1->VV1_PROVEI=="1",OemToAnsi(STR0001),OemToAnsi(STR0002))
cEstado := if(VVG->VVG_ESTVEI=="1",OemToAnsi(STR0003),OemToAnsi(STR0004))

if VV1->VV1_COMVEI == "0"
   cCombus := OemToAnsi(STR0005)
Elseif VV1->VV1_COMVEI == "1"
   cCombus := OemToAnsi(STR0006)
Elseif VV1->VV1_COMVEI == "2"
   cCombus := OemToAnsi(STR0007)
Elseif VV1->VV1_COMVEI == "3"
   cCombus := OemToAnsi(STR0008)
Elseif VV1->VV1_COMVEI == "9"
   cCombus := OemToAnsi(STR0009)
Else
   cCombus := Space(15)
Endif

FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORVEI",1,.f.)
cCorVei := Subs(VVC->VVC_DESCRI,1,15)
FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORFXA",1,.f.)
cFaixa  := Subs(VVC->VVC_DESCRI,1,15)

cDesMod := Subs(VV2->VV2_DESMOD,1,15)
cNumPas := StrZero(VV2->VV2_QTDPAS,3) + Space(12)
cTipVei := Subs(VV8->VV8_DESCRI,1,17)
cCatego := Subs(VVB->VVB_DESCRI,1,15)
cEspeci := Subs(VVE->VVE_DESCRI,1,15)

cVended := SA3->A3_COD + " - " + SA3->A3_NOME
cDesFpg := alltrim(SE4->E4_DESCRI)
if VVF->VVF_OPEMOV == "0"
   cNatOpe := OemToAnsi(STR0012) + Subs(cEstado,1,5)
Elseif VVF->VVF_OPEMOV == "2"
   cNatOpe := OemToAnsi(STR0013) + Subs(cEstado,1,5)
Elseif VVF->VVF_OPEMOV == "3"
   cNatOpe := OemToAnsi(STR0014) + Subs(cEstado,1,5)
Elseif VVF->VVF_OPEMOV == "4"
   cNatOpe := OemToAnsi(STR0015)
Elseif VVF->VVF_OPEMOV == "5"
   cNatOpe := OemToAnsi(STR0016) + Subs(cEstado,1,5)
Endif

aPag := 1
nQtdPag := 1

cDatEmi := Subs(Dtos(VVF->VVF_DATMOV),7,2) + "/" + Subs(Dtos(VVF->VVF_DATMOV),5,2) + "/" + Subs(Dtos(VVF->VVF_DATMOV),1,4)
cNum := SF1->F1_DOC + " / " + StrZero(aPag,2) + "/" + Strzero(nQtdPag,2) + &cCompac

@ 01,01 psay &cNormal
@ 03,62  psay "X" +space(4)+cNum //1
@ 06,01 psay &cCompac
@ 07,01 psay SF4->F4_TEXTO
@ 07,49 psay SD1->D1_CF    

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
                                   
nLin := 19

while VVG->VVG_FILIAL == xFilial("VVG") .and. VVG->VVG_TRACPA == VVF->VVF_TRACPA .and. !eof()

   FG_Seek("SD1","VVg->VVG_CHAINT+Space(9)+VVF->VVF_NUMNFI+VVF->VVF_SERNFI+cCdFor+cLojaF",2,.f.)
 	
   @ nLin,01 psay &cCompac  + cTipVei + OemToAnsi(STR0020) + cMarca + OemToAnsi(STR0021) + cDesMod + Space(8) + VVG->VVG_SITTRI + Space(3) + SD2->D2_UM + Space(3) + Transform(SD2->D2_QUANT,"@E 999") + Space(7) + Transform(SD1->D1_VUNIT,"@E 999,999,999.99") + Space(3) + Transform(SD1->D1_TOTAL,"@E 999,999,999.99") + Space(8) + Transform(SD2->D2_PICM,"@E 99.99")
   nLin := nLin + 1
   @ nLin,01 psay OemToAnsi(STR0022) + VVG->VVG_CHASSI + OemToAnsi(STR0023)
   nLin := nLin + 1
   @ nLin,01 psay OemToAnsi(STR0024) + cCatego + OemToAnsi(STR0030) + cEspeci + OemToAnsi(STR0033) + cRenava   //OemToAnsi(STR0036) + cNumPas
   nLin := nLin + 1
   @ nLin,01 psay OemToAnsi(STR0025) + cProced + OemToAnsi(STR0031) + cCorVei + OemToAnsi(STR0026) + cEstado   //+ OemToAnsi(STR0037) + cFaixa
   nLin := nLin + 1
   @ nLin,01 psay OemToAnsi(STR0032) + cCombus + OemToAnsi(STR0038) + cAnoFab + OemToAnsi(STR0027) + cAnoMod
   nLin := nLin + 2

//   nLin := nLin + 1
//   @ nLin,01 psay OemToAnsi(STR0033) + cRenava + OemToAnsi(STR0028) + cPotMot + OemToAnsi(STR0035) + cNumMot   //+ OemToAnsi(STR0039) + cCMT
//   nLin := nLin + 1
//   @ nLin,01 psay OemToAnsi(STR0040) + cNumEix + OemToAnsi(STR0029) + cDisEix + OemToAnsi(STR0034) + cQtdCil   //+ OemToAnsi(STR0041) + cDifere
  

	VVG->(DbSkip())

Enddo


//@ 36,126 psay cInMFil

@ 44,002 psay Transform(SF1->F1_BASEICM,"@E 999,999,999.99") + Space(19) + Transform(SF1->F1_VALICM ,"@E 999,999,999.99") + Space(73) + Transform(SF1->F1_VALBRUT,"@E 999,999,999.99")
@ 45,122 psay Transform(SF1->F1_VALBRUT,"@E 999,999,999.99")

@ 47,002 psay cNomTra
@ 47,080 psay cEmiFre
@ 47,120 psay cCGCTra
@ 48,002 psay cEndTra
@ 48,080 psay cCidTra
@ 48,108 psay cEstTra
@ 48,120 psay cINSTra

@ 50,035 psay cMarca

if VVF->VVF_OPEMOV ="0"  //venda
   @ 52,002  psay OemToAnsi(STR0042) + cVended  //50
   @ 53,002  psay OemToAnsi(STR0043) + cDesFpg
   @ 54,002  psay OemToAnsi(STR0045)  //via de transporte rodoviario   
else                  
   @ 52,002  psay OemToAnsi(STR0044) + "000008 - JORGE"   //cVended  - 50
   @ 53,002  psay OemToAnsi(STR0045)  //via de transporte rodoviario
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

Static Function FS_FATUR()
*********************
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
