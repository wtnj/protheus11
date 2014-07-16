
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEST196 บAutor  ณJos้ Henrique M Felipetto  Data ณ  28/02/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rotina para encerrar vแrias Ordens de Libera็ใo de uma vez บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"

User Function NHEST196()

If !Alltrim(Upper(cUserName)) $ "LEANDROJS/JOSEMF"
	alert("Apenas pessoas autorizadas podem usar esta fun็ใo!")
	Return .F.
EndIf

SetPrvt("cMarca,_aXDBF,_cArqXDBF,aCampos,cCadastro,aRotina,oDlgLocalNF,oDlgParamNF,cAl,_dData,_dDataA,aOldRotina,_cArmz")
aOldRotina := aRotina
getData()

if Empty(_dData) .or. Empty(_dDataA) .or. Empty(_cArmz)
	alert("Todos os parโmetros devem ser preenchidos!")
	Return .F.
EndIf

cAl := getNextAlias()
cMarca := GetMark()
cCadastro := OemToAnsi("Selecione o Nota - <ENTER> Marca/Desmarca")
aRotina := { {"Marca Tudo"    ,'U_fMarcavk()' , 0 , 4 },;
             {"Desmarca Tudo" ,'U_fDesmarvk()', 0 , 1 },;
             {"Legenda"       ,'U_fLegVoks()' , 0 , 1 },;
             {"Encerrar"      ,'U_fEncerra()' , 0 , 1 } }

// Cria Campos para mostrar no Browser
_cArqXDBF := CriaTrab(NIL,.f.)
//_cArqXDBF += ".DBF"
_aXDBF    := {}

AADD(_aXDBF,{"OK"         ,"C", 02,0})
AADD(_aXDBF,{"Nota"       ,"C", 09,0})
AADD(_aXDBF,{"Serie"      ,"C", 03,0})
AADD(_aXDBF,{"Fornecedor" ,"C", 06,2})
AADD(_aXDBF,{"Loja"       ,"C", 02,2})
AADD(_aXDBF,{"Item"       ,"C", 04,2})
AADD(_aXDBF,{"Produto"    ,"C", 15,2})
AADD(_aXDBF,{"Desc"       ,"C", 40,2})
AADD(_aXDBF,{"DtDigit"    ,"D", 08,2})
AADD(_aXDBF,{"HrEntr"     ,"C", 05,2})
AADD(_aXDBF,{"Locall"     ,"C", 02,2})
AADD(_aXDBF,{"DtPort"     ,"D", 08,2})
AADD(_aXDBF,{"HrPort"     ,"C", 05,2})
AADD(_aXDBF,{"UsrPort"    ,"C", 20,2})
AADD(_aXDBF,{"DtReceb"    ,"D", 08,2})
AADD(_aXDBF,{"HrReceb"    ,"C", 05,2})
AADD(_aXDBF,{"UsrReceb"   ,"C", 20,2})

If SELECT("XDBF") > 0
	XDBF->(DbCloseArea() )
EndIf

DbCreate(_cArqXDBF,_aXDBF)
DbUseArea(.T.,,_cArqXDBF,"XDBF",.F.)

aCampos := {}
Aadd(aCampos,{"OK"        ,"C", "  "             ,"@!"	 	  })
Aadd(aCampos,{"Nota"      ,"C", "Nota"           ,"@!"		  })
Aadd(aCampos,{"Serie"     ,"C", "Serie"          ,"@!"		  })
Aadd(aCampos,{"Fornecedor","C", "Fornecedor"     ,"@!"	  	  })
Aadd(aCampos,{"Loja"      ,"C", "Loja"           ,"@!"	  	  })
Aadd(aCampos,{"Item"      ,"C", "Item"           ,"@!"		  })
Aadd(aCampos,{"Produto"   ,"C", "Produto"        ,"@!"		  })
Aadd(aCampos,{"Desc"      ,"C", "Desc"           ,"@!"        })
Aadd(aCampos,{"DtDigit"  ,"D", "Dt.Digit"       ,"99/99/9999" })
Aadd(aCampos,{"HrEntr"   ,"C", "Hr.Entr"        ,"99:99"	  })
Aadd(aCampos,{"Locall"     ,"C", "Locall"          ,"@!"	  })
Aadd(aCampos,{"DtPort"   ,"D", "Dt.Port"        ,"99/99/9999" })
Aadd(aCampos,{"HrPort"   ,"C", "Hr.Port"        ,"99:99"	  })
Aadd(aCampos,{"UsrPort"  ,"C", "Usr.Port"       ,"@!"		  })
Aadd(aCampos,{"DtReceb"  ,"C", "Dt.Receb"       ,"99/99/9999" })
Aadd(aCampos,{"HrReceb"  ,"C", "Hr.Port"        ,"99:99"	  })
Aadd(aCampos,{"UsrReceb"  ,"C", "Usr.Port"       ,"@!"	      })

