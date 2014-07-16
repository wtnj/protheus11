#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

#DEFINE VBOX    070
#DEFINE VSPACE  006
#DEFINE HSPACE  006
#DEFINE HMARGEM 030
#DEFINE VMARGEM 030
#DEFINE MAXITEM 030
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PrtNfeSef ³ Autor ³ Eduardo Riera         ³ Data ³16.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de exemplo para impressão da DANFE no formato Retrato³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PrtNfeSef()

Local aArea     := GetArea()

Local oDanfe

oDanfe 	:= TMSPrinter():New("DANFE - Documento Auxiliar da Nota Fiscal Eletrônica")
oDanfe:SetPortrait()
oDanfe:Setup()
	
RptStatus({|lEnd| DanfeProc(oDanfe,@lEnd)},"Imprimindo Danfe...")
oDanfe:Preview()

RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DANFEProc ³ Autor ³ Eduardo Riera         ³ Data ³16.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de exemplo para impressão da DANFE no formato Retrato³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto grafico de impressao                    (OPC) ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DanfeProc(oDanfe,lEnd)

Local aArea     := GetArea()
Local aNotas    := {}
Local aXML      := {}
Local aAutoriza := {}

Local cAliasSF3 := "SF3"
Local cWhere    := ""
Local cAviso    := ""
Local cErro     := ""
Local cAutoriza := ""

Local lQuery    := .F.

Local oNfe 

If Pergunte("NFSIGW",.T.)
	dbSelectArea("SF3")
	dbSetOrder(5)
	#IFDEF TOP
		If MV_PAR04==1
			cWhere := "%SubString(SF3.F3_CFO,1,1) < '5' AND SF3.F3_FORMUL='S'%"
		Else
			cWhere := "%SubString(SF3.F3_CFO,1,1) >= '5'%"
		EndIf	
		cAliasSF3 := GetNextAlias()
		lQuery    := .T.
	
		BeginSql Alias cAliasSF3
		
		COLUMN F3_ENTRADA AS DATE
		COLUMN F3_DTCANC AS DATE
				
		SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
				FROM %Table:SF3% SF3
				WHERE
				SF3.F3_FILIAL = %xFilial:SF3% AND
				SF3.F3_SERIE = %Exp:MV_PAR03% AND 
				SF3.F3_NFISCAL >= %Exp:MV_PAR01% AND 
				SF3.F3_NFISCAL <= %Exp:MV_PAR02% AND 
				%Exp:cWhere% AND 
				SF3.F3_DTCANC = %Exp:Space(8)% AND
				SF3.%notdel%
		EndSql	
	
	#ELSE
		MsSeek(xFilial("SF3")+MV_PAR03+MV_PAR01,.T.)
	#ENDIF
	If MV_PAR04==1
		cWhere := "SubStr(F3_CFO,1,1) < '5' AND F3_FORMUL='S'"
	Else
		cWhere := "SubStr(F3_CFO,1,1) >= '5'"
	EndIf	
	While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
		(cAliasSF3)->F3_SERIE == MV_PAR03 .And.;
		(cAliasSF3)->F3_NFISCAL >= MV_PAR01 .And.;
		(cAliasSF3)->F3_NFISCAL <= MV_PAR02
		
		dbSelectArea(cAliasSF3)
		If AModNot((cAliasSF3)->F3_ESPECIE)=="55" .And. Empty((cAliasSF3)->F3_DTCANC) .And. &cWhere
		
			If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. (cAliasSF3)->F3_FORMUL=="S") .And. aScan(aNotas,{|x| x[4]+x[5]+x[6]+x[7]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA})==0	
				aadd(aNotas,{})
				aadd(Atail(aNotas),.F.)
				aadd(Atail(aNotas),IIF((cAliasSF3)->F3_CFO<"5","E","S"))
				aadd(Atail(aNotas),(cAliasSF3)->F3_ENTRADA)
				aadd(Atail(aNotas),(cAliasSF3)->F3_SERIE)
				aadd(Atail(aNotas),(cAliasSF3)->F3_NFISCAL)
				aadd(Atail(aNotas),(cAliasSF3)->F3_CLIEFOR)
				aadd(Atail(aNotas),(cAliasSF3)->F3_LOJA)
				
				aXML := u_XmlNfeSef(IIF((cAliasSF3)->F3_CFO<"5","0","1"),(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA)
				   
				aAutoriza := NfeConsNfe(aXML[1])
				If !Empty(aAutoriza[2])
				
					oNfe := XmlParser(aXML[2],"_",@cAviso,@cErro)
					
					If Empty(cAviso) .And. Empty(cErro)
				
					    ImpDet(oDanfe,oNFe,cAutoriza)
					    
					EndIf
				
				EndIf
				
			EndIf
		EndIf
		
		dbSelectArea(cAliasSF3)
		dbSkip()	
		If lEnd
			Exit
		EndIf
	EndDo
	If lQuery
		dbSelectArea(cAliasSF3)
		dbCloseArea()
		dbSelectArea("SF3")
	EndIf

EndIf
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Eduardo Riera         ³ Data ³16.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto grafico de impressao                    (OPC) ³±±
±±³          ³ExpC2: String com o XML da NFe                              ³±±
±±³          ³ExpC3: Codigo de Autorizacao do fiscal                (OPC) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDet(oDanfe,oNfe,cCodAutSef)

PRIVATE oFont07    := TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
PRIVATE oFont07N   := TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)
PRIVATE oFont09    := TFont():New("Times New Roman",09,09,,.F.,,,,.T.,.F.)  
PRIVATE oFont10    := TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
PRIVATE oFont10n   := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
PRIVATE oFont11    := TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
PRIVATE oFont18N   := TFont():New("Times New Roman",18,18,,.T.,,,,.T.,.F.)

