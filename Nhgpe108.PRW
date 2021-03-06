/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE108  �Autor  �Microsiga           � Data �  06/05/2008 ���
�������������������������������������������������������������������������͹��
���Desc.     � Declaracao de Assalariado.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"        
#INCLUDE "MSOLE.CH"

User Function Nhgpe108()

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL,CXINSTRU,CXLOCAL,_aExtras")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS") 
SetPrvt("_nSalm2,_nSalf2,_nSale2,_nSalo2,_nSalm1,_nAno,_nMes,_cAnoMes,_nSalf2,_nSale2,_nSalo2")


//�����������������������������������������������Ŀ
//� Parametros usados na rotina                   �
//� mv_par01         Filial   De                  �
//� mv_par02         Filial   Ate                 �
//� mv_par03         C.Custo  De                  �
//� mv_par04         C.Custo  Ate                 �
//� mv_par05         Matricula De                 �
//� mv_par06         Matricula Ate                �
//� mv_par07         Calendario De                �
//� mv_par08         Calendario Ate               �
//� mv_par09         Curso De                     �
//� mv_par10         Curso Ate                    �
//� mv_par11         Situacao Folha               �
//� mv_par12         Turma De                     �
//� mv_par13         Turma Ate                    �
//� mv_par14         1-Impressora / 2-Arquivo     �
//� mv_par15         Nome do arquivo de saida     �
//�������������������������������������������������

Pergunte("CERTIF",.F.)

cCadastro 	:= OemtoAnsi("Integracao com MS-Word")
aSays	  	:= {}
aButtons  	:= {}
_aExtras    := {}

AADD(aSays,OemToAnsi("Esta rotina ir� imprimir os certificados dos cursos realizados "))

AADD(aButtons, { 5,.T.,{|| Pergunte("CERTIF",.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| WORDIMP()})  // Chamada do Processamento// Substituido pelo assistente de conversao do AP5 IDE em 14/02/00 ==> 	Processa({|| Execute(WORDIMP)})  // Chamada do Processamento
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
Local _cDescf := Space(20)
Local i

SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))

// Seleciona Arquivo Modelo 
// cType := "DECLARA    | *.DOT"
// cArquivo := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,6)),,,.T.,GETF_ONLYSERVER )//"Selecione arquivo "


If SM0->M0_CODIGO == 'FN'
	cArquivo := "\system\Fn_declara.dot"
Else
	cArquivo := "\system\Nh_declara.dot"
Endif	

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
	Return
Endif

lImpress	:= ( mv_par14 == 1 )	// Verifica se a saida sera em Tela ou Impressora
cArqSaida	:= AllTrim( mv_par15 )	// Nome do arquivo de saida
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

cInicio 	:= "RA4->RA4_FILIAL+RA4->RA4_CALEND"
cFim		:= mv_par02+mv_par08
cFil		:= If (xFilial("RA4") = Space(2), Space(2), mv_par01)

DbSelectArea("SRA")
DbSetOrder(01)
SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))

