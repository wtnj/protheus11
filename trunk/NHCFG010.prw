
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCFG010     �Autor  �Joao Felipe da Rosa � Data �  08/20/08���
�������������������������������������������������������������������������͹��
���Desc.     � CRIA TABELA COM AXCADASTRO                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "colors.ch"

User Function NHCFG010()

Local _cTab := Space(3)

@ 001,005 TO 100,160 DIALOG oDialog TITLE "Criacao de Tabela"                                                

@ 010,010 say "Tabela:"  Color CLR_BLUE Size 040,8 object olTab
@ 010,030 Get _cTab Picture "@!" Size 040,010 object oTab

@ 025,010 BMPBUTTON TYPE 01 ACTION fAbreTab(_cTab)
@ 025,040 BMPBUTTON TYPE 02 ACTION Close(oDialog)                  

ACTIVATE MsDialog oDialog CENTER

Return 

Static Function fAbreTab(_cPar)

AxCadastro(_cPar)

Return

