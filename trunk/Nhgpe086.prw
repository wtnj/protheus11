/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE086  �Autor  �Marcos R Roquitski  � Data �  22/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Movimento de ferias gozadas.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhgpe086()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_ffolgas()",0,4} }
             

cCadastro := "Cadastro de Afastamentos"

mBrowse(,,,,"ZRA",,,)

Return


User Function ffolgas()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2},;
             {"Incluir","AxInclui",0,3},;
             {"Alterar","AxAltera",0,4},;
             {"Excluir","AxDeleta",0,5}}

cCadastro := "Movimento de Ferias"

DbSelectArea("ZRI")
SET FILTER TO ZRI->ZRI_MAT == ZRA->ZRA_MAT
ZRI->(DbGotop())

mBrowse(,,,,"ZRI",,,)

SET FILTER TO
ZRI->(DbGotop())

DbSelectArea("ZRA")

Return(.T.)