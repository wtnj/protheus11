/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN053  บAutor  ณMarcos R Roquitski  บ Data ณ  30/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Compensacao de adiantamento dos pedido de compras.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"
//#INCLUDE "FINA340.CH"

User Function Nhfin053()

SetPrvt("AROTINA,CCADASTRO,")

PRIVATE	aTitulos := {}
PRIVATE	cPrefixo := SE2->E2_PREFIXO
PRIVATE	cNum := SE2->E2_NUM
PRIVATE	cTipoTit := SE2->E2_TIPO
PRIVATE	cFornece := SE2->E2_FORNECE
PRIVATE	cLoja := SE2->E2_LOJA
PRIVATE	cParcela := SE2->E2_PARCELA
PRIVATE cPedido := SE2->E2_PEDIDO
PRIVATE lDebito := .F.
PRIVATE	cTipodoc := " "
PRIVATE cTipodc :=" "
PRIVATE nHdlPrv := 0
PRIVATE cSaldo
PRIVATE nSaldo := 0
PRIVATE nValor := 0
PRIVATE nMoeda := 0
PRIVATE dBaixa := dDataBase
PRIVATE cPedido := SE2->E2_PEDIDO
PRIVATE lMarca := .F.

aRotina := { { "Pesquisar"        , "AxPesqui"  , 0 ,1},;
             { "Autorizacao Pgto" , 'U_fLibPagto', 0 ,3},;
             { "Compensacao"      , 'U_fLibera', 0 ,3}}

cCadastro := "Adiantamento ao Fornecedor"
DbSelectArea("SE2")
SE2->(DbGoTop())
mBrowse(,,,,"SE2",,"E2_SALDO==0",25)
SE2->(DbGoTop())

Return(.T.)

User Function fLibPagto()
If U_Nhcom037()
	If SAJ->AJ_APRPA = 'S'
		If !Empty(SE2->E2_PEDIDO)
			If MsgBox("Confirma autorizacao de pagamento !","Autorizacao de pagamento","YESNO")
				fAutoriza()
			Endif
		Else
			MsgBox("Nao existe pedido vinculado a este Lancamento!","Autorizacao de pagamento","ALERT")		
		Endif	
	Else
		MsgBox("Usuario nao autorizado a liberar PA!","Autorizacao de pagamento","ALERT")
	Endif
Endif
Return(.T.)

Static Function fAutoriza()
	RecLock("SE2",.F.)
	SE2->E2_SALDO := SE2->E2_VALOR
	SE2->E2_BAIXA := Ctod(Space(08))
	
    MsUnlock("SE2")
Return(.T.)


User Function fLibera()
	
	cPrefixo := SE2->E2_PREFIXO
	cNum := SE2->E2_NUM
	cTipoTit := SE2->E2_TIPO
	cFornece := SE2->E2_FORNECE
	cLoja := SE2->E2_LOJA
	cParcela := SE2->E2_PARCELA
	cPedido := SE2->E2_PEDIDO
	nSaldo := SE2->E2_SALDO
	cSaldo := TRANSFORM( nSaldo, "@E 9999,999,999.99" )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Titulo a ser compensado			 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@  88,31  To 275,485 Dialog oDlgTp TITLE "Compensacao de Titulos a Pagar"

	@ 07, 006 SAY "Prefixo"    SIZE 21, 7
	@ 07, 032 SAY "Numero"     SIZE 22, 7
	@ 06, 072 SAY "Parcela"    SIZE 23, 7
	@ 06, 098 SAY "Tipo"       SIZE 14, 7
	@ 06, 124 SAY "Fornecedor" SIZE 34, 7
	@ 06, 195 SAY "Loja"       SIZE 14, 7
	@ 38, 006 SAY "Saldo"      SIZE 34, 7
	@ 38, 060 SAY "Moeda"      SIZE 21, 7
	@ 38, 085 SAY "Valor a compensar" SIZE 55, 7
	@ 38, 142 SAY "Data da Baixa" SIZE 45, 7

	@ 15, 006 GET cPrefixo SIZE 19, 10 
	@ 15, 032 GET cNum VALID !EMPTY(cNum)	SIZE 39, 10 
	@ 15, 072 GET cParcela SIZE 20, 10 
   	@ 15, 098 GET cTipoTit Picture "@!"  Valid !Empty(cTipoTit) SIZE 12, 10 
	@ 15, 124 GET cFornece Valid Fa340For(cFornece,cLoja) SIZE 70, 10 
	@ 15, 195 GET cLoja Valid Fa340For(cFornece,cLoja) SIZE 16, 10 
	@ 47, 006 GET cSaldo WHEN .F. SIZE 41, 10  
	@ 47, 060 GET nMoeda WHEN .F.	 SIZE 18, 10 
	@ 47, 085 GET nValor Picture	"@E 9999,999,999.99" Valid nValor >= 0 .AND. nValor <= nSaldo SIZE 52, 10
	@ 47, 142 GET dBaixa Valid DtMovFin(dBaixa) SIZE 41, 10 

	@ 68, 167 BMPBUTTON TYPE 1 ACTION fMonta()
	@ 68, 195 BMPBUTTON TYPE 2 ACTION Close(oDlgTp)

	ACTIVATE DIALOG oDlgTp CENTERED

