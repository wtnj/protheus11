#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT008  ºAutor ³Fabio Nico          º Data ³  02/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO FUNCIONARIO / MATRICULA                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTECAO DE ATIVOS                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT008()   
Local oPrint  
SetPrvt("aGrupo,_cCodUsr,aCols,aGrupo,_cArqDBF,_aDBF,_cArqDBF,_cOrdem,_totalgeral,_totalcc")

aCols	:= {}                  
Agrupo 	:= {}
cString   := "QAA"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o  ")
cDesc2    := OemToAnsi("Colaborador / Matricula da Manutencao")
cDesc3    := OemToAnsi("")
tamanho   := "P"
//limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT008"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELAÇÃO DE FUNCIONARIOS / MATRICULA ")                
cabec1    := "Matricula   Centro Custo    Funcionario "
cabec2    := "Centro de Custo de : " + mv_par01 + " a " + mv_par01                                                    
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT008"
_cPerg    := "MNT008" 
_nTotal   := 0  
_totalgeral := 0  
_totalcc := 0

Pergunte(_cPerg,.F.)                                      
cabec2    := "Centro de Custo de : " + mv_par01 + " a " + mv_par02
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
DbCloseArea("TRA1")     
Return


Static Function Gerando()
Local cQuery
Local _ni 
//-----------------------------------------------------------------------
//  monta a query para o ct2
//-----------------------------------------------------------------------		

                                                      	
cQuery := " SELECT QAA.QAA_MAT,QAA.QAA_NOME,QAA.QAA_CC "
cQuery += " FROM " + RetSqlName('QAA') + " QAA " 
cQuery += " WHERE QAA.QAA_CC BETWEEN '" +mv_par01+"' And '"+mv_par02+"' "
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += " ORDER BY QAA.QAA_NOME "
                                    
MemoWrit('C:\TEMP\NHMNT008.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TRA1->(DbGotop())     
    
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

While !TRA1->(EOF())                              
	
	if Prow() > 60                                      
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	endif
	@Prow()+1, 05 psay TRA1->QAA_MAT
	@Prow()  , 15 psay TRA1->QAA_CC
	@Prow()  , 25 psay TRA1->QAA_NOME
	TRA1->(DbSkip())   
	
Enddo


Return(nil)