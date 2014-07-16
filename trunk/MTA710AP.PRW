/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MTA710AP ³ Autor ³ Alexandre R. Bento    ³ Data ³ 06/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava rotina geradora da OP                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para a WHB                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ SB1                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

#include "rwmake.ch" 
#include "Topconn.ch"

User Function MTA710AP 

Local _cQuery := ""
Local _lRet   := .T.
Local _cTipo  :=""
Local _cGrupo :=""                                


pergunte("MTA712",.T.) //Mostra atela de parametros

// Executa a Query para limpar os produtos com B1_MRP igual a S 
_cQuery := "UPDATE "+ RetSqlName( 'SB1' ) 
_cQuery += " SET B1_MRP ='N'"
_cQuery += " WHERE B1_MRP <> 'N'"
_cQuery += " AND D_E_L_E_T_ = ' '"
TCSQLExec(_cQuery) //Executa a query	
	
If TCSQLExec(_cQuery) < 0 //Executa a query
   cErro := TCSQLERROR()
   ALERT(cErro)
Endif  
//ALERT(" B1_MRP = N ")

// Executa a Query para alterar o campo B1_MRP para S com a finalidade de agilizar a rotina de MRP
_cQuery := "UPDATE "+ RetSqlName( 'SB1' ) 
_cQuery += " SET B1_MRP ='S'"
_cQuery += " FROM " +  RetSqlName( 'SB1' )+ " B1, "  +  RetSqlName( 'SG1' )+ " G1, "  +  RetSqlName( 'SHC' )+ " HC"  
_cQuery += " WHERE B1.B1_FILIAL =  '" + xFilial("SB1")+ "'"
_cQuery += " AND HC.HC_FILIAL =  '" + xFilial("SHC")+ "'"
_cQuery += " AND G1.G1_FILIAL =  '" + xFilial("SG1")+ "'"
_cQuery += " AND HC.HC_PRODUTO = G1.G1_COD"
_cQuery += " AND B1.B1_COD = G1.G1_COMP"
_cQuery += " AND HC.HC_DATA BETWEEN '" + Dtos(mv_par05) + "' AND '" + Dtos(mv_par06) + "'"
_cQuery += " AND HC.HC_DOC BETWEEN '" + mv_par23 + "' AND '" + mv_par24 + "'"
_cQuery += " AND B1.D_E_L_E_T_ ='' "
_cQuery += " AND G1.D_E_L_E_T_ ='' "
_cQuery += " AND HC.D_E_L_E_T_ ='' "

TCSQLExec(_cQuery) //Executa a query	
	
If TCSQLExec(_cQuery) < 0 //Executa a query
   cErro := TCSQLERROR()
   ALERT(cErro)
Endif  

// Executa a Query para alterar o campo B1_MRP para S com a finalidade de agilizar a rotina de MRP
_cQuery := "UPDATE "+ RetSqlName( 'SB1' ) 
_cQuery += " SET B1_MRP ='S'"
_cQuery += " FROM " +  RetSqlName( 'SB1' )+ " B1, "  +  RetSqlName( 'SG1' )+ " G1, "  +  RetSqlName( 'SHC' )+ " HC"  
_cQuery += " WHERE B1.B1_FILIAL =  '" + xFilial("SB1")+ "'"
_cQuery += " AND HC.HC_FILIAL =  '" + xFilial("SHC")+ "'"
_cQuery += " AND G1.G1_FILIAL =  '" + xFilial("SG1")+ "'"
_cQuery += " AND HC.HC_PRODUTO = G1.G1_COD"
_cQuery += " AND B1.B1_COD = G1.G1_COD"
_cQuery += " AND HC.HC_DATA BETWEEN '" + Dtos(mv_par05) + "' AND '" + Dtos(mv_par06) + "'"
_cQuery += " AND HC.HC_DOC BETWEEN '" + mv_par23 + "' AND '" + mv_par24 + "'"
_cQuery += " AND B1.D_E_L_E_T_ ='' "
_cQuery += " AND G1.D_E_L_E_T_ ='' "
_cQuery += " AND HC.D_E_L_E_T_ ='' "

TCSQLExec(_cQuery) //Executa a query	
	
If TCSQLExec(_cQuery) < 0 //Executa a query
   cErro := TCSQLERROR()
   ALERT(cErro)
