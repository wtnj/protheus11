/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE100  �Autor  �Marcos R Roquitski  � Data �  07/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcionarios transferido.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"
#include "topconn.ch"

User Function Nhgpe100()

SetPrvt("aRotina,cCadastro,_cCustod,_cCustoa,_cMat,_cNome,_cCustc,_cCuste,_cCuston,_cMvGpem099")

_cMvGpem099 := Alltrim(GETMV("MV_GPEM099")) 
	
If Alltrim(_cMvGpem099) == 'S'
	MsgBox("Rotina Bloqueada, Verifique com Administrador da Folha de Pagameto.","Bloqueio Rescisao de Contrato","STOP")
	Return	
Endif	


fGeraZrg()
If !Empty(_cCustoa)
	If fExistApr()
		fGravaZrg()
	Else
		Return	
	Endif	
Else
	Return
Endif
	
aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2},;
             {"Aprovar","U_fAprova2",0,4} }
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
	//@ 015,010 Say OemToAnsi("Centro de Custo de ?") Size 60,8 OF oDlg PIXEL
	@ 030,010 Say OemToAnsi("Centro de Custo Ate ?") Size 60,8 OF oDlg PIXEL

	//@ 015,080 Get _cCustod PICTURE "@!"  F3 "CTT" Valid(Vazio() .or. Existcpo("CTT")) Size 20,8  
	@ 030,080 Get _cCustoa PICTURE "@!"  F3 "CTT" Valid(!Vazio() .or. Existcpo("CTT")) Size 20,8 
        
	@ 095,192 BMPBUTTON TYPE 01 ACTION Close(oDlg)
	Activate Dialog oDlg CENTERED

Return

Static function fExistApr()
Local lRet := .F.
Local _aGrupo := pswret()
Local _cLogin := Alltrim(_agrupo[1,2])

ZRJ->(DbSetOrder(1))
ZRJ->(DbSeek(xFilial("ZRJ")+ALLTRIM(UPPER(_cLogin))))
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

SRA->(DbSetOrder(1))
DbSelectArea("ZRG")
SET FILTER TO ZRG->ZRG_FILIAL==XFILIAL("ZRG") .AND. ZRG->ZRG_CCD == _cCustoa //.AND. ZRG->ZRG_CCD <= _cCustoa 
ZRG->(DbGotop())
While !ZRG->(Eof())

	If ZRG->ZRG_FILIAL<>XFILIAL("ZRG")	
		ZRG->(DBSKIP())
		LOOP
	ENDIF

	SRA->(DbSeek(xFilial("SRA")+ZRG->ZRG_MAT))
	If SRA->(Found())
	    If SRA->RA_CC <> ZRG->ZRG_CC
			RecLock("ZRG",.F.)
			ZRG->ZRG_CCRH    := SRA->RA_CC
			MsUnLock("ZRG")
		Endif
	Endif
	ZRG->(DbSkip())
Enddo
ZRG->(DbGotop())

Return


User Function fAprova2()
Local _cDescd := Space(30)
Local cQuery  := ""

	CTT->(DbSeek(xFilial("CTT")+ZRG->ZRG_CCD))
	If CTT->(Found())
		_cDescd := CTT->CTT_DESC01
	Endif	

	If CTT->CTT_BLOQ == '1'    
		Alert("Imposs�vel transferir para C.Custo Bloqueado!")
		Return .F.
	Endif	


	If MsgBox("Transfere de: "+ZRG->ZRG_CC+" "+Alltrim(ZRG->ZRG_DESC) +" para "+ZRG->ZRG_CCD + " "+Alltrim(_cDescd),"Transferencia","YESNO")
        
  		IF SELECT("TRX") > 0
  			TRX->(DBCLOSEAREA())
  		ENDIF
  		               
  		//-- verifica se o usu�rio est� retornando para o CC antes de completar 90 dias
  		
  		lMaisq90 := .f.
  		
  		cQuery := "SELECT TOP 1 * FROM "+RetSqlName("SRE")
  		cQuery += " WHERE RE_MATD = '"+ZRG->ZRG_MAT+"'"
  		cQuery += " AND RE_MATP = '"+ZRG->ZRG_MAT+"'"
  		cQuery += " AND RE_CCD = '"+ZRG->ZRG_CCD+"'"
  		cQuery += " AND RE_FILIAL = '"+XFILIAL("SRE")+"' AND D_E_L_E_T_ = ''" 
  		cQuery += " ORDER BY R_E_C_N_O_ DESC"
  		
  		TCQUERY cQuery NEW ALIAS "TRX"
  		     
  		TCSETFIELD("TRX","RE_DATA","D")//MUDA DE STRING PARA DATA
  		
  		TRX->(DBGOTOP())
  		
  		ZB0->(dbsetorder(1)) //ZB0_FILIAL+ZB0_CODATV+ZB0_CC
  		
  		IF !EMPTY(TRX->RE_MATD)
  		    IF (DATE() - TRX->RE_DATA) >= 90
				lMaisq90 := .t.
			Endif
		Endif
		  		
  		ZB1->(DBSETORDER(1)) //FILIAL + MAT + ATV + CC
	  	IF ZB1->(DBSEEK(XFILIAL("ZB1")+ZRG->ZRG_MAT))
  			WHILE ZB1->(!EOF()) .AND. ZB1->ZB1_FILIAL==XFILIAL('ZB1') .AND. ZB1->ZB1_MAT == ZRG->ZRG_MAT
  							
				If ZB0->(dbseek(xFilial('ZB0')+ZB1->ZB1_ATIVID))
  							  							                                                                        
					//-- SE ATIVIDADE NAO FOR GENERICA
					//-- SE ESTIVER RETORNANDO AO CENTRO DE CUSTO COM PERIODO MAIOR QUE 90 DIAS
					//-- SE A ATIVIDADE FOR DO MESMO CENTRO DE CUSTO QUE ESTA RETORNANDO
					//-- EXCLUI QUALIFICA��O DA ATIVIDADE
					If !ALLTRIM(ZB0->ZB0_GENERIC)$'S' .AND. ( lMaisq90 .AND. ALLTRIM(ZB1->ZB1_CC) == ALLTRIM(ZRG->ZRG_CCD) )
  						RECLOCK("ZB1",.F.)
							ZB1->(DBDELETE())
						MSUNLOCK("ZB1")
					ELSE
						RECLOCK("ZB1",.F.)
							ZB1->ZB1_CC := ZRG->ZRG_CCD
						MSUNLOCK("ZB1")
					ENDIF
                
                 Endif
                
				ZB1->(DBSKIP())
			ENDDO
		ENDIF
		
  		RecLock("ZRG",.F.)
  		  ZRG->ZRG_CC     := ZRG->ZRG_CCD
  		  ZRG->ZRG_OP     := ZRG->ZRG_OPD
  		  ZRG->ZRG_DESC   := _cDescd
  		  ZRG->ZRG_CCD    := Space(09)
  		  ZRG->ZRG_OPD    := Space(03)
  		  ZRG->ZRG_TRANSF := "Transferido"
		MsUnLock("ZRG")
		
	Endif

	SET FILTER TO ZRG->ZRG_FILIAL==XFILIAL('ZRG') .AND. ZRG->ZRG_CCD == _cCustoa //.AND. ZRG->ZRG_CCD <= _cCustoa
	ZRG->(DbGotop())                      

Return
 