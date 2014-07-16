/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE190  ºAutor  ³Marcos R Roquitski  º Data ³  19/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcionarios em  tratamento medico.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function Nhgpe190()
                                                                                 	
SetPrvt("aRotina,cCadastro,")     

aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2},;
             {"Alterar","U_NhGpe191",0,3},;
             {"Inicio Processo","U_NhGp191a",0,4},;
             {"Final Processo","U_NhGp191b",0,5},;
             {"Legenda"  ,"U_C190Leg",0,6} }             
              

cCadastro := "Funcionarios em tratamento Medico"

DbSelectArea("SRA")
//Set Filter to SRA->RA_DEMISSA = ''
SRA->(DbGotop())
                   
mBrowse(,,,,"SRA",,,,,,fCriaCor())

Set Filter to 
SRA->(DbGotop())

Return


//
User Function C190Leg()       

Local aLegenda :=	{ 	{"BR_VERDE" ,  "Sem Tratamento Medico  " },;
						{"BR_LARANJA", "Em Tratamento Medico   " }}

BrwLegenda("Tratamento Medico", "Legenda", aLegenda)

Return  

//
Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERDE"  , "Sem Tratamento Medico" },;
						{"BR_LARANJA", "Em Tratamento Medico " }}

Local uRetorno := {}
Aadd(uRetorno, { 'RA_XRESMED = "N"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'RA_XRESMED = "S"' , aLegenda[2][1] } )

Return(uRetorno)

