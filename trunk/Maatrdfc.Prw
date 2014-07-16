
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATRDFC   ³ Autor ³ Eliana C. da Silva    ³ Data ³ 12.01.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emiss„o da DFC para o Estado do Parana. Emite a dfc de acordo±±
±±³          ³com a configuracao do arquivo dfc.ini                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MATRdfc(void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch" 
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function matrdfc()   

SetPrvt("AREGISTROS,ACAMPOS,CARQTEMP,CMES,CANO,ADFC")
SetPrvt("ACONTEUDO,AAREA,CARQDFC,_NI,DDTINI,DDTFIM")
SetPrvt("LRET,I,J,CPERG,_CARQUIVO,_NOUTFILE")
SetPrvt("_NTIPO2,_NESTOQ,CCONTEUDO,NCPO_COD,_CREG,CLINHA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRegistros  := {}
aCampos	    := {}
cArqTemp	:= ""
cMes		:= ""
cAno		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na leitura do arquivo ini               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDFC     := {}
aConteudo:= {}
aArea    := GetArea()
cArqDFC  := ""
_nI      := 0 
dDtIni   := ""
dDtFim   := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis que armazenam os campos do resumo da apuracao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos	:= {}
lRet    := .t.              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria as perguntas se nao existirem                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// VERSAO 407/507
//aadd(aRegistros,{"MTRDFC","01","Ano de apuracao   ?","mv_ch1","C",04,0,0,"G","","mv_par01","","2000","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRDFC","02","Tipo Documento    ?","mv_ch2","N",01,0,1,"C","","mv_par02","21-DFC Normal","","","22-DFC Retificacao","","","24-DFC BAIXA","","","","","","","",""})
//aadd(aRegistros,{"MTRDFC","03","CRC Contador      ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRDFC","04","Modelo DFC        ?","mv_ch4","N",01,0,1,"C","","mv_par04","5-Simples/Pr Faixa A","","","8-Normal","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRDFC","05","Valor Estoq.Inicio?","mv_ch5","N",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRDFC","06","Valor Estoq.Final ?","mv_ch6","N",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRDFC","07","Quadro22-Municipio?","mv_ch7","N",01,0,1,"C","","mv_par07","Nao","","","Sim","","","","","","","","","","",""})
//aadd(aRegistros,{"MTRDFC","08","Caminho Arquivo   ?","mv_ch8","C",30,0,0,"G","","mv_par08","","C:\SIGAADV\DFC\","","","","","","","","","","","","",""})

// VERSAO 508
//
//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
aadd(aRegistros,{"MTRDFC","01","Ano de apuracao   ?","Ano de apuracao   ?","Ano de apuracao   ?","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRDFC","02","Tipo Documento    ?","Tipo Documento    ?","Tipo Documento    ?","mv_ch2","N",01,0,1,"C","","mv_par02","21-DFC Normal","","","","","22-DFC Retifica","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRDFC","03","CRC Contador      ?","CRC Contador      ?","CRC Contador      ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRDFC","04","Modelo DFC        ?","Modelo DFC        ?","Modelo DFC        ?","mv_ch4","N",01,0,1,"C","","mv_par04","5-Simples/Pr Fa","","","","","8-Normal","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRDFC","05","Valor Estoq.Inicio?","Valor Estoq.Inicio?","Valor Estoq.Inicio?","mv_ch5","N",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRDFC","06","Valor Estoq.Final ?","Valor Estoq.Final ?","Valor Estoq.Final ?","mv_ch6","N",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRDFC","07","Quadro22-Municipio?","Quadro22-Municipio?","Quadro22-Municipio?","mv_ch7","N",01,0,1,"C","","mv_par07","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{"MTRDFC","08","Caminho do Arquivo?","Caminho do Arquivo?","Caminho do Arquivo?","mv_ch8","C",30,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 

dbSelectArea("SX1")

For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
            FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cPerg:="MTRDFC"
//pergunte(cPerg,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Ano de apuracao    ?                 ³
//³ mv_par02             // Ano de Apuracao    ?                 ³
//³ mv_par03             // Arquivo de Configuracao?             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Processamento DFC-PR" 
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("MTRDFC")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa Gera Arquivo Texto para DFC-PR"
ACTIVATE DIALOG oDlg5
Return nil

Static Function OkProc()
Close(oDlg5)
Processa( {|| ProcDFC() } )
Return


Static Function ProcDFC()

dbSelectArea("SF3")
cArqDFC := "DFC.ini"

ReadDFC()
if !lRet
   RETURN
Endif    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo para armazenar apuracoes   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"CPO_ANO"         ,"C"    ,04     ,0      })
AADD(aCampos,{"CPO_COD"         ,"C"    ,04     ,0      })
AADD(aCampos,{"CPO_VALOR"       ,"N"    ,15     ,0      })

cArqTemp	:=	CriaTrab(aCampos)
dbUseArea(.T.,,cArqTemp,cArqTemp,.T.,.F.)
IndRegua(cArqTemp,cArqTemp,"CPO_ANO+CPO_COD",,,"Indexando Dados")

_cArquivo:=alltrim(mv_par08)+"DFC"+SM0->M0_CODIGO+SM0->M0_CODFIL+".TXT"

_nOutFile:= Fcreate(_cArquivo,0) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculando as movimentacoes do SF3                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMes		:=	""
cAno		:=	""   
dDtini  :=      CTOD("01/01/"+MV_PAR01)
dDtFim  :=      CTOD("31/12/"+MV_PAR01)

dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+Dtos(dDtini),.T.)
_nTipo2:= 0
_nEstoq:=0
ProcRegua(LastRec())
While (!Eof() .And. xFilial("SF3") == F3_FILIAL .And.;
                            dDtIni  <= F3_ENTRADA.And.;
                            dDtFim  >= F3_ENTRADA )
   IncProc()
   If SF3->F3_TIPO =="S"
      SF3->(DBSKIP())
      Loop
   EndIf
   If mv_par04 == 1
      For _nI := 1 to len(aDFC)
          cConteudo:=     aDFC[_nI,5]
          If aDFC[_nI,2]=="N" .and. substr(aDFC[_nI,1],1,3) =="CPO" ;
             .AND. &cConteudo !=0
             dbSelectArea(cArqTemp)
             if !dbSeek(mv_par01+substr(aDFC[_nI,1],5,3)+"0")
                RECLOCK(cArqTemp,.T.)
                Replace CPO_ANO With mv_par01
                Replace CPO_COD with substr(aDFC[_nI,1],5,3)+"0"
                Replace CPO_VALOR With  0
                _nTipo2:= _nTipo2 + 1
             Else
                RECLOCK(cArqTemp,.F.)
             EndIf                                        
             cConteudo:=     aDFC[_nI,5]                             
             IF substr(aDFC[_nI,1],5,3) == "713" .OR. substr(aDFC[_nI,1],5,3) == "763"
                Replace CPO_VALOR With  &cConteudo
             Else
                Replace CPO_VALOR With  CPO_VALOR + &cConteudo
             EndIf
             MsUnlock()
          Endif
      Next
   Else
      For _nI := 1 to len(aDFC)
          cConteudo:=     aDFC[_nI,5]
          if aDFC[_nI,2]=="N" .and. substr(aDFC[_nI,1],1,3) =="CPO" ;
             .AND. &cConteudo !=0
             dbSelectArea(cArqTemp)
             if !dbSeek(mv_par01+substr(aDFC[_nI,1],5,3)+"0")
                RECLOCK(cArqTemp,.T.)
                Replace CPO_ANO With mv_par01
                Replace CPO_COD with substr(aDFC[_nI,1],5,3)+"0"
                Replace CPO_VALOR With  0
                _nTipo2:= _nTipo2 + 1
             Else
                RECLOCK(cArqTemp,.F.)
             EndIf                                        
             cConteudo:=     aDFC[_nI,5]                             
             IF substr(aDFC[_nI,1],5,3) == "823" .OR. substr(aDFC[_nI,1],5,3) == "921"
                Replace CPO_VALOR With  &cConteudo
             Else
                Replace CPO_VALOR With  CPO_VALOR + &cConteudo
             EndIf
             MsUnlock()
             IF substr(aDFC[_nI,1],5,3) >= "801" .AND. substr(aDFC[_nI,1],5,3) <= "823"
                nCPO_COD:="8240"
             ENDiF
             IF substr(aDFC[_nI,1],5,3) >= "826" .AND. substr(aDFC[_nI,1],5,3) <= "847"
                nCPO_COD:="8490"
             ENDiF
             IF substr(aDFC[_nI,1],5,3) >= "851" .AND. substr(aDFC[_nI,1],5,3) <= "872"
                nCPO_COD:="8740"
             ENDiF
             IF substr(aDFC[_nI,1],5,3) >= "876" .AND. substr(aDFC[_nI,1],5,3) <= "897"
                nCPO_COD:="8990"
             ENDiF
             IF substr(aDFC[_nI,1],5,3) >= "901" .AND. substr(aDFC[_nI,1],5,3) <= "921"
                nCPO_COD:="9240"
             ENDiF
             IF substr(aDFC[_nI,1],5,3) >= "926" .AND. substr(aDFC[_nI,1],5,3) <= "947"
                nCPO_COD:="9490"
             ENDiF
             IF substr(aDFC[_nI,1],5,3) >= "951" .AND. substr(aDFC[_nI,1],5,3) <= "970"
                nCPO_COD:="9740"
             ENDiF
             IF substr(aDFC[_nI,1],5,3) >= "976" .AND. substr(aDFC[_nI,1],5,3) <= "997"
                nCPO_COD:="9990"
             ENDiF
             if !dbSeek(mv_par01+nCPO_COD)
                RECLOCK(cArqTemp,.T.)
                Replace CPO_ANO With mv_par01
                Replace CPO_COD With nCPO_COD
                Replace CPO_VALOR With  0
                _ntipo2 := _ntipo2 + 1
             Else
                RECLOCK(cArqTemp,.F.)
             EndIf
             IF _nEstoq==0 .or.(substr(aDFC[_nI,1],5,3) <> "823" .and. substr(aDFC[_nI,1],5,3) <> "921")
                Replace CPO_VALOR With  CPO_VALOR + &cConteudo
             EndIf
             MsUnlock()
             IF substr(aDFC[_nI,1],5,3) == "921"
                _nEstoq:=1
             EndIf 
          Endif
      Next
      IF MV_PAR07 == 2 .AND. SF3->F3_ESTADO == "PR" .AND. ALLTRIM(SF3->F3_CFO)<="199" 
         SA2->(dbSeek(XFILIAL("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA))
         IF SA2->A2_TIPO == "L" .OR. SA2->A2_TIPO == "T"
            if !dbSeek(mv_par01+SA2->A2_MUNDFC)
               RECLOCK(cArqTemp,.T.)
               Replace CPO_ANO With mv_par01
               Replace CPO_COD with SA2->A2_MUNDFC
               Replace CPO_VALOR With  0
               _nTipo2:= _nTipo2 + 1
            Else
               RECLOCK(cArqTemp,.F.)
            EndIf
            Replace CPO_VALOR With  CPO_VALOR + SF3->F3_VALCONT
            MsUnlock()
         ENDIF
      ENDIF
   EndIf
   dbSelectArea("SF3")
   dbSkip()
EndDo

DbSelectArea(cArqTemp)
dbGoTop()

ProcRegua(LastRec())
//Gera arquivo magnetico para o Fisco (DFC.TXT)
_cReg:= "1"+IIF(MV_PAR02==1,"21",IIF(MV_PAR02==2,"22","24"))+;
        Substr(SM0->M0_INSC,1,10)+Substr(SM0->M0_CGC,1,14)+;
        Substr(MV_PAR01,1,4)+"00"+"C"+MV_PAR03+IIF(MV_PAR04==1,"5","8")+;
        SPACE(59)+STR(_NTIPO2,3,0)
Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1)
while !Eof()
   _cReg:= "2"+substr(CPO_COD,1,4)+Right("000000000000000"+LTrim(Str((CPO_VALOR),15,0)),15)
   Fwrite(_nOutFile,_cReg + chr(10),len(_cReg) + 1) 
   dbSkip()
   IncProc()
EndDo
   
Fclose(_nOutFile)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos temporarios                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cArqTemp+".DBF")
   dbSelectArea(cArqTemp)
   dbCloseArea()
   Ferase(cArqTemp+".DBF")
   Ferase(cArqTemp+OrdBagExt())
Endif

MSGINFO("Termino de Processamento")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ReadDFC   ³ Autor ³Eliana C. da Silva     ³ Data ³05.10.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de Leitura dos arquivos de DFC                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com o Lay-Out da DFC                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Arquivo                                              ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReadDFC()
//MSGINFO("ENTREI AQUI")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura do Arquivo a Ser Lido                                         ³
//³                                                                        ³
//³XXX_XXX    X YYY Z CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC ³
//³|          | |   | |                                                    ³
//³|          | |   | À> Conteudo                                          ³
//³|          | |   À--> Numero de Decimais                                ³
//³|          | À------> Tamanho da Coluna                                 ³
//³|          À--------> Formato de Gravacao ( Numerico Caracter Data)     ³
//³À-------------------> Nome do campo                                     ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a Abertura do Arquivo cArqDFC.Ini                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( File(cArqDFC) )
        FT_FUse(cArqDFC)
	FT_FGotop()
	
	While ( !FT_FEof() )
		cLinha := FT_FREADLN()
		
		Do Case
                   Case SubStr(cLinha,1,4)=="CPO_"
                        aadd(aDFC, {SubStr(cLinha,01,07),;      //1.Campo
                        SubStr(cLinha,12,01),;                  //2.Tipo
                        Val(SubStr(cLinha,14,03)),;             //3.Tamanho
                        Val(SubStr(cLinha,18,01)),;             //4.Decimal
                        SubStr(cLinha,20)})                     //5.Conteudo
				
		EndCase
		
		FT_FSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Fecha o Arquivo cArqDFC.INI                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FUse()    
Else
	lRet	:= .F.
EndIf

RestArea(aArea)

Return