Return(.t.)  


Static Function  fMonta()
LOCAL oOk := LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo := LoadBitmap( GetResources(), "LBNO" )

	fTitulos()
	
    If Len(aTitulos) > 0
    
		nQtdTit := 0	 // quantidade de titulos,mostrado no rodape do browse

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Titulos a compensar         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nOpca   := 0

		DEFINE MSDIALOG oDlg TITLE cCadastro From 12,1.5 To 25.6,79.5 OF oMainWnd

		//@ 0.5, 0.5 TO 5.4, 38.3 LABEL cCadastro //OF oDlg
		@ 1.0, 1.0 LISTBOX oTitulo   VAR cVarQ Fields;
			  HEADER "","Prefixo","Numero","Parcela","Tipo","Saldo do Titulo","Valor compensado","Fornecedor";
			  COLSIZES 12, GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
			  GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBB"),;
			  GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB");
			  SIZE 293,54.5 ON DBLCLICK (aTitulos:=fFA340Troca(oTitulo:nAt,aTitulos),oTitulo:Refresh()) NOSCROLL

			oTitulo:SetArray(aTitulos)
			oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
			aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
			aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
			aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
			aTitulos[oTitulo:nAt,7]}}

		DEFINE SBUTTON FROM 80,234.6 TYPE 1 ACTION fFa340Ok() ENABLE
		DEFINE SBUTTON FROM 80,264.6 TYPE 2 ACTION oDlg:End() ENABLE
		ACTIVATE MSDIALOG oDlg  CENTERED

	Else
		Alert("Nao existe lancamentos a compensar !")
	Endif

Return(.T.)


Static Function fFa340Ok()
Local lReturn := .F.
	If MsgYesNo("Confirma marcacao de Titulos ?","Atencao")
		fGravaSe5()
		lReturn := .T.
	Endif
	oDlg:End()
Return(lReturn)


STATIC Function fFa340VTit(aTitulo,cTipoTit,cValor)
LOCAL nValor
	cValor := IIF (cValor == NIL,aTitulo,cValor)
	nValor := DesTrans(cValor)
Return nValor


Static Function fFA340Troca(nIt,aArray)
Local oDlg
Local nOpca := 0

	cValor  := fFa340VTit(aTitulos[nIt,6])
	cSaldo  := fFa340VTit(aTitulos[nIt,5])
	nValtot := 0

	aArray[nIt,8] := !aArray[nIt,8]

	If aArray[nIt,8]

		DEFINE MSDIALOG oDlgCp FROM	69,70 TO 160,331 TITLE "Compensacao de Titulos a Pagar" PIXEL

		@ 3, 2 TO 22, 128
		@ 7, 68 GET cValor Picture "@E 9999,999,999.99" SIZE 54, 10
		@ 8, 9 SAY "Valor a compensar"  SIZE 54, 7
		DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca:=1,If((cValor <= cSaldo .AND. cValor > 0),oDLgCp:End(),nOpca:=0))
		DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (aArray[nIt,8]:=.F.,oDlgCp:End())
	
		ACTIVATE MSDIALOG oDlgCp

		IF nOpca == 1
			aArray[nIt,6]:=Transf(cValor,"@E 9999,999,999.99")
			For Wq := 1 to Len(aArray)
			   If aArray[Wq,8]
			      nValtot += fFa340VTit(aArray[Wq,6])
			   Endif
			Next
		Endif
	Else
    	If !aArray[nIt,8]
			aArray[nIt,6]:=Transf(0,"@E 9999,999,999.99")
		Endif
		For I:=1 to Len(aArray)
		   If aArray[I,8]
		      nValtot+=fFa340VTit(aArray[i,6])
		   Endif
		Next
	Endif

