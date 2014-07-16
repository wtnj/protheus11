#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#include "Topconn.ch" 
User Function nhgpe016()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NPAG,NLIN,NOMEPROG,CPERG,NROS,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,_CPERIODO,CQUERY,NREG,_CCONTAD")
SetPrvt("_CCONTAC,_NTOTDEB,_NTOTCRE,_NCONDEB,_NCONCRE,_PRIVEZ")
SetPrvt("_NDEBITO,_NCREDITO,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 29/08/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
Maner Consultoria - Data 28/08/2001
Contabilizacao
*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""

cabec1:="";cabec2:="";cabec3:="";wnrel:=""

nOrdem:=0
tamanho:="M"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relatorio de Contabilizacao"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SI2"
nTipo    := 0
nPag     := 1
nLin     := 1
nomeprog := "NHGPE016"
cPerg    := ""
nRos:=SM0->M0_CGC
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

//Pergunte("RHGP19",.F.)
wnrel := "NHGPE016"
wnRel := SetPrint("SI2",NomeProg,,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif
//         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                  1         2         3         4         5         6         7         8         9        10        11        12        13
cabec1 := "Conta Debito         C Custo Deb       Valor Deb. Conta Credito         C Custo Cre       Valor Cre. Historico" 
cabec2 := "."
cabec3 := "." 
_cPeriodo := "20" + substr(dtoc(ddatabase),7,2) + substr(dtoc(ddatabase),4,2)

rptStatus({||Gerando()},"Imprimindo...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> rptStatus({||Execute(Gerando)},"Imprimindo...")
DbCloseArea("TEMPSI2")
Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Gerando
Static Function Gerando()
DbSelectArea("SI2")
dbSetOrder(2)

cQuery := "SELECT * FROM SI2NH0"
cQuery := cQuery + " WHERE I2_LOTE = '8890' AND I2_PERIODO = '" + _CPERIODO + "' AND "
cQuery := cQuery + " I2_DC <>'-' AND D_E_L_E_T_ <> '*' "
cQuery := cQuery + " ORDER BY I2_DEBITO,I2_CREDITO"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TEMPSI2"
DbSelectArea("TEMPSI2")
nREG := TEMPSI2->(Reccount())
//SetRegua(nREG)
TEMPSI2->(DbgoTop())
Cabecalho()
_cContaD := ""
_cContaC := ""
_nTotDeb := 0.00
_nTotCre := 0.00
_nConDeb := 0.00
_nConCre := 0.00
_privez  := 0
TEMPSI2->(dbGoTop())
While TEMPSI2->(!Eof())
MsgBox ("2", "lOOP","INFO")
   //IncRegua()
   If nLin >= 64
//     Eject
      nPag := nPag + 1
      Cabecalho()
   Endif
   _nDebito := 0.00
   _nCredito := 0.00
   If TEMPSI2->I2_DEBITO <> _cContaD .or. TEMPSI2->I2_CREDITO <> _cContaC 
      If _privez <> 0
         nLin := nLin + 2
         @ nLin,00 PSAY "Total Conta ------> "
         @ nLin  ,33 PSAY _nConDeb Picture "@E 99,999,999,999.99"
         @ nLin  ,84 PSAY _nConCre Picture "@E 99,999,999,999.99" 
         nLin := nLin + 2
         @ nLin,00 PSAY " "
         _nTotDeb := _nTotDeb + _nConDeb
         _nTotCre := _nTotCre + _nConCre
      Endif
      If _privez == 0
         _privez := 1
      Endif
      _nConDeb := 0.00
      _nConCre := 0.00
      _cContaD := TEMPSI2->I2_DEBITO
      _cContaC := TEMPSI2->I2_Credito
   Endif
   If substr(TEMPSI2->I2_DEBITO,1,1) >= "1"
      _nDebito := TEMPSI2->I2_VALOR
      _nConDeb := _nConDeb + _nDebito
   Endif
   If substr(TEMPSI2->I2_CREDITO,1,1) >= "1"
      _nCredito := TEMPSI2->I2_VALOR
      _nConCre := _nConCre + _nCredito
   Endif            
   nLin := nLin + 1
   @ nLin,01 PSAY TEMPSI2->I2_DEBITO
   @ nLin  ,22 PSAY TEMPSI2->I2_CCD
   @ nLin  ,33 PSAY _nDebito Picture "@E 99,999,999,999.99"
   @ nLin  ,51 PSAY TEMPSI2->I2_CREDITO
   @ nLin  ,73 PSAY TEMPSI2->I2_CCC
   @ nLin  ,84 PSAY _nCredito Picture "@E 99,999,999,999.99"
   @ nLin  ,102 PSAY SUBSTR(TEMPSI2->I2_HIST,1,30)
   TEMPSI2->(DbSkip())
Enddo
nLin := nLin + 2
@ nLin,00 PSAY "Total Conta ------> "
@ nLin  ,33 PSAY _nConDeb Picture "@E 99,999,999,999.99"
@ nLin  ,84 PSAY _nConCre Picture "@E 99,999,999,999.99"     
nLin := nLin + 2
@ nLin,00 PSAY " "
_nTotDeb := _nTotDeb + _nConDeb
_nTotCre := _nTotCre + _nConCre
nLin := nLin + 1
@ nLin,00 PSAY "Total Geral ------> "
@ nLin  ,33 PSAY _nTotDeb Picture "@E 99,999,999,999.99"
@ nLin  ,84 PSAY _nTotCre Picture "@E 99,999,999,999.99"
nLin := nLin + 2
@ nLin,00 PSAY " "
Eject

RestScreen(3,0,24,79,cSavScr1)
//Close TEMPSI2
//Delete File TEMP.DBF
//Delete File TEMP.CDX
RestScreen(3,0,24,79,cSavScr1)
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
// Substituido pelo assistente de conversao do AP5 IDE em 29/08/01 ==> Function Cabecalho
// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Cabecalho
Static Function Cabecalho()
nLin := 1
@ nLin,00 Psay &cCompac+Repli("*",132)   
nLin := nLin + 1
@ nLin,00 Psay "*"+SM0->M0_NOMECOM
@ nLin,112 Psay "Folha : "                                                                                                    
@ nLin,124 Psay StrZero(nPag,5,0)+"  *"
nLin := nLin + 1
@ nLin,00 Psay "*S.I.G.A. / "+nomeprog
@ nLin,20 Psay PadC(titulo,82)
@ nLin,112 Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
nLin := nLin + 1
@ nLin,00 Psay "*Hora...: "+Time()
@ nLin,112 Psay "Emissao: "+Dtoc(Date())+"  *"
nLin := nLin + 1
@ nLin,00 Psay Repli("*",132)
nLin := nLin + 1
@ nLin,00 Psay " "
nLin := nLin + 1
@ nLin,00 Psay cabec1 
nLin := nLin + 1
@ nLin,00 Psay cabec2 
Return

