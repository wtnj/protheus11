/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHGPE109 ºAutor  ³Marcos R Roquitski  º Data ³  07/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Funcionario Linha.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhgpe109()

SetPrvt("aRotina,cCadastro,_cCustod,_cCustoa,_cMat,_cNome,_cCustc,_cCuste,_cCuston")
SetPrvt("mStruct,mArqTrab,aFields,aRotina,cDelFunc,cCadastro,cMarca,cCoord,_aGrupo,_cLogin,_cLogin2")
SetPrvt("_dDatade,_dDatate,_cSitu,CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,_dUltApr,aOrd")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY")

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
lEnd      := .T.

MsAguarde ( {|lEnd| fGravaZrg() },"Aguarde", "Cadastro de Funcionario\Linha", .T.)
	
aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2} }
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
	@ 030,010 Say OemToAnsi("Centro de Custo ?") Size 60,8 OF oDlg PIXEL

	//@ 015,080 Get _cCustod PICTURE "@!"  F3 "CTT" Valid(Vazio() .or. Existcpo("CTT")) Size 20,8
	@ 030,080 Get _cCustoa PICTURE "@!"  F3 "CTT" Valid(!Vazio() .or. Existcpo("CTT")) Size 20,8
        
	@ 095,192 BMPBUTTON TYPE 01 ACTION Close(oDlg)
	Activate Dialog oDlg CENTERED

Return


Static function fExistApr()
Local lRet := .T.
Local _aGrupo := pswret()
Local _cLogin := _agrupo[1,2]

ZRJ->(DbSetOrder(1))
ZRJ->(DbSeek(xFilial("ZRJ")+PadR(_cLogin,TamSx3("ZRJ_LOGIN")[1])+_cCustoa))
If !ZRJ->(Found())
	ZRJ->(DbSeek(xFilial("ZRJ")+PadR(_cLogin,TamSx3("ZRJ_LOGIN")[1])+"<todos>"))
	If !ZRJ->(Found())
		MsgBox("Nao existe Centro de Custo para este Login, Favor cadastrar !","Centro de Custo","ALERT")
		lRet := .F.
	Endif	
Endif
Return(lRet)


Static Function fGravaZrg()
CTT->(DbSetOrder(1))
SRA->(DbSetOrder(2))
SRJ->(DbSetOrder(1))
While !SRA->(Eof())                                                                                  

	If SRA->RA_SITFOLH <> "D" .AND. Alltrim(SRA->RA_CC) <> '103999'

		MsProcTxt(SRA->RA_MAT +" - "+SRA->RA_NOME)

		ZRG->(DbSeek(xFilial("ZRG")+SRA->RA_MAT))
		If !ZRG->(Found())
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
	Endif
	SRA->(DbSkip())
Enddo

SRA->(DbSetOrder(1))
DbSelectArea("ZRG")
ZRG->(DbGotop())
While !ZRG->(Eof())
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
           
 
User Function fImpGer()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
