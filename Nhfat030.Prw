/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³NHFAT030  ³ Autor ³ Alexandre R. Bento      ³ Data ³ 13/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Relatorio de Conferencia das Contas Contabeis das NF's Saida ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SX1 - SA1 - SA2 - SD2 - SE1 - SF3 - CT1                      ³±±
±±³Utilizados³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Alterado  ³                                                              ³±±
±±³          ³                                                              ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"       

User Function Nhfat030()   

SetPrvt("CBTXT,CBCONT,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,LCONTINUA,NLASTKEY,NCONTA,NVALOR")
SetPrvt("NIPI,NICM,FINANC,FISCAL,TAMANHO,CPERG")
SetPrvt("WNREL,LI,M_PAG,PASSOU,CSTRING,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,ACONTA,NOME,LOJA,CLIENTE")
SetPrvt("NF,SERIE,DATA,NLINHA,_CDOC,_NREG")
SetPrvt("CODCONTA,IPI,ICM,VALOR,TOTAL,I,_cCGC")
SetPrvt("CONTARED,J,")
SetPrvt("_nValc,_nBaseic,_nValic,_nIsenIc,_nOutric,_nBaseIp,_nValip,_nIsenIP,_nOutrIp")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,nTipo,nLimite")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Data                              ³
//³ mv_par02             // Ate a Data                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_NREG    :=0
_nValc   :=0
_nBaseic :=0
_nValic  :=0
_nIsenIc :=0
_nOutric :=0
_nBaseIp :=0
_nValip  :=0
_nIsenIP :=0
_nOutrIp :=0
cbtxt    := " "
cbcont   := 0
titulo   :=PADC("Conferencia de Contas Saidas",74)
cDesc1   :=PADC("Emissao do Relatorio de Conferencia das Contas Contabeis das NF's",74)
cDesc2   :=PADC("de Entrada de acordo com a configuracao do usuario.",74)
cDesc3   := ""
aReturn  :={ "Especial", 1,"Administracao", 1, 2, 1, " ", 1}
nomeprog :="NHFAT030"
lContinua:= .T.
nLastkey := 0
nConta   := 1
nValor   := 2
nIPI     := 3
nICM     := 4
FINANC   := .F.
FISCAL   := .F.
Tamanho  := "G"


CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="M"
limite :=132
cRodaTxt := ""
cString  := "SF3"
nTipo    := 0
nPag     := 1


  
//ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
//³   Salva a Integridade dos dados de Entrada                                ³
//ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
  
cPerg    := "FAT004"
wnrel    := "FAT030"    // NOME DEFAULT DO RELATORIO EM DISCO
li       := 80
m_pag    := 1
passou   := 1

  
Pergunte(cPerg,.F.)
  
cString  := "SD2"
 
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+      AJUSTE DOS PARAMETROS DA IMPRESSAO VIA FUNCAO SETPRINT              +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
 
If nLastkey == 27
   Return
EndIf

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+           ACEITA PARAMETROS E FAZ AJUSTES NECESSARIOS                    +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


SetDefault(aReturn,cString)

If nLastKey == 27
   Return
EndIf

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+             VARIAVEIS UTILIZADAS NA BARRA DE STATUS                      +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

RptStatus({||RptDetail()})// 
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³RptDetail ³ Autor ³ Jose Roberto Gorski     ³ Data ³ 08/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Corpo do Relatorio                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SX1 - SA1 - SA2 - SD1 - SE2 - SF3 - CT1                      ³±±
±±³Utilizados³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
   

Static Function RptDetail()

SA1->(DbSetOrder(1))  // Codigo
SA2->(DbSetOrder(1))  // Codigo
SD2->(DbSetOrder(5))  // D2_FILIAL+DTOS(D2_EMISSAO)+D2_NUMSEQ                                                                                                                            
SE1->(DbSetOrder(2))  // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                               
SF3->(DbSetOrder(4))  // F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE                                                                                                                
SF4->(DbSetOrder(1))  // filial + TES
CT1->(DbSetOrder(1))  // Plano de Contas
SB1->(DbSetOrder(1))  // Produto
SD2->(DbGoTop())