beginSql Alias cAl
	SELECT ZB8_DOC,ZB8_SERIE,ZB8_FORNEC,ZB8_LOJA,ZB8_ITEM,ZB8_COD,B1_DESC,D1_DTDIGIT,
	       ZB8_HRENTR,ZB8_LOCAL,ZB8_DTPORT,ZB8_HRPORT,ZB8_USRPOR,ZB8_DTOK,ZB8_HROK,
		   ZB8_USROK

	FROM   %Table:ZB8% Z8 (NOLOCK),
		   %Table:SD1% D1 (NOLOCK),
		   %Table:SB1% B1 (NOLOCK)

	WHERE  ZB8_DOC = D1_DOC
	AND	   ZB8_SERIE = D1_SERIE
	AND	   ZB8_FORNEC = D1_FORNECE
	AND    ZB8_LOJA = D1_LOJA
	AND    ZB8_COD = B1_COD
	AND    ZB8_ITEM = D1_ITEM
	AND	   ZB8_STATUS = 'P'
	AND	   D1_DTDIGIT BETWEEN %Exp:DTOS(_dData)% AND %Exp:DTOS(_dDataA)%
	AND    ZB8_LOCAL = %Exp:_cArmz%

	AND    Z8.ZB8_FILIAL = %xFilial:ZB8%
	AND    B1.B1_FILIAL = %xFilial:SB1%
	AND    D1.D1_FILIAL = %xFilial:SD1%

	AND	   Z8.%notDel%                       
	AND	   D1.%notDel%
	AND    B1.%notDel%

	ORDER  BY ZB8_DOC
EndSql

cQuery := getLastQuery()[2]
MemoWrit("C:\TEMP\EST196",cQuery)

TcSetField(cAl,"D1_DTDIGIT","D")  // Muda a data de string para date
TcSetField(cAl,"ZB8_DTPORT","D")  // Muda a data de string para date
TcSetField(cAl,"ZB8_DTOK","D")  // Muda a data de string para date

While (cAl)->(!Eof() )
	RecLock("XDBF",.T.)
		XDBF->OK    		:= ""
		XDBF->Nota  		:= (cAl)->ZB8_DOC
		XDBF->Serie 		:= (cAl)->ZB8_SERIE
		XDBF->Fornecedor 	:= (cAl)->ZB8_FORNEC
		XDBF->Loja			:= (cAl)->ZB8_LOJA
		XDBF->Item			:= (cAl)->ZB8_ITEM
		XDBF->Produto 		:= (cAl)->ZB8_COD
		XDBF->Desc  		:= (cAl)->B1_DESC
		XDBF->DtDigit 		:= (cAl)->D1_DTDIGIT
		XDBF->HrEntr  		:= (cAl)->ZB8_HRENTR
		XDBF->Locall  		:= (cAl)->ZB8_LOCAL
		XDBF->DtPort 		:= (cAl)->ZB8_DTPORT
		XDBF->HrPort 		:= (cAl)->ZB8_HRPORT
		XDBF->UsrPort 		:= (cAl)->ZB8_USRPOR
		XDBF->DtReceb 		:= (cAl)->ZB8_DTOK
		XDBF->HrPort 		:= (cAl)->ZB8_HROK
		XDBF->UsrReceb 		:= (cAl)->ZB8_USROK
	MsUnLock("XDBF")
	(cAl)->(DbSkip() )
EndDo
(cAl)->(DbCloseArea() )

DbSelectArea("XDBF")
Index On XDBF->Nota to (_cArqXDBF)
XDBF->( DbGoTop() )
MarkBrow("XDBF","OK" ,"XDBF->OK",aCampos,,cMarca)
aRotina := aOldRotina
Return

User Function fEncerra()
Local nCont := 0
ZB8->(DbSetOrder(1) )
DbSelectArea("XDBF")
XDBF->( DbGoTop() )
While XDBF->( !EOF() )
	If !Empty(XDBF->OK)
		If ZB8->(DbSeek(xFilial("ZB8") + XDBF->Nota + XDBF->Serie + XDBF->Fornecedor + XDBF->Loja + XDBF->Item))
			RecLock("ZB8",.F.)
				ZB8->ZB8_STATUS := "R"
				ZB8->ZB8_HRPORT := "99:99"
			MsUnLock("ZB8")	
			nCont++
		EndIf
	EndIf	
	XDBF->(DbSkip() )
EndDo

If nCont > 1
	MsgInfo("Ordens de Libera็ใo encerradas com sucesso!")
ElseIf nCont == 1
	MsgInfo("Ordem de Libera็ใo encerrada com sucesso!")
ElseIf nCont == 0
	MsgInfo("Nenhuma Ordem de libera็ใo foi selecionada!. Favor verifique!")
EndIf
Return 

Static Function getData()
_dData := CTOD("  /  /    ")
_dDataA := CTOD("  /  /    ")
_cArmz := space(Len(SD1->D1_LOCAL))

oDlg  := MsDialog():New(0,0,180,260,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"de Data:"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(06,50,{|u| if(Pcount() > 0, _dData := u,_dData)},oDlg,60,8,"99/99/9999",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_dData")

	oSay2 := TSay():New(28,10,{||"at้ Data:"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(26,50,{|u| if(Pcount() > 0, _dDataA := u,_dDataA)},oDlg,60,8,"99/99/9999",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_dDataA")

	oSay3 := TSay():New(48,10,{||"Armaz้m:"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(46,50,{|u| if(Pcount() > 0, _cArmz := u,_cArmz)},oDlg,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"ALM","_cArmz")

	oBtn := tButton():New(66,50,"Ok",oDlg,{|| oDlg:End() } ,60,10,,,,.T.)
					
oDlg:Activate(,,,.t.,{||.T.},,)
Return