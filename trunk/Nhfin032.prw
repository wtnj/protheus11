/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NhFin032  ºAutor  ³Marcos R. Roquitski º Data ³  15/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Recebimento por Naturezas.                      ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhFin032()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nTotVlr,nTotFat,nVlItem,nQtItem")

cString   := "SE1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir, ")
cDesc2    := OemToAnsi("recebimentos totalizando por Naturezas/Cliente e Bancos.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN032"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "RECEBIMENTO"
Cabec1    := " Natureza                                    Cliente/Fornecedor/Banco                                        Total"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHFIN032"
_cPerg    := "FIN032"
nTotVlr   := 0
nTotFat   := 0
aMes      := {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
AjustaSx1()

If !Pergunte('FIN032',.T.)
   Return(nil)
Endif
titulo    := "RECEBIMENTO - "+aMes[(Month(mv_par01))]+"/"+ALLTRIM(STR(INT(YEAR(mv_par01))))
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

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Processa( {|| GeraRec()   },"Gerando Dados para a Impressao")
Processa( {|| GeraBan()   },"Gerando Dados para a Impressao")
Processa( {|| GeraPag()   },"Gerando Dados para a Impressao")
Processa( {|| GeraEmp()   },"Gerando Dados para a Impressao")
Processa( {|| GeraOth()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

Return

Static Function GeraRec() // Recebimento
	cQuery := "SELECT E5.E5_NATUREZ, E5.E5_CLIFOR, E5.E5_RECPAG, SUM(E5_VALOR) AS 'TOTCLI' FROM " + RetSqlName( 'SE5') + " E5 " 
    cQuery += "WHERE E5.E5_DATA BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' AND E5.D_E_L_E_T_ = ' ' "
    cQuery += "AND E5.E5_FILIAL = '" + xFilial("SE5")+ "' "
    cQuery += "AND SUBSTRING(E5.E5_NATUREZ,1,3) = '101' "
    cQuery += "AND E5.E5_TIPODOC IN('VL','RA','ES') "
    cQuery += "AND E5.E5_VALOR  > 0 "
	cQuery += "GROUP BY E5.E5_NATUREZ,E5.E5_CLIFOR,E5.E5_RECPAG "
	cQuery += "ORDER BY E5.E5_NATUREZ,E5.E5_CLIFOR,E5.E5_RECPAG "
	TCQUERY cQuery NEW ALIAS "TMP1"
Return


Static Function GeraBan() // Emprestimos Financeiros
	cQuery := "SELECT E5.E5_NATUREZ, E5.E5_BANCO, E5.E5_FILIAL,E5.E5_TIPODOC,E5.E5_RECPAG, SUM(E5_VALOR) AS 'TOTBAN' FROM " + RetSqlName( 'SE5') + " E5 " 
    cQuery += "WHERE E5.E5_DATA BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' AND E5.D_E_L_E_T_ = ' ' "
    cQuery += "AND E5.E5_FILIAL = '" + xFilial("SE5")+ "' "
    cQuery += "AND SUBSTRING(E5.E5_NATUREZ,1,3) = '102' "
    cQuery += "AND E5.E5_TIPODOC NOT IN('BA','MT','CM','DC','JR','CP','M2','C2','D2','J2','V2') "
    cQuery += "AND E5.E5_RECPAG IN('R','P') "
    cQuery += "AND E5.E5_VALOR  > 0 "
	cQuery += "GROUP BY E5.E5_NATUREZ,E5.E5_BANCO,E5.E5_FILIAL,E5.E5_TIPODOC,E5.E5_RECPAG "
	cQuery += "ORDER BY E5.E5_NATUREZ,E5.E5_BANCO,E5.E5_FILIAL,E5.E5_TIPODOC,E5.E5_RECPAG "
	TCQUERY cQuery NEW ALIAS "TMP2"
Return

Static Function GeraPag() // Recompra de Duplictas
	cQuery := "SELECT E5.E5_NATUREZ, E5.E5_BANCO, E5.E5_FILIAL,E5.E5_TIPODOC,E5.E5_RECPAG, SUM(E5_VALOR) AS 'TOTBAN' FROM " + RetSqlName( 'SE5') + " E5 " 
    cQuery += "WHERE E5.E5_DATA BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' AND E5.D_E_L_E_T_ = ' ' "
    cQuery += "AND E5.E5_FILIAL = '" + xFilial("SE5")+ "' "
    cQuery += "AND E5.E5_NATUREZ = '207015' "
    cQuery += "AND E5.E5_TIPODOC NOT IN('BA','MT','CM','DC','JR','CP','M2','C2','D2','J2','V2') "
    cQuery += "AND E5.E5_RECPAG IN('R','P') "
    cQuery += "AND E5.E5_VALOR  > 0 "
	cQuery += "GROUP BY E5.E5_NATUREZ,E5.E5_BANCO,E5.E5_FILIAL,E5.E5_TIPODOC,E5.E5_RECPAG "
	cQuery += "ORDER BY E5.E5_NATUREZ,E5.E5_BANCO,E5.E5_FILIAL,E5.E5_TIPODOC,E5.E5_RECPAG "
	TCQUERY cQuery NEW ALIAS "TMP3"
Return

Static Function GeraEmp() // Pagamentos e Emprestimos
	cQuery := "SELECT E5_CLIFOR, SUM(E5_VALOR) AS 'TOTEMP' FROM " + RetSqlName( 'SE5') + " E5 "
    cQuery += "WHERE E5.E5_DATA BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' AND E5.D_E_L_E_T_ = ' ' "
    cQuery += "AND E5.E5_FILIAL = '" + xFilial("SE5")+ "' "
    cQuery += "AND E5.E5_TIPO IN('PA','NDF') "
	cQuery += "AND E5.E5_TIPODOC NOT IN('BA','MT','CM','DC','JR','CP','M2','C2','D2','J2','V2') "
    cQuery += "AND E5.E5_RECPAG  = 'R' "
    cQuery += "AND E5.E5_VALOR  > 0 "
	cQuery += "GROUP BY E5.E5_CLIFOR "
	cQuery += "ORDER BY E5.E5_CLIFOR "
	TCQUERY cQuery NEW ALIAS "TMP4"
Return


Static Function GeraOth() // Recebimento Diversos
	cQuery := "SELECT E5.E5_NATUREZ, SUM(E5_VALOR) AS 'TOTOTH' FROM " + RetSqlName( 'SE5') + " E5 " 
    cQuery += "WHERE E5.E5_DATA BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' AND E5.D_E_L_E_T_ = ' ' "
    cQuery += "AND E5.E5_FILIAL = '" + xFilial("SE5")+ "' "
    cQuery += "AND E5.E5_NATUREZ = '101999' "
    cQuery += "AND E5.E5_TIPODOC IN(' ') "
    cQuery += "AND E5.E5_MOEDA IN('M1') "
    cQuery += "AND E5.E5_VALOR  > 0 "
	cQuery += "GROUP BY E5.E5_NATUREZ "
	cQuery += "ORDER BY E5.E5_NATUREZ "
	TCQUERY cQuery NEW ALIAS "TMP5"
Return

                                                         		
Static Function RptDetail()
Local nTotCli  := 0
Local nSubCli  := 0
Local nTotBan  := 0
Local nTotPag  := 0
Local nSubPag  := 0
Local nTotEmp  := 0
Local nSubEmp  := 0
Local nValor   := 0
Local nSubBan  := 0
Local nTotOth  := 0
Local nSubOth  := 0
Local nGerCli  := 0
Local cNaturez := Space(10)
Local cClifor  := Space(06)
Local lRet := .T.

TMP1->(DbGoTop())
ProcRegua(TMP1->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP1->(!Eof())
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	
	// Acumular por Natureza e Cliente
	nValor     := 0
	cNaturez   := TMP1->E5_NATUREZ
	cClifor    := TMP1->E5_CLIFOR
	While cNaturez + cCliFor == TMP1->E5_NATUREZ + TMP1->E5_CLIFOR
		If     TMP1->E5_RECPAG = 'R'
			nValor += TMP1->TOTCLI
		Elseif TMP1->E5_RECPAG = 'P'
			nValor -= TMP1->TOTCLI
		Endif
		nSubCli += nValor
	 	TMP1->(Dbskip())
	Enddo

	If nSubCli > 0
		@ Prow()+1,001 Psay cNaturez
		@ Prow()  ,013 Psay NomeNat(cNaturez)
		@ Prow()  ,045 Psay NomeCli(cClifor)
		@ Prow()  ,100 Psay nSubCli Picture "@E 999,999,999.99"
		nTotCli += nSubCli
		nGerCli += nSubCli
		nSubCli := 0
	Endif

	If TMP1->E5_NATUREZ <> cNaturez
		@ Prow()+02,100 Psay nTotCli  Picture "@E 999,999,999.99"
		@ Prow()+01,001 Psay __PrtThinLine()
		nTotCli := 0
	Endif
     
Enddo
@ Prow()+001, 060 Psay "RECEBIMENTO"
@ Prow()    , 100 Psay nGerCli  Picture "@E 999,999,999.99"
@ Prow()+01,001 Psay __PrtThinLine()
@ Prow()+002, 001 Psay ""

// Imprime Emprestimos e financiamentos
nValor  := 0
TMP2->(DbGoTop())
While TMP2->(!Eof())
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If lRet
		@ Prow() + 1, 001 Psay TMP2->E5_NATUREZ
		@ Prow()    , 013 Psay NomeNat(TMP2->E5_NATUREZ)
		@ Prow()    , 045 Psay TMP2->E5_BANCO
		@ Prow()    , 050 Psay NomeBan(TMP2->E5_BANCO)
		// @ Prow()    , 100 Psay TMP2->TOTBAN          Picture "@E 999,999,999.99"
		lRet := .F.
	Endif		
	If     TMP2->E5_RECPAG = 'R'	
		nValor += TMP2->TOTBAN
	Elseif TMP2->E5_RECPAG = 'P'	
		nValor -= TMP2->TOTBAN	
	Endif	
	cNaturez := TMP2->E5_NATUREZ
	TMP2->(DbSkip())

	If TMP2->E5_NATUREZ <> cNaturez
		nTotBan += nValor
		nSubBan += nValor
		@ Prow()    , 100 Psay nValor  Picture "@E 999,999,999.99"
		@ Prow()+002, 100 Psay nSubBan Picture "@E 999,999,999.99"
		nSubBan := 0
		nValor  := 0
		@ Prow()+01,001 Psay __PrtThinLine() 
		lRet := .T.
	Endif
    
Enddo
@ Prow()+02,001 Psay __PrtThinLine() 
@ Prow()+001, 060 Psay "EMPRESTIMOS/FINANCIAMENTOS"
@ Prow()    , 100 Psay nTotBan  Picture "@E 999,999,999.99"
@ Prow()+01,001 Psay __PrtThinLine() 

// Imprime Pagamento de emprestimos    
nValor  := 0
TMP3->(DbGoTop())
While TMP3->(!Eof())
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If lRet 
		@ Prow() + 1, 001 Psay TMP3->E5_NATUREZ
		@ Prow()    , 013 Psay NomeNat(TMP3->E5_NATUREZ)
		@ Prow()    , 045 Psay TMP3->E5_BANCO 
		@ Prow()    , 050 Psay NomeBan(TMP3->E5_BANCO)
		lRet := .F.
	Endif		
	nValor += TMP3->TOTBAN
	cNaturez := TMP3->E5_NATUREZ
	TMP3->(DbSkip())

	If TMP3->E5_NATUREZ <> cNaturez
		nTotPag += nValor
		nSubPag += nValor
		@ Prow()    , 100 Psay nValor  Picture "@E 999,999,999.99"
		@ Prow()+002, 100 Psay nSubPag Picture "@E 999,999,999.99"
		nSubPag := 0
		nValor  := 0
		@ Prow()+01,001 Psay __PrtThinLine() 
		lRet := .T.
	Endif
    
Enddo
@ Prow()+02,001 Psay __PrtThinLine() 
@ Prow()+001, 060 Psay "PAGAMENTO DE EMPRESTIMOS"
@ Prow()    , 100 Psay nTotPag  Picture "@E 999,999,999.99"
@ Prow()+01,001 Psay __PrtThinLine()

// Imprime Pagamentos Outras Entradas
nValor  := 0
TMP4->(DbGoTop())
While TMP4->(!Eof())
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If lRet
		@ Prow() + 1, 045 Psay NomeCli(TMP4->E5_CLIFOR)
		lRet := .F.
	Endif
	nValor += TMP4->TOTEMP
	cClifor := TMP4->E5_CLIFOR
	TMP4->(DbSkip())

	If TMP4->E5_CLIFOR <> cClifor
		nTotEmp += nValor
		nSubEmp += nValor
		@ Prow()    , 100 Psay nValor  Picture "@E 999,999,999.99"
		@ Prow()+002, 100 Psay nSubEmp Picture "@E 999,999,999.99"
		nSubEmp := 0
		nValor  := 0
		@ Prow()+01,001 Psay __PrtThinLine() 
		lRet := .T.
	Endif
    
Enddo


// Imprime Recebimento Diversos        
nValor := 0
lRet   := .T.
TMP5->(DbGoTop())
While TMP5->(!Eof())
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If lRet 
		@ Prow() + 1, 001 Psay TMP5->E5_NATUREZ
 		@ Prow()    , 013 Psay NomeNat(TMP5->E5_NATUREZ)
		@ Prow()    , 050 Psay 'RECEBIMENTO DIVERSOS'
		lRet := .F.
	Endif		
	nValor += TMP5->TOTOTH
	cNaturez := TMP5->E5_NATUREZ
	TMP5->(DbSkip())

	If TMP5->E5_NATUREZ <> cNaturez
		nTotOth += nValor
		nSubOth += nValor
		@ Prow()    , 100 Psay nValor  Picture "@E 999,999,999.99"
		@ Prow()+002, 100 Psay nSubOth Picture "@E 999,999,999.99"
		nSubOth := 0
		nValor  := 0
		@ Prow()+01,001 Psay __PrtThinLine() 
		lRet := .T.
	Endif
    
Enddo

@ Prow()+02,001 Psay __PrtThinLine()
@ Prow()+001, 060 Psay "OUTRAS ENTRADAS"
@ Prow()    , 100 Psay nTotEmp+nTotOth  Picture "@E 999,999,999.99"
@ Prow()+01,001 Psay __PrtThinLine()
@ Prow()+001, 060 Psay "T O T A L"
@ Prow()    , 100 Psay (nGerCli+nTotBan+nTotPag+nTotEmp+nTotOth) Picture "@E 999,999,999.99"
@ Prow()+01,001 Psay __PrtThinLine()
@ Prow()+001, 001 Psay ""
     
DbSelectArea("TMP1")
DbCloseArea()
DbSelectArea("TMP2")
DbCloseArea()
DbSelectArea("TMP3")
DbCloseArea()
DbSelectArea("TMP4")
DbCloseArea()
DbSelectArea("TMP5")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return(nil)


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "FIN032"
aRegs   := {}

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
/*
aadd(aRegs,{cPerg,"01","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})        
aadd(aRegs,{cPerg,"02","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
*/

aadd(aRegs,{cPerg,"01","Periodo de       ?","Periodo de       ?","Periodo de       ?","mv_ch1","D",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Periodo ate      ?","Periodo ate      ?","Periodo Ate      ?","mv_ch2","D",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
   	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()
       DbCommit()
   Next
Endif

dbSelectArea(_sAlias)

Return                    

Static Function NomeCli(cCodCli)
Local _cNomeCli := Space(40)
	SA1->(DbSeek(xFilial("SA1")+cCodCli)) // Pesquisa Cliente
	If SA1->(Found())
		_cNomeCli := SA1->A1_COD + " " + SA1->A1_NOME
	Else
		SA2->(DbSeek(xFilial("SA2")+cCodCli)) // Pesquisa Fornecedor
		If SA2->(Found())
			_cNomeCli := SA2->A2_COD + " " + SA2->A2_NOME
		Endif
	Endif
Return(_cNomeCli)



Static Function NomeNat(cNatur)
Local _cDescNat := Space(40)
	SED->(DbSeek(xFilial("SED")+cNatur))
	If SED->(Found())
		_cDescNat := SED->ED_DESCRIC
	Endif
Return(_cDescNat)

Static Function NomeBan(cBanc)
Local _cNomeBan := Space(40)
	SA6->(DbSeek(xFilial("SA6")+cBanc))
	If SA6->(Found())
		_cNomeBan := Substr(SA6->A6_NOME,1,30)
	Endif
Return(_cNomeBan)