PrtDanfe(oDanfe,oNfe,cCodAutSef)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PrtDanfe  ³ Autor ³Eduardo Riera          ³ Data ³16.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do formulario DANFE grafico conforme laytout no   ³±±
±±³          ³formato retrato                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PrtDanfe()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto grafico de impressao                          ³±±
±±³          ³ExpO2: Objeto da NFe                                        ³±±
±±³          ³ExpC3: Codigo de Autorizacao do fiscal                (OPC) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrtDanfe(oDanfe,oNFE,cCodAutSef)

Local aSitTrib   := {}
Local aTransp    := {}
Local aDest      := {}
Local aFaturas   := {}
Local aItens     := {}
Local aISSQN     := {}
Local aTotais    := {}
Local nHPage     := 0 
Local nPosV      := 0
Local nPosVOld   := 0
Local nPosH      := 0
Local nPosHOld   := 0
Local nAux       := 0
Local nX         := 0
Local nY         := 0
Local nFolha     := 1
Local nFolhas    := 0
Local nItem      := 0
Local nBaseICM   := 0
Local nValICM    := 0
Local nValIPI    := 0
Local nPICM      := 0
Local nPIPI      := 0
Local nFaturas   := 0
Local cAux       := ""
Local cSitTrib   := ""
Local aMensagem  := {}
Local lPreview   := .F.
Private oNF        := oNFe:_NFe
Private oEmitente  := oNF:_InfNfe:_Emit
Private oIdent     := oNF:_InfNfe:_IDE
Private oDestino   := oNF:_InfNfe:_Dest
Private oTotal     := oNF:_InfNfe:_Total
Private oTransp    := oNF:_InfNfe:_Transp
Private oDet       := oNF:_InfNfe:_Det
Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
Private oImposto
nFaturas   := IIf(oFatura<>Nil,IIf(ValType(oNF:_InfNfe:_Cobr:_Dup)=="A",Len(oNF:_InfNfe:_Cobr:_Dup),1),0)
oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega as variaveis de impressao                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
MsSeek(xFilial("SX5")+"S2")
While !Eof() /*.And. xFilial("SX5") == SX5->X5_FILIAL*/ .And.;
	"S2" == SX5->X5_TABELA
    aadd(aSitTrib,AllTrim(SX5->X5_CHAVE))
	dbSelectArea("SX5")	
	dbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Destinatario                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDest := {oDestino:_EnderDest:_Xlgr:Text+", "+oDestino:_EnderDest:_NRO:Text,;
			oDestino:_EnderDest:_XBairro:Text,;
			IIF(Type("oDestino:_EnderDest:_Cep")=="U","",Transform(oDestino:_EnderDest:_Cep:Text,"@r 99999-999")),;
			oIdent:_DSaiEnt:Text,;
			oDestino:_EnderDest:_XMun:Text,;
			IIF(Type("oDestino:_EnderDest:_fone")=="U","",oDestino:_EnderDest:_fone:Text),;
			oDestino:_EnderDest:_UF:Text,;
			oDestino:_IE:Text,;
			""}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Imposto                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTotais := {"","","","","","","","","","",""}
