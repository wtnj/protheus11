#INCLUDE "M465GRV.ch"
#include "rwmake.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ M465Grv   ³ Autor ³ Diego Rivero          ³ Data ³ 13/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rdmake Padrao para impressao de NCC/NDC pelo modulo SigaLoja³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Imprime NCC e NDC em Impresora Fiscal                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ParamIxb == 1 Inicio  / ParamIxb == 2 Final                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³ BOPS ³  Motivo de la Alteracion                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Diego Rivero³07/08/01³xxxxxx³Desenvolvimento inicial                    ³±±
±±³Fernando M. ³13/02/03³xxxxxx³Padronizacao para rdmake                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M465grv()

Local aArea := GetArea()
Local nIB2	:= 0
Local nIBP	:= 0
Local lRet	:= .T.

If nModulo != 12 .Or. !IIf(Type("lFiscal")#"U",lFiscal,.F.) .Or. cPaisLoc != "ARG"
   Return (.T.)
EndIf

If Alltrim(cEspecie) == "NCC"  .And. ParamIxb[1] == '1'
	lRet := ImprimeNCC()
ElseIf Alltrim(cEspecie) == "NDC" .And. ParamIxb[1] == '1'
	lRet := ImprimeNDC()
EndIf

RestArea( aArea )

Return( lRet )

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImprimeNCC³ Autor ³ Diego Rivero          ³ Data ³ 13/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de NCC para impressora fiscal                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nota de Credito(SigaLoja)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprimeNCC(  )

LOCAL _nX
LOCAL nPosCod   := Ascan( aHeader, { |x| Alltrim(x[2]) == "D1_COD"   } )
LOCAL nPosVUnit := Ascan( aHeader, { |x| Alltrim(x[2]) == "D1_VUNIT" } )
LOCAL nPosTotIt := Ascan( aHeader, { |x| Alltrim(x[2]) == "D1_TOTAL" } )
LOCAL nPosDesc  := Ascan( aHeader, { |x| Alltrim(x[2]) == "D1_VALDESC" } )
LOCAL nPosQtd   := Ascan( aHeader, { |x| Alltrim(x[2]) == "D1_QUANT" } )
LOCAL nPosNFOri := Ascan( aHeader, { |x| Alltrim(x[2]) == "D1_NFORI" } )
LOCAL nPosSerOri:= Ascan( aHeader, { |x| Alltrim(x[2]) == "D1_SERIORI" } )
LOCAL nTotalDesc:= 0
LOCAL nVlrIVA   := 0
LOCAL nRet      := 1
LOCAL _nI
LOCAL nAliqIVA  := 0
LOCAL nAliqInt  := 0
LOCAL nPosHas   := 0
LOCAL nIB2      := 0
LOCAL nIBP      := 0
LOCAL cNumNota  := Space(TamSX3("L1_DOC")[1])
LOCAL cVlrIVA   := ""
LOCAL cTipoCli  := ""
LOCAL cDescTotal:= ""
LOCAL cPdv      := Space(4)
LOCAL cDocOri   := ""
LOCAL cCNPJ     := ""
LOCAL cDadosCli := ""
LOCAL cDadosCab := ""
LOCAL cTipoDoc  := ""
LOCAL cCodProd  := ""
LOCAL cDescProd := ""     
LOCAL cQuant    := ""
LOCAL cVUnit    := ""
LOCAL cTotIt    := ""
LOCAL cAliquota := ""
LOCAL cIncluiIVA:= "B"  //Se T indica que o preco contem IVA incluido. Se B, o IVA eh discriminado
LOCAL cTexto    := ""
LOCAL cTotItem  
LOCAL cTmpHas   := ""
LOCAL cHasar1   := ""
LOCAL cHasar2   := ""                
LOCAL cVlrIB    := ""
LOCAL cRetorno  := ""
LOCAL cParam    := ""
LOCAL aRet      := {}
LOCAL aTamQuant := TamSX3("D1_QUANT")
LOCAL aTamUnit  := TamSX3("D1_VRUNIT")
LOCAL aTamTotIt := TamSX3("D1_TOTAL")

cTmpHas   := GetMV("MV_IMPSIVA",,"IVA|")  //Codigo dos impostos que somam no IVA(Argentina)
nPosHas   := AT("|",cTmpHas)
cHasar1   := Substr(cTmpHas,1,nPosHas-1)
cHasar2   := Substr(cTmpHas,nPosHas+1)
nPosHas   := IIf(nPosHas==0,Len(cTmpHas),nPosHas)

nRet  := IFPegPDV( nHdlECF, @cPdv )
If L010AskImp(.F.,nRet)
	Return (.F.)
EndIf
aRet  := LjStr2Array(cPDV)
cPDV  := aRet[1]   
cDocOri := cPdv + StrZero(0,TamSX3("L1_DOC")[1]-Len(cPDV))

Do Case
	Case SA1->A1_TIPO = "X"
		cTipoCli := "E"
	Case SA1->A1_TIPO = "F" .Or. Empty( SA1->A1_TIPO )
		cTipoCli := "C"
	Case SA1->A1_TIPO = "S"
		cTipoCli := "A"
	Case SA1->A1_TIPO = "Z"
		cTipoCli := "I"
	OtherWise
		cTipoCli := SA1->A1_TIPO
EndCase

If SA1->A1_TIPO == "F"
	cCNPJ		:=	SA1->A1_RG
	cTipoID	    :=	"2"
Else
	cCNPJ		:=	Alltrim( SA1->A1_CGC )
	cTipoID	    :=	"C"
	If Empty(cCNPJ)
		MsgAlert(STR0001) //"O cliente nao possui CUIT, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
		Return( .F. )
	EndIf
	If !Cuit(cCNPJ)
		MsgAlert(STR0002) //"O CUIT do cliente nao e valido, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
		Return( .F. )
	EndIf
Endif

cDadosCli  := Padr(Substr(SA1->A1_NOME,1,30),30) + ;       
              "|" + StrTran( AllTrim(cCNPJ), "-", "" ) + ;
              "|" + cTipoCli + ;
              "|" + cTipoID

SA3->(DbSetOrder(1))
SA3->(DbSeek( xFilial("SA3") + cVendedor ))
If SA3->(Found()) 
   cDadosCab   := Padr(Substr("|4|" + STR0003 + cVendedor + " " + Capital(SA3->(A3_NOME)),1,30),30) //"Vendedor: "
Else
   cDadosCab   := Padr(Substr("|4| ",1,30),30)   
EndIf
	
SE4->(DbSetOrder(1))
SE4->(DbSeek( xFilial("SE4") + cCondPagto ))
If SE4->(Found())
   cDadosCab   += Padr(Substr("|5|" + STR0004 + cCondPagto + " " + Capital(SE4->E4_DESCRI),1,30),30) //"Cond. Pagto.: "
Else
   cDadosCab   += Padr(Substr("|5| ",1,30),30)      
EndIf

For _nX := 1 To Len( aCols )
	If !aCols[_nX][Len(aCols[_nX])] .And. !Empty( aCols[_nX][nPosNFOri] )
		cDocOri := aCols[_nX][nPosSerOri] + " " + aCols[_nX][nPosNFOri]
	End
Next _nX

cDocOri  := "|1|" + cDocOri

If cTipoCli $ "IN"
   cTipoDoc  := "R"  //NCC serie A
Else
   cTipoDoc  := "S"  //NCC serie B
EndIf

aRet := {}
nRet := IFAbrirDNFH(nHdlECF, cTipoDoc, cDadosCli, cDadosCab, cDocOri, @aRet)
If L010AskImp(.F.,nRet)
   Return (.F.)
EndIf   
/*If !HsrStat( aRet[1], aRet[2], STR0006 )  //"Abertura de documento"   
   nRet  := IFCancCup(nHdlECF)
//   aRet   := ExecHsr( Chr( 152 ) )   // Cancel
   Return( .F. )
EndIf
*/

If ValType( aRet ) != 'A' .Or. Len( aRet ) < 3  .Or. ValType( aRet[3] ) != 'C'
   MsgAlert( STR0007, STR0008 )         //"Erro na abertura do Documento!"###"Erro da Impressora Fiscal"
   nRet  := IFCancCup(nHdlECF)
// aRet   := ExecHsr( Chr( 152 ) )   // Cancel      
   Return( .F. )
EndIf

cNumNota    := aRet[3]
cSerie		:= IIf(SA1->A1_TIPO $ "INZ", "A  ", "B  ")
cNFiscal	:= cPdv + cNumNota

For _nX := 1 To Len( aCols )

    If aCols[_nx][Len(aCols[_nx])]
   	   Loop
	Endif

	nAliqIVA 	:= 0
	nAliqInt	:= 0
	cUnit		:=	""

	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1") + aCols[_nX][nPosCod] ) )

    nTotalDesc  += aCols[_nX][nPosDesc]
    cCodProd    := SB1->B1_COD
    cDescProd   := SB1->B1_DESC
	cQuant	    := Alltrim( StrTran( Str( aCols[_nX][nPosQtd], aTamQuant[1], aTamQuant[2] ), ",", ".") )
	cVUnit	    := Alltrim( StrTran( Str( aCols[_nX][nPosVUnit], aTamUnit[1], aTamUnit[2] ), ",", ".") )
	cTotIt	    := Alltrim( StrTran( Str( aCols[_nX][nPosTotIt], aTamTotIt[1], aTamTotIt[2] ), ",", ".") )

	For _nI := 1 to Len(aImps[_nX][6])
		If aImps[_nX][6][_nI][3] > 0
			If Upper(Alltrim(aImps[_nX][6][_nI][1])) $ cHasar1  //Impostos que somam no IVA
				nAliqIVA := nAliqIVA + aImps[_nX][6][_nI][2]
			ElseIf Upper(Alltrim(aImps[_nX][6][_nI][1])) $ cHasar2  //Impostos internos
				nAliqInt := nAliqInt + aImps[_nX][6][_nI][2]
			Endif
		Endif
	Next _nI
    
    cAliquota  := AllTrim(Str(nAliqIVA,5,2))+"|"+AllTrim(Str(nAliqInt,4,2))+"|"+cIncluiIVA
    
    nRet  := IFRegItem( nHdlECF,cCodProd,cDescProd,cQuant,cUnit,'0',cAliquota,cTotItem)		
    If nRet == 1
       Return(.F.)
    EndIf
    
/*	If !HsrStat( aRet[1], aRet[2], STR0009 + aCols[_nX][nPosCod] )  //"Produto "            
       nRet  := IFCancCup(nHdlECF)	   
       Return( .F. )
	EndIf    	
*/
	
Next _nX

If nTotalDesc > 0
   cDescTotal := " |"+Strzero(nTotalDesc,12,2)+"|0|"
   nRet       := IFDescTot( nHdlECF,cDescTotal )   
   If nRet == 1
      Return(.F.)
   EndIf   
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percepcoes                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For _nX := 1 To Len( aImps )
   For _nI := 1 To Len( aImps[_nX][6] )
      If aImps[_nX][6][_nI][1] $ "IB2" .And. aImps[_nX][6][_nI][4] > 0
	     nIB2	+=	aImps[nX][6][nY][4]
      ElseIf aImps[_nX][6][_nI][1] $ "IBP" .And. aImps[_nX][6][_nI][4] > 0
		 nIBP	+=	aImps[_nX][6][_nI][4]
      ElseIf aImps[_nX][6][_nI][1] $ "IVP" .And. aImps[_nX][6][_nI][4] > 0 .And. aImps[_nX][6][_nI][2] > 0
         nVlrIVA += aImps[_nX][6][_nI][4]
      EndIf
   Next _nI
Next _nX
	
If nVlrIVA > 0
   cAliqIVA  := Alltrim(Str(nAliqIVA,TamSX3("L1_ALQIMP1")[1],nDecimais))		
   cTexto    := "Percep. IVA"
   cVlrIVA   := Alltrim(Str(nVlrIVA,TamSX3("L1_VALIMP1")[1],nDecimais))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIVA, @aRet)
   If nRet == 1
      Return(.F.)
   EndIf      
