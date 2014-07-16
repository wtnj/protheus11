
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST110   ºAutor ³João Felipe         º Data ³  29/01/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE DIVERGÊNCIA DE KARDEX                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "TOPCONN.CH"

User Function NHEST110()
Private oRelato 
Private _aMat := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SD3"
    oRelato:cPerg    := "EST110"
	oRelato:cNomePrg := "NHEST110"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "M"

	//descricao
	oRelato:cDesc1   := "Apresenta as divergências dos saldos"
	oRelato:cDesc2   := ""
	oRelato:cDesc3   := ""

	//titulo
	oRelato:cTitulo  := "DIVERGÊNCIA DE KARDEX"

	//cabecalho
	oRelato:cCabec1  := cabec1    := " Produto            Documento       Tabela        Numseq         Data        Localiz.        Lote      Tipo    Quantidade "
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

	// mv_par01 DE PROD
	// mv_par02 ATE PROD
	// mv_par03 DE MES/ANO
	// mv_par04 ATE MES/ANO
	// mv_par05 DE LOTE 
	// mv_par06 ATE LOTE
	// mv_par07 DE LOCAL
	// mv_par08 ATE LOCAL
	
Return

Static Function Imprime()
//Local dDtIni := CtoD("01/"+Substr(MV_PAR03,1,2)+"/"+Substr(MV_PAR03,4,4))
//Local dDtFim := CtoD("01/"+Substr(MV_PAR04,1,2)+"/"+Substr(MV_PAR04,4,4))
//Local dtFech //data do fechamento
//Local dDtDia := dDtIni //data que irá pular dia a dia
//Local dDtMes := dDtIni //data que irá pular mes a mes

	cQuery := "SELECT B1_COD, B1_DESC FROM "+RetSqlName("SB1")+" B1 "
	cQuery += " WHERE B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND B1_LOCALIZ = 'S'"
	cQuery += " AND B1_RASTRO = 'L'"
	cQuery += " AND D_E_L_E_T_ = ''"
	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " ORDER BY B1_COD"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(dbGoTop())
	
	ProcRegua(TRA1->(RecCount()))

	While TRA1->(!EOF())

		IncProc()
		
		cQuery := " SELECT D3.D3_COD, D3.D3_DOC, D3.D3_TM, D3.D3_LOCAL, D3.D3_NUMSEQ, D3.D3_LOTECTL, D3.D3_EMISSAO, D3.D3_QUANT, D3.D3_LOCALIZ"
		cQuery += " FROM "+RetSqlName("SD3")+" D3"
		cQuery += " WHERE D3_COD = '"+TRA1->B1_COD+"'"
		cQuery += " AND D3_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
		cQuery += " AND D3_LOTECTL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
		cQuery += " AND D3_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		cQuery += " AND D_E_L_E_T_ = ''"
		cQuery += " AND D3_TM <> '101'"
		cQuery += " AND D3_ESTORNO <> 'S'"
		cQuery += " AND D3_COD NOT IN ("
		cQuery += " 	SELECT DB_PRODUTO "
		cQuery += "     FROM "+RetSqlName("SDB")
		cQuery += " 	WHERE DB_PRODUTO = D3.D3_COD"
		cQuery += " 	AND DB_DOC = D3_DOC"
		cQuery += " 	AND DB_LOCAL = D3_LOCAL"
		cQuery += " 	AND DB_NUMSEQ = D3_NUMSEQ"
		cQuery += " 	AND DB_ESTORNO <> 'S'"
		cQuery += " 	AND D_E_L_E_T_ = ''"
		cQuery += " )"
		cQuery += " ORDER BY D3_EMISSAO, D3_LOCAL, D3_QUANT"
		
		TCQUERY cQuery NEW ALIAS "TRB"
		
		TRB->(dbGoTop())
		
		WHILE TRB->(!EOF())
			aAdd(_aMat,{TRB->D3_COD,TRB->D3_DOC, "(SDB Ausente)",TRB->D3_NUMSEQ,TRB->D3_EMISSAO,TRB->D3_LOCALIZ, TRB->D3_LOTECTL , TRB->D3_TM,TRB->D3_QUANT,TRB->D3_LOCAL})
			TRB->(dbSkip())
		ENDDO		
		
		cQuery := " SELECT D3.D3_COD, D3.D3_DOC, D3.D3_TM, D3.D3_LOCAL, D3.D3_NUMSEQ, D3.D3_LOTECTL, D3.D3_EMISSAO, D3.D3_QUANT, D3.D3_LOCALIZ"
		cQuery += " FROM "+RetSqlName("SD3")+" D3"
		cQuery += " WHERE D3_COD = '"+TRA1->B1_COD+"'"
		cQuery += " AND D3_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
		cQuery += " AND D3_LOTECTL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
		cQuery += " AND D3_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		cQuery += " AND D_E_L_E_T_ = ''"
		cQuery += " AND D3_TM <> '101'"
		cQuery += " AND D3_ESTORNO <> 'S'"
		cQuery += " AND D3_COD NOT IN ("
		cQuery += " 	SELECT D5_PRODUTO"
		cQuery += " 	FROM "+RetSqlName("SD5")
		cQuery += " 	WHERE D5_PRODUTO = D3.D3_COD"
		cQuery += " 	AND D5_DOC = D3.D3_DOC"
		cQuery += " 	AND D5_LOCAL = D3.D3_LOCAL"
		cQuery += " 	AND D5_NUMSEQ = D3.D3_NUMSEQ"
		cQuery += " 	AND D5_ESTORNO <> 'S'"
		cQuery += " 	AND D_E_L_E_T_ = ''"
		cQuery += " )"
		cQuery += " ORDER BY D3_EMISSAO, D3_LOCAL, D3_QUANT"		
		
		TCQUERY cQuery NEW ALIAS "TRC"
		
		TRC->(dbGoTop())
		
		WHILE TRC->(!EOF())
			aAdd(_aMat,{TRC->D3_COD,TRC->D3_DOC, "(SD5 Ausente)",TRC->D3_NUMSEQ,TRC->D3_EMISSAO,TRC->D3_LOCALIZ, TRC->D3_LOTECTL , TRC->D3_TM,TRC->D3_QUANT,TRC->D3_LOCAL})
			TRC->(dbSkip())
		ENDDO		
                       
		TRB->(dbCloseArea())
		TRC->(dbCloseArea())

		TRA1->(dbSkip())	
		
	EndDo

	TRA1->(dbCloseArea())
	
	RptStatus({|| RptDetail() }, "Imprimindo ...")

