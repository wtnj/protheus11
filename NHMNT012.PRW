#include 'fivewin.ch'
#include 'topconn.ch'
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT012  ºAutor ³João Felipe da Rosa º Data ³  21/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE CUSTOS DE CAUSAS E SOLUCOES                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT012()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols     := {}                  
cString   := "SZW"
cDesc1    := OemToAnsi("Este relatório tem por objetivo fornecer o total de custos com determinadas")
cDesc2    := OemToAnsi("causas ou soluções das O.S da Manutenção")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT012"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO CUSTOS COM CAUSAS OU SOLUCOES DAS OS'S")                
cabec1    := OemToAnsi(" Causa                                                 Horas            Custo Total")    
cabec2    := " "
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHMNT012"
_cPerg    := "MNT012" 

//_nTotal   := 0  
//_nTotcol01 := 0  
//_nTotcol02 := 0  
          
// mv_par01 -> Dt Inicio
// mv_par02 -> Dt Fim
// mv_par03 -> Causa Inicio
// mv_par04 -> Causa Fim
// mv_par05 -> Solucao Inicio
// mv_par06 -> Solucao Fim
// mv_par07 -> De Bem
// mv_par08 -> Ate Bem
// mv_par09 -> 1 = Causa / 2 = Solucao

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

//Pergunte(_cPerg,.F.) 


if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando()

		//-----------------------------------------------------------------------
		//  monta a query para o STL, STN, ST8
		//-----------------------------------------------------------------------		

/*
If mv_par09 == 1
		cQuery := " SELECT TN.TN_CAUSA, T8.T8_NOME, SUM (TL.TL_QUANTID)AS TL_HORAS, SUM(TL.TL_CUSTO) AS TL_CUSTO  
		cQuery += " FROM "+RetSqlName('STL')+" TL, "+RetSqlName('STN')+" TN, "+RetSqlName('ST8')+" T8, " +RetSqlName('STJ')+" TJ"
		cQuery += " WHERE TN.TN_ORDEM = TL.TL_ORDEM"
		cQuery += " AND TJ.TJ_ORDEM = TN.TN_ORDEM"
		cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		cQuery += " AND T8.T8_CODOCOR = TN.TN_CAUSA"
		cQuery += " AND TL.TL_DTINICI BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
		cQuery += " AND TN.TN_CAUSA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 +"'" 
		cQuery += " AND TL.D_E_L_E_T_ = ' '"
		cQuery += " AND TN.D_E_L_E_T_ = ' '"
		cQuery += " AND T8.D_E_L_E_T_ = ' '"
		cQuery += " AND TJ.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY TN.TN_CAUSA, T8.T8_NOME"

Elseif mv_par09 == 2

		cQuery := " SELECT TN.TN_SOLUCAO, T8.T8_NOME, SUM (TL.TL_QUANTID)AS TL_HORAS, SUM(TL.TL_CUSTO) AS TL_CUSTO  
		cQuery += " FROM "+RetSqlName('STL')+" TL, "+RetSqlName('STN')+" TN, "+RetSqlName('ST8')+" T8, "+RetSqlName('STJ')+" TJ" 
		cQuery += " WHERE TN.TN_ORDEM = TL.TL_ORDEM"
		cQuery += " AND TJ.TJ_ORDEM = TN.TN_ORDEM"
		cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		cQuery += " AND T8.T8_CODOCOR = TN.TN_SOLUCAO"
		cQuery += " AND TL.TL_DTINICI BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
		cQuery += " AND TN.TN_SOLUCAO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 +"'" 
		cQuery += " AND TL.D_E_L_E_T_ = ' '"
		cQuery += " AND TN.D_E_L_E_T_ = ' '"
		cQuery += " AND T8.D_E_L_E_T_ = ' '"
		cQuery += " AND TJ.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY TN.TN_SOLUCAO, T8.T8_NOME"
        cabec1 := OemToAnsi(" Solucao                                               Horas             Custo Total")     
	
Endif
*/
If mv_par09 == 1
		cQuery := " SELECT TN.TN_CAUSA, T8.T8_NOME, TL.TL_QUANTID , TL.TL_CUSTO"
		cQuery += " FROM "+RetSqlName('STL')+" TL, "+RetSqlName('STN')+" TN, "+RetSqlName('ST8')+" T8, " +RetSqlName('STJ')+" TJ" 
		cQuery += " WHERE TN.TN_ORDEM = TL.TL_ORDEM "
		cQuery += " AND TJ.TJ_ORDEM = TN.TN_ORDEM "
		cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		cQuery += " AND T8.T8_CODOCOR = TN.TN_CAUSA "
		cQuery += " AND TL.TL_DTINICI BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
		cQuery += " AND TN.TN_CAUSA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 +"'" 
		cQuery += " AND TL.D_E_L_E_T_ = ' ' AND TN.D_E_L_E_T_ = ' ' AND T8.D_E_L_E_T_ = ' ' "
		cQuery += " AND TJ.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY TL.TL_CUSTO, TL.TL_QUANTID, T8.T8_NOME, TN.TN_CAUSA"
		cQuery += " ORDER BY TN.TN_CAUSA, T8.T8_NOME "
