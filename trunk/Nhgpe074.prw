/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE074  �Autor  �Marcos R Roquitski  � Data �  05/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de dependentes de Terceiros.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhgpe074()

SetPrvt("aRotina,cCadastro,")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_fDepenter()",0,4} }
             

cCadastro := "Cadastro de Afastamentos"

mBrowse(,,,,"ZRA",,,)

Return

User Function fDepenter()

SetPrvt("aRotina,cCadastro,")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

cCadastro := "Cadastro de Afastamentos"

DbSelectArea("ZRB")
SET FILTER TO ZRB->ZRB_MAT == ZRA->ZRA_MAT 
ZRB->(DbGotop())

mBrowse(,,,,"ZRB",,,)

SET FILTER TO 
ZRB->(DbGotop())

DbSelectArea("ZRA")
Return(.T.)
