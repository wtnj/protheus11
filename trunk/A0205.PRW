/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualizacao                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Compras                                              !
+------------------+---------------------------------------------------------+
!Nome              ! A0205                                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! GATILHO                                                 !
!                  ! Posiciona no cadastro do PRODUTO para pegar o campo     !
!                  ! GRUPO e retornar a CONTA ORCAMENTARIA (BM_CTAORC)       !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO SERGIO SALVADOR                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 12/05/2014                                              !
+------------------+---------------------------------------------------------+

Esa funcao é chamada nos seguintes gatilhos:
C1_PRODUTO-006
C7_PRODUTO-001
C8_PRODUTO-001
D1_COD-008

*/

#include "rwmake.ch"

User Function A0205()
                            
Local _cCampo := Upper(Alltrim(Substr(ReadVar(),4)))
Local _nCod   := aScan(aHeader,{|x|UPPER(Alltrim(x[2]))==_cCampo})
Local _cGrupo := ''
Local _cCtaOrc:= ''

If !Acols[n][len(aHeader)+1]  //so executa se a linha digitada estiver ativa
	If SB1->(Dbseek(xFilial("SB1")+Acols[n][_nCod],.F.))
		_cGrupo := SB1->B1_GRUPO
		If SBM->(Dbseek(xFilial("SBM")+_cGrupo,.F.))
			_cCtaOrc:= SBM->BM_CTAORC
		Endif
	Endif
Endif

Return(_cCtaOrc)