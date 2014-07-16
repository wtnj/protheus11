/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE099  �Autor  �Marcos R Roquitski  � Data �  07/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Funcionario Linha.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"


User Function Nhgpe099()

SetPrvt("aRotina,cCadastro,_cCustod,_cCustoa,_cMat,_cNome,_cCustc,_cCuste,_cCuston")
SetPrvt("mStruct,mArqTrab,aFields,aRotina,cDelFunc,cCadastro,cMarca,cCoord,_aGrupo,_cLogin,_cLogin2")
SetPrvt("_dDatade,_dDatate,_cSitu,CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,_dUltApr,aOrd")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY")
SetPrvt("_cMvGpem099,_aGrupo,_cLogin")
	
cabec1    := ""
cabec2    := ""
cabec3    := ""
wnrel     := ""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Funciona/Linha X Centro de Custo"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "ZRG"
nTipo     := 0
nomeprog  := "NHGPE099"
cPerg     := ""
nPag      := 1
m_pag     := 1
_aGrupo   := pswret()
_cLogin   := _agrupo[1,2]
_cMvGpem099 := Alltrim(GETMV("MV_GPEM099")) 
	
If Alltrim(_cMvGpem099) == 'S'
	MsgBox("Rotina Bloqueada, Verifique com Administrador da Folha de Pagameto.","Bloqueio Rescisao de Contrato","STOP")
	Return	
Endif	


fGeraZrg()
If !Empty(_cCustoa)
	If fExistApr()
		fGravaZrg()
		fGravaQaa()
	Else
		Return
	Endif			
Else
	Return
Endif

aRotina := {}
aAdd(aRotina, {"Pesquisar"  , "AxPesqui"   ,0 ,1 })
aAdd(aRotina, {"Visualizar" , "AxVisual"   ,0 ,2 })
aAdd(aRotina, {"Alterar"    , "AxAltera"   ,0 ,3 })
aAdd(aRotina, {"Transferir" , "U_fTranf()" ,0 ,3 })
	
/*
If ALLTRIM(UPPER(cUserName))$"ANDREIARB/JOAOFR"
	aAdd(aRotina, {"Incluir"    , "AxInclui"   ,0 ,3 })
Endif

//-- na fundicao nao pode transferir quando c.custo iniciar por 2,4 ou 5, somente permitido para rh
//-- os n�: 026948
If ! ( SM0->M0_CODIGO=='FN' .and. Substr(_cCustoa,1,1)$'2/4/5' .and. !alltrim(upper(cUserName))$'EMERSONM' )
	aAdd(aRotina, {"Transferir" , "U_fTranf()" ,0 ,3 })
EndIf
*/

aAdd(aRotina, {"Imprimir"   , "U_fImpLin"  ,0 ,4 }) 

cCadastro := "Cadastro Funcionario\Linha"

mBrowse(,,,,"ZRG",,,)
SET FILTER TO 
ZRG->(DbGotop())


Return(.T.)

             
Static Function fGeraZrg()

	_cCustod  := Space(09)
	_cCustoa  := Space(09)

	@ 100,050 To 320,500 Dialog oDlg Title OemToAnsi("Funcionario\Linha")
	@ 005,005 To 090,222 PROMPT "Dados Centro de Custo" OF oDlg  PIXEL
	@ 030,010 Say OemToAnsi("Centro de Custo ?") Size 60,8 OF oDlg PIXEL
	@ 030,080 Get _cCustoa PICTURE "@!"  F3 "CTT" Valid(!Vazio() .or. Existcpo("CTT")) Size 20,8
        
	@ 095,192 BMPBUTTON TYPE 01 ACTION Close(oDlg)
	Activate Dialog oDlg CENTERED

Return


Static function fExistApr()
Local lRet := .F.
Local _aGrupo := pswret()
Local _cLogin := Alltrim(_agrupo[1,2])

ZRJ->(DbSetOrder(1))
ZRJ->(DbSeek(xFilial("ZRJ")+UPPER(_cLogin)))
While !ZRJ->(Eof()) .AND. Alltrim(UPPER(ZRJ->ZRJ_LOGIN)) == ALLTRIM(UPPER(_cLogin))

	If Alltrim(ZRJ->ZRJ_CC) == "<todos>"
		lRet := .T.
		Exit
	Endif

	If Alltrim(ZRJ->ZRJ_CC) == Alltrim(_cCustoa)
		lRet := .T.
		Exit
	Endif
	ZRJ->(DbSkip())

Enddo

