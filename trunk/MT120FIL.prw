/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MT120FIL        � Alexandre R. Bento    � Data �02.08.2007���
������������������������������������������������������������������������Ĵ��
���Descricao � Antes da apresenta�ao da interface da Mbrowse e ap�s a    ���
���          � prepara�ao da filtragem dos grupos de compras. 			 ���
������������������������������������������������������������������������Ĵ��
���Uso       � Depto de Compras                                          ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
//nTipo  Num�rico  nTipo == 1 - Pedido de Compras   
//                 nTipo == 2 - Autoriza��o de Entrega

#Include "rwmake.ch"    

User Function MT120FIL() 

Local cFiltro := ''
//No browse da autorizacao de entrega so ira mostrar as autorizacoes de entrega
If Alltrim(Funname()) == "MATA122" // Autoriza��o de entrega
   cFiltro :=  '  C7_TIPO = 2  ' //c7_tipo == 2 Autoriza��o de entrega
Endif   

Return (cFiltro) 