Elseif mv_par09 == 2              

		cQuery := " SELECT TN.TN_SOLUCAO, T8.T8_NOME, TL.TL_QUANTID, TL.TL_CUSTO "
		cQuery += " FROM "+RetSqlName('STL')+" TL, "+RetSqlName('STN')+" TN, "+RetSqlName('ST8')+" T8, "+RetSqlName('STJ')+" TJ" 
		cQuery += " WHERE TN.TN_ORDEM = TL.TL_ORDEM"
		cQuery += " AND TJ.TJ_ORDEM = TN.TN_ORDEM"
		cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		cQuery += " AND T8.T8_CODOCOR = TN.TN_SOLUCAO"
		cQuery += " AND TL.TL_DTINICI BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
		cQuery += " AND TN.TN_SOLUCAO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 +"'" 
		cQuery += " AND TL.D_E_L_E_T_ = ' '"
		cQuery += " AND TN.D_E_L_E_T_ = ' '"
		cQuery += " AND T8.D_E_L_E_T_ = ' '"
		cQuery += " AND TJ.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY TL.TL_CUSTO, TL.TL_QUANTID, T8.T8_NOME, TN.TN_SOLUCAO"
		cQuery += " ORDER BY TN.TN_SOLUCAO, T8.T8_NOME "

ENDIF
        cabec1 := OemToAnsi(" Solucao                                               Horas             Custo Total")     

		MemoWrit('C:\TEMP\NHMNT012.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
 	    TcSetField("TRA1","TJ_DTPRINI","D")  // Muda a data de string para date    
Return

Static Function RptDetail()  
Local _nLinha
Local _ntCusto := 0 //custo total geral
Local _cAntes := ""
Local _nCusto := 0
Local _nQtde  := 0
Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    

DbSelectArea('TRA1')
DbGotop()

While TRA1->( ! Eof() )
	if Prow() > 60
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
	Endif

     	If (mv_par09 = 1) 
     		_cAntes := TRA1->TN_CAUSA+TRA1->T8_NOME
     		@ Prow()+1 , 002 Psay TRA1->TN_CAUSA
			@ Prow()   , 012 Psay TRA1->T8_NOME

			While _cAntes == TRA1->TN_CAUSA+TRA1->T8_NOME
				_nQtde  += TRA1->TL_QUANTID
		    	_nCusto += TRA1->TL_CUSTO
		    	TRA1->(DbSkip())
			EndDo       
		Elseif (mv_par09 = 2)
	   		_cAntes := TRA1->TN_SOLUCAO+TRA1->T8_NOME
  			@ Prow()+1 , 002 Psay TRA1->TN_SOLUCAO
            @ Prow()   , 012 Psay TRA1->T8_NOME

			While _cAntes == TRA1->TN_SOLUCAO+TRA1->T8_NOME
				_nQtde  += TRA1->TL_QUANTID
		    	_nCusto += TRA1->TL_CUSTO
		    	TRA1->(DbSkip())
			EndDo       
		Endif

       	@ Prow()   , 052 Psay Transform (_nQtde,"@E 999999.99")    			
		@ Prow()   , 068 Psay Transform (_nCusto,"@E 999,999,999.99")  

		_ntCusto += _nCusto
		_nQtde  := 0
		_nCusto := 0

end
@ Prow()+1,000 PSAY __PrtThinLine()
@ Prow()+1,055 Psay "TOTAL:" + space(7)+ Transform(_ntCusto,"@E 999,999,999.99")   	

Return(nil)
  