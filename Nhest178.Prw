/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST178  ºAutor  ³Marcos R Roquitski  º Data ³  12/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusao no cadastro de Inventario.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fundicao e Usinagem WHB                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhEst178()

SetPrvt("_cEtiq,_cCont,_cCod,_cDesc,_cLocal,_dData,_cLocaliz,_nQuant,_cLot,_cDoc,_cFlag,_cLott,_cOper,_cTipo")

_cEtiq    := Space(09)
_cCont    := "1"
_cCod     := Space(15)
_cDesc    := Space(30)
_cLocal   := Space(02)
_dData    := dDataBase
_cLocaliz := Space(15)
_cOper    := Space(03)
_nQuant   := 0
_cLot     := Space(10)
_cDoc     := Space(09)
_cFlag    := Space(01)
_cLott    := " "
_cTipo    := Space(02)

@ 200,050 To 535,585 Dialog DlgInvent Title OemToAnsi("Inventario")
@ 005,008 To 140,260

@ 012,020 Say OemToAnsi("Data         ") Size 35,8
@ 027,020 Say OemToAnsi("Etiqueta     ") Size 25,8
@ 027,110 Say OemToAnsi("Contagem ")     Size 35,8
@ 042,020 Say OemToAnsi("Produto      ") Size 35,8

@ 057,020 Say OemToAnsi("Quantidade   ") Size 35,8
//@ 057,020 Say OemToAnsi("Data         ") Size 35,8
@ 072,020 Say OemToAnsi("Local        ") Size 35,8
@ 072,110 Say OemToAnsi("Operação     ") Size 35,8
@ 087,020 Say OemToAnsi("Localizacao  ") Size 35,8

@ 102,020 Say OemToAnsi("Lote         ") Size 35,8
@ 117,020 Say OemToAnsi("Documento    ") Size 35,8

@ 010,070 Get _dData     Picture "99/99/99"  Size 45,8
@ 025,070 Get _cEtiq     Picture "@!" Valid fEtiq() Size 30,8 Object o_cEtiq
@ 025,140 Get _cCont     Picture "@!" When .F. Size 30,8
@ 040,070 Get _cCod      Picture "@!" F3 "SB1" Valid fCod() Size 55,8
@ 040,124 Get _cDesc     Picture "@!" When .F. Size 120,8
@ 055,070 Get _nQuant    Picture "@E 999,999,999.99"  Valid _nQuant >=0 Size 75,8
@ 070,070 Get _cLocal    Picture "@!" Valid fLocal() Size 15,8
@ 070,140 Get _cOper     Picture "@!" When (_cTipo=="PA") Valid fOperaca() Size 15,8
@ 085,070 Get _cLocaliz  Picture "@!" When (_cFlag == "S") F3 "SBE" Valid fLocaliz() Size 55,8
@ 100,070 Get _cLot      Picture "@!" When (_cTipo<>"PA") Valid fLot() Size 35,8 Object oLote
@ 115,070 Get _cDoc      Picture "@!" Size 35,8

@ 145,190 BMPBUTTON TYPE 01 ACTION GravaDados()
@ 145,230 BMPBUTTON TYPE 02 ACTION Close(DlgInvent)
Activate Dialog DlgInvent CENTERED

Return

