/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE118  ºAutor  ³Marcos R. Roquitski º Data ³  17/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Vagas                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch" 
#include "protheus.ch" 
#include "msole.ch" 


User Function Nhgpe118()

SetPrvt("aRotina,cCadastro,aCores")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Altera","AxAltera",0,4},;
             {"Imprime","U_NhGpe122",0,5},; 
             {"Legenda","U_Gp118Legenda",0,6}}             
                              
cCadastro := "Cadastro de Vagas"

aCores    := {{ 'ZQS_STATUS==Space(01)','BR_VERDE'},;
					    { 'ZQS_STATUS=="1"' , 'BR_BRANCO'   },;
					  	{ 'ZQS_STATUS=="2"' , 'BR_AMARELO' },;
					  	{ 'ZQS_STATUS=="3"' , 'BR_AZUL' },;
					    { 'ZQS_STATUS=="4"' , 'BR_VERMELHO' }}
					    
DbSelectArea("ZQS")
// Set Filter to Empty(ZQS->ZQS_STATUS)
ZQS->(DbGotop())
mBrowse(,,,,"ZQS",,,,,,aCores)
Set Filter to 
ZQS->(DbGotop())

Return

//
User Function Gp118Legenda()
Local aLegenda :=	{	{"BR_VERDE" ,   "Em analise          " },;
           		        {"BR_BRANCO"  , "Aprovado            " },;
  	     				{"BR_AMARELO" , "Processo de selecao " },;
  	     				{"BR_AZUL" , "Concluida        " },;
    					{"BR_VERMELHO", "Cancelada           " }}

BrwLegenda("Cadastro de vagas", "Legenda", aLegenda)

Return  

//
Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERDE"     , "Em analise          " },;
			   						{"BR_BRNACO"    , "Aprovado            " },; // 1
  			 						{"BR_AMARELO"   , "Processo de selecao " },; // 2
  			 						{"BR_AZUL"      , "Concluida           " },; // 3
			   						{"BR_VERMELHO"  , "Cancelada           " }}  // 4

