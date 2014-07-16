/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST046  �Autor  �Marcos R Roquitski  � Data �  12/17/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Browse no tabela SZB, Inventario.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"  

User Function NhEst046()   

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Inventario'

aRotina := {{ "Pesquisar" ,"AxPesqui",0,1},;
			{ "Consulta"  ,"AxVisual",0,2},;
            { "Incluir"   ,'U_NhEst178(1)',0,3},;
            { "Incluir Novo",'U_NhEst047(1)',0,3},;            
            { "Alterar Novo",'U_NhEst047(2)',0,4},;            
			{ "Excluir"   ,"AxDeleta",0,5}}

cCadastro := 'Inventario'            

mBrowse(,,,,"SZB")                           

Return(nil)    