/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Mt241TOK        ³ Osmar Schimitberger   ³ Data ³09.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada para validar inclusão da rotina MATA241  ³±±
±±³            Internos Modelo 2										 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque / Custos                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"

User Function MT241TOK

SetPrvt("_CCC,_cLocal,_cCarDef,_cDefeito,_cFornece,_cLoja,_cOperaca,_nCC,_nLote,_nOrdem")

_CCC      := Alltrim(CCC)

_nSolic   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_SOLICIT"})
_cLocal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"})
_cCarDef  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CARDEF"})
_cDefeito := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_DEFEITO"})
_cFornece := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_FORNECE"})
_cLoja    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOJA"})
_cOperaca := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_OPERACA"})
_nCC      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CC"})
_cProd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
_nLote    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOTECTL"})
_nOrdem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_ORDEM"})

// Verifica se produto está bloqueado para inventário
IF !aCols[n][len(aHeader)+1]
	IF !U_E205BLQ(Acols[n][_cProd],Acols[n][_cLocal],.F.)
		Return .F.
	EndIF
ENDIF

If Empty(_CCC) .Or. Len(_CCC) < Iif(SM0->M0_CODIGO=="FN",8,6)
	MSGBOX("O CENTRO DE CUSTO é Obrigatório e Com "+STRZERO(Iif(SM0->M0_CODIGO=="FN",8,6),1)+" Dígitos, REDIGITE Novamente para Contabilizar Corretamente!!!!!!!!","Atenção Centro de Custo","STOP")
	Return(.F.)
Endif

If Subs(_CCC,2,1)$"5"
	
	SB1->(dbSetOrder(1)) // filial + cod
	SB1->(dbSeek(xFilial("SB1")+aCols[n,_cProd]))
	
	If !Subs(aCols[n,_cProd],1,3)$"MOD" .and. (!AllTrim(UPPER(cUserName))$"VALDELENEMS" .AND. (!AllTrim(UPPER(cUserName))$"ANAP/MARIOCP/DEVANIRLO/IVONEI.FERREIRA/LUCIANOC/ROGERIO" .and. ALLTRIM(SB1->B1_TIPO)$"PI/PA"))//fundicao cc iniciando com 4 ou 5
		MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
		Return(.F.)
	Endif
	
Endif

If (DA241DATA > Ddatabase)
	MSGBOX("A Data esta Maior que a Data do Sistema Verifique !!!!!","Atencao Data Errada","STOP")
	Return(.F.)
Endif

If SM0->M0_CODIGO == "NH"
	If aCols[n,_cLocal]$"99/00" .And. CTM <> "501"
		If Empty(aCols[n,_cDefeito]) .Or. Empty(aCols[n,_cCarDef]) .Or. Empty(aCols[n,_cFornece]) .Or.;
			Empty(aCols[n,_cLoja]) .Or. Empty(aCols[n,_cOperaca])
			MsgBox( OemToAnsi("Impossivel Fazer a Movimentação, pois não foi informado todos as campos referente ao Refugo ! - P.E. - MT241TOK"), OemToAnsi("Movimentação de Refugo"), "ALERT" )
			Return(.F.)
		Endif
	Endif
	//verifica se existe o fornecedor digitado para o refugo da qualidade
	//  SA5->(DbSetOrder(1))  //filial+Fornece+loja+produto
	//  If !SA5->(Dbseek(xfilial("SA5")+aCols[n,_cFornece]+aCols[n,_cLoja]+aCols[n,_cProd]))
	//    MsgBox( "Nao Existe este Fornecedor e loja cadastrado no Arquivo SA5, Verifique!", "Internos Mod 2", "ALERT" )
	//    Return(.F.)
	//  Endif
Endif


