/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN - Financeiro                                        !
+------------------+---------------------------------------------------------+
!Nome              ! NHFIN019.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Cadastro de Colaboradores                               +
+------------------+---------------------------------------------------------+
!Autor             ! Jose Roberto Gorski                                     !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 16/05/2000                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
! Alterada a função AxCadastro Padrão para  !           !           !        !
! implementação de bloqueio individual para !           !           !        !
! Inclusão/Alteração                        ! Gustavocr ! Edenilson !20/11/13!
+-------------------------------------------+-----------+-----------+--------+
*/

#include "rwmake.ch"       

User Function nhfin019()
Local aRotAdic:= {}
Local bPre    := {||MsgAlert('Chamada antes da função')}
Local bOK     := {||MsgAlert('Chamada ao clicar em OK'), .T.}
Local bTTS    := {||MsgAlert('Chamada durante transacao')}
Local bNoTTS  := {||MsgAlert('Chamada após transacao')}
Local aButtons:= {} //adiciona botões na tela de inclusão, alteração, visualização e exclusao
/*
aadd(aButtons,{ "PRODUTO"  , {|| MsgAlert("Teste")}, "Teste", "Botão Teste" })//adiciona chamada no aRotina
aadd(aRotAdic,{ "Adicional","U_Adic"               , 0      , 6             })
AxCadastro("SZ5", "Cadastro de Colaboradoress", "U_DelOk()", "U_INCALT()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )
*/

AxCadastro("SZ5", "Cadastro de Colaboradoress", "U_DELCOL()", "U_INCALT()", , , , , , , , , , )
Return( .T. )

User Function DELCOL()
If !Alltrim(Upper(cusername))$"GUSTAVOCR"
	TudoOK:= .F.
	Aviso("Exclusão de Colaboradores","Caro usuário, você não tem permissão para excluir colaboradores.", {"OK"},2)
Else
	TudoOK:= .T.
Endif

Return( TudoOk )

User Function INCALT()
if inclui
	TudoOK:= .T.
Else 
If !Alltrim(Upper(cusername))$"GUSTAVOCR"
	TudoOK:= .F.
	Aviso("Alteração de Colaboradores","Caro usuário, você não tem permissão para alterar colaboradores.", {"OK"},2)
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