aTotais[01] := Transform(Val(oTotal:_ICMSTOT:_vBC:TEXT),"@zr 999,999,999.99")
aTotais[02] := Transform(Val(oTotal:_ICMSTOT:_vICMS:TEXT),"@zr 9,999,999.99")
aTotais[03] := Transform(Val(oTotal:_ICMSTOT:_vBCST:TEXT),"@zr 999,999,999.99")
aTotais[04] := Transform(Val(oTotal:_ICMSTOT:_vST:TEXT),"@zr 9,999,999.99")
aTotais[05] := Transform(Val(oTotal:_ICMSTOT:_vProd:TEXT),"@zr 9,999,999.99")
aTotais[06] := Transform(Val(oTotal:_ICMSTOT:_vFrete:TEXT),"@zr 9,999,999.99")
aTotais[07] := Transform(Val(oTotal:_ICMSTOT:_vSeg:TEXT),"@zr 9,999,999.99")
aTotais[08] := Transform(Val(oTotal:_ICMSTOT:_vDesc:TEXT),"@zr 9,999,999.99")
aTotais[09] := Transform(Val(oTotal:_ICMSTOT:_vOutro:TEXT),"@zr 9,999,999.99")
aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@zr 9,999,999.99")
aTotais[11] := 	Transform(Val(oTotal:_ICMSTOT:_vNF:TEXT),"@zr 999,999,999.99")	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Faturas                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFaturas > 0
	For nX := 1 To Min(3,nFaturas)
		aadd(aFaturas,{PadR("Titulo",20),PadR("Vencto",15),PadR("Valor",16)})
	Next nX
	For nX := Len(aFaturas)+1 To 3
		aadd(aFaturas,{PadR("",20),PadR("",15),PadR("",20)})
	Next nX
	If nFaturas > 1
		For nX := 1 To nFaturas
			aadd(aFaturas,{PadR(oFatura:_Dup[nFaturas]:_nDup:TEXT,20),PadR(oFatura:_Dup[nFaturas]:_dVenc:TEXT,15),PadR(TransForm(Val(oFatura:_Dup[nFaturas]:_vDup:TEXT),"@r 9999,999,999.99"),16)})
		Next nX
	Else
		aadd(aFaturas,{PadR(oFatura:_Dup:_nDup:TEXT,20),PadR(oFatura:_Dup:_dVenc:TEXT,15),PadR(TransForm(Val(oFatura:_Dup:_vDup:TEXT),"@r 9999,999,999.99"),16)})
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro transportadora                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTransp := {"","","","","","","","","","","","","","","",""}
If Type("oTransp:_Transporta")<>"U"
	aTransp[01] := oTransp:_Transporta:_xNome:TEXT
	aTransp[02] := IIF(oTransp:_ModFrete:TEXT=="0","Emitente","Destinatário")
	aTransp[03] := IIf(Type("oTransp:_Transporta:_RNTC")=="U","",oTransp:_Transporta:_RNTC:TEXT)
	aTransp[04] := oTransp:_VeicTransp:_Placa:TEXT
	aTransp[05] := oTransp:_VeicTransp:_UF:TEXT
	aTransp[06] := Transform(oTransp:_Transporta:_CNPJ:TEXT,IIf(Len(oTransp:_Transporta:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99"))
	aTransp[07] := oTransp:_Transporta:_xEnder:TEXT
	aTransp[08] := oTransp:_Transporta:_xMun:TEXT
	aTransp[09] := oTransp:_Transporta:_UF:TEXT
	aTransp[10] := oTransp:_Transporta:_IE:TEXT
	aTransp[11] := oTransp:_Vol:_qVol:TEXT
	aTransp[12] := IIf(Type("oTransp:_Vol:_Esp")=="U","",oTransp:_Vol:_Esp:TEXT)
	aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",oTransp:_Vol:_Marca:TEXT)
	aTransp[14] := oTransp:_Vol:_nVol:TEXT
	aTransp[15] := oTransp:_Vol:_PesoB:TEXT
	aTransp[16] := oTransp:_Vol:_PesoL:TEXT
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Dados do Produto / Serviço                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len(oDet)
	nBaseICM := 0
	nValICM  := 0
	nValIPI  := 0
	nPICM    := 0
	nPIPI    := 0
	oImposto := oDet[nX]
	If Type("oImposto:_Imposto")<>"U"
		If Type("oImposto:_Imposto:_ICMS")<>"U"
			For nY := 1 To Len(aSitTrib)
		 		If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY])<>"U"
		 			If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT")<>"U"
			 			nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT"))
			 			nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
			 			nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_PICMS:TEXT"))
			 		EndIf
		 		EndIf
			Next nY
		EndIf
		If Type("oImposto:_Imposto:_IPI")<>"U"
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
				nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
				nPIPI   := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
			EndIf		
		EndIf
	EndIf
	aadd(aItens,{oDet[nX]:_Prod:_cProd:TEXT,;
					SubStr(oDet[nX]:_Prod:_xProd:TEXT,1,25),;
					IIF(Type("oDet[nX]:_Prod:_NCM")=="U","",oDet[nX]:_Prod:_NCM:TEXT),;
					"",;
					oDet[nX]:_Prod:_CFOP:TEXT,;
					oDet[nX]:_Prod:_uCom:TEXT,;
					TransForm(Val(oDet[nX]:_Prod:_qCom:TEXT),TM(Val(oDet[nX]:_Prod:_qCom:TEXT),TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2])),;
					TransForm(Val(oDet[nX]:_Prod:_vProd:TEXT),TM(Val(oDet[nX]:_Prod:_vProd:TEXT),TamSX3("D2_PRCVEN")[1],TamSX3("D2_PRCVEN")[2])),;
					TransForm(Val(oDet[nX]:_Prod:_qCom:TEXT)*Val(oDet[nX]:_Prod:_vProd:TEXT),TM(Val(oDet[nX]:_Prod:_qCom:TEXT)*Val(oDet[nX]:_Prod:_vProd:TEXT),TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2])),;
					TransForm(nBaseICM,TM(nBaseICM,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2])),;
					TransForm(nValICM,TM(nValICM,TamSX3("D2_VALICM")[1],TamSX3("D2_VALICM")[2])),;
					TransForm(nValIPI,TM(nValIPI,TamSX3("D2_VALIPI")[1],TamSX3("D2_BASEIPI")[2])),;
					TransForm(nPICM,TM(nPICM,TamSX3("D2_PICM")[1],TamSX3("D2_PICM")[2])),;
					TransForm(nPIPI,TM(nPIPI,TamSX3("D2_IPI")[1],TamSX3("D2_IPI")[2]))})
	cAux := AllTrim(SubStr(oDet[nX]:_Prod:_xProd:TEXT,26))
	While !Empty(cAux)
		aadd(aItens,{"",;
					SubStr(cAux,26,25),;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					""})
		cAux := SubStr(cAux,26)
	EndDo
