/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN094  �Autor  �Marcos R. Roquitski � Data �  30/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclui tipos de despesas.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

user function Nhfin094()

  // area atual
  local aArea := getArea()
  
  // titulo do cadastro
  private cCadastro := "Tipos de despesas"

  // fun��es
  private aRotina := { {"Pesquisar", "AxPesqui", 0, 1}  ,; // botao pesquisar
                       {"Visualizar", "AxVisual", 0, 2} ,; // botao visualizar
                       {"Incluir", "AxInclui", 0, 3}    ,; // botao incluir
                       {"Altera", "AxAltera", 0, 4}     ,; // botao altera
                       {"Excluir", "AxExclui", 0, 4} }     // botao excluir            


  // abre o browse com os dados
  dbSelectArea("ZZ5")
  ZZ5->(dbSetOrder(1))
  ZZ5->(dbGoTop())

  // abre o browse
  mBrowse( 006, 001, 022, 075, "ZZ5", nil, nil, nil, nil, nil, nil )
  
  // restaura a area
  restArea(aArea)

return nil
