/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE259  ºAutor  ³Marcos R Roquitski  º Data ³  27/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo desoneracao da folha de pagamento.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe259()

SetPrvt("aRotina,cCadastro,_cCustod,_cCustoa,_cMat,_cNome,_cCustc,_cCuste,_cCuston")
SetPrvt("mStruct,mArqTrab,aFields,aRotina,cDelFunc,cCadastro,cMarca,cCoord,_aGrupo,_cLogin,_cLogin2")
SetPrvt("_dDatade,_dDatate,_cSitu,CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,_dUltApr,aOrd")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY,_nFolha")

cabec1    := ""
cabec2    := ""
cabec3    := ""
wnrel     := ""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "** CALCULO - CONTRIBUICAO FOLHA DE PAGAMENTO **"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SRA"
nTipo     := 0
nomeprog  := "NHGPE259"
cPerg     := ""
nPag      := 1
m_pag     := 1
wnrel	  := "NHGPE259"
aOrd 	  := {"Matricula","Centro de Custo","Nome"}


SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

RptStatus({||Imprime()},"Imprimindo...")

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

//
Static Function Imprime()

Local _nChave   := Substr(Dtos(dDataBase),1,6)
Local _nTipo1   := 0 
Local _nTipo2   := 0
Local _nDifer   := 0
Local _nExclu   := 0

RCC->(DbSetOrder(1))

Titulo    := "CALCULO - CONTRIBUICAO FOLHA DE PAGAMENTO: "+MesExtenso(dDataBase) +'/'+Substr(Dtos(dDataBase),1,4)
Cabec1    := "NCM                  TIPO                                      VALOR"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)                                                                                                    

RCC->(DbSeek(Space(02)+"S033"))
While !RCC->(eof()) .AND. Alltrim(RCC->RCC_CODIGO) == 'S033'

	If RCC->RCC_CHAVE == _nChave .AND. RCC->RCC_FIL == xFilial("SRC")


		If Prow() > 60
			nPag := nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		Endif
	
		@ Prow() + 1,000 Psay Substr(RCC->RCC_CONTEU,1,8)
		@ Prow()    ,024 Psay Substr(RCC->RCC_CONTEU,9,1)
		@ Prow()    ,050 Psay Val(Substr(RCC->RCC_CONTEU,50,67)) Picture "@E 999,999,999,999.99"

		If Substr(RCC->RCC_CONTEU,9,1) == '1' 
			_nTipo1 += Val(Substr(RCC->RCC_CONTEU,50,67)) 
			
		ElseIf Substr(RCC->RCC_CONTEU,9,1) == '2' 
			_nTipo2 += Val(Substr(RCC->RCC_CONTEU,50,67)) 

		Endif
		_nExclu += Val(Substr(RCC->RCC_CONTEU,67,84))

	Endif
	RCC->(DbSkip())

Enddo


@ Prow() + 1,000 Psay __PrtThinLine()
@ Prow() + 1,000 Psay "Receita Bruta Total: "
@ Prow()    ,050 Psay _nTipo1+_nTipo2 Picture "@E 999,999,999,999.99"

@ Prow() + 1,000 Psay "Receita Bruta Relacionada: "
@ Prow()    ,050 Psay (_nTipo1) Picture "@E 999,999,999,999.99"
@ Prow()    ,070 Psay ((_nTipo1/(_nTipo1+_nTipo2))*100) Picture "@E 999.99%"


@ Prow() + 1,000 Psay "Receita Bruta nao relacionada"
@ Prow()    ,050 Psay (_nTipo2) Picture "@E 999,999,999,999.99"
@ Prow()    ,070 Psay ((_nTipo2/(_nTipo1+_nTipo2))*100) Picture "@E 999.99%"
@ Prow() + 1,000 Psay __PrtThinLine()
_nDifer := _nTipo2
                                              
@ Prow() + 1,015 Psay "I - CONTRIBUICAO DECRETO 7.716/2012" 
@ Prow() + 2,000 Psay "Faturamento enquadrado no Decreto 7.716/2012" 
//@ Prow()    ,050 Psay ( (_nTipo1 + _nTipo2) - _nDifer - _nExclu) Picture "@E 999,999,999,999.99" 
@ Prow()    ,050 Psay _nTipo1 Picture "@E 999,999,999,999.99" 