Next nX
For nX := Len(aItens) To MAXITEM-1
		aadd(aItens,{"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					""})
Next nX
nFolhas := 1
If Len(aItens)>30
	nFolhas += Int((Len(aItens)-30)/60)
	If Mod(Len(aItens)-30,60)>0
		nFolhas++
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro ISSQN                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aISSQN := {"","","",""}
If Type("oEmitente:_IM:TEXT")<>"U"
	aISSQN[1] := oEmitente:_IM:TEXT
EndIf
If Type("oTotal:_ISSQN")<>"U"
	aISSQN[2] := TransForm(Val(oTotal:_ISSQN:_vServ:TEXT),TM(Val(oTotal:_ISSQN:_vServ:TEXT),TamSx3("D2_TOTAL")[1],TamSx3("D2_TOTAL")[2]))
	aISSQN[3] := TransForm(Val(oTotal:_ISSQN:_vBC:TEXT),TM(Val(oTotal:_ISSQN:_vBC:TEXT),TamSx3("D2_BASEICM")[1],TamSx3("D2_BASEICM")[2]))
	aISSQN[4] := TransForm(Val(oTotal:_ISSQN:_vISS:TEXT),TM(Val(oTotal:_ISSQN:_vISS:TEXT),TamSx3("D2_VALICM")[1],TamSx3("D2_VALICM")[2]))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro de informacoes complementares                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aMensagem := {}
If Type("oNF:_InfNfe:_infAdic:_infAdFisco:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_infAdFisco:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,90))
		cAux := SubStr(cAux,91)
	EndDo
EndIf
If Type("oNF:_InfNfe:_infAdic:_infCol:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:__InfCol:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,90))
		cAux := SubStr(cAux,91)
	EndDo
EndIf
If !Empty(cCodAutSef)
	aadd(aMensagem,"Protocolo: "+cCodAutSef)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao do objeto grafico                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oDanfe == Nil
	lPreview := .T.
	oDanfe 	:= TMSPrinter():New("DANFE - Documento Auxiliar da Nota Fiscal Eletrônica")
	oDanfe:SetPortrait()
	oDanfe:Setup()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao da pagina do objeto grafico                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:StartPage()
nHPage := oDanfe:nHorzRes()-HMARGEM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Box - Recibo de entrega                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosV    := VBOX+VMARGEM
nPosVOld := VMARGEM
nPosHOld := HMARGEM
nPosH    := nHPage*.8
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nPosHOld+010,"Recebemos de "+oEmitente:_xNome:Text+" os produtos constantes da nota fiscal indicada ao lado",oFont07N)
nPosH    += HSPACE
	oDanfe:Box(nPosVOld,nPosH,nPosV+VBOX,nHPage)
nPosVOld := nPosV+VSPACE
nPosV += VBOX
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nHPage*.8)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nHPage*.2)
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),nPosHOld+005,"Data de recebimento",oFont07)
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),(nHPage*.2)+005,"Identificação e assinatura do recebedor",oFont07)
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),(nHPage*.85),"Nf-e: "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N)
nPosVOld := nPosV
nPosV += VBOX/2
	oDanfe:Line(nPosV,nPosHOld,nPosV,nHPage) 
	
