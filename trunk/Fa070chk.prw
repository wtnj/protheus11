/*
+------------------------------------------------------------------------------------------------------------------+
!                                                FICHA TECNICA DO PROGRAMA                                         !
+------------------------------------------------------------------------------------------------------------------+
!                                                   DADOS DO PROGRAMA                                              !
+------------------+-----------------------------------------------------------------------------------------------+
!Modulo            ! Ponto de Entrada FA070CHK - Contas a Receber                                                  !
!                  !                                                                                               !
+------------------+-----------------------------------------------------------------------------------------------+
!Nome              ! FA070CHK.PRW                                                                                  !
+------------------+-----------------------------------------------------------------------------------------------+
!Descricao         ! Ponto de entrada antes da apresentacao do titulo.                                             +
+------------------+-----------------------------------------------------------------------------------------------+
!Autor             ! Marcos R. Roquitski                                                                           !
+------------------+-----------------------------------------------------------------------------------------------+
!Data de Criacao   ! 16/09/2009                                                                                    !
+------------------+-----------------------------------------------------------------------------------------------+
!                                                   ATUALIZACOES                                                   !
+------------------------------------------------+---------------------+---------------------+---------------------+
!Descricao detalhada da atualizacao              !Nome do solicitante  ! Analista Reponsavel !Data da Atualizacao  !
+------------------------------------------------+---------------------+---------------------+---------------------+
! Liberar baixa de titulos por usu�rio conforme  !Emerson L. de Marchi ! Edenilson           !18/02/2013           !
! rela��o abaixo.                                !                     !                     !                     !  
!                                                !                     !                     !                     !
+------------------------------------------------+---------------------+---------------------+---------------------+
*/

#include "rwmake.ch"

User Function FA070CHK()
Local nSalvRec := Recno()
Local _cTipos  := Alltrim(GETMV("MV_TIPOS"))

// Cliente nao reteve impostos, baixar os imposto.

If !MsgBox(" (*) Cliente efetuou Retencao dos Impostos?","Retencao de Impostos","YESNO")
	RecLock("SE1",.F.)
	SE1->E1_RETIMP := '1'
	SE1->E1_COFINS := 0
	SE1->E1_PIS    := 0
	SE1->E1_CSLL   := 0
	SE1->E1_INSS   := 0
	SE1->E1_IRRF   := 0
	SE1->E1_ISS    := 0
	MsUnlock("SE1")

	nSalvRec:=Recno()

	//������������������������������������������������������������������Ŀ
	//�Verifica se h� abatimentos para voltar a carteira                 �
	//��������������������������������������������������������������������
	SE1->(DbSetOrder(2))
		
	If DbSeek(xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)

		cTitAnt := (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
		While !Eof() .and. cTitAnt == (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			If Alltrim(SE1->E1_TIPO) $ _cTipos
				RecLock("SE1",.F.)				
				SE1->E1_BAIXA   := dDataBase
				SE1->E1_SALDO   := 0
				SE1->E1_RETIMP  := '1' // Nao reteve imposto
				MsUnlock("SE1")				
			Endif	
			SE1->(dbSkip())
		EndDo
	Endif

	DbSetOrder(1)
	dbGoTo( nSalvRec )

	If !Alltrim(Upper(cusername))$"RICARDOBA/EMERSONLM/ADRIANAG/GUSTAVOCR/ALEXANDREVM/PAULOCB/PAMELLASB/ADAYANER/LUCIANAMS/ADRIANAAF/THIAGOSI/CAMILLABC/LUCIANAPM"
		Aviso("Baixa de Titulos","Caro usu�rio, voc� n�o tem permiss�o para baixar Titulos.", {"OK"},2)
		Return( .F. )
	Else
		Return( .T. )
	Endif
Else	
	If !Alltrim(Upper(cusername))$"RICARDOBA/EMERSONLM/ADRIANAG/GUSTAVOCR/ALEXANDREVM/PAULOCB/PAMELLASB/ADAYANER/LUCIANAMS/ADRIANAAF/THIAGOSI/CAMILLABC/LUCIANAPM"
		Aviso("Baixa de Titulos","Caro usu�rio, voc� n�o tem permiss�o para baixar Titulos.", {"OK"},2)
		Return( .F. )
	Else
		Return( .T. )
	Endif
Endif