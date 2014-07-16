/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQAD001  ºAutor  ³ Fabio Nico         º Data ³  18/01/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Composicao do codigo da Auditoria                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³WHB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch" 
#INCLUDE "topconn.ch"   

User Function Nhqad001()

SetPrvt("_Sigla,_Ano,_Sequen,_cCodProd,_cAlias")
	
_Sigla    := Space(01)
_Ano      := Space(02)
_Sequen   := Space(02)
_cAlias   := Alias()
_cCodProd := ''
                    
//If _cAlias == "TES"
//   TES->(DbCloseArea())
//Endif

if M->QUA_TIPAUD == '1'
      M->QUA_NUMAUD := 'S'
   elseif M->QUA_TIPAUD == '2'
      M->QUA_NUMAUD := 'P'
   elseif M->QUA_TIPAUD == '3'
      M->QUA_NUMAUD := 'F'
   elseif M->QUA_TIPAUD == '4'
      M->QUA_NUMAUD := 'O'
endif 

fGeraSeq2()
                      
_Ano := Alltrim(Substr(dtoc(date()),9,2))
_cCodProd := M->QUA_NUMAUD + _Sequen + "/" + _Ano
M->QUA_NUMAUD := _cCodProd
         
Return

Static Function fGeraSeq2()
	cQuery := "SELECT TOP 1 * FROM " +  RetSqlName( 'QUA' ) + " QUA "
 	cQuery += " WHERE QUA.QUA_NUMAUD LIKE '%"+M->QUA_NUMAUD+ "%' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY SUBSTRING(QUA.QUA_NUMAUD,2,2) DESC"       
	TCQUERY cQuery NEW ALIAS "TES"

TES->(Dbgotop())

_Sequen = STRZERO(VAL(Substr(TES->QUA_NUMAUD,2,2))+1,2)   
TES->(DbCloseArea())
DbSelectArea("QUA")

Return