Endif
	
If nIB2 > 0
   cAliqIVA  := "**.**"
   cTexto    := "Perc. IIBB Bs.As."
   cVlrIB    := Alltrim(Str(nIB2,TamSX3("L1_VALIMP1")[1],nDecimais))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)
   If nRet == 1
      Return(.F.)
   EndIf      
Endif
	
If nIBP > 0
   cAliqIVA  := "**.**"
   cTexto    := "Perc. IIBB Cap.Fed"
   cVlrIB    := Alltrim(Str(nIBP,TamSX3("L1_VALIMP1")[1],nDecimais))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)		
   If nRet == 1
      Return(.F.)
   EndIf   
Endif	

nRet  := IFFecharDNFH(nHdlECF, @aRet)  //Fechar o documento DNFH
If nRet == 1
   Return(.F.)
EndIf
/*If !HsrStat( aRet[1], aRet[2], STR0010 )  //"Fechamento do Documento"            
   nRet  := IFCancCup(nHdlECF)
//   aRet   := ExecHsr( Chr( 152 ) )   // Cancel
   Return( .F. )
EndIf
*/

Return 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImprimeNDC³ Autor ³ Diego Rivero          ³ Data ³ 14/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de NDC para impressora fiscal                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nota de Debito ao Cliente(SigaLoja)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprimeNDC( )

