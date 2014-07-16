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
!Descricao         ! O ponto de entrada FA050INC ser� executado na valida��o da Tudo Ok na inclus�o do C. a Pagar. +
+------------------+-----------------------------------------------------------------------------------------------+
!Autor             ! Edenilson Santos                                                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Data de Criacao   ! 03/05/2013                                                                                    !
+------------------+-----------------------------------------------------------------------------------------------+
!                                                   ATUALIZACOES                                                   !
+------------------------------------------------+---------------------+---------------------+---------------------+
!Descricao detalhada da atualizacao              !Nome do solicitante  ! Analista Reponsavel !Data da Atualizacao  !
+------------------------------------------------+---------------------+---------------------+---------------------+
! Bloqueio de Inclus�o de Titulos por Usu�rio    !Emerson L. de Marchi !                     !03/05/2013           !
!                                                !                     !                     !                     !
+------------------------------------------------+---------------------+---------------------+---------------------+
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function FA050INC()
Local TudoOK:= .F.

/*Devido a auditoria foi bloqueado a inclus�o de titulos a pagar para todos os usu�rios*/

If Alltrim(Upper(cusername))$"RICARDOBA/EMERSONLM/ADRIANAG/ELISANGELAS/GUSTAVOCR/ALEXANDREVM/MARCIAMD/THIAGOSI/PAULOCB/PAMELLASB/ADAYANER/ADRIANAAF/LUCIANAMS/CAMILLABC/LUCIANAPM"
	TudoOK:= .F.
	Aviso("Inclus�o de Titulos","Caro usu�rio, voc� n�o tem permiss�o para incluir Titulos.", {"OK"},2)
Else
	TudoOK:= .T.
Endif

Return(TudoOK)