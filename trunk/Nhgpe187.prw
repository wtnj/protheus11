/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE187  ºAutor  ³Marcos R. Roquitski º Data ³  26/07/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aviso Previo.                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"        
#INCLUDE "MSOLE.CH"

User Function Nhgpe187()

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL,CXINSTRU,CXLOCAL,_aExtras")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS") 
SetPrvt("_nSalm2,_nSalf2,_nSale2,_nSalo2,_nSalm1,_nAno,_nMes,_cAnoMes,_nSalf2,_nSale2,_nSalo2")


If Pergunte("NHGPE187",.T.)

	Processa({|| WORDIMP()})

Endif
	
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WORDIMP  ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 31.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Certificados dos cursos  - VIA WORD           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static FUNCTION WORDIMP()
Local _cDescf := Space(20)
Local i
Local _nAno := 0

SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))


If SM0->M0_CODIGO = 'FN'
	If mv_par06 == 1
		cArquivo := "\system\AVISO_01.dot" // Aviso Indenizado     

	Elseif mv_par06 == 2
		cArquivo := "\system\AVISO_02.dot" // Aviso Trabalhado       

	Elseif mv_par06 == 3
		cArquivo := "\system\AVISO_03.dot" // Final de Aprendizado

	Elseif mv_par06 == 4
		cArquivo := "\system\AVISO_04.dot" // Demissao experiencia

	Endif

Elseif SM0->M0_CODIGO = 'NH'
	If mv_par06 == 1
		cArquivo := "\system\AVISO_01N.dot" // Aviso Indenizado     

	Elseif mv_par06 == 2
		cArquivo := "\system\AVISO_02N.dot" // Aviso Trabalhado       

	Elseif mv_par06 == 3
		cArquivo := "\system\AVISO_03N.dot" // Final de Aprendizado

	Elseif mv_par06 == 4
		cArquivo := "\system\AVISO_04N.dot" // Demissao experiencia

	Endif

Elseif SM0->M0_CODIGO = 'IT'
	If mv_par06 == 1
		cArquivo := "\system\AVISO_01I.dot" // Aviso Indenizado     

	Elseif mv_par06 == 2
		cArquivo := "\system\AVISO_02I.dot" // Aviso Trabalhado       

	Elseif mv_par06 == 3
		cArquivo := "\system\AVISO_03I.dot" // Final de Aprendizado

	Elseif mv_par06 == 4
		cArquivo := "\system\AVISO_04I.dot" // Demissao experiencia

	Endif
Endif


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
_nAviso    := 0
lImpress   := .F.
nPag 	   := 0
cArqSaida  := "AVISO"


// Inicia o Word 
nVez := 1

// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
oWord := OLE_CreateLink('TMsOleWord97')		

OLE_NewFile(oWord,cPath+cArqLoc)

If lImpress
	OLE_SetProperty( oWord, oleWdVisible,   .F. )
	OLE_SetProperty( oWord, oleWdPrintBack, .T. )
Else
	OLE_SetProperty( oWord, oleWdVisible,   .T. )
	OLE_SetProperty( oWord, oleWdPrintBack, .F. )
EndIf

If SRA->(DbSeek(xFilial("SRA")+mv_par01))

	U_Nhgpe197()
	
	//--Cadastro Funcionario
	OLE_SetDocumentVar(oWord,"cNomeFun",SRA->RA_NOME)

	_cDescf := Space(20)
	SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
	If SRJ->(Found())
		_cDescf := SRJ->RJ_DESC
	Endif		
	OLE_SetDocumentVar(oWord,"Funcao",_cDescf)
	OLE_SetDocumentVar(oWord,"Matricula",SRA->RA_MAT)
	OLE_SetDocumentVar(oWord,"Admissa",DTOC(SRA->RA_ADMISSA))
	OLE_SetDocumentVar(oWord,"Ctps",SRA->RA_NUMCP+" Serie: "+SRA->RA_SERCP+" - "+SRA->RA_UFCP)
	OLE_SetDocumentVar(oWord,"Saida",mv_par02)
	OLE_SetDocumentVar(oWord,"Homologacao",mv_par03)
	OLE_SetDocumentVar(oWord,"Local",IIF(mv_par04==1,'Sindicato/CIC','Empresa'))
	OLE_SetDocumentVar(oWord,"Horario",mv_par05)
	OLE_SetDocumentVar(oWord,"Homolog2",mv_par03-1)
    
	_nAno := ((Year(dDataBase) - Year(SRA->RA_ADMISSA)))
			
	If _nAno <=1
		_nAviso := 30
	
	Else
	
		If Month(dDataBase) > Month(SRA->RA_ADMISSAO)
			_nAviso := 30 + ( (_nAno-1) * 3)

		Elseif Month(dDataBase) < Month(SRA->RA_ADMISSAO)
			_nAviso := 30 + ( (_nAno-2) * 3)

		Endif	
				
		If 	Month(SRA->RA_ADMISSAO) == Month(dDataBase)
			If Day(SRA->RA_ADMISSAO) >= Day(dDataBase)
				_nAviso := 30 + ((_nAno-1) * 3)

			Elseif Day(SRA->RA_ADMISSAO) > Day(dDataBase)
				_nAviso := 30 + ((_nAno-2) * 3)
			Endif
		Endif	
		
	Endif
	_cExtenso := Extenso(_nAviso)
	_cExtenso := Substr(_cExtenso,1, At("REA",_cExtenso) -1)

	OLE_SetDocumentVar(oWord,"Saida2",mv_par02+_nAviso-1)	
	OLE_SetDocumentVar(oWord,"Aviso",Alltrim(Str(_nAviso))+" ("+_cExtenso+ " )" )		
	OLE_SetDocumentVar(oWord,"Aviso2",Alltrim(Str(_nAviso)))			
	OLE_SetDocumentVar(oWord,"Aviso3",Alltrim(Str(_nAviso-7)))				

	If Mv_par04 == 1
		OLE_SetDocumentVar(oWord,"Mensagem","LIGAR DIA "+Dtoc(mv_par03-1)+" PARA CONFIRMAR HORARIO DA HOMOLOGACAO Fone: 3341-1204")
	Else
		OLE_SetDocumentVar(oWord,"Mensagem","")	
	Endif
			
Endif

//--Atualiza Variaveis
OLE_UpDateFields(oWord)

//-- Imprime as variaveis				
OLE_SetProperty( oWord, '208', .F. ) 

Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento ou clique no botao para fechar.", {"Fechar"})
	
OLE_CloseLink( oWord ) 			// Fecha o Documento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return
