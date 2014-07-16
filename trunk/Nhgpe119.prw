/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE119  ºAutor  ³Marcos R. Roquitski º Data ³  17/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aceite de vaga.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"                                                                    
#include "protheus.ch"

User Function Nhgpe119()

SetPrvt("aRotina,cCadastro,aCores")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Aceita","U_Gp119Aceita",0,3} ,;
             {"Rejeitar","U_Gp119Rejeita",0,3},;
             {"Candidatos","U_Gp119Cand",0,3},;
             {"Cancelar","U_Gp119Canc",0,3},;
             {"Legenda","U_Gp118Legenda",0,2}}             
                              
cCadastro := "Cadastro de Vagas"

aCores    := {{ 'ZQS_STATUS==Space(01)','BR_VERDE'},;
					    { 'ZQS_STATUS=="1"' , 'BR_BRANCO'   },;
					  	{ 'ZQS_STATUS=="2"' , 'BR_AMARELO' },;
					  	{ 'ZQS_STATUS=="3"' , 'BR_AZUL' },;
					    { 'ZQS_STATUS=="4"' , 'BR_VERMELHO' }}
					    
mBrowse(,,,,"ZQS",,,,,,aCores)

Return

//
Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERDE"   , "Em aberto        " },;
			   						{"BR_VERMELHO"  , "Reprovado        " },;
  			 						{"BR_AMARELO"   , "Ausente          " },;
  			 						{"BR_AZUL"      , "Aprovado         " }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZQD_RH = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZQD_RH = "3"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZQD_RH = "2"' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZQD_RH = "1"' , aLegenda[4][1] } )
Return(uRetorno)

//
User Function Gp119Aceita()
	If ZQS->ZQS_STATUS == "1" 
		MsgBox("Vaga aprovada","Processo seletivo","ALERT")
                                                           

	Elseif ZQS->ZQS_STATUS == "2" 
		MsgBox("Vaga em processo de selecao","Processo seletivo","ALERT")

	Elseif ZQS->ZQS_STATUS == "3"  
		MsgBox("Vaga concluida","Processo seletivo","ALERT")


	Elseif ZQS->ZQS_STATUS == "4" 
		MsgBox("Vaga cancelada","Processo seletivo","ALERT")

	Elseif Empty(ZQS->ZQS_STATUS)

			If MsgBox("Confirma aceite da Vaga","Confirmacao de Vaga","YESNO")
				
				RecLock("ZQS")
				ZQS->ZQS_STATUS := "1"
				MsUnlock("ZQS")
			
			Endif
	
	Endif

Return


//
User Function Gp119Rejeita()
	If ZQS->ZQS_STATUS == "1" // Vaga aprovada

			If MsgBox("Confirma rejeite da vaga","Confirmacao de Vaga","YESNO")
				
				RecLock("ZQS")
				ZQS->ZQS_STATUS := Space(01)
				MsUnlock("ZQS")
			
			Endif

	Elseif ZQS->ZQS_STATUS == "2"
		MsgBox("Vaga em processo de selecao","Processo seletivo","ALERT")

	Elseif ZQS->ZQS_STATUS == "3"
		MsgBox("Vaga concluida","Processo seletivo","ALERT")

	Elseif ZQS->ZQS_STATUS == "4"
		MsgBox("Vaga cancelada","Processo seletivo","ALERT")

	Elseif Empty(ZQS->ZQS_STATUS)

			MsgBox("Vaga nao aprovada","Confirmacao de Vaga","ALERT")

	Endif

Return


// 
User Function Gp119Cand()
SetPrvt("aRotina,cCadastro,lAtualCad")

If ZQS->ZQS_STATUS $ "1/2"


	aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
  	           {"Visualizar","AxVisual",0,2} ,;
	             {"Incluir","AxInclui",0,3} ,;
	             {"Alterar","AxAltera",0,4} ,;
	             {"Excluir","AxDeleta",0,5} ,;
	             {"Legenda","U_Gp119Legenda",0,2}}                          
           
	cCadastro := "Cadastro candidato vagas"
	
	aCores    := {{ 'ZQD_RH==" "' , 'BR_VERDE'},;
						    { 'ZQD_RH=="2"' , 'BR_VERMELHO'},;
						  	{ 'ZQD_RH=="3"' , 'BR_AMARELO'},;
						  	{ 'ZQD_RH=="1"' , 'BR_AZUL' }}

	lAtualCad := .F.
	DbSelectArea("ZQD")
	SET FILTER TO ZQD->ZQD_VAGA == ZQS->ZQS_VAGA
	ZQD->(DbGotop())

	mBrowse(,,,,"ZQD",,,,,,aCores)

	If !Empty(ZQD->ZQD_VAGA) ;	lAtualCad := .T.
	Endif	

	SET FILTER TO 
	ZQD->(DbGotop())

	DbSelectArea("ZQS")
	// Defini cores ZQS
	aCores    := {{ 'ZQS_STATUS==Space(01)','BR_VERDE'},;
						    { 'ZQS_STATUS=="1"' , 'BR_BRANCO' },;
						  	{ 'ZQS_STATUS=="2"' , 'BR_AMARELO' },;
						  	{ 'ZQS_STATUS=="3"' , 'BR_AZUL' },;
						    { 'ZQS_STATUS=="4"' , 'BR_VERMELHO' }}
					    
	// Atualiza status ZQS
	If lAtualCad
		RecLock("ZQS")
		ZQS->ZQS_STATUS := "2"
		MsUnlock("ZQS")
	Endif
Else
	MsgBox("Vaga nao confirmada!","Processo seletivo","ALERT")	

Endif
Return(.T.)

//
User Function Gp119Legenda()
Local aLegenda :=	{	{"BR_VERDE"   , "Em aberto     " },;
    					      {"BR_VERMELHO", "Reprovado     " },;
  	     						{"BR_AMARELO" , "Ausente       " },;
  	     						{"BR_AZUL"    , "Aprovado      " }}

BrwLegenda("Processo seletivo", "Legenda", aLegenda)

Return  

//
User Function Gp119Canc()


Return
