/*
+---------------------------------------------------------------------------------+
!                          FICHA TECNICA DO PROGRAMA                              !
+---------------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                                !
+------------------+--------------------------------------------------------------+
!Modulo            ! Compras                                                      !
+------------------+--------------------------------------------------------------+
!Nome              ! MA120BUT.PRW                                                 !
+------------------+--------------------------------------------------------------+
!Descricao         ! Adiciona botoes no pedido de compras.                        !
+------------------+--------------------------------------------------------------+
!Autor             ! Alexandre Soares                                             !
+------------------+--------------------------------------------------------------+
!Data de Criacao   ! 02/01/2008                                                    !
+------------------+--------------------------------------------------------------+
!   ATUALIZACOES                                                                  !
+----------------------------------------------+-----------+-----------+----------+
!   Descricao detalhada da atualizacao         !Nome do    ! Analista  !Data da   !
!                                              !Solicitante! Respons.  !Atualiz.  !
+----------------------------------------------+-----------+-----------+----------+
!Inclusão Botão Alteração de Fornecedor.       !SILMARACD  !Edenilson  !12/08/2013!
!                                              !           !           !          !
+----------------------------------------------+-----------+-----------+----------+ 
*/
#include "rwmake.ch"        
#Include "prtopdef.ch"    
#include "protheus.ch"

User Function ma120but()  
Public _nRecno:= SC7->(RecNo())
aBotao        := {}  

If !inclui
    aadd( aBotao, { "S4WB014A", { || _fHist()}  , "Historico" } )
    aadd( aBotao, { ""        , { || _fAltFor()}, "Alt.Fornec." } )    
//	aadd(aBotao,{ "VENDEDOR"  ,{|| ExecBlock("COMA002",.f.,.f.,"PED")}, "Informacoes Fornecedor" } )  //Mila
Endif

Return( aBotao )

Static Function _fHist
Local oDlg6
Local oText 
Local oMsgD1
Local cMsgD1
Local lOk := .F.

                                 
	ZAE->(DbSetOrder(1))

	IF ZAE->(DbSeek(xFilial('ZAE')+CA120NUM))
		cMSGD1 := ZAE->ZAE_FLWUP
		lOk := .T.
    EndIf

	Define MsDialog oDlg6 Title "Mensagem no Pedido de Compra" From 080,042 To 270,500 Pixel 
	@ 13,14 Say "Digite neste Campo o Historico do pedido: "+ CA120NUM Object oText
       @ 025, 014 GET oMSGD1 VAR cMSGD1 MEMO SIZE 202,45 PIXEL OF oDlg6         
	@ 75,170 BMPBUTTON TYPE 01 ACTION Close(oDlg6)
    Activate MsDialog oDlg6 Centered 

	If lOk 
      	RecLock("ZAE",.F.)
			ZAE->ZAE_FLWUP  := cMsgD1
        MsUnlock("ZAE")
	Else 	
      	RecLock("ZAE",.T.)
			ZAE->ZAE_FILIAL := xFilial('ZAE')
			ZAE->ZAE_PEDIDO := CA120NUM
			ZAE->ZAE_FLWUP  := cMsgD1
        MsUnlock("ZAE")
	EndIf
Return

Static Function _fAltFor()
Private oDlgForn, cGetForn := space(06), cGetLoja := space(2), cF3 := Space(03)
Public cNomFor:= ""

If fcIteEnt(xFilial("SC7"),CA120NUM)
	Define MsDialog oDlgForn Title "Alteração de Fornecedor" From 010,030 To 105,460 Pixel
	
	@ 007,005 say "Fornecedor: " Object oForSay
	@ 007,035 get cGetForn Size 025,010 F3 "SA2" Valid fcLoja() Object oForGer
	
	@ 007,070 say "Loja: " Pixel of oDlgForn
	@ 007,085 get cGetLoja Size 015,010 Valid fcForn(cGetForn,cGetLoja) Pixel of oDlgForn
	
	@ 007,100 get cNomFor Picture "@!" When(.F.) Size 112,008 Object oNomFor
	
	@ 023,147 Button "Confirmar" Size 30,20 Pixel of oDlgForn Action fcGraFor(xFilial("SC7"),CA120NUM) // Confirma
	@ 023,182 Button "Cancelar"  Size 30,20 Pixel of oDlgForn Action Close(oDlgForn)                   // Cancela e Fecha Formulário
	
	Activate MsDialog oDlgForn Centered
Else
	Aviso("Pedido de Compra | Atenção","Pedido com itens entregues, não é possível alterar o fornecedor.", {"OK"},2)
Endif
Return

Static Function fcGraFor(vFil,vPed)  // Confirma Alteração do Fornecedor
If !Empty(cGetForn) .and. !Empty(cGetLoja)
	SC7->(DbSetOrder(1))
	If SC7->(DbSeek(vFil+vPed))         //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		While SC7->(!Eof()) .and. SC7->C7_FILIAL+SC7->C7_NUM == vFil+vPed
			Reclock("SC7",.F.)
			SC7->C7_FORNECE:= cGetForn
			SC7->C7_LOJA   := cGetLoja
			MsUnlock("SC7")
			SC7->(Dbskip())
		Enddo
		CA120FORN:= cGetForn
		CA120LOJ := cGetLoja
		MsgBox('Fornecedor alterado com sucesso!','Pedido de Compra','INFO')
		Close(oDlgForn)
	Endif
Else
	Aviso("Pedido de Compra | Atenção","Favor preencher todos os campos!", {"OK"},2)
Endif
SC7->(DbGoTo(_nRecno))
Return

Static Function fcIteEnt(vFil,vPed)
SC7->(DbSetOrder(1))
If SC7->(DbSeek(vFil+vPed))
	While SC7->(!Eof()) .and. SC7->C7_FILIAL+SC7->C7_NUM == vFil+vPed
		If SC7->C7_QUJE > 0
			Return(.F.)
		Endif
		SC7->(DbSkip())
	Enddo
Endif
SC7->(DbGoTo(_nRecno))
Return .T.

Static Function fcForn(vFor,vLoj)
If !Empty(cGetForn) .and. !Empty(cGetLoja)
	SA2->(DbSetOrder(1))               //filial + Forn + Loja
	SA2->(DbSeek(xFilial("SA2")+AllTrim(vFor)+AllTrim(vLoj)))
	If SA2->(Found())
		cNomFor := SA2->A2_NOME
		oNomFor:Refresh()
	Else
		MsgAlert("Fornecedor nao encontrado!")
		Return(.F.)
	EndIf
Endif
Return(.T.)

Static Function fcLoja()
if !Empty(cGetForn)
	cGetLoja:= SA2->A2_LOJA
Endif
Return