//@ 01,00 Psay &cCompac // +Repli("*",132)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
SD2->(DbSeeK(xFilial("SD2")+DTOS(mv_par01),.t.))

WHILE !SD2->(EOF()) .AND. DtoS(SD2->D2_EMISSAO) <= DtoS(mv_par02) .And. lContinua
   
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   //+              VERIFICA SE HOUVE INTERRUPCAO PELO OPERADOR             +
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    /*/
      IF lAbortPrint
         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         lContinua := .F.
         Exit
      ENDIF
    /*/
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   //+                        IMPRESSAO DOS DADOS                           +
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   
   aConta:={}
  
   IF li > 52
     Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
///      @  002,001 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------"
//      @  003,001 PSAY "                                             CONFERENCIA DAS CONTAS"
//      @  003,080 PSAY "Data : "+DTOC(Date())
//      @  004,001 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------"
      li := 6
   ENDIF
   
   IF SD2->D2_TIPO == "B"
      SA2->(DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
      NOME := SubStr(SA2->A2_NREDUZ,1,20)
      LOJA := SA2->A2_LOJA
      _cCGC:= SA2->A2_CGC
   ELSE
      SA1->(DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA))
      NOME := SA1->A1_NREDUZ
      LOJA := SA1->A1_LOJA
      _cCGC:= SA1->A1_CGC      
   ENDIF   
   FINANC := SE1->(DbSeek(xFilial("SE1")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_SERIE+SD2->D2_DOC))
   FISCAL := SF3->(DbSeek(xFilial("SF3")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE))
   @ li,002 PSAY "Data : "+DTOC(SD2->D2_EMISSAO)
   @ li,020 PSAY "Nota : "+SD2->D2_DOC
   @ li,037 PSAY "Serie : "+SD2->D2_SERIE
   @ li,050 PSAY "Fornecedor : "+NOME
   @ li,088 PSAY "CGC : "+_cCGC
   @ li,110 PSAY "CFO : "+SD2->D2_CF
   SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
   @ li,122 PSAY "Gera Lanc: " + SF4->F4_CONTAB
   
   li := li + 1
   CLIENTE := SD2->D2_CLIENTE
   LOJA    := SD2->D2_LOJA
   NF      := SD2->D2_DOC
   SERIE   := SD2->D2_SERIE
   DATA    := SD2->D2_EMISSAO
   WHILE !SD2->(EOF()) .AND. SD2->D2_CLIENTE == CLIENTE .AND. SD2->D2_LOJA == LOJA .AND. SD2->D2_EMISSAO == DATA .AND. SD2->D2_DOC == NF .AND. SERIE == SD2->D2_SERIE


      SB1->(DbSeeK(xFilial("SB1")+SD2->D2_COD))      
      @ li,002 PSAY SD2->D2_COD
      @ li,018 PSAY SubStr(SB1->B1_DESC,1,15)
      @ li,038 PSAY SD2->D2_TES
      IF CT1->(DbSeek(xFilial("CT1")+SD2->D2_CONTA))
          @ li,044 PSAY CT1->CT1_CONTA  //SI1->I1_RES
      ELSE
          @ li,044 PSAY SD2->D2_CONTA
      ENDIF
      nLinha := aScan(aConta,{|aLinha|aLinha[nConta]==SD2->D2_CONTA})
      IF nLinha==0
         aAdd(aConta,{SD2->D2_CONTA, 0, 0, 0})
         nLinha := Len(aConta)
      ENDIF   
      aConta[nLinha][nValor] := aConta[nLinha][nValor] + SD2->D2_TOTAL
      aConta[nLinha][nIPI]   := aConta[nLinha][nIPI] + SD2->D2_VALIPI
      aConta[nLinha][nICM]   := aConta[nLinha][nICM] + SD2->D2_VALICM
      @ li,058 PSAY SD2->D2_CCUSTO
      @ li,065 PSAY SD2->D2_TOTAL PICTURE "@E 999,999,999.99"
      IF SD2->D2_VALICM != 0
         @ li,080 PSAY SD2->D2_VALICM PICTURE "@E 999,999,999.99"
      ENDIF
      IF SD2->D2_VALIPI != 0
         @ li,100 PSAY SD2->D2_VALIPI PICTURE "@E 99,999.99"
      ENDIF   
      @ li, 120 PSAY SD2->D2_QUANT PICTURE "@E 99,999.99"
      li := li + 1
      // _cDoc   := SD1->D1_DOC   
      _nReg := SD2->(Recno())
      SD2->(DbSkip())
   END
   IF SD2->(EOF())
      // SD1->(DbSeek(xFilial("SD1")+DTOS(DATA)+_cDoc))
      SD2->(DbGoTo(_nReg))
   ENDIF
   IF !SD2->(EOF())
      CLIENTE := SD2->D2_CLIENTE
      LOJA    := SD2->D2_LOJA
      // SD1->(DbSeek(xFilial("SD1")+DTOS(DATA)+_cDoc))
      SD2->(DbGoTo(_nReg))
      IF SD2->D2_TIPO == "B"
         CODCONTA := SA2->A2_CONTA+SA2->A2_COD
      ELSE   
         CODCONTA := SD2->D2_CLIENTE
      ENDIF   
      IPI := ICM := VALOR := TOTAL := 0
      @ li,002 PSAY "Debito : "
      FOR I := 1 TO Len(aConta)
         IPI   := IPI + aConta[I][nIPI]
         ICM   := ICM + aConta[I][nICM]
         CONTARED := aConta[I][nConta]
         VALOR := aConta[I][nValor] - aConta[I][nICM]
         CT1->(DbSeek(xFilial("CT1")+CONTARED))
         @ li,015 PSAY CT1->CT1_RES
         @ li,029 PSAY VALOR PICTURE "@E 999,999,999.99"
         IF I == 1
            @ li,045 PSAY "Credito : "
            @ li,059 PSAY CODCONTA
            FOR J := 1 TO Len(aConta)
               TOTAL := TOTAL + aConta[J][nValor]
            NEXT
            @ li,090 PSAY TOTAL PICTURE "@E 999,999,999.99"
         ENDIF
         li := li + 1
      NEXT
      IF IPI != 0
      
         // Colocar a Conta Correta para IPI
         @ li,015 PSAY "0T10"
         @ li,025 PSAY IPI PICTURE "@E 999,999,999.99"
         li := li + 1
      ENDIF
      IF ICM != 0
         // Colocar a Conta correta para ICM
         @ li,015 PSAY "0T8"
         @ li,025 PSAY ICM PICTURE "@E 999,999,999.99"
         
      ENDIF
      li := li + 1
      VALOR := TOTAL - ICM
