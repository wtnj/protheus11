/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NGFINALI � AUTOR: Jo�o Felipe da Rosa � Data � 16/09/2008 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � CHAMADA NO MOMENTO DA CONFIRMA��O DO RETORNO DA O.S.      ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                           ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

User Function NGFINALI()

Local lInclOld := Inclui
Local aOldArea := GetArea()
Private Inclui   := .T.

If MsgYesNo("Efetua Lancamento de ATRASO S/N",OemToAnsi('ATENCAO'))

 
	Private aChoice  := {},aRelac  := {},bNgGrava := {},aSMENU := {},aCHKDEL := {}
	aOldRot  := aClone(aRotina)
	Private aRotina := {{"Pesquisar"  ,"PesqBrw" , 0, 1},; 
	                    {"Visualizar" ,"AXVISUAL", 0, 2},;
	                    {"Incluir"    ,"NG401INC", 0, 3},; 
	                    {"Alterar"    ,"NG401INC", 0, 4},; 
	                    {"Excluir"    ,"NG401INC", 0, 5, 3}}
	 
	cPrograma := "MNTA400"
	 
	aRelac := {{"TPL_ORDEM","STJ->TJ_ORDEM"}}
	 
	DBSELECTAREA('TPL')
	DBSETORDER(2) //TPL_FILIAL+TPL_ORDEM+TPL_CODMOT
	IF DBSEEK(XFILIAL('TPL')+ALLTRIM(STJ->TJ_ORDEM))
		NGCAD01("TPL",Recno(),4) //ALTERAR
	ELSE
		DBGOBOTTOM()
		DBSKIP()
		NGCAD01("TPL",Recno(),3) //INCLUIR
	ENDIF

	 
	RestArea(aOldArea)//RETORNA A �REA ANTERIOR
	Inclui := lInclOld //RETORNA O CONTE�DO ANTERIOR
	aRotina := aClone(aOldRot) //RETORNA O CONTE�DO ANTERIOR
endif

Return .t.
/*
            
USER FUNCTION TPLSEEK(_cOrdem, _cCodMot)

	DBSELECTAREA('TPL')
	DBSETORDER(2) //TPL_FILIAL+TPL_ORDEM+TPL_CODMOT
	IF DBSEEK(XFILIAL('TPL')+ALLTRIM(_cOrdem)+ALLTRIM(_cCodMot))

		M->TPL_DTINC := TPL->TPL_DTINC
		M->TPL_HOINC := TPL->TPL_HOINC
		M->TPL_DTFIM := TPL->TPL_DTFIM
		M->TPL_HOFIM := TPL->TPL_HOFIM
	
	ENDIF


Return .F.
*/
 

