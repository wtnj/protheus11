/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHCOM019        � Alexandre R. Bento    � Data � 10/08/07 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada q traz lead time do produto e soma na data���
���          � Entrega prevista e o usuario n�o pode alterar p/ baixo    ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


#include "rwmake.ch"   

User Function NHCOM019()

Local _nCC    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_CC"})  
Local _nConta := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_CONTA"})  
Local _nOS    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_NUMOS"})  
Local _lOK    := .T.  


If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada

   If !Empty(Alltrim(Acols[n][_nOS]))
      ZA1->(DbsetOrder(1))
      If ZA1->(DbSeek(xFilial("ZA1")+Acols[n][_nOS]))
         Acols[n][_nCC]    := ZA1->ZA1_CC
         Acols[n][_nConta] := ZA1->ZA1_CONTA
      Else
         _lOK  := .F.        
      Endif
      
   Endif 

Endif	
		
Return(_lOK)
          
