/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN089  ºAutor  ³Marcos R. Roquitski º Data ³  23/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao automatica de faturas por fornecedor/vencimento.   º±±
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

User Function Nhfin089()

SetPrvt("_cFornec,_cFatura,_nCont,_nNumFat")

_cFatura := Space(09)
_nCont   := 1                                      
_nValFat := 0 
_nNumFat := 0
				
If !Pergunte("NHFIN089",.T.)
	Return
Endif

If MsgBox("Confirme processamento das Notas Fiscais ?","Faturas automaticas","YESNO")

	Processa({|| GeraTmp()}, "Gerando dados...") 
	Processa({|| TotFatu()}, "Gerando dados...") 
			
	If _nValFat > 0
		If MsgBox("Numero de Titulos: "+Transform(_nNumFat,"9999")+ " Valor da Fatura: "+Transform(_nValFat,"@E 999,999,999.99"),"Faturas automaticas","YESNO")
			Processa({|| GeraFat()}, "Gerando faturas.")
		Else
			Alert("Operacao nao confirmada!")
		Endif
	Else
		Alert("Nao houve titulos selecionados!")
	Endif	

	DbSelectArea("TMP_E2")
	DbCloseArea("TMP_E2")

Endif	

Return

Static Function GeraTmp() 
Local cQuery
		
	cQuery := "SELECT * FROM " + RetSqlName('SE2') + " SE2 " 
  	cQuery += " WHERE SE2.E2_VENCREA BETWEEN '"+ Dtos(Mv_par01) + "' AND '"+ Dtos(Mv_par02) + "'"                      
	cQuery += " AND SE2.E2_FORNECE BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "'"	 
	cQuery += " AND SE2.E2_LOJA BETWEEN '" + Mv_par05 + "' AND '" + Mv_par06 + "'" 
	cQuery += " AND SE2.E2_TIPO = 'NF' " 
	cQuery += " AND SE2.E2_SALDO > 0 " 
	cQuery += " AND SE2.E2_NUMBOR = ' ' " 
	cQuery += " AND SE2.D_E_L_E_T_ = ' ' " 
    cQuery += " AND SE2.E2_FILIAL = '" + xFilial("SE2")+ "'"
	cQuery += " ORDER BY E2_FORNECE,E2_LOJA" 
	
    //MemoWrit('C:\TEMP\NHFIN048.SQL',cQuery) 
	TCQUERY cQuery NEW ALIAS "TMP_E2"
 
Return


Static Function GeraFat()
SE2->(DbSetOrder(1))
DbSelectArea("TMP_E2") 
TMP_E2->(DbGotop()) 

_nValFat    := 0 
_nNumFat    := 0
_nE2BaseCof := 0
_nE2BasePis := 0
_nE2BaseCsl := 0
_nE2Pis     := 0
_nE2Cofins  := 0
_nE2Csll    := 0


