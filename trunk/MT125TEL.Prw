/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT125TEL        ³ Alexandre R. Bento    ³ Data ³ 04/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/ incluir campos no cabecalho do contrato³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*

#include "rwmake.ch"        
#include "protheus.ch"

User Function MT125TEL()            
Local oNewDialog    := PARAMIXB[1]
Local aPosGet       := PARAMIXB[2]
Local aObj          := PARAMIXB[3]
Local nOpcx         := PARAMIXB[4]
Public _dDtVal     := CtoD("  /  /  ")
Public _dDtRev     := CtoD("  /  /  ")
Public _cNumRev    := space(02)
Public _cEntrega   := space(100)
Public _cTransp    := Space(06) 

@ 044,aPosGet[1,3] SAY "Transportadora" OF oNewDialog PIXEL SIZE 060,006     
@ 043,aPosGet[1,4] MSGET _cTransp PICTURE PesqPict("SC3","C3_TRANSP")  F3 CpoRetF3('C3_TRANSP','SA4') OF oNewDialog PIXEL SIZE 040,006

//@ 044,aPosGet[1,5] SAY "Validade" OF oNewDialog PIXEL SIZE 040,006     
//043,aPosGet[1,6] MSGET _dDtVal PICTURE PesqPict("SC3","C3_DATAVAL")  OF oNewDialog PIXEL SIZE 040,006
@ 044,aPosGet[1,5] SAY OemToAnsi("Data Revisão") OF oNewDialog PIXEL SIZE 060,006     
@ 043,aPosGet[1,6] MSGET _dDtRev WHEN(.F.) PICTURE PesqPict("SC3","C3_DATAREV")  OF oNewDialog PIXEL SIZE 040,006
@ 043,aPosGet[1,7] MSGET _cNumRev WHEN(.F.) PICTURE PesqPict("SC3","C3_NUMREV")  OF oNewDialog PIXEL SIZE 020,006
//@ 056,aPosGet[3,1] SAY "Cond Entrega" OF oNewDialog PIXEL SIZE 060,006     
//@ 055,aPosGet[3,2] MSGET _cEntrega PICTURE PesqPict("SC3","C3_ENTREGA")  OF oNewDialog PIXEL SIZE 100,006
//@ 005,003 TO 056,aPosGet[2,8] SAY "Cond Entrega" OF oNewDialog PIXEL SIZE 060,006     
//@ 005,023 TO 055,aPosGet[2,9] MSGET _cEntrega PICTURE PesqPict("SC3","C3_ENTREGA")  OF oNewDialog PIXEL SIZE 100,006

SC3->(DBSEEK(XFILIAL('SC3')+CA125NUM))

_dDtRev  := SC3->C3_DATAREV
_cNumRev := SC3->C3_NUMREV   

Return(.T.) 

*/