nPosV := DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,@nFolha,nFolhas)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro destinatário/remetente                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"DESTINATÁRIO/REMETENTE",oFont07)
nPosV    += Char2PixV("XX",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH*.9)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Nome/Razão social",oFont07)	
	nAux += Char2Pix(Repl("X",120),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH*.9)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CNPJ/CPF",oFont07)	
	nAux := nPosH - Char2Pix(Repl("X",15),oFont07)
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Data de emissão",oFont07)	
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,oDestino:_XNome:TEXT,oFont07)
	nAux += Char2Pix(Repl("X",120),oFont07)+010
	Do Case
		Case Type("oDestino:_CNPJ")=="O"
			oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,TransForm(oDestino:_CNPJ:TEXT,"@r 99.999.999/9999-99"),oFont07)	
		Case Type("oDestino:_CPF")=="O"
			oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,TransForm(oDestino:_CPF:TEXT,"@r 999.999.999-99"),oFont07)	
		OtherWise
			oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,Space(14),oFont07)				
	EndCase
		
	nAux := nPosH - Char2Pix(Repl("X",15),oFont07)+005
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,oIdent:_DEmi:TEXT,oFont07)		

nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH*.9)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Endereço",oFont07)	
	nAux += Char2Pix(Repl("X",80),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH*.9)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Bairro/Distrito",oFont07)	
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH*.9)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CEP",oFont07)	
	nAux := nPosH - Char2Pix(Repl("X",15),oFont07)
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Data entrada/saida",oFont07)
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[1],oFont07)
	nAux += Char2Pix(Repl("X",080),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[2],oFont07)	
	nAux += Char2Pix(Repl("X",020),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[3],oFont07)
	nAux := nPosH - Char2Pix(Repl("X",15),oFont07)+005
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[4],oFont07)		

nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH*.9)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Municipio",oFont07)	
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH*.9)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Fone/Fax",oFont07)	
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH*.9)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"UF",oFont07)	
	nAux += Char2Pix(Repl("X",10),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH*0.9)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Inscriçao estadual",oFont07)	
	nAux := nPosH - Char2Pix(Repl("X",15),oFont07)
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Hora entrada/saída",oFont07)
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[5],oFont07)
	nAux += Char2Pix(Repl("X",040),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[6],oFont07)	
	nAux += Char2Pix(Repl("X",040),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[7],oFont07)
	nAux += Char2Pix(Repl("X",010),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[8],oFont07)	
	nAux := nPosH - Char2Pix(Repl("X",15),oFont07)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aDest[9],oFont07)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro fatura                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosV += VBOX*((Int((Len(aFaturas)-3)/3)/2))
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"FATURA",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
nPosV    += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)	
	nAux := nPosHOld+010
	For nX := 1 To Len(aFaturas)
		oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aFaturas[nX,1],oFont07)	
		nAux += Char2Pix(Repl("X",Len(aFaturas[1,1])),oFont07)+010
		If nX == 1
			oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
		EndIf
		oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aFaturas[nX,2],oFont07)	
		nAux += Char2Pix(Repl("X",Len(aFaturas[1,2])),oFont07)+010
		If nX == 1
			oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
		EndIf
		oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aFaturas[nX,3],oFont07)		                                
		If Mod(nX,3) == 0
			If nX <> Len(aFaturas)
				nPosVOld += Char2PixV("XX",oFont07)
				nPosV    += Char2PixV("XX",oFont07)
				nPosHOld := HMARGEM
				nPosH    := nHPage			
				nAux := nPosHOld+010
			EndIf
		Else
			nAux += Char2Pix(Repl("X",Len(aFaturas[1,3])),oFont07)+010
			If nX == 1
				oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)		
			EndIf
		EndIf
	Next nX	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do imposto                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"CALCULO DO IMPOSTO",oFont07)
