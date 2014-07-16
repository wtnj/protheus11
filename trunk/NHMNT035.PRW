#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT035  ºAutor ³João Felipe da Rosa º Data ³  23/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO DETALHADO DE MATERIAIS EM ATRASO DE O.S          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT035()   

Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Apresenta detalhes sobre materiais solicitados")
cDesc2    := OemToAnsi("que ainda não foram comprados.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT035" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DETALHADO DE MATERIAIS EM ATRASO DE O.S") //título
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := ""
cabec2    := " O.S.     Bem           S.C.     Item    Insumo        Descrição                         Pedido   Dt.Inicial   Dt.Final     Horas "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1 
M_PAG     := 1 //Variavel que acumula numero da pagina 
wnrel     := nomeprog //"NH"
_cPerg    := "MNT035" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_PAR01 = De Data        ³
//³MV_PAR02 = Até Data       ³
//³MV_PAR03 = De Bem         ³
//³MV_PAR04 = Até Bem        ³
//³MV_PAR05 = De Produto     ³
//³MV_PAR06 = Até Produto    ³
//³MV_PAR07 = De C.Custo     ³
//³MV_PAR08 = Até C.Custo    ³
//³MV_PAR09 = De C.Trabalho  ³
//³MV_PAR10 = Até C.Trabalho ³
//³MV_PAR11 = Até Servico    ³
//³MV_PAR12 = Até Servico    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif 

cabec1 := "Período consultado: "+DtoC(mv_par01)+" até "+DtoC(mv_par02)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CHAMADAS PARA AS FUNÇÕES³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa(  {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO QUE GERA OS DADOS PARA IMPRESSAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Gerando()
Local cQuery

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MONTA A QUERY³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                     
cQuery := "SELECT TPL.TPL_ORDEM, TJ.TJ_CODBEM, C1.C1_NUM, C1.C1_ITEM, C1.C1_PRODUTO, C1.C1_PEDIDO,"
cQuery += " TPL.TPL_DTINIC, TPL.TPL_DTFIM, TPL.TPL_HOINIC, TPL.TPL_HOFIM, B1.B1_DESC"
cQuery += " FROM "+RetSqlName("TPL")+" TPL, "+RetSqlName("STJ")+" TJ, "+RetSqlName("SC1")+" C1, "
cQuery += RetSqlName("SB1")+" B1"
cQuery += " WHERE TPL.TPL_ORDEM = TJ.TJ_ORDEM"
cQuery += " AND C1.C1_OS = TJ.TJ_ORDEM" 
cQuery += " AND B1.B1_COD = C1.C1_PRODUTO "
cQuery += " AND TPL.TPL_DTINIC >= '"+DTOS(MV_PAR01)+"'"
cQuery += " AND TPL.TPL_DTFIM <= '"+DTOS(MV_PAR02)+"'"
cQuery += " AND TJ.TJ_CODBEM  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND C1.C1_PRODUTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " AND TJ.TJ_CCUSTO  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
cQuery += " AND TJ.TJ_CENTRAB BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
cQuery += " AND TJ.TJ_SERVICO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"
cQuery += " AND C1.C1_FILIAL = '"+xFilial("SC1")+"' AND C1.D_E_L_E_T_ = ''"
cQuery += " AND TJ.TJ_FILIAL = '"+xFilial("STJ")+"' AND TJ.D_E_L_E_T_ = ''"
cQuery += " AND TPL.TPL_FILIAL = '"+xFilial("TPL")+"' AND TPL.D_E_L_E_T_ = ''"

//MemoWrit('C:\TEMP\'+nomeprog+'.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TcSetField("TRA1","TPL_DTINIC","D")  // Muda a data de string para date    
TcSetField("TRA1","TPL_DTFIM" ,"D")  // Muda a data de string para date    

TRA1->(DbGotop())     

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA IMPRESSAO DO RELATÓRIO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Imprime()
Local _cOS,_nTempo

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SetRegua(TRA1->(RecCount()))

While TRA1->(!Eof())  

	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	IncRegua()
	
	@Prow()+1, 001 psay TRA1->TPL_ORDEM
	@Prow()  , 010 psay ALLTRIM(TRA1->TJ_CODBEM)

	_cOS := TRA1->TPL_ORDEM
    
	_lPrim := .T. //primeira vez no loop
	
	While TRA1->TPL_ORDEM == _cOs        
	
		If _lPrim
			@Prow()  , 024 psay TRA1->C1_NUM
		Else	
			@Prow()+1, 024 psay TRA1->C1_NUM
		EndIf

		@Prow()  , 033 psay TRA1->C1_ITEM
		@Prow()  , 041 psay ALLTRIM(TRA1->C1_PRODUTO)+" - "+SUBSTR(TRA1->B1_DESC,1,33)
		
		@Prow()  , 089 psay TRA1->C1_PEDIDO

		If _lPrim
			@Prow()  , 098 psay TRA1->TPL_DTINIC
			@Prow()  , 111 psay TRA1->TPL_DTFIM

 			_nTempo := ((TRA1->TPL_DTFIM - TRA1->TPL_DTINIC)) * 24
 			
 			_nTempo += HoraToInt(TRA1->TPL_HOFIM) - HoraToInt(TRA1->TPL_HOINIC)

			_nTam := Len(Alltrim(Str(Int(_nTempo))))
			
			@Prow()  , 124 psay IntToHora(_nTempo,_nTam) //Tempo de atraso
			
			_lPrim := .F.
		
		EndIf
		             
		TRA1->(DbSkip())
	EndDo

	@Prow()+1, 001 psay ""

EndDo

@ prow()+1,000 PSAY __PrtThinLine()

TRA1->(DbCloseArea())

Return(nil)