If !lRet 
		MsgBox("Nao existe Centro de Custo para este Login, Favor cadastrar !","Centro de Custo","ALERT")
		lRet := .F.
Endif
Return(lRet)

Static Function fGravaZrg()
CTT->(DbSetOrder(1))
SRA->(DbSetOrder(2))
SRJ->(DbSetOrder(1)) 
ZRG->(DbSetOrder(1))
SRA->(DbSeek(xFilial("SRA")+_cCustoa))
While !SRA->(Eof()) .AND. SRA->RA_CC == _cCustoa .and. SRA->RA_FILIAL == xFilial("SRA")
	If SRA->RA_SITFOLH <> "D" 
		IF !ZRG->(DbSeek(xFilial("ZRG")+SRA->RA_MAT))
			RecLock("ZRG",.T.)
			ZRG->ZRG_FILIAL := xFilial("ZRG")
			ZRG->ZRG_MAT    := SRA->RA_MAT
			ZRG->ZRG_NOME   := SRA->RA_NOME

			CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
			If CTT->(Found())
				ZRG->ZRG_DESC  := CTT->CTT_DESC01
			Endif	
			ZRG->ZRG_CC     := SRA->RA_CC
			ZRG->ZRG_ADMI   := SRA->RA_ADMISSA
			ZRG->ZRG_CODF   := SRA->RA_CODFUNC
			ZRG->ZRG_TURNO  := SRA->RA_TNOTRAB
			SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
			If SRJ->(Found())
				ZRG->ZRG_DESCF := SRJ->RJ_DESC
			Endif	
			MsUnLock("ZRG")
		Else      
			RecLock("ZRG",.F.)
		    If SRA->RA_CC <> ZRG->ZRG_CC
				ZRG->ZRG_CCRH    := SRA->RA_CC
			Endif

			ZRG->ZRG_CODF   := SRA->RA_CODFUNC
			SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
			If SRJ->(Found())
				ZRG->ZRG_DESCF := SRJ->RJ_DESC
			Endif	
			MsUnLock("ZRG")
		Endif
	Else
		If SRA->RA_SITFOLH == "D" 
			ZRG->(DbSeek(xFilial("ZRG")+SRA->RA_MAT))
			If ZRG->(Found())
				RecLock("ZRG",.F.)
					ZRG->(DbDelete())	
				MsUnLock("ZRG")		
			Endif
		Endif	
	Endif
	SRA->(DbSkip())
Enddo

SRA->(DbSetOrder(1))
DbSelectArea("ZRG")
SET FILTER TO ZRG->ZRG_FILIAL==xFilial("ZRG") .AND. ZRG->ZRG_CC == _cCustoa 
ZRG->(DbGotop())
While !ZRG->(Eof())

	IF ZRG->ZRG_FILIAL != xFilial("ZRG")
		ZRG->(dbskip())
		Loop
	Endif

	SRA->(DbSeek(xFilial("SRA")+ZRG->ZRG_MAT))
	If SRA->(Found())
	    If SRA->RA_CC <> ZRG->ZRG_CC
			RecLock("ZRG",.F.) 
				ZRG->ZRG_CCRH    := SRA->RA_CC
			MsUnLock("ZRG")
		Endif
	Else
		RecLock("ZRG",.F.)
			ZRG->(DbDelete())	
		MsUnLock("ZRG")		
	Endif
	ZRG->(DbSkip())
Enddo

ZRG->(DbGotop())

Return

