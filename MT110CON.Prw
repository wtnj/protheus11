/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT110CON        ³ Alexandre R. Bento    ³ Data ³ 20/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de Entrada p/ Validar a alteração e exclusao da SC  ³±±
±±³          ³ Somente pelo usuario que inclui a mesma                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


#include "rwmake.ch"   

User Function MT110CON()

Local lRet    := .T.
Local _lValSC := GETMV("MV_VALSC") //Valida esta SC .T. = Valida ou .F. = Falso


If _lValSC //valida solicitação 
	If !Inclui
         SC1->(dbSetOrder(1))		
         SC1->(DbSeek(xFilial("SC1")+CA110NUM))
         If SC1->(Found()) 
   	        If altera
	           If Upper(Alltrim(cUsername)) <> Upper(Alltrim(SC1->C1_SOLICIT)) .and. Upper(Alltrim(cUsername)) <> 'ADMIN'
	              MsgBox( "Alteração somente é permitida pelo usuario "+ alltrim(SC1->C1_SOLICIT) + " que fez a mesma", "Atenção", "STOP" )      
	              lRet := .F.
	           Endif
	        ElseIf Upper(Alltrim(cUsername)) <> Upper(Alltrim(SC1->C1_SOLICIT)) .and. Upper(Alltrim(cUsername)) <> 'ADMIN'
	           MsgBox( "Exclusão somente é permitida pelo usuario "+ alltrim(SC1->C1_SOLICIT) + " que fez a mesma", "Atenção", "STOP" )      
	           lRet := .F.
	        Endif   
	     Endif    
	Endif                       
Endif

/*
If !Inclui 
	SZU->(DbSetOrder(2))
	SZU->(DbSeek(xFilial("SZU") + SC1->C1_NUM))
	While !SZU->(Eof())	.AND. SZU->ZU_NUM == SC1->C1_NUM
		If SZU->ZU_STATUS=="A" .OR. SZU->ZU_STATUS=="C"
			lRet := .F.
	        If altera
	            MsgBox( "Existe Aprovacao eletronica em adamento, Alteracão nao autorizada", "Atenção", "STOP")
			Else
	            MsgBox( "Existe Aprovacao eletronica em adamento, Exclusão nao autorizada", "Atenção", "STOP")
			Endif	            
			Exit
		Endif	
		SZU->(DbSkip())	
	Enddo	
Endif	
*/

RETURN(lRet)
