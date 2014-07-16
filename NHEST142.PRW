#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST142  ºAutor ³João Felipe da Rosa º Data ³  01/04/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE BAIXAS                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE E CUSTOS                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterações³          ³                                                 º±±
±±ºAdicionado no relatorio os campos D3_ORDEM e D3_MAQUINA                º±±
±±ºFeito por Douglas Dourado - 24/12/12 - OS 036609						  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±s±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST142()   

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SD3"
    oRelato:cPerg    := "EST142"
	oRelato:cNomePrg := "NHEST142"
	oRelato:wnrel    := oRelato:cNomePrg

	// MV_PAR01 - de Produto
	// MV_PAR02 - ate Produto
	// MV_PAR03 - de Emissao
	// MV_PAR04 - ate Emissao
	// MV_PAR05 - Local
	// MV_PAR06 - de CCusto
	// MV_PAR07 - ate CCusto
	// MV_PAR08 - de Grupo
	// MV_PAR09 - Ate GRupo
	// MV_PAR10 - De hora
	// MV_PAR11 - Ate hora
	// MV_PAR12 - De turno
	// MV_PAR13 - Ate turno
	// MV_PAR14 - Agrupado (Sim / Nao)
	
	//descricao
	oRelato:cDesc1   := "Apresenta as baixas de material."
	oRelato:cDesc2   := ""
	oRelato:cDesc3   := ""

	//titulo
	oRelato:cTitulo  := "BAIXAS DO ESTOQUE"
	
	//tamanho        
	oRelato:cTamanho := "G"   //default "M"

	//cabecalho      
	oRelato:cCabec1  := " PRODUTO         DESCRIÇÃO                                 QUANT.    TM     C.CUSTO     DOC             DATA      SOLICIT    NOME                                 RESPONSAVEL    HORA         TURNO    ORDEM    MAQUINA"
    oRelato:cCabec2  := ""
    
    oRelato:aOrd     := {OemToAnsi("Por Produto"),OemToAnsi("Por Quantidade")} 
		
	oRelato:Run({||Imprime()})

	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA IMPRESSAO DO RELATÓRIO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local nTotQtd := 0

	Processa(  {|| Gerando()   },"Gerando Dados para a Impressao") 

	oRelato:Cabec()

	SetRegua(TRA1->(RecCount()))

	//Percorre os registros
	While TRA1->(!Eof())  

		If Prow() > 65 
			oRelato:Cabec()
	  	Endif

		IncRegua(TRA1->D3_COD)

		@Prow()+1, 001 psay TRA1->D3_COD
		@Prow()  , 017 psay TRA1->B1_DESC
		@Prow()  , 058 psay TRA1->D3_QUANT PICTURE "@E 999999"	
		nTotQtd += TRA1->D3_QUANT
		
		If mv_par14==2
			@Prow()  , 069 psay TRA1->D3_TM
			@Prow()  , 077 psay TRA1->D3_CC
			@Prow()  , 087 psay TRA1->D3_DOC
			@Prow()  , 101 psay DTOC(TRA1->D3_EMISSAO)
			@Prow()  , 115 psay TRA1->D3_SOLICIT
			@Prow()  , 125 psay TRA1->QAA_NOME      
			@Prow()  , 162 psay TRA1->D3_USUARIO
			@Prow()  , 177 psay TRA1->D3_HORAFIM
			@Prow()  , 192 psay TRA1->D3_TURNO
			@Prow()  , 199 psay TRA1->D3_ORDEM
			@Prow()  , 208 psay TRA1->D3_MAQUINA
			
		EndIf
		
		TRA1->(DbSkip())
	
	EndDo
	
	@ prow()+1,000 PSAY __PrtThinLine()        
	@ Prow()+1, 001 psay "Total: "
	@ Prow()  , 056 psay nTotQtd PICTURE "@E 99999999"

	TRA1->(DbCloseArea())

Return(nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO QUE GERA OS DADOS PARA IMPRESSAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local cQuery

	mv_par10 := Iif(AllTrim(mv_par10)==":","",alltrim(mv_par10))
	mv_par11 := Iif(AllTrim(mv_par11)==":","",alltrim(mv_par11))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MONTA A QUERY³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := " SELECT D3.D3_COD, B1.B1_DESC, "
	
	If mv_par14==1 //agrupado? sim
	
		oRelato:cCabec1  := " PRODUTO         DESCRIÇÃO                                 QUANT."

		cQuery += " SUM(D3.D3_QUANT) AS D3_QUANT, D3_ORDEM, D3_MAQUINA "
		cQuery += " FROM "+RetSqlName("SD3")+" D3, "+RetSqlName("SB1")+" B1 "
		cQuery += " WHERE D3.D3_COD = B1.B1_COD"
	Else
		cQuery += " D3.D3_TM, D3.D3_QUANT, D3.D3_CC, D3.D3_DOC, D3.D3_EMISSAO, D3.D3_SOLICIT,D3_USUARIO, D3_HORAFIM, D3_TURNO, QAA.QAA_NOME, D3.D3_ORDEM, D3.D3_MAQUINA "
		cQuery += " FROM "+RetSqlName("SD3")+" D3, "+RetSqlName("SB1")+" B1, "+RetSqlName("QAA")+" QAA"
		cQuery += " WHERE D3.D3_COD = B1.B1_COD"
		cQuery += " AND QAA.QAA_MAT = D3.D3_SOLICIT"
	EndIf		
	
	cQuery += " AND D3.D3_CC BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	cQuery += " AND D3.D3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQuery += " AND D3.D3_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
	cQuery += " AND D3.D3_LOCAL = '"+MV_PAR05+"'"
	cQuery += " AND D3.D3_GRUPO BETWEEN '"+mv_par08+"' AND '"+mv_par09+"'"
	cQuery += " AND D3.D3_HORAFIM BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"
	cQuery += " AND D3.D3_TURNO BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
	cQuery += " AND D3.D_E_L_E_T_ = ''"
	cQuery += " AND B1.D_E_L_E_T_ = ''"
	
	If mv_par14==1 //agrupado ? sim
		cQuery += " GROUP BY D3.D3_COD, B1.B1_DESC ,D3_ORDEM, D3_MAQUINA"
	EndIf

	If aReturn[8] == 1 //Produto
		cQuery += " ORDER BY D3.D3_COD "
	ElseIf aReturn[8] == 2
		cQuery += " ORDER BY D3_QUANT DESC"
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TRA1" 
	MemoWrit('C:\TEMP\EST142.SQL',cQuery)
	
	If mv_par14!=1
		TCSETFIELD("TRA1","D3_EMISSAO","D") //muda de string para date
	EndIf
	
	TRA1->(DbGotop())     
	
Return