Static Function GravaDados()
	If _cCont == "1"
		If Empty(_cEtiq) .Or. Empty(_cCod)
			MsgBox("Existe dados em branco, verifique !","Inventario","INFO")
			Return
		Endif
	   RecLock("SZB",.T.)
		SZB->ZB_ETIQ    := _cEtiq
		SZB->ZB_CONT    := _cCont
		SZB->ZB_COD     := _cCod
		SZB->ZB_DESC    := _cDesc
		SZB->ZB_LOCAL   := _cLocal
		SZB->ZB_DATA    := _dData
		SZB->ZB_LOCALIZ := _cLocaliz
		SZB->ZB_QTDE1   := _nQuant
		SZB->ZB_QTDE3   := _nQuant // na primeira contagem grava na qtde3 tambem		
		SZB->ZB_LOTE    := _cLot
		SZB->ZB_DOC     := _cDoc
  		SZB->ZB_OPERACA := _cOper  //operação		
	   MsUnlock("SZB")
	Else
	//	If SZB->(DbSeek(xFilial("SZB")+_cEtiq+DtoS(_dData)),Found())
  	    If SZB->(DbSeek(xFilial("  ")+DtoS(_dData)+_cEtiq),Found())		
		   If _cCont == "2"
				If SZB->ZB_QTDE1 == _nQuant
				   RecLock("SZB",.F.)
					SZB->ZB_QTDE2   := _nQuant
					SZB->ZB_QTDE3   := _nQuant
					SZB->ZB_CONT    := _cCont
				   MsUnlock("SZB")
				Else
				   RecLock("SZB",.F.)
					SZB->ZB_QTDE2   := _nQuant
					SZB->ZB_QTDE3   := 0 // Zera a qtde 3 pois eh diferente a primeira da segunda contagem
					SZB->ZB_CONT    := _cCont
				   MsUnlock("SZB")
				Endif		   
		   Elseif _cCont == "3"
			   RecLock("SZB",.F.)
				SZB->ZB_QTDE3   := _nQuant
				SZB->ZB_CONT    := _cCont
			   MsUnlock("SZB")
		   Endif
		Else
			MsgBox("Nao foi possivel atualizar o arquivo de inventario ! ","Inventario","INFO")				
		Endif		   
	Endif	   
   fLimpa() //Limpa as variaveis do Dialogo p/ proxima digitação
   o_cEtiq:SetFocus() // Coloca o focu na variavel etiqueta
   DlgRefresh(DlgInvent) // atualiza o dialogo                              
	   
Return(.T.)

Static Function fEtiq()
Local lReturn := .T.,;
      lCheio  := .F.

	If Empty(_cEtiq)
		MsgBox("Dados em branco invalido, preencha os dados corretamente ! ","Inventario","INFO")		
		lReturn := .F.
		Return(lReturn)
	Endif
	
	_cCont    := "1"
	_cCod     := Space(15)
	_cDesc    := Space(30)
	_cLocal   := Space(02)
	_dData    := dDataBase
	_cLocaliz := Space(15)
	_nQuant   := 0
	_cLot     := Space(10)
	_cDoc     := Space(09)
	_cOper    := Space(03)
	_cTipo    := Space(02)
    SZB->(DbSetOrder(1))
	If SZB->(DbSeek(xFilial("SZB")+DtoS(_dData)+_cEtiq),Found())
	   _cCod      := SZB->ZB_COD
		_cDesc    := SZB->ZB_DESC
	   _cLocal    := SZB->ZB_LOCAL
	   _cLocaliz  := SZB->ZB_LOCALIZ
	   _cLot      := SZB->ZB_LOTE
	   _cDoc      := SZB->ZB_DOC
	   _cOper     := SZB->ZB_OPERACA
		If SZB->ZB_CONT == "1"
		   _cCont  := "2"
		Elseif SZB->ZB_CONT == "2" 
		   _cCont  :=  "3"
			lCheio := .T.
		Elseif SZB->ZB_CONT == "3"
			MsgBox("Para esta etiqueta, Ja existe 3 Contagens","Inventario","INFO")		
			lReturn := .F.
	  	Endif
	Endif

	If lCheio 
		If SZB->ZB_QTDE1 == SZB->ZB_QTDE2
			MsgBox("Para esta etiqueta, Ja existe 3 Contagens","Inventario","INFO")
			lReturn := .F.
		Endif
	Endif		

Return(lReturn)

Static Function fCod()
Local lReturn := .T.
Local _cNewCod := ""

