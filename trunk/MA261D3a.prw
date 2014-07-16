/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MA261D3         � Antonio Carlos Annies � Data � 11.07.03 ���
������������������������������������������������������������������������Ĵ��
���Descri��o �  Grava��o de Defeitos do Refugo no SD3                    ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


#INCLUDE "rwmake.ch" 
#INCLUDE "TOPCONN.CH"

User Function MA261D3() 

   SetPrvt("cQuery")

	cQuery := "UPDATE " + RetSqlName( 'SD3' ) 
	cQuery := cQuery + " SET D3_DEFEITO =  SUBSTRING(D3_NUMSERI,1,2), D3_CARDEF = SUBSTRING(D3_NUMSERI,3,3), D3_NUMSERI = ' '"
	cQuery := cQuery + " WHERE D_E_L_E_T_ <> '*' "
	cQuery := cQuery + " AND D3_NUMSERI <> ' ' "
	TCSQLExec(cQuery)

Return