Return aArray

STATIC Function fTitulos()
Local nRecno := SE2->(Recno())
	aTitulos := {}
	If !Empty(cPedido)
		DbSelectArea("SE2")
		SE2->(DbSetOrder(13))	
		SE2->(DbSeek(xFilial("SE2")+cPedido+cFornece+cLoja))
		While !Eof() .AND. SE2->E2_PEDIDO == cPedido
			If (Alltrim(SE2->E2_TIPO) == "PA" .AND. cFornece == SE2->E2_FORNECE .AND. cLoja == SE2->E2_LOJA .AND. SE2->E2_SALDO > 0)
				Aadd(aTitulos,{E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,Transform(E2_SALDO,"@E 9999,999,999.99"),Transform(E2_SALDO,"@E 9999,999,999.99"),E2_NOMFOR,lMarca,E2_FORNECE,E2_LOJA,E2_NATUREZ})
			Endif
			SE2->(DbSkip())
		Enddo
		SE2->(DbSetOrder(1))
		SE2->(DbGoto(nRecno))
	Endif		

Return aTitulos


Static Function fa340For( cFornecedor, cLoja )
Local cAlias:=Alias()
If Empty(cFornecedor)
	Return .F.
Endif
cAlias:=Alias()
dbSelectArea("SA2")
dbSetOrder(1)
cLoja:=Iif(cLoja == Nil .or. (Empty(cLoja) .and. Empty(SE2->E2_LOJA)),"",cLoja)
If !(dbSeek(xFilial("SA2")+cFornecedor+cLoja))
	Return .f.
Endif
dbSelectArea(cAlias)
Return ( .T. )



Static Function fGravaFin()
Local lReturn := .T., m, l,aVenc, _cNomFor, _cNaturez

	RecLock("SE2",.F.)
	SE2->E2_TIPO := "PA"
    MsUnlock("SE2")

	// Grava no movimento Bancario
	RecLock("SE5",.T.)
		SE5->E5_FILIAL  := xFilial("SE5")
		SE5->E5_DATA    := dDataBase
		SE5->E5_TIPO    := "PA"
		SE5->E5_VALOR   := SE2->E2_VALOR
		SE5->E5_NATUREZ := SE2->E2_NATUREZ
		SE5->E5_BANCO   := _cBanco
		SE5->E5_AGENCIA := _cAgencia
		SE5->E5_CONTA   := _cConta
		SE5->E5_NUMCHEQ := _cNumChq 
		SE5->E5_RECPAG  := "P"
		SE5->E5_BENEF   := SE2->E2_FORNECE
		SE5->E5_HISTOR  := _cHistor
		SE5->E5_TIPODOC := "PA"
		SE5->E5_VLMOED2 := SE2->E2_VALOR 
		SE5->E5_NUMERO  := SE2->E2_NUM
		SE5->E5_CLIFOR  := SE2->E2_FORNECE
		SE5->E5_LOJA    := SE2->E2_LOJA
		SE5->E5_DTDIGIT := dDataBase
		SE5->E5_MOTBX   := "NOR"
		SE5->E5_DTDISPO := dDataBase
		SE5->E5_FORNECE := SE2->E2_FORNECE
	MsUnlock("SE5")
	Close(DlgDados)
	
Return(.T.)	



