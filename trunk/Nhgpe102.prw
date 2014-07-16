/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE102  ºAutor  ³Marcos R Roquitski  º Data ³  07/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Transferencia de funcionarios entre c\custos, tabelas      º±±
±±º          ³ SRA e SRE                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"


User Function Nhgpe102()

SetPrvt("aRotina,cCadastro,_cCustod,_cCustoa,_cMat,_cNome,_cCustc,_cCuste,_cCuston")

Processa({|| fGravaZrg() },'Atualizando da Folha para ZRG')
  
aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2},;
             {"Transfere","U_fTranscc",0,4} }

cCadastro := "Cadastro Funcionario\Linha"

mBrowse(,,,,"ZRG",,,)
SET FILTER TO 
ZRG->(DbGotop())


Return(.T.)


Static Function fGravaZrg()

SRA->(DbSetOrder(1))

DbSelectArea("ZRG")
SET FILTER TO ZRG->ZRG_FILIAL == xFilial("ZRG")     

ZRG->(DbGotop())
While !ZRG->(Eof()) 

	IF ZRG->ZRG_FILIAL != xFilial("ZRG")
		ZRG->(dbskip())
		Loop
	Endif

	SRA->(DbSeek(xFilial("SRA")+ZRG->ZRG_MAT))
	If SRA->(Found()) .and. AllTrim(SRA->RA_CC) != '103999'
		If SRA->RA_SITFOLH == 'D'
			RecLock("ZRG",.F.)
			ZRG->(DbDelete())
			MsUnLock("ZRG")
		Else
		    If SRA->RA_CC <> ZRG->ZRG_CC 
		    	If SUBSTRING(ZRG->ZRG_CC,1,1) $ '1/3' // Somente Administrativo/Usinagem
					RecLock("ZRG",.F.)
					ZRG->ZRG_CCRH    := SRA->RA_CC
					MsUnLock("ZRG")
				Endif	
			Endif
		Endif
	Endif	
	ZRG->(DbSkip())
Enddo
ZRG->(DbGotop())



SET FILTER TO ZRG->ZRG_FILIAL == xFilial("ZRG") .AND. !Empty(ZRG->ZRG_CCRH) .AND. Alltrim(ZRG->ZRG_CC) <> '103999'.AND. Alltrim(ZRG->ZRG_CCRH) <> '103999'
ZRG->(DbGotop())

Return


User Function fTranscc()
Local _cDesca := Space(30)
Local _cDescb := Space(30)

	CTT->(DbSeek(xFilial("CTT")+ZRG->ZRG_CCRH))
	If CTT->(Found())
		_cDesca := CTT->CTT_DESC01
	Endif

	CTT->(DbSeek(xFilial("CTT")+ZRG->ZRG_CC))
	If CTT->(Found())
		_cDescb := CTT->CTT_DESC01
	Endif

	If CTT->CTT_BLOQ == '1'    
		Alert("Impossível transferir para C.Custo Bloqueado!")
		Return .F.
	Endif	


	If MsgBox("Transfere de: "+ZRG->ZRG_CCRH+" "+Alltrim(_cDesca) +" para "+ZRG->ZRG_CC + " "+Alltrim(_cDescb),"Transferencia","YESNO")
		RecLock("SRE",.T.)
		SRE->RE_DATA    := DATE()
		SRE->RE_EMPD    := SM0->M0_CODIGO
		SRE->RE_FILIALD := "01"
		SRE->RE_MATD    := ZRG->ZRG_MAT
		SRE->RE_CCD     := ZRG->ZRG_CCRH   
		SRE->RE_EMPP    := SM0->M0_CODIGO
		SRE->RE_FILIALP := "01"
		SRE->RE_MATP    := ZRG->ZRG_MAT
		SRE->RE_CCP     := ZRG->ZRG_CC
		MsUnLock("SRE")

		SRA->(DbSeek(xFilial("SRA")+ZRG->ZRG_MAT))
		If SRA->(Found())
			RecLock("SRA",.F.)
			SRA->RA_CC := ZRG->ZRG_CC
			MsUnLock("SRA")
		Endif	
	Endif
	RecLock("ZRG",.F.)
	ZRG->ZRG_CCRH    := Space(09)
	ZRG->ZRG_TRANSF  := ""
	MsUnLock("ZRG")
	ZRG->(DbGotop())
Return
 