LOCAL _nX
LOCAL nPosCod   := Ascan( aHeader, { |x| Alltrim(x[2]) == "D2_COD"   } )
LOCAL nPosVUnit := Ascan( aHeader, { |x| Alltrim(x[2]) == "D2_PRCVEN" } )
LOCAL nPosTotIt := Ascan( aHeader, { |x| Alltrim(x[2]) == "D2_TOTAL" } )
LOCAL nPosDesc  := Ascan( aHeader, { |x| Alltrim(x[2]) == "D2_VALDESC" } )
LOCAL nPosQtd   := Ascan( aHeader, { |x| Alltrim(x[2]) == "D2_QUANT" } )
LOCAL nVlrIVA   := 0 
LOCAL nRet      := 1
LOCAL _nI
LOCAL nAliqIVA  := 0
LOCAL nAliqInt  := 0
LOCAL nPosHas   := 0
LOCAL nIB2      := 0
LOCAL nIBP      := 0
LOCAL nTamF2DOC := TamSX3("F2_DOC")[1]

LOCAL cTipoCli  := ""
LOCAL cPdv      := Space(4)
LOCAL cCNPJ     := ""
LOCAL cDadosCab := ""
LOCAL cVlrIVA   := ""
LOCAL cSerieCup := ""
LOCAL cNumNota  := Space(TamSX3("L1_DOC"))[1]
LOCAL cCodProd
LOCAL cDescProd
LOCAL cQuant    := ""
LOCAL cVUnit    := ""
LOCAL cTotIt    := ""
LOCAL cAliquota :=""
LOCAL cIncluiIVA:= "s"  //Se T indica que o preco contem IVA incluido. Caso contrario,
                        //o IVA eh discriminado