//_nTotFat := ((((_nTipo1+_nTipo2) - _nDifer - _nExclu) * 1)/100)
_nTotFat := ((_nTipo1*1)/100)
_nAliq   := 1
@ Prow() + 1,000 Psay "Aliquota Aplicavel"
@ Prow()    ,060 Psay _nAliq Picture "@E 9,999.99%"

@ Prow() + 1,000 Psay "TOTAL DA CONTRIBUICAO PELO FATURAMENTO"
@ Prow()    ,050 Psay _nTotFat Picture "@E 999,999,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()

@ Prow() + 1,015 Psay "II - CONTRIBUICAO DA FOLHA 20%"

_nPerFo := 20

_fSrc()

/*			
If SM0->M0_CODIGO == 'FN'
	If	SX6->(DbSeek(xFilial("SRC")+"MV_FOLMES"))
		If Alltrim(SX6->X6_CONTEUD) == Substr(Dtos(dDataBase),1,6)
			_fSrc()
		Else
			_fSrd() 
		Endif	
	Endif	
Else
	If	SX6->(DbSeek("  MV_FOLMES"))
		If Alltrim(SX6->X6_CONTEUD) == Substr(Dtos(dDataBase),1,6)
			_fSrc()
		Else
			_fSrd() 
		Endif	
	Endif	
Endif
*/


@ Prow() + 2,000 Psay "Folha de Pagamento + pro-labore + autonomos"
@ Prow()    ,050 Psay _nFolha Picture "@E 999,999,999,999.99"
@ Prow() + 1,000 Psay "Aliquota Aplicavel"
@ Prow()    ,060 Psay _nPerFo Picture "@E 9,999.99%"
@ Prow() + 1,000 Psay "Total da Contribuicao Original"
@ Prow()    ,050 Psay ((_nFolha * 20)/100) Picture "@E 999,999,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()


@ Prow() + 1,015 Psay "III - CONTRIBUICAO DA FOLHA 20%"
@ Prow() + 1,010 Psay "NCM nao qnquadrado no Decreto 7.716/2012"
_nPerFo := 20


@ Prow() + 2,000 Psay "Valor do faturamento nao enquadrado"
@ Prow()    ,050 Psay _nTipo2 Picture "@E 999,999,999,999.99"

@ Prow() + 1,000 Psay "Valor total do faturamento"
@ Prow()    ,050 Psay (_nTipo1 + _nTipo2) Picture "@E 999,999,999,999.99"

_nRazao := ((_nTipo2/(_nTipo1+_nTipo2)))
_nFopag := (_nRazao * ((_nFolha * 20)/100) )
@ Prow() + 1,000 Psay "Razao"
@ Prow()    ,056 Psay ((_nTipo2/(_nTipo1+_nTipo2))) Picture "@E 999.99999999"

@ Prow() + 1,000 Psay "Total da Contribuicao Original"
@ Prow()    ,050 Psay ((_nFolha * 20)/100) Picture "@E 999,999,999,999.99"

@ Prow() + 1,000 Psay "Total da Contribuicao pela FOPAG"
@ Prow()    ,050 Psay _nFopAG Picture "@E 999,999,999,999.99"

@ Prow() + 1,000 Psay __PrtThinLine()



@ Prow() + 1,015 Psay "IV - VALOR COMPENSACAP SEFIP"
_nPerFo := 20
_nRazao := ((_nTipo2/(_nTipo1+_nTipo2)))
_nFopag := (_nRazao * ((_nFolha * 20)/100) )
@ Prow() + 1,000 Psay "Total da Contribuicao Original"
@ Prow()    ,050 Psay ((_nFolha * 20)/100) Picture "@E 999,999,999,999.99"

@ Prow() + 1,000 Psay "Total da Contribuicao pela FOPAG"
@ Prow()    ,050 Psay _nFopAG Picture "@E 999,999,999,999.99"

@ Prow() + 1,000 Psay "Valor a ser indicado como compensacao na SEFIP"
@ Prow()    ,050 Psay ((_nFolha * 20)/100) - _nFopAG Picture "@E 999,999,999,999.99"
@ Prow() + 1,000 Psay __PrtThinLine()


@ Prow() + 1,015 Psay "V - DESEMBOLSO"
 
