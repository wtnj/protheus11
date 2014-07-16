/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT241CAB   ºAutor  ³João Felipe da Rosa  º Data ³  05/03/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para incluir campos no cabeçalho da       º±±
±±º          ³ rotina MATA241 (Internos Mod. 2)                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 LOGISTICA ALMOXARIFADO                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "protheus.ch"             

User Function MT241CAB()
Local nSolic := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_SOLICIT"})
Public _cMat := Space(6)
Public _lMata185 := .T.
Public _cNome := ""

If UPPER(FUNNAME())$"MATA185/NHEST161/NHEST164"

	QAA->(dbSetOrder(6)) //LOGIN
	If QAA->(dbSeek(SCP->CP_SOLICIT))
		_cMat  := QAA->QAA_MAT
		_cNome := QAA->QAA_NOME
		
		For xA:=1 to Len(aCols)
			aCols[xA][nSolic] := QAA->QAA_MAT
		Next		

	Else
		alert("SOLICITANTE NÃO CADASTRADO NO CADASTRO DE USUÁRIOS!!!!!!!!!!!!!" + chr(10)+chr(13)+ chr(10)+chr(13)+;
		"SOLUÇÃO: Verifique se o usuário está cadastrado em: Estoque/Custos -> Atualizações -> Cadastros -> Usuários " + chr(10)+chr(13)+ ;
		"Se o usuário estiver cadastrado, verifique o campo Login se está preenchido!" + chr(10)+chr(13)+ ;
		"Se você não tiver acesso ao caminho acima, entre em contato com pessoal do Almoxarifado!" )
	EndIf

	_lMata185 := .F.

EndIf

IF !INCLUI .AND. !ALTERA
	_cMat := D3_SOLICIT
ENDIF

@ 0.4,37.4+Len(cDocumento) SAY "Solicitante"
@ 0.3,41.4+Len(cDocumento) MSGET _cMat F3 "QAA" WHEN ((INCLUI .OR. ALTERA) .and. _lMata185 .and. SM0->M0_CODIGO=="NH") SIZE 35,8 VALID fValSolic()

If !_lMata185
	@ 0.3,46+Len(cDocumento) MSGET _cNome WHEN .F. SIZE 60,8
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ OBS.: UTILIZA O PONTO DE ENTRADA MT241GRV PARA GRAVAR ESTE CAMPO (D3_SOLICIT)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ6
//³ VALIDA A MATRICULA DO SOLICITANTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValSolic()
	
	If SM0->M0_CODIGO=="NH"
		QAA->(DBSETORDER(1)) // FILIAL + MAT
		IF !QAA->(DBSEEK(XFILIAL("QAA")+_cMat))
			Alert("Solicitante não cadastrado!")
			Return .F.
		ENDIF
	EndIf
		
Return .T.