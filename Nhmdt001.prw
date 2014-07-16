#IFDEF WINDOWS
    #Include "FIVEWIN.Ch"
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MDTR830  ³ Autor ³ Thiago Machado        ³ Data ³ 04.10.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio da CAT (Comunicacao de Acidente de Trabalho).     ³±±
±±³          ³Para cada acidente do trabalho a empresas deve emitir a CAT ³±±
±±³          ³do trabalho devera emitir o Atestado de Saude Ocuacional -  ³±±
±±³          ³para ser entregue ao INSS. Na cat deve constar informacoes  ³±±
±±³          ³do acidente e se tiver do acidentado.                       ³±±
±±³          ³O programa buscara informacoes para imprimir a cat nas      ³±±
±±³          ³Seguintes tabelas:                                          ³±±
±±³          ³ TNC - Acidentes                                            ³±±
±±³          ³ SRA - Funcionarios                                         ³±±
±±³          ³ TMT - Diagnostico medic.                                   ³±±
±±³          ³                                                            ³±±
±±³          ³ Apos a emissao da cat o campo data emissao sera atualizado ³±±
±±³          ³ o programa, alertara o usuario no caso de alteracao ou     ³±±
±±³          ³ exclusao.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MDTR830 (void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMDT001  ºAutor  ³Marcos Roquitski    º Data ³  15/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³edição do relatorio                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Nhmdt001()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel   := "MDTR830"
LOCAL limite  := 129
LOCAL cDesc1  := "Comunicacao de Acidente de Trabalho ( CAT ) .                            "
LOCAL cDesc2  := "Emite a CAT com todas as informacoes referente ao acidente selecionado   "
LOCAL cDesc3  := "Apos a emissÆo a data corrente sera atualizada no registro da CAT.       "
LOCAL cString := "TNC"

PRIVATE nomeprog := "MDTR830"
PRIVATE tamanho  := "M"
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 1, 1, "",1 } //"Zebrado"###"Administracao"
PRIVATE titulo   := "Comunicacao de Acidente de Trabalho - CAT"
PRIVATE ntipo    := 0
PRIVATE nLastKey := 0
PRIVATE cabec1, cabec2
PRIVATE cAlias := "SI3"
PRIVATE cDescr := "SI3->I3_DESC"

Dbselectarea("SX6")
Dbsetorder(1)
If Dbseek(xFilial("SX6")+"MV_MCONTAB")
  If Alltrim(GETMV("MV_MCONTAB")) == "CTB"
      cAlias := "CTT"
      cDescr := "CTT->CTT_DESC01"
  Endif
Endif

DbSelectArea("SX1")
DbSetOrder(01)
If !DbSeek("MDR830"+"03")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := "MDR830"
   SX1->X1_ORDEM   := "03"
   SX1->X1_VARIAVL := "mv_ch3"
   SX1->X1_PERGUNT := "Modelo do Relatorio?"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 1
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_DEF01   := "Modelo 1"
   SX1->X1_DEF02   := "Modelo 2"
   SX1->X1_DEF03   := "Modelo 3"
   SX1->X1_VAR01   := "mv_par03"
   SX1->(MsUnLock())
Else
  If SX1->X1_DEF03 != "Modelo 3"
      Reclock('SX1',.F.)
      SX1->X1_DEF03 := "Modelo 3"
      SX1->(MsUnLock())
  Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cPerg    :="MDR830"
If pergunte(cPerg,.T.)
  If Mv_par03 == 2  .or. Mv_par03 == 3
      MDTR830PX()
  Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Variaveis utilizadas para parametros                         ³
      //³ mv_par01             // De  Acidente                         ³
      //³ mv_par02             // Ate Acidente                         ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Envia controle para a funcao SETPRINT                        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      wnrel:="MDTR830"

      wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

      If nLastKey == 27
          Set Filter to
          Return
      Endif

      SetDefault(aReturn,cString)

      If nLastKey == 27
          Set Filter to
          Return
      Endif

      #IFDEF WINDOWS
          RptStatus({|lEnd| R830Imp(@lEnd,wnRel,titulo,tamanho)},titulo)
      #ELSE
          R830Imp(.F.,wnRel,titulo,tamanho)
      #ENDIF
  Endif
