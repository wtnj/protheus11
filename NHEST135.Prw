
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  NHEST135 � Autor �  Alexandre R. Bento  � Data � 22/12/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao no valor unitario permiti alterar 1 centavo      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Para Controle na digitacao da NF pelo fiscal               ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

     
#include "rwmake.ch"              

User Function NHEST135()      

Local _cPedido:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_PEDIDO"})
Local _cItem  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_ITEMPC"})
Local _cVunit := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_VUNIT"})
Local _lRet   := .T.    
Local _nRecSC7, _nIndSC7

                     
If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
   
	_nRecSC7 := SC7->(RECNO())   
    _nIndSC7 := SC7->(IndexOrd())         	         
	SC7->(DbSetOrder(1)) // Filial + pedido + item 
    If SC7->(DbSeek(xFilial("SC7")+Acols[n][_cPedido]+Acols[n][_cItem]))
	   If ((Acols[n][_cVunit] - SC7->C7_PRECO) > 0.01) .Or. ((Acols[n][_cVunit] - SC7->C7_PRECO) < -0.01)
	      MsgBox("Atencao Nao Pode Alterar o Pre�o Unitario Acima de Um Centavo","Atencao","ALERT")
	      _lRet   := .F.	          
	   Endif   
    Endif
    SC7->(DbGoTo(_nRecSC7))       // Volta para o Ponto inicial
	SC7->(DbSetOrder(_nIndSC7)) // Volta para o indice anterior
Endif   
   
Return(_lRet)
       