#INCLUDE 'rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT031     ºAutor  ³JOAO FELIPE DA ROSAº Data ³  05/09/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  VALIDA O CAMPO D3_ORDEM NA BAIXA DA O.S.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION NHMNT031()

IF UPPER(FUNNAME())$'MATA241'
	DBSELECTAREA('STJ')
	DBSETORDER(1)//FILIAL + ORDEM
	IF DBSEEK(XFILIAL('STJ')+M->D3_ORDEM)
		
		IF ALLTRIM(STJ->TJ_CCUSTO) == Iif(SM0->M0_CODIGO=="FN","IMOBILIZ","IMOBIL")
			MsgBox("Centro de custo para o Bem desta OS não pode ser "+Iif(SM0->M0_CODIGO=="FN","IMOBILIZ","IMOBIL"),"C.Custo Inválido","INFO")
			Return .F.
		ENDIF
		
		CTT->(DBSETORDER(1)) //FILIAL + CCUSTO
		IF CTT->(DBSEEK(XFILIAL('CTT')+STJ->TJ_CCUSTO))
			IF CTT->CTT_BLOQ == '1'
				MsgBox('Centro de custo para o Bem desta OS está bloqueado no cadastro','C.Custo Inválido','INFO')
				Return .F.
			ENDIF
			
		ELSE
			MsgBox('Centro de Custo para o Bem desta OS não existe no cadastro','C.Custo Inválido','INFO')
			Return .F.
		ENDIF
	ELSE
		MsgBox("Ordem de Servico não existe no cadastro. Verifique!","OS não existe","INFO")    	
		Return .F.
	ENDIF
ENDIF

RETURN .T.