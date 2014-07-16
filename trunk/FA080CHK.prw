/*
+------------------------------------------------------------------------------------------------------------------+
!                                                FICHA TECNICA DO PROGRAMA                                         !
+------------------------------------------------------------------------------------------------------------------+
!                                                   DADOS DO PROGRAMA                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Modulo            ! Ponto de Entrada FA080CHK - Validação baixas a pagar manual                                   !
!                  !                                                                                               !
+------------------+-----------------------------------------------------------------------------------------------+
!Nome              ! FA080CHK.PRW                                                                                  !
+------------------+-----------------------------------------------------------------------------------------------+
!Descricao         ! O ponto de entrada FA080CHK e acionado antes de carregar a tela de baixa do contas a pagar    +
+------------------+-----------------------------------------------------------------------------------------------+
!Autor             ! Edenilson Santos                                                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Data de Criacao   ! 18/12/2013                                                                                    !
+------------------+-----------------------------------------------------------------------------------------------+
!                                                   ATUALIZACOES                                                   !
+------------------------------------------------+---------------------+---------------------+---------------------+
!Descricao detalhada da atualizacao              !Nome do solicitante  ! Analista Reponsavel !Data da Atualizacao  !
+------------------------------------------------+---------------------+---------------------+---------------------+
!                                                !                     !                     !                     !
+------------------------------------------------+---------------------+---------------------+---------------------+
*/

#include "rwmake.ch"
#include "protheus.ch"

User Function FA080CHK()

If !Alltrim(Upper(cusername))$"RICARDOBA/EMERSONLM/ADRIANAG/GUSTAVOCR/ALEXANDREVM/PAULOCB/PAMELLASB/ADAYANER/LUCIANAMS/TADEUM/PATRICIASA/CARLOSEC/MAUROCS/CAMILLABC/LUCIANAPM"
	TudoOK:= .F.
	Aviso("Baixa de Titulos","Caro usuário, você não tem permissão para baixar Titulos.", {"OK"},2)
Else
	TudoOK:= .T.
Endif

Return(TudoOK)