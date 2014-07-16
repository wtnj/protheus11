/*
+------------------------------------------------------------------------------------------------------------------+
!                                                FICHA TECNICA DO PROGRAMA                                         !
+------------------------------------------------------------------------------------------------------------------+
!                                                   DADOS DO PROGRAMA                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Modulo            ! Ponto de Entrada FA050INC - Contas a Pagar                                                    !
!                  !                                                                                               !
+------------------+-----------------------------------------------------------------------------------------------+
!Nome              ! FA050INC.PRW                                                                                  !
+------------------+-----------------------------------------------------------------------------------------------+
!Descricao         ! O ponto de entrada FA050INC será executado na validação da Tudo Ok na inclusão do C. a Pagar. +
+------------------+-----------------------------------------------------------------------------------------------+
!Autor             ! Edenilson Santos                                                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Data de Criacao   ! 03/05/2013                                                                                    !
+------------------+-----------------------------------------------------------------------------------------------+
!                                                   ATUALIZACOES                                                   !
+------------------------------------------------+---------------------+---------------------+---------------------+
!Descricao detalhada da atualizacao              !Nome do solicitante  ! Analista Reponsavel !Data da Atualizacao  !
+------------------------------------------------+---------------------+---------------------+---------------------+
! Bloqueio de Inclusão de Titulos por Usuário    !Emerson L. de Marchi !                     !03/05/2013           !
!                                                !                     !                     !                     !
+------------------------------------------------+---------------------+---------------------+---------------------+
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function FA050INC()
Local TudoOK:= .F.

/*Devido a auditoria foi bloqueado a inclusão de titulos a pagar para todos os usuários*/

If Alltrim(Upper(cusername))$"RICARDOBA/EMERSONLM/ADRIANAG/ELISANGELAS/GUSTAVOCR/ALEXANDREVM/MARCIAMD/THIAGOSI/PAULOCB/PAMELLASB/ADAYANER/ADRIANAAF/LUCIANAMS/CAMILLABC/LUCIANAPM"
	TudoOK:= .F.
	Aviso("Inclusão de Titulos","Caro usuário, você não tem permissão para incluir Titulos.", {"OK"},2)
Else
	TudoOK:= .T.
Endif

Return(TudoOK)