If SM0->M0_CODIGO=="FN"  // Fundição
    
   	If Len(Alltrim(_cCod))==7
   		_cNewCod := fTransCod(_cCod)
		_cCod := Iif(Empty(_cNewCod),_cCod,_cNewCod)
	EndIf

   	SB1->(DbsetOrder(1)) //filial+cod
   	If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())
		_cDesc := SB1->B1_DESC
		_cFlag := SB1->B1_LOCALIZ // traz se controla localização S=SIM ou N=NAO
		_cLott := SB1->B1_RASTRO //  traz se controle de lote L=LOTE
		_cTipo := SB1->B1_TIPO
   	Else
   	  	MsgBox("Produto nao Encontrado","Inventario","INFO")
		lReturn := .F.
   	Endif

Elseif SM0->M0_CODIGO=="NH"  // Usinagem

   //Faz verificacao se foi digitado o codigo NEW HUBNER ou o Codigo do CLIENTE
   IF Subs(_cCod,5,1) == "."             
      SB1->(DbsetOrder(1)) //filial+cod
	   If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
			_cDesc := SB1->B1_DESC
			_cFlag := SB1->B1_LOCALIZ // traz se controla localização S=SIM ou N=NAO
	     	_cLott := SB1->B1_RASTRO //  traz se controle de lote L=LOTE 			
  	        _cTipo := SB1->B1_TIPO 
		Else
			MsgBox("Produto nao Encontrado","Inventario","INFO")
			lReturn := .F.
		Endif
	Else
		 SB1->(DbsetOrder(9)) //filial+codap5
		 If SB1->(DbSeek(xFilial("SB1")+_cCod),Found())	
		    _cDesc := SB1->B1_DESC
			 _cCod := SB1->B1_COD    
			_cFlag := SB1->B1_LOCALIZ  // traz se controla localização S=SIM ou N=NAO
  	    	_cTipo := SB1->B1_TIPO  			
		 Else
			 MsgBox("Produto nao Encontrado","Inventario","INFO")
			 lReturn := .F.
	 	 Endif
		
	Endif             

Endif
	
Return(lReturn)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRANSFORMA O CODIGO DE 7 DIGITOS NO CODIGO COMPLETO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fTransCod(_cCod)
Local _cNewcod := ""
Local cLike := Substr(_cCod,1,3)+'%'+Substr(_cCod,4,4)+'%'

	//--Fecha Alias Temporario se estiver aberto
	If Select("TRA1") > 0
		dbSelectArea("TRA1")
		dbCloseArea()
	Endif
	
	//-- procura o produto pelos 7 caracteres digitados
	beginSql Alias "TRA1"
		select TOP 1
			B1_COD
		from
			%table:SB1%
		where
			B1_COD LIKE %Exp:cLike%
		order by
			B1_COD ASC
	endSql
	
	//-- Verifica se encontrou o produto
	//-- Atribui ao retorno o valor encontrado
	If !TRA1->(EOF())
		If Substr(TRA1->B1_COD,7,1)$"1/P"
			_cNewCod := TRA1->B1_COD
		EndIf
	EndIf 
	
	TRA1->(dbCloseArea())

Return _cNewCod

Static Function fLocal()
Local lReturn := .T.       

	If _cTipo <>"PA"
		If !Empty(_cLocal) .Or. Empty(_cLocal)
	
			If !(Existcpo("SB2",_cCod+_cLocal) .And.  ExistCpo("SX5","ZA"+_cLocal))
				lReturn := .F.                  
			Endif		
		Endif
	Endif
    If !(ExistCpo("SX5","ZA"+_cLocal))
	    lReturn := .F.                  
    Endif		
	
Return(lReturn)


Static Function fOperaca()
Local lReturn := .T.       
Local lFlag   := .T.
Local _x      := 1 
                  
For _x:= 1 to Len(alltrim(_cOper))

    lFlag := Entre("0","9",Subs(_cOper,_x,1))
    If !lFlag
       MsgBox(OemtoAnsi("Operacao é Composta Somente de Numeros"),"Inventario","INFO")
	   lReturn := .F.                  
	   exit
    Endif
    
Next _x

If _cTipo <>"PA"
   MsgBox("Digitar Operacao Somente para Produto Acabado","Inventario","INFO")
   lReturn := .F.                  
