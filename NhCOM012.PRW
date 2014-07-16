/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM012  ºAutor  ³Fabio Nico          º Data ³  03/18/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verificacao de duplicidade de CGC no cadastro de Fornecedor º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NHCOM012()

Local _cod, _loja

_cod := space(6)
_loja := 0

DbSelectArea("SA2")


cQuery := "SELECT SA2.A2_COD,SA2.A2_LOJA,SA2.A2_CGC "
cQuery += "FROM " + RetSqlName('SA2') + " SA2 "
cQuery += "WHERE SA2.A2_CGC LIKE '"+ SUBSTR(M->A2_CGC,0,8)+"%'"
cQuery += "AND SA2.A2_CGC <> ' ' "
cQuery += "AND SA2.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY 2 DESC"  
	
MemoWrit('C:\TEMP\NHCOM012.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP"                      
DbSelectArea("TMP")
DbGotop("TMP")

if alltrim(TMP->A2_COD) <> '' 
        M->A2_COD = TMP->A2_COD
		M->A2_LOJA =strzero(VAL(TMP->A2_LOJA)+1,2)
   else
     	M->A2_LOJA <> '01'
   		MSGBOX("FORNECEDOR INEXISTENTE PARA LOJA 01 - VERIFIQUE")
   		M->A2_LOJA := '01'
endif


DbCloseArea("TMP")

Return(.T.)   
