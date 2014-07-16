#Include "NFSAIVEI.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ NFSAIVEI ³ Autor ³  Manoel               ³ Data ³ 07/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime Nota Fiscal de Veiculos (Saida)  Cotave            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION NFSAIVEI()

SetPrvt("aDriver,cObserv1,cObserv2,cObserv3,cObserv4,cObserv5,cTitulo,cDesc1,cDesc2,cDesc3,cNomeImp,lServer,cTamanho")

aReturn :=  { OemToAnsi(STR0010), 1,OemToAnsi(STR0011), 2, 2, 1, "",1 }

aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

cTitulo := cDesc1  := cDesc2 := cDesc3 := ""

cNomeRel :=  "NFSAIVEI"
cDrive     := GetMv("MV_DRVNFI")
cNomeImp   := GetMv("MV_PORNFI")
ctamanho := "M"   
cAlias   := "VV0"
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
cString  := "VV0"
Li       := 80
m_Pag    := 1

wnRel    := "VEIVM010"

nomeprog  := "NFSAIVEI"
tamanho   := "M"
nCaracter := 15

cNumNF := ParamIxb[1]
cSerNF := ParamIxb[2]

FG_SEEK("VV0","cNumNF+cSerNF",4,.f.)
FG_SEEK("VVA","VV0->VV0_NUMTRA",1,.f.)
FG_SEEK("VVG","VVA->VVA_CHAINT+VVA->VVA_TRACPA",2,.f.)
FG_SEEK("VV1","VVA->VVA_CHAINT",1,.f.)
FG_SEEK("VV2","VV1->VV1_CODMAR+VV1->VV1_MODVEI",1,.f.)
FG_SEEK("VV8","VV2->VV2_TIPVEI",1,.f.)
FG_SEEK("VVB","VV2->VV2_CATVEI",1,.f.)
FG_SEEK("VVE","VV2->VV2_ESPVEI",1,.f.)
FG_SEEK("VE1","VV1->VV1_CODMAR",1,.f.)
FG_SEEK("SA1","VV0->VV0_CODCLI+VV0->VV0_LOJA",1,.f.)
FG_SEEK("SA3","VV0->VV0_CODVEN",1,.f.)
FG_Seek("SB1","VVA->VVA_CHAINT",1,.f.)
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

for i:= 1 to 5

    cKeyAce := VVA->VVA_OBSMEM + strzero(i,3)
    cCampo  := "cObserv"+STR(i,1)
                                                                        
    if FG_SEEK("SYP","cKeyAce",1,.f.)
      
       nPos1 := AT("\13\10",SYP->YP_TEXTO)
       if nPos1 > 0
          nPos := len(alltrim(SYP->YP_TEXTO)) - 6
       else
          nPos := len(alltrim(SYP->YP_TEXTO))
       endif
          
       &cCampo := Substr(SYP->YP_TEXTO,1,nPos)

    Else
       &cCampo := " "

    Endif   

next

cNomEmp := left(SM0->M0_NOMECOM,30)
cCGCFil := transform(left(SM0->M0_CGC,14),"@R 99.999.999/9999-99")

cEndEmp := left(SM0->M0_ENDENT,30)
cCEPFil := transform(SM0->M0_CEPENT,"@R 99.999-999")
cInMFil := transform(SM0->M0_CODMUN,"@R 999.999/9")
cTelFil := SM0->M0_TEL
cFaxFil := SM0->M0_FAX
cInsFil := SM0->M0_INSC
cCidFil := SM0->M0_CIDENT
cEstFil := SM0->M0_ESTENT


cNomPro := SA1->A1_NOME
cEndPro := SA1->A1_END
cBaiPro := Subs(SA1->A1_BAIRRO,1,15)
cCepPro := transform(SA1->A1_CEP,"@R 99999-999")
cCGCCPF1  := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))
cInsPro := SA1->A1_INSCR
cCidPro := SA1->A1_MUN
cEstPro := SA1->A1_EST
cFonPro := SA1->A1_TEL

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
cModVei := subs(VV2->VV2_MODVEI,1,8)
cTipVei := Subs(VV8->VV8_DESCRI,1,17)
cCatego := Subs(VVB->VVB_DESCRI,1,15)
cEspeci := Subs(VVE->VVE_DESCRI,1,15)

cVended := SA3->A3_COD + " - " + SA3->A3_NOME
cDesFpg := alltrim(SE4->E4_DESCRI)

aTit  := {}
aTit1 := {}
                               
