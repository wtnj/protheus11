/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE120 �Autor  �Marcos R Roquitski  � Data �  31/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consultas vagas em aberto.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch" 
#include "protheus.ch" 
#include "msole.ch" 

User Function Nhgpe120()

SetPrvt("aRotina,cCadastro,aCores")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Historico","U_NhGpe152",0,5},;              
             {"Legenda","U_Gp118Legenda",0,3}}
                              
cCadastro := "Cadastro de Vagas"

aCores    := {{ 'ZQS_STATUS==Space(01)','BR_VERDE'},;
					    { 'ZQS_STATUS=="1"' , 'BR_BRANCO'   },;
					  	{ 'ZQS_STATUS=="2"' , 'BR_AMARELO' },;
					  	{ 'ZQS_STATUS=="3"' , 'BR_AZUL' },;
					    { 'ZQS_STATUS=="4"' , 'BR_VERMELHO' }}
					    
DbSelectArea("ZQS")
ZQS->(DbGotop())
mBrowse(,,,,"ZQS",,,,,,aCores)
Set Filter to 
ZQS->(DbGotop())

Return
