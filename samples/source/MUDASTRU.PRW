SX3->(DBSETORDER(1))
cArqSx2 := "SX2"+SM0->M0_CODIGO+"0"
cIndSx2 :=cArqSx2
IF !OpenSX2Excl(cArqSx2,cIndSx2)
Else
   Do While .T.
      cAlias:="   "
      @  0, 0 TO 250,400 DIALOG oDlg TITLE "Atualiza‡„o de Estruturas em SQL"
      @ 30,35 TO 80,130
      @ 50,40 SAY "Arquivo..:"
      @ 50,80 GET cAlias PICTURE "!!!" Valid Execute(AlValid)
      @ 35,150 BMPBUTTON TYPE 01 ACTION Execute(ATUALIZAR)
      @ 65,150 BMPBUTTON TYPE 02 ACTION Close(oDlg)
      ACTIVATE DIALOG oDlg  CENTERED
      Exit
   Enddo
ENDIF
__Return(.T.)



*---------------
Function AlValid
*---------------
_AliasOk:=.F.
If ! SX2->(DBSEEK(cAlias))
   _AliasOk:=.F.   
   MsgStop("Tabela nao encontrada no SX2.","Aviso de Erro")
ElseIf ! SX3->(DBSEEK(cAlias))
   _AliasOk:=.F.
   MsgStop("Tabela nao encontrada no SX3.","Aviso de Erro")
ElseIf ! TCCanOpen(ALLTRIM(SX2->X2_ARQUIVO))
   _AliasOk:=.F.
   MsgStop("Tabela nao encontrada no SQL.","Aviso de Erro")
Else
   _AliasOk:=.T.
Endif
Return _AliasOk



*-----------------
Function ATUALIZAR
*-----------------
Processa({||Execute(ATUALIZA)})
Return .T.



*----------------
Function ATUALIZA
*----------------
cArqIni := ALLTRIM(SX2->X2_ARQUIVO)

ProcRegua(7)

IncProc("Apagando Arq. de Backup")
MSErase(RetArq( "TOPCONN",cArqIni+".#DB",.f.))

IncProc("Renomeando Arq. para Backup")
MSRename(cArqIni+GetDBExtension(),cArqIni+".#DB")

IncProc("Verificando Estrutura.")
aNewStr:={}

Do while ! SX3->(EOF()) .AND. SX3->X3_ARQUIVO == cAlias
   If SX3->X3_CONTEXT#"V"
      AADD(aNewStr,{SX3->X3_CAMPO ,SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL}) 
   EndIf
   SX3->(DBSKIP())
Enddo

IncProc("Apagando Indices.")
SIX->(DbSeek(cAlias))
While ( ! SIX->(Eof()) ) .And. ( cAlias == SIX->INDICE )
      Ferase(cArqIni+SIX->ORDEM+RetIndExt())
      SIX->(DbSkip())
End

IncProc("Criando Arq.")                    
MSCreate(cArqIni,aNewStr,"TOPCONN")

IncProc("Atualizando Arq.")                    
cArqTemp := cArqIni+".#DB"

lOk := .F.
While !lOk
   lOk :=MsOpenDbf(.T.,"TOPCONN",cArqIni+GetDBExtension(),"CurArqAtu",.F.,.F.,.T.)
End	 

IncProc("Atualizando os Dados.")
DbSelectArea("CurArqAtu")
MSAppend(cArqIni,cArqTemp)

CurArqAtu->(DBCLOSEAREA())

DBSELECTAREA("SX3")

Return .T.