dbselectArea("SE1")
DbSetOrder(1)
dbgotop()
DbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DUPL)

nPar := 0 
nValor := 0

do while !eof() .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM = SF2->F2_FILIAL+SF2->F2_PREFIXO+SF2->F2_DUPL                        


    if SE4->E4_CODIGO = "006" //VIP
       exit   
    endif
    
    
*   if SE1->E1_BAIXA = ctod("  /  /  ")

      aAdd(aTit,{SE1->E1_PREFIXO+SE1->E1_NUM+"/"+SE1->E1_PARCELA,transform(SE1->E1_VALOR,"@e 999,999.99"),SE1->E1_VENCTO})

      if SE1->E1_PARCELA  >="1"
         nValor := nValor + SE1->E1_VALOR  
      endif

      if SE4->E4_TIPO = "A"
         if SE1->E1_PARCELA = "0"
            n_Razao := SE1->E1_VENCTO - SE1->E1_EMISSAO 
            d_Ant := SE1->E1_VENCTO  
            aAdd(aTit1,strzero(n_Razao,3)) 
            npar++
         elseif SE1->E1_PARCELA = "1" .and. npar = 0
            n_Razao := SE1->E1_VENCTO - SE1->E1_EMISSAO 
            d_Ant := SE1->E1_VENCTO  
            aAdd(aTit1,strzero(n_Razao,3))          
         else                                             
            n_Razao := SE1->E1_VENCTO - d_Ant 
            d_Ant := SE1->E1_VENCTO       
            aAdd(aTit1,strzero(n_Razao,3)) 
         endif
      endif

*   endif  

   dbselectArea("SE1")
   dbskip()

enddo  
    
DbSelectArea("SE4")
Dbsetorder(1)
dbgotop()
DbSeek(xFilial("SE4")+SF2->F2_COND)

if SE4->E4_TIPO # "A"
   cDesFpg := SF2->F2_COND+" - "+SE4->E4_DESCRI
elseif SE4->E4_TIPO = "A" .and. SE4->E4_CODIGO = "006"   //VIP
   cDesFpg := SF2->F2_COND+" - "+"A PRAZO"                               
else
   cDescri := ""
   for xz = 1 to len(aTit1)
      cDescri := cDescri + atit1[xz] + ","          
   next         
   if len(aTit1) = 0
      cDescri := "A VISTA"
   else                     
      cDescri := cDescri + " Dias"
   endif 
   cDesFpg := SF2->F2_COND+" - "+cDESCRI
endif

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
 	
@ 19,01 psay &cCompac  + cTipVei + OemToAnsi(STR0020) + cMarca + OemToAnsi(STR0021) + cDesMod + Space(8) + VVG->VVG_SITTRI + Space(3) + SD2->D2_UM + Space(3) + Transform(SD2->D2_QUANT,"@E 999") + Space(7) + Transform(SF2->F2_VALMERC,"@E 999,999,999.99") + Space(3) + Transform(SF2->F2_VALMERC,"@E 999,999,999.99") + Space(8) + Transform(SD2->D2_PICM,"@E 99.99")
//@ 20,01 psay OemToAnsi(STR0022) + VVG->VVG_CHASSI + OemToAnsi(STR0061)   + cModvei + space(3) + OemToAnsi(STR0023)
@ 20,01 psay OemToAnsi(STR0022) + VVG->VVG_CHASSI + OemToAnsi("Cod. Mod.:")   + cModvei + space(3) + OemToAnsi(STR0023)
@ 21,01 psay OemToAnsi(STR0024) + cCatego + OemToAnsi(STR0030) + cEspeci + OemToAnsi(STR0033) + cRenava   //OemToAnsi(STR0036) + cNumPas
@ 22,01 psay OemToAnsi(STR0025) + cProced + OemToAnsi(STR0031) + cCorVei + OemToAnsi(STR0026) + cEstado   //+ OemToAnsi(STR0037) + cFaixa
@ 23,01 psay OemToAnsi(STR0032) + cCombus + OemToAnsi(STR0038) + cAnoFab + OemToAnsi(STR0027) + cAnoMod

//@ 24,01 psay OemToAnsi(STR0033) + cRenava + OemToAnsi(STR0028) + cPotMot + OemToAnsi(STR0035) + cNumMot   //+ OemToAnsi(STR0039) + cCMT
//@ 25,01 psay OemToAnsi(STR0040) + cNumEix + OemToAnsi(STR0029) + cDisEix + OemToAnsi(STR0034) + cQtdCil   //+ OemToAnsi(STR0041) + cDifere
//@ 27,01 psay OemToAnsi(STR0029) + cDisEix + OemToAnsi(STR0035) + cNumMot   //+ OemToAnsi(STR0041) + cDifere

