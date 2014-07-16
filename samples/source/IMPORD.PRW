/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ FG_ImpOrd³ Autor ³  Emilton              ³ Data ³ 01/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime Ordem de Servico (Formulario Comum/Especifico)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
# Include "IMPORD.CH"

&&USER FUNCTION IMPORD(cNum,cReg,cTip)
USER FUNCTION IMPORD()
**********************

SetPrvt("lFlgImp,aLimImp,nNumLin,nTamLin")
SetPrvt("cNumOsv,cNumBox,cReceEm,dDatAbe,cHorAbe,nKilome,dDatVei,cCampo")
SetPrvt("cNomEmp,cCGCFil,cEndEmp,cCEPFil,cTelFil,cFaxFil,cInsFil,cCidFil")
SetPrvt("cEstFil,cNomPro,cEndPro,cBaiPro,cCepPro,cCGCPro,cInsPro,cCidPro")
SetPrvt("cEstPro,cFonPro,cNomFat,cEndFat,cBaiFat,cCEPFat,cCGCFat,cInsFat")
SetPrvt("cCidFat,cEstFat,cFonFat,cPlaVei,cChaVei,cMotVei,cCorVei,cFabVei")
SetPrvt("cConVei,cCodFro,cTipMot,cModVei,cMarVei,cNomMot,cFonMot,cCidMot")
SetPrvt("cEstMot,cDDDMot,cTipDoc,cNumDoc,cCidOri,cCidDes,cNomCon")
SetPrvt("aSerVis,aRequis")
SetPrvt("cConPgt,nTotNot,nNumNFS,cStatus,nTemPad,cIndIS1,cIndIS2,cIndIM1")
SetPrvt("cIndIM2,cIndIM3,cLinDet,dDatFec")
SetPrvt("nNotApc,nNotAsv,nNotPro,nNotSrv,nValSrv,cDesSrv")
SetPrvt("nValPro,nDesPro,nLubrif,nNaoOri,nOutMar,nOrigin")
SetPrvt("nAplDir,nOutTip")
SetPrvt("cCampo1,cCampo2,cCampo3")
SetPrvt("nLubrif,nNaoOri,nOutMar,nOrigin,nOutTip,nDesPro")

nNotApc := 0
nNotAsv := 0
nNotPro := 0
nNotSrv := 0
nValSrv := 0
cDesSrv := 0
nValPro := 0
nDesPro := 0
nLubrif := 0
nNaoOri := 0
nOutMar := 0
nOrigin := 0
nAplDir := 0
nOutTip := 0
cCampo1 := ""
cCampo2 := ""
cCampo3 := ""
aSerVis := {}
aRequis := {}
lFlgImp := .f.
aLimImp := {}
nNumLin := 0
nTamLin := 0

cNumOsv := ParamIxb[1]
cParamt := ParamIxb[2]
cTipPrg := ParamIxb[3]

