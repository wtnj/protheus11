/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M380ZEMP  �Autor  �Jo�o Felipe da Rosa � Data �  25/09/2012 ���
�������������������������������������������������������������������������͹��

���Desc.     � Este ponto de entrada tem como objetivo permitir ao usu�rio 
determinar se o processo de zerar o empenho ser�, ou n�o executado quando 
for confirmada a altera��o. � poss�vel  utiliz�-lo para determinar, por 
exemplo, se o usu�rio tem, ou n�o permiss�o para zerar o empenho.
LOCALIZA��O: Ponto de entrada localizado na fun��o "A380ZEmp" da rotina 
de ajuste de empenhos. � nesta fun��o que o usu�rio confirma se o empenho 
ser�, ou n�o zerado.EM QUE PONTO: Ser� executado quando o usu�rio clicar 
no bot�o "Zera Empenho Lote/Endere�o" durante a rotina de altera��o do empenho. 
UTILIZA��O: Quando o usu�rio clicar no bot�o "Zera Empenho Lote/Endere�o" 
o sistema emite um aviso solicitando ao usu�rio a confirma��o para zerar 
o empenho. Se o PE retornar um valor l�gico falso (.F.) o sistema n�o 
emitir� o aviso e o processo de zerar empenhos n�o ser� realizado.
PAR�METROS DE ENVIO: Nenhum par�metro � enviado ao ponto de entrada.
PAR�METROS DE RETORNO: Dever� ser retornado um valor l�gico 
verdadeiro (.T.) ou falso (.F.) indicando ao sistema se o processo de 
zerar empenhos ser� ou n�o realizado..                                

���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M380ZEMP()

If !alltrim(upper(cusername))$"ANAP/ROGERIO/FERNANDOW/JOAOFR/ALEXANDRERB/ADMIN"
	Alert("N�o � poss�vel zerar empenhos! Favor entrar em contato com Controladoria!")
	Return .F.
endif

return .T.