Local uRetorno := {}
Aadd(uRetorno, { 'ZQS_STATUS = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZQS_STATUS = "1"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZQS_STATUS = "2"' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZQS_STATUS = "3"' , aLegenda[4][1] } )
Aadd(uRetorno, { 'ZQS_STATUS = "4"' , aLegenda[4][1] } )
Return(uRetorno)



User Function fValUser()
  // Verifica se tem cadastrado o login na QAA, se não tiver gera uma mensagem, porém não impede o cancelamento da NF.
	QAA->(DbSetOrder(6)) // Usuario
	SRJ->(DbSetOrder(1)) // Funcao 
	CTT->(DbSetOrder(1)) // C. Custo
	If QAA->(DbSeek(Alltrim(cUserName))) //Login
	   	M->ZQS_OLOGIN := QAA->QAA_LOGIN
	   	M->ZQS_OMAT   := QAA->QAA_MAT
			M->ZQS_ONOME  := QAA->QAA_NOME
			M->ZQS_OFUNC  := QAA->QAA_CODFUNC
			M->ZQS_OCC    := QAA->QAA_CC
			If SRJ->(DbSeek(xFilial("SRJ")+QAA->QAA_CODFUNC)) //Funcao
				M->ZQS_OFUNDE := SRJ->RJ_DESC
			Endif
			If CTT->(DbSeek(xFilial("CTT")+QAA->QAA_CC)) //Centro de Custo
				M->ZQS_ODESCC := CTT->CTT_DESC01
			Endif
	Endif
Return(QAA->QAA_LOGIN)
                          


User function ImpRequi()
Local _cTipo1,_cTipo2,_cTipo3,_cMotivo1,_cMotivo2,_cMotivo3,_cTurno, _cScc, _cSdesccc, _cPlanta, _cSturno

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ESTE ARQUIVO DEVE ESTAR NA PASTA SYSTEM DO SERVIDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArquivo := "\system\reqm1.dot"

SRA->(DbSetOrder(1))
CTT->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copiar Arquivo .DOT do Server para Diretorio Local ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nPos := Rat("\",cArquivo)
If nPos > 0
	cArqLoc := AllTrim(Subst(cArquivo, nPos+1,20 ))
Else 
	cArqLoc := cArquivo
EndIF
cPath := GETTEMPPATH()
If Right( AllTrim(cPath), 1 ) != "\"
   cPath += "\"
Endif
If !CpyS2T(cArquivo, cPath, .T.)
	Return
Endif

lImpress	:= .F.	// Verifica se a saida sera em Tela ou Impressora
cArqSaida	:= "REQUISICAO"	// Nome do arquivo de saida

// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
oWord := OLE_CreateLink('TMsOleWord97')		

OLE_NewFile(oWord,cPath+cArqLoc)

// Define o modo de impressão
If lImpress
	OLE_SetProperty( oWord, oleWdVisible,   .F. )
	OLE_SetProperty( oWord, oleWdPrintBack, .T. )
Else
	OLE_SetProperty( oWord, oleWdVisible,   .T. )
	OLE_SetProperty( oWord, oleWdPrintBack, .F. )
EndIf

_cPlanta := Space(08)
// Planta Usinagem/Fundicao
If 	SM0->M0_CODIGO = 'FN'
	_cPlanta := "FUNDICAO"
Elseif SM0->M0_CODIGO == 'NH'
	_cPlanta := "USINAGEM"
Endif

// Tipo Recrutamento interno,externo ou misto
_cTipo1 := _cTipo2 := _cTipo3 := Space(01)
If ZQS->ZQS_TIPO = '1'
	_cTipo1 := "X"
Elseif ZQS->ZQS_TIPO = '2'
	_cTipo2 := "X"
Elseif ZQS->ZQS_TIPO = '3'
	_cTipo3 := "X"
Endif
 
_cMotivo1 := _cMotivo2 := _cMotivo3 := Space(01)
If ZQS->ZQS_MOTIVO = '1'
	_cMotivo1 := "X"
Elseif ZQS->ZQS_MOTIVO = '2'
	_cMotivo2 := "X"
Elseif ZQS->ZQS_MOTIVO = '3'
	_cMotivo3 := "X"
Endif

//Troca as variáveis do documento
OLE_SetDocumentVar(oWord,"cTipo1"  ,_cTipo1) // Recrutamento interno
OLE_SetDocumentVar(oWord,"cTipo2"  ,_cTipo2) // Recrutamento externo
OLE_SetDocumentVar(oWord,"cTipo3"  ,_cTipo3) // Recrutamento misto

OLE_SetDocumentVar(oWord,"cMotivo1"  ,_cMotivo1) // Aumento de Quadro
OLE_SetDocumentVar(oWord,"cMotivo2"  ,_cMotivo2) // Substituicao
OLE_SetDocumentVar(oWord,"cMotivo3"  ,_cMotivo3) // Outros

OLE_SetDocumentVar(oWord,"cNrVaga" ,ZQS->ZQS_NRVAGA) // Numero de vaga
OLE_SetDocumentVar(oWord,"cCargo"  ,ZQS->ZQS_FUNCAO + " "+ZQS->ZQS_DESCFU) // Cargo
OLE_SetDocumentVar(oWord,"cCodFun" ,ZQS->ZQS_FUNCAO ) // Codigo de Funcao
OLE_SetDocumentVar(oWord,"cDesFun" ,ZQS->ZQS_DESCFU) // Descricao da Funcao


OLE_SetDocumentVar(oWord,"cSalario"  ,"R$ "+Transform(ZQS->ZQS_SALARI,"@E 999,999.99")) // Salario
OLE_SetDocumentVar(oWord,"cCusto"  ,ZQS->ZQS_CC ) // Centro de custo
OLE_SetDocumentVar(oWord,"cDesccc"  ,ZQS->ZQS_DESCCC ) // Descricao c.Custo

If ZQS->ZQS_TURNO == "1"
	_cTurno := "1o. Turno"

Elseif ZQS->ZQS_TURNO == "2"
	_cTurno := "2o. Turno"

Elseif ZQS->ZQS_TURNO == "3"
	_cTurno := "3o. Turno"

Elseif ZQS->ZQS_TURNO == "4"
	_cTurno := "4o. Turno"

Elseif ZQS->ZQS_TURNO == "5"
	_cTurno := "Adm."

Endif
OLE_SetDocumentVar(oWord,"cCodVaga" ,ZQS->ZQS_VAGA) // Sequencial vaga
OLE_SetDocumentVar(oWord,"cPlanta" ,_cPlanta) // Planta
OLE_SetDocumentVar(oWord,"cTurno"  ,_cTurno ) // Turno
OLE_SetDocumentVar(oWord,"cJustifica",ZQS->ZQS_OBS1 ) // Motivo da substituicao
OLE_SetDocumentVar(oWord,"cSnome",ZQS->ZQS_SFUNOM) // Nome substituicao
OLE_SetDocumentVar(oWord,"cSmat",ZQS->ZQS_SMAT) // Matricula substituicao
OLE_SetDocumentVar(oWord,"cSsal"  ,"R$ "+Transform(ZQS->ZQS_SSAL,"@E 999,999.99")) // Salario substituicao
OLE_SetDocumentVar(oWord,"cScargo"  ,ZQS->ZQS_SFUNC + " "+ZQS->ZQS_SFUNDE) // Cargo substituicao
OLE_SetDocumentVar(oWord,"cSmotivo",ZQS->ZQS_SMOTSU) // Motivo substituicao
OLE_SetDocumentVar(oWord,"cScoment",ZQS->ZQS_SCOMEN) // Comentario substituicao
OLE_SetDocumentVar(oWord,"cSdemis",ZQS->ZQS_SDEMIS) // Data de demissao do substituido

_cScc := Space(09)
_cSdesccc := Space(20)
SRA->(DbSeek(xFilial("SRA")+ZQS->ZQS_SMAT))
If SRA->(Found())
	_cScc := SRA->RA_CC
	CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
	If CTT->(Found())
		_cSdesccc := CTT->CTT_DESC01
	Endif
Endif

OLE_SetDocumentVar(oWord,"cScc",_cScc) // Centro de custo substituticao
OLE_SetDocumentVar(oWord,"cSdesccc",_cSdesccc) // Centro de custo descricao
OLE_SetDocumentVar(oWord,"cOnome",ZQS->ZQS_ONOME) // Nome do solicitante
OLE_SetDocumentVar(oWord,"cOmat",ZQS->ZQS_OMAT) // Matricula do solicitante
OLE_SetDocumentVar(oWord,"cOcargo",ZQS->ZQS_OFUNC+" "+ZQS->ZQS_OFUNDE) // Cargo do solicitante
OLE_SetDocumentVar(oWord,"cOsetor",ZQS->ZQS_OCC+" "+ZQS->ZQS_ODESCC) // Setor do solicitante
OLE_SetDocumentVar(oWord,"cOramal",ZQS->ZQS_ORAMAL) // Ramal do solicitante


If ZQS->ZQS_STURNO == "1"
	_cSturno := "1o. Turno"

Elseif ZQS->ZQS_STURNO == "2"
	_cSturno := "2o. Turno"

Elseif ZQS->ZQS_STURNO == "3"
	_cSturno := "3o. Turno"

Elseif ZQS->ZQS_STURNO == "4"
	_cSturno := "4o. Turno"

Elseif ZQS->ZQS_STURNO == "5"
	_cSturno := "Adm."

Endif

OLE_SetDocumentVar(oWord,"cSturno",_cSturno) // Turno do substituicao



//--Atualiza Variaveis
OLE_UpDateFields(oWord)

OLE_SetProperty( oWord, '208', .F. )  

Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento REQUISICAO DE FUNCIONARIO ou clique no botao para fechar.", {"Fechar"})
		   		
OLE_CloseLink( oWord ) 			// Fecha o Documento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return  