Return

/*

cQuery := "SELECT D3.D3_COD, D3.D3_DOC, D3.D3_TM, D3.D3_LOCAL, D3.D3_NUMSEQ, D3.D3_LOTECTL, D3.D3_EMISSAO, D3.D3_QUANT, D3.D3_LOCALIZ"
cQuery += " FROM "+RetSqlName('SD3')+" D3, "+RetSqlName('SB1')+" B1"
cQuery += " WHERE D3.D3_COD = B1.B1_COD"
cQuery += " AND D3.D3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" 
cQuery += " AND D3.D3_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'" 
cQuery += " AND D3.D3_LOTECTL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery += " AND D3.D3_ESTORNO <> 'S'" //Nao pega qdo estiver estornado
cQuery += " AND B1.B1_RASTRO = 'L'"
cQuery += " AND B1.B1_LOCALIZ = 'S'"
cQuery += " AND B1.D_E_L_E_T_ = ' ' AND D3.D_E_L_E_T_ = ' '" 

MemoWrit('C:\TEMP\NHEST110-A.SQL',cQuery)
TCQUERY cQuery NEW ALIAS 'TRA1'

Return



User Function OLDNHEST110()   

cString   := "SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("a relação de produtos que estão divergentes")
cDesc3    := OemToAnsi("nos kardex por dia, lote e endereço")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST110"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO DE DIVERGÊNCIA DE KARDEX") 
cabec1    := " Produto         Documento    Tabela    Numseq       Data    Localiz.     Lote     Tipo  Quantidade "
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST110"
_cPerg    := "EST110" 
_aMat 	  := {} 
_aMat2 	  := {} 
_cProd 	  := ""
_cPrd 	  := ""
_cDoc     := ""

// mv_par01 DE PROD
// mv_par02 ATE PROD
// mv_par03 DE DATA
// mv_par04 ATE DATA        
// mv_par05 DE LOTE 
// mv_par06 ATE LOTE

Pergunte(_cPerg,.F.)
titulo    +="   Data De "+Dtoc(mv_par03) + "  Ate  "+Dtoc(mv_par04)
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
Processa( {|| RptDetail()   },"Imprimindo...") 

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
Local _nTotal := 0


//-----------------------------------------------------------------------
// MONTA A QUERY PARA SD3
//-----------------------------------------------------------------------		

cQuery := "SELECT D3.D3_COD, D3.D3_DOC, D3.D3_TM, D3.D3_LOCAL, D3.D3_NUMSEQ, D3.D3_LOTECTL, D3.D3_EMISSAO, D3.D3_QUANT, D3.D3_LOCALIZ"
cQuery += " FROM "+RetSqlName('SD3')+" D3, "+RetSqlName('SB1')+" B1"
cQuery += " WHERE D3.D3_COD = B1.B1_COD"
cQuery += " AND D3.D3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" 
cQuery += " AND D3.D3_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'" 
cQuery += " AND D3.D3_LOTECTL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery += " AND D3.D3_ESTORNO <> 'S'" //Nao pega qdo estiver estornado
cQuery += " AND B1.B1_RASTRO = 'L'"
cQuery += " AND B1.B1_LOCALIZ = 'S'"
cQuery += " AND B1.D_E_L_E_T_ = ' ' AND D3.D_E_L_E_T_ = ' '" 
MemoWrit('C:\TEMP\NHEST110-A.SQL',cQuery)
TCQUERY cQuery NEW ALIAS 'TRA1'

//TcSetField("TRA1","QM2_VALDAF","D")  // TRANSFORMA DE STRING PARA DATA

If	!USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf
        
//-----------------------------------------------------------------------
// MONTA A QUERY PARA SDB
//-----------------------------------------------------------------------		

cQuery2 := "SELECT DB.DB_PRODUTO, DB.DB_DOC, DB.DB_TM, DB.DB_LOCAL, DB.DB_NUMSEQ, DB.DB_DATA, DB.DB_ORIGEM," 
cQuery2 += " SUM(DB.DB_QUANT) AS DB_QUANT, DB.DB_LOCALIZ"
cQuery2 += " FROM "+RetSqlName('SDB')+" DB, "+RetSqlName('SB1')+" B1"
cQuery2 += " WHERE DB.DB_PRODUTO = B1.B1_COD"
cQuery2 += " AND DB.DB_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" 
cQuery2 += " AND DB.DB_DATA BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
cQuery2 += " AND DB.DB_LOTECTL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery2 += " AND DB.DB_ESTORNO <> 'S'" //Nao pega qdo estiver estornado
cQuery2 += " AND B1.B1_RASTRO = 'L'"
cQuery2 += " AND B1.B1_LOCALIZ = 'S'"
cQuery2 += " AND B1.D_E_L_E_T_ = ' ' AND DB.D_E_L_E_T_ = ' '" 
cQuery2 += " GROUP BY DB.DB_PRODUTO, DB.DB_DOC, DB.DB_TM, DB.DB_LOCAL, DB.DB_NUMSEQ, DB.DB_DATA,DB.DB_LOCALIZ, DB.DB_ORIGEM"


MemoWrit('C:\TEMP\NHEST110-B.SQL',cQuery2)
TCQUERY cQuery2 NEW ALIAS 'TRB'

//TcSetField("TRA1","QM2_VALDAF","D")  // TRANSFORMA DE STRING PARA DATA

If	!USED()
	MsgBox(cQuery2+'. Query errada','Erro!!!','STOP')
EndIf

//-----------------------------------------------------------------------
// MONTA A QUERY PARA SD5
//-----------------------------------------------------------------------		

cQuery3 := "SELECT D5.D5_PRODUTO, D5.D5_DOC, D5.D5_ORIGLAN, D5.D5_LOCAL, D5.D5_NUMSEQ, D5.D5_DATA,"
cQuery3 += " SUM(D5.D5_QUANT) AS D5_QUANT,D5.D5_OP,D5.D5_SERIE"
cQuery3 += " FROM "+RetSqlName('SD5')+" D5, "+RetSqlName('SB1')+" B1"
cQuery3 += " WHERE D5.D5_PRODUTO = B1.B1_COD"
cQuery3 += " AND D5.D5_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" 
cQuery3 += " AND D5.D5_DATA BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
cQuery3 += " AND D5.D5_LOTECTL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery3 += " AND D5.D5_ESTORNO <> 'S'" //Nao pega qdo estiver estornado
cQuery3 += " AND B1.B1_RASTRO = 'L'"
cQuery3 += " AND B1.B1_LOCALIZ = 'S'" 
cQuery3 += " AND B1.D_E_L_E_T_ = ' ' AND D5.D_E_L_E_T_ = ' '" 
cQuery3 += " GROUP BY D5.D5_PRODUTO, D5.D5_DOC, D5.D5_ORIGLAN, D5.D5_LOCAL, D5.D5_NUMSEQ,"
cQuery3 += " D5_NUMSEQ, D5.D5_DATA,D5.D5_OP,D5.D5_SERIE"

MemoWrit('C:\TEMP\NHEST110-C.SQL',cQuery3)
TCQUERY cQuery3 NEW ALIAS 'TRC'

//TcSetField("TRA1","QM2_VALDAF","D")  // TRANSFORMA DE STRING PARA DATA

If	!USED()
	MsgBox(cQuery3+'. Query errada','Erro!!!','STOP')
EndIf

TRA1->(DbGotop())     
TRB->(DbGotop())  
TRC->(DbGotop())  
SDB->(DbSetOrder(1))//DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
SD5->(DbSetOrder(3))//D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
SD3->(DbSetOrder(3))//D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ
SD2->(DbSetOrder(1))//D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ
SDA->(DbSetOrder(1))//DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA
                                                                                       
While TRA1->(!Eof())

	SDB->(DbSeek(xFilial('SDB')+TRA1->(D3_COD+D3_LOCAL+D3_NUMSEQ)))
	If TRA1->D3_TM == '502'
		If SDB->(!Found())
			aAdd(_aMat,{TRA1->D3_COD,TRA1->D3_DOC, "SD3->SDB",TRA1->D3_NUMSEQ,TRA1->D3_EMISSAO,TRA1->D3_LOCALIZ, TRA1->D3_LOTECTL , TRA1->D3_TM,TRA1->D3_QUANT,TRA1->D3_LOCAL+" -> 10"})
		EndIF
	Else
		If SDB->(!Found())
			SDA->(DbSeek(xFilial('SDA')+TRA1->(D3_COD+D3_LOCAL+D3_NUMSEQ+D3_DOC)))
			If SDA->(Found())
				If SDA->DA_SALDO == 0
					aAdd(_aMat,{TRA1->D3_COD,TRA1->D3_DOC, "SD3->SDB",TRA1->D3_NUMSEQ, TRA1->D3_EMISSAO,TRA1->D3_LOCALIZ, TRA1->D3_LOTECTL ,TRA1->D3_TM,TRA1->D3_QUANT})
				EndIf
			Else
				aAdd(_aMat,{TRA1->D3_COD,TRA1->D3_DOC, "SD3->SDB",TRA1->D3_NUMSEQ, TRA1->D3_EMISSAO,TRA1->D3_LOCALIZ, TRA1->D3_LOTECTL ,TRA1->D3_TM,TRA1->D3_QUANT})
			EndIf
		EndIF
	EndIf
	
   	SD5->(DbSeek(xFilial('SD5')+TRA1->(D3_NUMSEQ+D3_COD+D3_LOCAL)))//+D3_LOTECTL)))		
   	If SD5->(!Found())
   		aAdd(_aMat,{TRA1->D3_COD,TRA1->D3_DOC,"SD3->SD5",TRA1->D3_NUMSEQ,TRA1->D3_EMISSAO,TRA1->D3_LOCALIZ, TRA1->D3_LOTECTL ,TRA1->D3_TM,TRA1->D3_QUANT})
   	EndIf
	   	
   	TRA1->(DbSkip())

EndDo

While TRB->(!Eof())

	SDB->(DbSeek(xFilial('SDB')+TRB->(DB_PRODUTO+DB_LOCAL+DB_NUMSEQ)))
	If TRB->DB_ORIGEM$'SD3'
		If TRB->DB_LOCAL <> '10' 
			SD3->(DbSeek(xFilial('SD3')+TRB->(DB_PRODUTOD+DB_LOCAL+DB_NUMSEQ)))
			If SD3->(!Found())
				aAdd(_aMat,{TRB->DB_PRODUTO,TRB->DB_DOC, "SDB->SD3 ",TRB->DB_NUMSEQ,TRB->DB_DATA,TRB->DB_LOCALIZ, Iif(SDB->(Found()),SDB->DB_LOTECTL,"--      "),TRB->DB_TM,TRB->DB_QUANT})
			EndIf
		Else
	//-------SE ACHOU APONTAMENTO NO D3 VERIFICA SE A SOMA DAS QUANTIDADES NO DB SAO IGUAIS AS DO D3
			SD3->(DbSeek(xFilial('SD3')+TRB->(DB_PRODUTO+DB_LOCAL+DB_NUMSEQ)))
			If SD3->(Found()) 
				If TRB->DB_QUANT <> SD3->D3_QUANT
					aAdd(_aMat,{TRB->DB_PRODUTO,TRB->DB_DOC, "SDB->SD3",TRB->DB_NUMSEQ,TRB->DB_DATA, TRB->DB_LOCALIZ, Iif(SDB->(Found()),SDB->DB_LOTECTL,"--      ") ,TRB->DB_TM,TRB->DB_QUANT,"SDB->"+ALLTRIM(STR(TRB->DB_QUANT))+" SD3->"+ALLTRIM(STR(SD3->D3_QUANT))})
				EndIf
			EndIf
		EndIF		
	ElseIf TRB->DB_ORIGEM$'SC6/SD2'
			SD2->(DbSeek(xFilial('SD2')+TRB->(DB_PRODUTO+DB_LOCAL+DB_NUMSEQ)))
			If !SD2->(Found()) 
				aAdd(_aMat,{TRB->DB_PRODUTO,TRB->DB_DOC, "SDB->SD2",TRB->DB_NUMSEQ,TRB->DB_DATA, TRB->DB_LOCALIZ, Iif(SDB->(Found()),SDB->DB_LOTECTL,"--      ") ,TRB->DB_TM,TRB->DB_QUANT,"SDB->"+ALLTRIM(STR(TRB->DB_QUANT))+" SD3->"+ALLTRIM(STR(SD3->D3_QUANT))})
			EndIf
	EndIf 
	SD5->(DbSeek(xFilial('SD5')+TRB->(DB_NUMSEQ+DB_PRODUTO+DB_LOCAL)))
   	If SD5->(!Found()) 
   		aAdd(_aMat,{TRB->DB_PRODUTO,TRB->DB_DOC,"SDB->SD5",TRB->DB_NUMSEQ,TRB->DB_DATA,TRB->DB_LOCALIZ, Iif(SDB->(Found()),SDB->DB_LOTECTL,"--      "),TRB->DB_TM,TRB->DB_QUANT})
   	EndIf
	   	
   	TRB->(DbSkip())

EndDo

While TRC->(!Eof())
	
	SD5->(DbSeek(xFilial('SD5')+TRC->(D5_NUMSEQ+D5_PRODUTO+D5_LOCAL)))

	If TRC->D5_SERIE == ''
		If TRC->D5_LOCAL <> '10'
			SD3->(DbSeek(xFilial('SD3')+TRC->(D5_PRODUTO+D5_LOCAL+D5_NUMSEQ)))
			If SD3->(!Found())
				aAdd(_aMat,{TRC->D5_PRODUTO,TRC->D5_DOC, "SD5->SD3",TRC->D5_NUMSEQ,TRC->D5_DATA,"--      ", Iif(SD5->(Found()),SD5->D5_LOTECTL,"--    ")  ,TRC->D5_ORIGLAN,TRC->D5_QUANT})
			EndIf
		Else
			SD3->(DbSeek(xFilial('SD3')+TRC->(D5_PRODUTO+D5_LOCAL+D5_NUMSEQ)))
			If SD3->(Found())
				If TRC->D5_QUANT <> SD3->D3_QUANT
					aAdd(_aMat,{TRC->D5_PRODUTO,TRC->D5_DOC, "SD5->SD3",TRC->D5_NUMSEQ,TRC->D5_DATA,"--      ", Iif(SD5->(Found()),SD5->D5_LOTECTL,"--    ")  ,TRC->D5_ORIGLAN,TRC->D5_QUANT, "SD5->"+ALLTRIM(STR(TRC->D5_QUANT))+" SD3->"+ALLTRIM(STR(SD3->D3_QUANT))})
				EndIF
			EndIf
		EndIf
	EndIf
	SDB->(DbSeek(xFilial('SDB')+TRC->(D5_PRODUTO+D5_LOCAL+D5_NUMSEQ)))
	
	If TRC->D5_ORIGLAN == '502'
		If !SDB->(Found())
			aAdd(_aMat,{TRC->D5_PRODUTO,TRC->D5_DOC, "SD5->SDB",TRC->D5_NUMSEQ,TRC->D5_DATA,"--      ", Iif(SD5->(Found()),SD5->D5_LOTECTL,"--    ") ,TRC->D5_ORIGLAN,TRC->D5_QUANT})
		EndIf
	Else
//		SDB->(DbSeek(xFilial('SDB')+TRC->(D5_PRODUTO+D5_LOCAL+D5_NUMSEQ)))
		If !SDB->(Found())
			SDA->(DbSeek(xFilial('SDA')+TRC->(D5_PRODUTO+D5_LOCAL+D5_NUMSEQ+D5_DOC)))	
			If SDA->(Found())
				If SDA->DA_SALDO == 0
					aAdd(_aMat,{TRC->D5_PRODUTO, TRC->D5_DOC, "SD5->SDB",TRC->D5_NUMSEQ,TRC->D5_DATA,"--      ", Iif(SD5->(Found()),SD5->D5_LOTECTL,"--    ")  ,TRC->D5_ORIGLAN,TRC->D5_QUANT})
				EndIf
			Else
				aAdd(_aMat,{TRC->D5_PRODUTO, TRC->D5_DOC, "SD5->SDB",TRC->D5_NUMSEQ,TRC->D5_DATA,"--      ", Iif(SD5->(Found()),SD5->D5_LOTECTL,"--    ")  ,TRC->D5_ORIGLAN,TRC->D5_QUANT})
			EndIf		
		EndIF
	EndIf

   	TRC->(DbSkip())

EndDo

Return
*/


