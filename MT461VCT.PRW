/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! MT461VCT.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de Entrada, Antes de gravar a N.F verifica se     +
!                  ! existe vencimento menor que a data do sistema.          +
+------------------+---------------------------------------------------------+
!Autor             ! Edenilson Santos                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 14/06/2013                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+*/

#include "rwmake.ch"

User Function MT461VCT()

Local _Dp      := 1
Local _aVencto := ParamIxb[1]

If SM0->M0_CODIGO == "IT"

	If Len(_aVencto[1]) > 0
		
		For _Dp := 1 To Len(_aVencto)
			
			If  Dow(_aVencto[_Dp][1]) == 1 // Domingo
				
				If SA1->A1_COD $ '900086/900083/900131/900072/900078/900077/900073/900080'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 3
				ElseIf SA1->A1_COD $ '900286'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) - 3
				ElseIf SA1->A1_COD $ '900044'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 4
				Endif
				
			Endif
			
			If Dow(_aVencto[_Dp][1]) == 2 // Segunda
				
				If SA1->A1_COD $ '900086/900083/900131/900072/900078/900077/900073/900080'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 2
				ElseIf SA1->A1_COD $ '900286'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 2
				ElseIf SA1->A1_COD $ '900044'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 3
				Endif
				
			Endif
			
			If Dow(_aVencto[_Dp][1]) == 3 // Terca
				
				If SA1->A1_COD $ '900086/900083/900131/900072/900078/900077/900073/900080'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 1
				ElseIf SA1->A1_COD $ '900286'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 2
				ElseIf SA1->A1_COD $ '900044'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 2
				Endif
				
			Endif
			
			If Dow(_aVencto[_Dp][1]) == 4 // Quarta
				
				If SA1->A1_COD $ '900086/900083/900131/900072/900078/900077/900073/900080'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1])
				ElseIf SA1->A1_COD $ '900286'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 1
				ElseIf SA1->A1_COD $ '900044'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 1
				Endif
				
			Endif
			
			If Dow(_aVencto[_Dp][1]) == 5 // Quinta
				
				If SA1->A1_COD $ '900086/900083/900131/900072/900078/900077/900073/900080'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) - 1
				ElseIf SA1->A1_COD $ '900286'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1])
				ElseIf SA1->A1_COD $ '900044'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1])
				Endif
				
			Endif
			
			If Dow(_aVencto[_Dp][1]) == 6 // Sexta
				
				If SA1->A1_COD $ '900086/900083/900131/900072/900078/900077/900073/900080'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) - 2
				ElseIf SA1->A1_COD $ '900286'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) - 1
				ElseIf SA1->A1_COD $ '900044'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 6
				Endif
				
			Endif
			
			If Dow(_aVencto[_Dp][1]) == 7 // Sabado
				
				If SA1->A1_COD $ '900086/900083/900131/900072/900078/900077/900073/900080'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) - 3
				ElseIf SA1->A1_COD $ '900286'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) - 2
				ElseIf SA1->A1_COD $ '900044'
					_aVencto[_Dp][1] := (_aVencto[_Dp][1]) + 5
				Endif
				
			Endif
			
		Next
		
	Endif

Endif

Return _aVencto

/*  
Ponto-de-Entrada: MT461VCT - Alteração no vencimento e valor do título 
Abrangências: Microsiga Protheus 10  
Versões: Microsiga Protheus 10  
Compatível Países: Brasil  
Sistemas Operacionais: Todos  
Compatível às Bases de Dados: Todos  
Idiomas: Português (Brasil)  
Descrição: 
O ponto de entrada MT461VCT permite alterar o valor e o vencimento do título gerado no momento de geração da nota fiscal.Programa Fonte 
MATA461.PRXSintaxe 
MT461VCT - Alteração no vencimento e valor do título ( [ aVencto ], [ aTitulo ] ) --> aVencto

Parâmetros: 
 Nome   Tipo   Descrição   Default   Obrigatório   Referência  
 aVencto   Array of Record   array contendo data de vencimento e valor de cada parcela.Vide Observação           
 aTitulo   Array of Record   array contendo valores dos títulos que serão gravados. Vide Observação           

Retorno 
aVencto(array_of_record) 

array contendo os novos vencimentos, deverá enviar data de vencimento e valor de cada parcela.
Observações 
*/