@ 26,01 psay cObserv1
@ 27,01 psay cObserv2
@ 28,01 psay cObserv3
@ 29,01 psay cObserv4
@ 30,01 psay cObserv5

cDecl := ""
cCgcCpf3 := ""
cCid := ""
cEst := ""
cCep := ""
cIns := ""
cEnd := ""
cRg  := ""

FG_SEEK("VV3","VV0->VV0_TIPVEN",1,.F.)
cDecl := RTRIM(VV3->VV3_DESCRI)
if !EMPTY(VV0->VV0_CLIALI)
   FG_SEEK("SA1","VV0->VV0_CLIALI+VV0->VV0_LOJALI",1,.f.)
   cDecl := cDecl + " " + rtrim(SA1->A1_NOME)
   cCGCCPF2 := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
   cCGCCPF3 := cCGCCPF2 + space(18-len(cCGCCPF2))
   cCid     := rtrim(SA1->A1_MUN)
   cEst     := SA1->A1_EST
   cIns     := SA1->A1_INSCR
   cRg      := SA1->A1_INSCR
   cCep     := SA1->A1_CEP
   cEnd     := rtrim(SA1->A1_END)
   if len(trim(SA1->A1_CGC)) < 14 //fisica
      cDecl := cDecl +"," + OemToAnsi(STR0051) + cCgcCpf3 + "," + OemToAnsi(STR0052)+ cRg + "," +OemToAnsi(STR0054)
      cDecl := cDecl + cEnd + "," +OemToAnsi(STR0055) + cCid + OemToAnsi(STR0058) + cEst + "," + OemToAnsi(STR0056) + cCep + "."
   else   
      cDecl := cDecl + "," + OemToAnsi(STR0057) + cCgcCpf3 + "," + OemToAnsi(STR0053)+ cIns + "," + OemToAnsi(STR0054)
      cDecl := cDecl + cEnd + "," + OemToAnsi(STR0055) + cCid + OemToAnsi(STR0058) + cEst + "," +OemToAnsi(STR0056) + cCep + "."  
   endif
   
endif

if VV0->VV0_OPEMOV ="0"  //venda
   @ 32,001 psay OemToAnsi(STR0047)+ " " +left(cDecl,65)
   @ 33,001 psay subs(cDecl,66,135)
   @ 34,001 psay subs(cDecl,201,135)
endif

@ 44,002  psay Transform(SF2->F2_BASEICM,"@E 999,999,999.99") + Space(19) + Transform(SF2->F2_VALICM ,"@E 999,999,999.99") + Space(73) + Transform(SF2->F2_VALMERC,"@E 999,999,999.99")

@ 45,065  psay Transform(VV0->VV0_DESACE,"@E 999,999,999.99")    //DESP. ACESSORIO
@ 45,122  psay Transform(SF2->F2_VALMERC,"@E 999,999,999.99")    

@ 47,002  psay cNomTra  //45
@ 47,080  psay cEmiFre
@ 47,120  psay cCGCTra
@ 48,002  psay cEndTra
@ 48,080  psay cCidTra
@ 48,108  psay cEstTra
@ 48,120  psay cINSTra

@ 50,035  psay cMarca  //48 52

if VV0->VV0_OPEMOV ="0"  //venda
   @ 52,002  psay OemToAnsi(STR0042) + cVended  //50
   @ 53,002  psay OemToAnsi(STR0043) + cDesFpg                  
   @ 54,002  psay OemToAnsi(STR0060)  //via de transporte rodoviario
else                  
   @ 52,002  psay OemToAnsi(STR0059) + cVended  //50             
   @ 53,002  psay OemToAnsi(STR0060)  //via de transporte rodoviario
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

if SE4->E4_TIPO = "A" .and. SE4->E4_CODIGO = "006"   //VIP
   return
endif    

nLin := 14

if len(aTit) <= 12 

   for xa = 1 to len(aTit)
     
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

else

   if subs(aTit[1,1],11,1) = "0"    //tem entrada
   
      @ nLin, 000 pSay aTit[xa,1] //DUPLICATA
      @ nLin, 017 pSay aTit[xa,2] //VALOR
      @ nLin, 032 pSay aTit[xa,3] //VENCTO 

      @ nLin, 047 pSay "A Prazo"   // total a prazo
      @ nLin, 063 pSay nValor
       
   endif
   
endif

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