// Grava QAA terceiros
Static Function fGravaQaa()
QAD->(DbSetOrder(1))
QAC->(DbSetOrder(1))
QAA->(DbSetOrder(2))
SRJ->(DbSetOrder(1))
ZRG->(DbSetOrder(1))
QAA->(DbSeek(xFilial("QAA")+_cCustoa))
While !QAA->(Eof()) .AND. QAA->QAA_FILIAL==xFilial('QAA') .AND. Alltrim(QAA->QAA_CC) == Alltrim(_cCustoa)

	If Empty(QAA->QAA_FIM) .AND. QAA->QAA_MATRIZ == '1' .AND. (Substr(QAA->QAA_MAT,1,2) == '99' .OR. Substr(QAA->QAA_MAT,1,2) == '70')

		IF !ZRG->(DbSeek(xFilial("ZRG")+Substr(QAA->QAA_MAT,1,6)))

			RecLock("ZRG",.T.)
			ZRG->ZRG_FILIAL := xFilial("ZRG")
			ZRG->ZRG_MAT    := QAA->QAA_MAT
			ZRG->ZRG_NOME   := QAA->QAA_NOME

			QAD->(DbSeek(xFilial("QAD")+QAA->QAA_CC))
			If QAD->(Found())
				ZRG->ZRG_DESC  := QAD->QAD_DESC   
			Endif	
			ZRG->ZRG_CC     := QAA->QAA_CC
			ZRG->ZRG_ADMI   := QAA->QAA_INICIO
			ZRG->ZRG_CODF   := QAA->QAA_CODFUNC
			ZRG->ZRG_TURNO  := '005'

			QAC->(DbSeek(xFilial("QAC")+QAA->QAA_CODFUN))
			If QAC->(Found())
				ZRG->ZRG_DESCF := QAC->QAC_DESC
			Endif	
			MsUnLock("ZRG")

		Else

			RecLock("ZRG",.F.)
			ZRG->ZRG_CC := QAA->QAA_CC
			QAD->(DbSeek(xFilial("QAD")+QAA->QAA_CC))
			If QAD->(Found())
				ZRG->ZRG_DESC  := QAD->QAD_DESC   
			Endif	

			ZRG->ZRG_CODF   := QAA->QAA_CODFUNC
			QAC->(DbSeek(xFilial("QAC")+QAA->QAA_CODFUN))
			If QAC->(Found())
				ZRG->ZRG_DESCF := QAC->QAC_DESC
			Endif	
			ZRG->ZRG_TURNO  := '005'
			MsUnLock("ZRG")


			If !Empty(QAA->QAA_FIM)
				ZRG->(DbSeek(xFilial("ZRG")+QAA->QAA_MAT))
				If ZRG->(Found())
					RecLock("ZRG",.F.)
					ZRG->(DbDelete())	
					MsUnLock("ZRG")		
				Endif
			Endif	
		Endif	
	Endif
	QAA->(DbSkip())
Enddo

        
User Function fTranf()
	
	_cCuston   := Space(09)
	_cOP       := Space(03)
	_cArea     := Space(06)
	_CAREADESC := ''	
	
	@ 000,000 To 160,450 Dialog oDlg Title OemToAnsi("Transferencia")
    @ 005,005 To 060,222 PROMPT "Funcionario: "+ZRG->ZRG_MAT+" "+ZRG->ZRG_NOME OF oDlg  PIXEL

	@ 020,010 Say OemToAnsi("C.Custo Destino:") Size 60,8 OF oDlg PIXEL
	@ 018,055 Get _cCuston PICTURE "@!"  F3 "CTT" Valid((!Vazio() .or. Existcpo("CTT")) .AND. fValCC()) Size 20,8 
        
	@ 032,010 Say OemToAnsi("Opera��o:") Size 60,8 OF oDlg PIXEL
	@ 030,055 Get _cOP PICTURE "@e 999" Valid fValOP() Size 20,8 OBJECT ocOP

	@ 044,010 Say OemToAnsi("Area:") Size 60,8 OF oDlg PIXEL
	@ 042,055 Get _cArea PICTURE "@!"  F3 "ARE" Valid fValArea() Size 40,8 OBJECT ocArea
	@ 042,100 GET _cAreaDesc WHEN .F. Size 115,008 Object oAreaDesc

	@ 065,162 BMPBUTTON TYPE 01 ACTION fTrocac(oDlg)
	@ 065,192 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	Activate Dialog oDlg CENTERED

Return
      
Static Function fValCC()
Local _aGrupo := pswret()
Local _cLogin := Alltrim(_agrupo[1,2])

	If SM0->M0_CODIGO=="NH" //--Empresa Usinagem
		If Substr(_cCuston,1,1)=="5"
			Alert("Imposs�vel transferir para C.Custo de Resultado!")
			Return .F.
		EndIf
	ElseIf SM0->M0_CODIGO=="FN" //--Empresa Fundicao

		If Substr(_cCuston,2,1)=="5"
			Alert("Imposs�vel transferir para C.Custo de Resultado!")
			Return .F.
		EndIf

		If AllTrim(_cCuston)$"11003999/23007999/43007999/33007999/53007999"
			                                                  
			If _cLogin $ 'EMERSONM/ESELAINEOR/RAFAELEN/LUCIANOS'
			    Return .t.
			Else
			    Alert('Para C.Custo de Afastados somente pessoal do RH!')
			    Return .f.
			Endif
						    
		EndIf
	
	EndIf
	
	
	If CTT->CTT_BLOQ == '1'
		Alert("Imposs�vel transferir para C.Custo Bloqueado!")
		Return .F.
	Endif	
			    	
	
