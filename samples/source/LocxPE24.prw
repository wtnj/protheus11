#INCLUDE "LOCXPE24.ch"
#include "rwmake.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ LocxPE24  ³ Autor ³ Diego Rivero          ³ Data ³ 13/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rdmake Padrao para impressao de NCC/NDC pelo modulo SigaLoja³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Imprime NCC e NDC em Impresora Fiscal                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LocxPE24()

Local aArea := GetArea()
Local nIB2	:= 0
Local nIBP	:= 0
Local lRet	:= .T.

If nModulo != 12 .Or. !IIf(Type("lFiscal")#"U",lFiscal,.F.) .Or.;
   cPaisLoc != "ARG" .Or. !IIf(Type("lCFiscal")#"U",lCFiscal,.F.)
   Return (.T.)
EndIf

If aCfgNF[1] == 4  //NCC
	lRet := ImprimeNCC()
ElseIf aCfgNF[1] == 2  //NDC
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
Static Function ImprimeNCC()

LOCAL _nX
LOCAL nTotalDesc:= 0
LOCAL nVlrIVA   := 0
LOCAL nLinCabec := 3
LOCAL nRet      := 1
LOCAL _nI
LOCAL nAliqIVA  := 0
LOCAL nAliqInt  := 0
LOCAL nPosHas   := 0
LOCAL nIB2      := 0
LOCAL nIBP      := 0
LOCAL nAliqImp  := 0
LOCAL nBaseImp  := 0
LOCAL nValorImp := 0
LOCAL nDecimais := MsDecimais(nMoedaNF)
LOCAL cNumNota  := Space(TamSX3("L1_DOC")[1])
LOCAL cVlrIVA   := ""
LOCAL cTipoCli  := ""
LOCAL cDescTotal:= ""
LOCAL cPdv      := Space(TamSX3("L1_PDV")[1])
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
LOCAL cAliquota :=""
LOCAL cIncluiIVA:= "B"  //Se T indica que o preco contem IVA incluido. Se B, o IVA eh discriminado
                        //o IVA eh discriminado
LOCAL cTexto    := ""
LOCAL cTotItem  
LOCAL cTmpHas   := ""
LOCAL cHasar1   := ""
LOCAL cHasar2   := ""                
LOCAL cVlrIB    := ""
LOCAL cVendedor := ""
LOCAL cTES      := "" 
LOCAL cIndImp   := ""
LOCAL cCpoAlqImp:= ""
LOCAL cCpoBasImp:= ""
LOCAL cCpoVlrImp:= ""
LOCAL cCodImp   := ""
LOCAL aRet      := {}
LOCAL aTamQuant := TamSX3("D1_QUANT")
LOCAL aTamUnit  := TamSX3("D1_VUNIT")
LOCAL aTamTotIt := TamSX3("D1_TOTAL")
LOCAL aTesImpInf:= {}

cTmpHas   := GetMV("MV_IMPSIVA",,"IVA|")  //Codigo dos impostos que somam no IVA(Argentina)
nPosHas   := AT("|",cTmpHas)
cHasar1   := Substr(cTmpHas,1,nPosHas-1)
cHasar2   := Substr(cTmpHas,nPosHas+1)
nPosHas   := IIf(nPosHas==0,Len(cTmpHas),nPosHas)

nRet := IFPegPDV( nHdlECF, @cPdv )
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
	If !Cuit(cCNPJ,"A1_CGC")
		MsgAlert(STR0002) //"O CUIT do cliente nao e valido, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
		Return( .F. )
	EndIf
Endif
cEnd := RTrim(SA1->A1_END)

cDadosCli  := Padr(Substr(SA1->A1_NOME,1,30),30) + ;       
              "|" + StrTran( AllTrim(cCNPJ), "-", "" ) + ;
              "|" + cTipoCli + ;
              "|" + cTipoID +;
              "|" + Padr(cEnd,50)

SA3->(DbSetOrder(1))
SA3->(DbSeek( xFilial("SA3") + cVendedor ))
If SA3->(Found()) 
   cDadosCab   := Padr(Substr("|4|" + STR0003 + cVendedor + " " + Capital(SA3->(A3_NOME)),1,30),30) //"Vendedor: "
Else
   cDadosCab   := Padr(Substr("|4| ",1,30),30)   
EndIf
	
SE4->(DbSetOrder(1))
SE4->(DbSeek( xFilial("SE4") + cCondicao ))
If SE4->(Found())
   cDadosCab   += Padr(Substr("|5|" + STR0004 + cCondicao + " " + Capital(SE4->E4_DESCRI),1,30),30) //"Cond. Pagto.: "
Else
   cDadosCab   += Padr(Substr("|5| ",1,30),30)      
EndIf

For _nX := 1 To Len( aCols )
	If !aCols[_nX][Len(aCols[_nX])] .And. !Empty( MaFisRet(_nX, "IT_NFORI") )
		cDocOri := MaFisRet(_nX, "IT_SERORI") + " " + MaFisRet(_nX, "IT_NFORI")
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

If ValType( aRet ) != 'A' .Or. Len( aRet ) < 3  .Or. ValType( aRet[3] ) != 'C'
   MsgAlert( STR0007, STR0008 )         //"Erro na abertura do Documento!"###"Erro da Impressora Fiscal"
   nRet  := IFCancCup(nHdlECF)
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
	cVUnit		:=	""

	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1") + MaFisRet(_nX, "IT_PRODUTO") ) )

    nTotalDesc  += MaFisRet(_nX, "IT_DESCONTO")
    cCodProd    := SB1->B1_COD
    cDescProd   := SB1->B1_DESC
	cQuant	    := Alltrim( StrTran( Str( MaFisRet(_nX, "IT_QUANT"), aTamQuant[1], aTamQuant[2] ), ",", ".") )
	cVUnit	    := Alltrim( StrTran( Str( MaFisRet(_nX, "IT_PRCUNI"), aTamUnit[1], aTamUnit[2] ), ",", ".") )
	cTotIt	    := Alltrim( StrTran( Str( MaFisRet(_nX, "IT_TOTAL"), aTamTotIt[1], aTamTotIt[2] ), ",", ".") )
    
    cTES        := MaFisRet(_nX, "IT_TES")
	aTesImpInf  := TesImpInf(cTES)
	For _nI := 1 to Len(aTesImpInf)                                                 
	   cIndImp     := Substr(aTesImpInf[_nI][2],10,1)               
	   cCodImp     := AllTrim(aTesImpInf[_nI][1])               
	   cCpoAlqImp  := "IT_ALIQIV"+cIndImp		               
	   nAliqImp    := MaFisRet(_nX,cCpoAlqImp)	   
	   cCpoBasImp  := "IT_BASEIV"+cIndImp  
	   nBaseImp    := MaFisRet(_nX,cCpoBasImp)	   		    	   
	   cCpoVlrImp  := "IT_VALIV"+cIndImp		               
	   nValorImp   := MaFisRet(_nX,cCpoVlrImp)	   	   
	   If nBaseImp > 0
	      If cCodImp $ cHasar1       //Impostos que somam no IVA
			 nAliqIVA := nAliqIVA + nAliqImp
		  ElseIf cCodImp $ cHasar2   //Impostos internos
			 nAliqInt := nAliqInt + nAliqImp
		  Endif
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Percepcoes                          ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		  
          If cCodImp == "IB2" .And. nValorImp > 0
	         nIB2	+=	nValorImp
          ElseIf cCodImp == "IBP" .And. nValorImp > 0
		     nIBP	+=	nValorImp
          ElseIf cCodImp == "IVP" .And. nValorImp > 0 
             nVlrIVA += nValorImp
          EndIf		  
	   Endif	   
    Next _nI
        
    cAliquota  := AllTrim(Str(nAliqIVA,5,2))+"|"+AllTrim(Str(nAliqInt,4,2))+"|"+cIncluiIVA
    
    nRet  := IFRegItem( nHdlECF,cCodProd,cDescProd,cQuant,cVUnit,'0',cAliquota,cTotItem)		
    If nRet == 1
	   Return (.F.)
	EndIf
Next _nX

If nTotalDesc > 0
   cDescTotal := " |"+Strzero(nTotalDesc,12,2)+"|0|"
   nRet       := IFDescTot( nHdlECF,cDescTotal )   
   If nRet == 1
      Return (.F.)
   EndIf      
Endif
	
If nVlrIVA > 0
   cAliqIVA  := "**.**"
   cTexto    := "Percep. IVA"
   cVlrIVA   := Alltrim(Str(nVlrIVA,14,2))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIVA, @aRet)
   If nRet == 1
      Return (.F.)
   EndIf         
Endif
	
If nIB2 > 0
   cAliqIVA  := "**.**"
   cTexto    := "Perc. IIBB Bs.As."
   cVlrIB    := Alltrim(Str(nIB2,14,2))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)
   If nRet == 1
      Return (.F.)
   EndIf         