/*
aSort(_aMat,,,{|x,y|x[1]+x[2]+x[3] > y[1]+y[2]+x[3]}) //ordena por produto  DOCUMENTO e nunseq
For x:=1 to len (_aMat)

    If _cProd <> _aMat[x][1]+_aMat[x][2]+_aMat[x][4]
		aAdd(_aMat2,{ _aMat[x][1], _aMat[x][2],_aMat[x][3],_aMat[x][4], _aMat[x][5],Substr(_aMat[x][6],1,6),_aMat[x][7],_aMat[x][8],Transf(_aMat[x][9],"@E 9,999,999.99")})
	EndIF
	_cProd := _aMat[x][1]+_aMat[x][2]+_aMat[x][4]

Next

aSort(_aMat2,,,{|x,y|x[1]+x[5] > y[1]+y[5]}) //ordena por produto  e data
*/


Static Function RptDetail()
Local _aMat2 := {}

For y:=1 to len(_aMat)

	//procura no array se não existe a mesma ocorrência ausente na tabela SDB e na tabela SD5
	_n := aScan(_aMat,{|x| _aMat[y][1]==x[1] .AND. ; //mesmo produto
						   _aMat[y][2]==x[2] .AND. ; //mesmo documento
						   _aMat[y][3]!=x[3] .AND. ; //tabela diferente
						   _aMat[y][4]==x[4] .AND. ; //mesmo num seq
						   _aMat[y][6]==x[6] .AND. ; //mesma localiz
						   _aMat[y][7]==x[7] .AND. ; //mesmo lotectl
						   _aMat[y][9]==x[9]})       //mesma quant
						   
	If _n==0
		aAdd(_aMat2,_aMat[y])
	EndIf
						   
