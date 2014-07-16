/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN024  บAutor  ณMarcos R. Roquitski บ Data ณ  23/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime demonstrativo e resgate de contratos/emprestimos.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhFin024()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,nTotUsd,nTotRea,nTotSud,nTotSre,nTotVar")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,aMatriz,nPos,nSaldoB2,x,nFaltas,nConsumo")
SetPrvt("nVlResga, nVlMoeda, nSaldo1, nCorre1, nCorre2, nVariac,cFilterUser")

cString   := "SEH"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir, ")
cDesc2    := OemToAnsi("Demonstrativo de Resgate")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN024"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "DEMONSTRATIVO DE RESGATE"
Cabec1    := " Contrato Instituicao            Dt.Empr.  Dt.Vecnto  T.Cambio  %Desagio              USD                  R$             SLD USD              SLD R$            Variacao  Fatura"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHFIN024"
_cPerg    := ""
nTotUsd   := 0
nTotRea   := 0
nTotSud   := 0 
nTotSre   := 0
nTotVar   := 0
                   
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver     := ReadDriver()
cCompac     := aDriver[1]
cNormal     := aDriver[2] 
cFilterUser := aReturn[7]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

Return


Static Function Gerando()
	cQuery := "SELECT EH_NUMERO,EH_NBANCO,EH_DATA,EH_DATARES,EH_TAXCAM,EH_TAXA,"
	cQuery := cQuery + "EH_VALOR,EH_VLCRUZ,EH_MOEDA,EH_FATURA,EH_ULTAPR "
	cQuery := cQuery + "FROM SEHNH0 "
	cQuery := cQuery + "WHERE D_E_L_E_T_ <> '*' " 	   
	cQuery := cQuery + "AND EH_MOEDA > 1 " 	   
	cQuery := cQuery + " ORDER BY EH_NUMERO ASC" 

	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","EH_DATA","D")     // Muda a data de string para date    
	TcSetField("TMP","EH_DATARES","D")
	TcSetField("TMP","EH_ULTAPR","D")
	
Return                                   


Static Function RptDetail()

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
   Endif

   If !Empty(cFilterUser).and.!(&cFilterUser)
      DbSkip()
      Loop
   Endif

   @ Prow() + 1, 001 Psay TMP->EH_NUMERO
   @ Prow()    , 010 Psay TMP->EH_NBANCO
   @ Prow()    , 033 Psay TMP->EH_DATA    Picture "99/99/9999"
   @ Prow()    , 044 Psay TMP->EH_DATARES Picture "99/99/9999"
   @ Prow()    , 055 Psay TMP->EH_TAXCAM  Picture "@E 999.99999"
   @ Prow()    , 066 Psay TMP->EH_TAXA    Picture "@E 999.99"
   
   nVlMoeda := 0
   nVlResga := 0
   nSaldo1  := 0
   nCorre1  := 0
   nCorre2  := 0
   nVariac  := 0
   
   If TMP->EH_MOEDA >= 2
		@ Prow()    , 075 Psay TMP->EH_VALOR   Picture "@E 999,999,999.99"
	   nVlMoeda := TMP->EH_VALOR
	Endif		
	@ Prow()    , 095 Psay TMP->EH_VALOR*TMP->EH_TAXCAM  Picture "@E 999,999,999.99"
                                                      
   DbSelectArea("SEI")
   SEI->(DbSetOrder(1))
   SEI->(DbSeek(xFilial("SEI")+"EMP"+TMP->EH_NUMERO) )
   While !Eof() .And. (SEI->EI_NUMERO == TMP->EH_NUMERO)
   	If SEI->EI_TIPODOC == "BL"
			nVlResga := nVlResga + SEI->EI_VLMOED2
		Endif			
		SEI->(DbSkip())
   Enddo
	@ Prow()    , 115 Psay (nVlMoeda - nVlResga)   Picture "@E 999,999,999.99"

	If nVlResga > 0
	   nSaldo1 := nVlMoeda - nVlResga
	   nCorre1 := nSaldo1*RecMoeda(dDataBase,TMP->EH_MOEDA)
	   nCorre2 := nSaldo1*TMP->EH_TAXCAM
	   nVariac := nCorre1 - nCorre2 
	Else
	   nSaldo1 := nVlMoeda - nVlResga
	   nCorre1 := nSaldo1*RecMoeda(dDataBase,TMP->EH_MOEDA)
	   nCorre2 := nSaldo1*TMP->EH_TAXCAM
	   nVariac := nCorre1 - nCorre2 
	Endif


	@ Prow()    , 135 Psay nCorre1 					  Picture "@E 999,999,999.99"
	@ Prow()    , 155 Psay nVariac                 Picture "@E 999,999,999.99"
	@ Prow()    , 171 Psay TMP->EH_FATURA          Picture "@!"

	nTotUsd   := nTotUsd + TMP->EH_VALOR
	nTotRea   := nTotRea + TMP->EH_VALOR*TMP->EH_TAXCAM
	nTotSud   := nTotSud + (nVlMoeda - nVlResga)
	nTotSre   := nTotSre + nCorre1
	nTotVar   := nTotVar + nVariac

	TMP->(DbSkip())
Enddo      
@ Prow()+003, 001 Psay "Total Geral ....................................................."
@ Prow()    , 075 Psay nTotUsd   Picture "@E 999,999,999.99"
@ Prow()    , 095 Psay nTotRea   Picture "@E 999,999,999.99"
@ Prow()    , 115 Psay nTotSud   Picture "@E 999,999,999.99"
@ Prow()    , 135 Psay nTotSre   Picture "@E 999,999,999.99"
@ Prow()    , 155 Psay nTotVar   Picture "@E 999,999,999.99"
@ Prow()+001, 001 Psay ""
     
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return(nil)
