/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCFG004  ºAutor  ³Marcos R Roquitski  º Data ³  09/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutencao no Cadastro de Responsaveis X Grupos.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  

User Function NhCfg004() 

SetPrvt("cCadastro, aRotina, Local, _Login, _Grupo, _LocalPad, _Desc, _Cod, _cTipo, _cCusto, _aComba1")
SetPrvt("_aOpcao,_cOpcao")

_aOpcao   := {"Sim","Nao"}
_cOpcao   := "Nao"
_aComba1  := {}
cCadastro := 'Cadastro de Responsaveis X Grupos'
aRotina := {{ "Pesquisa","AxPesqui"      ,0,1},;
            { "Visual"  ,"AxVisual"      ,0,2},;
            { "Inclui"  ,"U_ManResp(1)"  ,0,3},;
            { "Todos os Grupos"  ,"U_ManResg()",0,3},;
            { "Altera"  ,"U_ManResp(2)"  ,0,3},;
            { "Exclui"  ,"U_fDelGrp()"  ,0,3} }
            
DbSelectArea("SX5")
SX5->(DbGotop())
SX5->(DbSeek(xFilial("SX5")+"02"))
AADD(_aComba1,Space(02))
While !SX5->(Eof()) .And. SX5->X5_TABELA == "02"
	AADD(_aComba1,Alltrim(SX5->X5_CHAVE))
	SX5->(DbSkip())
Enddo

Set filter to SX5->X5_TABELA = 'ZH'
SX5->(DbGotop())
mBrowse(06,01,22,75,"SX5",,,,,,)
Set Filter to 
SX5->(DbGotop())

Return


User Function ManResp(pOpcao)

If pOpcao == 1 // Inclusao
	_Login  := Space(15)
	_Grupo  := Space(04)
	_Ordem  := Space(01)
	_Desc   := Space(30)
	_cTipo  := Space(02)
	_cCusto := Space(09)
    _cOpcao := "Nao"	

Elseif pOpcao == 2 // Altera
	_Login  := Substr(SX5->X5_DESCRI,01,15)
	_Grupo  := Substr(SX5->X5_DESCRI,16,4)
	_Ordem  := Substr(SX5->X5_DESCRI,20,1)
	_Desc   := Space(30)
	_cTipo  := Substr(SX5->X5_DESCRI,21,2)
	_cCusto := Substr(SX5->X5_DESCRI,23,9) //Substr(SX5->X5_DESCRI,23,9)
    _cOpcao := Iif(Empty(Substr(SX5->X5_DESCRI,32,1)),"Nao",Substr(SX5->X5_DESCRI,32,1))
	BuscaGrupo()

Endif


@ 200,050 To 500,600 Dialog DlgTabela Title OemToAnsi("Cadastro Usuarios X Grupos")
@ 011,020 Say OemToAnsi("Login       ") Size 35,8
@ 026,020 Say OemToAnsi("Grupo       ") Size 35,8
@ 042,020 Say OemToAnsi("Ordem       ") Size 35,8
@ 057,020 Say OemToAnsi("Tipo        ") Size 35,8
@ 072,020 Say OemToAnsi("C.Contabil  ") Size 35,8
@ 073,115 Say OemToAnsi("Conta Projeto 104020") Size 100,8
@ 087,020 Say OemToAnsi("Contrato    ") Size 35,8

@ 011,070 Get _Login  PICTURE "@!" F3 "QUS" Size 55,8
@ 026,070 Get _Grupo    PICTURE "@!" F3 "SBM" Valid BuscaGrupo(1) Size 45,8
@ 026,115 Get _Desc     PICTURE "@!" When .F. Size 120,8
@ 041,070 Get _Ordem    PICTURE "9"  Size 20,8
@ 057,070 COMBOBOX _cTipo  ITEMS _aComba1 SIZE 25,10 object oComba1 
//@ 072,070 Get _cCusto   PICTURE "@!" F3 "CT1" Valid(Vazio() .OR. Existcpo("CT1")) Size 20,8
@ 072,070 Get _cCusto   PICTURE "@!"  Valid fconta() object oconta Size 20,08 //(Vazio() .OR. Existcpo("CT1")) Size 20,8
@ 087,070 COMBOBOX _cOpcao ITEMS _aOpcao SIZE 30,10 object oOpcao     

