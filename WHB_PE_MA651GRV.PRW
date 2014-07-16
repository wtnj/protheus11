/*---------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Ponto de Entrada                                        !
+------------------+---------------------------------------------------------+
!Módulo            ! SIGAPCP                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! WHB_PE_MA651GRV                                         !
+------------------+---------------------------------------------------------+
!Descrição         ! PE em Firmar Ops, MATA651                               !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 23/08/2010                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACÕES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descrição detalhada da atualização      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+-------*/
#Include "Protheus.ch"
#Include "rwmake.ch"

user Function ma651grv()

//Primeiro bck das areas abertas em uso
Local aBckSB1 := getArea("SB1")
Local aBckSB2 := getArea("SB2")
Local aBckSC1 := getArea("SC1")
Local aBckSC7 := getArea("SC7")
Local aBckSD4 := getArea("SD4")

//Não é certeza que o B1 esteja posicionado (tem uma condição para isso)
//Então posicionamos novamente

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

//Vai que não tem o produto, então verifico
If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

	//Esta tela só pode aparecer se o B1_TIPO for igual a PA
	If ( SB1->B1_TIPO == "PA" )
		//chamo rotina para mostrar tela para confirmação de horario
		//e para gravar na C2
		u_pWhbm004()

	Endif
Endif

//Aki voltamos como esta antes
restArea(aBckSB1)
restArea(aBckSB2)
restArea(aBckSC1)
restArea(aBckSC7)
restArea(aBckSD4)

Return                                                         	