Endif  



// ALERT(" B1_MRP = S ")
// Executa a Query para pode filtrar os tipos e grupos conforme produtos do PMP (plano mestre de producao)
_cQuery := "SELECT B1.B1_TIPO,B1.B1_GRUPO"
_cQuery += " FROM " +  RetSqlName( 'SB1' )+ " B1, "  +  RetSqlName( 'SG1' )+ " G1, "  +  RetSqlName( 'SHC' )+ " HC"  
_cQuery += " WHERE B1.B1_FILIAL =  '" + xFilial("SB1")+ "'"
_cQuery += " AND HC.HC_FILIAL =  '" + xFilial("SHC")+ "'"
_cQuery += " AND G1.G1_FILIAL =  '" + xFilial("SG1")+ "'"
_cQuery += " AND HC.HC_PRODUTO = G1.G1_COD"
_cQuery += " AND B1.B1_COD = G1.G1_COMP"
_cQuery += " AND HC.HC_DATA BETWEEN '" + Dtos(mv_par05) + "' AND '" + Dtos(mv_par06) + "'"
_cQuery += " AND HC.HC_DOC BETWEEN '" + mv_par23 + "' AND '" + mv_par24 + "'"
_cQuery += " AND B1.D_E_L_E_T_ ='' "
_cQuery += " AND G1.D_E_L_E_T_ ='' "
_cQuery += " AND HC.D_E_L_E_T_ ='' "
_cQuery += " GROUP BY B1.B1_TIPO,B1.B1_GRUPO"
_cQuery += " UNION ALL"
_cQuery += " SELECT B1.B1_TIPO,B1.B1_GRUPO"
_cQuery += " FROM " +  RetSqlName( 'SB1' )+ " B1, "  +  RetSqlName( 'SG1' )+ " G1, "  +  RetSqlName( 'SHC' )+ " HC"  
_cQuery += " WHERE B1.B1_FILIAL =  '" + xFilial("SB1")+ "'"
_cQuery += " AND HC.HC_FILIAL =  '" + xFilial("SHC")+ "'"
_cQuery += " AND G1.G1_FILIAL =  '" + xFilial("SG1")+ "'"
_cQuery += " AND HC.HC_PRODUTO = G1.G1_COD"
_cQuery += " AND B1.B1_COD = G1.G1_COD"
_cQuery += " AND HC.HC_DATA BETWEEN '" + Dtos(mv_par05) + "' AND '" + Dtos(mv_par06) + "'"
_cQuery += " AND HC.HC_DOC BETWEEN '" + mv_par23 + "' AND '" + mv_par24 + "'"
_cQuery += " AND B1.D_E_L_E_T_ ='' "
_cQuery += " AND G1.D_E_L_E_T_ ='' "
_cQuery += " AND HC.D_E_L_E_T_ ='' "
_cQuery += " GROUP BY B1.B1_TIPO,B1.B1_GRUPO"

  TCQUERY _cQuery NEW ALIAS "TEMP"     
 
// ALERT("FINALLLLL")
 
_cTipo:=""
_cGrupo:=""                                
TEMP->(DbGoTop())
While TEMP->(!Eof())

   If !TEMP->B1_TIPO$"MO" //Descarta a mao de obra
	   If !TEMP->B1_TIPO$_cTipo 
	      _cTipo  += TEMP->B1_TIPO+"/"
	   Endif
	
	   If !TEMP->B1_TIPO$_cGrupo 
	      _cGrupo += TEMP->B1_GRUPO+"/"      
	   Endif
   Endif
    	
   TEMP->(Dbskip())
Enddo
                
//ALERT(_cTipo)
//ALERT(_cGrupo)

For _nx:= 1 to len(a711Tipo)
      
      If !Subs(a711Tipo[_nx][2],1,2)$_cTipo
         a711Tipo[_nx][1] := .F.   
      Endif
Next

For _nx:= 1 to len(a711Grupo)
      
      If !Subs(a711Grupo[_nx][2],1,4)$_cGrupo 
         a711Grupo[_nx][1] := .F.   
      Endif
Next

TEMP->(DbCloseArea())

Return (_lRet)
//Se .T., o produto sera considerado no calculo do MRP.
//Se .F., o produto NAO sera considerado no calculo do MRP.
  