@ 0105,070 BMPBUTTON TYPE 01 ACTION GravaDados(pOpcao)
@ 0105,110 BMPBUTTON TYPE 02 ACTION Close(DlgTabela)
Activate Dialog DlgTabela CENTERED

Return

Static Function fconta()
Local _lRet := .T.
If !Empty(_cCusto)
   if Len(Alltrim(_cCusto)) <> 6 .Or. Alltrim(_cCusto) <> "104020"
      _cCusto:= "104020" //conta de projetos novos
   Endif
Endif

Return(_lRet)

User Function ManResg()

_Login := Space(15)
_Grupo := Space(04)
_Ordem := Space(01)
_Desc  := Space(30)
_cTipo  := Space(02)
_cCusto := Space(09)
_cOpcao := "Nao"	



@ 200,050 To 400,600 Dialog DlgTabelg Title OemToAnsi("Cadastro Usuarios X Grupos")

@ 010,020 Say OemToAnsi("Login  ") Size 35,8
@ 025,020 Say OemToAnsi("Nivel  ") Size 35,8     
@ 040,020 Say OemToAnsi("Contrato    ") Size 35,8
@ 009,070 Get _Login  PICTURE "@!" F3 "QUS" Size 55,8
@ 026,070 Get _Ordem    PICTURE "9"  Size 20,8
@ 041,070 COMBOBOX _cOpcao ITEMS _aOpcao SIZE 30,10 object oOpcao     
@ 075,070 BMPBUTTON TYPE 01 ACTION GravaDadog()
@ 075,110 BMPBUTTON TYPE 02 ACTION Close(DlgTabelg)
Activate Dialog DlgTabelg CENTERED

Return



Static Function BuscaGrupo(pGrupo)
Local lRet := .T.
SBM->(DbSeek(xFilial("SBM") + _Grupo))
If SBM->(Found())
	_Desc := SBM->BM_DESC
Elseif pGrupo == 1
	lRet := .F.
	_Desc := Space(30)
	MsgBox("Grupo nao pertence ao cadastro !","Grupos","ALERT")
Endif
Return(lRet)	


Static Function GravaDados(pOpcao)
_Cod := 0
If Empty(_cTipo)
	_cTipo := Space(02)
Endif	

If Empty(_Login)
	MsgBox("Login ou Grupo estao com dados em branco Corrija !","Grupos","ALERT")
	Close(DlgTabelg)
	Return
Endif		

If pOpcao == 1 
	SX5->(Dbgotop())
	While !SX5->(Eof())
		If SX5->X5_TABELA  == "ZH" .AND. Val(SX5->X5_CHAVE) > _Cod
			_Cod := Val(SX5->X5_CHAVE)
		Endif
		SX5->(DbSkip())
	Enddo
	RecLock("SX5",.T.)
	SX5->X5_TABELA  := "ZH"
	SX5->X5_CHAVE   := Alltrim(Str(_Cod +1))
	SX5->X5_DESCRI  := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)
	SX5->X5_DESCSPA := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)
	SX5->X5_DESCENG := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)
	MsUnLock("SX5")
Elseif pOpcao == 2
	RecLock("SX5",.F.)
	SX5->X5_DESCRI  := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)
	SX5->X5_DESCSPA := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)
	SX5->X5_DESCENG := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)
	MsUnLock("SX5")
Endif	
Close(DlgTabela)
Return



User Function fDelGrp()
If MsgBox("Confirme exclusao do Aprovador deste Grupo ?","Exclusao do Aprovador","YESNO")
	RecLock("SX5",.F.)
	DbDelete()	
	MsUnLock("SX5")
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
	_Grupo := Substring(SBM->BM_GRUPO,1,4)
	SX5->(Dbgotop())
	While !SX5->(Eof())
		If SX5->X5_TABELA  == "ZH" .AND. Val(SX5->X5_CHAVE) > _Cod
			_Cod := Val(SX5->X5_CHAVE)
		Endif
		SX5->(DbSkip())
	Enddo
	RecLock("SX5",.T.)
	SX5->X5_TABELA  := "ZH"
	SX5->X5_CHAVE   := Alltrim(Str(_Cod +1))
	SX5->X5_DESCRI  := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)  
	SX5->X5_DESCSPA := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)    
	SX5->X5_DESCENG := _Login + _Grupo + _Ordem  + _cTipo + _cCusto + Subs(_cOpcao,1,1)  
	MsUnLock("SX5")

	SBM->(DbSkip())

Enddo
Close(DlgTabelg)

Return