Endif
fLote() //Gera Lote automaticamete para o inventario

Return(lReturn)



Static Function fLocaliz()
Local lReturn := .T.
	If _cFlag == "S"
		If !(Existcpo("SBE",_cLocal+_cLocaliz))
			lReturn := .F.                  
		Endif		
	Endif		
Return(lReturn)


Static Function fLimpa()

_cEtiq    := Space(09)
_cCont    := "1"
_cCod     := Space(15)
_cDesc    := Space(30)
_cLocal   := Space(02)
_dData    := dDataBase
_cLocaliz := Space(15)
_nQuant   := 0
_cLot     := Space(10)
_cDoc     := Space(09)
_cFlag    := Space(01)    
_cLott    := ""
_cOper    := Space(03)    
_cTipo    := Space(02)
                      
Return(.T.)

Static Function fLote()

Local lLote     := .F.
Local _nSeq     := 0
Local _cSeq     := Space(02)
Local _cLote    := Space(06)
Local _cData    := DToC(DdataBase)
Local _cMes     
Local _cDia

// Construcao de Lotes
_cLote := StrZero(Val(SubStr(_cData,10,1))- 1,1) //Ano menos um apenas p/ inventario

// Determinar o Mes
If SubStr(_cData,4,2) == "01"
   _cMes := "A"
ElseIf SubStr(_cData,4,2) == "02"
   _cMes := "B"
ElseIf SubStr(_cData,4,2) == "03"
   _cMes := "C"
ElseIf SubStr(_cData,4,2) == "04"
   _cMes := "D"
ElseIf SubStr(_cData,4,2) == "05"
   _cMes := "E"
ElseIf SubStr(_cData,4,2) == "06"
   _cMes := "F"  
ElseIf SubStr(_cData,4,2) == "07"
   _cMes := "G"
ElseIf SubStr(_cData,4,2) == "08"
   _cMes := "H"
ElseIf SubStr(_cData,4,2) == "09"
   _cMes := "I"
ElseIf SubStr(_cData,4,2) == "10"
   _cMes := "J"
ElseIf SubStr(_cData,4,2) == "11"
   _cMes := "K"
ElseIf SubStr(_cData,4,2) == "12"
   _cMes := "L"
Endif

_cLote := _cLote + _cMes

// Determina o Dia
_cDia  := SubStr(_cData,1,2)

_cLote := _cLote + _cDia

// Coloca caracter de Controle
_cLote := _cLote + "-"


If Val(_cSeq) > 0
//   _nSeq  := _nSeq + 1 //soma mais 1 para o produto que esta entrando
    _nSeq  :=  Val(Alltrim(_cSeq)) + 1 //soma mais 1 para o produto que esta entrando
Endif

If _nSeq  == 0  //A primeira vez entra aqui lote 1
   _nSeq  := 1
Endif                  

If !lLote 
   _cLote := _cLote + AllTrim(Str(_nSeq))   // Composicao Final
Endif   
        
_cLot := _cLote  //atribui lote gerado
ObjectMethod(oLote, "Refresh()") //atualiza lote na tela

Return(.T.) 

Static Function fLot() //Faz validacao no lote digitado

Local _lRet     := .T.

If _cLott$"L" //VERIFICA CONTROLE DE LOTE

   If !Empty(_cLot)      

      If Len(Alltrim(_cLot)) <> 6
         MsgBox("O Lote Deve conter 6 Digitos Ex: 8H31-1","Inventario","INFO")   
         _lRet     := .F.   
      Endif
   
      If Subs(alltrim(_cLot),5,1) <> "-"
         MsgBox("O Lote Deve Conter O Hifen na Quinta Posicao Ex: 8H31-1","Inventario","INFO")      
        _lRet     := .F.   
      Endif
   Else 
       MsgBox("O Lote Deve Ser Informado","Inventario","INFO")      
      _lRet     := .F.   
   
   Endif
   
Endif

Return(_lRet) 