Endif
	
If nIBP > 0
   cAliqIVA  := "**.**"
   cTexto    := "Perc. IIBB Cap.Fed"
   cVlrIB    := Alltrim(Str(nIBP,14,2))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)		
   If nRet == 1
      Return (.F.)
   EndIf         
Endif	

nRet  := IFFecharDNFH(nHdlECF, @aRet)  //Fechar o documento DNFH
If nRet == 1
	Return (.F.)
EndIf

Return .T.

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
LOCAL _nI
LOCAL nVlrIVA   := 0
LOCAL nLinCabec := 3
LOCAL nRet      := 1
LOCAL nAliqIVA  := 0
LOCAL nAliqInt  := 0
LOCAL nIB2      := 0
LOCAL nIBP      := 0
LOCAL nAliqImp  := 0
LOCAL nBaseImp  := 0
LOCAL nValorImp := 0
LOCAL nDecimais := MsDecimais(nMoedaNF)
LOCAL nPosHas   := 0
LOCAL nTamDoc   := TamSX3("L1_DOC")[1]
LOCAL cQuant    := ""
LOCAL cVUnit    := ""
LOCAL cTotIt    := ""
LOCAL cAliquota :=""
LOCAL cIncluiIVA:= "s"  //Se T indica que o preco contem IVA incluido. Caso contrario,
                        //o IVA eh discriminado
