#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST200  �Autor �DOUGLAS DOURADO �    Data �  19/06/12    ���
�������������������������������������������������������������������������͹��
���Desc.     � RELAT�RIO DE DIAS DE COBERTURA POR PRODUTO                 ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHEST200()

cString   := "STJ"
cDesc1    := "Este relat�rio mostra os dias de cobertura do estoque atual"
cDesc2    := "por produto."
cDesc3    := ""
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST200"
nLastKey  := 0
titulo    := "RELAT�RIO COBERTURA DE ESTOQUE POR PRODUTO - " // T�tulo do relat�rio
cabec1    := " Codigo             Descri��o                          Local       Saldo    Dias Cobertura    Quant SC     Quant PC     Valor Total" 
cabec2    := ""
cabec3    := "" 
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST200"  
_cPerg	  := "EST200"  


//--------------------------------------------------------------
//              PERGUNTAS
//-------------------------------------------------------------- 
// mv_par01 "De Produto"
// mv_par02 "At� Produto"
// mv_par03 "De Grupo"
// mv_par04 "At� Grupo"
// mv_par05 "Mostrar Saldo Zerado ?"
// mv_par06 "De Local"
// mv_par07 "At� Local"
//--------------------------------------------------------------

Pergunte("EST200",.T.) // <-- Chama a fun��o respons�vel pela inicializa��o das "perguntas" do relat�rio, valor em "TRUE" for�a o usu�rio a entrar com os par�metros primeiro. 

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

//-- PROGRAMACAO

Processa( {|| Gerando()   },"Gerando Dados do Relat�rio...") 
Processa( {|| RptDetail()   },"Gerando Relat�rio...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando() // FUN��O RESPONSAVEL POR GERAR A QUERY
Local cQueryPrinc // Query Principal   
Local cQuerySol // Query de Solicita��es
Local cQueryPed // Query de Pedidos Pendentes 
Local cQueryCon // Query de Consumo Medio Diario com base em 6 meses atras  

ProcRegua(2)

IncProc()
 

    //------------------//
    // MONTA AS QUERY'S //
    //------------------//               
    
    //-- QUERY PRINCIPAL -------------------------------------------
    cQueryPrinc := " SELECT B1_COD , B1_DESC , B2_LOCAL, (B2.B2_QATU - B2.B2_QEMPSA) AS 'SALDO_ATUAL', B1_UPRC * (B2.B2_QATU - B2.B2_QEMPSA) AS 'TOTAL_ESTOQUE' "
	cQueryPrinc += " FROM " + RetSqlName("SB1") + " B1, " + RetSqlName("SB2") + " B2 " 
	cQueryPrinc += " WHERE B1_COD = B2_COD "
	cQueryPrinc += " AND B1.D_E_L_E_T_ = '' AND B1_FILIAL = '" +xFilial("SB1") + "' "
	cQueryPrinc += " AND B2.D_E_L_E_T_ = '' AND B2_FILIAL = '" +xFilial("SB2") + "' "    
    cQueryPrinc += " AND B1.B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' " // DE ACORDO COM AS PERGUNTAS, FILTRA OS PRODUTOS 
    cQueryPrinc += " AND B1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " // DE ACORDO COM AS PERGUNTAS, FILTRA OS GRUPOS 
    cQueryPrinc += " AND B2.B2_LOCAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' " // DE ACORDO COM AS PERGUNTAS, FILTRA O ARMAZEM
    //------------------------------------------------------------- 
    //   Mostrar Saldos Negativos ?
    IF mv_par05 == 2  // 1 = Sim  e  2 = Nao
		cQueryPrinc += " AND (B2.B2_QATU-B2.B2_QEMPSA) <> 0 "        	   
    ENDIF
    //------------------------------------------------------------- 
    
	cQueryPrinc += " ORDER BY B1_COD, B2_LOCAL "
	
    TCQUERY cQueryPrinc NEW ALIAS "TRA1"  // Criando o ALIAS principal  
    
	IncProc()
	
	TRA1->(DbGoTop()) 
	   
    //--------------------------------------------------------------    
    

Return

//---------------------------
// MONTA O RELAT�RIO (F�SICO)
//---------------------------
Static Function RptDetail()  
Local _nValor := 0
Local _nDias := 0
Local _nSol := 0
Local _nPed := 0
Local _dData

ProcRegua(0)

_dData := Date()
                                         
Titulo += DtoC(_dData) // Coloca a data atual no t�tulo do relat�rio 

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) // Monta o Cabe�alho do Relat�rio 
   
 //---------------------------------
 // Escrevendo os dados no relat�rio
 //---------------------------------