LOCAL cTexto    := ""
LOCAL cInfo     := ""
LOCAL cTotItem  
LOCAL cTmpHas   := ""
LOCAL cHasar1   := ""
LOCAL cHasar2   := ""
LOCAL cVlrIB    := ""
LOCAL cRetorno  := ""

LOCAL aTamQuant := TamSX3("D1_QUANT")
LOCAL aTamUnit  := TamSX3("D1_VRUNIT")
LOCAL aTamTotIt := TamSX3("D1_TOTAL")
LOCAL aRet      := {}

cTmpHas   := GetMV("MV_IMPSIVA",,"IVA|")  //Codigo dos impostos que somam no IVA(Argentina)
nPosHas   := AT("|",cTmpHas)
cHasar1   := Substr(cTmpHas,1,nPosHas-1)
cHasar2   := Substr(cTmpHas,nPosHas+1)
nPosHas   := IIf(nPosHas==0,Len(cTmpHas),nPosHas)

nRet     := IFStatus(nHdlECF, '5', @cRetorno)      
//   aRet  := ExecHsr( Chr( 42 ) )              
If nRet == 1 
   Return( .F. )
EndIf      

/*aRet  := LjStr2Array(cRetorno)
If !HsrStat( aRet[1], aRet[2], STR0011 ) //" Verificacao do Status da Impressora "      
   GrabLogHsr( aRet[1] + ' ' + aRet[2] + STR0011 + SL1->L1_NUM ) //" Verificacao do Status da Impressora "
   Return( .F. )
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³se exitir cupom aberto, faz o cancelamento e abre um novo.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
If nRet = 7
   nRet := IFCancCup( nHdlECF )
   If L010AskImp(.F.,nRet)
      Return (.F.)
   EndIf
   Inkey(8)   // dá um tempo para a impressora fazer a impressao do cancelamento
Endif

nRet := IFPegPDV( nHdlECF, @cPdv )
If nRet == 1 
   Return( .F. )
EndIf      
aRet  := LjStr2Array(cPDV)
cPDV  := aRet[7]   

Do Case
	Case SA1->A1_TIPO = "X"
		cTipoCli := "E"
	Case SA1->A1_TIPO = "F" .Or. Empty( SA1->A1_TIPO )
		cTipoCli := "C"
	Case SA1->A1_TIPO = "S"
		cTipoCli := "A"
	Case SA1->A1_TIPO = "Z"
		cTipoCli := "I"
	OtherWise
		cTipoCli := SA1->A1_TIPO
EndCase

If SA1->A1_TIPO == "F"
	cCNPJ		:=	SA1->A1_RG
	cTipoID	    :=	"2"
Else
	cCNPJ		:=	Alltrim( SA1->A1_CGC )
	cTipoID	    :=	"C"
	If Empty(cCNPJ)
		MsgAlert(STR0001) //"O cliente nao possui CUIT, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
		Return( .F. )
	EndIf
	If !Cuit(cCNPJ)
		MsgAlert(STR0002) //"O CUIT do cliente nao e valido, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
		Return( .F. )
	EndIf
Endif

SA3->(DbSetOrder(1))
SA3->(DbSeek( xFilial("SA3") + cVendedor ))
If SA3->(Found()) 
   cDadosCab   := Padr(Substr("|4|" + STR0003 + cVendedor + " " + Capital(SA3->(A3_NOME)),1,40),40) //"Vendedor: "
Else
   cDadosCab   := Padr(Substr("|4| ",1,40),40)   
EndIf
	
SE4->(DbSetOrder(1))
SE4->(DbSeek( xFilial("SE4") + cCondPagto ))
If SE4->(Found())
   cDadosCab   += Padr(Substr("|5|" + STR0004 + cCondPagto + " " + Capital(SE4->E4_DESCRI),1,40),40) //"Cond. Pagto.: "
Else
   cDadosCab   += Padr(Substr("|5| ",1,40),40)      
EndIf
                                     
cSerieCup := Iif( SA1->A1_TIPO $ "NI", "D", "E" )
//NDC serie A - SA1->A1_TIPO $ "NI"
//NDC serie B - demais
cInfo     := cSerieCup+"|"+AllTrim(SA1->A1_NOME)+"|"+StrTran(AllTrim(cCNPJ),"-","")+"|"+;
             cTipoCli+"|"+cTipoID+"|"+cDadosCab

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre documento fiscal               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRet := IFAbreCup(nHdlECF,cInfo)
If nRet == 1
   Return( .F. )   
EndIf

//aRet  := LjStr2Array(cInfo)
/*If !HsrStat( aRet[1], aRet[2], STR0006 )  //"Abertura de documento"   
   nRet  := IFCancCup(nHdlECF)
//	aRet   := ExecHsr( Chr( 152 ) )   // Cancel
   Return( .F. )
EndIf


If ValType( aRet ) != 'A' .Or. Len( aRet ) < 3 .Or. ValType( aRet[3] ) != 'C'
   nRet  := IFCancCup(nHdlECF)
//   aRet   := ExecHsr( Chr( 152 ) )   // Cancel
   Return( .F. )
EndIf
*/