Static Function fGravaSe5()
Local lReturn := .T., m, _nSaldo := 0
LOCAL oOk := LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo := LoadBitmap( GetResources(), "LBNO" )

	DbSelectArea("SE2")
	SE2->(DbGoTop())

	For m:=1 to Len(aTitulos)
		If aTitulos[m,8]
			_nSaldo +=Destrans(aTitulos[m,6])
		Endif
	Next

	SE2->(DbSeek(xFilial("SE2")+cPrefixo+cNum+cParcela+cTipotit+cFornece+cLoja))
	If SE2->(Found())
		If (SE2->E2_SALDO - _nSaldo <=0)
			RecLock("SE2",.F.)
			SE2->E2_SALDO   -= _nSaldo
			SE2->E2_VALLIQ  += _nSaldo
			SE2->E2_BAIXA   := dDataBase
			SE2->E2_MOVIMEN := dDataBase
		    MsUnlock("SE2")
		Else
			RecLock("SE2",.F.)
			SE2->E2_SALDO -= _nSaldo
	    	MsUnlock("SE2")
	    Endif
    Endif

    m := 1
	For m:=1 to Len(aTitulos)
		If aTitulos[m,8]
			SE2->(DbSeek(xFilial("SE2")+aTitulos[m,1]+aTitulos[m,2]+aTitulos[m,3]+aTitulos[m,4]+aTitulos[m,9]+aTitulos[m,10]))
			If SE2->(Found())
				If (SE2->E2_SALDO - Destrans(aTitulos[m,6]) <=0)
					RecLock("SE2",.F.)
					SE2->E2_SALDO   -= Destrans(aTitulos[m,6])
					SE2->E2_VALLIQ  += Destrans(aTitulos[m,6])
					SE2->E2_BAIXA   := dDataBase
					SE2->E2_MOVIMEN := dDataBase
				    MsUnlock("SE2")
				Else
					RecLock("SE2",.F.)
					SE2->E2_SALDO -= Destrans(aTitulos[m,6])
				    MsUnlock("SE2")
				Endif
		    Endif
		Endif
	Next

    m := 1 // Gera movimento bancario
	For m:=1 to Len(aTitulos)
		If aTitulos[m,8]

			SE2->(DbSeek(xFilial("SE2")+cPrefixo+cNum+cParcela+cTipotit+cFornece+cLoja))
			If SE2->(Found())

				// Grava no movimento Bancario Compens. Adiantamento
				RecLock("SE5",.T.)	
				SE5->E5_FILIAL  := xFilial("SE5")
				SE5->E5_DATA    := dDataBase
				SE5->E5_TIPO    := cTipoTit
				SE5->E5_VALOR   := Destrans(aTitulos[m,6])
				SE5->E5_NATUREZ := SE2->E2_NATUREZ
				SE5->E5_DOCUMEN := aTitulos[m,1]+aTitulos[m,2]+aTitulos[m,3]+aTitulos[m,4]
				SE5->E5_RECPAG  := "P"
				SE5->E5_BENEF   := SE2->E2_NOMFOR
				SE5->E5_HISTOR  := "Compens. Adiantamento"
				SE5->E5_TIPODOC := "CP"
				SE5->E5_VLMOED2 := Destrans(aTitulos[m,6])
				SE5->E5_LA      := 'N'
				SE5->E5_PREFIXO := SE2->E2_PREFIXO
				SE5->E5_NUMERO  := SE2->E2_NUM
				SE5->E5_CLIFOR  := SE2->E2_FORNECE
				SE5->E5_LOJA    := SE2->E2_LOJA
				SE5->E5_DTDIGIT := dDataBase
				SE5->E5_MOTBX   := "CMP"
				SE5->E5_SEQ     := Str(m)
				SE5->E5_DTDISPO := dDataBase
				SE5->E5_FORNECE := aTitulos[m,9]
				SE5->E5_FORNADT := aTitulos[m,9]
				SE5->E5_LOJAADT := aTitulos[m,10]
				SE5->E5_FILORIG := xFilial("SE5")
				MsUnlock("SE5")


				RecLock("SE5",.T.)
				SE5->E5_FILIAL  := xFilial("SE5")
				SE5->E5_DATA    := dDataBase
				SE5->E5_TIPO    := "PA"
				SE5->E5_VALOR   := Destrans(aTitulos[m,6])
				SE5->E5_DOCUMEN := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO
				SE5->E5_NATUREZ := aTitulos[m,11]
				SE5->E5_RECPAG  := "P"
				SE5->E5_BENEF   := SE2->E2_NOMFOR
				SE5->E5_HISTOR  := "Baixa por compensacao"
				SE5->E5_TIPODOC := "BA"
				SE5->E5_VLMOED2 := Destrans(aTitulos[m,6])
				SE5->E5_LA      := 'N'
				SE5->E5_PREFIXO := aTitulos[m,1]
				SE5->E5_NUMERO  := aTitulos[m,2]
				SE5->E5_CLIFOR  := SE2->E2_FORNECE
				SE5->E5_LOJA    := SE2->E2_LOJA
				SE5->E5_DTDIGIT := dDataBase
				SE5->E5_MOTBX   := "CMP"				
				SE5->E5_DTDISPO := dDataBase
				SE5->E5_FORNECE := SE2->E2_FORNECE
				SE5->E5_FORNADT := SE2->E2_FORNECE
				SE5->E5_LOJAADT := SE2->E2_LOJA
				MsUnlock("SE5")

            Endif
		Endif
	Next
	SE2->(DbGoTop())


Return(.T.)	


Static Function foDlgTp()
	Close(oDlgTp)
	DbSelectArea("SE2")
	SE2->(DbGoTop())
Return(.T.)
