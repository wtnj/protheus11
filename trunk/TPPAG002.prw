/*
+-------------------------------------------------------------------------------------------------+
| Programa  : TPPAG002                     | Autor : Handerson Lemos Duarte     | Data: 17.12.08  |
+-------------------------------------------------------------------------------------------------+
| Descrição :Calcula os campos ZC3_TOTEMB e ZC3_TOTPC 											  |
+-------------------------------------------------------------------------------------------------+
+-------------------------------------------------------------------------------------------------+
| Uso       : WHB                                                                                 |
+-------------------------------------------------------------------------------------------------+
| Revisao   :                                                                                     |
+-------------------------------------------------------------------------------------------------+
*/ 
//U_TPPAG002("ZC3_TOTEMB") 
//U_TPPAG002("ZC3_TOTPC")
#Include "RwMake.ch"
User Function TPPAG002(cCampo)
Local  aArea 	:= GetArea()
Local  nRet		:=0 
Do Case
	Case cCampo=="ZC3_TOTEMB"
   		nRet:=M->ZC3_UCPRE+M->ZC3_UMPRE+M->ZC3_PRREV //ZC3_TOTEMB
   		M->ZC3_TOTPC:=IIF((M->ZC3_UCNPC+M->ZC3_UMNPC+M->ZC3_QTDREV)==0,0,M->ZC3_TOTEMB/((M->ZC3_UCNPC+M->ZC3_UMNPC+M->ZC3_QTDREV)/3))//ZC3_TOTPC
	Case cCampo=="ZC3_TOTPC"	
		nRet:=IIF((M->ZC3_UCNPC+M->ZC3_UMNPC+M->ZC3_QTDREV)==0,0,M->ZC3_TOTEMB/((M->ZC3_UCNPC+M->ZC3_UMNPC+M->ZC3_QTDREV)/3))//ZC3_TOTPC
EndCase		
RestArea(aArea)
Return(nRet) 
