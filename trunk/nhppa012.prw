/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPPA012  ºAutor  ³Felipe Ciconini     º Data ³  24/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao Formulario do Gerenciador de Modificações           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PPAP                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

User Function NHPPA012()
Private aHeader := {}
Private aCols	:= {}
Private cCont	:= ""

	If ZE8->(DbSeek(xFilial("ZE8")+cNum+cItem))
		fCarrega()
	EndIf

    DbSelectArea("ZE8")
	ZE8->(DbSetOrder(1))

	aAdd(aHeader,{"Numero"		, "ZE8_NUM"		,"999999"			 ,08,0,".F.","","C","ZE8"})
	aAdd(aHeader,{"Descrição"	, "ZE8_DESC"	,"@!"				 ,20,0,".T.","","C","ZE8"})
	aAdd(aHeader,{"Custo"  		, "ZE8_CUSTO"	,"@E 9,999,999.99"	 ,05,0,".T.","","N","ZE8"})
	aAdd(aHeader,{"Prazo (Dias)", "ZE8_PRAZO"	,"9999"				 ,05,0,".T.","","C","ZE8"})
	
	Define MsDialog oForm From 0,0 To 340,435 Pixel Title "FORMULARIO"
	
		@ 010,010 TO 150,210 Multiline Modify Delete Object oMultiline
		@ 155,185 BMPButton Type 01 Action fGrava()
		@ 155,155 BMPButton Type 02 Action oForm:End()
	
	Activate MsDialog oForm Center

Return

Static Function fGrava()
Local xD

	For xD:=1 to Len(aCols)
		
		If !aCols[xD][len(aHeader)+1]
			If ZE8->(DbSeek(xFilial("ZE8")+cNum+cItem+aCols[xD][1]))
				RecLock("ZE8",.F.)
					ZE8->ZE8_DESC	:= aCols[xD][2]
					ZE8->ZE8_CUSTO	:= aCols[xD][3]
					ZE8->ZE8_PRAZO	:= aCols[xD][4]
				MsUnlock("ZE8")
			Else
				RecLock("ZE8",.T.)
					ZE8->ZE8_FILIAL	:= xFilial("ZE8")
					ZE8->ZE8_NUM 	:= aCols[xD][1]
					ZE8->ZE8_NUMMOD	:= cNum
					ZE8->ZE8_ITEMMD	:= cItem
					ZE8->ZE8_DESC	:= aCols[xD][2]
					ZE8->ZE8_CUSTO	:= aCols[xD][3]
					ZE8->ZE8_PRAZO	:= aCols[xD][4]
				MsUnlock("ZE8")
			EndIf
		Else
			If ZE8->(DbSeek(xFilial("ZE8")+cNum+cItem+aCols[xD][1]))
				RecLock("ZE8")
					ZE8->(DbDelete())
				MsUnlock("ZE8")
			EndIf
		EndIf
		
	Next
	
	fCusto()
	
	oForm:End()

Return

Static Function fCusto()
            
	nCusto := 0

	If ZE8->(DbSeek(xFilial("ZE8")+cNum+cItem))
		While cNum+cItem == ZE8->ZE8_NUMMOD+ZE8->ZE8_ITEMMD
			nCusto += ZE8->ZE8_CUSTO
			ZE8->(DbSkip())
		EndDo
	EndIf

Return

Static Function fCarrega()

	While ZE8->ZE8_NUMMOD+ZE8->ZE8_ITEMMD == cNum+cItem
		aAdd(aCols,{ZE8->ZE8_NUM,ZE8->ZE8_DESC,ZE8->ZE8_CUSTO,ZE8->ZE8_PRAZO,.F.})
		ZE8->(DbSkip())
	EndDo

Return

User Function fPPA012Num()
Local cNumero	:= ""
Local xD
Local cNo 		:= ""
	
	For xD:=1 to Len(aCols)-1  
		cNo := StrZero(++Val( Iif(aCols[xD][1]>cNo,aCols[xD][1],cNo) ),6)
	Next
          
	If ZE8->(DbSeek(xFilial("ZE8")+cNum+cItem))
		While cNum+cItem == ZE8->ZE8_NUMMOD+ZE8->ZE8_ITEMMD
			cNumero := Iif(cNumero<StrZero(++Val(ZE8->ZE8_NUM),6),StrZero(++Val(ZE8->ZE8_NUM),6),cNumero)
			ZE8->(DbSkip())
		EndDo
	Else
		cNumero := "000001"
	EndIf
	
	If cNo > cNumero
		Return cNo
	EndIf
	
Return cNumero