cRetorno   := Space(nTamF2DOC)
nRet       := IFPegCupom( nHdlECF, @cRetorno)
If nRet == 1
   Return( .F. )      
EndIf

cNumNota := StrZero( Val( cRetorno ), nTamF2DOC )
cSerie   := IIf( SA1->A1_TIPO $ "INZ", "A  ", "B  " )
cNFiscal := cPdv + cNumNota

For _nX := 1 To Len( aCols )

    If aCols[_nx][Len(aCols[_nx])]
   	   Loop
	Endif

	nAliqIVA 	:= 0
	nAliqInt	:= 0
	cUnit		:=	""

	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1") + aCols[_nX][nPosCod] ) )
	
    cCodProd    := SB1->B1_COD
    cDescProd   := SB1->B1_DESC
	cQuant	    := Alltrim( StrTran( Str( aCols[_nX][nPosQtd], aTamQuant[1], aTamQuant[2] ), ",", ".") )
	cVUnit	    := Alltrim( StrTran( Str( aCols[_nX][nPosVUnit], aTamUnit[1], aTamUnit[2] ), ",", ".") )
	cTotIt	    := Alltrim( StrTran( Str( aCols[_nX][nPosTotIt], aTamTotIt[1], aTamTotIt[2] ), ",", ".") )

	For _nI := 1 to Len(aImps[_nX][6])
		If aImps[_nX][6][_nI][3] > 0
			If Upper(Alltrim(aImps[_nX][6][_nI][1])) $ cHasar1  //Impostos que somam no IVA
				nAliqIVA := nAliqIVA + aImps[_nX][6][_nI][2]
			ElseIf Upper(Alltrim(aImps[_nX][6][_nI][1])) $ cHasar2  //Impostos internos
				nAliqInt := nAliqInt + aImps[_nX][6][_nI][2]
			Endif
		Endif
	Next _nI    
    cAliquota  := Str(nAliqIVA,TamSX3("L2_ALQIMP1")[1],nDecimais)+"|"+Str(nAliqInt,4,2)+"|"+cIncluiIVA
    
    nRet  := IFRegItem( nHdlECF,cCodProd,cDescProd,cQuant,cUnit,'0',cAliquota,cTotItem)		
    If nRet == 1 
       Return(.F.)
    EndIf
    
