/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE082  �Autor  �Marcos R Roquitski  � Data �  11/05/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Advertencia.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"


User Function Nhgpe082()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_fAdverte()",0,4} }
             

cCadastro := "Cadastro de Afastamentos"

mBrowse(,,,,"SRA",,,)

Return



User Function fAdverte()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2},;
             {"Incluir","AxInclui",0,3},;
             {"Alterar","AxAltera",0,4},;
             {"Excluir","AxDeleta",0,5}}

cCadastro := "Cadastro de Advertencia"

DbSelectArea("ZRS")
SET FILTER TO ZRS->ZRS_MAT == SRA->RA_MAT
ZRS->(DbGotop())

mBrowse(,,,,"ZRS",,,)

SET FILTER TO
ZRS->(DbGotop())

DbSelectArea("ZRA")
Return(.T.)