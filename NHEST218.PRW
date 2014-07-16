
/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Cadastro de Componentes                                 !
+------------------+---------------------------------------------------------+
!Modulo            ! EST - Estoque/Custos                                    !
+------------------+---------------------------------------------------------+
!Nome              ! NHEST218.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Composição Forjaria                                     +
+------------------+---------------------------------------------------------+
!Autor             ! Edenilson Santos                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/03/2013                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+ 
*/

#include "rwmake.ch"

User Function NHEST218()
   AxCadastro("ZFA","Composição Forjaria")
return

/*Fn:Gerador de Código*/
User Function EST218GR()
   Local ProxCod:= 0	
   ZFA->(dbsetorder(1)) //Indice:Filial+Tipo+Codigo  
   ZFA->(dbseek(xFilial("ZFA")+M->ZFA_TIPO))  
   while ZFA->( !eof() ) .and. ZFA->ZFA_TIPO == M->ZFA_TIPO  
      ProxCod:= val(ZFA->ZFA_CODIGO)	        	  	 
      ZFA->( DbSkip() )
   end
   M->ZFA_CODIGO:= strzero((ProxCod + 1),2)
return

/*Fn:Aviso Duplicidade */
User Function EST218EX()
   ZFA->(dbsetorder(1)) //Indice:Filial+Tipo+Codigo
   if ZFA->(dbseek(xFilial("ZFA")+M->ZFA_TIPO+M->ZFA_CODIGO))
      Alert("Código já existente!")
      return .f.
   endif
return .t.