Next

//_aMat2 := aClone(_aMat)

oRelato:Cabec()

SetRegua(len(_aMat2))

For x:= 1 to len(_aMat2)

	IncRegua()

	If Prow() > 65
		oRelato:Cabec()
	Endif
   
		@ Prow() +1, 001 Psay Substr(_aMat2[x][1],1,15)	//PRODUTO
		@ Prow()   , 020 Psay _aMat2[x][2]   	    	//DOCUMENTO
		@ Prow()   , 033 Psay _aMat2[x][3] 	      		//TABELA
		@ Prow()   , 050 Psay AllTrim(_aMat2[x][4])		//NUMSEQ
		@ Prow()   , 062 Psay StoD(_aMat2[x][5])		//DATA
		@ Prow()   , 079 Psay Substr(_aMat2[x][6],1,6)  //LOCALIZ
		@ Prow()   , 090 Psay _aMat2[x][7]       		//LOTECTL
		@ Prow()   , 105 Psay _aMat2[x][8]       		//TIPO MOVIMENTAÇAO
		@ Prow()   , 112 Psay _aMat2[x][9] PicTure "@e 99999999" 	//QUANTIDADE
//		@ Prow()   , 108 Psay STR(_aMat2[x][9],12,2) 	//QUANTIDADE		
//		@ Prow()   , 104 Psay _aMat2[x][10]       	//MOTIVO				

Next 
@ Prow()+1,000 PSAY __PrtThinLine()

//TRA1->(DbCloseArea())          
//TRB->(DbCloseArea()) 
//TRC->(DbCloseArea()) 

Return(nil)                                 