LOCAL cNumNota  := Space(TamSX3("L1_DOC")[1])                        
LOCAL cTexto    := ""
LOCAL cInfo     := ""
LOCAL cTotItem  
LOCAL cTipoCli  := ""
LOCAL cPdv      := Space(TamSX3("L1_PDV")[1])
LOCAL cCNPJ     := ""
LOCAL cDadosCab := ""
LOCAL cSerieCup := ""
//Argentina
LOCAL cTmpHas   := ""
LOCAL cHasar1   := ""
LOCAL cHasar2   := ""
LOCAL cVlrIB    := ""
LOCAL cVendedor := ""
LOCAL cTES      := "" 
LOCAL cIndImp   := ""
LOCAL cCpoAlqImp:= ""
LOCAL cCpoBasImp:= ""
LOCAL cCpoVlrImp:= ""
LOCAL cCodImp   := ""
LOCAL cVlrIVA   := ""
LOCAL cCodProd  := ""
LOCAL cDescProd := ""
Local cRetorno  := ""

LOCAL aTamQuant := TamSX3("D1_QUANT")
LOCAL aTamUnit  := TamSX3("D1_VUNIT")
LOCAL aTamTotIt := TamSX3("D1_TOTAL")
LOCAL aRet      := {}
Local cEnd      := ""
LOCAL aTesImpInf:= {}

cTmpHas   := GetMV("MV_IMPSIVA",,"IVA|")  //Codigo dos impostos que somam no IVA(Argentina)
nPosHas   := AT("|",cTmpHas)
cHasar1   := Substr(cTmpHas,1,nPosHas-1)
cHasar2   := Substr(cTmpHas,nPosHas+1)
nPosHas   := IIf(nPosHas==0,Len(cTmpHas),nPosHas)

nRet     := IFStatus(nHdlECF, '5', @cRetorno)      
If nRet == 1 
   Return( .F. )
EndIf      
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
cPDV  := aRet[1]   

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
	If !Cuit(cCNPJ,"A1_CGC")
		MsgAlert(STR0002) //"O CUIT do cliente nao e valido, por isso nao e possivel gerar a Nota de Credito. Atualize os dados do cliente!"
		Return( .F. )
	EndIf
Endif
cEnd := RTrim(SA1->A1_END)

SA3->(DbSetOrder(1))
SA3->(DbSeek( xFilial("SA3") + cVendedor ))
If SA3->(Found()) 
   cDadosCab   := Padr(Substr("|4|" + STR0003 + cVendedor + " " + Capital(SA3->(A3_NOME)),1,40),40) //"Vendedor: "
Else
   cDadosCab   := Padr(Substr("|4| ",1,40),40)   
EndIf
	
SE4->(DbSetOrder(1))
SE4->(DbSeek( xFilial("SE4") + cCondicao ))
If SE4->(Found())
   cDadosCab   += Padr(Substr("|5|" + STR0004 + cCondicao + " " + Capital(SE4->E4_DESCRI),1,40),40) //"Cond. Pagto.: "
Else
   cDadosCab   += Padr(Substr("|5| ",1,40),40)      
EndIf

                                     
cSerieCup := Iif( SA1->A1_TIPO $ "NI", "D", "E" )
cInfo     := cSerieCup+"|"+AllTrim(SA1->A1_NOME)+"|"+StrTran(AllTrim(cCNPJ),"-","")+"|"+;
             cTipoCli+"|"+cTipoID+"|"+Padr(cEnd,50)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre documento fiscal               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRet := IFAbreNota(nHdlECF,@cInfo)
aRet := LjStr2Array(@cInfo)
If nRet == 1
   Return( .F. )   