While TRA1->(!Eof())  
   
    IncProc()  

    //-- CONSUMO DIARIO MEDIO POR PRODUTO ---------------
    cQueryCon := " SELECT SUM(D3.D3_QUANT)/180 AS 'CONSUMO_DIARIO' "
	cQueryCon += " FROM " + RetSqlName("SD3") + " D3 "
	cQueryCon += " WHERE D3.D3_EMISSAO >= '" + DtoS(date()-180) + "' "  
	cQueryCon += " AND D3.D3_TM  > '500' "
	cQueryCon += " AND D3.D3_ESTORNO <> 'S' " 
	cQueryCon += " AND D3.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"' "
	cQueryCon += " AND D3.D3_COD = '" + TRA1->B1_COD + "' " 
	
	TCQUERY cQueryCon NEW ALIAS "CON1"  // Criando o ALIAS do Consumo Medio Diario
	
	CON1->(DbGoTop())

	_nDias := Iif( CON1->(!EOF()), CON1->CONSUMO_DIARIO,0)

	CON1->(dbclosearea())	

    //---------------------------------------------------
        
    //-- QUERY DE SOLICITA��ES --------------------------
    cQuerySol := " SELECT SUM(C1_QUANT) AS 'QUANT_SC' "
    cQuerySol += " FROM " + RetSqlName("SC1") + " C1 "
 	cQuerySol += " WHERE C1_PRODUTO = '" + TRA1->B1_COD + "' "   
    cQuerySol += " AND C1_QUJE <> C1_QUANT "
    cQuerySol += " AND C1_RESIDUO <> 'S' "
    cQuerySol += " AND C1_STATUS <> 'C' " 
    cQuerySol += " AND C1.D_E_L_E_T_ = '' AND C1_FILIAL = '" + xFilial("SC1") + "' "
    
   	TCQUERY cQuerySol NEW ALIAS "SOL1"  // Criando o ALIAS solicita��es
	
	SOL1->(DbGoTop())
	
	_nSol := Iif( SOL1->(!EOF()), SOL1->QUANT_SC, 0)
	
	SOL1->(dbclosearea())	   
    //--------------------------------------------------  
    
    
    //-- QUERY DE PEDIDOS PENDENTES --------------------
    cQueryPed := " SELECT SUM(C7_QUANT - C7.C7_QUJE) AS 'QUANT_PC' "
	cQueryPed += " FROM " + RetSqlName("SC7") + " C7 "
	cQueryPed += " WHERE C7_PRODUTO = '"+ TRA1->B1_COD + "' "
	cQueryPed += " AND C7.C7_QUANT <> C7.C7_QUJE "
	cQueryPed += " AND C7.C7_ENCER <> 'E' "
	cQueryPed += " AND C7.C7_RESIDUO <> 'S' "
	cQueryPed += " AND C7.D_E_L_E_T_ = '' AND C7_FILIAL = '"+xFilial("SD3")+"' " 

    TCQUERY cQueryPed NEW ALIAS "PED1"  // Criando o ALIAS pedidos
	
    PED1->(DbGoTop())  
     
    _nPed := Iif( PED1->(!EOF()), PED1->QUANT_PC , 0)
	
    PED1->(dbclosearea())	   
     
    //--------------------------------------------------
    
 	If Prow() > 76  // Limite de linhas por p�gina
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) // <--  Se for maior que o limite, escreve um cabe�alho
	Endif
	
	@Prow()+1, 001 psay TRA1->B1_COD
	@Prow()  , 020 psay TRA1->B1_DESC
	@Prow()  , 057 psay TRA1->B2_LOCAL
	@Prow()  , 060 psay TRA1->SALDO_ATUAL picture("@e 9,999,999.99") 
	@Prow()  , 073 psay (TRA1->SALDO_ATUAL/_nDias) picture("@e 999,999,999")  // Dias de Cobertura
	@Prow()  , 088 psay _nSol picture("@e 999,999,999") // Quant SC
	@Prow()  , 102 psay _nPed picture("@e 999,999,999") // Quant PC
	@Prow()  , 117 psay TRA1->TOTAL_ESTOQUE picture("@e 999,999,999.99") // Saldo * Ult. Pre�o Compra
 	_nValor += TRA1->TOTAL_ESTOQUE 
   
	TRA1->(DbSkip())  
	   	
EndDo

@Prow()+1, 000 PSAY __PrtThinLine() //  <--  Escreve uma linha fina na tela
@Prow()+1, 001 psay "Total: " 
@Prow()  , 117 psay _nValor picture("@e 999,999,999.99") 
 					
TRA1->(DbCloseArea())  

Return(nil)