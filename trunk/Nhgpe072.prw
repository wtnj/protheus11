/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE072  �Autor  �Marcos R Roquitski  � Data �  17/01/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Afastamentos de Terceiros.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     `
#include "protheus.ch"

User Function Nhgpe072()

SetPrvt("aRotina,cCadastro,")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_fAfastTer()",0,4} }
             

cCadastro := "Cadastro de Afastamentos"

mBrowse(,,,,"ZRA",,,)

Return

User Function fAfastTer()

SetPrvt("aRotina,cCadastro,")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

cCadastro := "Cadastro de Afastamentos"

DbSelectArea("ZR8")
SET FILTER TO ZR8->ZR8_MAT == ZRA->ZRA_MAT 
ZR8->(DbGotop())

mBrowse(,,,,"ZR8",,,)

SET FILTER TO 
ZR8->(DbGotop())

DbSelectArea("ZRA")
Return(.T.)

