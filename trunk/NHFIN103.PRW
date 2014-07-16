/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! NHFIN103.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Funções de Validação HSBC                               +
+------------------+---------------------------------------------------------+
!Autor             ! Edenilson Santos                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 01/10/2013                                              !
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
#include "topconn.ch"

user function fnHSBC(fnOpcao)
	local aRetorno:= {}

	if (SE2->E2_FORNECE == '999999' .and. SE2->E2_LOJA == '01')
		oldArea:= getArea()
		dbselectar('SZ5')
		SZ5->(dbsetorder(1))
		SZ5->(dbseek(xFilial('SZ5')+SE2->E2_MATR))
		if SZ5->(found())
			aadd(aRetorno,strzero(val(SZ5->Z5_BANCO),3))                                                                  //01
			aadd(aRetorno,strzero(val(alltrim(SZ5->Z5_AGENCIA)),5))                                                       //02
			aadd(aRetorno,strzero(val(substr(alltrim(SZ5->Z5_CONTA),1,len(alltrim(strtran(SZ5->Z5_CONTA,'-','')))-1)),12))//03
			aadd(aRetorno,right(alltrim(SZ5->Z5_CONTA),1))                                                                //04
			aadd(aRetorno,SZ5->Z5_NOME)                                                                                   //05
			aadd(aRetorno,'1')                                                                                            //06
			aadd(aRetorno,strzero(val(SZ5->Z5_CPF),14))                                                                   //07
			aadd(aRetorno,'RUA WIEGANDO OLSEN 1000')                                                                      //08
			aadd(aRetorno,'CIDADE INDUSTRIAL')                                                                            //09
			aadd(aRetorno,'CURITIBA')                                                                                     //10
			aadd(aRetorno,'84460070')                                                                                     //11
			aadd(aRetorno,'PR')                                                                                           //12
		
		else
			Aviso("Borderô de Pagamento | Atenção","Colaborador "+SE2->E2_MATR+" não cadastrado.", {"OK"},2)
		endif
		restarea(oldArea)
	else
		aadd(aRetorno,iif(SEA->EA_MODELO = "17","399",strzero(val(SA2->A2_BANCO),3)))                    //01
		aadd(aRetorno,strzero(val(alltrim(subst(SA2->A2_AGENCIA,1,4))),5))                               //02
		aadd(aRetorno,strzero(val(substr(alltrim(SA2->A2_NUMCON),1,len(alltrim(SA2->A2_NUMCON))-1)),12)) //03
		aadd(aRetorno,right(alltrim(SA2->A2_NUMCON),1))                                                  //04
		aadd(aRetorno,substr(SA2->A2_NOME,1,30))                                                         //05
		aadd(aRetorno,if(SA2->A2_TIPO=="F","1","2"))	                                                    //06
		aadd(aRetorno,strzero(val(SA2->A2_CGC),14))                                                      //07
		aadd(aRetorno,SA2->A2_END)                                                                       //08
		aadd(aRetorno,SA2->A2_BAIRRO)                                                                    //09
		aadd(aRetorno,SA2->A2_MUN)                                                                       //10
		aadd(aRetorno,SA2->A2_CEP)                                                                       //11
		aadd(aRetorno,SA2->A2_EST)                                                                       //12
	endif

	do case
	case fnOpcao==1
	return aRetorno[1]
	case fnOpcao==2
	return aRetorno[2]
	case fnOpcao==3
	return aRetorno[3]
	case fnOpcao==4
	return aRetorno[4]
	case fnOpcao==5
	return aRetorno[5]
	case fnOpcao==6
	return aRetorno[6]
	case fnOpcao==7
	return aRetorno[7]
	case fnOpcao==8
	return aRetorno[8]
	case fnOpcao==9
	return aRetorno[9]
	case fnOpcao==10
	return aRetorno[10]
	case fnOpcao==11
	return aRetorno[11]
	case fnOpcao==12
	return aRetorno[12]
	otherwise
	return('')
	endcase

return