nPosV    += Char2PixV("XX",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),nAux,"Base de calculo do ICMS",oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor do ICMS",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Base de calculo do ICMS substituição",oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor do ICMS substituição",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor total dos produtos",oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[01],oFont07)
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[02],oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[03],oFont07)
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[04],oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[05],oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010

nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),nAux,"Valor do Frete",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor do Seguro",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Desconto",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Outras despesas acessórias",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor do IPI",oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor Total da Nota",oFont07)
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[06],oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[07],oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[08],oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[09],oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[10],oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTotais[11],oFont07)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transportador/Volumes transportados                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"TRANSPORTADOR/VOLUMES TRANSPORTADOS",oFont07)
nPosV    += Char2PixV("XX",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),nAux,"Razão Social",oFont07)	
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Frete por Conta",oFont07)	
	nAux += Char2Pix(Repl("X",15),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Codigo ANTT",oFont07)	
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Placa do veículo",oFont07)	
	nAux += Char2Pix(Repl("X",15),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"UF",oFont07)
	nAux += Char2Pix(Repl("X",05),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CNPJ/CPF",oFont07)
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[01],oFont07)
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[02],oFont07)	
	nAux += Char2Pix(Repl("X",15),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[03],oFont07)
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[04],oFont07)
	nAux += Char2Pix(Repl("X",15),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[05],oFont07)
	nAux += Char2Pix(Repl("X",05),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[06],oFont07)

nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),nAux,"Endereço",oFont07)	
	nAux += Char2Pix(Repl("X",60),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Municipio",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"UF",oFont07)	
	nAux += Char2Pix(Repl("X",10),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Inscrição Estadual",oFont07)	
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[07],oFont07)
	nAux += Char2Pix(Repl("X",60),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[08],oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[09],oFont07)
	nAux += Char2Pix(Repl("X",10),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[10],oFont07)

nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),nAux,"Quantidade",oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Especie",oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Marca",oFont07)	
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Numeração",oFont07)	
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Peso Bruto",oFont07)
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Peso Liquido",oFont07)
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[11],oFont07)
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[12],oFont07)
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[13],oFont07)
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[14],oFont07)
	nAux += Char2Pix(Repl("X",25),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[15],oFont07)
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aTransp[16],oFont07)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do produto ou servico                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+VSPACE
nPosV += VBOX*.75
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"DADOS DO PRODUTO / SERVIÇO",oFont07)
nPosV    += Char2PixV("XX",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+005
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Cod.Prod.",oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_COD")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Descrição do Produto/Serviço",oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"NCM/SH",oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_POSIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CST",oFont07)	
	nAux += Char2Pix(Repl("X",03),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CFOP",oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"UN",oFont07)
	nAux += Char2Pix(Repl("X",002),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Quantidade",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_QUANT")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.Unitário",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_PRCVEN")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.Total",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_TOTAL")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"BC.ICMS",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_BASEICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.ICMS",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.IPI",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"A.ICM",oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"A.IPI",oFont07)

nPosVOld := nPosV+2
nPosV += VBOX*0.5
For nX := 1 To MAXITEM
	nPosHOld := HMARGEM
	nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+Char2PixV("X",oFont07)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][01],oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_COD")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][02],oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][03],oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_POSIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][04],oFont07)	
	nAux += Char2Pix(Repl("X",03),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][05],oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][06],oFont07)
	nAux += Char2Pix(Repl("X",002),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][07],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_QUANT")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][08],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_PRCVEN")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][09],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_TOTAL")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][10],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_BASEICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][11],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][12],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][13],oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nX][14],oFont07)
	nPosVOld := nPosV+2
	nPosV += VBOX*0.5