if cTipPrg == "IMPORD"
  
   cDesc1     :=""
   cDesc2     :=""
   cDesc3     :=""
   cString    :="SD1"
   aRegistros := {}
   ctitulo    := OemToAnsi("Emissao da Ordem de Servico")
   ctamanho   := "M"
   aReturn    :=  { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
   nLastKey   := 0
   lServer    := .f.

   cDrive     := GetMv("MV_DRVOSN")
   cNomeImp   := GetMv("MV_POROSN")
   cAlias  := "VO1"
   cNomRel := "IMPORD"
   cTitulo := STR0025
   Titulo  := STR0025

   lHabil := .f.   
   lServer:= .f.

   cNomRel := SetPrint(cString,cNomRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil    ,cDrive,.T.  ,lServer,cNomeImp)

   If nlastkey == 27
      Return(Allwaystrue())
   EndIf

   SetDefault(aReturn,cAlias)

*** Ponto de Entrada para o Formulario Comum

	aDriver := LeDriver()
	cNormal := aDriver[2]

   Set Printer to &cNomRel
   Set Printer On
   Set Device to Printer

   If cParamt == "S"

   ***FG_SEEK("VO1","cNumOsv",1,.f.)
      FG_SEEK("VV1","VO1->VO1_CHAINT",1,.f.)
      FG_SEEK("VE4","VV1->VV1_CODMAR",1,.f.)
      FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORVEI",1,.f.)
      FG_SEEK("VV2","VV1->VV1_CODMAR+VV1->VV1_MODVEI",1,.f.)
      FG_SEEK("VO5","VO1->VO1_CHAINT",1,.f.)
      FG_SEEK("VVK","VV1->VV1_CODMAR+VV1->VV1_CODCON",1,.f.)
      FG_SEEK("SA1","VV1->VV1_PROATU",1,.f.)
      FG_SEEK("AA1","VO1->VO1_FUNABE",1,.f.)
      FG_SEEK("VOG","VO1->VO1_CODMOT",1,.f.)

   Else

      cKeyAce := cNumOsv
      FG_SEEK("VO1","cKeyAce",1,.f.)
      FG_SEEK("VV1","VO1->VO1_CHAINT",1,.f.)
      FG_SEEK("VE4","VV1->VV1_CODMAR",1,.f.)
      FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORVEI",1,.f.)
      FG_SEEK("VV2","VV1->VV1_CODMAR+VV1->VV1_MODVEI",1,.f.)
      FG_SEEK("VO5","VO1->VO1_CHAINT",1,.f.)
      FG_SEEK("VVK","VV1->VV1_CODMAR",1,.f.)
      FG_SEEK("SA1","VV1->VV1_PROATU",1,.f.)
      FG_SEEK("AA1","VO1->VO1_FUNABE",1,.f.)
      FG_SEEK("VOG","VO1->VO1_CODMOT",1,.f.)

   Endif

   cNumOsv := if(cParamt == "S",VO1->VO1_NUMOSV,VO1->VO1_NUMOSV)
   cNumBox := if(cParamt == "S",VO1->VO1_NUMBOX,VO1->VO1_NUMBOX)
   cReceEm := if(cParamt == "S",dtoc(VO1->VO1_DATENT),dtoc(VO1->VO1_DATENT))+" as "+if(cTipPrg == "1",transform(M->VO1_HORENT,"@R 99:99"),transform(VO1->VO1_HORENT,"@R 99:99"))
   dDatAbe := if(cParamt == "S",VO1->VO1_DATABE,VO1->VO1_DATABE)
   cHorAbe := if(cParamt == "S",transform(VO1->VO1_HORABE,"@R 99:99"),transform(VO1->VO1_HORABE,"@R 99:99"))
   nKilome := if(cParamt == "S",VO1->VO1_KILOME,VO1->VO1_KILOME)

   dDatVei := If(VE4->VE4_VDAREV == "2",dtoc(VO5->VO5_PRIREV),dtoc(VO5->VO5_DATVEN))

   for i:= 1 to 5

       cCampo  := "cObser"+STR(i,1)
       cKeyAce := VO1->VO1_OBSMEM + strzero(i,3)   

       if FG_SEEK("SYP","cKeyAce",1,.f.)
      
          nPos := AT("\13\10",SYP->YP_TEXTO)
          if nPos > 0
             nPos-=7
          Else
             nPos := Len(SYP->YP_TEXTO)   
          Endif
          &cCampo := Substr(SYP->YP_TEXTO,1,nPos)
       Else
          &cCampo := " "
       Endif   

   next

   cNomEmp := left(SM0->M0_NOMECOM,40)
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
   cBaiPro := SA1->A1_BAIRRO
   cCepPro := SA1->A1_CEP 
   
   cCGCCPF := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
   cCGCPro := cCGCCPF + space(18-len(cCGCCPF))
   
   cInsPro := SA1->A1_INSCR
   cCidPro := SA1->A1_MUN
   cEstPro := SA1->A1_EST
   cFonPro := SA1->A1_TEL

   DbSelectArea("VV1")
   DbSetOrder(1)
   Dbseek(xFilial("VV1")+VO1->VO1_CHAINT)
   DbSelectarea("VE1")
   DbsetOrder(1)
   DbSeek(xFilial("VE1")+VV1->VV1_CODMAR)          
   
   If !empty(if(cParamt == "S",VO1->VO1_FATPAR,VO1->VO1_FATPAR))
      FG_SEEK("SA1","VV1->VV1_PROATU",1,.f.)
      cNomFat := left(SA1->A1_NOME,40)
      cEndFat := SA1->A1_END
      cBaiFat := SA1->A1_BAIRRO
      cCEPFat := SA1->A1_CEP
      cCGCFat := SA1->A1_CGC
      cInsFat := SA1->A1_INSCR
      cCidFat := SA1->A1_MUN
      cEstFat := SA1->A1_EST
      cFonFat := SA1->A1_TEL
   Endif

   cPlaVei := VV1->VV1_PLAVEI
   cChaVei := VV1->VV1_CHASSI
   cMotVei := VV1->VV1_NUMMOT
   cCorVei := left(VVC->VVC_DESCRI,15)
   cFabVei := VV1->VV1_FABMOD
   if (!EMPTY(VV1->VV1_CODCON),  cConVei := VVK->VVK_RAZSOC, cConVei := space(30)) 
   cCodFro := VV1->VV1_CODFRO
   cTipMot := VV1->VV1_TIPMOT

   cModVei := left(VV2->VV2_DESMOD,28)
   cMarVei := left(VE1->VE1_DESMAR,15)

   cNomMot := left(VOG->VOG_NOMMOT,29)
   cFonMot := VOG->VOG_FONMOT
   cCidMot := VOG->VOG_CIDMOT
   cEstMot := ""
   cDDDMot := ""
   cTipDoc := VOG->VOG_TIPDOC
   cNumDoc := VOG->VOG_NUMDOC

   cCidOri := ""
   cCidDes := ""

   cNomCon := AA1->AA1_NOMTEC

   aSerVis := {}
   aRequis := {}
   cConPgt := ""
   nTotNot := 0
   nNumNFS := 0

   cStatus := if(cParamt == "S",VO1->VO1_STATUS,VO1->VO1_STATUS)

   If cParamt != "S"

******cChave := If(cParamt == "S",VO1->VO1_NUMOSV,VO1->VO1_NUMOSV)+"S"
      cKeyAce := VO1->VO1_NUMOSV
      If FG_SEEK("VO2","cKeyAce",1,.f.)

         dbSelectar("VO4")

         FG_SEEK("VO4","VO2->VO2_NOSNUM",1,.f.)

         While VO2->VO2_NOSNUM == VO4->VO4_NOSNUM .and. !eof()

            If aScan(aSerVis,VO4->VO4_CODSER)== 0
               nTemPad := FG_TEMPAD(VO1->VO1_CHAINT,VO4->VO4_CODSER,"F")
               aAdd(aSerVis,VO4->VO4_CODSER+VO4->VO4_CODPRO+" "+left(VO6->VO6_DESABR,18)+transform(nTemPad,"@R 999:99"))
            EndIf
            dbSkip()

         EndDo

      EndIf

      dbselectarea("VO2")
******cChave := If(cParamt == "S",VO1->VO1_NUMOSV,VO1->VO1_NUMOSV)+"P"
      cKeyAce := VO1->VO1_NUMOSV

      If FG_SEEK("VO2","cKeyAce",1,.f.)

         cKeyAce := "P"+If(cParamt == "S",VO1->VO1_NUMOSV,VO1->VO1_NUMOSV)

         while cKeyAce == VO2->VO2_TIPREQ+VO2->VO2_NUMOSV .and. !eof()

            aAdd(aRequis,VO2->VO2_NOSNUM)
            dbSkip()

         EndDo

      EndIf

   EndIf
  
   SETPRC(00,00)
   @ 00,01 psay &cNormal 
   @ 01,01 psay STR0026 + cNomEmp 
   @ 01,58 psay "!   " + STR0027
   @ 02,01 psay STR0028 + cEndEmp
   @ 02,58 psay "!"
   @ 03,01 psay STR0029 + cCidFil + STR0030 + cEstFil + STR0031 + cCEPFil
   @ 03,58 psay "!   Nro.: " + strzero(val(cNumOsv),8) 
***@ 03,69 psay strzero(val(cnumosv),8)
   @ 04,01 psay STR0032 + cTelFil + STR0033 + cFaxFil 
   @ 04,58 psay "!   " + STR0034 + strzero(day(dDatAbe),2)+"/"+strzero(month(dDatAbe),2)+"/"+strzero(year(dDatAbe),4)
   @ 05,01 psay STR0035 + cCGCFil + STR0036 + cInsFil 
   @ 05,58 psay "!   " + STR0037 + cHorAbe
   @ 06,01 psay replicate("-",79)
   @ 07,01 psay STR0038 + cNomPro + STR0039 + cFonPro
   @ 08,01 psay STR0040 + cEndPro + "  " + cBaiPro
   @ 09,01 psay STR0041 + cCidPro + STR0042 + cEstPro + STR0043 + transform(cCepPro,"@R 99999-999")
   @ 10,01 psay STR0044 + cCGCPro + STR0045 + cInsPro

   @ 11,01 psay "--"+STR0046+replicate("-",59)
   @ 12,01 psay STR0047 + cPlaVei + STR0048 + cChaVei + STR0049 + cMotVei + " " + cTipMot
   @ 13,01 psay STR0050 + cMarVei + STR0051 + cModVei + STR0052 + Left(cCorVei,15)
   @ 14,01 psay STR0053 + transform(cFabVei,"@R 9999/9999") + STR0054 + cConVei + STR0055 + dDatVei
   @ 15,01 psay STR0057 + str(nKilome,8) + STR0056 + cCodFro
   @ 16,01 psay replicate("-",79)
   @ 17,01 psay STR0058 + cNomMot + " " + cCidMot + " " + cEstMot + " " + cDDDMot + cFonMot


   @ 18,01 psay "--"+STR0059+"----------------------------------------------------------------"
   @ 19,01 psay cObser1
   @ 20,01 psay cObser2
   @ 21,01 psay cObser3
   @ 22,01 psay cObser4
   @ 23,01 psay cObser5

*******************************************************************************
*
*  @ 24,01 psay chr(15)
*  @ 24,02 psay "Servicos a Executar"
*  @ 25,02 psay "Codigo           Mec. Descricao                ! Codigo           Mec. Descricao                ! Requisicoes de Pecas"
*
*  for I = 1 to 23
*
*      cIndIS1 := (I * 2) - 1
*      cIndIS2 := (I * 2)
*      cIndIM1 := (I * 3) - 2
*      cIndIM2 := (I * 3) - 1
*      cIndIM3 := (I * 3)
*
*      cLinDet := if(len(aSerVis) >= cIndIS1,aSerVis[cIndIS1] + " ! ",space(47) + "! ")
*      cLinDet += if(len(aSerVis) >= cIndIS2,aSerVis[cIndIS2] + " ! ",space(47) + "! ")
*      cLinDet += if(len(aRequis) >= cIndIM1,aRequis[cIndIM1] + "/"  ,space(7))
*      cLinDet += if(len(aRequis) >= cIndIM2,aRequis[cIndIM2] + "/"  ,space(7))
*      cLinDet += if(len(aRequis) >= cIndIM3,aRequis[cIndIM3]        ,space(6))
*
*      @ 25+I,02 psay cLinDet
*
*  next
*
*  @ 49,00 psay chr(18)
*
*******************************************************************************

   @ 23,02 psay STR0060
   @ 24,02 psay STR0061

   for I = 1 to 23

       cIndIS1 := (I * 2) - 1
*******cIndIS2 := (I * 2)
       cIndIM1 := (I * 3) - 2
       cIndIM2 := (I * 3) - 1
       cIndIM3 := (I * 3)

       cLinDet := if(len(aSerVis) >= cIndIS1,aSerVis[cIndIS1] + " ! ",space(47) + "! ")
*******cLinDet += if(len(aSerVis) >= cIndIS2,aSerVis[cIndIS2] + " ! ",space(47) + "! ")
       cLinDet += if(len(aRequis) >= cIndIM1,aRequis[cIndIM1] + "/"  ,space(7))
       cLinDet += if(len(aRequis) >= cIndIM2,aRequis[cIndIM2] + "/"  ,space(7))
       cLinDet += if(len(aRequis) >= cIndIM3,aRequis[cIndIM3]        ,space(6))

       @ 24+I,02 psay cLinDet

   next

   @ 48,01 psay replicate("-",79)

   do case

******case If(cParamt == "S",VO1->VO1_STATUS,VO1->VO1_STATUS) == "C"
      case VO1->VO1_STATUS == "C"

           @ 50,08 psay STR0073
           @ 51,01 psay ""
           @ 52,01 psay ""
           @ 53,01 psay ""
           @ 54,01 psay ""
           @ 55,01 psay ""

******case If(cParamt == "S",VO1->VO1_STATUS,VO1->VO1_STATUS) == "F"   //   ORDEM DE SERVICO FECHADA, IMPRIME VALORES DE NOTAS FISCAIS
      case cParamt == "N"

           nNumLin := 49

           If FG_SEEK("VOO","VO1->VO1_NUMOSV",1,.F.)

              dbSelectArea("VOO")
              While VO1->VO1_NUMOSV == VOO->VOO_NUMOSV .and. !eof()

                 FG_SEEK("VOI","VOO->VOO_TIPTEM",1,.f.)
                 aAdd(aLimImp,"TT: "+VOO->VOO_TIPTEM+" "+Left(VOI->VOI_DESTTE,13)+" NF: "+VOO->VOO_NUMNFI+" "+Transform(VOO->VOO_TOTPEC+VOO->VOO_TOTSRV,"@e 99,999.99"))
                 dbSkip()

              EndDo

           EndIf

           For i := 1 to len(aLimImp)

               If lFlgImp == .f.
                  lFlgImp := .t.
                  @ nNumLin ++,01 pSay aLimImp[i]
               Else
                  lFlgImp := .f.
                  @ nNumLin ++,pCol() pSay aLimImp[i]
               EndIf

           Next

           @ nNumLin++,01 psay replicate("-",79)
           @ nNumLin++,01 psay STR0066
           nNumLin++
           nNumLin++
           @ nNumLin++,01 psay "------------------------------------- -------------------- --------------------"
           @ nNumLin++,01 psay STR0067
      

******case If(cParamt == "S",VO1->VO1_STATUS,VO1->VO1_STATUS) == "A"
      case cParamt == "N"

           @ 50,08 psay STR0068
           @ 52,01 psay STR0069
           @ 53,01 psay STR0070
           @ 54,01 psay STR0071
           @ 56,01 psay "                   -----------------------------------"
           @ 57,01 psay STR0072 //+cNomMot
           @ 58,01 psay "                    "+cTipDoc+".: "//+cNumDoc

   endcase

   Eject

   Set device to Screen
   
   If aReturn[5]==1
      dbCommitAll()
      SET PRINTER TO
      OurSpool(cNomRel)
    Endif

    MS_Flush()

Else

   cDesc1     :=""
   cDesc2     :=""
   cDesc3     :=""
   cString    :="SD1"
   aRegistros := {}
   ctitulo    := OemToAnsi("Emissao da Ordem de Servico")
   ctamanho   := "M"
   aReturn    :=  { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
   nLastKey   := 0
   lServer    := .f.
   cDrive     := GetMv("MV_DRVOSE")
   cNomeImp   := GetMv("MV_POROSE")
   cAlias  := "VO1"
   cNomRel := "IMPOSV"
   cTitulo := STR0025
   Titulo  := STR0025          
   nNumLin := 1

   lHabil := .f.
   cTamanho:= "P"

   cNomRel := SetPrint(cString,cNomRel,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil    ,cDrive,.T.  ,lServer,cNomeImp)

   If nlastkey == 27
      Return(Allwaystrue())
   EndIf

   Set Printer to &cNomRel
   Set Printer On
   Set device to Printer

   cKeyAce := cNumOsv
   FG_SEEK("VO1","cKeyAce",1,.f.)
   FG_SEEK("VV1","VO1->VO1_CHAINT",1,.f.)
   FG_SEEK("VE4","VV1->VV1_CODMAR",1,.f.)
   FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORVEI",1,.f.)
   FG_SEEK("VV2","VV1->VV1_CODMAR+VV1->VV1_MODVEI",1,.f.)
   FG_SEEK("VO5","VO1->VO1_CHAINT",1,.f.)
   FG_SEEK("SA1","VV1->VV1_PROATU",1,.f.)
   FG_SEEK("VOG","VO1->VO1_CODMOT",1,.f.)
   cKeyAce := cNumOsv+cParamT
   FG_SEEK("VOO","cKeyAce",1,.f.)
   FG_SEEK("VO4","VOO->VOO_NUMNFI+VOO->VOO_SERNFI",7,.f.)
   FG_SEEK("AA1","VO4->VO4_FUNFEC",1,.f.)
   FG_SEEK("SF2","VOO->VOO_NUMNFI+VOO->VOO_SERNFI+VOO->VOO_FATPAR+VOO->VOO_LOJA",1,.f.)
   FG_SEEK("SE4","SF2->F2_COND",1,.f.)
   FG_SEEK("VOI","VOO->VOO_TIPTEM",1,.f.)

   *** Tipo de Data a Apresentar ************************************************

   If VE4->VE4_VDAREV == "1"
      dDatVei := VO5->VO5_DATVEN
   else
      dDatVei := VO5->VO5_PRIREV
   EndIf
   dDatFec := VO4->VO4_DATFEC

   *** Dados da Empresa *********************************************************

   cNomEmp := left(SM0->M0_NOMECOM,30)
   cCGCFil := transform(left(SM0->M0_CGC,14),"@R 99.999.999/9999-99")

   cEndEmp := left(SM0->M0_ENDENT,30)
   cCEPFil := transform(left(SM0->M0_CEPENT,14),"@R 99.999-999")
   cTelFil := SM0->M0_TEL
   cFaxFil := SM0->M0_FAX
   cInsFil := SM0->M0_INSC

   cCidFil := SM0->M0_CIDENT
   cEstFil := SM0->M0_ESTENT

   *** Dados do Proprietario ****************************************************

   cNomPro := left(SA1->A1_NOME,30)
   cEndPro := SA1->A1_END
   cBaiPro := SA1->A1_BAIRRO
   cCepPro := SA1->A1_CEP
   cCGCPro := SA1->A1_CGC
   cInsPro := SA1->A1_INSCR
   cCidPro := SA1->A1_MUN
   cEstPro := SA1->A1_EST
   cFonPro := SA1->A1_TEL

   *** Dados do Faturamento *****************************************************

   FG_SEEK("SA1","VOO->VOO_FATPAR+VOO->VOO_LOJA",1,.f.)
   cNomFat := left(SA1->A1_NOME,30)
   cEndFat := SA1->A1_END
   cBaiFat := SA1->A1_BAIRRO
   cCEPFat := SA1->A1_CEP
   cCGCFat := SA1->A1_CGC
   cInsFat := SA1->A1_INSCR
   cCidFat := SA1->A1_MUN
   cEstFat := SA1->A1_EST
   cFonFat := SA1->A1_TEL

   cPlaVei := VV1->VV1_PLAVEI
   cChaVei := VV1->VV1_CHASSI
   cMotVei := VV1->VV1_NUMMOT
   cCorVei := VVC->VVC_DESCRI
   cFabVei := Transform(VV1->VV1_FABMOD,"@R 9999/9999")
   cConVei := VVK->VVK_CODCON
   cCodFro := VV1->VV1_CODFRO
   cTipMot := VV1->VV1_TIPMOT
   cNumBox := VO1->VO1_NUMBOX

   cModVei := VV2->VV2_DESMOD
   cMarVei := VE1->VE1_DESMAR

   *** Dados do Motorista *******************************************************

   cNomMot := left(VOG->VOG_NOMMOT,29)
   cFonMot := VOG->VOG_FONMOT
   cCidMot := VOG->VOG_CIDMOT
   cEstMot := ""
   cDDDMot := ""
   cTipDoc := VOG->VOG_TIPDOC
   cNumDoc := VOG->VOG_NUMDOC

   cCidOri := ""
   cCidDes := ""

   cNomCon := AA1->AA1_NOMTEC

   *** Dados do Servico *********************************************************

   declare cLinhas[30]

***TS.Descricao Tp Servico        Valor
***xxxxxxxxxxxxXxxxxxxxxxX99,999,999.99999999/999999/999999/999999/999999/999999/999999
***xxxxxxxxxxxxXxxxxxxxxxX99,999,999.99999999/999999/999999/999999/999999/999999/999999
***         1         2         3         4         5         6         7         8
***123456789012345678901234567890123456789012345678901234567890123456789012345678901234
***xxxxxxxxxxxxXxxxxxxxxxX99,999,999.9999,999,999.99
***xxxxxxxxxxxxXxxxxxxxxxX99,999,999.9999,999,999.99

   cConPgt := SE4->E4_DESCRI
   aRequis := {}
   aVetSer := {}
   afill(cLinhas,space(36))
   ix3 := nTotNot := 0

   nNumLin := 1
   nTamLin := 0
   nNotApc := nNotAsv := nNotPro := nNotSrv := nValSrv := nDesSrv := nValPro := 0
   nDesPro := nLubrif := nNaoOri := nOutMar := nOrigin := nAplDir := nOutTip := 0
   cCampo1 := ""
   cCampo2 := ""
   cCampo3 := ""

   If VOI->VOI_SITTPO == "3"

      cKeyAce := VO1->VO1_NUMOSV+"S"

      If FG_SEEK("VO2","cKeyAce",1,.f.)

         If FG_SEEK("VO4","VO2->VO2_NOSNUM+VOO->VOO_TIPTEM",1,.f.)

            while VO2->VO2_NOSNUM+VOO->VOO_TIPTEM == VO4->VO4_NOSNUM+VO4->VO4_TIPTEM .and. !eof()

               if aScan(cLinhas,VO4->VO4_TIPSER) == 0

                  FG_SEEK("VOK","VO4->VO4_TIPSER",1,.f.)

                  for ix2 := 1 to 30
                      if empty(left(cLinhas[ix2],3))
                         exit
                      endif
                  next

                  cLinhas[ix2] := VO4->VO4_TIPSER+space(12)+VOK->VOK_DESSER+transform(VO4->VO4_VALINT,"@ez 999999,999.99")

               else

                  cLinhas[aScan(cLinhas,VO4->VO4_TIPSER)] := left(cLinhas[aScan(cLinhas,VO4->VO4_TIPSER)],35)+Transform(val(right(cLinhas[aScan(cLinhas,VO4->VO4_TIPSER)],13)) + VO4->VO4_VALINT,"@ez 999999,999.99")

               endif

               dbSkip()

            enddo

         EndIf

      EndIf

   Else

      If FG_SEEK("SF2","VOO->VOO_NUMNFI+VOO->VOO_SERNFI+VOO->VOO_FATPAR+VOO->VOO_LOJA",1,.f.)

         If FG_SEEK("SD2","SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA",3,.f.)

            dbSelectArea("SD2")
            dbSetOrder(3)

            while SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA .and. !eof()

               If FG_SEEK("SF4","SD2->D2_TES",1,.f.)

                  If SF4->F4_ISS == "S"

                     FG_SEEK("SB1","SD2->D2_COD",1,.f.)

                     cKeyAce := Left(SB1->B1_CODITE,3)
                     FG_SEEK("VOK","cKeyAce",1,.f.)

                     for ix2 := 1 to 30
                         if empty(left(cLinhas[ix2],3))
                            exit
                         endif
                     next

                     cLinhas[ix2] := VOK->VOK_TIPSER+space(14)+VOK->VOK_DESSER+space(05)+transform(D2_TOTAL,"@ez 999999,999.99")
                     nValSrv += D2_TOTAL
                     nDesSrv += D2_DESCON

                  EndIf

               EndIf

               dbSkip()

            EndDo

         EndIf

      EndIf

   EndIf

   *** Dados das Pecas **********************************************************

   cKeyAce := VO1->VO1_NUMOSV+"P"

   If FG_SEEK("VO2","cKeyAce",1,.f.)    && Numero das Requisicoes de Pecas  
   
      dbSelectArea("VO2")
      
      while cKeyAce == VO2->VO2_NUMOSV+VO2->VO2_TIPREQ .and. xFilial("VO2") == VO2->VO2_FILIAL .and. !eof()

         If nTamLin +  len(alltrim(str(val(VO2->VO2_NOSNUM)))) > 26
            nTamLin += len(alltrim(str(val(VO2->VO2_NOSNUM))))
            nNumLin ++
         EndIf
         If nNumLin > 3
            exit
         EndIf

         cLinhas[nNumLin] += alltrim(str(val(VO2->VO2_NOSNUM)))+"/"

         dbSkip()

      EndDo

   EndIf

   If FG_SEEK("SF2","VOO->VOO_NUMNFI+VOO->VOO_SERNFI+VOO->VOO_FATPAR+VOO->VOO_LOJA",1,.f.)

      nNotPro := SF2->F2_DOC
      nNotApc := SF2->F2_VALMERC

      If FG_SEEK("SD2","SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA",3,.f.)

         dbSelectArea("SD2")
         dbSetOrder(3)

         while SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA .and. !eof()

            If FG_SEEK("SF4","SD2->D2_TES",1,.f.)

               If SF4->F4_ISS == "S"
                  dbSkip()
                  Loop
               EndIf

               FG_SEEK("SB1","SD2->D2_COD",1,.f.)
               FG_SEEK("SBM","SB1->B1_GRUPO",1,.f.)

               If alltrim(SBM->BM_TIPGRU) == "1"

                  Do Case
                     Case SBM->BM_PROORI == "1"
                          nOrigin += SD2->D2_TOTAL
                     Case SBM->BM_PROORI == "0"
                          nNaoOri += SD2->D2_TOTAL
                  EndCase

               Else

                  Do Case
                     Case alltrim(SBM->BM_TIPGRU) == "2"
                          nLubrif += SD2->D2_TOTAL
                     Case alltrim(SBM->BM_TIPGRU) == "5"
                          nOutMar += SD2->D2_TOTAL
                     Case alltrim(SBM->BM_TIPGRU) == "6"
                          nAplDir += SD2->D2_TOTAL
                  OtherWise
                          nOutTip += SD2->D2_TOTAL
                  EndCase

               EndIf

               nValPro += SD2->D2_TOTAL
               nDesPro += SD2->D2_DESCON

            EndIf

            dbSkip()

         EndDo

      EndIf

   EndIf

   cLinhas[06] += transform(nLubrif,"@ez 99999,999.99")
   cLinhas[07] += transform(nNaoOri,"@ez 99999,999.99")
   cLinhas[08] += transform(nOutMar,"@ez 99999,999.99")
   cLinhas[09] += transform(nOrigin,"@ez 99999,999.99")
   cLinhas[10] += transform(nAplDir,"@ez 99999,999.99")
   cLinhas[11] += transform(nOutTip,"@ez 99999,999.99")

   cLinhas[16] += transform(nValPro,"@ez 99999,999.99")
   cLinhas[18] += transform(nDesPro,"@ez 99999,999.99")
   cLinhas[20] += transform(nValPro-nDesPro,"@ez 99999,999.99")

   cLinhas[23] += transform(nValSrv,"@ez 99999,999.99")
   cLinhas[25] += transform(cDesSrv,"@ez 99999,999.99")
   cLinhas[27] += transform(nValSrv-cDesSrv,"@ez 99999,999.99")

   cLinhas[30] += transform((nValPro-nDesPro)+(nValSrv-cDesSrv),"@ez 99999,999.99")

   *** Dados da Empresa *********************************************************

   @ 02,72        psay VO1->VO1_NUMOSV+"/"+VOO->VOO_TIPTEM

   &&@ 03,03        psay cNomEmp+" "+cEndEmp+" "+cInsFil+" "+cEstFil+" "+cCepFil
   @ 03,03        psay cEndEmp+" "+cInsFil+" "+cEstFil+" "+cCepFil
   @ 04,03        psay "C.G.C.: "+cCGCFil+" I.E.: "+cInsFil
   @ 04,75        psay dDatFec
   @ 05,03        psay "Telefone DDD: "+cTelFil+" Fax: "+cFaxFil

   *** Dados do Proprietario ****************************************************

   @ 06,10        psay cNomPro
   @ 06,62        psay cFonPro

   @ 07,10        psay cEndPro+" "+cBaiPro
   @ 07,66        psay Transform(cCEPPro,"@R 99.999-999")

   @ 08,10        psay cCidPro       
   @ 08,64        psay cEstPro

   @ 09,10        psay transform(cCgcpro,"@R 99.999.999/9999-99")
   @ 09,52        psay cInsPro

   *** Dados do Faturar Para ****************************************************

   @ 12,10        psay cNomFat
   @ 12,62        psay cFonFat

   @ 13,10        psay cEndFat+" "+cBaiFat
   @ 13,66        psay Transform(cCEPFat,"@R 99.999-999")

   @ 14,10        psay cCidFat
   @ 14,64        psay cEstFat

   @ 15,10        psay cCGCFat
   @ 15,52        psay cInsFat

   *** Dados do Veiculo *********************************************************

   @ 17,08        psay cPlaVei
   @ 17,26        psay cChaVei
   @ 17,54        psay cMotVei

   @ 18,08        psay cMarVei

   @ 18,56        psay cModVei
   @ 18,74        psay left(cCorVei,09)

   @ 19,08        psay cFabVei
   @ 19,26        psay cConVei
   @ 19,74        psay dDatVei

   @ 20,08        psay Transform(VO1->VO1_KILOME,"@e 99,999,999")
   @ 20,26        psay ""  && Cidade Origem
   @ 20,54        psay ""  && Cidade Destino

   @ 21,08        psay cNomMot

   @ 22,08        psay cNomCon
   @ 22,48        psay cNumBox
   @ 22,62        psay VO1->VO1_DATABE
   @ 22,73        psay Transform(VO1->VO1_HORABE,"@er 99:99")

   *** Observacoes **************************************************************

   for i:= 1 to 5

       cCampo  := "cObser"+STR(i,1)
       cKeyAce := VO1->VO1_OBSMEM + strzero(i,3)   

       if FG_SEEK("SYP","cKeyAce",1,.f.)
      
          nPos := AT("\13\10",SYP->YP_TEXTO)
          if nPos > 0
             nPos-=7
          Else
             nPos := Len(SYP->YP_TEXTO)   
          Endif
          &cCampo := Substr(SYP->YP_TEXTO,1,nPos)
       Else
          &cCampo := " "
       Endif   


   next

   @ 24,02 psay cCampo1
   @ 25,03 psay cCampo2
   @ 26,03 psay cCampo3

   *** Listagem de Servicos *****************************************************

   nNumLin := 30

   for i := 1 to 30

      if !empty(left(cLinhas[i],5))
         @ nNumLin,01 psay left(cLinhas[i],05)
         @ nNumLin,11 psay substr(cLinhas[i],17,25)
         @ nNumLin,38 psay substr(cLinhas[i],43,13)
      endif

      if i < 4
         @ nNumLin,pcol()+01 psay substr(cLinhas[i],57,48)
      else
         if str(i,2) $ " 6/ 7/ 8/ 9/10/16/18/20/23/25/27/30"
            @ nNumLin,72        psay right(cLinhas[i],12)
         endif
      endif

      nNumLin ++

   next

&&   @ 61,44 psay SF2->F2_DOC+space(04)+Transform(SF2->F2_VALMERC,"@ez 99,999,999.99")
   @ 61,44 psay SF2->F2_DOC+space(04)+Transform(SF2->F2_VALBRUT,"@ez 99,999,999.99")

   @ 61,70 psay cConPgt

   @ 64,10 psay cTipDoc+" "+cNumDoc

   Eject

   Set device to Screen
   
   If aReturn[5]==1
      dbCommitAll()
      SET PRINTER TO
      OurSpool(cNomRel)
    Endif

    MS_Flush()

Endif

Return

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