Endif
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R830Imp  ³ Autor ³ Thiago Machado        ³ Data ³04/10/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MDTR830                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function R830Imp(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cRodaTxt := ""
LOCAL nCntImpr := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para controle do cursor de progressao do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nTotRegs := 0 ,nMult := 1 ,nPosAnt := 4 ,nPosAtu := 4 ,nPosCnt := 0
LOCAL lContinua        := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

dbSelectArea("TNC")
dbSetOrder(1)
DbSeek(xFilial("TNC")+mv_par01,.t.)

SetRegua(LastRec())
While !Eof()                                 .AND.;
   TNC->TNC_FILIAL == xFIlial("TNC")        .AND.;
   TNC->TNC_ACIDEN <= mv_par02

   #IFNDEF WINDOWS
      If LastKey() = 286    //ALT_A
         lEnd := .t.
      Endif
   #ENDIF

   If lEnd
       @ PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
       Exit
   EndIf

   IncRegua()

   dbSelectArea("TNC")
   dbSetOrder(1)
   DbSeek(xFilial("TNC")+TNC->TNC_ACIDEN)
   dbSelectArea("TM0")
   dbSetOrder(1)
   DbSeek(xFilial("TM0")+TNC->TNC_NUMFIC)
   somalinha()
   @ LI,000 PSAY "PREVIDENCIA SOCIAL"
   @ LI,088 PSAY "|1-Emitente:"
   IF TNC->TNC_EMITEN = "1"
     @ LI,101 PSAY "EMPREGADOR"
   ELSEIF TNC->TNC_EMITEN = "2"
     @ LI,101 PSAY "SINDICATO"
   ELSEIF TNC->TNC_EMITEN = "3"
     @ LI,101 PSAY "MEDICO"
   ELSEIF TNC->TNC_EMITEN = "4"
     @ LI,101 PSAY "SEGURADO"
   ELSEIF TNC->TNC_EMITEN = "5"
     @ LI,101 PSAY "AUT. PUBLICA"
   ENDIF
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "INSTITUTO NACIONAL DO SEGURO SOCIAL"
   @ li,088 PSAY "|"
   @ li,089 PSAY replicate("-",40)
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "COMUNICACAO DE ACIDENTE DO TRABALHO - CAT"
   @ LI,088 PSAY "|2-Tipo de CAT:"
   IF TNC->TNC_TIPCAT = "1"
    @ li,105 psay  "INICIAL"
   ELSEIF TNC->TNC_TIPCAT = "2"
    @ li,105 psay  "REABERTURA"
   ELSEIF TNC->TNC_TIPCAT = "3"
     @ li,105 psay "COMUNICACAO DE OBITO EM :"+DTOC(TNC->TNC_DTOBIT)
   ENDIF
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 PSAY replicate("-",129)
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |E|3-Razao Social/Nome"
   @ LI,129 psay "|"
   somalinha()
   @ li,000 PSAY "| |m|"+SM0->M0_NOMECOM
   @ LI,129 psay "|"
   somalinha()
   @ LI,000 PSAY "| |p|"
   @ li,005 PSAY replicate("-",124)
   @ LI,129 psay "|"
   somalinha()
   @ li,000 psay "| |r|4-Tipo"
   @ li,027 psay "|5-CNAE"
   @ LI,054 PSAY "|6-Endereco"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |e|"
   IF SM0->M0_TPINSC = 2
     @ LI,006 PSAY SM0->M0_CGC PICTURE "@R 99.999.999/9999-99"
   Else
     @ LI,006 PSAY SM0->M0_CGC PICTURE "@!"
   Endif
   @ LI,028 PSAY SM0->M0_CNAE PICTURE "@!"
   @ LI,055 PSAY SM0->M0_ENDCOB PICTURE "@!"
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |s|Bairro"
   @ li,031 psay "|CEP"
   @ LI,050 PSAY "|7-Municipio"
   @ LI,072 PSAY "|8-UF"
   @ li,078 PSAY "|9-Telefone"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |a|"
   @ li,006 PSAY SM0->M0_BAIRCOB PICTURE "@!"
   @ LI,032 PSAY SM0->M0_CEPCOB PICTURE "@!"
   @ LI,051 PSAY SM0->M0_CIDCOB PICTURE "@!"
   @ LI,073 PSAY SM0->M0_ESTCOB PICTURE "@!"
   @ LI,079 PSAY SM0->M0_TEL PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 PSAY "| |"
   @ li,003 PSAY replicate("-",126)
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |A|10-Nome"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |c|"
   @ li,006 PSAY TNC->TNC_NOMFIC PICTURE "@!"
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |r|4-Tipo"
   @ li,027 psay "|5-CNAE"
   @ LI,054 PSAY "|6-Endereco"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |e|"
   IF SM0->M0_TPINSC = 2
     @ LI,006 PSAY SM0->M0_CGC PICTURE "@R 99.999.999/9999-99"
   Else
     @ LI,006 PSAY SM0->M0_CGC PICTURE "@!"
   Endif
   @ LI,028 PSAY SM0->M0_CNAE PICTURE "@!"
   @ LI,055 PSAY SM0->M0_ENDCOB PICTURE "@!"
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |s|Bairro"
   @ li,031 psay "|CEP"
   @ LI,050 PSAY "|7-Municipio"
   @ LI,072 PSAY "|8-UF"
   @ li,078 PSAY "|9-Telefone"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |a|"
   @ li,006 PSAY SM0->M0_BAIRCOB PICTURE "@!"
   @ LI,032 PSAY SM0->M0_CEPCOB PICTURE "@!"
   @ LI,051 PSAY SM0->M0_CIDCOB PICTURE "@!"
   @ LI,073 PSAY SM0->M0_ESTCOB PICTURE "@!"
   @ LI,079 PSAY SM0->M0_TEL PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 PSAY "| |"
   @ li,003 PSAY replicate("-",126)
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |A|10-Nome"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |c|"
   @ li,006 PSAY TNC->TNC_NOMFIC PICTURE "@!"
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |i|11-Nome da Mae"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |d|"

   dbselectarea("SRA")
   DBSETORDER(1)
   DBSEEK(XFILIAL("SRA")+TM0->TM0_MAT)

   @ li,006 psay SRA->RA_MAE PICTURE "@!"
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |e|12-Data de nasc."
   @ li,033 psay "|13-Sexo"
   @ LI,042 PSAY "|14-Estado Civil"
   @ LI,059 PSAY "|15-CTPS Serie Data em."
   @ li,082 PSAY "|16-UF"
   @ li,095 PSAY "|17-Remuneracao mensal"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |n|"
   @ li,006 psay SRA->RA_NASC PICTURE "99/99/9999"
   IF SRA->RA_SEXO = "M"
     @ LI,034 PSAY "MASCULINO"
   ELSEIF SRA->RA_SEXO = "F"
     @ LI,034 PSAY "FEMININO"
   ENDIF
   IF SRA->RA_ESTCIVI = "1"
     @ LI,043 PSAY "SOLTEIRO"
   ELSEIF SRA->RA_ESTCIVI = "2"
     @ LI,043 PSAY "CASADO"
   ELSEIF SRA->RA_ESTCIVI = "3"
     @ LI,043 PSAY "VIUVO"
   ELSEIF SRA->RA_ESTCIVI = "4"
     @ LI,043 PSAY "SEP. JUD."
   ELSEIF SRA->RA_ESTCIVI = "4"
     @ LI,043 PSAY "IGNORADO"
   ENDIF
   @ LI,060 PSAY SRA->RA_SERCP PICTURE "99999"
   @ LI,083 PSAY SRA->RA_UFCP PICTURE "@!"
   @ LI,096 PSAY SRA->RA_SALARIO PICTURE "R 999,999,999.99"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |t|18-Carteira de Identidade"
   @ li,031 psay "|Data de Emissao"
   @ LI,055 PSAY "|Orgao Exp."
   @ LI,067 PSAY "|19-UF"
   @ li,074 PSAY "|20-PIS/PASEP"
   @ li,089 PSAY "|21-Endereco"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|E|a|"
   @ LI,006 PSAY SRA->RA_RG PICTURE "@!"
   If FieldPos("RA_RGORG") > 0
     @ li,056 PSAY SRA->RA_RGORG
   Endif
   @ LI,075 PSAY SRA->RA_PIS PICTURE "@!"
   @ LI,090 PSAY SRA->RA_ENDEREC PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|m|d|Endereco (compl.)"
   @ li,048 psay "|Bairro"
   @ LI,065 PSAY "|CEP"
   @ LI,079 PSAY "|22-Municipio"
   @ li,100 PSAY "|23-UF"
   @ li,108 PSAY "|24-Telefone"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|i|o|"
   @ li,006 PSAY SRA->RA_COMPLEM PICTURE "@!"
   @ LI,049 PSAY SRA->RA_BAIRRO PICTURE "@!"
   @ LI,066 PSAY SRA->RA_CEP PICTURE "@R 99999-999"
   @ LI,080 PSAY SRA->RA_MUNICIP PICTURE "@! "
   @ LI,101 PSAY SRA->RA_ESTADO PICTURE "@!"
   @ LI,107 PSAY SRA->RA_TELEFON PICTURE "@!"
   @ li,129 PSAY "|"

   somalinha()
   @ li,000 psay "|t| |"
   @ li,006 psay "25-Nome da Ocupacao"
   @ LI,028 PSAY "|26-CBO"
   @ LI,040 PSAY "|27-Filiacao Previdencia Social"
   @ li,082 PSAY "|28-Aposentado?"
   @ li,100 PSAY "|29-Area"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|e| |"
   dbselectarea("SRJ")
   DBSETORDER(1)
   DBSEEK(XFILIAL("SRJ")+SRA->RA_CODFUNC)
   cCBO := SRJ->RJ_CBO
  If FieldPos("RJ_CODCBO") > 0
      If !Empty(SRJ->RJ_CODCBO)
          cCBO := SRJ->RJ_CODCBO
      Endif
  Endif
   @ LI,006 PSAY SRJ->RJ_DESC PICTURE "@!"
   @ LI,029 PSAY Substr(cCBO,1,10)
   IF TNC->TNC_TIPREV = "1"
      @ li,041 PSAY "Empregado"
   ELSEIF TNC->TNC_TIPREV = "2"
      @ li,041 PSAY "Trab. avulso"
   ELSEIF TNC->TNC_TIPREV = "3"
      @ li,041 PSAY "Seg. especial"
   ELSEIF TNC->TNC_TIPREV = "4"
      @ li,041 PSAY "Medico Resid."
   ENDIF
   IF TNC->TNC_APOSEN = "1"
      @ li,083 PSAY "SIM"
   ELSE
      @ li,083 PSAY "NAO"
   ENDIF
   IF TNC->TNC_AREA = "1"
      @ LI,101 PSAY "URBANA"
   ELSE
      @ LI,101 PSAY "RURAL"
   ENDIF
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|n|"
   @ li,003 PSAY replicate("-",126)
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|t|A|30-Data do Acidente"
   @ LI,025 PSAY "|31-Hora do Acidente"
   @ LI,046 PSAY "|32-Apos quantas horas de trabalho?"
   @ li,081 PSAY "|33-Tipo"
   @ li,090 PSAY "|34-Houve Afastamento?"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|e|c|"
   @ LI,006 PSAY TNC->TNC_DTACID PICTURE "99/99/9999"
   @ LI,026 PSAY TNC->TNC_HRACID PICTURE "99:99"
   @ LI,052 PSAY TNC->TNC_HRTRAB PICTURE "99:99"
   //TIPO DO ACIDENTE//
   IF TNC->TNC_AFASTA = "1"
       @ LI,091 PSAY "SIM"
   ELSE
       @ LI,091 PSAY "NAO"
   endif
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |i|35-Ultimo dia"
   @ LI,019 PSAY "|36-Local do Acidente"
   @ LI,050 PSAY "|37-Especif. do local de trabalho"
   @ li,090 PSAY "|38-CGC/CNPJ"
   @ li,114 PSAY "|39-UF"
   @ li,129 PSAY "|"
   somalinha()
   cIndLocal := "ESTABELECIMENTO DA EMPRESA"
   If TNC->TNC_INDLOC == "2"
      cIndLocal := "ONDE PRESTA SERVICO"
   ElseIf TNC->TNC_INDLOC == "3"
      cIndLocal := "VIA PUBLICA"
   ElseIf TNC->TNC_INDLOC == "4"
      cIndLocal := "AREA RURAL"
   ElseIf TNC->TNC_INDLOC == "5"
      cIndLocal := " "
   Endif
   @ li,000 psay "| |d|"
   @ LI,006 PSAY TNC->TNC_DTULTI PICTURE "99/99/9999"
   @ LI,020 PSAY cIndLocal PICTURE "@!"
   @ LI,051 PSAY TNC->TNC_LOCAL PICTURE "@!"
   @ LI,091 PSAY TNC->TNC_CGCPRE PICTURE "@R 99.999.999/9999-99"
   @ LI,115 PSAY TNC->TNC_ESTACI PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |e|40-Municipio do Acidente"
   @ LI,030 PSAY "|41-Parte(s) do corpo atingida(s)"
   @ LI,090 PSAY "|42-Agente Causador"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |n|"
   @ LI,006 PSAY TNC->TNC_CIDACI PICTURE "@!"
   @ LI,031 PSAY SUBSTR(TNC->TNC_PARTE,1,40)
   dbselectarea("TNH")
   DBSETORDER(1)
   DBSEEK(XFILIAL("TNH")+TNC->TNC_CODOBJ)
   @ LI,091 PSAY SUBSTR(TNH->TNH_DESOBJ,1,20)
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |t|43-Descricao da situacao geradora do acidente ou doenca"
   @ LI,090 PSAY "|44-Houve registro policial?"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |e|"
   @ LI,006 PSAY TNC->TNC_DESCR1 PICTURE "@!"
   IF TNC->TNC_POLICI = "1"
      @ LI,091 PSAY "SIM"
   ELSE
      @ LI,091 PSAY "NAO"
   ENDIF
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| | |"
   @ LI,006 PSAY TNC->TNC_DESCR2 PICTURE "@!"
   @ LI,090 PSAY "|45-Houve morte?"
   IF TNC->TNC_MORTE = "1"
      @ LI,110 PSAY "SIM"
   ELSE
      @ LI,110 PSAY "NAO"
   ENDIF
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |"
   @ li,003 PSAY replicate("-",126)
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |T|46-Nome:"
   @ li,020 PSAY TNC->TNC_TESTE1 PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |e|47-Endereco"
   @ LI,046 PSAY "|Bairro"
   @ li,062 PSAY "|CEP"
   @ li,078 PSAY "|48-Municipio"
   @ li,095 PSAY "|49-UF"
   @ li,105 PSAY "|Telefone"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |s|"
   @ LI,006 PSAY TNC->TNC_ENDTE1 PICTURE "@!"
   @ LI,047 PSAY TNC->TNC_BAIRR1 PICTURE "@!"
   @ LI,063 PSAY TNC->TNC_CEP1 PICTURE "@!"
   @ LI,079 PSAY TNC->TNC_CIDAD1 PICTURE "@!"
   @ LI,096 PSAY TNC->TNC_ESTAD1 PICTURE "@!"
   @ LI,106 PSAY TNC->TNC_TELEF1 PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |t|50-Nome:"
   @ li,020 PSAY TNC->TNC_TESTE2 PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |m|51-Endereco"
   @ LI,046 PSAY "|Bairro"
   @ li,062 PSAY "|CEP"
   @ li,078 PSAY "|52-Municipio"
   @ li,095 PSAY "|53-UF"
   @ li,105 PSAY "|Telefone"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "| |.|"
   @ LI,006 PSAY TNC->TNC_ENDTE2 PICTURE "@!"
   @ LI,047 PSAY TNC->TNC_BAIRR2 PICTURE "@!"
   @ LI,063 PSAY TNC->TNC_CEP2 PICTURE "@!"
   @ LI,079 PSAY TNC->TNC_CIDAD2 PICTURE "@!"
   @ LI,096 PSAY TNC->TNC_ESTAD2 PICTURE "@!"
   @ LI,106 PSAY TNC->TNC_TELEF2 PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ li,000 psay "|"
   @ li,001 PSAY replicate("-",128)
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|"
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 PSAY "|                     ________________________________                  _____________________________________"
   @ LI,129 psay "|"
   somalinha()
   @ li,000 psay "|"
   @ li,032 PSAY "Local e data"
   @ li,076 PSAY "Assinatura e carimbo do emitente"
   @ LI,129 psay "|"
   somalinha()
   @ li,000 psay "|"
   @ li,001 PSAY replicate("-",128)
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|A|A|54-Unidade de atendimento medico"
   @ LI,086 PSAY "|55-Data"
   @ li,098 PSAY "|56-Hora"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|t|t|"
   @ li,006 PSAY TNC->TNC_LOCATE PICTURE "@!"
   @ LI,087 PSAY TNC->TNC_DTATEN PICTURE "99/99/9999"
   @ LI,099 PSAY TNC->TNC_HRATEN PICTURE "99:99"
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|e|e|57-Houve Internacao?"
   @ LI,027 PSAY "|58-Duracao provavel do tratamento"
   @ li,061 PSAY "|59-Devera afastar-se do trabalho?"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|s|n|"
   IF TNC->TNC_INTERN = "1"
     @ LI,006 PSAY "SIM"
   ELSE
     @ LI,006 PSAY "NAO"
   ENDIF
   @ LI,028 PSAY TNC->TNC_QTAFAS
   @ LI,033 PSAY " DIAS"
   IF TNC->TNC_AFASTA = "1"
      @ LI,062 PSAY "SIM"
   ELSE
      @ LI,062 PSAY "NAO"
   ENDIF
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|t|d|60-Descricao e natureza da lesao"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|a|i|"
   @ li,006 PSAY TNC->TNC_DESLES PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|d|m|61-Diagnostico provavel"
   @ li,087 PSAY "|62-CID - 10"
   @ LI,129 PSAY "|"
   somalinha()
   DBSELECTAREA("TMT")
   DBSETORDER(7)
   DBSEEK(XFILIAL("TMT")+TNC->TNC_ACIDEN)

   @ LI,000 PSAY "|o|e|"
   @ li,006 PSAY TMT->TMT_DIAGNO PICTURE "@!"
   @ LI,088 PSAY TMT->TMT_CID PICTURE "@!"
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |n|63-Obs."
   @ LI,015 PSAY TNC->TNC_OBSERV PICTURE "@!"
   @ li,129 psay "|"
   somalinha()
   @ LI,000 PSAY "| |t|"
   @ li,129 psay "|"
   somalinha()
   @ LI,000 PSAY "| |o|"
   @ li,129 psay "|"
   somalinha()
   @ LI,000 PSAY "|"
   @ li,001 psay replicate("-",128)
   @ LI,129 PSAY "|"
   somalinha()
   @ li,000 PSAY "|                     ________________________________       ________________________________________________"
   @ LI,129 psay "|"
   somalinha()
   @ li,000 psay "|"
   @ li,032 PSAY "Local e data"
   @ li,067 PSAY "Assinatura e carimbo do medico com CRM"
   @ LI,129 psay "|"
   somalinha()
   @ li,000 psay "|"
   @ li,001 PSAY replicate("-",128)
   @ li,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|I|64-Recebido em"
   @ LI,018 PSAY "|65-Codigo da Unidade"
   @ li,040 PSAY "|66-Numero da CAT"
   @ li,085 PSAY "|"
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|N|"
   @ LI,041 PSAY TNC->TNC_ACIDEN PICTURE "999999"
   @ li,085 PSAY "|"
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|S|68-Matricula do servidor"
   @ li,085 PSAY "|"
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|S|"
   @ li,085 PSAY "|"
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |                 __________________        _______________________"
   @ li,085 PSAY "|"
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "| |"
   @ LI,023 PSAY "Matricula"
   @ li,049 PSAY "Ass. do Servidor"
   @ li,085 PSAY "|"
   @ LI,129 PSAY "|"
   somalinha()
   @ LI,000 PSAY "|"
   @ li,001 PSAY replicate("-",128)
   @ li,129 PSAY "|"
   RECLOCK("TNC",.F.)
   TNC->TNC_DTEMIS := date()
   MSUNLOCK("TNC")
   Dbselectarea("TNC")
   IF FieldPos('TNC_INDACI') > 0
     If TNC->TNC_INDACI == "2"
      QUEST830TXT()
     Endif
   Endif
   dbselectarea("TNC")
   DBSKIP()

   li := 80

END

//Roda(nCntImpr,cRodaTxt,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("TNC")

Set Filter To

Set device to Screen

If aReturn[5] = 1
        Set Printer To
        dbCommitAll()
        OurSpool(wnrel)
Endif
MS_FLUSH()

dbSelectArea("TMT")

Return NIL


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ SomaLin  ³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Incrementa Linha inicial                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MDTA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function somalinha()
    Li ++
    If Li > 72
       Li := 0
    Endif
Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MDTR830PX³ Autor ³Denis Hyroshi de Souza ³ Data ³ 07/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Segundo Modelo do CAT                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MDTR830                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MDTR830PX()

Local oPrint
Local i   := 1
Local x   := 0
Local lin     := 0
Private oFont16,oFont14,oFont12,oFont11,oFont10,oFont09,oFont08,oFont07,oFont07b,oFont06,oFont06b
Private oFontYY,oFontXX
oPrint := TMSPrinter():New( OemToAnsi("Comunicacao de Acidente de Trabalho - CAT") )
oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...

If mv_par03 == 2
  oFont08 := TFont():New("TIMES NEW ROMAN",08,08,,.T.,,,,.T.,.F.)
  oFontXX := TFont():New("COURIER NEW",10,10,,.F.,,,,.F.,.F.)
  oFontYY := TFont():New("COURIER NEW",09,09,,.T.,,,,.F.,.F.)
  oFont09 := TFont():New("TIMES NEW ROMAN",09,09,,.F.,,,,.T.,.F.)
  oFont14 := TFont():New("TIMES NEW ROMAN",14,14,,.T.,,,,.T.,.F.)
  oFont16 := TFont():New("TIMES NEW ROMAN",16,16,,.T.,,,,.T.,.F.)
  MDTR830M2(oPrint,@i,@lin)
Elseif mv_par03 == 3
  oFont07b := TFont():New("LUCIDA CONSOLE",07,07,,.F.,,,,.F.,.F.)
  oFont06b := TFont():New("LUCIDA CONSOLE",05,05,,.F.,,,,.F.,.F.)
  oFontXX := TFont():New("COURIER NEW",10,10,,.F.,,,,.F.,.F.)
  oFontYY := TFont():New("COURIER NEW",09,09,,.T.,,,,.F.,.F.)
  oFont05 := TFont():New("TIMES NEW ROMAN",05,05,,.F.,,,,.F.,.F.)
  oFont06 := TFont():New("ARIAL",06,06,,.F.,,,,.F.,.F.)
  oFont07 := TFont():New("ARIAL",07,07,,.F.,,,,.F.,.F.)
  oFont08 := TFont():New("ARIAL",08,08,,.F.,,,,.F.,.F.)
  oFont09 := TFont():New("ARIAL",09,09,,.F.,,,,.F.,.F.)
  oFont10 := TFont():New("ARIAL",10,10,,.F.,,,,.F.,.F.)
  oFont11 := TFont():New("ARIAL",10,10,,.T.,,,,.F.,.F.)
  oFont12 := TFont():New("ARIAL",12,12,,.T.,,,,.T.,.T.)
  MDTR830M3(oPrint,@i,@Lin)
Endif
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   MDTR830MOD3³ Autor ³Denis Hyroshi de Souza ³ Data ³ 07/12/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MDTR830                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MDTR830M3(oPrint,i,l)

Local lin := 100, strEmit := "EMITENTE", strEmpr := "EMPREGADOR", strViti := "ACIDENTADO"
Local strAcid := "ACIDENTE OU DOENÇA", strTest := "TESTEMUNHAS", strAten := "ATENDIMEN."
Local strAtes := "ATESTADO MÉDICO", strLesa := "LESÃO", strDiag := "DIAGNÓST."
Local strInss := "INSS", cIndLocal := "ESTAB. EMPRESA"
Local strNota01, strNota02, strNota03, strNota04, strNota05
strNota01 := "A indexatidão das declarações desta comunica- ção implicará nas sanções previstas nos arts. "
strNota01 += "171 e 299 do Código Penal."
strNota02 := "A comunicação de acidente do trabalho deverá ser feita até o 1º dia útil após o acidente, "
strNota02 += "sob pena de multa."
strNota03 := "A comunicação de acidente do trabalho reger-se-á pelo art. 134 do Decreto nº 2.172/97."
strNota04 := "Os conceitos de acidente do trabalho e doença ocupacional estão definidos nos arts. 131 a 133 "
strNota04 += "do Decreto nº 2.172/97."
strNota05 := "A caracterização do acidente reger-se-á pelo art. 135 do Decreto nº 2.172/97."

DbSelectArea("TNC")
DbSetOrder(1)
DbSeek(xFilial("TNC")+mv_par01,.t.)

While !Eof()                                 .AND.;
  TNC->TNC_FILIAL == xFIlial("TNC")        .AND.;
  TNC->TNC_ACIDEN <= mv_par02

  oPrint:StartPage()
  DbSelectArea("TNC")
  DbSetOrder(1)
  DbSelectArea("TM0")
  DbSetOrder(1)
  DbSeek(xFilial("TM0")+TNC->TNC_NUMFIC)
  Dbselectarea("SRA")
  DbSetOrder(1)
  DbSeek(xFilial("SRA")+TM0->TM0_MAT)
  Dbselectarea("TNH")
  DbSetOrder(1)
  DbSeek(xFilial("TNH")+TNC->TNC_CODOBJ)
  Dbselectarea("TMT")
  DbSetOrder(7)
  DbSeek(xFilial("TMT")+TNC->TNC_ACIDEN)
  Dbselectarea("TMK")
  DbSetOrder(1)
  DbSeek(xFilial("TMK")+TMT->TMT_CODUSU)
  Dbselectarea("TMR")
  DbSetOrder(1)
  DbSeek(xFilial("TMR")+TMT->TMT_CID)
  Dbselectarea(cAlias)
  DBSETORDER(1)
  DbSeek(xFilial(cAlias)+TNC->TNC_CC)
  DbSelectArea("SRJ")
  DBSetOrder(1)
  DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
  cCBO := SRJ->RJ_CBO
  If FieldPos("RJ_CODCBO") > 0
      If !Empty(SRJ->RJ_CODCBO)
          cCBO := SRJ->RJ_CODCBO
      Endif
  Endif
    Dbselectarea("SRA")

    cTipInsc := str(SM0->M0_TPINSC,1)
    cCGCCOM := alltrim(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
    cCGCSEM := SM0->M0_CGC

    cEstCiv := space(1)
  IF SRA->RA_ESTCIVI = "C" ; cEstCiv := "2"   //"CASADO(A)"
  ELSEIF SRA->RA_ESTCIVI = "D" ; cEstCiv := "4" //"DIVORCIADO(A)"
  ELSEIF SRA->RA_ESTCIVI = "M" ; cEstCiv := "5"   //"MARITAL"
  ELSEIF SRA->RA_ESTCIVI = "Q" ; cEstCiv := "5" //"DESQUITADO(A)"
  ELSEIF SRA->RA_ESTCIVI = "S" ; cEstCiv := "1" //"SOLTEIRO(A)"
  ELSEIF SRA->RA_ESTCIVI = "V" ; cEstCiv := "3" //"VIUVO(A)"
  ENDIF

  oPrint:Box(lin,1000,200,2350)
  oPrint:Line(200,1000,300,1000)
  oPrint:Line(200,2350,300,2350)
  oPrint:Box(300,30,3000,2350)
  oPrint:Say(130,260," PREVIDÊNCIA  SOCIAL ",oFont12)
  oPrint:Say(180,260,"INSTITUTO NACIONAL DO SEGURO SOCIAL",oFont07)
  oPrint:Say(240,30,"COMUNICAÇÃO DE ACIDENTE DO TRABALHO - CAT",oFont11)

  Linha := 890
  For xx := 1 to len(strEmit)//EMITENTE
      oPrint:Say(Linha,70,substr(strEmit,xx,1),oFont07b)
      linha += 20
  Next xx

  Linha := 330
  For xx := 1 to len(strEmpr)//Empregador
      oPrint:Say(Linha,170,substr(strEmpr,xx,1),oFont07b)
      linha += 20
  Next xx

  Linha := 670
  For xx := 1 to len(strViti)//Acidentado
      oPrint:Say(Linha,170,substr(strViti,xx,1),oFont07b)
      linha += 20
  Next xx

  Linha := 1000
  For xx := 1 to len(strAcid)//Acidente ou Doenca
      oPrint:Say(Linha,170,substr(strAcid,xx,1),oFont07b)
      linha += 20
  Next xx

  Linha := 1416
  For xx := 1 to len(strTest)//Testemunhas
      oPrint:Say(Linha,170,substr(strTest,xx,1),oFont07b)
      linha += 20
  Next xx

  Linha := 1890
  For xx := 1 to len(strAtes)//Atestado Medico
      oPrint:Say(Linha,70,substr(strAtes,xx,1),oFont07b)
      linha += 20
  Next xx

  Linha := 1830
  For xx := 1 to len(strAten)//Atendimento
      oPrint:Say(Linha,170,substr(strAten,xx,1),oFont06b)
      linha += 20
  Next xx

  Linha := 2030
  For xx := 1 to len(strLesa)//Lesao
      oPrint:Say(Linha,170,substr(strLesa,xx,1),oFont06b)
      linha += 20
  Next xx

  Linha := 2135
  For xx := 1 to len(strDiag)//Diagnostico
      oPrint:Say(Linha,170,substr(strDiag,xx,1),oFont06b)
      linha += 20
  Next xx

  Linha := 2660
  For xx := 1 to len(strInss)//INSS
      oPrint:Say(Linha,70,substr(strInss,xx,1),oFont07b)
      linha += 20
  Next xx

  oPrint:Say(lin+10,1020,"1 - Emitente",oFont07)
  oPrint:Box(lin+2,1220,lin+45,1250)
  oPrint:Say(lin+60,1020,"1 - Empregador   2 - Sindicato   3 - Médico   4 - Segurado ou Dependente   5 - Autoridade Pública",oFont06)
  oPrint:Say(lin+5,1225,TNC->TNC_EMITEN ,oFont10)
  oPrint:Say(lin+110,1020,"2 - Tipo de CAT",oFont07)
  oPrint:Box(lin+102,1270,lin+145,1300)
  oPrint:Say(lin+160,1020,"1 - Início   2 - Reabertura   3 - Comunicação de Óbito em "+If(TNC->TNC_TIPCAT == "3",DtoC(TNC->TNC_DTOBIT),"___/___/___"),oFont07)
  oPrint:Say(lin+105,1275,TNC->TNC_TIPCAT,oFont10)
    lin := 300

// PRIMEIRA PARTE

  oPrint:Line(lin+1350,30,lin+1350,2350)
  oPrint:Line(lin,130,lin+1350,130)
  oPrint:Line(lin,230,lin+1350,230)
  oPrint:Line(lin+250,130,lin+250,2350)
  oPrint:Line(lin+675,130,lin+675,2350)
  oPrint:Line(lin+1100,130,lin+1100,2350)
  oPrint:Line(lin+125,230,lin+125,2350)
  oPrint:Line(lin+350,230,lin+350,2350)
  oPrint:Line(lin+435,230,lin+435,2350)
  oPrint:Line(lin+515,230,lin+515,2350)
  oPrint:Line(lin+595,230,lin+595,2350)
  oPrint:Line(lin+755,230,lin+755,2350)
  oPrint:Line(lin+835,230,lin+835,2350)
  oPrint:Line(lin+915,230,lin+915,2350)
  oPrint:Line(lin+1145,230,lin+1140,2350)
  oPrint:Line(lin+1225,230,lin+1225,2350)
  oPrint:Line(lin+1270,230,lin+1265,2350)
    //EMPREGADOR_________________________________________________________________________________________________
  oPrint:Say(lin+10,250,"3 - "+"Razão Social / Nome",oFont07)
  oPrint:Say(lin+55,250,SM0->M0_NOMECOM,oFont08)
  oPrint:Line(lin,1000,lin+350,1000)
  oPrint:Say(lin+10,1020,"4 - "+"Tipo",oFont07)
  oPrint:Box(lin+2,1200,lin+45,1230)
  oPrint:Say(lin+10,1340,"1 - CEI       2 - CNPJ      3 - CPF      4 - NT",oFont07)
  oPrint:Say(lin+55,1020,If(cTipInsc == "2",cCGCCOM,cCGCSEM),oFont10)
  oPrint:Say(lin+5,1205,cTipInsc,oFont10)
  oPrint:Line(lin,2110,lin+250,2110)
  oPrint:Say(lin+10,2130,"5 - "+"CNAE",oFont07)
  oPrint:Say(lin+55,2130,SM0->M0_CNAE,oFont10)

  oPrint:Say(lin+135,250,"6 - "+"Endereço Rua/Av./Nº/Comp.",oFont07)
  oPrint:Say(lin+180,250,SM0->M0_ENDCOB,oFont10)
  oPrint:Line(lin,1000,lin+350,1000)
  oPrint:Say(lin+135,1020,"Bairro",oFont07)
  oPrint:Say(lin+180,1020,SM0->M0_BAIRCOB,oFont10)
  oPrint:Line(lin+125,1350,lin+250,1350)
  oPrint:Say(lin+135,1370,"CEP",oFont07)
  oPrint:Say(lin+180,1350,Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont10)
  oPrint:Line(lin+125,1550,lin+250,1550)
  oPrint:Say(lin+135,1570,"7 - "+"Município",oFont07)
  oPrint:Say(lin+180,1570,SM0->M0_CIDCOB,oFont10)
  oPrint:Line(lin+125,1950,lin+250,1950)
  oPrint:Say(lin+135,1970,"8 - "+"UF",oFont07)
  oPrint:Say(lin+180,1970,Upper(SM0->M0_ESTCOB),oFont10)
  oPrint:Say(lin+135,2130,"9 - "+"Telefone",oFont07)
  oPrint:Say(lin+180,2130,SM0->M0_TEL,oFont10)
    //ACIDENTADO_______________________________________________________________________________________________
  oPrint:Say(lin+260,250,"10 - "+"Nome",oFont07)
  oPrint:Say(lin+305,250,SRA->RA_NOME,oFont10)
  oPrint:Say(lin+260,1020,"11 - "+"Nome da Mãe",oFont07)
  oPrint:Say(lin+305,1020,SRA->RA_MAE,oFont10)

  oPrint:Say(lin+360,250,"12 - "+"Data Nasc.",oFont07)
  oPrint:Say(lin+395,250,Dtoc(SRA->RA_NASC),oFont10)
  oPrint:Line(lin+350,490,lin+435,490)
  oPrint:Say(lin+360,510,"13 - "+"Sexo",oFont07)
  oPrint:Box(lin+352,670,lin+395,700)
  oPrint:Say(lin+355,675,If(SRA->RA_SEXO = "M","1","2"),oFont10)
  oPrint:Say(lin+405,510,"1 - Masc. 2 - Fem.",oFont06)
  oPrint:Line(lin+350,750,lin+435,750)
  oPrint:Say(lin+360,770,"14 - "+"Estado Civil",oFont07)
  oPrint:Box(lin+352,1030,lin+395,1060)
  oPrint:Say(lin+355,1035,cEstCiv,oFont10)
  oPrint:Say(lin+405,760,"1-Solteiro 2-Casado 3-Viúvo 4-Sep. Jud. 5-Outros 6-IGN",oFont06)
  oPrint:Line(lin+350,1530,lin+435,1530)
  oPrint:Say(lin+360,1550,"15 - "+"CTPS  Série",oFont07)
  oPrint:Say(lin+395,1545,Transform(SRA->RA_NUMCP,"@R 999.999")+" - "+SRA->RA_SERCP,oFont09)
  oPrint:Line(lin+350,1850,lin+435,1850)
  oPrint:Say(lin+360,1870,"Data de Emissão",oFont07)
  If FieldPos("RA_DTEMICP") > 0
      oPrint:Say(lin+395,1870,DTOC(SRA->RA_DTEMICP),oFont10)
  Endif
  oPrint:Line(lin+350,2180,lin+435,2180)
  oPrint:Say(lin+360,2200,"16 - "+"UF",oFont07)
  oPrint:Say(lin+395,2200,SRA->RA_UFCP,oFont10)

  oPrint:Say(lin+445,250,"17 - "+"Carteira de Identidade",oFont07)
  oPrint:Say(lin+480,250,SRA->RA_RG,oFont10)
  oPrint:Line(lin+435,710,lin+515,710)
  oPrint:Say(lin+445,730,"Data de Emissão",oFont07)
  If FieldPos("RA_RGDTEMI") > 0
      oPrint:Say(lin+480,730,DtoC(SRA->RA_RGDTEMI),oFont10)
  Endif
  oPrint:Line(lin+435,970,lin+515,970)
  oPrint:Say(lin+445,990,"Orgão Exp.",oFont07)
  If FieldPos("RA_RGORG") > 0
      oPrint:Say(lin+480,990,SRA->RA_RGORG,oFont10)
  ENdif
  oPrint:Line(lin+435,1150,lin+515,1150)
  oPrint:Say(lin+445,1170,"18 - "+"UF",oFont07)
  If FieldPos("RA_RGUF") > 0
      oPrint:Say(lin+480,1170,SRA->RA_RGUF,oFont10)
  Endif
  oPrint:Line(lin+435,1300,lin+515,1300)
  oPrint:Say(lin+445,1320,"19 - "+"PIS/PASEP",oFont07)
  oPrint:Say(lin+480,1320,SRA->RA_PIS,oFont10)
  oPrint:Line(lin+435,1850,lin+515,1850)
  oPrint:Say(lin+445,1870,"20 - "+"Remuneração Mensal",oFont07)
  oPrint:Say(lin+480,1870,"R$"+space(1)+AllTrim(Transform(SRA->RA_SALARIO,"@E 999,999,999.99")),oFont10)

  oPrint:Say(lin+525,250,"21 - "+"Endereço Rua/Av./Nº/Comp.",oFont07)
  oPrint:Say(lin+560,250,SRA->RA_ENDEREC,oFont10)
  oPrint:Line(lin+515,1000,lin+595,1000)
  oPrint:Say(lin+525,1020,"Bairro",oFont07)
  oPrint:Say(lin+560,1020,SRA->RA_BAIRRO,oFont10)
  oPrint:Line(lin+515,1300,lin+595,1300)
  oPrint:Say(lin+525,1320,"CEP",oFont07)
  oPrint:Say(lin+560,1310,Transform(SRA->RA_CEP,"@R 99999-999"),oFont10)
  oPrint:Line(lin+515,1510,lin+595,1510)
  oPrint:Say(lin+525,1530,"22 - "+"Município",oFont07)
  oPrint:Say(lin+560,1530,SRA->RA_MUNICIP,oFont10)
  oPrint:Line(lin+515,1900,lin+595,1900)
  oPrint:Say(lin+525,1920,"23 - "+"UF",oFont07)
  oPrint:Say(lin+560,1920,SRA->RA_ESTADO,oFont10)
  oPrint:Line(lin+515,2050,lin+595,2050)
  oPrint:Say(lin+525,2070,"24 - "+"Telefone",oFont07)
  oPrint:Say(lin+560,2070,SRA->RA_TELEFON,oFont10)

  oPrint:Say(lin+605,250,"25 - "+"Nome da Ocupação",oFont07)
  oPrint:Say(lin+640,250,SRJ->RJ_DESC,oFont10)
  oPrint:Line(lin+595,650,lin+675,650)
  oPrint:Say(lin+605,670,"26 - "+"CBO",oFont07)
  oPrint:Say(lin+640,670,Substr(cCBO,1,10),oFont10)
  oPrint:Line(lin+595,900,lin+675,900)
  oPrint:Say(lin+605,920,"27 - "+"Filiação à Previdência Social",oFont07)
  oPrint:Box(lin+597,1480,lin+640,1510)
  oPrint:Say(lin+600,1485,If(TNC->TNC_TIPREV == "6","7",If(TNC->TNC_TIPREV == "7","8",TNC->TNC_TIPREV)),oFont10)
  oPrint:Say(lin+647,920,"1-Empregado 2-Trab. Avulso 7-Seg. Trabalho 8-Médico Resid.",oFont07)
  oPrint:Line(lin+595,1810,lin+675,1810)
  oPrint:Say(lin+605,1830,"28 - "+"Aposentado ?",oFont07)
  oPrint:Box(lin+597,2060,lin+640,2090)
  oPrint:Say(lin+600,2065,TNC->TNC_APOSEN,oFont10)
  oPrint:Say(lin+647,1830,"1 - Sim  2 - Não",oFont07)
  oPrint:Line(lin+595,2100,lin+675,2100)
  oPrint:Say(lin+605,2120,"29 - "+"Área",oFont07)
  oPrint:Box(lin+597,2270,lin+640,2300)
  oPrint:Say(lin+600,2275,TNC->TNC_AREA,oFont10)
  oPrint:Say(lin+647,2110,"1 - Urbano  2 - Rural",oFont05)

  //ACIDENTE OU DOENCA_______________________________________________________________________________________
  oPrint:Say(lin+685,250,"30 - "+"Data Acidente",oFont07)
  oPrint:Say(lin+720,250,Dtoc(TNC->TNC_DTACID),oFont10)
  oPrint:Line(lin+675,535,lin+835,535)
  oPrint:Say(lin+685,555,"31 - "+"Hora Acidente",oFont07)
  oPrint:Say(lin+720,555,Transform(TNC->TNC_HRACID,"99:99"),oFont10)
  oPrint:Line(lin+675,860,lin+835,860)
  oPrint:Say(lin+685,880,"32 - "+"Após quantas horas de trab.?",oFont06)
  oPrint:Say(lin+720,880,Transform(TNC->TNC_HRTRAB,"99:99"),oFont10)
  oPrint:Line(lin+675,1320,lin+835,1320)
  oPrint:Say(lin+685,1340,"33 - "+"Houve afastamento?",oFont07)
  oPrint:Box(lin+677,1730,lin+720,1760)
  oPrint:Say(lin+680,1735,TNC->TNC_AFASTA,oFont10)
  oPrint:Say(lin+727,1340,"1 - Sim  2 - Não",oFont07)
  oPrint:Line(lin+675,1820,lin+755,1820)
  oPrint:Say(lin+685,1840,"34 - "+"Último dia trabalhado",oFont07)
  oPrint:Say(lin+720,1840,Dtoc(TNC->TNC_DTULTI),oFont10)

  If TNC->TNC_INDLOC == "2"
      cIndLocal := "PRES. SERVIÇO"
  ElseIf TNC->TNC_INDLOC == "3"
      cIndLocal := "VIA PÚBLICA"
  ElseIf TNC->TNC_INDLOC == "4"
      cIndLocal := "ÁREA RURAL"
  ElseIf TNC->TNC_INDLOC == "5"
      cIndLocal := " "
  Endif

  oPrint:Say(lin+765,250,"35 - "+"Local Acidente",oFont07)
  oPrint:Say(lin+800,250,cIndLocal,oFont08)
  oPrint:Say(lin+765,555,"36 - "+"CNPJ",oFont07)
  oPrint:Say(lin+800,555,Transform(TNC->TNC_CGCPRE,"@R 99.999.999/9999-99"),oFont08)
  oPrint:Say(lin+765,880,"37 - "+"Município do Local do Acid.",oFont06)
  oPrint:Say(lin+800,880,TNC->TNC_CIDACI,oFont10)
  oPrint:Say(lin+765,1340,"38 - "+"UF",oFont07)
  oPrint:Say(lin+800,1340,TNC->TNC_ESTACI,oFont10)
  oPrint:Line(lin+755,1520,lin+835,1520)
  oPrint:Say(lin+765,1540,"39 - "+"Especificação do Local do Acidente",oFont07)
  oPrint:Say(lin+800,1540,Alltrim(TNC->TNC_LOCAL),oFont10)

  oPrint:Say(lin+845,250,"40 - "+"Parte(s) do Corpo Atingida(s)",oFont07)
  oPrint:Say(lin+880,250,MemoLine(TNC->TNC_PARTE,55,1),oFont10)
  oPrint:Line(lin+835,1140,lin+915,1140)
  oPrint:Say(lin+845,1160,"41 - "+"Agente Causador",oFont07)
  oPrint:Say(lin+880,1160,TNH->TNH_DESOBJ,oFont10)


  oPrint:Say(lin+925,250,"42 - "+"Descrição da situação geradora do Acidente ou Doença",oFont07)
  oPrint:Say(lin+970,250,TNC->TNC_DESCR1,oFont10)
  oPrint:Say(lin+1035,250,TNC->TNC_DESCR2,oFont10)
  oPrint:Line(lin+915,1830,lin+1100,1830)
  oPrint:Say(lin+925,1850,"43 - "+"Houve registro policial?",oFont07)
  oPrint:Box(lin+917,2290,lin+960,2320)
  oPrint:Say(lin+920,2295,TNC->TNC_POLICI,oFont10)
  oPrint:Say(lin+979,1850,"1 - Sim  2 - Não",oFont07)
  oPrint:Line(lin+1007,1830,lin+1007,2350)
  oPrint:Say(lin+1017,1850,"44 - "+"Houve morte?",oFont07)
  oPrint:Box(lin+1009,2150,lin+1052,2180)
  oPrint:Say(lin+1012,2155,TNC->TNC_MORTE,oFont10)
  oPrint:Say(lin+1072,1850,"1 - Sim  2 - Não",oFont07)


  //TESTEMUNHAS _______________________________________________________________________________________
  oPrint:Say(lin+1110,250,"45 - "+"Nome",oFont07)
  oPrint:Say(lin+1105,450,TNC->TNC_TESTE1,oFont10)

  oPrint:Say(lin+1155,250,"46 - "+"Endereço Rua/Av./Nº/Comp.",oFont07)
  oPrint:Say(lin+1190,250,TNC->TNC_ENDTE1,oFont10)
  oPrint:Line(lin+1145,1000,lin+1225,1000)
  oPrint:Say(lin+1155,1020,"Bairro",oFont07)
  oPrint:Say(lin+1190,1020,TNC->TNC_BAIRR1,oFont10)
  oPrint:Line(lin+1145,1300,lin+1225,1300)
  oPrint:Say(lin+1155,1320,"CEP",oFont07)
  oPrint:Say(lin+1190,1320,TNC->TNC_CEP1,oFont10)
  oPrint:Line(lin+1145,1500,lin+1225,1500)
  oPrint:Say(lin+1155,1520,"47 - "+"Município",oFont07)
  oPrint:Say(lin+1190,1520,TNC->TNC_CIDAD1,oFont10)
  oPrint:Line(lin+1145,1900,lin+1225,1900)
  oPrint:Say(lin+1155,1920,"48 - "+"UF",oFont07)
  oPrint:Say(lin+1190,1920,TNC->TNC_ESTAD1,oFont10)
  oPrint:Line(lin+1145,2050,lin+1225,2050)
  oPrint:Say(lin+1155,2070,"Telefone",oFont07)
  oPrint:Say(lin+1190,2070,TNC->TNC_TELEF1,oFont10)


  oPrint:Say(lin+1235,250,"49 - "+"Nome",oFont07)
  oPrint:Say(lin+1230,450,TNC->TNC_TESTE2,oFont10)

  oPrint:Say(lin+1280,250,"50 - "+"Endereço Rua/Av./Nº/Comp.",oFont07)
  oPrint:Say(lin+1315,250,TNC->TNC_ENDTE2,oFont10)
  oPrint:Line(lin+1270,1000,lin+1350,1000)
  oPrint:Say(lin+1280,1020,"Bairro",oFont07)
  oPrint:Say(lin+1315,1020,TNC->TNC_BAIRR2,oFont10)
  oPrint:Line(lin+1270,1300,lin+1350,1300)
  oPrint:Say(lin+1280,1320,"CEP",oFont07)
  oPrint:Say(lin+1315,1320,TNC->TNC_CEP2,oFont10)
  oPrint:Line(lin+1270,1500,lin+1350,1500)
  oPrint:Say(lin+1280,1520,"51 - "+"Município",oFont07)
  oPrint:Say(lin+1315,1520,TNC->TNC_CIDAD2,oFont10)
  oPrint:Line(lin+1270,1900,lin+1350,1900)
  oPrint:Say(lin+1280,1920,"52 - "+"UF",oFont07)
  oPrint:Say(lin+1315,1920,TNC->TNC_ESTAD2,oFont10)
  oPrint:Line(lin+1270,2050,lin+1350,2050)
  oPrint:Say(lin+1280,2070,"Telefone",oFont07)
  oPrint:Say(lin+1315,2070,TNC->TNC_TELEF2,oFont10)


// SEGUNDA PARTE
  lin := 1650
  oPrint:Line(lin+675,30,lin+675,2350)
  oPrint:Line(lin+155,30,lin+155,2350)
  oPrint:Line(lin+175,30,lin+175,2350)
  oPrint:Line(lin,1200,lin+155,1200)
  oPrint:Line(lin+175,130,lin+675,130)
  oPrint:Line(lin+175,230,lin+675,230)
  oPrint:Line(lin+275,230,lin+275,2350)
  oPrint:Line(lin+375,130,lin+375,2350)
  oPrint:Line(lin+475,130,lin+475,2350)
  oPrint:Line(lin+575,230,lin+575,2350)
  oPrint:Line(lin+830,30,lin+830,2350)
  oPrint:Line(lin+850,30,lin+850,2350)
  oPrint:Line(lin+1270,30,lin+1270,2350)
  oPrint:Line(lin+850,130,lin+1270,130)
  oPrint:Line(lin+850,1600,lin+1270,1600)
  oPrint:Line(lin+950,130,lin+950,1600)
  oPrint:Line(lin+1050,130,lin+1050,1600)
  oPrint:Line(lin+675,1200,lin+830,1200)

   //ATENDIMENTO_______________________________________________________________________________
  oPrint:Line(lin+117,350,lin+117,1000)
  oPrint:Say(lin+127,580,"Local e Data",oFont07)
  oPrint:Line(lin+117,1400,lin+117,2050)
  oPrint:Say(lin+127,1500,"Assinatura e carimbo do Emitente",oFont07)

  oPrint:Line(lin+792,350,lin+792,1000)
  oPrint:Say(lin+802,580,"Local e Data",oFont07)
  oPrint:Line(lin+792,1400,lin+792,2050)
  oPrint:Say(lin+802,1458,"Assinatura e carimbo do Médico com CRM",oFont07)

  oPrint:Say(lin+185,250,"53 - "+"Unidade de Atendimento Médico",oFont07)
  oPrint:Say(lin+230,250,TNC->TNC_LOCATE,oFont10)
  oPrint:Line(lin+175,1700,lin+275,1700)
  oPrint:Say(lin+185,1720,"54 - "+"Data",oFont07)
  oPrint:Say(lin+230,1720,Dtoc(TNC->TNC_DTATEN),oFont10)
  oPrint:Line(lin+175,2050,lin+275,2050)
  oPrint:Say(lin+185,2070,"55 - "+"Hora",oFont07)
  oPrint:Say(lin+230,2070,Transform(TNC->TNC_HRATEN,"99:99"),oFont10)

  oPrint:Say(lin+285,250,"56 - "+"Houve internação?",oFont07)
  oPrint:Box(lin+277,590,lin+320,620)
  oPrint:Say(lin+280,595,TNC->TNC_INTERN,oFont10)
  oPrint:Say(lin+340,250,"1 - Sim  2 - Não",oFont07)
  oPrint:Line(lin+275,750,lin+375,750)
  oPrint:Say(lin+285,770,"57 - "+"Duração provável do tratam.",oFont07)
  oPrint:Box(lin+340,930,lin+370,990)
  oPrint:Say(lin+343,935,Alltrim(Str(TNC->TNC_QTAFAS,3)),oFont07)
  oPrint:Say(lin+340,1005,"Dia(s)",oFont07)
  oPrint:Line(lin+275,1270,lin+375,1270)
  oPrint:Say(lin+285,1290,"58 - "+"Deverá o acidentado afastar-se do trab. durante o trat.?",oFont07)
  oPrint:Box(lin+277,2280,lin+320,2310)
  oPrint:Say(lin+280,2285,TNC->TNC_AFASTA,oFont10)
  oPrint:Say(lin+340,1290,"1 - Sim  2 - Não",oFont07)

  oPrint:Say(lin+385,250,"59 - "+"Descrição e natureza da lesão",oFont07)
  oPrint:Say(lin+430,250,TNC->TNC_DESLES  ,oFont10)

  oPrint:Say(lin+485,250,"60 - "+"Diagnóstico provável",oFont07)
  oPrint:Say(lin+530,250,TMT->TMT_DIAGNO  ,oFont10)
  oPrint:Line(lin+475,2000,lin+575,2000)
  oPrint:Say(lin+485,2020,"61 - "+"CID",oFont07)
  oPrint:Say(lin+530,2020,TMT->TMT_CID,oFont10)

  oPrint:Say(lin+585,250,"62 - "+"Observações",oFont07)
  oPrint:Say(lin+630,250,TNC->TNC_OBSERV  ,oFont10)
  oPrint:Say(lin+860,150,"63 - "+"Recebida em",oFont07)
  oPrint:Line(lin+850,650,lin+950,650)
  oPrint:Say(lin+860,670,"64 - "+"Código da Unidade",oFont07)
  oPrint:Line(lin+850,1070,lin+950,1070)
  oPrint:Say(lin+860,1090,"65 - "+"Número do Acidente",oFont07)
  If TNC->(FieldPos("TNC_CATINS")) > 0
      oPrint:Say(lin+905,1090,TNC->TNC_CATINS,oFont10)
  Endif

  oPrint:Say(lin+960,150,"66 - "+"É reconhecido o direito do segurado à habilitação de benefício",oFont06)
  oPrint:Say(Lin+985,150,"     "+"acidentário?",oFont06)
  oPrint:Box(lin+985,450,lin+1025,480)
  oPrint:Say(lin+990,1125,"",oFont10)
  oPrint:Say(lin+1015,150,"1 - Sim  2 - Não",oFont07)
  oPrint:Line(lin+950,1070,lin+1050,1070)
  oPrint:Say(lin+960,1090,"67 - "+"Tipo",oFont07)
  oPrint:Box(lin+954,1270,lin+997,1300)
//    oPrint:Say(lin+955,1375,If(TNC->TNC_INDACI == "4","1",TNC->TNC_INDACI),oFont10)
  oPrint:Say(lin+1015,1090,"1 - Típico  2 - Trajeto  3 - Doença",oFont06)

  oPrint:Say(lin+1060,150,"68 - "+"Matrícula do servidor",oFont07)

  oPrint:Line(lin+1232,350,lin+1232,850)
  oPrint:Say(lin+1242,540,"Matrícula",oFont07)
  oPrint:Line(lin+1232,950,lin+1232,1450)
  oPrint:Say(lin+1242,1030,"Assinatura do servidor",oFont07)

  oPrint:Say(lin+860,1620,"Notas:",oFont07)

   nLinha := lin+860+30
  nLinhasMemo := MLCOUNT(strNota01,45)
  lPrint := .t.
  For LinhaCorrente := 1 to nLinhasMemo
      If lPrint
          oPrint:Say(nLinha,1620,"1.",oFont07)
          lPrint := .f.
      Endif
      oPrint:Say(nLinha,1660,(MemoLine(strNota01,45,LinhaCorrente)),oFont07)
      nLinha += 25
  Next LinhaCorrente

  nLinha += 5
  nLinhasMemo := MLCOUNT(strNota02,45)
  lPrint := .t.
  For LinhaCorrente := 1 to nLinhasMemo
      If lPrint
          oPrint:Say(nLinha,1620,"2.",oFont07)
          lPrint := .f.
      Endif
      oPrint:Say(nLinha,1660,(MemoLine(strNota02,45,LinhaCorrente)),oFont07)
      nLinha += 25
  Next LinhaCorrente

  nLinha += 5
  nLinhasMemo := MLCOUNT(strNota03,45)
  lPrint := .t.
  For LinhaCorrente := 1 to nLinhasMemo
      If lPrint
          oPrint:Say(nLinha,1620,"3.",oFont07)
          lPrint := .f.
      Endif
      oPrint:Say(nLinha,1660,(MemoLine(strNota03,45,LinhaCorrente)),oFont07)
      nLinha += 25
  Next LinhaCorrente

  nLinha += 5
  nLinhasMemo := MLCOUNT(strNota04,45)
  lPrint := .t.
  For LinhaCorrente := 1 to nLinhasMemo
      If lPrint
          oPrint:Say(nLinha,1620,"4.",oFont07)
          lPrint := .f.
      Endif
      oPrint:Say(nLinha,1660,(MemoLine(strNota04,45,LinhaCorrente)),oFont07)
      nLinha += 25
  Next LinhaCorrente

  nLinha += 5
  nLinhasMemo := MLCOUNT(strNota05,45)
  lPrint := .t.
  For LinhaCorrente := 1 to nLinhasMemo
      If lPrint
          oPrint:Say(nLinha,1620,"5.",oFont07)
          lPrint := .f.
      Endif
      oPrint:Say(nLinha,1660,(MemoLine(strNota05,45,LinhaCorrente)),oFont07)
      nLinha += 25
  Next LinhaCorrente

  oPrint:Say(lin+1285,120,"A COMUNICAÇÃO DO ACIDENTE É OBRIGATÓRIA, MESMO NO CASO EM QUE NÃO HAJA AFASTAMENTO DO TRABALHO.",oFont11)

  RECLOCK("TNC",.F.)
  TNC->TNC_DTEMIS := date()
  MSUNLOCK("TNC")

  I++
  oPrint:EndPage()
    Dbselectarea("TNC")
    IF FieldPos('TNC_INDACI') > 0
      If TNC->TNC_INDACI == "2"
          QUEST830(oPrint)
      Endif
  Endif
  lin := 100
  DbSelectArea("TNC")
  DbSkip()
EndDo
oPrint:Preview()

Return Nil


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   MDTR830MOD3³ Autor ³Denis Hyroshi de Souza ³ Data ³ 07/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MDTR830                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MDTR830M2(oPrint,i,l)

Local lin := 150, cEmitente := space(10), cTipoCat := space(10), cTipoFil := space(10)
Local cSexo := space(5), cEstCiv := space(5), cApos := space(3), cArea := space(5)
Local cTipAci := space(10), cAfastam := space(3), cPolicial := space(3), cObito := space(3)
Local cCidtest := space(10), cIntern := space(3), cAfastm := space(3), cTipoinsc := space(10)
Local cIndLocal := space(10)
DbSelectArea("TNC")
DbSetOrder(1)
DbSeek(xFilial("TNC")+mv_par01,.t.)

While !Eof()                                 .AND.;
  TNC->TNC_FILIAL == xFIlial("TNC")        .AND.;
  TNC->TNC_ACIDEN <= mv_par02

  oPrint:StartPage()
  DbSelectArea("TNC")
  DbSetOrder(1)
  DbSeek(xFilial("TNC")+TNC->TNC_ACIDEN)
  DbSelectArea("TM0")
  DbSetOrder(1)
  DbSeek(xFilial("TM0")+TNC->TNC_NUMFIC)
  Dbselectarea("SRA")
  DbSetOrder(1)
  DbSeek(xFilial("SRA")+TM0->TM0_MAT)
  Dbselectarea("TNH")
  DbSetOrder(1)
  DbSeek(xFilial("TNH")+TNC->TNC_CODOBJ)
    Dbselectarea("TMT")
    DbSetOrder(7)
    DbSeek(xFilial("TMT")+TNC->TNC_ACIDEN)
    Dbselectarea("TMK")
    DbSetOrder(1)
    DbSeek(xFilial("TMK")+TMT->TMT_CODUSU)
    Dbselectarea("TMR")
    DbSetOrder(1)
    DbSeek(xFilial("TMR")+TMT->TMT_CID)
    Dbselectarea(cAlias)
    DbSetOrder(1)
    DbSeek(xFilial(cAlias)+TNC->TNC_CC)

    oPrint:Box(lin, 30, 250, 2350 )
    oPrint:Say(lin+20,670,"Comunicação de Acidente de Trabalho",oFont16 ) //"Comunicação de Acidente de Trabalho"
    lin := 270

    IF TNC->TNC_EMITEN = "1" ; cEmitente := "EMPREGADOR"
    ELSEIF TNC->TNC_EMITEN = "2" ; cEmitente := "SINDICATO"
    ELSEIF TNC->TNC_EMITEN = "3" ;    cEmitente := "MEDICO"
    ELSEIF TNC->TNC_EMITEN = "4" ;    cEmitente := "SEGURADO"
    ELSEIF TNC->TNC_EMITEN = "5" ;    cEmitente := "AUT. PUBLICA"
    ENDIF

  IF TNC->TNC_TIPCAT = "1" ; cTipoCat := "INICIAL"
  ELSEIF TNC->TNC_TIPCAT = "2" ; cTipoCat := "REABERTURA"
  ELSEIF TNC->TNC_TIPCAT = "3" ; cTipoCat := "OBITO"
  ENDIF

  IF TNC->TNC_TIPREV = "1" ; cTipoFil := "EMPREGADO"
  ELSEIF TNC->TNC_TIPREV = "2" ; cTipoFil := "TRABALHADOR AVULSO"
  ELSEIF TNC->TNC_TIPREV = "6" ; cTipoFil := "SEG. ESPECIAL"
  ELSEIF TNC->TNC_TIPREV = "7" ; cTipoFil := "MÉDICO RESIDENCIAL"
  ENDIF

  IF SRA->RA_SEXO = "M" ; cSexo := "MASCULINO"
  ELSEIF SRA->RA_SEXO = "F" ; cSexo := "FEMININO"
  ENDIF

  IF SRA->RA_ESTCIVI = "C" ; cEstCiv := "CASADO(A)"
  ELSEIF SRA->RA_ESTCIVI = "D" ; cEstCiv := "DIVORCIADO(A)"
  ELSEIF SRA->RA_ESTCIVI = "M" ; cEstCiv := "MARITAL"
  ELSEIF SRA->RA_ESTCIVI = "Q" ; cEstCiv := "DESQUITADO(A)"
  ELSEIF SRA->RA_ESTCIVI = "S" ; cEstCiv := "SOLTEIRO(A)"
  ELSEIF SRA->RA_ESTCIVI = "V" ; cEstCiv := "VIUVO(A)"
  ENDIF

  IF TNC->TNC_APOSEN = "1" ; cApos := "SIM"
  ELSE  ; cApos := "NÃO"
  ENDIF

  IF TNC->TNC_AREA = "1" ; cArea := "URBANA"
  ELSE ; cArea := "RURAL"
  ENDIF

    IF TNC->TNC_INDACI == "1" ; cTipAci := "ACIDENTE TIPICO"
    ELSEIF TNC->TNC_INDACI == "2" ; cTipAci := "ACIDENTE DE TRAJETO"
    ELSEIF TNC->TNC_INDACI == "3" ; cTipAci := "DOENÇA DO TRABALHO"
    ELSEIF TNC->TNC_INDACI == "4" ; cTipAci := "INCIDENTE"
    ENDIF

  IF TNC->TNC_AFASTA = "1" ; cAfastam := "SIM"
  ELSE ; cAfastam := "NÃO"
    ENDIF

  IF TNC->TNC_POLICI = "1" ; cPolicial := "SIM"
  ELSE ; cPolicial := "NÃO"
  ENDIF

  IF TNC->TNC_MORTE = "1" ; cObito := "SIM"
  ELSE ; cObito := "NÃO"
  ENDIF

  IF !EMPTY(TNC->TNC_ESTAD1)
      cCidtest := Alltrim(TNC->TNC_CIDAD1)+" - "+TNC->TNC_ESTAD1
  ELSE
      cCidtest := TNC->TNC_CIDAD1
  ENDIF

    IF TNC->TNC_INTERN = "1"  ; cIntern := "SIM"
    ELSE ; cIntern :=  "NÃO"
    ENDIF

    IF TNC->TNC_AFASTA = "1"  ; cAfastm := "SIM"
    ELSE   ; cAfastm :=  "NÃO"
    ENDIF

    cCGCCOM := alltrim(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
    cCGCSEM := SM0->M0_CGC


    IF SM0->M0_TPINSC = 1  ; cTipoinsc := "CEI"+" - "+cCGCSEM //"CEI"
    ELSEIF SM0->M0_TPINSC = 2  ; cTipoinsc := "CNPJ"+" - "+cCGCCOM //"CNPJ"
    ELSEIF SM0->M0_TPINSC = 3  ; cTipoinsc := "CPF"+" - "+cCGCSEM //"CPF"
    ELSEIF SM0->M0_TPINSC = 4  ; cTipoinsc := "INCRA"+" - "+cCGCSEM //"INCRA"
    ELSE ; cTipoinsc := cCGCSEM
    ENDIF

    cIndLocal := "ESTABELECIMENTO DA EMPRESA"
  If TNC->TNC_INDLOC == "2"
      cIndLocal := "ONDE PRESTA SERVIÇO"
  ElseIf TNC->TNC_INDLOC == "3"
      cIndLocal := "VIA PÚBLICA"
  ElseIf TNC->TNC_INDLOC == "4"
      cIndLocal := "ÁREA RURAL"
  ElseIf TNC->TNC_INDLOC == "5"
      cIndLocal := " "
  Endif

  oPrint:Say(lin+10,30,"Informações do Emitente",oFont14 )   //"Informações do Emitente"
  lin += 10
  oPrint:Box(lin+60,30,lin+210,2350)
  oPrint:Line(lin+110,30,lin+110,2350)
  oPrint:Line(lin+160,30,lin+160,2350)
  oPrint:Line(lin+60,1160,lin+210,1160)
  oPrint:Line(lin+60,330,lin+210,330)
  oPrint:Line(lin+60,1460,lin+210,1460)
  oPrint:Say(lin+70,40,"Emitente",oFont08) //"Emitente"
  oPrint:Say(lin+70,340,cEmitente,oFont09)
  oPrint:Say(lin+70,1170,"Data Emissão",oFont08)   //"Data Emissão"
  oPrint:Say(lin+70,1470,DtoC(Date()),oFont09)
  oPrint:Say(lin+120,40,"Tipo de CAT",oFont08)  //"Tipo de CAT"
  oPrint:Say(lin+120,340,cTipoCat,oFont09)
  oPrint:Say(lin+120,1170,"Comunicação Obito",oFont08) //"Comunicação Obito"
  oPrint:Say(lin+120,1470,DtoC(TNC->TNC_DTOBIT),oFont09)
  oPrint:Say(lin+170,40,"Filiação",oFont08)           //"Filiação"
  oPrint:Say(lin+170,340,cTipoFil,oFont09)
  oPrint:Say(lin+170,1170,"E-mail",oFont08)  //"E-mail"
  oPrint:Say(lin+170,1470,"",oFont09)
  lin += 230

  oPrint:Say(lin+10,30,"Informações do Empregador",oFont14 ) //"Informações do Empregador"
  lin += 10
  oPrint:Box(lin+60,30,lin+310,2350)
  oPrint:Line(lin+110,30,lin+110,2350)
  oPrint:Line(lin+160,30,lin+160,2350)
  oPrint:Line(lin+210,30,lin+210,2350)
  oPrint:Line(lin+260,30,lin+260,2350)
  oPrint:Line(lin+110,1160,lin+310,1160)
  oPrint:Line(lin+60,330,lin+310,330)
  oPrint:Line(lin+110,1460,lin+310,1460)
  oPrint:Say(lin+70,40,"Razão Social/Nome",oFont08) //"Razão Social/Nome"
  oPrint:Say(lin+70,340,Upper(Substr(SM0->M0_NOMECOM,1,80)),oFont09)
  oPrint:Say(lin+120,40,"Tipo/Num. Documento",oFont08) //"Tipo/Num. Documento"
  oPrint:Say(lin+120,340,cTipoinsc,oFont09)
  oPrint:Say(lin+120,1170,"CNAE",oFont08)  //"CNAE"
  oPrint:Say(lin+120,1470,SM0->M0_CNAE,oFont09)
  oPrint:Say(lin+170,40,"CEP",oFont08)          //"CEP"
  oPrint:Say(lin+170,340,Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont09)
  oPrint:Say(lin+170,1170,"Endereço",oFont08)  //"Endereço"
  oPrint:Say(lin+170,1470,Upper(Substr(SM0->M0_ENDCOB,1,35)),oFont09)
  oPrint:Say(lin+220,40,"Bairro",oFont08)   //"Bairro"
  oPrint:Say(lin+220,340,Upper(SM0->M0_BAIRCOB),oFont09)
  oPrint:Say(lin+220,1170,"Estado",oFont08)  //"Estado"
  oPrint:Say(lin+220,1470,Upper(SM0->M0_ESTCOB),oFont09)
  oPrint:Say(lin+270,40,"Município",oFont08)   //"Município"
  oPrint:Say(lin+270,340,Upper(SM0->M0_CIDCOB),oFont09)
  oPrint:Say(lin+270,1170,"Telefone",oFont08)                      //"Telefone"
  oPrint:Say(lin+270,1470,SM0->M0_TEL,oFont09)
  lin += 330

  oPrint:Say(lin+10,30,"Informações do Acidentado",oFont14 ) //"Informações do Acidentado"
  lin += 10
  oPrint:Box(lin+60,30,lin+510,2350)
  oPrint:Line(lin+110,30,lin+110,2350)
  oPrint:Line(lin+160,30,lin+160,2350)
  oPrint:Line(lin+210,30,lin+210,2350)
  oPrint:Line(lin+260,30,lin+260,2350)
  oPrint:Line(lin+310,30,lin+310,2350)
  oPrint:Line(lin+360,30,lin+360,2350)
  oPrint:Line(lin+410,30,lin+410,2350)
  oPrint:Line(lin+460,30,lin+460,2350)
  oPrint:Line(lin+60,1160,lin+510,1160)
  oPrint:Line(lin+60,330,lin+510,330)
  oPrint:Line(lin+60,1460,lin+510,1460)
  oPrint:Say(lin+70,40,"Nome",oFont08)         //"Nome"
  oPrint:Say(lin+70,340,Substr(SRA->RA_NOME,1,35),oFont09)
  oPrint:Say(lin+70,1170,"Data de Nascimento",oFont08)  //"Data de Nascimento"
  oPrint:Say(lin+70,1470,Dtoc(SRA->RA_NASC),oFont09)
  oPrint:Say(lin+120,40,"Nome da Mãe",oFont08)  //"Nome da Mãe"
  oPrint:Say(lin+120,340,Substr(SRA->RA_MAE,1,35),oFont09)
  oPrint:Say(lin+120,1170,"Sexo",oFont08)      //"Sexo"
  oPrint:Say(lin+120,1470,cSexo,oFont09)
  oPrint:Say(lin+170,40,"Estado Civil",oFont08)  //"Estado Civil"
  oPrint:Say(lin+170,340,cEstCiv,oFont09)
  oPrint:Say(lin+170,1170,"Remuneração",oFont08)  //"Remuneração"
  oPrint:Say(lin+170,1470,"R$"+space(1)+AllTrim(Transform(SRA->RA_SALARIO,"@E 999,999,999.99")),oFont09) //"R$"
  oPrint:Say(lin+220,40,"CTPS",oFont08)  //"CTPS"
  oPrint:Say(lin+220,340,Transform(SRA->RA_NUMCP,"@R 999.999")+"  "+SRA->RA_SERCP,oFont09)
  oPrint:Say(lin+220,1170,"Identidade",oFont08)  //"Identidade"
  oPrint:Say(lin+220,1470,SRA->RA_RG,oFont09)
  oPrint:Say(lin+270,40,"PIS/PASEP/NIT",oFont08)  //"PIS/PASEP/NIT"
  oPrint:Say(lin+270,340,SRA->RA_PIS,oFont09)
  oPrint:Say(lin+270,1170,"Endereço",oFont08)  //"Endereço"
  oPrint:Say(lin+270,1470,Substr(SRA->RA_ENDEREC,1,35),oFont09)
  oPrint:Say(lin+320,40,"Bairro",oFont08)  //"Bairro"
  oPrint:Say(lin+320,340,SRA->RA_BAIRRO,oFont09)
  oPrint:Say(lin+320,1170,"CEP",oFont08)  //"CEP"
  oPrint:Say(lin+320,1470,Transform(SRA->RA_CEP,"@R 99999-999"),oFont09)
  oPrint:Say(lin+370,40,"Estado",oFont08)  //"Estado"
  oPrint:Say(lin+370,340,SRA->RA_ESTADO,oFont09)
  oPrint:Say(lin+370,1170,"Município",oFont08)  //"Município"
  oPrint:Say(lin+370,1470,SRA->RA_MUNICIP,oFont09)
  oPrint:Say(lin+420,40,"Telefone",oFont08)  //"Telefone"
  oPrint:Say(lin+420,340,SRA->RA_TELEFON,oFont09)
  oPrint:Say(lin+420,1170,"CBO",oFont08)       //"CBO"
  DbSelectArea("SRJ")
  DBSetOrder(1)
   DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
  cCBO := SRJ->RJ_CBO
  If FieldPos("RJ_CODCBO") > 0
          If !Empty(SRJ->RJ_CODCBO)
          cCBO := SRJ->RJ_CODCBO
      Endif
  Endif
  oPrint:Say(lin+420,1470,cCBO,oFont09)
  oPrint:Say(lin+470,40,"Aposentado",oFont08)  //"Aposentado"
  oPrint:Say(lin+470,340,cApos,oFont09)
  oPrint:Say(lin+470,1170,"Área",oFont08)     //"Área"
  oPrint:Say(lin+470,1470,cArea,oFont09)
  lin += 530

  oPrint:Say(lin+10,30,"Informações do Acidente",oFont14 ) //"Informações do Acidente"
  lin += 10
  oPrint:Box(lin+60,30,lin+810,2350)
  oPrint:Line(lin+110,30,lin+110,2350)
  oPrint:Line(lin+160,30,lin+160,2350)
  oPrint:Line(lin+210,30,lin+210,2350)
  oPrint:Line(lin+260,30,lin+260,2350)
  oPrint:Line(lin+310,30,lin+310,2350)
  oPrint:Line(lin+410,30,lin+410,2350)
  oPrint:Line(lin+460,30,lin+460,2350)
  oPrint:Line(lin+510,30,lin+510,2350)
  oPrint:Line(lin+560,30,lin+560,2350)
  oPrint:Line(lin+610,30,lin+610,2350)
  oPrint:Line(lin+710,30,lin+710,2350)
  oPrint:Line(lin+760,30,lin+760,2350)
  oPrint:Line(lin+60,1160,lin+410,1160)
  oPrint:Line(lin+560,1160,lin+810,1160)
  oPrint:Line(lin+60,330,lin+810,330)
  oPrint:Line(lin+60,1460,lin+410,1460)
  oPrint:Line(lin+560,1460,lin+810,1460)
  oPrint:Say(lin+70,40,"Data do Acidente",oFont08) //"Data do Acidente"
  oPrint:Say(lin+70,340,Dtoc(TNC->TNC_DTACID),oFont09)
  oPrint:Say(lin+70,1170,"Hora do Acidente",oFont08)  //"Hora do Acidente"
  oPrint:Say(lin+70,1470,Transform(TNC->TNC_HRACID,"99:99"),oFont09)
  oPrint:Say(lin+120,40,"Horas Trabalhadas",oFont08)  //"Horas Trabalhadas"
  oPrint:Say(lin+120,340,Transform(TNC->TNC_HRTRAB,"99:99"),oFont09)
  oPrint:Say(lin+120,1170,"Tipo",oFont08)  //"Tipo"
  oPrint:Say(lin+120,1470,cTipAci,oFont09)
  oPrint:Say(lin+170,40,"Afastamento",oFont08)  //"Afastamento"
  oPrint:Say(lin+170,340,cAfastam,oFont09)
  oPrint:Say(lin+170,1170,"Registro Policial",oFont08)  //"Registro Policial"
  oPrint:Say(lin+170,1470,cPolicial,oFont09)
  oPrint:Say(lin+220,40,"Local do Acidente",oFont08)  //"Local do Acidente"
  oPrint:Say(lin+220,340,cIndLocal,oFont09)
  oPrint:Say(lin+220,1170,"Especificação Local",oFont08)  //"Especificação Local"
  oPrint:Say(lin+220,1470,Substr(TNC->TNC_LOCAL,1,35),oFont09)
  oPrint:Say(lin+270,40,"CGC da Prestadora",oFont08)  //"CGC da Prestadora"
  oPrint:Say(lin+270,340,Transform(TNC->TNC_CGCPRE,"@R 99.999.999/9999-99"),oFont09)
  oPrint:Say(lin+270,1170,"UF do Acidente",oFont08)  //"UF do Acidente"
  oPrint:Say(lin+270,1470,Upper(TNC->TNC_ESTACI),oFont09)
  oPrint:Say(lin+320,40,"Município do",oFont08)  //"Município do"
  oPrint:Say(lin+340,340,Upper(TNC->TNC_CIDACI),oFont09)
  oPrint:Say(lin+320,1170,"Último dia",oFont08)  //"Último dia"
  oPrint:Say(lin+340,1470,Dtoc(TNC->TNC_DTULTI),oFont09)
  oPrint:Say(lin+370,40,"Acidente",oFont08)  //"Acidente"
  oPrint:Say(lin+370,1170,"Trabalhado/Dt Óbito",oFont08)  //"Trabalhado/Dt Óbito"
  oPrint:Say(lin+420,40,"Parte do Corpo",oFont08)  //"Parte do Corpo"
  oPrint:Say(lin+420,340,TNC->TNC_PARTE,oFont09)
  oPrint:Say(lin+470,40,"Agente Causador",oFont08)  //"Agente Causador"
  oPrint:Say(lin+470,340,TNH->TNH_DESOBJ,oFont09)
  oPrint:Say(lin+520,40,"Situação Geradora",oFont08)   //"Situação Geradora"
  oPrint:Say(lin+520,340,TNC->TNC_DESCR1,oFont09)
  oPrint:Say(lin+570,40,"Morte",oFont08)  //"Morte"
  oPrint:Say(lin+570,340,cObito,oFont09)
  oPrint:Say(lin+570,1170,"Data Óbito",oFont08)  //"Data Óbito"
  oPrint:Say(lin+570,1470,DtoC(TNC->TNC_DTOBIT),oFont09)
  oPrint:Say(lin+620,40,"Descrição do",oFont08)   //"Descrição do"
  oPrint:Say(lin+620,340,(MemoLine(TNC->TNC_DESACI,35,1)),oFont09)
  oPrint:Say(lin+670,340,(MemoLine(TNC->TNC_DESACI,35,2)),oFont09)
  oPrint:Say(lin+640,1170,"Nome Testemunha",oFont08)  //"Nome Testemunha"
  oPrint:Say(lin+640,1470,TNC->TNC_TESTE1,oFont09)
  oPrint:Say(lin+670,40,"Acidente",oFont08)  //"Acidente"
  oPrint:Say(lin+720,40,"Endereço",oFont08)  //"Endereço"
  oPrint:Say(lin+720,340,Substr(TNC->TNC_ENDTE1,1,35),oFont09)
  oPrint:Say(lin+720,1170,"CEP",oFont08)  //"CEP"
  oPrint:Say(lin+720,1470,Transform(TNC->TNC_CEP1,"@R 99999-999"),oFont09)
  oPrint:Say(lin+770,40,"Município/UF",oFont08)  //"Município/UF"
  oPrint:Say(lin+770,340,cCidtest,oFont09)
  oPrint:Say(lin+770,1170,"Telefone",oFont08)  //"Telefone"
  oPrint:Say(lin+770,1470,TNC->TNC_TELEF1,oFont09)
  lin += 830


  oPrint:Say(lin+10,30,"Informações do Atestado Médico",oFont14 ) //"Informações do Atestado Médico"
  lin += 10
  oPrint:Box(lin+60,30,lin+360,2350)
  oPrint:Line(lin+110,30,lin+110,2350)
  oPrint:Line(lin+160,30,lin+160,2350)
  oPrint:Line(lin+210,30,lin+210,2350)
  oPrint:Line(lin+260,30,lin+260,2350)
  oPrint:Line(lin+310,30,lin+310,2350)
  oPrint:Line(lin+60,1160,lin+210,1160)
  oPrint:Line(lin+310,1160,lin+360,1160)
  oPrint:Line(lin+60,330,lin+360,330)
  oPrint:Line(lin+60,1460,lin+210,1460)
  oPrint:Line(lin+310,1460,lin+360,1460)
  oPrint:Say(lin+70,40,"Unidade",oFont08)   //"Unidade"
  oPrint:Say(lin+70,340,Substr(TNC->TNC_LOCATE,1,35),oFont09)
  oPrint:Say(lin+70,1170,"Data Atendimento",oFont08)  //"Data Atendimento"
  oPrint:Say(lin+70,1470,Dtoc(TNC->TNC_DTATEN),oFont09)
  oPrint:Say(lin+120,40,"Hora Atendimento",oFont08)               //"Hora Atendimento"
  oPrint:Say(lin+120,340,Transform(TNC->TNC_HRATEN,"99:99"),oFont09)
  oPrint:Say(lin+120,1170,"Internação",oFont08)              //"Internação"
  oPrint:Say(lin+120,1470,cIntern,oFont09)
  oPrint:Say(lin+170,40,"Duração Tratamento",oFont08)        //"Duração Tratamento"
  oPrint:Say(lin+170,340,Alltrim(Str(TNC->TNC_QTAFAS,3))+" "+"DIA(S)",oFont09)  //"DIA(S)"
  oPrint:Say(lin+170,1170,"Afastamento",oFont08)             //"Afastamento"
  oPrint:Say(lin+170,1470,cAfastm,oFont09)
  oPrint:Say(lin+220,40,"Natureza Lesão",oFont08)                //"Natureza Lesão"
  oPrint:Say(lin+220,340,Upper(TNC->TNC_DESLES),oFont09)
  oPrint:Say(lin+270,40,"CID",oFont08)                       //"CID"
  oPrint:Say(lin+270,340,Upper(Substr(TMR->TMR_DOENCA,1,80)),oFont09)
  oPrint:Say(lin+320,40,"Observações",oFont08)               //"Observações"
  oPrint:Say(lin+320,340,Upper(Substr(TNC->TNC_OBSERV,1,35)),oFont09)
  oPrint:Say(lin+320,1170,"CRM",oFont08)                     //"CRM"
  oPrint:Say(lin+320,1470,TMK->TMK_NUMENT,oFont09)
  lin += 380

  RECLOCK("TNC",.F.)
  TNC->TNC_DTEMIS := date()
  MSUNLOCK("TNC")

  I++
  oPrint:EndPage()
    Dbselectarea("TNC")
    IF FieldPos('TNC_INDACI') > 0
      If TNC->TNC_INDACI == "2"
          QUEST830(oPrint)
      Endif
  Endif
  lin := 150
  DbSelectArea("TNC")
  DbSkip()
EndDo
oPrint:Preview()
Return Nil
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   |QUEST830  ³ Autor ³Denis Hyroshi de Souza ³ Data ³ 29/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Imprime o questinario de responsabilidade do empregador     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function QUEST830(oPrint)
Local aArea := TNC->(GetArea())
Local lin := 150
Local cLOCACT,cHORSAI,cTRAJET,cMEIO,cLOCACI,cDISTAC,cMUDANC,cMOTIVO,cADMITE,cCONFIN,cHRRPAD,cHRRDIA
store space(1) to cLOCACT,cHORSAI,cTRAJET,cMEIO,cLOCACI,cMUDANC,cMOTIVO,cADMITE,cCONFIN,cHRRPAD,cHRRDIA
store 0 to cDISTAC
Dbselectarea("TNC")
If FieldPos("TNC_LOCACT") > 0
  cLOCACT := TNC->TNC_LOCACT
Endif
If FieldPos("TNC_HORSAI") > 0
  cHORSAI := TNC->TNC_HORSAI
Endif
If FieldPos("TNC_TRAJET") > 0
  cTRAJET := TNC->TNC_TRAJET
Endif
If FieldPos("TNC_MEIO") > 0
  cMEIO   := TNC->TNC_MEIO
Endif
If FieldPos("TNC_LOCACI") > 0
  cLOCACI := TNC->TNC_LOCACI
Endif
If FieldPos("TNC_DISTAC") > 0
  cDISTAC := TNC->TNC_DISTAC
Endif
If FieldPos("TNC_MUDANC") > 0
  cMUDANC := TNC->TNC_MUDANC
Endif
If FieldPos("TNC_MOTIVO") > 0
  cMOTIVO := TNC->TNC_MOTIVO
Endif
If FieldPos("TNC_ADMITE") > 0
  cADMITE := TNC->TNC_ADMITE
Endif
If FieldPos("TNC_CONFIN") > 0
  cCONFIN := TNC->TNC_CONFIN
Endif
If FieldPos("TNC_HRRPAD") > 0
  cHRRPAD := TNC->TNC_HRRPAD
Endif
If FieldPos("TNC_HRRDIA") > 0
  cHRRDIA := TNC->TNC_HRRDIA
Endif


//***************
//***************  Pagina 1
//***************
oPrint:StartPage()
oPrint:Say(lin,400,"RSPS - COORDENAÇÃO REGIONAL DE ACIDENTES DE TRABALHO",oFontXX)
lin += 50
oPrint:Say(lin,150,"QUALIFICAÇÃO DE ACIDENTE DE TRAJETO NOS TERMOS DAS ALÍNEAS 'd' E 'e' INCISO E",oFontXX)
lin += 50
oPrint:Say(lin,150,"PARAGRÁFOS 4º E 5º DO ARTIGO 3º DO REGULAMENTO APROVADO PELO DECRETO Nº 790 DE 24",oFontXX)
lin += 50
oPrint:Say(lin,150,"DE DEZEMBRO DE 1976.",oFontXX)

lin := 450
oPrint:Say(lin,550,"QUESTIONÁRIO DE RESPONSABILIDADE DO EMPREGADOR",oFontXX)

lin := 550
oPrint:Say(lin,150,"I - QUALIFICAÇÃO",oFontXX)
lin += 50
oPrint:Say(lin,150,"EMPREGADOR:",oFontXX)
oPrint:Say(lin,430,ALLTRIM(SM0->M0_NOMECOM),oFontYY)
lin += 50
oPrint:Say(lin,150,"C.G.C. OU MATRÍCULA NO IAPAS:",oFontXX)
oPrint:Say(lin,900,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFontYY)
lin += 50
oPrint:Say(lin,150,"ESTABELECIDA NA:",oFontXX)
oPrint:Say(lin,580,ALLTRIM(SM0->M0_ENDCOB)+" - "+ALLTRIM(SM0->M0_BAIRCOB)+" - "+ALLTRIM(SM0->M0_CIDCOB),oFontYY)
lin += 50
oPrint:Say(lin,150,"ACIDENTADO:",oFontXX)
oPrint:Say(lin,450,ALLTRIM(SRA->RA_NOME),oFontYY)
lin += 50
oPrint:Say(lin,150,"RESIDENTE:",oFontXX)
oPrint:Say(lin,450,ALLTRIM(SRA->RA_ENDEREC),oFontYY)
lin += 50
oPrint:Say(lin,150,"LOCAL DE TRABALHO:",oFontXX)
oPrint:Say(lin,630,ALLTRIM(SM0->M0_ENDCOB),oFontYY)
lin += 100

oPrint:Say(lin,150,"II - DESCRIÇÃO",oFontXX)
lin += 50
oPrint:Say(lin,150,"O ACIDENTE OCORREU NO PERCURSO:",oFontXX)
lin += 50

cMarca := If(cLOCACT=="1"," X ",space(3))
oPrint:Say(lin,150,SPACE(5)+"a) DA RESIDÊNCIA PARA O TRABALHO"+" ("+cMarca+")",oFontXX)
lin += 50
cMarca := If(cLOCACT=="2"," X ",space(3))
oPrint:Say(lin,150,SPACE(5)+"b) DO TRABALHO PARA A RESIDÊNCIA"+" ("+cMarca+")",oFontXX)
lin += 50
cMarca := If(cLOCACT=="3"," X ",space(3))
oPrint:Say(lin,150,SPACE(5)+"c) DE IDA PARA O LOCAL DE REFEIÇÃO EM INTERVALO DE TRABALHO"+" ("+cMarca+")",oFontXX)
lin += 50
cMarca := If(cLOCACT=="4"," X ",space(3))
oPrint:Say(lin,150,SPACE(5)+"d) DE VOLTA DO LOCAL DE REFEIÇÃO EM INTERVALO DE TRABALHO"+" ("+cMarca+")",oFontXX)
lin += 50

oPrint:Say(lin,150,"DATA DA OCORRÊNCIA:",oFontXX)
oPrint:Say(lin,600,Dtoc(TNC->TNC_DTACID),oFontYY)
oPrint:Say(lin,1000,"HORA:",oFontXX)
oPrint:Say(lin,1180,Transform(TNC->TNC_HRACID,"99:99"),oFontYY)
lin += 50

oPrint:Say(lin,150,"HORÁRIO DE SAÍDA DO LOCAL ACIMA ASSINALADO:",oFontXX)
oPrint:Say(lin,1120,Transform(cHORSAI,"99:99"),oFontYY)
lin += 50

oPrint:Say(lin,150,"HORÁRIO DE TRABALHO QUE O SEGURADO CUMPRIU OU DEVERIA TER CUMPRIDO NO DIA",oFontXX)
lin += 50
oPrint:Say(lin,150,"DO ACIDENTE:",oFontXX)
oPrint:Say(lin,500,cHRRDIA,oFontYY)
lin += 50

oPrint:Say(lin,150,"TRAJETO USUAL DO EMPREGADO:",oFontXX)
oPrint:Say(lin,800,Memoline(cTRAJET,40,1),oFontYY)
lin += 50
oPrint:Say(lin,150,Memoline(cTRAJET,40,2),oFontYY)
lin += 50

oPrint:Say(lin,150,"MEIO DE LOCOMOÇÃO UTILIZADO PELO SEGURADO QUANDO DO ACIDENTE:",oFontXX)
oPrint:Say(lin,1550,Alltrim(cMEIO),oFontYY)
lin += 50

oPrint:Say(lin,150,"LOCAL EM QUE OCORREU O ACIDENTE:",oFontXX)
oPrint:Say(lin,920,Alltrim(cLOCACI),oFontYY)
lin += 50

oPrint:Say(lin,150,"DISTÂNCIA APROXIMADA ENTRE O LOCAL DE SAÍDA DO SEGURADO E O ACIDENTE:",oFontXX)
oPrint:Say(lin,1800,Alltrim(Str(cDISTAC,5))+" m",oFontYY)
lin += 50

cSim := If(cMUDANC=="1","X",Space(1))
cNao := If(cMUDANC=="2","X",Space(1))
oPrint:Say(lin,150,"HOUVE ALTERAÇÃO OU MUDANÇA DE TRAJETO?      SIM( "+cSim+" ) NÃO( "+cNao+" )",oFontXX)
lin += 50

oPrint:Say(lin,150,"POR QUÊ?",oFontXX)
lin += 50
oPrint:Say(lin,150,cMOTIVO,oFontYY)

lin += 50
oPrint:Say(lin,150,"A AUTORIDADE POLICIAL TOMOU CONHECIMENTO DA OCORRÊNCIA:",oFontXX)
oPrint:Say(lin,1400,If(TNC->TNC_POLICI=="1","SIM","NAO"),oFontYY)

lin += 50
oPrint:Say(lin,150,"(EM CASO DE RESPOSTA AFIRMATIVA JUNTAR CERTIDÃO DO REGISTRO DA OCORRÊNCIA).",oFontXX)
lin += 50
oPrint:Say(lin,150,"ADMITE O EMPREGADOR O ENQUADRAMENTO DO ACIDENTE NOS DISPOSITIVOS LEGAIS TRANSCRITOS",oFontXX)
lin += 50
oPrint:Say(lin,150,"NO VERSO?",oFontXX)
oPrint:Say(lin,450,If(cADMITE=="1","SIM","NAO"),oFontYY)
lin += 100

oPrint:Say(lin,150,"III - OUTRAS CONSIDERAÇÕES",oFontXX)
lin += 50
oPrint:Say(lin,150,Substr(cCONFIN,1,80),oFontYY)
lin += 150

oPrint:Say(lin,150,"IV - HORÁRIO DE TRABALHO DO SEGURADO",oFontXX)
lin += 50
oPrint:Say(lin,150,cHRRPAD,oFontYY)
lin += 150


oPrint:Say(lin,150,"NOTA: A INEXATIDÃO DAS DECLARAÇÕES CONSTANTES DESTE DOCUMENTO CONSTITUI CRIME",oFontXX)
lin += 50
oPrint:Say(lin,150,"PREVISTO NOS ARTIGOS 171 E 299 DO CÓDIGO PENAL.",oFontXX)
lin += 150

oPrint:Say(lin,1300,"LOCALIDADE:",oFontXX)
oPrint:Say(lin,1570,ALLTRIM(SM0->M0_CIDCOB)+", "+DTOC(Date()),oFontYY)
lin += 300

oPrint:Line(lin-10,1380,lin-10,2150)
oPrint:Say(lin,1400,"ASSINATURA E CARIMBO DO EMPREGADOR",oFontXX)
lin += 50

oPrint:EndPage()
//***************
//***************  Pagina 2
//***************
lin := 150

oPrint:StartPage()
oPrint:Say(lin,300,"REGULAMENTO APROVADO PELO DECRETO Nº 79037 DE 24 DE DEZEMBRO DE 1970",oFontXX)
lin += 100
oPrint:Say(lin,150,"ARTIGO 3º - SÃO TAMBÉM CONSIDERADOS COMO ACIDENTE DE TRABALHO:",oFontXX)
lin += 50
oPrint:Say(lin,250,"II - O ACIDENTE SOFRIDO PELO EMPREGADO AINDA QUE FORA DO LOCAL DE TRABALHO:",oFontXX)
lin += 50
oPrint:Say(lin,250,"d) NO PERCURSO DA RESIDÊNCIA PARA O TRABALHO OU DESTA PARA AQUELA;",oFontXX)
lin += 50
oPrint:Say(lin,250,"e) NO PERCURSO DE IDA OU VOLTA PARA O LOCAL DA REFEIÇÃO OU INTERVALO DE TRABALHO.",oFontXX)
lin += 50
oPrint:Say(lin,250,"4º - O DISPOSTO NO ÍTEM II, LETRAS 'd' E 'e', NÃO SE APLICAM AO ACIDENTE SOFRIDO PELO",oFontXX)
lin += 50
oPrint:Say(lin,150,"SEGURADO QUE POR INTERESSE PESSOAL TIVER INTERROMPIDO OU ALTERADO O PERCURSO.",oFontXX)
lin += 50
oPrint:Say(lin,250,"5º - ENTENDE-SE COMO PERCURSO O TRAJETO USUAL DA RESIDÊNCIA OU DO LOCAL DE REFEIÇÃO",oFontXX)
lin += 50
oPrint:Say(lin,150,"PARA O TRABALHO, OU DESTE PARA AQUELES.",oFontXX)
lin += 150//LIN == 800

oPrint:box(lin,150,2700,2200)
oPrint:line(lin+120,150,lin+120,2200)
oPrint:Say(lin+10,160,"CROQUI DESCRITO DO LOCAL DO ACIDENTE RELACIONADO COM O LOCAL DE TRABALHO-RESIDÊNCIA",oFontXX)
oPrint:Say(lin+60,160,"OU TRABALHO-LOCAL DE REFEIÇÃO OU VICE-VERSA.",oFontXX)

oPrint:EndPage()

RestArea(aArea)
Return .t.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   |QUEST830TXT Autor ³Denis Hyroshi de Souza ³ Data ³ 29/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Imprime o questinario de responsabilidade do empregador     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function QUEST830TXT()
Local aArea := TNC->(GetArea())
Local cLOCACT,cHORSAI,cTRAJET,cMEIO,cLOCACI,cDISTAC,cMUDANC,cMOTIVO,cADMITE,cCONFIN,cHRRPAD,cHRRDIA
store space(1) to cLOCACT,cHORSAI,cTRAJET,cMEIO,cLOCACI,cMUDANC,cMOTIVO,cADMITE,cCONFIN,cHRRPAD,cHRRDIA
store 0 to cDISTAC

Dbselectarea("TNC")
If FieldPos("TNC_LOCACT") > 0
  cLOCACT := TNC->TNC_LOCACT
Endif
If FieldPos("TNC_HORSAI") > 0
  cHORSAI := TNC->TNC_HORSAI
Endif
If FieldPos("TNC_TRAJET") > 0
  cTRAJET := TNC->TNC_TRAJET
Endif
If FieldPos("TNC_MEIO") > 0
  cMEIO   := TNC->TNC_MEIO
Endif
If FieldPos("TNC_LOCACI") > 0
  cLOCACI := TNC->TNC_LOCACI
Endif
If FieldPos("TNC_DISTAC") > 0
  cDISTAC := TNC->TNC_DISTAC
Endif
If FieldPos("TNC_MUDANC") > 0
  cMUDANC := TNC->TNC_MUDANC
Endif
If FieldPos("TNC_MOTIVO") > 0
  cMOTIVO := TNC->TNC_MOTIVO
Endif
If FieldPos("TNC_ADMITE") > 0
  cADMITE := TNC->TNC_ADMITE
Endif
If FieldPos("TNC_CONFIN") > 0
  cCONFIN := TNC->TNC_CONFIN
Endif
If FieldPos("TNC_HRRPAD") > 0
  cHRRPAD := TNC->TNC_HRRPAD
Endif
If FieldPos("TNC_HRRDIA") > 0
  cHRRDIA := TNC->TNC_HRRDIA
Endif


//***************
//***************  Pagina 1
//***************
li := 80
Somalinha()
@Li,035 PSay "RSPS - COORDENAÇÃO REGIONAL DE ACIDENTES DE TRABALHO"
Somalinha()
       //          1         2         3         4         5         6         7         8         9         0         1         2         3
         //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@Li,005 PSay "QUALIFICAÇÃO DE ACIDENTE DE TRAJETO NOS TERMOS DAS ALÍNEAS 'd' E 'e' INCISO E PARAGRÁFOS 4º E 5º DO ARTIGO 3º DO"
Somalinha()
@Li,005 PSay "REGULAMENTO APROVADO PELO DECRETO Nº 790 DE 24 DE DEZEMBRO DE 1976."
Somalinha()
Somalinha()
@Li,040 PSay "QUESTIONÁRIO DE RESPONSABILIDADE DO EMPREGADOR"
Somalinha()
Somalinha()
@Li,005 PSay "I - QUALIFICAÇÃO"
Somalinha()
@Li,005 PSay "Empregador:"
@Li,018 PSay ALLTRIM(SM0->M0_NOMECOM)
Somalinha()
@Li,005 PSay "C.G.C. ou Matricula no IAPAS:"
@Li,036 PSay SM0->M0_CGC Picture "@R 99.999.999/9999-99"
Somalinha()
@Li,005 PSay "Estabelecias na:"
@Li,023 PSay ALLTRIM(SM0->M0_ENDCOB)+" - "+ALLTRIM(SM0->M0_BAIRCOB)+" - "+ALLTRIM(SM0->M0_CIDCOB)
Somalinha()
@Li,005 PSay "Acidentado:"
@Li,018 PSay ALLTRIM(SRA->RA_NOME)
Somalinha()
@Li,005 PSay "Residente:"
@Li,017 PSay ALLTRIM(SRA->RA_ENDEREC)
Somalinha()
@Li,005 PSay "Local de Trabalho:"
@Li,025 PSay ALLTRIM(SM0->M0_ENDCOB)
Somalinha()
Somalinha()
@Li,005 PSay "II - DESCRIÇÃO"
Somalinha()
@Li,005 PSay "O Acidente ocorreu no percurso:"
Somalinha()

cMarca := If(cLOCACT=="1"," X ",space(3))
@Li,010 PSay "a) Da Residencia para o Trabalho"+" ("+cMarca+")"
Somalinha()
cMarca := If(cLOCACT=="2"," X ",space(3))
@Li,010 PSay "b) Do Trabalho para a Residencia"+" ("+cMarca+")"
Somalinha()
cMarca := If(cLOCACT=="3"," X ",space(3))
@Li,010 PSay "c) De ida para o local de refeicao em intervalo de trabalho"+" ("+cMarca+")"
Somalinha()
cMarca := If(cLOCACT=="4"," X ",space(3))
@Li,010 PSay "d) De volta do local de refeicao em intervalo de trabalho"+" ("+cMarca+")"
Somalinha()

@Li,005 PSay "Data da Ocorrencia:"
@Li,026 PSay TNC->TNC_DTACID Picture "99/99/99"
@Li,040 PSay "Hora:"
@Li,047 PSay TNC->TNC_HRACID Picture "99:99"
Somalinha()

@Li,005 PSay "Horario de Saida do Local acima assinalado:"
@Li,050 PSay cHORSAI Picture "99:99"
Somalinha()
@Li,005 PSay "Horario de Trabalho que o segurado cumpriu ou deveria ter cumprido no dia do acidente:"
@Li,094 PSay cHRRDIA
Somalinha()
@Li,005 PSay "Trajeto Usual do Empregado:"
@Li,033 PSay Substr(cTRAJET,1,80)
Somalinha()
@Li,005 PSay "Meio de Locomocao utilizado pelo segurado quando do acidente:"+Space(2)+Alltrim(cMEIO)
Somalinha()

@Li,005 PSay "Local em que ocorreu o acidente:"
@Li,038 PSay Alltrim(cLOCACI)
Somalinha()
@Li,005 PSay "Distancia aproximada entre o local de saida do segurado e o acidente:  "+Alltrim(Str(cDISTAC,5))+" m"
Somalinha()

cSim := If(cMUDANC=="1","X",Space(1))
cNao := If(cMUDANC=="2","X",Space(1))
@Li,005 PSay "Houve alteracao ou mudanca de trajeto?  SIM( "+cSim+" ) NAO( "+cNao+" )"
Somalinha()
@Li,005 PSay "Por que?"
Somalinha()
@Li,005 PSay cMOTIVO
Somalinha()
@Li,005 PSay "A Autoridade policial tomou conhecimento da ocorrencia:"
@Li,062 PSay If(TNC->TNC_POLICI=="1","SIM","NAO")
Somalinha()
@Li,005 PSay "(Em caso de resposta afirmativa juntar Certidao do Registro da Ocorrencia)."
Somalinha()
@Li,005 PSay "Admite o empregador o enquadramento do acidente nos dispositivos legais transcritos no verso?"
@Li,100 PSay If(cADMITE=="1","SIM","NAO")
Somalinha()
Somalinha()

@Li,005 PSay "III - OUTRAS CONSIDERAÇÕES"
Somalinha()
@Li,005 PSay cCONFIN
Somalinha()
Somalinha()
@Li,005 PSay "IV - HORÁRIO DE TRABALHO DO SEGURADO"
Somalinha()
@Li,005 PSay cHRRPAD
Somalinha()
Somalinha()
       //          1         2         3         4         5         6         7         8         9         0         1         2         3
         //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@Li,005 PSay "NOTA: A INEXATIDÃO DAS DECLARAÇÕES CONSTANTES DESTE DOCUMENTO CONSTITUI CRIME PREVISTO NOS ARTIGOS 171 E 299"
Somalinha()
@Li,005 PSay "DO CÓDIGO PENAL."
Somalinha()
Somalinha()

@Li,068 PSay "Localidade:"
@Li,081 PSay ALLTRIM(SM0->M0_CIDCOB)+", "+DTOC(Date())
Somalinha()
Somalinha()
Somalinha()
Somalinha()

@Li,074 PSay Replicate("_",36)
Somalinha()
@Li,075 PSay "Assinatura e carimbo do empregador"
Somalinha()

li := 80
//***************
//***************  Pagina 2
//***************
Somalinha()
Somalinha()
@Li,025 PSay "REGULAMENTO APROVADO PELO DECRETO Nº 79037 DE 24 DE DEZEMBRO DE 1970"
Somalinha()
Somalinha()
@Li,005 PSay "ARTIGO 3º - SÃO TAMBÉM CONSIDERADOS COMO ACIDENTE DE TRABALHO:"
Somalinha()
@Li,010 PSay "II - O ACIDENTE SOFRIDO PELO EMPREGADO AINDA QUE FORA DO LOCAL DE TRABALHO:"
Somalinha()
@Li,010 PSay "d) NO PERCURSO DA RESIDÊNCIA PARA O TRABALHO OU DESTA PARA AQUELA;"
Somalinha()
@Li,010 PSay "e) NO PERCURSO DE IDA OU VOLTA PARA O LOCAL DA REFEIÇÃO OU INTERVALO DE TRABALHO."
Somalinha()
@Li,010 PSay "4º - O DISPOSTO NO ÍTEM II, LETRAS 'd' E 'e', NÃO SE APLICAM AO ACIDENTE SOFRIDO PELO SEGURADO QUE POR"
Somalinha()
@Li,005 PSay "INTERESSE PESSOAL TIVER INTERROMPIDO OU ALTERADO O PERCURSO."
Somalinha()
@Li,010 PSay "5º - ENTENDE-SE COMO PERCURSO O TRAJETO USUAL DA RESIDÊNCIA OU DO LOCAL DE REFEIÇÃO PARA O TRABALHO, OU DESTE"
Somalinha()
@Li,005 PSay "PARA AQUELES."
Somalinha()
Somalinha()
Somalinha()
@Li,006 PSay Replicate("_",114)
Somalinha()
@Li,005 PSay "|"
@Li,006 PSay "CROQUI DESCRITO DO LOCAL DO ACIDENTE RELACIONADO COM O LOCAL DE TRABALHO-RESIDÊNCIA OU TRABALHO-LOCAL DE REFEIÇÃO"
@Li,120 PSay "|"
Somalinha()
@Li,005 PSay "|"
@Li,006 PSay "OU VICE-VERSA."
@Li,120 PSay "|"
Somalinha()
@Li,005 PSay "|"
@Li,006 PSay Replicate("_",114)
@Li,120 PSay "|"
For xx := 1 to 35
  Somalinha()
  @Li,005 PSay "|"
  @Li,120 PSay "|"
Next xx
Somalinha()
@Li,005 PSay "|"
@Li,006 PSay Replicate("_",114)
@Li,120 PSay "|"

RestArea(aArea)
Return .t.

