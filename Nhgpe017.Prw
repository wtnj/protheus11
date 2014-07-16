/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE017  ºAutor  ³Microsiga           º Data ³  10/31/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "Topconn.ch"

User Function Nhgpe017()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO,CQUERY")
SetPrvt("NPAG,NLIN,NOMEPROG,CPERG,NROS,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,NREG,_CCODIGO,_CCONTAC,_CCONTAD")
SetPrvt("_VCONTAC,_VCONTAD,_NTOTDEB,_NTOTCRE,_NCONDEB,_NCONCRE")
SetPrvt("_PRIVEZ,_CCUSDEB,_CCUSCRE,CQUERY")

/*
Maner Consultoria - Data 28/08/2001
Contabilizacao
*/

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1   := "";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "M"
limite   := 132
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Lancamento Padrao X Resumo da Folha de Pagamento "
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
nPag     := 1
nLin     := 1
nomeprog := "nhgpe023"
cPerg    := ""
nRos     := SM0->M0_CGC
aDriver  := ReadDriver()
cCompac  := aDriver[1]
cNormal  := aDriver[2]

//Pergunte("RHGP19",.F.)
wnrel := "nhgpe023"
wnRel := SetPrint("SI2",NomeProg,,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif
//         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                  1         2         3         4         5         6         7         8         9        10        11        12        13
cabec1 := "Verba                    Conta Debito         CCusto Deb        Valor Deb. Conta Credito        CCusto Cre        Valor Cre." 
cabec2 := "."
//cabec3 := "123 12345678901234567890 12345678901234567890 123456789  12345678901234567 12345678901234567890 123456789  12345678901234567." 

Processa( {|| fGeraTmp() },"Gerando Dados para a Impressao")
RptStatus({|| ImpTemp()})

DbSelectArea("TEMPSRV")
DbCloseArea()


Return

Static Function fGeraTmp()
   cQuery := "SELECT * FROM SRVNH0 "
   cQuery := cQuery + "WHERE D_E_L_E_T_ <> '*' "
   cQuery := cQuery + "AND Substring(RV_LCTOP,1,1) > '   ' "
   cQuery := cQuery + "ORDER BY RV_LCTOP ASC"
	TCQUERY cQuery NEW ALIAS "TEMPSRV"
Return


Static Function ImpTemp()

DbSelectArea("TEMPSRV")
nREG := TEMPSRV->(Reccount())
TEMPSRV->(DbgoTop())
Cabecalho()
_cCodigo := ""
_cContaC := ""
_cContaD := ""
_vContaC := 0.00
_vContaD := 0.00
_nTotDeb := 0.00
_nTotCre := 0.00
_nConDeb := 0.00
_nConCre := 0.00
_privez  := 0
TEMPSRV->(dbGoTop())
While TEMPSRV->(!Eof())
   dbSelectArea("SRZ")
   dbSetOrder(2)
   SRZ->(DbSeek(xFilial()+TEMPSRV->RV_COD,.T.))
   While SRZ->(! Eof())  .AND. SRZ->RZ_PD == TEMPSRV->RV_COD
      If SUBSTR(SRZ->RZ_CC,1,1) >= "1" .and. SUBSTR(SRZ->RZ_CC,1,1) <= "9" .and. SRZ->RZ_VAL > 0.00
         If nLin >= 64
            nPag := nPag + 1
            Cabecalho()
         Endif
         If TEMPSRV->RV_LCTOP <> _cCodigo
            If _privez <> 0
               nLin := nLin + 2
               @ nLin,00 PSAY "Total Lancamento--> "
               @ nLin  ,58 PSAY _nConDeb Picture "@E 99,999,999,999.99"
               @ nLin  ,108 PSAY _nConCre Picture "@E 99,999,999,999.99" 
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
            nLin := nLin + 1
            @ nLin  ,01 PSAY "Lancamento Padrao: "
            @ nLin  ,22 PSAY TEMPSRV->RV_LCTOP
            dbSelectArea("SI5")
            dbSetOrder(1)
            SI5->(DbSeek(xFilial()+TEMPSRV->RV_LCTOP,.T.))
            iF SI5->(! Eof())  .AND. SI5->I5_CODIGO == TEMPSRV->RV_LCTOP
               @ nLin  ,26 PSAY SI5->I5_DESCRIC
            Endif   
            _cCodigo := TEMPSRV->RV_LCTOP
         Endif      
         _cContaC := ""
         _cContaD := ""
         _vContaC := 0.00
         _vContaD := 0.00
         _cCusDeb := " "
         _cCusCre := " "
         dbSelectArea("SI5")
         dbSetOrder(1)
         SI5->(DbSeek(xFilial()+TEMPSRV->RV_LCTOP,.T.))
         iF SI5->(! Eof())  .AND. SI5->I5_CODIGO == TEMPSRV->RV_LCTOP
            If SI5->I5_DC == "D" .OR. SI5->I5_DC == "X"
               _cContaD := substr(SI5->I5_DEBITO,1,20)
               _vContaD := SRZ->RZ_VAL
               _cCusDeb := SRZ->RZ_CC
            Endif   
            If SI5->I5_DC == "C" .OR. SI5->I5_DC == "X"
               _cContaC := substr(SI5->I5_CREDITO,1,20)
               _vContaC := SRZ->RZ_VAL
               _cCusCre := SRZ->RZ_CC
            Endif   
         Endif   
         nLin := nLin + 1
         @ nLin,  01 PSAY TEMPSRV->RV_COD
         @ nLin  ,05 PSAY TEMPSRV->RV_DESC
         @ nLin  ,26 PSAY _cContaD
         @ nLin  ,47 PSAY _cCusDeb
         @ nLin  ,58 PSAY _vContaD Picture "@E 99,999,999,999.99"
         @ nLin  ,76 PSAY _cContaC
         @ nLin  ,97 PSAY _cCusCre
         @ nLin  ,108 PSAY _vContaC Picture "@E 99,999,999,999.99"
         _nConDeb := _nConDeb + _vContaD
         _nConCre := _nConCre + _vContaC
      Endif
      SRZ->(DBSKIP())
   End do           
   TEMPSRV->(DbSkip())
Enddo
nLin := nLin + 2
@ nLin,00 PSAY "Total Lancamento--> "
@ nLin  ,58 PSAY _nConDeb Picture "@E 99,999,999,999.99"
@ nLin  ,108 PSAY _nConCre Picture "@E 99,999,999,999.99" 
nLin := nLin + 2
@ nLin,00 PSAY " "
_nTotDeb := _nTotDeb + _nConDeb
_nTotCre := _nTotCre + _nConCre
nLin := nLin + 1
@ nLin  ,00 PSAY "Total Geral ------> "
@ nLin  ,58 PSAY _nTotDeb Picture "@E 99,999,999,999.99"
@ nLin  ,108 PSAY _nTotCre Picture "@E 99,999,999,999.99"
nLin := nLin + 2
@ nLin,00 PSAY " "

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel)
Endif
MS_FLUSH()

Return


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