Next nX	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do ISSQN                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+(VSPACE/2)
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"CáLCULO DO ISSQN",oFont07)
nPosV    += Char2PixV("XX",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Inscrição Municipal",oFont07)	
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor Total dos Serviços",oFont07)	
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Base de Cálculo do ISSQN",oFont07)	
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Valor do ISSQN",oFont07)	
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aISSQN[1],oFont07)
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aISSQN[2],oFont07)	
	nAux += Char2Pix(Repl("X",10),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aISSQN[3],oFont07)
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aISSQN[4],oFont07)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados Adicionais                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+(VSPACE/2)
nPosV += VBOX*4
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"DADOS ADICIONAIS",oFont07)
nPosV    += Char2PixV("XX",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Informações complementares",oFont07)	
	nAux := (nHPage/2)+10
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Reservado ao fisco",oFont07)	
	nAux := nPosHOld+010
	nPosV    += Char2PixV("XX",oFont07)
	nPosVOld += Char2PixV("XX",oFont07)	
	For nX := 1 To Len(aMensagem)		
		nPosVOld += Char2PixV("XX",oFont07)
		oDanfe:Say(nPosVOld,nAux,aMensagem[nX],oFont07)
	Next nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalizacao da pagina do objeto grafico                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:EndPage()
nItem := MAXITEM+1
While nItem <= Len(aItens)
	DanfeCpl(oDanfe,aItens,@nItem,oNFe,oIdent,oEmitente,@nFolha,nFolhas)
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a Impressão                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
If lPreview
	oDanfe:Preview()
EndIf
Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Cabecalho do documento                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas)

