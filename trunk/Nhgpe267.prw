/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE267  �Autor  �Marcos R Roquitski  � Data �  14/08/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Responsavel  Centro de Custo                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch" 
#INCLUDE "PROTHEUS.CH"  

User Function NhGpe267() 

SetPrvt("cCadastro,aRotina")

cCadastro := 'Cadastro de Supervisao\Centro de Custo"

aRotina := {{ "Pesquisa","AxPesqui"    ,0,1},;
            { "Visual"  ,"AxDeleta"    ,0,2},;
            { "Inclui"  ,"AxInclui"    ,0,3},;
            { "Excluir", "AxExclui"    ,0,4},;     // botao excluir            
            { "Altera"  ,"AxAltera"    ,0,3}}

DbSelectArea("ZRJ")
ZRJ->(DbGotop())
mBrowse(,,,,"ZRJ",,,,,,)

Return

