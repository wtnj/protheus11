/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MT250est � Autor �  Alexandre R. Bento  � Data � 20/05/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � VALIDACAO na Exclusao de Ordem de Producao                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Para Controle na exclusao de OP                            ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"              

User Function MT250EST
Local lRet := .T.//-- Valida��es do Cliente
Local _nDias   := GETMV("MV_DIASMO")

If SM0->M0_CODIGO$"FN/NH"
	If SD3->D3_EMISSAO < (Date()- _nDias) .OR. SD3->D3_EMISSAO < (dDatabase - _nDias)  //Controle de data para n�o permitir mov. com data retroativa controle paramatro mv_diasmo = numero de dias
	   MsgBox( "Impossivel Fazer Exclusao com Data Menor que a Permitida pelo Depto Custo! - P.E. - MT250EST", "Exclusao OP", "ALERT" )
	   lRet := .F.
	Endif
	
Endif


Return(lRet)   //-- Retorna variavel logica sendo:  .