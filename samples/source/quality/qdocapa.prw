#INCLUDE "MSOLE.CH"

User Function QDOCAPA()

Local aQPath    := QDOPATH()
Local cQPathD   := aQPath[2] // Caminho do Modelo .Dot
Local cQPathTrm := aQPath[3] // Caminho do diretorio temporario
Local cTextoD   := aQPath[4] // Nome padrao do .Dot


SetPrvt("oWord","cChave","cTpCopia","cNomFilial","cObjetivo","cNomRece","cSumario")
SetPrvt("cMotRevi","cApElabo","cApRevis","cApAprov","cApHomol","cRodape","cMdsObs")
SetPrvt("cCodAtu","cCodNov","cDescr","cDe","cPara","cMdpRaz","cMdpObs","cMdsRaz")
SetPrvt("cEdit","cEditor","nCopias")

cObjetivo:=cMotRevi:=cApElabo:=cApRevis:=cApAprov:=cApHomol:=cElabora:=cRevisor:=cAprovad:=cHomolog:=" "
cSumario:=cRodape:=cCodAtu:=cCodNov:=cDescr:=cDe:=cPara:=cMdpRaz:=cMdpObs:=cMdsRaz:=cMdsObs:= " "

cEdit     := Alltrim(GetMV("MV_QDTIPED")) 
nCopias   := 1
cChave    := QDH->QDH_CHAVE
cTpCopia  := If(lChCopia, OemToAnsi("Copia Controlada"), OemToAnsi("Copia nao Controlada"))
cNomFilial:= Space(40)
cEditor   := Space(12) 
cObjetivo := " "
cNomRece  := " "
cDepRece  := " "
cFilRece  := " "
cSumario  := " "
cMotRevi  := " "
cApElabo  := " "
cApRevis  := " "
cApAprov  := " "
cApHomol  := " "
cRodape   := " "
cCodAtu   := " "
cCodNov   := " "
cDescr    := " "
cDe       := " "
cPara     := " "
cMdpRaz   := " "
cMdpObs   := " "
cMdsRaz   := " "
cMdsObs   := " "

DbSelectArea("QD2")
DbSetOrder(1)

DbSelectArea("QDH")
DbSetOrder(1)

If QDH->QDH_DTOIE = "I"
	QdoDocQA2()
	If QD2->(DbSeek(xFilial("QD2")+M->QDH_CODTP))
		If !Empty(QD2->QD2_MODELO)
			cTextoD:= Alltrim(QD2->QD2_MODELO)
			If !File(cQPathTrm+cTextoD)
				CpyS2T(cQPathD+cTextoD,cQPathTrm,.T.)
				If !File(cQPathTrm+cTextoD)
					Help(" ", 1,"QD_DOTNEXT")
					Return .F.
				EndIf
			EndIf
		Else
			If !File(cQPathTrm+cTextoD)
				CpyS2T(cQPathD+cTextoD,cQPathTrm,.T.)
				If !File(cQPathTrm+cTextoD)
	   				Help(" ",1,"QD_DOTNEXT")
	   				Return .F.
				EndIf
			EndIf			
		EndIf
	Else
		MsgAlert("Atencao !!!","Tipo de Documento nao encontrado.")
		Return .F.
	EndIf
	
	ExecBlock( "QDOM700", .f., .f., { cEdit, cEditor } )

	If Empty( cEditor )
	   Help( " ", 1, "QD_NEXTEDT" )
	   Return .f.
	EndIf

	oWord := OLE_CreateLink( cEditor )
	OLE_SetProperty( oWord, oleWdVisible,   .f. )
	OLE_SetProperty( oWord, oleWdPrintBack, .f. )
	OLE_OpenFile(oWord,(cQPathTrm+cTextoD),.T.) // "Abrindo modelo padrao existente"
	ExecBlock( "QDOM710", .f., .f. ) // "Transferindo dados do sistema"	
	OLE_UpdateFields( oWord ) // "Atualizando vari veis do editor"
	OLE_PrintFile( oWord, "ALL",,, nCopias ) 
	OLE_CloseFile( oWord )
	OLE_CloseLink( oWord )
	If File(cQPathTrm+cTextoD)
		FErase(cQPathTrm+cTextoD)
	EndIf
EndIf

Return