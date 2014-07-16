#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP033  ºAutor  ³FELIPE CICONINI     º Data ³  24/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE RELEASES,ENTREGAS E ATRASOS DO DIA             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PLANEJAMENTO E CONTROLE DA PRODUCAO                         º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Chamado nº 010202
Bom dia! Peço a gentileza que seja criado um relatório, onde consigamos verificar o release do dia, a entrega e o atraso do dia (acumulado), 
de todos os fornecedores em uma folha. obrigada

*/


User Function NHPCP032()
Private aMatHj := {}
Private aMatAm := {}

cString		:= "ZA0"
cDesc1		:= ""
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHPCP033"
nLastKey	:= 0
titulo		:= OemToAnsi("")
cabec1    	:= ""
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHPCP033"
_cPerg		:= "PCP033"

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)
nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa({|| Gerando()  },"Gerando Dados para Impressao")
Processa({|| RptDetail()  },"Imprimindo...")

Set Filter To
If aReturn[5]==1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

Static Function Gerando ()
Local cQuery 

    
    //0000000000000000000000000000000000
    //00000000|MONTANDO A QUERY|00000000
    //0000000000000000000000000000000000
    
	cPrev	:= "ZA0.ZA0_PREV"+StrZero(DAY(mv_par01),2)
	cPrevAm := "ZA0.ZA0_PREV"+StrZero(++Val(DAY(mv_par01)),2)

	cQuery := "SELECT ZA0."+&(cPrev)+", ZA0."+&(cPrevAm)+",ZA0.ZA0_PROD, ZA9.ZA9_FORNEC, ZA9.ZA9_LOJA, ZA9.ZA9_MES, ZA9.ZA9_ANO, SB1.B1_DESC, SB1.B1_COD"
	cQuery += " FROM "+RetSqlName("ZA0")+" ZA0, "+RetSqlName("ZA9")+" ZA9, "+RetSqlName("SB1")+" SB1"
	cQuery += " WHERE	ZA0.ZA0_NUM 	= ZA9.ZA9_NUM"
	cQuery += " AND		ZA9.ZA9_FORNEC	BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
	cQuery += " AND		ZA9.ZA9_LOJA	BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'"
	cQuery += " AND		ZA9.ZA9_MES		= '"+MONTH(mv_par01)+"'"
	cQuery += " AND		ZA9.ZA9_ANO		= '"+YEAR(mv_par01)+"'"
	cQuery += " AND		ZA0.ZAO_PROD	= SB1.B1_COD
	
	cQuery += " AND		ZA9.D_E_L_E_T_	= ' '"
	cQuery += " AND		ZA0.D_E_L_E_T_	= ' '"
	cQuery += " AND		ZA9.ZA9_FILIAL	= '"+xFilial("ZA9")+"'"
	cQuery += " AND		ZA0.ZA0_FILIAL	= '"+xFilial("ZA0")+"'"
	cQuery += " ORDER BY ZA9.ZA9_FORNEC, ZA9.ZA9_LOJA"
	MemoWrit('C:\TEMP\NHPCP033.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS 'TMP1'
	
	
	
	
	Return
	
Static Function RptDetail()

	cabec1 := ""
	cabec2 := ""
	Titulo := OemToAnsi("RELATÓRIO DE RELEASES, ENTREGAS E ACUMULADOS")
	
    If Prow() > 60
    	Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
    EndIf  
    
    TMP1->(DbGoTop())
    
    While TMP1->(!EoF())
        
    	@Prow()+1,001 PSAY TMP1->ZA9_FORNEC
    	@Prow()  ,020 PSAY TMP1->ZA9_LOJA
    	@Prow()  ,024 PSAY TMP1->B1_COD
    	@Prow()  ,044 PSAY TMP1->B1_DESC
    	@Prow()  ,074 PSAY DtoC(mv_par01)
    	@Prow()  ,088 PSAY TMP1->&(cPrev)
    	@Prow()  ,100 PSAY TMP1->&(cPrevAm)
    	
        TMP1->(DbSkip())
    EndDo
      
Return