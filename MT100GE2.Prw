/*
+--------------------------------------------------------------------------------------------------------+
!                                       FICHA TECNICA DO PROGRAMA                                        !
+--------------------------------------------------------------------------------------------------------+
!                                           DADOS DO PROGRAMA                                            !
+------------------+-------------------------------------------------------------------------------------+
! Modulo           ! FIN - Financeiroo                                                                   !
+------------------+-------------------------------------------------------------------------------------+
! Nome             ! MT100GE2.PRW                                                                        !
+------------------+-------------------------------------------------------------------------------------+
! Descrição        ! Ponto de Entrada, complementa a gravação dos titulos financeiros a pagar.           +
+------------------+-------------------------------------------------------------------------------------+
! Autor            ! Alexandre Rodizio Bento                                                             !
+------------------+-------------------------------------------------------------------------------------+
! Data de Criação  ! 12/04/2004                                                                          !
+------------------+-------------------------------------------------------------------------------------+
!                                              ATUALIZAÇÕES                                              !
+-----------------------------------------------------------+----------------------+---------------------+
! Descrição detalhada da atualização        ! Solicitante   ! Analista Responsavel ! Data da Atualização !
+-------------------------------------------+---------------+----------------------+---------------------+
! Regra para Vcto Real Fund./Usi Prorrogar  !               ! Alexandre R. Bento   ! 12/04/2004          !
! Regra para Vcto Real Zaire/Troy Antecipar ! Emersonlm     ! Edenilson Santos     ! 18/11/2013          !
+-------------------------------------------+---------------+----------------------+---------------------+
*/

#include "rwmake.ch"      

user function MT100GE2()  
local _Vencrea:= SE2->E2_VENCTO
public _cNat  := SE2->E2_NATUREZ
public _cDesc := Space(30)

if alltrim(SE2->E2_NATUREZ) == "30000" .and. alltrim(SE2->E2_TIPO) =="NF" .or. empty(SE2->E2_NATUREZ) //Natureza de servico e somente o titulo da nota
   @ 200,050 to 400,585 dialog DlgItem title oemtoansi("Altera a Natureza")
   @ 005,008 to 075,260                                     
   if!empty(SE2->E2_NATUREZ)
      @ 020,020 say oemtoansi("Esta opção é para Alterar a Natureza das notas de seviços ")   size 190,8
   else 
      @ 020,020 say oemtoansi("Esta opção é para Alterar a Natureza das Notas de Entrada ")   size 190,8
   endif  

   @ 050,020 say oemtoansi("Digite a Natureza ")   size 45,8
   @ 050,070 get _cNat   picture "@!" F3 "SED" size 35,8 valid fNat() object o_cNat
   @ 050,125 get _cDesc  picture "@!" when .F. size 100,8 object o_cDesc

   @ 085,190 bmpbutton type 01 action fOK()
   @ 085,230 bmpbutton type 02 action close(DlgItem)
   Activate dialog DlgItem on init fNat()
endif

*---------------------------------------------*
*     Padrão Vencto Real Fundição/Usinagem    *
*         Quarta-Feira e Sexta-Feria          *
* Sab/Dom/Seg/Ter: Prorroga para Quarta-Feira *
* Qui            : Prorroga para Sexta-Feira  *
*---------------------------------------------*
	if dow(SE2->E2_VENCTO) == 7 // Sabado 
		_Vencrea := _Vencrea + 4
	endif                
	
	if dow(SE2->E2_VENCTO) == 1 // Domingo
		_Vencrea := _Vencrea + 3   
	endif                
		
	if dow(SE2->E2_VENCTO) == 2 // Segunda
		_Vencrea := _Vencrea + 2
	endif
		
	if dow(SE2->E2_VENCTO) == 3 // Terca
		_Vencrea := _Vencrea + 1
	endif
		
	if dow(SE2->E2_VENCTO) == 5 // Quinta
		_Vencrea := _Vencrea + 1
	endif

	reclock("SE2",.F.)
	SE2->E2_VENCREA := _Vencrea
	msunlock("SE2")

/*
*---------------------------------------------*
*        Padrão Vencto Real Zaire/Troy        *
*         Quarta-Feira e Sexta-Feria          *
* Sab/Dom/Seg/Ter: Antecipa para Sexta-Feira  *
* Qui            : Antecipa para Quarta-Feira *
*---------------------------------------------*
	if dow(SE2->E2_VENCTO) == 7 // Sabado 
		_Vencrea := _Vencrea - 1
	endif                
	
	if dow(SE2->E2_VENCTO) == 1 // Domingo
		_Vencrea := _Vencrea - 2   
	endif                
		
	if dow(SE2->E2_VENCTO) == 2 // Segunda
		_Vencrea := _Vencrea - 3 
	endif
		
	if dow(SE2->E2_VENCTO) == 3 // Terca
		_Vencrea := _Vencrea - 4
	endif
		
	if dow(SE2->E2_VENCTO) == 5 // Quinta
		_Vencrea := _Vencrea - 1
	endif

	reclock("SE2",.F.)
	SE2->E2_VENCREA := _Vencrea
	msunlock("SE2")
*/
	
return(.T.)
                              
static function fNat()
SED->(dbsetorder(1))
if SED->(dbseek(xFilial("SED")+_cNat))
   _cDesc := SED->ED_DESCRIC
   ObjectMethod(o_cDesc, "refresh()")
   return(.T.)
else          
   msgbox("Atenção esta Natureza nao Existe, Favor Redigite !!!","Atenção","STOP")
   return(.F.)
endif 

return(.T.)

static function fOK()
SE2->E2_NATUREZ := _cNat                            
close(DlgItem)
return