#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhgp10()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,SOMATOTAL")
SetPrvt("INSCRICAO,CONTRATO,AGENCIA,CONTACORRENTE,NOMEBANCO,TIPO")
SetPrvt("NROS,LINHA,NUMERO,VLRADTO,A,NOUTFILE")
SetPrvt("RSR,B,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LIQUIDOS FOLHA  ³ M¦da Gra‡a N.Carvalho ³ Data ³ 30.08.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Integra‡ao Contabil                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="M"
limite :=132
cString:="SRA"
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte('GPM450',.T.)

If nLastKey == 27
	Return Nil
Endif

If MsgYesNo("Confirma a Geracao do Arquivo Texto ? ? ?","Arquivo Gerado com Sucesso ! ! !")
   RptStatus({|| fRC_Imp()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>    RptStatus({|| Execute(fRC_Imp)})  //-- Chamada do Relatorio.
EndIf
Return   

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function fRC_Imp
Static Function fRC_Imp()

SomaTotal:=0.00
If SM0->M0_CODIGO=="NH"
   Inscricao:="73355174000140"
   Contrato:="999999"
   Agencia:="99999"
   ContaCorrente:="9999999999999"
ElseIf SM0->M0_CODIGO=="FN"
   Inscricao:="01261681000104"
   Contrato:="999999"
   Agencia:="99999"
   ContaCorrente:="9999999999999"
Endif   
NomeBanco:="BANCO HSBC BAMERINDUS S/A     "
if mv_par03==1
   Tipo:="32"
Endif   
if mv_par04==1
   Tipo:="32"
EndIf   
if mv_par05==1
   Tipo:="33"
Endif
If mv_par01==1 
   Tipo:="31"
Endif   
if mv_par02==1
   Tipo:="30"
Endif   
DbSelectArea("SRI")
DbSetOrder(1)
DbSelectArea("SRR")
DbSetOrder(1)
DbSelectArea("SRC")
DbSetOrder(1)
DbSelectArea("SRA")
SRA->(DbGoTop())
DbSetOrder(1)
If Val(mv_par08)<>0
   SRA->(DbSeek(xFilial(mv_par08)+mv_par14,.T.))
Endif   
SetRegua(SRA->(RecCount()))
nRos:=SM0->M0_CGC
LINHA:={}
AADD(LINHA,"39900000         2"+Inscricao+Contrato+Space(14)+Agencia+" "+ContaCorrente+" "+Subs(SM0->M0_NOMECOM,1,30)+NomeBanco+Space(10)+"1"+StrZero(Day(DDataBase),2,0)+StrZero(Month(DDataBase),2,0)+Subs(Str(Year(DDataBase),4),3,2)+Subs(Time(),1,2)+Subs(Time(),4,2)+Subs(Time(),7,2)+StrZero(mv_par28,6,0)+"02001600CPG"+Space(67) + 'Z' )
Numero:=1
AADD(LINHA,"399"+StrZero(Numero,4,0)+"1C"+Tipo+"01020 2"+Inscricao+Contrato+Space(14)+Agencia+" "+ContaCorrente+" "+SubStr(SM0->M0_NOMECOM,1,30)+Space(40)+SM0->M0_ENDCOB+Space(05)+SM0->M0_COMPCOB+Space(03)+SM0->M0_CIDCOB+SM0->M0_CEPCOB+SM0->M0_ESTCOB+Space(17)+ 'Z')
Numero:=Numero+1
Do While SRA->(! Eof()) .and. SRA->RA_MAT>=mv_par14 .and. SRA->RA_MAT<=mv_par15
   IncRegua()
   If SRA->RA_SITFOLH$"TD" .or. VAL(SRA->RA_CTDEPSA)==0 .or. VAL(SRA->RA_BCDEPSA)==0
      SRA->(DbSkip())
      Loop
   Endif   
   If Tipo=="30" // pagamento salario
      SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"799",.T.))
      IF SRA->RA_FILIAL==SRC->RC_FILIAL .AND. SRA->RA_MAT==SRC->RC_MAT .AND. SRC->RC_PD="799"
         AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+StrZero(Val(SRA->RA_CTDEPSA),13,0)+" "+SRA->RA_NOME+StrZero(Val(SRA->RA_MAT),16,0)+Space(04)+StrZero(Day(mv_par24),2,0)+StrZero(Month(mv_par24),2,0)+Subs(Str(Year(mv_par24),4),3,2)+"R$ "+Space(17)+StrZero(SRC->RC_VALOR*100,13,0)+Space(97)+"0"+Space(09)+ 'Z')
         Numero:=Numero+1
         SomaTotal:=SomaTotal+SRC->RC_VALOR
      ENDIF
   ENDIF
   If Tipo=="31" // Adiantamento
      VlrAdto:=0.00
      SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"410",.T.))
      IF SRA->RA_FILIAL==SRC->RC_FILIAL .AND. SRA->RA_MAT==SRC->RC_MAT .AND. SRC->RC_PD="410"
         VlrAdto:=SRC->RC_VALOR
      ENDIF
      SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"469",.T.))
      IF SRA->RA_FILIAL==SRC->RC_FILIAL .AND. SRA->RA_MAT==SRC->RC_MAT .AND. SRC->RC_PD="469"
         VlrAdto:=VlrAdto+SRC->RC_VALOR
      ENDIF
      AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+StrZero(Val(SRA->RA_CTDEPSA),13,0)+" "+SRA->RA_NOME+StrZero(Val(SRA->RA_MAT),16,0)+Space(04)+StrZero(Day(mv_par24),2,0)+StrZero(Month(mv_par24),2,0)+Subs(Str(Year(mv_par24),4),3,2)+"R$ "+Space(17)+StrZero(VlrAdto*100,13,0)+Space(97)+"0"+ space(09)+'Z')
      Numero:=Numero+1
      SomaTotal:=SomaTotal+VlrAdto
   ENDIF
   If Tipo=="32" .AND. mv_par03==1 .AND. mv_par04==2 // 13o. Salario (1a. Parcela)
      SRC->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"137",.T.))
      IF SRA->RA_FILIAL==SRC->RC_FILIAL .AND. SRA->RA_MAT==SRC->RC_MAT .AND. SRC->RC_PD=""
         AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+StrZero(Val(SRA->RA_CTDEPSA),13,0)+" "+SRA->RA_NOME+StrZero(Val(SRA->RA_MAT),16,0)+Space(4)+StrZero(Day(mv_par24),2,0)+StrZero(Month(mv_par24),2,0)+Subs(Str(Year(mv_par24),4),3,2)+"R$ "+Space(17)+StrZero(SRC->RC_VALOR*100,13,0)+Space(97)+"0"+Space(09)+'Z')
         Numero:=Numero+1
         SomaTotal:=SomaTotal+SRC->RC_VALOR
      ENDIF
   ENDIF
   If Tipo=="32" .AND. mv_par03==2 .AND. mv_par04==1  // 13o. Salario (1a. Parcela)
      SRI->(DbSeek(xFilial("SRA")+SRA->RA_MAT+"709",.T.))
      IF SRA->RA_FILIAL==SRI->RI_FILIAL .AND. SRA->RA_MAT==SRI->RI_MAT .AND. SRI->RI_PD=""
         AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+StrZero(Val(SRA->RA_CTDEPSA),13,0)+" "+SRA->RA_NOME+StrZero(Val(SRA->RA_MAT),16,0)+Space(4)+StrZero(Day(mv_par24),2,0)+StrZero(Month(mv_par24),2,0)+Subs(Str(Year(mv_par24),4),3,2)+"R$ "+Space(17)+StrZero(SRI->RI_VALOR*100,13,0)+Space(97)+"0"+Space(09)+'Z')
         Numero:=Numero+1
         SomaTotal:=SomaTotal+SRI->RI_VALOR
      ENDIF
   ENDIF
   If Tipo=="33"  // Ferias
      SRR->(DbSeek(xFilial("SRR")+SRR->RR_MAT+DTOS(mv_par25),.T.))
      DO WHILE SRA->RA_FILIAL==SRR->RR_FILIAL .AND. SRA->RA_MAT==SRR->RR_MAT .AND. SRR->RR_DATA>=CtoD(mv_par25) .AND. SRR->RR_DATA<=CotD(mv_par25) 
         IF SRR->RR_PD=="404"
            AADD(LINHA,"399"+StrZero(Numero,4,0)+"3"+StrZero(Numero-1,5,0)+"A000   "+Subs(SRA->RA_BCDEPSA,1,3)+"0"+Subs(SRA->RA_BCDEPSA,4,4)+" "+StrZero(Val(SRA->RA_CTDEPSA),13,0)+" "+SRA->RA_NOME+StrZero(Val(SRA->RA_MAT),16,0)+Space(4)+StrZero(Day(mv_par24),2,0)+StrZero(Month(mv_par24),2,0)+Subs(Str(Year(mv_par24),4),3,2)+"R$ "+Space(17)+StrZero(SRR->RR_VALOR*100,13,0)+Space(97)+"0"+Space(09)+'Z')
            Numero:=Numero+1
            SomaTotal:=SomaTotal+SRR->RR_VALOR
         ENDIF
         SRR->(DbSkip())   
      ENDDO
   ENDIF
   SRA->(DbSkip())      
ENDDO
nRos:=SM0->M0_CGC
AADD(LINHA,"39999995"+Space(09)+StrZero(Numero,6,0)+Space(03)+StrZero(SomaTotal*100,15,0)+Space(198)+'Z')
AADD(LINHA,"39999999"+Space(09)+StrZero(1,6,0)+ StrZero(Numero+2,6,0)+Space(210)+'Z')
nRos:=SM0->M0_CGC
a:=len(linha)
   if a>0
      
      nOutfile := FCreate(AllTrim(mv_par23),0)  // cria o arquivo
      FOR rsr:=1 TO a
          
          b:=linha[rsr]
          FWrite(nOutFile,b+chr(10),241)   // chr(10) indica fim de linha
                                   // ,241 indica o tamanho da linha b=240+chr(10)=1
      NEXT
      
      FClose(nOutFile)                // fecha o arquivo
   
   endIf

RestScreen(3,0,24,79,cSavScr1)

RetIndex("SRC")
RetIndex("SRA")
RetIndex("SRI")
RetIndex("SRR")
Return
