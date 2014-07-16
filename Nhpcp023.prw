#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHPCP023  ºAutor ³Fabio William Nico  º Data ³  12/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ MATERIAL UTILIZADO NA FORNADA                              º±±
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

User Function NHPCP023()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SZZ"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir as ")
cDesc2    := OemToAnsi("Quantidades utilizadas nas FORNADAS ")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHPCP009"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("MATERIAL UTILIZADO NAS FORNADAS ")                
cabec1    := ""
cabec2    := "Cod.Materia        Descricao                       No.Forno         Qtde        Liga       Dt.Ini.FUS     Ord.Prod.    Corrida     Produto"
//cabec2    := "Periodo de : " + dtos(mv_par01) + " a " + dtos(mv_par02)
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHPCP009"
_cPerg    := "PCP009" 
_nTotcol01 := 0  
_nTotalP := 0  

Pergunte(_cPerg,.T.) 

cabec1    := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)

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

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
RptStatus( {|| RptDetail() },"Imprimindo...")

//TRB->(DbCloseArea()) 
//TR3->(DbCloseArea()) 

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
		//  monta a query para o SD1
		//-----------------------------------------------------------------------		
		cQuery := "SELECT ZZ_PRODUTO,B1_DESC,ZZ_FORNO,ZZ_QTDE,ZZ_LIGA,ZZ_DINIFUS,ZZ_OP,ZZ_CORRIDA "
		cQuery += " 
		cQuery += "FROM " + RetSqlName('SB1') + " B1, " + RetSqlName('SZZ') +" ZZ "
		cQuery += "WHERE ZZ_DINIFUS BETWEEN '"+DTOS(mv_par01)+"' And '"+DTOS(mv_par02)+"' "
		cQuery += "AND ZZ_PRODUTO = B1_COD "
		cQuery += "AND ZZ.D_E_L_E_T_ = '' "
		cQuery += "AND B1.D_E_L_E_T_ = '' "
		cQuery += "GROUP BY ZZ_PRODUTO,B1_DESC,ZZ_FORNO,ZZ_QTDE,ZZ_LIGA,ZZ_DINIFUS,ZZ_OP, ZZ_CORRIDA "
		MemoWrit('C:\TEMP\NHPCP009.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS "TRA1"

		If	!USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

Return

Static Function RptDetail()  
 
if mv_par03 = 1
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,tamanho,nTipo)                                      
endif
DbSelectArea('TRA1')

_nTotalP := 0
_aproduto := TRA1->ZZ_PRODUTO
     
SETREGUA(TRA1->(RECCOUNT()))

While TRA1->( ! Eof() )      

	INCREGUA()	

    if TRA1->ZZ_PRODUTO <> _aproduto
		@ Prow()+1,000 PSAY __PrtThinLine()
		@ Prow()+1,020 Psay "Total do produto....: "
		@ Prow()  ,061 Psay _nTotalP picture "@E 99,999,999.99"   
		@ Prow()+1,000 PSAY __PrtThinLine()
		_aproduto := TRA1->ZZ_PRODUTO
		_nTotalp :=0
	endif

	@ Prow()+1 , 001 Psay TRA1->ZZ_PRODUTO
	@ Prow()   , 017 Psay TRA1->B1_DESC
	@ Prow()   , 055 Psay TRA1->ZZ_FORNO
	@ Prow()   , 064 Psay TRA1->ZZ_QTDE Picture "@E 999,999.99"
	@ Prow()   , 080 Psay TRA1->ZZ_LIGA
	@ Prow()   , 090 Psay stod(TRA1->ZZ_DINIFUS) picture "99/99/9999"
	@ Prow()   , 105 Psay TRA1->ZZ_OP
	@ Prow()   , 120 Psay TRA1->ZZ_CORRIDA   
	
	SC2->(DbSetOrder(1)) //C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	if SC2->(DbSeek(xFilial("SC2")+Substr(TRA1->ZZ_OP,1,6)))
		@ Prow()   , 130 Psay SC2->C2_PRODUTO
	EndIf

    _nTotalP := _nTotalP + TRA1->ZZ_QTDE
	 	         
	if mv_par03 = 1
		if Prow() > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,tamanho,nTipo)                                      
	 	endif
	endif
 	
	_nTotcol01 += TRA1->ZZ_QTDE
	TRA1->(DbSkip())
enddo                               

@ Prow()+2,000 PSAY __PrtThinLine() 
@ Prow()+1,020 Psay "Total do produto....: "
@ Prow()  ,061 Psay _nTotalP picture "@E 99,999,999.99"   
@ Prow()+2,000 PSAY __PrtThinLine() 
@ Prow()+1 , 001 Psay "TOTAL DO PERIODO..:" 
@ Prow()   , 061 Psay _nTotcol01 picture "@E 99,999,999.99"   

Return(nil)