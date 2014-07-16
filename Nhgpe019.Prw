#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Nhgpe019()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,_SALARIO")
SetPrvt("_ABONO,")

/*                                                                       
------------------------------------------------ MANER INFORMATICA
LEILA MARUO EM 15/12/2000
ABONO CONFORME CONVENCAO COLETICA DE 12/2000

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
If MsgYesNo("Confirma a Geracao de Abono Convencao 12/2001","Processando gera‡Æo Contabilizacao ..............")
   RptStatus({|| fRZ_Imp()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>    RptStatus({|| Execute(fRZ_Imp)})  //-- Chamada do Relatorio.
EndIf
Return   

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function fRZ_Imp
Static Function fRZ_Imp()

DbSelectArea("SR1")
DbSetorder(1)
DbSelectArea("SRA")
DbSetorder(1)

SRA->(SetRegua(RecCount()))
SRA->(DbGoTop())

While SRA->(!Eof()) 
   IncRegua()
   _SALARIO := 0.00
   _ABONO:= 0.00
   If SRA->RA_SITFOLH <> 'D' .AND. SRA->RA_SITFOLH <> 'T'
      IF DTOS(SRA->RA_ADMISSA) < '20011201'
         _SALARIO := SRA->RA_SALARIO
         IF SRA->RA_CATFUNC == 'H'
            _SALARIO := SRA->RA_SALARIO * SRA->RA_HRSMES
         Endif
         _ABONO:= ROUND((_SALARIO * 10 /100),2)
         IF _ABONO > 210.00
            _ABONO := 210.00
         Endif
         SR1->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+"250",.t.))
         If SR1->R1_FILIAL==SRA->RA_FILIAL .AND. SR1->R1_MAT==SRA->RA_MAT .AND. SR1->R1_PD=='250'
            RecLock("SR1",.F.)
            SR1->R1_VALOR:=_ABONO
            MsUnLock("SR1")
         Else
            RecLock("SR1",.T.)
            SR1->R1_FILIAL:=SRA->RA_FILIAL
            SR1->R1_MAT:=SRA->RA_MAT
            SR1->R1_PD:='250'
            SR1->R1_TIPO1:='V'
            SR1->R1_VALOR:=_ABONO
            SR1->R1_PARCELA:=0
            SR1->R1_CC:=SRA->RA_CC
            SR1->R1_TIPO2:='I'
            SR1->R1_DATA:=ddatabase 
            SR1->R1_SEMANA := ""
            MsUnLock("SR1")
         ENDIF  
         SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+"250",.t.))
         If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD=='250'
            RecLock("SRC",.F.)
            SRC->RC_VALOR:=_ABONO
            MsUnLock("SRC")
         Else
            RecLock("SRC",.T.)
            SRC->RC_FILIAL:=SRA->RA_FILIAL
            SRC->RC_MAT:=SRA->RA_MAT
            SRC->RC_PD:='250'
            SRC->RC_TIPO1:='V'
            SRC->RC_VALOR:=_ABONO
            SRC->RC_PARCELA:=0
            SRC->RC_CC:=SRA->RA_CC
            SRC->RC_TIPO2:='I'
            SRC->RC_DATA:=ddatabase
            MsUnLock("SRC")
         ENDIF
         SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+"424",.t.))
         If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD=='424'
            RecLock("SRC",.F.)
            SRC->RC_VALOR:=_ABONO
            MsUnLock("SRC")
         Else
            RecLock("SRC",.T.)
            SRC->RC_FILIAL:=SRA->RA_FILIAL
            SRC->RC_MAT:=SRA->RA_MAT
            SRC->RC_PD:='424'
            SRC->RC_TIPO1:='V'
            SRC->RC_VALOR:=_ABONO
            SRC->RC_PARCELA:=0
            SRC->RC_CC:=SRA->RA_CC
            SRC->RC_DATA:=ddatabase
            SRC->RC_TIPO2:='I'
            MsUnLock("SRC")
         ENDIF

      ENDIF
   EndIf
   SRA->(DbSkip())      
EndDO

//RestScreen(3,0,24,79,cSavScr1)

RetIndex("SR1")
Return
