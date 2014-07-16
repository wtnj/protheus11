/*
+----------------------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                            !
+----------------------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                                          !
+------------------+---------------------------------------------------------------------------+
!Modulo            ! END - Endividamento                                                       !
+------------------+---------------------------------------------------------------------------+
!Nome              ! NHEND004.PRW                                                              !
+------------------+---------------------------------------------------------------------------+
!Descricao         ! Cadastro de Feriados Bancários                                            +
+------------------+---------------------------------------------------------------------------+
!Autor             ! Edenilson Santos                                                          !
+------------------+---------------------------------------------------------------------------+
!Data de Criacao   ! 13/03/2014                                                                !
+------------------+---------------------------------------------------------------------------+
!   ATUALIZACOES                                                                               !
+-----------------------------------------------------+-------------+-------------+------------+
!   Descricao detalhada da atualizacao                !Nome do      ! Analista    !Data da     !
!                                                     !Solicitante  ! Responsavel !Atualização !
+-----------------------------------------------------+-------------+-------------+------------+
! Cadastro de feriados bancários no brasil até 2078.  !             !             !            !
! Base de dados importada via arquivo xls extraida do !             !             !            !
! site abaixo conforme orientações alexandrevm        !             !             !            !
! http://www.anbima.com.br/feriados/feriados.asp      ! Alexandrevm ! Edenilson   ! 13/03/2014 !
+-----------------------------------------------------+-------------+-------------+------------+
*/

#include "rwmake.ch"

User Function NHEND004()
Local aRotAdic:= {}
Local bPre    := {||MsgAlert('Chamada antes da função')}
Local bOK     := {||MsgAlert('Chamada ao clicar em OK'), .T.}
Local bTTS    := {||MsgAlert('Chamada durante transacao')}
Local bNoTTS  := {||MsgAlert('Chamada após transacao')}
Local aButtons:= {} //adiciona botões na tela de inclusão, alteração, visualização e exclusao
/*
aadd(aButtons,{ "PRODUTO"  , {|| MsgAlert("Teste")}, "Teste", "Botão Teste" })//adiciona chamada no aRotina
aadd(aRotAdic,{ "Adicional","U_Adic"               , 0      , 6             })
AxCadastro("ZG4", "Cadastro de Feriados", "U_DelOk()", "U_INCALT()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )
*/

AxCadastro("ZG4", "Cadastro de Feriados Bancários", "U_DEL004()", "U_INC004()", , , , , , , , , , )
Return( .T. )

User Function DEL004()
If !Alltrim(Upper(cusername))$"ALEXANDREVM/EDENILSONAS"
	TudoOK:= .F.
	Aviso("Exclusão de Feriado","Caro usuário, você não tem permissão para excluir Feriado.", {"OK"},2)
Else
	TudoOK:= .T.
Endif

Return( TudoOk )

User Function INC004()
if inclui
	TudoOK:= .T.
Else
	If !Alltrim(Upper(cusername))$"ALEXANDREVM/EDENILSONAS"
		TudoOK:= .F.
		Aviso("Alteração de Feriado","Caro usuário, você não tem permissão para alterar feriado.", {"OK"},2)
	Else
		TudoOK:= .T.
	Endif
Endif
return( TudoOK )

/*
User Function Adic()
MsgAlert("Rotina adicional")
Return
*/