SRA->(DbSeek(xFilial("SRA")+mv_par05))
While SRA->(!Eof()) .and. SRA->RA_MAT>=mv_par05 .and. SRA->RA_MAT<=mv_par06

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
	OLE_SetDocumentVar(oWord,"Ctps",SRA->RA_NUMCP+" "+SRA->RA_SERCP+" - "+SRA->RA_UFCP)


	fSalm1()
	OLE_SetDocumentVar(oWord,"Periodo_a",Substr(_cAnoMes,5,2)+"/"+Substr(_cAnoMes,1,4)) // Periodo
	OLE_SetDocumentVar(oWord,"Salm1_a",Transform(_nSalm1,"@E 999,999.99")) // Salario Base
	OLE_SetDocumentVar(oWord,"Salf2_a",Transform(_nSalf2,"@E 999,999.99")) // Salario familia
	OLE_SetDocumentVar(oWord,"Sale2_a",Transform(_nSale2,"@E 999,999.99")) // Adic. + H. Extras
	OLE_SetDocumentVar(oWord,"Salo2_a",Transform(_nSalo2,"@E 999,999.99")) // Ferias
	OLE_SetDocumentVar(oWord,"Total_a",Transform(_nSalm1 + _nSalf2 + _nSale2 + _nSalo2,"@E 999,999.99")) // Total 


	fSalm2()
	OLE_SetDocumentVar(oWord,"Periodo_b",Substr(_cAnoMes,5,2)+"/"+Substr(_cAnoMes,1,4)) // Periodo
	OLE_SetDocumentVar(oWord,"Salm2_b",Transform(_nSalm2,"@E 999,999.99")) // Salario Base
	OLE_SetDocumentVar(oWord,"Salf2_b",Transform(_nSalf2,"@E 999,999.99")) // Salario familia
	OLE_SetDocumentVar(oWord,"Sale2_b",Transform(_nSale2,"@E 999,999.99")) // Adic. + H. Extras
	OLE_SetDocumentVar(oWord,"Salo2_b",Transform(_nSalo2,"@E 999,999.99")) // Ferias
	OLE_SetDocumentVar(oWord,"Total_b",Transform(_nSalm2 + _nSalf2 + _nSale2 + _nSalo2,"@E 999,999.99")) // Total 

	fSalm2()
	OLE_SetDocumentVar(oWord,"Periodo_c",Substr(_cAnoMes,5,2)+"/"+Substr(_cAnoMes,1,4)) // Periodo
	OLE_SetDocumentVar(oWord,"Salm2_c",Transform(_nSalm2,"@E 999,999.99")) // Salario Base
	OLE_SetDocumentVar(oWord,"Salf2_c",Transform(_nSalf2,"@E 999,999.99")) // Salario familia
	OLE_SetDocumentVar(oWord,"Sale2_c",Transform(_nSale2,"@E 999,999.99")) // Adic. + H. Extras
	OLE_SetDocumentVar(oWord,"Salo2_c",Transform(_nSalo2,"@E 999,999.99")) // Ferias
	OLE_SetDocumentVar(oWord,"Total_c",Transform(_nSalm2 + _nSalf2 + _nSale2 + _nSalo2,"@E 999,999.99")) // Total 

	fSalm3()
	fSalm3()
	fSalm3()
	fSalm3()
	OLE_SetDocumentVar(oWord,"Extra_1",Substr(_aExtras[1,1],5,2)+"/" +Substr(_aExtras[1,1],1,4)+ " Horas Extras ")
	OLE_SetDocumentVar(oWord,"Extra_2",Substr(_aExtras[2,1],5,2)+"/" +Substr(_aExtras[2,1],1,4)+ " Horas Extras ")
	OLE_SetDocumentVar(oWord,"Extra_3",Substr(_aExtras[3,1],5,2)+"/" +Substr(_aExtras[3,1],1,4)+ " Horas Extras ")
	OLE_SetDocumentVar(oWord,"Extra_4",Substr(_aExtras[4,1],5,2)+"/" +Substr(_aExtras[4,1],1,4)+ " Horas Extras ")
	OLE_SetDocumentVar(oWord,"Extra_5",Substr(_aExtras[5,1],5,2)+"/" +Substr(_aExtras[5,1],1,4)+ " Horas Extras ")
	OLE_SetDocumentVar(oWord,"Extra_6",Substr(_aExtras[6,1],5,2)+"/" +Substr(_aExtras[6,1],1,4)+ " Horas Extras ")

	OLE_SetDocumentVar(oWord,"Valor_1",Transform(_aExtras[1,2],"@E 999,999.99"))
	OLE_SetDocumentVar(oWord,"Valor_2",Transform(_aExtras[2,2],"@E 999,999.99"))
	OLE_SetDocumentVar(oWord,"Valor_3",Transform(_aExtras[3,2],"@E 999,999.99"))
	OLE_SetDocumentVar(oWord,"Valor_4",Transform(_aExtras[4,2],"@E 999,999.99"))
	OLE_SetDocumentVar(oWord,"Valor_5",Transform(_aExtras[5,2],"@E 999,999.99"))
	OLE_SetDocumentVar(oWord,"Valor_6",Transform(_aExtras[6,2],"@E 999,999.99"))

    Exit
    
Enddo

//--Atualiza Variaveis
OLE_UpDateFields(oWord)

//-- Imprime as variaveis				
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