/*    aRet  := LjStr2Array(cRetorno)
	If !HsrStat( aRet[1], aRet[2], STR0009 + aCols[_nX][nPosCod] )  //"Produto "            
       nRet  := IFCancCup(nHdlECF)	   
       Return( .F. )
	EndIf    	
*/    
Next _nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percepcoes                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For _nX := 1 To Len( aImps )
   For _nI := 1 To Len( aImps[_nX][6] )
      If aImps[_nX][6][_nI][1] $ "IB2" .And. aImps[_nX][6][_nI][4] > 0
	     nIB2	+=	aImps[nX][6][nY][4]
	  ElseIf aImps[_nX][6][_nI][1] $ "IBP" .And. aImps[_nX][6][_nI][4] > 0
	     nIBP	+=	aImps[_nX][6][_nI][4]
      ElseIf aImps[_nX][6][_nI][1] $ "IVP" .And. aImps[_nX][6][_nI][4] > 0 .And. aImps[_nX][6][_nI][2] > 0
	     nVlrIVA += aImps[_nX][6][_nI][4]
      EndIf
   Next _nI
Next _nX
	
If nVlrIVA > 0
   cAliqIVA  := Alltrim(Str(nAliqIVA,TamSX3("L1_ALQIMP1")[1],nDecimais))		
   cTexto    := "Percep. IVA"
   cVlrIVA   := Alltrim(Str(nVlrIVA,TamSX3("L1_VALIMP1")[1],nDecimais))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIVA, @aRet)
   If nRet == 1
      Return(.F.)
   EndIf         
Endif
	
If nIB2 > 0
   cAliqIVA  := "**.**"
   cTexto    := "Perc. IIBB Bs.As."
   cVlrIB    := Alltrim(Str(nIB2,TamSX3("L1_VALIMP1")[2],nDecimais))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)
   If nRet == 1
      Return(.F.)
   EndIf         
Endif
	
If nIBP > 0
    cAliqIVA  := "**.**"
	cTexto    := "Perc. IIBB Cap.Fed"
	cVlrIB    := Alltrim(Str(nIBP,TamSX3("L1_VALIMP1")[1],nDecimais))
	aRet      := {}
    nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)		
    If nRet == 1
       Return(.F.)
    EndIf          
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o cupom e imprime a mensagem              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTexto  := ""
nRet := IFFechaCup(nHdlECF,cTexto)
If nRet == 1
   Return(.F.)
EndIf

Return