@ Prow() + 1,000 Psay "Total da Contribuicao pelo Faturamento"
@ Prow()    ,050 Psay _nTotFat Picture "@E 999,999,999,999.99"
@ Prow() + 1,000 Psay "Total da Contribuicao pela FOPAG"
@ Prow()    ,050 Psay _nFopAG Picture "@E 999,999,999,999.99"


_nTotDe := _nTotFat + _nFopag
@ Prow() + 3,000 Psay "Total Desembolso"
@ Prow()    ,050 Psay _nTotDe Picture "@E 999,999,999,999.99"

@ Prow() + 1,000 Psay __PrtThinLine()



/*

        tipo   base de cal  aliq     Cont. Devida       Rec. Bruta   Vlr. Exclusoes                     
  
841300001         95157.77  1.00           951.58         95157.77             0.00             0.00                                                                                                                                                      
        1         93828.90  1.00           938.29        101597.40          7768.50             0.00                                                                                                                                                      
870899901        572382.04  1.00          5723.82        574053.10         16171.06             0.00                                                                                                                                                      
870894901         92793.24  1.00           927.93         92862.60            69.36             0.00                                                                                                                                                      
870893001         59649.60  1.00           596.50         59649.60             0.00             0.00                                                                                                                                                      
870840901       1152640.65  1.00         11526.41       1157450.65          8880.33             0.00                                                                                                                                                      
870830901         94008.55  1.00           940.09        117962.89         23954.34             0.00                                                                                                                                                      
870829991       1712681.84  1.00         17126.82       1712681.84             0.00             0.00                                                                                                                                                      
851100001        952527.24  1.00          9525.27        952527.24             0.00             0.00                                                                                                                                                      
848300001        986966.17  1.00          9869.66        986966.17           882.44             0.00                                                                                                                                                      
841900001        270090.51  1.00          2700.91        286132.64         16042.13             0.00                                                                                                                                                      
840900001        178255.56  1.00          1782.56        217292.96         39037.40             0.00                                                                                                                                                      
761699001        207077.21  1.00          2070.77        211418.34          4341.13             0.00                                                                                                                                                      
650000001        112602.96  1.00          1126.03        117147.89          4544.93             0.00                                                                                                                                                      

*/

Return

//
Static Function _fSrd() 
Local _cMesAno := Substr(Dtos(dDataBase),1,6)
Local _cFilial := xFilial("SRD")
_nFolha := 0

	cQuery := "SELECT SUM(RD.RD_VALOR) 'FAT' "
	cQuery := cQuery + " FROM " + RetSqlName( 'SRD' ) + " RD " 
	cQuery := cQuery + "WHERE RD.D_E_L_E_T_ = ' ' "
	cQuery := cQuery + "AND RD.RD_DATARQ = '" + _cMesAno + "' "
	cQuery := cQuery + "AND RD.RD_FILIAL BETWEEN '" + _cFilial + "' AND '" + _cFilial +"' " 
	cQuery := cQuery + "AND RD.RD_PD IN ('715','716','717','718','719,'824') "
	TCQUERY cQuery NEW ALIAS "ZTMP"
	TcSetField("ZTMP","RD_DATPGT","D") // Muda a data de string para date.

	DbSelectArea("ZTMP")
	ZTMP->(DbGotop())
	_nFolha := ZTMP->FAT

	ZTMP->(DbCloseArea())		

Return
 

//
Static Function _fSrc() 
Local _cMesAno := Substr(Dtos(dDataBase),1,6)
Local _cFilial := xFilial("SRC")
_nFolha := 0

	cQuery := "SELECT SUM(RC.RC_VALOR) 'FAT' "
	cQuery := cQuery + " FROM " + RetSqlName( 'SRC' ) + " RC " 
	cQuery := cQuery + "WHERE RC.D_E_L_E_T_ = ' ' "
	cQuery := cQuery + "AND RC.RC_FILIAL BETWEEN '" + _cFilial + "' AND '" + _cFilial +"' " 
	cQuery := cQuery + "AND RC.RC_PD IN ('715','716','717','718','719','824') "
	TCQUERY cQuery NEW ALIAS "ZTMP"

	DbSelectArea("ZTMP")
	ZTMP->(DbGotop())
	_nFolha := ZTMP->FAT

	ZTMP->(DbCloseArea())		

Return

