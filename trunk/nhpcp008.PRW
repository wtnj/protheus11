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

User Function nhpcp008()  
SetPrvt("_cArqDbf,_cArqNtx,_aDBF,cCadastro,aRotina")
Public _aBrowse	:= {{"Filial"		, "TR_FILIAL"	, "C", 02, 0, "@!"}, ;
	   				{"Produto"		, "TR_COD"		, "C", 15, 0, "@!"}, ;
	 	 			{"Ord.Prod."	, "TR_OP"		, "C", 13, 0, "@!"};
					}

IF SM0->M0_CODIGO <> "FN" //empresa new hubner	
   Msgbox("Esta Rotina So Pode Ser Utilizada na Fundicao!!!" ,"Atencao","ALERT" )                  
   Return
Endif

cCadastro := OemToAnsi("Ajuste de empenho FUSAO")
aRotina := {{ "Pesquisa"	,'AxPesqui'  , 0,1},;
            { "Dig.Forno"	,'U_Fornada', 0,2},;    // digitacao das fornadas
            { "Legenda"  	,'U_FusTick', 0,2}}                                      
            
DbSelectArea("SC2")
SC2->(DbSetOrder(1))             

//mBrowse( 6, 1,22,75,"SC2",,"SC2->C2_DATRF==CTOD('//')",,,,)       
mBrowse( 6, 1,22,75,"SC2",,,,,)       

Return(nil)

//-----------------------------------------------------------------------------------------------------------
//  1 - MONTA O DBF TEMPOPARIO  ( PRIMEIRA LINHA SC2 / DEMAIS LINHA FUS--> ARQUIVO CRIADO
//  2 - 
//-----------------------------------------------------------------------------------------------------------

User Function Fornada()                           
SetPrvt(",aRotina2,cCadastro2")
fCriaDBF()  // Cria arquivo temporario
cCadastro2 := OemToAnsi("Digitacao Forno")
aRotina2 := {{ "Pesquisa"	,'AxPesqui'  , 0,1},;
            { "Digitar" 	,'U_dForno(2)', 0,2},;    // digitacao das fornadas
            { "Legenda"  	,'U_FusTick', 0,2}}                       
       
DbSelectArea("SD4")
SD4->(DbSetOrder(1))    
cQuery := "SELECT D4_COD,D4_FILIAL,D4_OP FROM " + RetSqlName( 'SD4' ) +" D4 "
cQuery += "WHERE D4.D4_OP = '" + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + "'"
TCQUERY cQuery NEW ALIAS "TMP"    
DbSelectArea("TMP")                                                                 
TMP->(DbGoTop())
While !EOF()
	DbSelectArea("DBF")                                                                 
	RecLock("DBF",.T.)
	DBF->TR_FILIAL := TMP->D4_FILIAL
	DBF->TR_COD    := TMP->D4_COD
	DBF->TR_OP     := TMP->D4_OP
	MsUnLock("DBF")
	DbSelectArea("TMP")
	DbSkip()
End                                         

DbSelectArea("DBF") 
DBF->(DbSetOrder(1))
DBF->(DbGoTop())

mBrowse( 6, 1,22,75,"DBF",_aBrowse,,,)
      
Return(nil)          


//----------------------------------------------------------------------------------------------------------

                                            
Static Function fEnd() 
   RollBackSx8() 
   Close(oDialog) 
Return


//  gravacao do ticket e peso no SD1

Static Function f_Grava()
DbSelectArea("SD1")
RecLock("SD1",.F.)
SD1->D1_TICKET  := _cDoc
SD1->D1_PTICKET := _cPeso
MsUnLock("SD1")
Close(oDialog)
Return

User Function FusTick()       
Local aLegenda :=	{ {"BR_VERMELHO", "Aberto" },;
  					  {"BR_VERDE"   , "Digitado"   }}

BrwLegenda("Empenhos Digitados", "Legenda", aLegenda)
Return  


//----------------------------------------------------
Static Function fCriaDBF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"                        
_aDBF := {}

AADD(_aDBF,{"TR_FILIAL"  ,"C", 2,0})         // Filial
AADD(_aDBF,{"TR_COD   "  ,"C", 15,0})        // Codigo do Produto
AADD(_aDBF,{"TR_OP    "  ,"C", 13,0})        // Numero da OP

DbCreate(_cArqDBF,_aDBF)
DbUseArea(.T.,,_cArqDBF,"DBF",.F.)           

_cArqNtx := CriaTrab(NIL,.f.)
_cOrdem  := "DBF->FILIAL+DBF->COD+DBF->OP"
IndRegua("DBF",_cArqNtx,_cOrdem) //"Selecionando Registros..."

Return

