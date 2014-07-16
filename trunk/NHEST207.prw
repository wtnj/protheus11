/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa � NHEST207  �Autor � Guilherme D. Camargo  �Data � 27/08/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     �          CADASTRO DE PERMISS�ES DE                         ���
���          �         MOVIMENTA��O ENTRE ARMAZ�NS                        ���
�������������������������������������������������������������������������͹��
���Uso       �             ESTOQUE / CUSTOS                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.ch"

User Function NHEST207()
Private cQuery := ''
Private aRotina, cCadastro
cCadastro := "Movimenta��o Armaz�ns."
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"AxVisual" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"        ,"u_e207Inc"    , 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"u_e207Alt"  	, 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"u_e207Del"  	, 0 , 5})
mBrowse(6,1,22,75,"ZEQ",,,,,,)
Return

/*����������������������������������������������
�������        Fun��o de Inclus�o        �������
�����������������������������������������������*/
User Function e207Inc()
Local nOpca := 0
Private cCadastro := "Movimenta��o Armaz�ns."

dbSelectArea("ZEQ")
nOpca := AxInclui("ZEQ",ZEQ->(Recno()),3,,"u_e207Grv",,"U_E207TOK()",.F.,,,,,,.T.,,,,,)
Return nOpca

User Function e207Grv()

RecLock("ZEQ",.F.)
	ZEQ->ZEQ_USRINC := AllTrim(Upper(cUserName))
MsUnlock("ZEQ")

Return

/*����������������������������������������������
�������        Fun��o de Dele��o        �������
�����������������������������������������������*/
User Function e207Del()
Local nOpca := 0
Private cCadastro := "Movimenta��o Armaz�ns."

dbSelectArea("ZEQ")

If u_E207TOK(5)
	nOpca := AxDeleta("ZEQ",ZEQ->(Recno()),5,,,,,,.T.)	
Else
	nOpca = .F.
Endif

Return nOpca

/*����������������������������������������������
�������       Fun��o de Altera��o        �������
�������       ** N�O HABILITADA **       �������
�����������������������������������������������*/
User Function e207Alt
	Alert("Opera��o n�o Dispon�vel!")
Return .F.

/*���������������������������������������������������������������
�������   Fun��o que verifica o tipo da movimenta��o e    �������
�������   se o usu�rio possui permiss�o para realiz�-la.  �������
�����������������������������������������������������������������*/
User Function E207TOK(nParam)
Local nMovim
Local nLocal
Local nLocalD
If nParam == 5
	nMovim = ZEQ_MOVIM
	nLocal = ZEQ_LOCAL
	nLocalD = ZEQ_LOCALD
Else
	nMovim = M->ZEQ_MOVIM
	nLocal = M->ZEQ_LOCAL
	nLocalD = M->ZEQ_LOCALD
Endif
	If nMovim == 'T'
		ZF0->(DbSetOrder(1))
		If !alltrim(Upper(cUserName))$'JOAOFR/ALEXANDRERB/MARCOSR/ADMIN/ADMINISTRADOR/JOSEMF/DOUGLASSD/GUILHERMEDC/EDENILSONAS/JOSEMAB/PAULORL'
			If !ZF0->(DbSeek(xFilial("ZF0") + PadR(Upper(cUserName),20) + nLocal)) .AND.;
			!ZF0->(DbSeek(xFilial("ZF0") + PadR(Upper(cUserName),20) + nLocalD))
				Alert("Voc� deve ser repons�vel por, pelo menos, um dos armaz�ns para editar as permiss�es!")
				Return .F.
   			Endif
   		Endif   		
  	Elseif nMovim == 'B'
		ZF0->(DbSetOrder(1))
		If !alltrim(Upper(cUserName))$'JOAOFR/ALEXANDRERB/MARCOSR/ADMIN/ADMINISTRADOR/JOSEMF/DOUGLASSD/GUILHERMEDC/EDENILSONAS/JOSEMAB/PAULORL'
			If !ZF0->(DbSeek(xFilial("ZF0") + PadR(Upper(cUserName),20) + nLocal))
				Alert ("Somente o respons�vel pelo Armaz�m pode editar as permiss�es!")
				Return .F.
			Endif
		Endif
	Endif
Return .T.