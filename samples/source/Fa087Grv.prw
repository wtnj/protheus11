#INCLUDE "FA087GRV.ch"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³Fa087Grv  ³ Autor ³ Diego Rivero           ³Fecha ³ 17.02.03³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o recibo na impressora fiscal                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Recibo(FINA087A)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa087Grv( )

If nModulo != 12 .Or. !IIf(Type("lFiscal")#"U",lFiscal,.F.) .Or. cPaisLoc != "ARG"
	Return
EndIf

LjMsgRun( STR0001,, { || Fa087aPrint() } ) //"Imprimindo Recibo na Impressora Fiscal..."

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³Fa087aPrin³ Autor ³ Diego Fernando Rivero  ³Fecha ³ 17.04.01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Imprime o recibo na Impressora Fiscal                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fa087Grv                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa087aPrint()

LOCAL nTotValor  := 0
LOCAL nX, nY                                       
LOCAL nRet
LOCAL nNewPos
LOCAL nCopias    := 2
LOCAL cTotValor  := "0.00"
LOCAL cNumRecibo := cRecibo  //Numero do recibo
LOCAL cTipoCli   := ""
LOCAL cTipoID    := ""
LOCAL cCNPJ      := ""
LOCAL cDadosCli  := ""
LOCAL cDadosCab  := "| | |"
LOCAL cCodigo    := " "
LOCAL cDescricao := Space(20)
LOCAL cDesricao  := ""
LOCAL cIncluiIVA := "T"  //Se T indica que o preco contem IVA incluido. Caso contrario,
                         //o IVA eh discriminado
LOCAL cTotItem   
LOCAL cTexto     := ""
LOCAL aTit       := {}
LOCAL aDadosRec  := {} 
LOCAL aRet       := {}

aDadosRec  := Fa087aDados(cNumRecibo)

For nX := 1 To Len( aDadosRec )

	If Alltrim( aDadosRec[nX][1] ) $ "RG-/RI-/RB-/CH/PG/TJ/EF"
	   nTotValor += aDadosRec[nX][6]
	ElseIf Alltrim( aDadosRec[nX][1] ) == "TB"
       Aadd( aTit, Padr( Left(aDadosRec[nX][2],6) + " " + Left(aDadosRec[nX][3],1) + " " + aDadosRec[nX][4] + "  "  + aDadosRec[nX][7] + "    $ " + Str(aDadosRec[nX][6],10,2),50) )
	ElseIf Alltrim( aDadosRec[nX][1] ) == "RA"
       Aadd( aTit, Padr( STR0002 + Left( aDadosRec[nX][4], 6 ) + STR0003  + aDadosRec[nX][7] + STR0004 + Str(aDadosRec[nX][6],10,2),50 ) ) //"Antec. Nro. "###" do "###" por $ "
	EndIf

Next nX

cTotValor := Fa087aNum( nTotValor )

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

If SA1->A1_TIPO == 'F'
	cCNPJ		:=	SA1->A1_RG
	cTipoID	    :=	"2"
Else
	cCNPJ		:=	Alltrim( SA1->A1_CGC )
	cTipoID	    :=	"C"
Endif
cCNPJ	:=	StrTran( AllTrim(cCNPJ), "-", "" )

cDadosCli  := Padr(Substr(SA1->A1_NOME,1,30),30) + ;       
              "|" + StrTran( AllTrim(cCNPJ), "-", "" ) + ;
              "|" + cTipoCli + ;
              "|" + cTipoID

nRet := IFAbrirDNFH(nHdlECF, "x", cDadosCli, cDadosCab, cNumRecibo, @aRet)  //Abre o recibo
If L010AskImp(.F.,nRet)
   Return (.F.)
EndIf   

cAliquota  := "00.00"+"|"+"0.00"+"|"+cIncluiIVA

nRet := IFRegItem( nHdlECF,cCodigo,cDescricao,"1.00",cTotValor,"0",cAliquota,cTotItem)  //Registra o total do recibo		
If nRet == 1
   Return( .F. )      
EndIf

If Len( aTit ) < 10
	For nY := 1 To Len( aTit )
	    nRet  := IFRecibo(nHdlECF,aTit[nY],@aRet)  //ReceiptText - Imprime as linhas do recibo
        If nRet == 1
           Return( .F. )      
        EndIf	    
	Next nY
Else
	For nY := 1 To 9
	    nNewPos := Iif( ( nY + 9 ) <= Len( aTit ), nY + 9, 0 )
	    cTexto  := aTit[nY]+IIf(nNewPos <> 0," * " + aTit[nNewPos], "" )
	    nRet    := IFRecibo(nHdlECF,cTexto,@aRet)  //ReceiptText - Imprime as linhas do recibo   
        If nRet == 1
           Return( .F. )      
        EndIf	    	    
	Next nY
EndIf

aRet  := {}
nRet  := IFFecharDNFH(nHdlECF, @aRet)
If L010AskImp(.F.,nRet)
   Return (.F.)
EndIf   

For nX := 2 To nCopias
    nRet  := IFReimprime(nHdlEcf)  //Imprime copias
    If L010AskImp(.F.,nRet)
       Return (.F.)
    EndIf   
Next nX
    
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³Fa087aDado³ Autor ³ Diego Fernando Rivero  ³Fecha ³ 17.04.01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Carrega um array com os dados do recibo emitido            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fa087Grv                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa087aDados(cNumRecibo)

LOCAL aArea   := GetArea()
LOCAL aRet    := { }
LOCAL cDoc, cTipoDoc, cValor, cData, cSerie

DbSelectArea("SEL")
DbSetOrder(1)
DbSeek( xFilial() + cNumRecibo )

While !Eof() .And. EL_RECIBO == cNumRecibo .And. EL_FILIAL == xFilial()

	cDoc	:= EL_NUMERO
	cTipoDoc:= EL_TIPODOC
	cTipo	:= EL_TIPO
	nValor	:= EL_VALOR
	cData	:= Fa087aData(EL_EMISSAO)
	cSerie	:= AllTrim(EL_PREFIXO)

	Aadd( aRet , { cTipoDoc, cTipo, cSerie, cDoc, cData, nValor, Dtoc(EL_EMISSAO) } )
	DbSkip()

EndDo

RestArea(aArea)

Return( aRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³Fa087aNum ³ Autor ³ Diego Fernando Rivero  ³Fecha ³ 17.04.01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Converte os numeros em formato que a impressora reconheca  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FA087Grv                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa087aNum(nNumero)
LOCAL cRet := ''
LOCAL aTamValor  := TamSX3("EL_VALOR")

cRet := Str(nNumero, aTamValor[1], aTamValor[2])
cRet := Alltrim( cRet )
cRet := StrTran( cRet, ",", "." )

Return( cRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³Fa087aData³ Autor ³ Diego Fernando Rivero  ³Fecha ³ 17.04.01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Converte as datas em um formato que a impressora reconheca ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fa087Grv                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa087aData( dData )

LOCAL cRet := ''

cRet := DTOC( dData )
cRet := SubStr( cRet, 7, 2 ) + SubStr( cRet, 4, 2 ) + SubStr( cRet, 1, 2 )

Return( cRet )
