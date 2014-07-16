/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST199 Autor: José Henrique M Felipetto    Data: 06/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ativação automática do controle por endereço V.1           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque/Custos                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

User Function NHEST199()
Private _nLoteDia := U_NHEST002() , _cOrigem := '' , _cTipo , _lSai := .F. , _nItem := 0 , _cCamLog := "" , _cLog := fCreate("C:\TEMP\ErrorLog.txt") , _cNewLine := chr(13) + chr(10)
Private _lErro := .T. , _lLote := .F. , _lEnd  := .F. , _cProd := ""

MsgInfo(" Controle de Endereço Automático - NHEST199 (203) ")
SB1->( DbSetOrder(1) )
SB2->( DbSetOrder(1) )

While !_lSai
	fGetFile()
EndDo

If !File(_cOrigem)
	alert("Arquivo de origem não encontrado! Favor, tente de novo.")
	Return .F.
EndIf

_aStruct := {{"LINHA","C",50,0}}

_cTrb := CriaTrab(_aStruct,.T.)
Use &_cTrb Alias TRB New Exclusive

Append From (_cOrigem) SDF

/////----------------   JA TEM O DBF CARREGADO

TRB->( DbGoTop() )
While TRB->( !eof() )

	_cProd := Alltrim(Substr(TRB->LINHA,1,15))

	If !SB1->(DbSeek(xFilial("SB1") + _cProd ))
		fWrite(_cLog,"Arquivo " + _cProd + " não encontrado na tabela SB1. " + _cNewLine)
		TRB->(DbSkip() )
		loop
	EndIf

	If SB1->B1_MSBLQL == '1'
		fWrite(_cLog,"Produto " + _cProd + " bloqueado para uso! " + _cNewLine)
		TRB->(DbSkip() )
		loop
	EndIf
    /*
	If !SB2->(DbSeek(xFilial("SB2") + _cProd ))
		fWrite(_cLog,"Arquivo " + _cProd + " não encontrado na tabela SB2. " + _cNewLine)
		TRB->(DbSkip() )
		loop
	EndIf
    */   
    SB2->(DbSeek(xFilial("SB2") + _cProd ))    
    
	If SB1->B1_LOCALIZ == "S" .AND. SM0->M0_CODFIL == "01"
		fWrite(_cLog,"Produto " + _cProd + " já controla endereço! " + _cNewLine)
		TRB->(DbSkip() )
		loop
	EndIf

	If SB1->B1_RASTRO == "L"
		fWrite(_cLog,"Produto " + _cProd + " controla lote! " + _cNewLine)
		TRB->(DbSkip() )
		loop
	EndIf

	AtivaEndereco( _cProd )
	TRB->( DbSkip() )
EndDo

TRB->( DbCloseArea() )
fErase(_cTrb)
fClose(_cLog)
Return

Static Function AtivaEndereco(_cProd)

RecLock("SB1",.F.)
	SB1->B1_LOCALIZ := "S"		
MsUnLock("SB1")

While !SB2->(Eof() ) .and. SB2->B2_FILIAL == xFilial("SB2") .and. Alltrim(SB2->B2_COD) == Alltrim(_cProd)

	If SB2->B2_QATU <= 0
		SB2->( DbSkip() )
		loop
	EndIf
	
	_nItem++
	
	Processa( {|| fMt805() } , "Criando Endereço MATA805 ")
	SB2->( DbSkip() )
EndDo
_nItem := 0
Return

Static Function fGetFile()
_cOrigem  := Space(50)

@ 010,133 To 120,600 Dialog oDialogos Title "Importacao de Arquivo"

@ 021,005 Say "Origem" Size  18,8
@ 021,035 Get _cOrigem Size 130,8 When .F.

@ 021,180 Button    "Localizar" Size 36,12 Action Origem()
@ 041,070 BmpButton Type 2 Action fFecha()
@ 041,100 BmpButton Type 1 Action fConfArq()

Activate Dialog oDialogos CENTERED

Return

Static Function fFecha()
	_lSai := .T.
	Close(oDialogos)
Return

Static Function fConfArq()

	If Empty(_cOrigem)
		alert("Arquivo de origem deve ser preenchido! ")
	Else
		_lSai := .T.
		Close(oDialogos)
	EndIf

Return

Static Function Origem()
	_cTipo   :="Arquivo Tipo (*.txt)       | *.txt | "
	_cOrigem := cGetFile(_cTipo,,0,,.T.,49)
Return

Static Function fMt805()
Local cCounter	:=	StrZero(0,TamSx3('DB_ITEM')[1])
SDB->( DbSetOrder(2) ) //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_LOTECTL+DB_NUMLOTE+DB_NUMSERI+DB_LOCALIZ+DB_NUMSEQ
SBE->( DbSetOrder(1) ) //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_LOTECTL+DB_NUMLOTE+DB_NUMSERI+DB_LOCALIZ+DB_NUMSEQ

If SDB->(DbSeek(xFilial("SDB") + SB2->(B2_COD + B2_LOCAL) + Space(10) + Space(6) + Space(20) + "01" + space(13) )) // Impede que crie movimentos repetidos na SDB
	Return
EndIf

//Verifica se existe o endereço 01 para o almox em questao
If !SBE->(DbSeek(xFilial("SBE") + SB2->B2_LOCAL + "01"))

	RecLock("SBE",.T.)
		SBE->BE_FILIAL := SB2->B2_FILIAL
		SBE->BE_LOCALIZ := "01"		
		SBE->BE_LOCAL := SB2->B2_LOCAL
		SBE->BE_STATUS := "1"
		SBE->BE_PRIOR := "ZZZ"
		SBE->BE_DATGER := dDataBase
	MsUnLock("SBE")
                                                          
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria registro de movimentacao por Localizacao (SDB)           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCounter := Soma1(cCounter)
CriaSDB( SB2->B2_COD						 	 ,;	// Produto
		 SB2->B2_LOCAL						 	 ,;	// Armazem
		 SB2->B2_QATU		 	 			     ,;	// Quantidade
		 "01"								 	 ,;	// Localizacao
		 ""		 					             ,;	// Numero de Serie
		 ""		   								 ,;	// Doc
		 ""		   								 ,;	// Serie
		 ""		   								 ,;	// Cliente / Fornecedor
		 ""		   								 ,;	// Loja
		 ""		   							 	 ,;	// Tipo NF
		 "ACE"	   								 ,;	// Origem do Movimento
		 dDataBase 								 ,;	// Data
		 ""						 	             ,;	// Lote
		 ""								   		 ,; // Sub-Lote   /* If(Rastro(aCols[i,1],"S"),aCols[i,7],"") */
		 ""							 			 ,;	// Numero Sequencial
		 "499"								     ,;	// Tipo do Movimento
		 "M"								     ,;	// Tipo do Movimento (Distribuicao/Movimento)
		 cCounter								 ,;	// Item
		 .F.									 ,;	// Flag que indica se é mov. estorno
		 0										 ,;	// Quantidade empenhado
		 0								  		  )	// Quantidade segunda UM

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma saldo em estoque por localizacao fisica (SBF)            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GravaSBF("SDB")
Return