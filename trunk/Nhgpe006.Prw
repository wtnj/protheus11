#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Nhgpe006()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,TIPO")
SetPrvt("SOMATOTAL,FIMLIN,INSCRICAO,CONTRATO,AGENCIA,CONTACORRENTE")
SetPrvt("NOMEBANCO,NROS,LINHA,NUMERO,VLRADTO,_TAMANHO")
SetPrvt("NOUTFILE,RSR,B,")

/*                                                                       
------------------------------------------------ MANER INFORMATICA
LEILA MARUO EM 30/08/2000
HSBC - CREDITO CONTA CORRENTE
/*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nordem:=0
tamanho:="M"
limite :=132
cString:="SRA"
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
//--------------------------- perguntas selecionadas     
Pergunte("NHG003")

//--------------------------- parametros
//mv_par01 - Tipo Processamento
//       1 - Adiantamento
//       2 - Folha Pagamento
//       3 - 1 parcela 13 sal rio
//       4 - 2 parcela 13 salario
//       5 - F‚rias
//mv_par02 - Filial de
//mv_par03 - Filial at‚
//mv_par04 - Centro de custo de 
//mv_par05 - Centro de custo at‚
//mv_par06 - Banco/Agencia de
//mv_par07 - Banco/Agencia at‚
//mv_par08 - Matricula de
//mv_par09 - Matricula at‚
//mv_par10 - Nome de
//mv_par11 - Nome at‚
//mv_par12 - Conta Corrente de
//mv_par13 - Conta Corrente at‚
//mv_par14 - Situa‡äes
//mv_par15 - Sequencia Arquivo
//mv_par16 - Categorias
//mv_par17 - Arquivo de saida
//mv_par18 - Data de Cr‚dito
//mv_par19 - F‚rias de 
//mv_par20 - F‚rias at‚

If nLastKey == 27
	Return Nil
Endif
If MsgYesNo("Confirma a Geracao do Arquivo Texto HSBC conta corrente ? ? ?","Processando gera‡Æo Arquivo ..............")
   RptStatus({|| fRC_Imp()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>    RptStatus({|| Execute(fRC_Imp)})  //-- Chamada do Relatorio.
EndIf
Return   

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function fRC_Imp
Static Function fRC_Imp()

If mv_par01==1 // ADIANTAMENTO
   Tipo:="31"
Endif   

If mv_par01==2 // FOLHA
   Tipo:="30"
Endif

If mv_par01==3
   Tipo:="32"  // 1 PARCELA DE 13 SALARIO
Endif

If mv_par01==4 // 2 PARCELA DE 13 SALARIO
   Tipo:="32"
EndIf

If mv_par01==5 // FERIAS
   Tipo:="33"
Endif

DbSelectArea("SRI")
DbSetorder(1)
DbSelectArea("SRR")
DbSetorder(1)
DbSelectArea("SRC")
DbSetorder(1)
DbSelectArea("SRA")
SRA->(DbGoTop())
DbSetorder(1)

If Val(mv_par02)<>0  
   SRA->(DbSeek(mv_par02+mv_par08,.T.))
Endif

//ProcRegua(SRA->(RecCount()))
SRA->(SetRegua(RecCount()))

SomaTotal:=0.00
FimLin:=Chr(13)+Chr(10)
Inscricao:=SM0->M0_CGC
Contrato:="066362"
Agencia:="00672"
ContaCorrente:="0000001399567"
//              123456789012
NomeBanco:="BANCO HSBC BAMERINDUS S/A     "
//          123456789012345678901234567890
nRos:=SM0->M0_CGC
LINHA:={}
AADD(LINHA,"39900000         2"+Inscricao+Contrato+Space(14)+Agencia+" "+ContaCorrente+" "+Subs(SM0->M0_NOMECOM,1,30)+NomeBanco+Space(10)+"1"+StrZero(Day(DATE()),2,0)+StrZero(Month(DATE()),2,0)+Str(Year(DATE()),4)+Subs(Time(),1,2)+Subs(Time(),4,2)+Subs(Time(),7,2)+StrZero(Val(mv_par15),6,0)+"02001600CPGY2K"+Space(63)+FIMLIN)
Numero:=1
AADD(LINHA,"399"+StrZero(Numero,4,0)+"1C"+Tipo+"01020 2"+Inscricao+Contrato+Space(14)+Agencia+" "+ContaCorrente+" "+SubStr(SM0->M0_NOMECOM,1,30)+Space(40)+SM0->M0_ENDCOB+Space(05)+SM0->M0_COMPCOB+Space(03)+SM0->M0_CIDCOB+SM0->M0_CEPCOB+SM0->M0_ESTCOB+Space(18)+FimLin)

Numero := Numero + 1

While SRA->(!Eof()) .and. SRA->RA_FILIAL >= mv_par02 .and. SRA->RA_FILIAL <= mv_par03 .and. SRA->RA_MAT >= mv_par08 .and. SRA->RA_MAT <= mv_par09
   IncRegua()
//   IncProc(SRA->RA_NOME)
   
//----------------------------------situacao e categoria dos funcionarios.
   If !( SRA->RA_SITFOLH $ mv_par14 ) .Or.  !( SRA->RA_CATFUNC $ mv_par16 )
      SRA->(DbSkip())
      Loop
   Endif
//----------------------------------conta e banco zerados
   If VAL(SRA->RA_CTDEPSA) == 0 .or. VAL(SRA->RA_BCDEPSA) == 0
      SRA->(DbSkip())
      Loop
   Endif   
//----------------------------------centro de custo
   If SRA->RA_CC < mv_par04 .or. SRA->RA_CC > mv_par05
      SRA->(DbSkip())
      Loop
   Endif   
//----------------------------------nome
   If SRA->RA_NOME < mv_par10 .or. SRA->RA_NOME > mv_par11
      SRA->(DbSkip())
      Loop
   Endif   
//----------------------------------conta corrente
   If SRA->RA_CTDEPSA < mv_par12 .or. SRA->RA_CTDEPSA > mv_par13
      SRA->(DbSkip())
      Loop
   Endif   

//----------------------------------banco agencia
   If Val(SRA->RA_BCDEPSA) < Val(mv_par06) .or. Val(SRA->RA_BCDEPSA) > Val(mv_par07)
      SRA->(DbSkip())
      Loop
   Endif

//----------------------------------pagamento salario
   If Tipo=="30" 
      SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"799",.T.))
      If SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"799",.T.))
         SomaTotal:= SomaTotal + SRC->RC_VALor
         AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+"000000"+Subs(SRA->RA_CTDEPSA,1,5)+Subs((SRA->RA_CTDEPSA),7,2)+" "+SRA->RA_NOME+SRA->RA_FILIAL+"FO1"+StrZero(Val(SRA->RA_MAT),11,0)+Space(04)+StrZero(Day(mv_par18),2,0)+StrZero(Month(mv_par18),2,0)+Str(Year(mv_par18),4)+"R$ "+Space(17)+StrZero(SRC->RC_VALor*100,13,0)+Space(95)+"0"+Space(10)+FimLin)
         Numero:= Numero + 1
      EndIf
   EndIf

//----------------------------------Adiantamento
   If Tipo=="31"  
      VlrAdto:=0.00
      SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"442",.T.))
      IF SRA->RA_FILIAL==SRC->RC_FILIAL .AND. SRA->RA_MAT==SRC->RC_MAT .AND. SRC->RC_PD=="442"
         VlrAdto:=SRC->RC_VALor + VlrAdto
      Endif
      SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"723",.T.))
      IF SRA->RA_FILIAL==SRC->RC_FILIAL .AND. SRA->RA_MAT==SRC->RC_MAT .AND. SRC->RC_PD=="723"
         VlrAdto:=VlrAdto - SRC->RC_VALor 
      Endif
      If VlrAdto > 0.00
         AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+"000000"+Subs(SRA->RA_CTDEPSA,1,5)+Subs((SRA->RA_CTDEPSA),7,2)+" "+SRA->RA_NOME+SRA->RA_FILIAL+"AD1"+StrZero(Val(SRA->RA_MAT),11,0)+Space(04)+StrZero(Day(mv_par18),2,0)+StrZero(Month(mv_par18),2,0)+Str(Year(mv_par18),4)+"R$ "+Space(17)+StrZero(VlrAdto*100,13,0)+Space(95)+"0"+Space(10)+FIMLIN)
         Numero:=Numero+1
         SomaTotal:=SomaTotal+VlrAdto
      ENDIF
   ENDIF

//----------------------------------13o. Salario (1a. Parcela)
   If Tipo=="32" .AND. mv_par03==1  
      SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"144",.T.))
      IF SRA->RA_FILIAL==SRC->RC_FILIAL .AND. SRA->RA_MAT==SRC->RC_MAT .AND. SRC->RC_PD="144"
         AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+"000000"+Subs(SRA->RA_CTDEPSA,1,5)+Subs((SRA->RA_CTDEPSA),7,2)+" "+SRA->RA_NOME+SRA->RA_FILIAL+"1311"+StrZero(Val(SRA->RA_MAT),10,0)+Space(04)+StrZero(Day(mv_par18),2,0)+StrZero(Month(mv_par18),2,0)+Str(Year(mv_par18),4)+"R$ "+Space(17)+StrZero(SRC->RC_VALor*100,13,0)+Space(95)+"0"+Space(10)+FIMLIN)
         Numero:=Numero+1
         SomaTotal:=SomaTotal+SRC->RC_VALor
      ENDIF
   ENDIF

//---------------------------------- 13o. Salario (2a. Parcela)
   If Tipo=="32" .AND. mv_par04==1  
      SRI->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"797",.T.))
      IF SRA->RA_FILIAL==SRI->RI_FILIAL .AND. SRA->RA_MAT==SRI->RI_MAT .AND. SRI->RI_PD="797"
         AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+"000000"+Subs(SRA->RA_CTDEPSA,1,5)+Subs((SRA->RA_CTDEPSA),7,2)+" "+SRA->RA_NOME+SRA->RA_FILIAL+"1321"+StrZero(Val(SRA->RA_MAT),10,0)+Space(04)+StrZero(Day(mv_par18),2,0)+StrZero(Month(mv_par18),2,0)+Str(Year(mv_par18),4)+"R$ "+Space(17)+StrZero(SRI->RI_VALor*100,13,0)+Space(95)+"0"+Space(10)+FimLin)
         Numero:=Numero+1
         SomaTotal:=SomaTotal+SRI->RI_VALor
      ENDIF
   ENDIF

//---------------------------------- Ferias
   If Tipo=="33"  
      SRR->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"F"+DTOS(mv_par19),.T.))
      DO WHILE SRR->(! EOF()) .AND. SRA->RA_FILIAL==SRR->RR_FILIAL .AND. SRA->RA_MAT==SRR->RR_MAT .AND. SRR->RR_DATA>=mv_par19 .AND. SRR->RR_DATA<=mv_par20
         IF SRR->RR_TIPO3=="F" .AND. SRR->RR_PD=="460"
            AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+"000000"+Subs(SRA->RA_CTDEPSA,1,5)+Subs((SRA->RA_CTDEPSA),7,2)+" "+SRA->RA_NOME+SRA->RA_FILIAL+"FE1"+StrZero(Val(SRA->RA_MAT),11,0)+Space(04)+StrZero(Day(mv_par18),2,0)+StrZero(Month(mv_par18),2,0)+Str(Year(mv_par18),4)+"R$ "+Space(17)+StrZero(SRR->RR_VALor*100,13,0)+Space(95)+"0"+Space(10)+FimLin)
            Numero:=Numero+1
            SomaTotal:=SomaTotal+SRR->RR_VALor
         ENDIF
         SRR->(DbSkip())
      ENDDO
   ENDIF
   SRA->(DbSkip())      
End

nRos:=SM0->M0_CGC

//---------------------------------- Trailler
AADD(LINHA,"399"+StrZero(Numero,4,0)+"5"+Space(09)+StrZero(Numero,6,0)+Space(03)+StrZero(SomaTotal*100,15,0)+Space(199)+FimLin)
AADD(LINHA,"39999999"+Space(09)+StrZero(1,6,0)+ StrZero(Numero+2,6,0)+Space(211)+FIMLIN)

_Tamanho:=len(linha)
   if _Tamanho > 0
      nOutfile := FCreate(AllTrim(mv_par17),0)  
      For rsr:=1 TO _Tamanho
          b:=linha[rsr]
          FWrite(nOutFile,b,242) // chr(10) indica fim de linha
                                 // ,241 indica o tamanho da linha b=240+chr(10)=1
      NEXT
      FClose(nOutFile)             
   endIf

RestScreen(3,0,24,79,cSavScr1)

RetIndex("SRC")
RetIndex("SRA")
RetIndex("SRI")
RetIndex("SRR")
Return
