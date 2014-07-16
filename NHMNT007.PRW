/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³NHMNT007  ºAutor  ³Fabio Nico          º Data ³  29/04/06   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gatilho para evitar inclusao de 2OS para o mesmo produto   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

     
#include "rwmake.ch"              
                                               
User Function NHMNT007()     

Local nTJRec := STJ->(Recno()) //-- Guarda o Recno da tabela STJ
Local _lRet := .T.                

If M->TJ_MAQSIT == 'D'
   Return .T.
endif

dbSelectArea("STJ")    
dbSetOrder(12)
dbSeek(xFilial("STJ")+"B"+M->TJ_CODBEM)

If STJ->(Found())
	While STJ->TJ_CODBEM == M->TJ_CODBEM
	  	If STJ->TJ_MAQSIT == M->TJ_MAQSIT .and. STJ->TJ_TERMINO == 'N' .and. STJ->TJ_SITUACA != 'C'
         	Msgbox("Já Existe OS para este BEM ","Atencao","ALERT")
        	Return .F.
      	Endif
      	dbskip()
    Enddo
Endif

IF M->TJ_SERVICO <> '000000'
	Msgbox("Estado permitido apenas para O.S. Corretiva.","Atencao","ALERT")
    Return .F.
ENDIF

STJ->(dbGoTo(nTJRec)) //-- Retorna o recno da tabela STJ

Return .T.