EndIf
cNumNota := StrZero( Val( aRet[3] ), 8 )
cSerie   := IIf( SA1->A1_TIPO $ "INZ", "A  ", "B  " )
//NDC serie A - SA1->A1_TIPO $ "INZ"
//NDC serie B - demais
cNFiscal := cPdv + cNumNota

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
/*
cRetorno   := Space(8)
nRet       := IFPegCupom( nHdlECF, @cRetorno, "N|"+AllTrim(cSerieCup))
If nRet == 1
   Return( .F. )      
EndIf
*/

For _nX := 1 To Len( aCols )

    If aCols[_nx][Len(aCols[_nx])]
   	   Loop
	Endif

	nAliqIVA 	:= 0
	nAliqInt	:= 0
	cVUnit		:=	""

	SB1->( DbSetOrder(1) )
	SB1->( DbSeek( xFilial("SB1") + MaFisRet(_nX, "IT_PRODUTO") ) )
	
    cCodProd    := SB1->B1_COD
    cDescProd   := SB1->B1_DESC
	cQuant	    := Alltrim( StrTran( Str( MaFisRet(_nX, "IT_QUANT"), aTamQuant[1], aTamQuant[2] ), ",", ".") )
	cVUnit	    := Alltrim( StrTran( Str( MaFisRet(_nX, "IT_PRCUNI"), aTamUnit[1], aTamUnit[2] ), ",", ".") )
	cTotIt	    := Alltrim( StrTran( Str( MaFisRet(_nX, "IT_TOTAL"), aTamTotIt[1], aTamTotIt[2] ), ",", ".") )
    
    cTES        := MaFisRet(_nX, "IT_TES")
	aTesImpInf  := TesImpInf(cTES)
	For _nI := 1 to Len(aTesImpInf)                                                 
	   cIndImp     := Substr(aTesImpInf[_nI][2],10,1)               
	   cCodImp     := AllTrim(aTesImpInf[_nI][1])               
	   cCpoAlqImp  := "IT_ALIQIV"+cIndImp		               
	   nAliqImp    := MaFisRet(_nX,cCpoAlqImp)	   
	   cCpoBasImp  := "IT_BASEIV"+cIndImp  
	   nBaseImp    := MaFisRet(_nX,cCpoBasImp)	   		    	   
	   cCpoVlrImp  := "IT_VALIV"+cIndImp		               
	   nValorImp   := MaFisRet(_nX,cCpoVlrImp)	   	   
	   If nBaseImp > 0
	      If cCodImp $ cHasar1       //Impostos que somam no IVA
			 nAliqIVA := nAliqIVA + nAliqImp
		  ElseIf cCodImp $ cHasar2   //Impostos internos
			 nAliqInt := nAliqInt + nAliqImp
		  Endif
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Percepcoes                          ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		  
          If cCodImp == "IB2" .And. nValorImp > 0
	         nIB2	+=	nValorImp
          ElseIf cCodImp == "IBP" .And. nValorImp > 0
		     nIBP	+=	nValorImp
          ElseIf cCodImp == "IVP" .And. nValorImp > 0 
             nVlrIVA += nValorImp
          EndIf		  
	   Endif	   
    Next _nI

    cAliquota  := Str(nAliqIVA,5,2)+"|"+Str(nAliqInt,4,2)+"|"+cIncluiIVA
    
    nRet := IFRegItem( nHdlECF,cCodProd,cDescProd,cQuant,cVUnit,'0',cAliquota,cTotItem)		
    
    If nRet == 1 
       Return(.F.)
    EndIf
Next _nX
	
If nVlrIVA > 0
   cAliqIVA  := "**.**"
   cTexto    := "Percep. IVA"
   cVlrIVA   := Alltrim(Str(nVlrIVA,14,2))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIVA, @aRet)
   If nRet == 1
      Return(.F.)
   EndIf         
Endif
	
If nIB2 > 0
   cAliqIVA  := "**.**"
   cTexto    := "Perc. IIBB Bs.As."
   cVlrIB    := Alltrim(Str(nIB2,14,2))
   aRet      := {}
   nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)
   If nRet == 1
      Return(.F.)
   EndIf         
Endif
	
If nIBP > 0
    cAliqIVA  := "**.**"
	cTexto    := "Perc. IIBB Cap.Fed"
	cVlrIB    := Alltrim(Str(nIBP,14,2))
	aRet      := {}
    nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cVlrIB, @aRet)		
    If nRet == 1
       Return(.F.)
    EndIf          
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o cupom e imprime a mensagem              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRet := IFFechaCup(nHdlECF,cTexto)
If L010AskImp(.F.,nRet)
	Return (.F.)
EndIf

Return .T.
