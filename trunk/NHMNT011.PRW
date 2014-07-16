#include 'fivewin.ch'
#include 'topconn.ch'
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT011  ºAutor ³João Felipe da Rosa º Data ³  20/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE CUSTOS COM OS                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Manutencao de ativos                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT011()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols     := {}                  
cString   := "SZW"
cDesc1    := OemToAnsi("Este relatório tem por objetivo mostrar os custos por cada OS ")
cDesc2    := OemToAnsi("ou cada Ocorrencia.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT011"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO CUSTOS COM OCORRENCIAS")                
cabec1    := OemToAnsi("OS      Ocorrencia    Data      Causa                                     Solucao                        Custo Total  ")    
cabec2    := ""
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHMNT011"
_cPerg    := "MNT011" 

//_nTotal   := 0  
//_nTotcol01 := 0  
//_nTotcol02 := 0  
          
// mv_ch01 -> Dt Inicio
// mv_ch02 -> Dt Fim                       
// mv_ch03 -> Ordem inicio
// mv_ch04 -> Ordem Fim
// mv_ch05 -> Cod Ocorrencia Inicio
// mv_ch06 -> Cod Ocorrencia Fim 
// mv_ch07 -> Causa Inicio
// mv_ch08 -> Causa Fim
// mv_ch09 -> Solucao Inicio
// mv_ch010 -> Solucao Fim    
// MV_PAR11 -> de operacao
// MV_PAR12 -> ate operacao

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
		//  monta a query para o SZW
		//-----------------------------------------------------------------------		

		cQuery := " SELECT TJ.TJ_ORDEM, TN.TN_CODOCOR, TJ.TJ_DTPRINI, TN.TN_CAUSA, TN.TN_SOLUCAO, T8.T8_NOME, SUM(TL.TL_CUSTO) AS TL_CUSTO"
        cQuery += " FROM " + RetSqlName( 'STL ' ) + " TL, " + RetSqlName ('STJ') + " TJ, " + RetSqlName ('STN') + " TN,"
        cQuery += RetSqlName ('ST8') + " T8," +RetSqlName('ST9')+" T9"
        cQuery += " WHERE TJ.TJ_ORDEM = TL.TL_ORDEM"
		cQuery += " AND TN.TN_ORDEM = TJ.TJ_ORDEM" 
		cQuery += " AND T9.T9_CODBEM = TJ.TJ_CODBEM"
		cQuery += " AND T9.T9_OPERAC BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
		cQuery += " AND TN.TN_SOLUCAO = T8.T8_CODOCOR"
		cQuery += " AND TJ.TJ_DTPRINI BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
        cQuery += " AND TJ.TJ_ORDEM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"		
        cQuery += " AND TN.TN_CODOCOR BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
        cQuery += " AND TN.TN_CAUSA BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'" 
        cQuery += " AND TN.TN_SOLUCAO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"        
        cQuery += " AND TN.D_E_L_E_T_ = '' AND TJ.D_E_L_E_T_ = '' AND T8.D_E_L_E_T_ = '' AND TL.D_E_L_E_T_ = '' "               
		cQuery += " GROUP BY TJ.TJ_ORDEM, TN.TN_CODOCOR, TJ.TJ_DTPRINI, TN.TN_CAUSA, TN.TN_SOLUCAO, T8.T8_NOME"
   		
		MemoWrit('C:\TEMP\NHMNT011.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
 	    TcSetField("TRA1","TJ_DTPRINI","D")  // Muda a data de string para date    
Return

Static Function RptDetail()  
Local _nLinha

Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    

DbSelectArea('TRA1')
QAA->(DbSetOrder(1)) //filial matricula
ST8->(DbSetOrder(1)) //T8_FILIAL+T8_CODOCOR+T8_TIPO 
While TRA1->( ! Eof() )
	if Prow() > 60
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
	Endif

	 	@ Prow()+1 , 001 Psay TRA1->TJ_ORDEM
	 	@ Prow()   , 010 Psay TRA1->TN_CODOCOR
	 	@ Prow()   , 019 Psay TRA1->TJ_DTPRINI PICTURE "99/99/99"
	 	@ Prow()   , 032 Psay TRA1->TN_CAUSA
        IF ST8->(DbSeek(xFilial("ST8")+TRA1->TN_CAUSA+"C"))
	        @ Prow()   , 041 Psay Substr(ST8->T8_NOME, 1,20)
    	EndIf
    	@ Prow()   , 075 Psay TRA1->TN_SOLUCAO
        @ Prow()   , 084 Psay Substr(TRA1->T8_NOME,1,20)
		@ Prow()   , 106 Psay TRA1->TL_CUSTO
    TRA1->(DbSkip())
end
@ Prow()+1,000 PSAY __PrtThinLine()

Return(nil)
  