If (CTM$"001/501") .AND.(_CCC=='ALMOXARI')
	MsgBox("Este centro de custo não é permitido para este tipo de movimento, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
	return(.F.)
EndIf

If SM0->M0_CODIGO == "IT"

	If (CTM$"501/505") .And. Subs(aCols[n,_cProd],1,2)$'PA' .And. !AllTrim(Upper(cUserName))$"VALDELENEMS/ANDREIA.SCHAMNE"
		MsgBox("Este tipo de movimento não é permitido, favor entrar em contato com Depto de Custos.","Atencao","ALERT") // Baixa
		Return(.F.)
	EndIf
	
	If (CTM$"001/201") .And. Subs(aCols[n,_cProd],1,2)$'PA' .And. !AllTrim(Upper(cUserName))$"VALDELENEMS/ANDREIA.SCHAMNE"
		MsgBox("Este tipo de movimento não é permitido, favor entrar em contato com Depto de Custos.","Atencao","ALERT")// Inclusão
		Return(.F.)
	EndIf

EndIf


//Solicitado por FernandoW devido a varios problemas de movimentação com o tipo de mov. 001 e 201
If CTM$"001/201"
	If !AllTrim(UPPER(cUserName))$"REGINASM/FERNANDOW/DAIANESC/VALDELENEMS/ANAPP/LUCIANODB/LEANDROJS/ADMINISTRADOR/LUISC/TIAGOMS/JONESTONBM/GLAYSONLR/"+;
		"ANDERSONSC/JOAOG/ROGERIO/DOUGLASFS/EVERTONG/DEVANIRLO/DIOGOBA/MARIOCP/LUCASDS/GEANCS/JOAOFR/DANILOCS/MATEUSHD/EDERSON/"+;
		"PLINIOMS/DOUGLASSD/MARINAMB/IVONEI.FERREIRA/ANTONIOVG/DIOGOPO/JEFFERSONAS/ERICALP/DOUGLASF/SILVANA.MOREIRA/ANDREIA.SCHAMNE/ANGELAMH"
		MsgBox("Somente o Depto de Custo Pode Utilizar Este Tipo de Movimentação, Duvida Ligue p/ Depto de Custo!","Movimentaçao P.E. MT241TOK","ALERT")
		Return(.F.)
	Endif
EndIf

//-- verifica quando houver o campo de OS de Manutencao preenchido, se o C.Custo do Bem da OS é o mesmo do C.Custo digitado
if aCols[n,_nOrdem] <> ' '
	Dbselectarea("STJ")
	dbSetOrder(1)
	STJ->(DbSeek(xFilial("STJ")+aCols[n,_nOrdem]))
	
	if STJ->TJ_CCUSTO <> _CCC
		MsgBox( "Atencao o CENTRO DE CUSTO DA O.S. difere do digitado", "ALERT" )
		Return(.F.)
	Endif
endif

//-- nhpcp010 = digitacao de fornada
If !ALLTRIM(UPPER(FUNNAME()))$"NHPCP010/NHPCP037"
	If Empty(_cMat)
		If SM0->M0_CODIGO=="NH"
			Alert("Solicitante não cadastrado!")
			Return .F.
		EndIf
	EndIf
EndIf

/**
* Verifica a Durabilidade do EPI se for o caso
*/
If AllTrim(Upper(FunName()))$"MATA185"//-- Rotina de Baixa de PreRequisicao
	
	//Verifica se existe solicitacao de EPI na tabela ZDC para esta baixa
	ZDC->(dbSetOrder(2)) //FILIAL + NUMSA
	If ZDC->(dbSeek(xFilial("ZDC")+SCP->CP_NUM))
		
		SRA->(dbSetOrder(1)) // FILIAL + MAT
		SB1->(dbSetOrder(1)) // FILIAL + COD
		
		//-- percorre os itens da solicitacao a ser baixada
		For xP:=1 to Len(aCols)
			
			//-- percorre os ítens da solicitacao de epi
			WHILE ZDC->(!EOF()) .AND. ZDC->ZDC_NUMSA==SCP->CP_NUM
				
				//-- descarta os itens que nao forem iguais ao item a ser verificado
				If ZDC->ZDC_PROD<>Acols[xP][_cProd]
					ZDC->(dbSkip())
					Loop
				EndIf
				
				//-- Retorna a data da última baixa do epi para o funcionário
				dDtUltBx := fUltBx(ZDC->ZDC_PROD,ZDC->ZDC_MAT)
				
				//-- Obtém a durabilidade do EPI na tabela de produtos
				dDurabil := Posicione("SB1",1,xFilial("SB1")+ZDC->ZDC_PROD,"B1_DURA")
				
				//-- Verifica se a durabilidade está vigente
				If (dDtUltBx + dDurabil) > date()
					cMsg := "D U R A B I L I D A D E !" + CHR(13)+CHR(10) + CHR(13)+CHR(10)
					cMsg += "O Funcionário " + AllTrim(Posicione("SRA",1,xFilial("SRA")+ZDC->ZDC_MAT,"RA_NOME"))
					cMsg += " já retirou o EPI " + AllTrim(ZDC->ZDC_PROD) + " no dia "+DtoC(dDtUltBx)+"!" + CHR(13)+CHR(10)
					cMsg += " Para realizar a baixa "
					cMsg += " deverá aguardar " + AllTrim(Str(dDurabil - (date() - dDtUltBx))) + " dias! "
					MSGBOX(cMsg,'Atenção','INFO')
					
					//	Return .F.
				EndIf
				
				ZDC->(dbSkip())
			ENDDO
			
		Next
		
	EndIf
	
	//-- verifica o campo solicitante se está preenchido quando for produto do tipo FE
	If SM0->M0_CODIGO=="FN" // empresa Fundicao
		SB1->(dbSetOrder(1)) // filial + cod
		For xA:=1 to Len(aCols)
			SB1->(dbSeek(xFilial("SB1")+aCols[xA,_cProd]))
			If AllTrim(SB1->B1_TIPO)$"FE" .and. empty(aCols[xA,_nSolic])
				Alert("Solicitante não informado para o item "+STRZERO(xA,4)+" - "+AllTrim(aCols[xA,_cProd])+"!")
				Return .F.
			EndIf
		Next
	EndIf
	
EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ,¿
//³ VERIFICA A ULTIMA BAIXA DO EPI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ,Ù
Static Function fUltBx(cEpi,cMatr)
Local dDt := ctod('  /  /  ')
Local cAl := 'DURABIL'

beginSql Alias cAl
	SELECT
	TOP 1 D3.D3_EMISSAO data
	FROM
	%Table:SD3% D3
	JOIN
	%Table:ZDC% ZDC
	ON
	ZDC.ZDC_FILIAL = %xFilial:ZDC%
	AND ZDC.ZDC_DOC = D3.D3_DOC
	AND ZDC.ZDC_PROD = D3.D3_COD
	AND ZDC.ZDC_MAT = %Exp:cMatr%
	AND ZDC.ZDC_PROD = %Exp:cEpi%
	WHERE
	D3.D3_TM > '500'
	AND D3.D_E_L_E_T_ = ' '
	AND D3.D3_ESTORNO <> 'S'
	ORDER BY
	D3.R_E_C_N_O_ DESC
endSql

If (cAl)->(!Eof())
	dDt := StoD((cAl)->data)
EndIf

(cAl)->(dbCloseArea())

Return dDt
