/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHPCP008  ³ Autor ³ FABIO NICO             Data ³ 06/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Digitação da FUSAO                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP - FUSAO                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "colors.ch"                  
#INCLUDE "TOPCONN.CH"
#include "font.ch"

User Function nhest096()  
SetPrvt("cCadastro,aRotina")


cCadastro := OemToAnsi("Alteracao de STATUS do Item")
aRotina := {{ "Pesquisa"	,'AxPesqui'  , 0,1},;
            { "Bloq/Libera"	,'U_Altera'	 , 0,2},;    // digitacao das fornadas
            { "Legenda"  	,'U_Legenda' , 0,2}}                                      
            
DbSelectArea("SB1")
SB1->(DbSetOrder(1))             

//mBrowse( 6, 1,22,75,"SC2",,"SC2->C2_DATRF==CTOD('//')",,,,)       
mBrowse( 6, 1,22,75,"SB1",,,,,,fCriaCor())       

Return(nil)

//----------------------------------------------------------------------------------------------------------

                                            
Static Function fEnd() 
   RollBackSx8() 
   Close(oDialog) 
Return


//----------------------------------------------------------------------------------------------------------
//  CONFIRMA A ALTERACAO DO BLOQUEIO DO PRODUTO
//----------------------------------------------------------------------------------------------------------
User Function Altera()
If MsgYesNo("Confirma BLOQUEIO/DESBLOQUEIO ITEM","ESTOQUE")
	
	Alert('Impossivel realizar operação!')
	/*
	DbSelectArea("SB1")
	RecLock("SB1",.F.)
	if B1_MSBLQL == "1"
			SB1->B1_MSBLQL := "2"
		else
			SB1->B1_MSBLQL := "1"
	endif		
	MsUnLock("SB1")
	*/
Endif
Return

//----------------------------------------------------------------------------------------------------------
//  LEGENDA
//----------------------------------------------------------------------------------------------------------
User Function Legenda()       
Local aLegenda :=	{ {"BR_VERMELHO", "Bloqueado" },;
  					  {"BR_VERDE"   , "Liberado"   }}

BrwLegenda("Produtos Bloqueados", "Legenda", aLegenda)
Return  
                                    

Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERMELHO", "Bloqueado"  },;
  						{"BR_VERDE"   , "Liberado"  }}

Local uRetorno := {}
Aadd(uRetorno, { 'B1_MSBLQL = "1"', aLegenda[1][1] } )
Aadd(uRetorno, { 'B1_MSBLQL = "2"', aLegenda[2][1] } )

Return(uRetorno)

