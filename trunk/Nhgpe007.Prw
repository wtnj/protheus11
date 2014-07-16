#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Nhgpe007()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,NCOD")
SetPrvt("_NREC,_PD,_FILIAL,_TIPO1,_NVALOR,_OCORREN")
SetPrvt("_TPC,_CCC,")

/*                                                                       
------------------------------------------------ MANER INFORMATICA
LEILA MARUO EM 05/10/2000
LANCAMENTO CONTABIL DA PROVISAO NEGATIVO

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nordem:=0
tamanho:="M"
limite :=132
cString:="SRA"
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0

If nLastKey == 27
	Return Nil
Endif
/*/
If MsgYesNo("Confirma a Geracao da Contabilizacao ? ? ?","Processando gera‡Æo Contabilizacao ..............")
   RptStatus({|| fRZ_Imp()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>    RptStatus({|| Execute(fRZ_Imp)})  //-- Chamada do Relatorio.
EndIf
Return   

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function fRZ_Imp
Static Function fRZ_Imp()

DbSelectArea("SRZ")
DbSetorder(2)

SRZ->(SetRegua(RecCount()))
//SRZ->(DbGoTop())
//alterado em 07/11/2001 - Maner Consultoria
//tratar verbas 748- adic prov 13 sal 766- adic prov fer 767-1/3 prov ferias
//SRZ->(DbSeek("01"+ "758",.t.))
//While SRZ->(!Eof()) .and. SRZ->RZ_PD >= "758" .and. SRZ->RZ_PD <= "765"
SRZ->(DbSeek("01"+ "748",.t.))
While SRZ->(!Eof()) .and. SRZ->RZ_PD >= "748" .and. SRZ->RZ_PD <= "767"
   IncRegua()
   If SRZ->RZ_VAL < 0.00
      NCOD := "0"
//      iF SRZ->RZ_PD == "758"  alterado em 07/11/2001 - Maner Consultoria
      iF SRZ->RZ_PD == "758" .or. SRZ->RZ_PD == "766" .or. SRZ->RZ_PD == "767"
         NCOD := "782"
      eNDIF
      iF SRZ->RZ_PD == "759"
         NCOD := "783"
      eNDIF
      iF SRZ->RZ_PD == "760"
         NCOD := "784"    
      eNDIF
//      iF SRZ->RZ_PD == "763" alterado em 07/11/2001 - Maner Consultoria
      iF SRZ->RZ_PD == "763" .or.  SRZ->RZ_PD == "748"
         NCOD := "785"
      eNDIF
      iF SRZ->RZ_PD == "764"
         NCOD := "786"
      eNDIF
      iF SRZ->RZ_PD == "765"
         NCOD := "787"
      eNDIF
      IF NCOD <> "0"
         _nRec:=Recno()
         _PD:=SRZ->RZ_PD
         _fILIAL:=SRZ->RZ_FILIAL
         _TIPO1:=SRZ->RZ_TIPO
         iF SRZ->RZ_VAL < 0.00
            _nValor:=SRZ->RZ_VAL *(-1)
         eLSE
            _nValor:=SRZ->RZ_VAL
         Endif
         _OCORREN:=SRZ->RZ_OCORREN
         _TPC:=SRZ->RZ_TPC
         _cCC:=SRZ->RZ_CC
         SRZ->(DbSeek("01"+ NCOD+_cCC,.t.))
         If SRZ->RZ_FILIAL=="01" .AND. SRZ->RZ_PD==NCOD .AND. SRZ->RZ_CC==_cCC
            RecLock("SRZ",.F.)
            SRZ->RZ_VAL:=_nValor
            MsUnLock("SRZ")
         Else
            RecLock("SRZ",.T.)
            SRZ->RZ_FILIAL:=_FILIAL
            SRZ->RZ_PD:=NCOD
            SRZ->RZ_TIPO:=_TIPO1
            SRZ->RZ_VAL:=_nValor
            SRZ->RZ_OCORREN:=_OCORREN
            SRZ->RZ_CC:=_cCC
            SRZ->RZ_TPC:=_TPC
            MsUnLock("SRZ")
         Endif
         DbSelectArea("SRZ")
         DbSetOrder(0)
         SRZ->(DbGoto(_nRec))
         Do While SRZ->(Recno())==_nRec
            RecLock("SRZ",.F.)
            SRZ->(DbDelete())
            MsUnLock("SRZ")
            SRZ->(DbSkip())      
         EndDo
         DbSelectArea("SRZ")
         DbSetOrder(2)
         SRZ->(DbSeek("01"+ _PD+_CCC,.t.))
      ENDIF
   EndIf
   SRZ->(DbSkip())      
EndDO
RetIndex("SRZ")
Return
