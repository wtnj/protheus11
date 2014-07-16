/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE165  �Autor  �Marcos R. Roquitski � Data �  03/08/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � Carta de uso de equipamento eletronicos.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"        
#INCLUDE "MSOLE.CH"

User Function Nhgpe165()

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL,CXINSTRU,CXLOCAL,_aExtras")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS") 
SetPrvt("_nSalm2,_nSalf2,_nSale2,_nSalo2,_nSalm1,_nAno,_nMes,_cAnoMes,_nSalf2,_nSale2,_nSalo2")


Pergunte("MOVFUNC",.F.)

cCadastro 	:= OemtoAnsi("Integracao com MS-Word")
aSays	  	:= {}
aButtons  	:= {}
_aExtras    := {}

AADD(aSays,OemToAnsi("Esta rotina ir� imprimir carta de uso de equipamento eletronicos"))

AADD(aButtons, { 5,.T.,{|| Pergunte("MOVFUNC",.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| WORDIMP()}) 
EndIf
	
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � WORDIMP  � Autor � Equipe Desenv. R.H.   � Data � 31.03.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Certificados dos cursos  - VIA WORD           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Revis�o  �                                          � Data �          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static FUNCTION WORDIMP()
Local _cDescf := Space(20),_cDescc := Space(20)
Local i, _cData
Local  _nSalAnt := _nSalAtu := _nPerCent := 0
Local _dDatau := Ctod(Space(08))

SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))

// Seleciona Arquivo Modelo 
cType     := "RHDOC010  | *.DOT"
cArquivo  := "\system\rhdoc010.dot"
lImpress  := .F.	// Verifica se a saida sera em Tela ou Impressora
cArqSaida := "_RHDOC010"	// Nome do arquivo de saida

//����������������������������������������������������Ŀ
//� Copiar Arquivo .DOT do Server para Diretorio Local �
//������������������������������������������������������
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
	Alert(cPath + '' + cArquivo)
	Return
Endif

nPag 		:= 0

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

DbSelectArea("SRA")
DbSetOrder(01)
SRJ->(DbSetOrder(1)) 
SR3->(DbSetOrder(2))

SRA->(DbSeek(xFilial("SRA")+mv_par01))
If SRA->(Found())

	_cDescf := Space(20)
	SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
	If SRJ->(Found())
		_cDescf := SRJ->RJ_DESC
	Endif
	
	_cDescc := Space(20)
	CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
	If CTT->(Found())
		_cDescc := CTT->CTT_DESC01
	Endif		

	_cData := 'Curitiba, '+Alltrim(Str(Day(SRA->RA_ADMISSA))) + ' de ' + Mesextenso(SRA->RA_ADMISSA) + ' de ' + Alltrim(Str(Year(SRA->RA_ADMISSA)))

	OLE_SetDocumentVar(oWord,"Empresa",SM0->M0_NOMECOM)
	OLE_SetDocumentVar(oWord,"RaMat",SRA->RA_MAT)
	OLE_SetDocumentVar(oWord,"RaNome",SRA->RA_NOME)
	OLE_SetDocumentVar(oWord,"RaCc",SRA->RA_CC+_cDescc)
	OLE_SetDocumentVar(oWord,"RaFuncao",_cDescf) 
	OLE_SetDocumentVar(oWord,"RaAdmissao",_cData)	
	OLE_SetDocumentVar(oWord,"RaSalario","R$ "+Transform(SRA->RA_SALARIO,"@E 999,999.99"))

Endif

//--Atualiza Variaveis
OLE_UpDateFields(oWord)
OLE_SetProperty( oWord, '208', .F. )  
	
Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento ou clique no botao para fechar.", {"Fechar"}) 

OLE_CloseLink( oWord ) 			// Fecha o Documento
	

//����������������������������������������������������Ŀ
//�  Apaga arquivo .DOT temporario da Estacao 		   �
//������������������������������������������������������
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return
