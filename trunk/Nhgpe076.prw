/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE076  �Autor  �Marcos R Roquitski  � Data �  13/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Movimento de ferias.                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhgpe076()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_fAfastfer()",0,4} }
             

cCadastro := "Cadastro de Afastamentos"

mBrowse(,,,,"ZRA",,,)

Return


User Function fAfastfer()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2},;
             {"Incluir","AxInclui",0,3},;
             {"Alterar","AxAltera",0,4},;
             {"Excluir","AxDeleta",0,5}}

cCadastro := "Movimento de Ferias"

DbSelectArea("ZRH")
SET FILTER TO ZRH->ZRH_MAT == ZRA->ZRA_MAT
ZRH->(DbGotop())

mBrowse(,,,,"ZRH",,,)

SET FILTER TO
ZRH->(DbGotop())

DbSelectArea("ZRA")

Return(.T.)