Static Function fSalm1()

	_nSalm1  := 0
	_nAno    := Val(Substr(Dtos(dDataBase),1,4))
	_nMes    := Val(Substr(Dtos(dDataBase),5,2))
	_cAnoMes := StrZero(_nAno,4)+StrZero(_nMes,2)
	_nSalf2  := 0
	_nSale2  := 0
	_nSalo2  := 0
	_nSale3  := 0

	// Busca nos acumulados
	
	/*
	SRC->(DbSeek(xFilial("SRC")+SRA->RA_MAT))
	While !SRC->(Eof()) .AND. SRC->RC_MAT == SRA->RA_MAT
		If SRC->RC_PD $ '101/102/103/128/130' // Salario-Base
			_nSalm1 += SRC->RC_VALOR
		Endif

		If SRC->RC_PD $ '124' // Salario-familia
			_nSalf2 += SRC->RC_VALOR
		Endif
	
		If SRC->RC_PD $ '105/107/110/111/113/116/121/122/141/143/145/147' // Adicional Noturno + Horas extras
			_nSale2 += SRC->RC_VALOR
		Endif

	
		If SRC->RC_PD $ '105/107/110/111/116/122/141/143/145/147' // Horas extras
			_nSale3 += SRC->RC_VALOR
		Endif


		If SRC->RC_PD $ '160/162/164/168/170' // Ferias
			_nSalo2 += SRC->RC_VALOR
		Endif

		SRC->(DbSkip())
	Enddo
    */

	If _nSalm1 <= 0

		_nSalm1  := 0
		_nSalf2  := 0
		_nSale2  := 0
		_nSalo2  := 0

		SRD->(DbSeek(xFilial("SRD")+SRA->RA_MAT+_cAnoMes))
		While !SRD->(Eof()) .AND. SRD->RD_MAT == SRA->RA_MAT .AND. SRD->RD_DATARQ == _cAnoMes
			If SRD->RD_PD $ '101/102/103/128/130'
				_nSalm1 += SRD->RD_VALOR
			Endif

			If SRD->RD_PD $ '124'
				_nSalf2 += SRD->RD_VALOR
			Endif
	
			If SRD->RD_PD $ '105/107/110/111/113/116/121/122/141/143/145/147'
				_nSale2 += SRD->RD_VALOR
			Endif


			If SRD->RD_PD $ '105/107/110/111/116/122/141/143/145/147'
				_nSale3 += SRD->RD_VALOR
			Endif


			If SRD->RD_PD $ '160/162/164/168/170'
				_nSalo2 += SRD->RD_VALOR
			Endif

			SRD->(DbSkip())
		Enddo
	Endif
	
	/*	
	_nSalm2 := SRA->RA_SALARIO
	If SRA->RA_CATFUNC == 'H'
		_nSalm2 := SRA->RA_HRSMES * SRA->RA_SALARIO
	Endif

	If _nSalm1 < _nSalm2
		_nSalm1 := SRA->RA_SALARIO
		If SRA->RA_CATFUNC == 'H'
			_nSalm1 := SRA->RA_HRSMES * SRA->RA_SALARIO
		Endif
	Endif
    */
	AADD(_aExtras,{_cAnoMes,_nSale3})

Return

Static Function fSalm2()
_nSalm2 := 0
_nSalf2 := 0
_nSale2 := 0
_nSalo2 := 0
_nSale3 := 0

If _nMes == 1
	_nAno := _nAno  - 1
	_nMes := 12
Else
	_nMes := _nMes - 1
Endif
_cAnoMes := StrZero(_nAno,4)+StrZero(_nMes,2)


SRD->(DbSeek(xFilial("SRD")+SRA->RA_MAT+_cAnoMes))
While !SRD->(Eof()) .AND. SRD->RD_MAT == SRA->RA_MAT  .AND. SRD->RD_DATARQ == _cAnoMes
	If SRD->RD_PD $ '101/102/103/128/130'
		_nSalm2 += SRD->RD_VALOR
	Endif

	If SRD->RD_PD $ '124'
		_nSalf2 += SRD->RD_VALOR
	Endif
	
	If SRD->RD_PD $ '105/107/110/111/113/116/121/122/141/143/145/147'
		_nSale2 += SRD->RD_VALOR
	Endif

	If SRD->RD_PD $ '160/162/164/168/170'
		_nSalo2 += SRD->RD_VALOR
	Endif

	If SRD->RD_PD $ '105/107/110/111/116/122/141/143/145/147'
		_nSale3 += SRD->RD_VALOR
	Endif
	
	SRD->(DbSkip())
Enddo
AADD(_aExtras,{_cAnoMes,_nSale3})
Return

Static Function fSalm3()
_nSale3 := 0

If _nMes == 1
	_nAno := _nAno  - 1
	_nMes := 12
Else
	_nMes := _nMes - 1
Endif
_cAnoMes := StrZero(_nAno,4)+StrZero(_nMes,2)

SRD->(DbSeek(xFilial("SRD")+SRA->RA_MAT+_cAnoMes))
While !SRD->(Eof()) .AND. SRD->RD_MAT == SRA->RA_MAT  .AND. SRD->RD_DATARQ == _cAnoMes
	If SRD->RD_PD $ '105/107/110/111/116/122/141/143/145/147'
		_nSale3 += SRD->RD_VALOR
	Endif
	SRD->(DbSkip())
Enddo
AADD(_aExtras,{_cAnoMes,_nSale3})
Return
