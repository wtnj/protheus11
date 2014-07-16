#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHMNT017  บAutor ณJoใo Felipe         บ Data ณ  12/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ MANUTENCAO DE ATIVOS                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANUTENCAO DE ATIVOS                                       บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NHMNT017()   

aCols	:= {}                  
Agrupo 	:= {}
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("as OS de servicos para execucao")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT017"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELACAO DE O.S. PARA EXECUCAO")                
cabec1    := " Cod do Bem      Descricao do Bem                                                                Periodo de : "
cabec2    := " Data OS     No.OS   Tarefa    Desc.Tarefa                        Etapa     Descr.Etapa                                                                Freq.       Data           Status "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT017"
_cPerg    := "MNT017" 
_nTotal   := 0  
_totalgeral := 0  
_totalcc := 0
 

// mv_par01 = do bem
// mv_par02 = ate bem
// mv_par03 = da ordem 
// mv_par04 = ate ordem 
// mv_par05 = do servico
// mv_par06 = ate servico
// mv_par07 = do centro de trabalho
// mv_par08 = ate centro de trabalho
// mv_par09 = do plano 
// mv_par10 = ate plano
// mv_par11 = da data
// mv_par12 = at้ data


Pergunte(_cPerg,.F.)                            
cabec1  := " Cod do Bem      Descricao do Bem"
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

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

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool
DbCloseArea("TMP")     
Return


Static Function Gerando()
Local cQuery
Local _cOs   
Local _lPrim := .T.

//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------		



cQuery := " SELECT TJ.TJ_ORDEM, TH.TH_CODBEM,TJ.TJ_PLANO, TH.TH_TAREFA, T5.T5_DESCRIC ,TH.TH_ETAPA,TPA.TPA_DESCRI, "
cQuery += " TJ.TJ_DTORIGI, TF.TF_TEENMAN, TF.TF_UNENMAN, TJ.TJ_CENTRAB, TJ.TJ_CCUSTO"
cQuery += " FROM " + RetSqlName('STH')+" TH, " +RetSqlName('STF') + " TF, " + RetSqlName('STJ')  
cQuery += " TJ, " + RetSqlName('TPA') + " TPA, " + RetSqlName ('ST5') + " T5 "
cQuery += " WHERE TH.TH_CODBEM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
cQuery += " AND TJ.TJ_ORDEM BETWEEN '" + mv_par03 + "'AND '" + mv_par04 + "'"
cQuery += " AND TH.TH_SERVICO BETWEEN '" +mv_par05+ "' AND '" + mv_par06 + "'"
cQuery += " AND TJ.TJ_CENTRAB BETWEEN '" +mv_par07+ "' AND '" + mv_par08 + "'"
cQuery += " AND TJ.TJ_PLANO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
cQuery += " AND TJ.TJ_DTORIGI BETWEEN '"+DtoS(mv_par11)+"' AND '"+DtoS(mv_par12)+"'"
cQuery += " AND T5.T5_CODBEM = TH.TH_CODBEM"
cQuery += " AND TH.TH_CODBEM = TF.TF_CODBEM"
cQuery += " AND TH.TH_TAREFA = T5.T5_TAREFA"
cQuery += " AND TPA.TPA_ETAPA = TH.TH_ETAPA"
cQuery += " AND TJ.TJ_CODBEM = TF.TF_CODBEM"
cQuery += " AND TF.TF_ATIVO = 'S'"
cQuery += " AND TF.TF_SERVICO = TJ.TJ_SERVICO"
cQuery += " AND TJ.TJ_TERMINO = 'N'"
cQuery += " AND TJ.D_E_L_E_T_ <> '*'"
cQuery += " AND TH.D_E_L_E_T_ <> '*'"
cQuery += " AND TF.D_E_L_E_T_ <> '*'"
cQuery += " AND TPA.D_E_L_E_T_ <> '*'"
cQuery += " AND T5.D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY TH.TH_CODBEM, TH.TH_ETAPA, TH.TH_TAREFA, TJ.TJ_ORDEM, TJ.TJ_TERMINO, TJ.TJ_PLANO , TJ.TJ_DTORIGI, "
cQuery += " TPA.TPA_DESCRI, T5.T5_DESCRIC, TF.TF_TEENMAN, TF.TF_UNENMAN, TJ.TJ_CENTRAB, TJ.TJ_CCUSTO"
cQuery += " ORDER BY TJ.TJ_CCUSTO,TH.TH_CODBEM,TJ.TJ_DTORIGI"

MemoWrit('C:\TEMP\NHMNT017.SQL',cQuery)
TCQUERY cQuery NEW ALIAS 'TMP'

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

TMP->(DbGotop())     

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

//_bem_ant := TMP->TJ_CODBEM
//_cc_ant := TMP->T9_CCUSTO
//@Prow()+1, 001 psay TMP->TJ_CODBEM
//@Prow()  , 025 psay ALLTRIM(TMP->T6_NOME) + " / " + ALLTRIM(TMP->T9_NOME)
//@Prow()  , 120 psay "Centro Custo: "
//@Prow()  , 135 psay TMP->T9_CCUSTO    
//@Prow()  , 150 psay TMP->CTT_DESC01

_cOs := ''

While TMP->(!Eof()) 
    if _cOs <> TMP->TJ_ORDEM
	   	If !_lPrim
		   	_nPag  := _nPag + 1   
			Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
		EndIf
		_lPrim := .F.	       	
       	@Prow()+1, 001 psay TMP->TH_CODBEM
		ST9->(DbSeek(xFilial('ST9')+TMP->TH_CODBEM))
		@Prow()  , 017 psay ALLTRIM(ST9->T9_NOME)
		@Prow()  , 66 psay "Centro Custo: "
		@Prow()  , 81 psay TMP->TJ_CCUSTO
		CTT->(DbSeek(xFilial('CTT')+TMP->TJ_CCUSTO))
		@Prow()  , 90 psay CTT->CTT_DESC01
	endif      

	@Prow()+2, 001 psay STOD(TMP->TJ_DTORIGI) Picture "99/99/9999" 
	@Prow()  , 013 psay TMP->TJ_ORDEM
	@Prow()  , 021 psay TMP->TH_TAREFA
	@Prow()  , 031 psay TMP->T5_DESCRIC
	@Prow()  , 067 psay TMP->TH_ETAPA
	@Prow()  , 077 psay TMP->TPA_DESCRI
	@Prow()  , 152 psay TMP->TF_TEENMAN 
	@Prow()  , 155 psay TMP->TF_UNENMAN
		
	@Prow()  , 160 psay "____/____/____"
	@Prow()  , 178 psay "___________________________________"

	_cOs := TMP->TJ_ORDEM

	TMP->(Dbskip())

  	If Prow() > 65 .AND. _cOs == TMP->TJ_ORDEM
   		@Prow()+1, 001 psay "Continua..."
	   	_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
		@Prow()+1, 001 psay "Continuacao..."
       	@Prow()+1, 001 psay TMP->TH_CODBEM
		ST9->(DbSeek(xFilial('ST9')+TMP->TH_CODBEM))
		@Prow()  , 017 psay ALLTRIM(ST9->T9_NOME)
		@Prow()  , 66 psay "Centro Custo: "
		@Prow()  , 81 psay TMP->TJ_CCUSTO
		CTT->(DbSeek(xFilial('CTT')+TMP->TJ_CCUSTO))
		@Prow()  , 90 psay CTT->CTT_DESC01  

	Endif  
enddo
TMP->(DbCloseArea())          

Return(nil)