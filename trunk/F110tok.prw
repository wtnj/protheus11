/*
+------------------------------------------------------------------------------------------------------------------+
!                                                FICHA TECNICA DO PROGRAMA                                         !
+------------------------------------------------------------------------------------------------------------------+
!                                                   DADOS DO PROGRAMA                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Modulo            ! Ponto de Entrada F110TOK - Valida��o baixas a pagar manual                                   !
!                  !                                                                                               !
+------------------+-----------------------------------------------------------------------------------------------+
!Nome              ! F110TOK.PRW                                                                                  !
+------------------+-----------------------------------------------------------------------------------------------+
!Descricao         ! O ponto de entrada F110TOK sera ativado pelo botao OK para validacao dos dados da baixa       +
!                  ! automatica. Este ponto de entrada recebe como parametro um array contendo 'Banco De' e 'Banco +
!					    ! At� para sele��o de titulos que atendam o intervalo de portadores. Este ponto de entrada deve +
!                  ! ter retorno l�gico.                                                                           +
+------------------+-----------------------------------------------------------------------------------------------+
!Autor             ! Edenilson Santos                                                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Data de Criacao   ! 20/12/2013                                                                                    !
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

User Function F110tok()

If !Alltrim(Upper(cusername))$"RICARDOBA/EMERSONLM/ADRIANAG/GUSTAVOCR/ALEXANDREVM/PAULOCB/PAMELLASB/ADAYANER/LUCIANAMS/ADRIANAAF/THIAGOSI/CAMILLABC/LUCIANAPM"
	TudoOK:= .F.
	Aviso("Baixa de Titulos","Caro usu�rio, voc� n�o tem permiss�o para baixar Titulos.", {"OK"},2)
Else
	TudoOK:= .T.
Endif

Return(TudoOK)