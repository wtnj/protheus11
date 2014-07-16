/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST138  � Autor � Jo�o Felipe da Rosa    Data � 11/12/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Controle de Orderm de Libera��o Receb. Conferente          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Conferente                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function nhest138()

SetPrvt("CCADASTRO,AROTINA,")


cCadastro := OemToAnsi("Ordem de Libera��o de Materiais")
aRotina := {{ "Pesquisa","AxPesqui"    ,  0 , 1},;
            { "Visualizacao",'U_EST137(2)'  , 0 , 2},;
            { "Conferente"   ,'U_EST137(7)' , 0,3}}

mBrowse( 6, 1,22,75,"ZB8",,,,,,fCriaCor())
Return

Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERMELHO", "Fechado"  },;
  						{"BR_VERDE"   , "Aberto"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZB8_HRCONF <> " "', aLegenda[1][1] } )
Aadd(uRetorno, { 'ZB8_HRCONF = " "' , aLegenda[2][1] } )

Return(uRetorno)