Local nHPage     := oDanfe:nHorzRes()-HMARGEM
Local nPosVOld   := 0
Local nPosH      := 0
Local nPosHOld   := 0
Local nAux       := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 1                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+(VBOX/2)
nPosV    := nPosV + 380
nPosHOld := HMARGEM
nPosH    := 910
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont10N),nPosHOld+010,oEmitente:_xNome:Text,oFont10N)
	oDanfe:Say(nPosVOld+Char2PixV("XX",oFont10N)+Char2PixV("Xx"   ,oFont10),nPosHOld+010,oEmitente:_EnderEmit:_xLgr:Text+", "+oEmitente:_EnderEmit:_Nro:Text,oFont10)
	oDanfe:Say(nPosVOld+Char2PixV("XX",oFont10N)+Char2PixV("XxX"  ,oFont10),nPosHOld+010,oEmitente:_EnderEmit:_xBairro:Text+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont10)
	oDanfe:Say(nPosVOld+Char2PixV("XX",oFont10N)+Char2PixV("XxXX" ,oFont10),nPosHOld+010,oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont10)
	oDanfe:Say(nPosVOld+Char2PixV("XX",oFont10N)+Char2PixV("XxXXX",oFont10),nPosHOld+010,"Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont10)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 2                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosHOld := nPosH+HSPACE
nPosH    := nPosHOld + 360
nPosHOld += Int(((360-Char2Pix("DANFE")))/3)
	nAux := nPosVOld
	oDanfe:Say(nAux,nPosHOld,"DANFE",oFont18N)
	nAux += Char2PixV("XXX",oFont18N)
	oDanfe:Say(nAux,nPosHOld-050,"Documento Auxiliar da",oFont07N)
	nAux += Char2PixV("XX",oFont07)
	oDanfe:Say(nAux,nPosHOld-050,"Nota Fiscal Eletrônica",oFont07N)
	nAux += Char2PixV("XXX",oFont07)
	oDanfe:Say(nAux,nPosHOld-050,IIf(oIdent:_TpNf:Text=="1","SAÍDA","ENTRADA"),oFont18N)
	nAux += Char2PixV("XXXX",oFont18N)
	oDanfe:Say(nAux,nPosHOld-050,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont07N)
	nAux += Char2PixV("XX",oFont07)
	oDanfe:Say(nAux,nPosHOld-050,"Série "+oIdent:_Serie:Text,oFont07N)
	nAux += Char2PixV("XX",oFont07)
	oDanfe:Say(nAux,nPosHOld-050,"Folha "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont07)
	nAux += Char2PixV("XX",oFont07)
nPosHOld := nPosH+HSPACE
nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Codigo de barra                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFolha == 1
	MSBAR3("CODE128",2.2,11,SubStr(oNF:_InfNfe:_ID:Text,4),oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.0211,2.2,/*lBanner*/,/*cFont*/,"C",.F.)
Else
	MSBAR3("CODE128",0.6,11,SubStr(oNF:_InfNfe:_ID:Text,4),oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.0211,2.2,/*lBanner*/,/*cFont*/,"C",.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 4                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+VSPACE
nPosV += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	
	nAux := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV("x",oFont07),nAux,"Inscricao estadual",oFont07)	
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Nat.da operação",oFont07)	
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Insc.Estadual do Subst.Trib.",oFont07)	
	nAux += Char2Pix(Repl("X",35),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CNPJ",oFont07)	
	nAux += Char2Pix(Repl("X",16),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Chave de acesso da NF-e - Consulta no site http://www.nfe.gov.br",oFont07)
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	
	nAux := nPosHOld+010
	nPosVOld+=Char2PixV("X",oFont07)*3.5
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,oEmitente:_IE:TEXT,oFont07)
	nAux += Char2Pix(Repl("X",20),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,oIdent:_NATOP:TEXT,oFont07)	
	nAux += Char2Pix(Repl("X",40),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"",oFont07)	
	nAux += Char2Pix(Repl("X",35),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")),oFont07)	
	nAux += Char2Pix(Repl("X",16),oFont07)+010
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,SubStr(oNF:_InfNfe:_ID:Text,4),oFont07)
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	
nFolha++	
	
Return(nPosV)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Complemento da NFe                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Static Function DanfeCpl(oDanfe,aItens,nItem,oNFe,oIdent,oEmitente,nFolha,nFolhas)

Local nX := 0
Local nHPage     := 0 
Local nPosV      := 0
Local nPosVOld   := 0
Local nPosH      := 0
Local nPosHOld   := 0
Local nAux       := 0

oDanfe:StartPage()
nPosV := DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,@nFolha,nFolhas)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do produto ou servico                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHPage := oDanfe:nHorzRes()-HMARGEM
nPosVOld := nPosV+VSPACE
nPosV    += VBOX
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"DADOS DO PRODUTO / SERVIÇO",oFont07)
nPosV    += Char2PixV("XX",oFont07)
nPosVOld += Char2PixV("XX",oFont07)
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+005
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Cod.Prod.",oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_COD")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Descrição do Produto/Serviço",oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"NCM/SH",oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_POSIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CST",oFont07)	
	nAux += Char2Pix(Repl("X",03),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"CFOP",oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"UN",oFont07)
	nAux += Char2Pix(Repl("X",002),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"Quantidade",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_QUANT")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.Unitário",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_PRCVEN")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.Total",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_TOTAL")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"BC.ICMS",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_BASEICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.ICMS",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"V.IPI",oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"A.ICM",oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,"A.IPI",oFont07)

nPosVOld := nPosV+2
nPosV += VBOX*0.5
nX := 0
While nX < 70
	nX++
	nPosHOld := HMARGEM
	nPosH    := nHPage
	oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	nAux := nPosHOld+Char2PixV("X",oFont07)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][01],oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_COD")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][02],oFont07)	
	nAux += Char2Pix(Repl("X",30),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][03],oFont07)	
	nAux += Char2Pix(Repl("X",TamSX3("B1_POSIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][04],oFont07)	
	nAux += Char2Pix(Repl("X",03),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][05],oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][06],oFont07)
	nAux += Char2Pix(Repl("X",002),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][07],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_QUANT")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][08],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_PRCVEN")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][09],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_TOTAL")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][10],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_BASEICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][11],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALICM")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][12],oFont07)
	nAux += Char2Pix(Repl("X",TamSX3("D2_VALIPI")[1]),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][13],oFont07)
	nAux += Char2Pix(Repl("X",005),oFont07)+010
	oDanfe:Box(nPosVOld,nAux-005,nPosV,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV("X",oFont07),nAux,aItens[nItem][14],oFont07)
	nPosVOld := nPosV+2
	nPosV += VBOX*0.5
	nItem++
	If nItem > Len(aItens)
		Exit
	EndIf
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalizacao da pagina do objeto grafico                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:EndPage()
Return(.T.)

Static Function Char2Pix(cTexto,oFont)

Return(GetTextWidht(0,cTexto,oFont)*2)

Static Function Char2PixV(cChar,oFont)

Return(GetTextWidht(0,cChar,oFont)*Len(cChar))