//******************************************
      SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL                                                                                                                                                
      SF2->(DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
      
    //li := li + 1
      @  li,002 PSAY "Vlr.IRRF:" 
      @  li,011 PSAY Transform(0, "@E 999,999.99")
      @  li,023 PSAY "Vlr.ISS:"
      @  li,034 PSAY Transform(0, "@E 999,999.99")            
      @  li,046 PSAY "Vlr.INSS:" 
      @  li,056 PSAY Transform(SF2->F2_VALINSS, "@E 999,999.99")      
      @  li,070 PSAY "Vlr.PIS :"
      @  li,080 PSAY Transform(SF2->F2_VALPIS,"@E 999,999.99")            
      @  li,092 PSAY "Vlr.CSLL:" 
      @  li,102 PSAY Transform(SF2->F2_VALCSLL,"@E 999,999.99")            
      @  li,114 PSAY "Vlr.COFINS:"
      @  li,125 PSAY Transform(SF2->F2_VALCOFI,"@E 999,999.99")                  
      li := li + 1

//******************************************
     IF li > 52
        Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
        li := 6
     ENDIF

      
      IF FINANC
         li := li + 1
         @  li,002 PSAY "FINANCEIRO"
         li := li + 1
         @  li,002 PSAY " NUMERO  PREFIXO  PARCELA  VENCIMENTO REAL          VALOR          NATUREZA"
         li := li + 1
         WHILE !SE1->(EOF()) .AND. SE1->E1_NUM == SD2->D2_DOC .AND. SE1->E1_PREFIXO == SD2->D2_SERIE .AND. SE1->E1_CLIENTE == SD2->D2_CLIENTE .AND. SE1->E1_LOJA == SD2->D2_LOJA
            @  li,004 PSAY SE1->E1_NUM
            @  li,013 PSAY SE1->E1_PREFIXO
            @  li,023 PSAY SE1->E1_PARCELA
            @  li,033 PSAY SE1->E1_VENCREA
            @  li,045 PSAY SE1->E1_VALOR PICTURE "@E 999,999,999.99"
            @  li,069 PSAY SE1->E1_NATUREZ
            li := li + 1
            SE1->(DbSkip())
         END      
      ENDIF
      IF FISCAL
         _nValc   :=0
		 _nBaseic :=0
	     _nValic  :=0
		 _nIsenIc :=0
	     _nOutric :=0
		 _nBaseIp :=0
		 _nValip  :=0
		 _nIsenIP :=0
		 _nOutrIp :=0

         While !SF3->(EOF()) .AND. SF3->F3_NFISCAL == SD2->D2_DOC .AND. SF3->F3_SERIE == SD2->D2_SERIE .AND. SF3->F3_CLIEFOR == SD2->D2_CLIENTE .AND. SF3->F3_LOJA == SD2->D2_LOJA

            _nValc   += SF3->F3_VALCONT 
            _nBaseic += SF3->F3_BASEICM 
            _nValic  += SF3->F3_VALICM 
            _nIsenIc += SF3->F3_ISENICM 
            _nOutric += SF3->F3_OUTRICM 
            _nBaseIp += SF3->F3_BASEIPI 
            _nValip  += SF3->F3_VALIPI 
            _nIsenIP += SF3->F3_ISENIPI
            _nOutrIp += SF3->F3_OUTRIPI 
            SF3->(DbSkip())
         ENDDO 
            li := li + 1
            @  li,002 PSAY "FISCAL"
            li := li + 1
            @  li,002 PSAY " VALOR CONTABIL : "
            @  li,023 PSAY _nValc PICTURE "@E 999,999,999.99"
            li := li + 1
            @  li,002 PSAY " BASE DO ICM     VALOR ICM       ISENTAS         OUTRAS  "
            li := li + 1
            @  li,001 PSAY _nBaseic PICTURE "@E 999,999,999.99"
            @  li,015 PSAY _nValic PICTURE "@E 999,999,999.99"
            @  li,030 PSAY _nIsenIc PICTURE "@E 999,999,999.99"
            @  li,046 PSAY _nOutric PICTURE "@E 999,999,999.99"
            li := li + 1
            @  li,002 PSAY " BASE DO IPI     VALOR IPI       ISENTAS         OUTRAS  "
            li := li + 1
            @  li,001 PSAY _nBaseIp PICTURE "@E 999,999,999.99"
            @  li,015 PSAY _nValip PICTURE "@E 999,999,999.99"
            @  li,030 PSAY _nIsenIP PICTURE "@E 999,999,999.99"
            @  li,046 PSAY _nOutrIp PICTURE "@E 999,999,999.99"
            li := li + 1
      ENDIF
     @ Prow() + 1, 001 Psay __PrtThinLine() 
//      @  li,001 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------"
      li := li + 1
      SD2->(DbSkip())
    //li := li + 1
   ENDIF
END

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+                        RESTAURA TELAS E SET'S                            +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Set Device To Screen
     
If aReturn[5]==1
   Set Printer To
   dbCommitAll()
   OurSpool(wnrel)
EndIf

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+                  LIBERA RELATORIO PARA SPOOL DA REDE                     +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

MS_FLUSH()

Return