
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHPPA009  บAutor  ณFelipe Ciconini     บ Data ณ  20/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Browse da tabela ZE1, tabela de modificacoes solicitadas   บฑฑ
ฑฑบ          ณ pelo cliente (comercial)                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PPAP                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

User Function NHPPA009()
Private cCadastro,aRotina

cCadastro := "Gerenciador de Modifica็๕es"
aRotina := {}

aAdd(aRotina,{ "Pesquisar" ,"AxPesqui"	    ,0,1})
aAdd(aRotina,{ "Engenharia","U_NHPPA008(2)" ,0,2})
aAdd(aRotina,{ "Setores"   ,'U_NHPPA008(3)' ,0,3})
aAdd(aRotina,{ "Excluir"   ,"AxDeleta"	    ,0,5})				//FAZER UM DELETE PARA A TABELA ZE1, EXCLUINDO DA ZE2 TAMBEM
aAdd(aRotina,{ "Legenda"   ,"U_FPPA09COR()",0,8})

cCadastro := "Gerenciador de Modifica็๕es"

DbSelectArea("ZE2")

mBrowse(6,1,22,75,"ZE2",,,,,,fCriaCor())

Return


User Function FPPA09COR()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"		  },;
  					  {"BR_VERMELHO" , "Finalizado"   },;
  					  {"BR_AMARELO"  , "Pendente"	  },;
  					  {"BR_PRETO"	 , "Nใo se Aplica"},;
  					  {"BR_AZUL"     , "Iniciado"     }}

BrwLegenda(OemToAnsi("Gerenciador de Modifica็๕es"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberto"		  },;
  					  {"BR_VERMELHO" , "Finalizado"   },;
  					  {"BR_AMARELO"  , "Pendente"     },;
  					  {"BR_PRETO"    , "Nใo se Aplica"},;
  					  {"BR_AZUL"     , "Iniciado"	  }}

Local uRetorno := {}

Aadd(uRetorno, { 'ZE2_STATUS = "A"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZE2_STATUS = "F"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZE2_STATUS = "P"' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZE2_STATUS = "N"' , aLegenda[4][1] } )
Aadd(uRetorno, { 'ZE2_STATUS = "I"' , aLegenda[5][1] } )

Return(uRetorno)
