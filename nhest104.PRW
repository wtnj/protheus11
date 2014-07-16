/*                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST104       ³ Fabio William Nico     ³ Data ³ 19/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza SB1 conforme entradas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaEst                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NHEST104()    

If !Pergunte('EST104',.T.)
   Return(nil)
Endif                        

Processa({|| Gerando()  },"Gerando Dados ")
Processa({|| Atualizando()  },"Atualizando dados")


Return(nil)
           

//-----------------------------------------------------------------------------------------------------
// GERANDO DADOS ARQUIVO TMP
//-----------------------------------------------------------------------------------------------------
Static Function Gerando()  
	cQuery := "SELECT B1_COD "
	cQuery += "FROM " + RetSqlName('SB1') +" B1 "                                                                     
	cQuery += "WHERE B1_GRUPO IN ('FE01','FE02','FE03','FE04','FE05','FE06') AND B1_UPRC = 0 "
	cQuery += "AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' " 
	MemoWrit('C:\TEMP\EST104.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRB"
Return

Static Function Atualizando()  

DbSelectArea("TRB")
DbGoTop()

While TRB->(!Eof()) 
	cQuery1 := " SELECT TOP 1 D1_COD,D1_VUNIT "
	cQuery1 += " FROM " + RetSqlName('SD1') +" D1 "    
	cQuery1 += " WHERE D1_DTDIGIT BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "'
	cQuery1 += " AND D1_COD = '" + ALLTRIM(TRB->B1_COD) + "'"
	cQuery1 += " ORDER BY D1_VUNIT DESC "

	TCQUERY cQuery1 NEW ALIAS "TRC"	

	DbSelectArea("TRC")
	DbGoTop()
	if TRC->D1_VUNIT > 0
		cQuery2 := "UPDATE SB1NH0 SET B1_UPRC = '" + STRZERO(TRC->D1_VUNIT,9,2) + "' WHERE B1_COD = '" + ALLTRIM(TRC->D1_COD) + "' AND B1_UPRC = 0 "
	   //	MemoWrit('C:\TEMP\EST1042.SQL',cQuery2)
	    TCSQLEXEC(cQuery2)
	Endif  
    DbCloseArea("TRC")
	
	DbSelectArea("TRB")
	TRB->(Dbskip())
	
Enddo

DbCloseArea("TRB")

Return(.T.)