While !TMP_E2->(Eof())

	_nCont   := Val(GetMv("MV_FIN089")) + 1

	GetMV("MV_FIN089")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := StrZero(_nCont,3)
	MsUnLock("SX6")


	_cNomeRe := TMP_E2->E2_NOMFOR
	_cFornec := TMP_E2->E2_FORNECE
	_cLoja   := TMP_E2->E2_LOJA
	_cFatura := Substr(Dtos(dDataBase),7,2)+ Substr(Dtos(dDataBase),5,2)+ Substr(Dtos(dDataBase),3,2)+ StrZero(_nCont,3)

	While !TMP_E2->(Eof()) .and. TMP_E2->E2_FORNECE == _cFornec
	
		If SE2->(DbSeek(xFilial("SE2") + TMP_E2->E2_PREFIXO + TMP_E2->E2_NUM + TMP_E2->E2_PARCELA + TMP_E2->E2_TIPO + TMP_E2->E2_FORNECE + TMP_E2->E2_LOJA))
		              
			_cNature    := SE2->E2_NATUREZ
			_nValFat    += SE2->E2_SALDO
			_cVencto    := SE2->E2_VENCREA
			_cE2cc      := SE2->E2_CC
			_nE2BaseCof += SE2->E2_BASECOF
			_nE2BasePis += SE2->E2_BASEPIS
			_nE2BaseCsl += SE2->E2_BASECSL

			_nE2Cofins  += SE2->E2_COFINS
			_nE2Pis     += SE2->E2_PIS
			_nE2Csll    += SE2->E2_CSLL

			// Baixa titulo
			RecLock("SE2",.F.)
			SE2->E2_BAIXA	 := dDataBase
			SE2->E2_VALLIQ	 := SE2->E2_SALDO
			SE2->E2_JUROS	 := 0
			SE2->E2_DESCONT  := 0
			SE2->E2_SALDO	 := 0
			SE2->E2_MOVIMEN  := dDataBase
			SE2->E2_FATURA   := _cFatura
			SE2->E2_FATPREF  := 'FA'
			SE2->E2_TIPOFAT  := 'FT'
			SE2->E2_DTFATUR  := dDataBase
			SE2->E2_FLAGFAT  := "S"
			SE2->E2_FATFOR   :=  _cFornec
			SE2->E2_FATLOJ   :=  _cLoja
			MsUnlock("SE2")

			// Grava movimento bancario
			RecLock("SE5",.T.)
			SE5->E5_FILIAL		:= xFilial("SE5")
			SE5->E5_DATA		:= dDataBase
			SE5->E5_VALOR		:= SE2->E2_VALOR
			SE5->E5_VLMOED2     := SE2->E2_VALOR
			SE5->E5_NATUREZ	    := SE2->E2_NATUREZ
			SE5->E5_RECPAG		:= "P"
			SE5->E5_TIPO		:= SE2->E2_TIPO
			SE5->E5_TIPODOC  	:= "BA"
			SE5->E5_HISTOR		:= "Bx.p/Emiss.Fatura " + _cFatura
			SE5->E5_PREFIXO     := SE2->E2_PREFIXO
			SE5->E5_NUMERO		:= SE2->E2_NUM
			SE5->E5_PARCELA	    := SE2->E2_PARCELA
			SE5->E5_FORNECE	    := SE2->E2_FORNECE
			SE5->E5_CLIFOR		:= SE2->E2_FORNECE
			SE5->E5_LOJA		:= SE2->E2_LOJA
			SE5->E5_DTDIGIT     := dDataBase
			SE5->E5_MOTBX		:= "FT"
			SE5->E5_SEQ			:= '01'
			SE5->E5_DTDISPO	    := dDataBase
			SE5->E5_BENEF		:= SE2->E2_NOMFOR
			SE5->E5_FILORIG     := xFilial("SE5")

		Endif	
		TMP_E2->(DbSkip())

	Enddo	
								
	If _nValFat > 0
		RecLock("SE2",.T.)
		SE2->E2_FILIAL 	:=  xFilial("SE2")
		SE2->E2_NUM 	:=  _cFatura
		SE2->E2_PREFIXO	:=  'FA'
		SE2->E2_PARCELA	:=  'A'
		SE2->E2_NATUREZ	:=  _cNature
		SE2->E2_VENCTO 	:=  dDataBase
		SE2->E2_VENCREA	:=  dDataBase
		SE2->E2_VENCORI :=  dDataBase
		SE2->E2_EMISSAO	:=  dDatabase
		SE2->E2_EMIS1	:=  dDatabase
		SE2->E2_TIPO	:=  "FT"
		SE2->E2_FORNECE	:=  _cFornec
		SE2->E2_LOJA	:=  _cLoja
		SE2->E2_VALOR	:=  _nValFat
		SE2->E2_SALDO	:=  _nValFat
		SE2->E2_MOEDA	:=  1
		SE2->E2_FATURA 	:=  "NOTFAT"
		SE2->E2_NOMFOR 	:= 	_cNomeRe 
		SE2->E2_VLCRUZ	:=  _nValFat
		SE2->E2_ORIGEM 	:=  "FINA290"
		SE2->E2_FILORIG :=  xFilial("SE2")
		SE2->E2_MULTNAT :=  "2"
		SE2->E2_BASECOF := _nE2BaseCof
		SE2->E2_BASEPIS := _nE2BasePis
		SE2->E2_BASECSL := _nE2BaseCsl
		SE2->E2_PRETPIS := "1"
		SE2->E2_PRETCOF := "1"
		SE2->E2_PRETCSL := "1"
		SE2->E2_PIS     := _nE2Pis
		SE2->E2_COFINS  := _nE2Cofins
		SE2->E2_CSLL    := _nE2Csll
		
		_nE2BaseCof     := 0
		_nE2BasePis     := 0
		_nE2BaseCsl     := 0
		_nE2Pis         := 0
		_nE2Cofins      := 0
		_nE2Csll        := 0
		
		SA2->(DbSetOrder(1))
		DbSelectArea("SE2")
		If SA2->(DbSeek(xFilial("SA2")+ SE2->E2_FORNECE + SE2->E2_LOJA))
			If !Empty(SA2->A2_CGC) .And. Alltrim(SE2->E2_TIPO) == 'FT'
				If SA2->A2_BANCO == '001'
					SE2->E2_PORTADO = '990'
				Elseif SA2->A2_BANCO == '341'
					SE2->E2_PORTADO = '880'
				Else
					If SE2->E2_SALDO >= 3000
						SE2->E2_PORTADO = '998'		
					Else
						SE2->E2_PORTADO = '999'				
					Endif	
				Endif	
			Endif
		Endif	
		MsUnlock("SE2")
		Alert("Foi gerando a Fatura: "+_cFatura + ' Valor da Fatura: '+Transform(_nValFat,'@E 999,999,999.99'))
		_nValFat := 0		

	Endif

Enddo

Return 


//
Static Function TotFatu()
SE2->(DbSetOrder(1))
DbSelectArea("TMP_E2") 
TMP_E2->(DbGotop()) 


While !TMP_E2->(Eof())

	_cNomeRe := TMP_E2->E2_NOMFOR
	_cFornec := TMP_E2->E2_FORNECE
	_cLoja   := TMP_E2->E2_LOJA
	_cFatura := Substr(Dtos(dDataBase),7,2)+ Substr(Dtos(dDataBase),5,2)+ Substr(Dtos(dDataBase),3,2)+ StrZero(_nCont,3)

	While !TMP_E2->(Eof()) .and. TMP_E2->E2_FORNECE == _cFornec
	
		If SE2->(DbSeek(xFilial("SE2") + TMP_E2->E2_PREFIXO + TMP_E2->E2_NUM + TMP_E2->E2_PARCELA + TMP_E2->E2_TIPO + TMP_E2->E2_FORNECE + TMP_E2->E2_LOJA))
		              
			_cNature := SE2->E2_NATUREZ
			_nValFat += SE2->E2_SALDO
			_cVencto := SE2->E2_VENCREA
			_cE2cc   := SE2->E2_CC
			_nNumFat++

		Endif	
		TMP_E2->(DbSkip())

	Enddo	
								
Enddo


Return