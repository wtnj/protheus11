
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHPPA010  �Autor  �FELIPE CICONINI     � Data �  29/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Browse da tabela ZE1 (GERENCIADOR DE MUDAN�AS - COMERCIAL) ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � COMERCIAL                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

User Function NHPPA010()
Private cCadastro,aRotina

cCadastro := "Gerenciador de Modifica��es"
aRotina := {}

aAdd(aRotina,{ "Pesquisar" ,"AxPesqui"	    ,0,1})
aAdd(aRotina,{ "Consulta"  ,"U_NHPPA011(2)" ,0,2})
aAdd(aRotina,{ "Incluir"   ,"U_NHPPA011(3)" ,0,3})
aAdd(aRotina,{ "Acompanhar","U_NHPPA011(4)" ,0,4})
aAdd(aRotina,{ "Excluir"   ,"U_NHPPA011(5)" ,0,5})
aAdd(aRotina,{ "Legenda"   ,"U_FPPA010COR()",0,8})

cCadastro := "Gerenciador de Modifica��es"

DbSelectArea("ZE1")

mBrowse(6,1,22,75,"ZE1",,,,,,fCriaCor())


Return


User Function FPPA010COR()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"		  },;
  					  {"BR_VERMELHO" , "Finalizado"   },;
  					  {"BR_AMARELO"  , "Pendente"	  },;
  					  {"BR_AZUL"	 , "Iniciado"	  }}

BrwLegenda(OemToAnsi("Gerenciador de Modifica��es"), "Legenda", aLegenda)

Return  

Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"		  },;
  					  {"BR_VERMELHO" , "Finalizado"   },;  
  					  {"BR_AMARELO"  , "Pendente"     },;
  					  {"BR_AZUL"	 , "Iniciado"	  }}

Local uRetorno := {}

Aadd(uRetorno, { 'ZE1_STATUS = "A"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZE1_STATUS = "F"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZE1_STATUS = "P"' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZE1_STATUS = "I"' , aLegenda[4][1] } )


Return(uRetorno)