Return .T.


Static Function fValOP()

	If Empty(_cOP)                                    
	
		Alert("Informe a Opera��o!")
		Return .F.
	EndIf
	
	If len(AllTrim(_cOP))!=3 
		AlerT("Informe a opera��o com 3 d�gitos!")
		Return .F.
	EndIf

Return


Static Function fTrocac()
	RecLock("ZRG",.F.)
	ZRG->ZRG_OPD     := _cOP
	ZRG->ZRG_CCD     := _cCuston
	ZRG->ZRG_AREA    := _cArea
	ZRG->ZRG_TRANSF  := "em Transferencia"
	MsUnLock("ZRG")

	Close(oDlg)
Return

User Function fAprova()
Local _cDescd := Space(30)
	CTT->(DbSeek(xFilial("CTT")+ZRG->ZRG_CCD))
	If CTT->(Found())
		_cDescd := CTT->CTT_DESC01
	Endif	

	If MsgBox("Transfere de: "+ZRG->ZRG_CC+" "+Alltrim(ZRG->ZRG_DESC) +" para "+ZRG->ZRG_CCD + " "+Alltrim(_cDescd),"Transferencia","YESNO")
		RecLock("ZRG",.F.)
			ZRG->ZRG_CC     := ZRG->ZRG_CCD
			ZRG->ZRG_OP     := ZRG->ZRG_OPD
			ZRG->ZRG_DESC   := _cDescd
			ZRG->ZRG_CCD    := Space(09)
			ZRG->ZRG_OPD    := Space(02)
			ZRG->ZRG_TRANSF := Space(10)
		MsUnLock("ZRG")
	Endif

	SET FILTER TO ZRG->ZRG_CC >= _cCustod .AND. ZRG->ZRG_CC <= _cCustoa
	
	ZRG->(DbGotop())
Return


 
User Function fImpLin()


//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:= "NHGPE099"
aOrd := {"Codigo","Centro de Custo","Nome","Turno"}
SetPrint("ZRG",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
// SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Imprime()},"Imprimindo...")

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Imprime()

Local _nFun := 0, _cNumero, _cNmbanco := Space(40)
Local _nVlrTot   := 0

DbSelectArea("ZRG")
SET FILTER TO ZRG->ZRG_CC == _cCustoa 
ZRG->(Dbgotop())
                        
Cabec1    := "Matr.  Nome                             C\Custo   Descricao             Admissao     Funcao  Descricao                       Operador            Maquina                        C\C Dest  Status           C\C RH   TURNO"
cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 

While !ZRG->(eof())
	
	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	@ Prow() + 1, 000 Psay 	ZRG->ZRG_MAT
	@ Prow()    , 007 Psay 	ZRG->ZRG_NOME
	@ Prow()    , 040 Psay 	ZRG->ZRG_CC
	@ Prow()    , 050 Psay 	ZRG->ZRG_DESC
	@ Prow()    , 072 Psay 	ZRG->ZRG_ADMI
	@ Prow()    , 085 Psay 	ZRG->ZRG_CODF
	@ Prow()    , 090 Psay 	ZRG->ZRG_DESCF
	@ Prow()    , 125 Psay 	ZRG->ZRG_OPER 
	@ Prow()    , 145 Psay 	ZRG->ZRG_MAQ  
	@ Prow()    , 176 Psay 	ZRG->ZRG_CCD  
	@ Prow()    , 186 Psay 	ZRG->ZRG_TRANSF
	@ Prow()    , 203 Psay 	ZRG->ZRG_CCRH 
	@ Prow()    , 212 Psay 	ZRG->ZRG_TURNO
	_nFun++
	ZRG->(DbSkip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()  
@ Prow() + 1,000 Psay "Qtde Funcionarios: "+TRANSFORM(_nFun,"99999")
@ Prow() + 1,000 Psay __PrtThinLine()  

Return
                                                                                        

//��������������������������Ŀ
//� TRAZ A DESCRICAO DA AREA �
//����������������������������
Static Function fValArea()

	SX5->(Dbgotop())
	SX5->(DbSetOrder(1)) //FILIAL + TABELA + CHAVE
	If SX5->(DbSeek(xFilial("SX5")+"ZV"+_cArea)) //AREAS
    	_cAreaDesc := SX5->X5_DESCRI
    	oAreaDesc:Refresh()
 	Else
 		If !Empty(_cArea)
 			Alert("Area n�o existente!")
	 		Return .F.
	 	EndIf
 	EndIf

Return .T.
