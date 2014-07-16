/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCFG007  ºAutor  ³Marcos R Roquitski  º Data ³  16/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutencao no Cadastro de Usuarios X tipos de documentos.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  

User Function NhCfg007() 

SetPrvt("cCadastro,aRotina,Local _Login, _Grupo, _LocalPad, _Desc, _Cod")

cCadastro := 'Cadastro de Responsaveis X Grupos'
aRotina := {{ "Pesquisa","AxPesqui"      ,0,1},;
            { "Visual"  ,"AxVisual"      ,0,2},;
            { "Inclui"  ,"U_mResp(1)"  ,0,3},;
            { "Altera"  ,"U_mResp(2)"  ,0,3} }

DbSelectArea("SX5")
Set filter to SX5->X5_TABELA = 'ZD'
SX5->(DbGotop())
mBrowse(,,,,"SX5",,,,,,)
Set Filter to 
SX5->(DbGotop())

Return


User Function mResp(pOpcao)

If pOpcao == 1 // Inclusao
	_Login := Space(16)
	_Grupo := Space(02)
	_Ordem := Space(01)
	_Desc  := Space(30)

Elseif pOpcao == 2 // Altera

	_Login := Substr(SX5->X5_DESCRI,01,15)+Space(01)
	_Grupo := Right(Alltrim(SX5->X5_DESCRI),2)
	_Ordem := Space(01)
	_Desc  := Space(30)

Endif	

@ 200,050 To 400,600 Dialog DlgTabela Title OemToAnsi("Cadastro Usuarios X Tipos de Documentos")

@ 010,020 Say OemToAnsi("Login        ") Size 35,8
@ 025,020 Say OemToAnsi("Tipo de DOC'S") Size 35,8

@ 009,070 Get _Login  PICTURE "@!" F3 "QUS" Size 55,8
@ 026,070 Get _Grupo  PICTURE "@!" F3 "QD2" Size 45,8

@ 075,070 BMPBUTTON TYPE 01 ACTION GravaDados(pOpcao)
@ 075,110 BMPBUTTON TYPE 02 ACTION Close(DlgTabela)
Activate Dialog DlgTabela CENTERED

Return


User Function mResg()

_Login := Space(16)
_Grupo := Space(02)
_Ordem := Space(01)
_Desc  := Space(30)

@ 200,050 To 400,600 Dialog DlgTabelg Title OemToAnsi("Cadastro Usuarios X Tipos de Documentos")

@ 010,020 Say OemToAnsi("Login  ") Size 35,8
@ 025,020 Say OemToAnsi("Tipo de DOC'S") Size 35,8

@ 009,070 Get _Login  PICTURE "@!" F3 "QUS" Size 55,8
@ 026,070 Get _Grupo    PICTURE "@!" F3 "QD2" Size 45,8


@ 075,070 BMPBUTTON TYPE 01 ACTION GravaDadog()
@ 075,110 BMPBUTTON TYPE 02 ACTION Close(DlgTabelg)
Activate Dialog DlgTabelg CENTERED

Return


Static Function GravaDados(pOpcao)
_Cod := 0

If Empty(_Login)
	MsgBox("Login ou tipo de documentos em branco corrija !","Tipos de Documentos","ALERT")
	Close(DlgTabelg)
	Return
Endif		

If pOpcao == 1 
	SX5->(Dbgotop())
	While !SX5->(Eof())
		If SX5->X5_TABELA  == "ZD" .AND. Val(SX5->X5_CHAVE) > _Cod
			_Cod := Val(SX5->X5_CHAVE)
		Endif
		SX5->(DbSkip())
	Enddo
	RecLock("SX5",.T.)
	SX5->X5_TABELA  := "ZD"
	SX5->X5_CHAVE   := Alltrim(Str(_Cod +1))
	SX5->X5_DESCRI  := _Login + _Grupo
	SX5->X5_DESCSPA := _Login + _Grupo
	SX5->X5_DESCENG := _Login + _Grupo
	MsUnLock("SX5")
	Close(DlgTabela)
Else
	RecLock("SX5",.F.)
	SX5->X5_DESCRI  := _Login + _Grupo
	SX5->X5_DESCSPA := _Login + _Grupo
	SX5->X5_DESCENG := _Login + _Grupo
	MsUnLock("SX5")
	Close(DlgTabela)
Endif	

Return


Static Function GravaDadog()
_Cod := 0

If Empty(_Login) 
	MsgBox("Login ou Grupo estao com dados em branco Corrija !","Grupos","ALERT")
	Close(DlgTabelg)
	Return
Endif		

SBM->(DbGotop())
While !SBM->(Eof()) 
	_Grupo := Substring(QD2->QD2_CODTP,1,2)
	SX5->(Dbgotop())
	While !SX5->(Eof())
		If SX5->X5_TABELA  == "ZD" .AND. Val(SX5->X5_CHAVE) > _Cod
			_Cod := Val(SX5->X5_CHAVE)
		Endif
		SX5->(DbSkip())
	Enddo
	RecLock("SX5",.T.)
	SX5->X5_TABELA  := "ZD"
	SX5->X5_CHAVE   := Alltrim(Str(_Cod +1))
	SX5->X5_DESCRI  := _Login + _Grupo
	SX5->X5_DESCSPA := _Login + _Grupo
	SX5->X5_DESCENG := _Login + _Grupo
	MsUnLock("SX5")

	SBM->(DbSkip())

Enddo
Close(DlgTabelg)

Return

Return
