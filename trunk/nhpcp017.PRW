/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHPCP017   ºAutor ³João Felipe         º Data ³  03/10/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE PERFORMANCE ENTREGAS AOS CLIENTES             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH"

User Function NHPCP017()   

cString   := "ZAO"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("a performance geral das entregas dentro do ano.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHPCP017"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE PERFORMENCE DAS ENTREGAS AOS CLIENTES")
cabec1    := OemToAnsi(" Cliente - Descrição")
cabec2    := OemToAnsi("     Item                                                               Previsao       Entregue      Diferença  Performance")
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHPCP017"
_cPerg    := "PCP017" 
 
// mv_par01 do cliente
// mv_par02 até cliente
// mv_par03 da loja
// mv_par04 até loja
// mv_par05 de data
// mv_par06 até data
// mv_par07 de GRUPO
// mv_par08 até GRUPO

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

RptStatus({|| RptDetail() },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()

// variáveis
_cNum       := "" 
_cDt1       := DATE()
_cDt2       := DATE()
_nTEntr     := 0 //total entregue
_nTPrev     := 0 //total previsto  
_nEntr      := 0
_nPrev      := 0
_proddesc   := SPACE(30)
_nTEntGeral := 0
_nTPrvGeral := 0

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

DbSelectArea('SA1')
DbSetOrder(1) //filial + cli + loja
DbGoTop()

DbSelectArea('ZAO')
DbSetOrder(1) //filial + num
DbGoTop()

DbSelectArea('ZAP')
DbSetOrder(1) //filial + num + item
DbGoTop()
 
SETREGUA(ZAO->(RECCOUNT()))

SB1->(DBSETORDER(1))

While ZAO->(!Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FILTRA POR CLIENTE ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ZAO->ZAO_CLIENT < mv_par01 .Or. ZAO->ZAO_CLIENT > mv_par02
		ZAO->(DBSKIP())
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FILTRA POR LOJA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ZAO->ZAO_LOJA < mv_par03 .Or. ZAO->ZAO_LOJA > mv_par04
		ZAO->(DBSKIP())
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FILTRA POR MES ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ZAO->ZAO_MES < MONTH(mv_par05) .Or. ZAO->ZAO_MES > MONTH(mv_par06)
		ZAO->(DBSKIP())
		Loop
	EndIf   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FILTRA POR ANO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If YEAR(ZAO->ZAO_DTINI) < YEAR(mv_par05) .Or. YEAR(ZAO->ZAO_DTINI) > Year(mv_par06)
		ZAO->(dbSkip())
		Loop
	EndIf
	
	INCREGUA()
   
	//pula página
	If Prow() > 70
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CALCULA ENTRADA E PREVISAO DO ITEM³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	ZAP->(DbSeek(xFilial('ZAP')+ZAO->ZAO_NUM))
        
	lPrim := .T.

	While ZAP->ZAP_NUM == ZAO->ZAO_NUM

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FILTRA POR GRUPO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(DbSetOrder(1)) //FILIAL + COD
		SB1->(DbSeek(xFilial("SB1")+ZAP->ZAP_PROD))
		
		If SB1->(Found()) 
			IF SB1->B1_GRUPO < MV_PAR07 .OR. SB1->B1_GRUPO > MV_PAR08
				ZAP->(DBSKIP())
				LOOP
			ENDIF
		ENDIF

		If lPrim
			//imprime cliente
			@Prow()+1, 001 psay ZAO->ZAO_CLIENT+" - "+ZAO->ZAO_LOJA
		
			If SA1->(DbSeek(xFilial('SA1')+ZAO->ZAO_CLIENT+ZAO->ZAO_LOJA))
				@Prow()  , 014 psay SA1->A1_NOME
			EndIf
			lPrim := .F.
		EndIf

		IF SB1->(DBSEEK(XFILIAL('SB1')+ZAP->ZAP_PROD))
			_proddesc := SB1->B1_DESC
		ENDIF
				
		@Prow()+1, 005 psay ZAP->ZAP_ITEM+"  "+ZAP->ZAP_PROD+SUBSTR(_proddesc,1,30)

		_nEntr := 0
		_nPrev := 0
		
		for _x := 1 to 31
            
			_cD  := STRZERO(_x,2) 				 	 //dia
			_cM  := TRANSFORM(ZAO->ZAO_MES,"@E 99")  //mes
			_cA  := STR(YEAR(ZAO->ZAO_DTFIM),4)      //ano
			
			_dDt := CTOD(_cD+"/"+_cM+"/"+_cA) //Data a verificar entrada e previsao
			
			//Filtra
			If _dDt >= mv_par05 .AND. _dDt <= mv_par06

				_cfield := "ZAP->ZAP_PREV"+STRZERO(_x,2)
				_nPrev += &(_cfield)  //SOMA PREVISAO DESTE ÍTEM NO PERÍODO	
				_nEntr += fEntr(_dDt) //SOMA ENTRADA  DESTE ITEM NO PERÍODO

			EndIf

		next
		
		@Prow()  , 070 psay _nPrev Picture("@e 9999999")
		@Prow()  , 085 psay _nEntr Picture("@e 9999999")
		@Prow()  , 100 psay _nEntr - _nPrev Picture("@e 9999999")
		@Prow()  , 115 psay Transform((_nEntr * 100) / _nPrev,"@e 999%")
		_nTEntr += _nEntr
		_nTPrev += _nPrev
		
		ZAP->(DbSkip())
	EndDo

	If !lPrim
		@Prow()+1, 001 psay "Total: --> " 
		@Prow()  , 115 psay Transform((_nTEntr * 100)/_nTPrev,"@e 999%")
		@Prow()+1,   0 psay ""
	EndIf	

	_nTEntGeral +=  _nTEntr
	_nTPrvGeral +=  _nTPrev

	_nTEntr := 0
	_nTPrev := 0
	
	ZAO->(DbSkip())
EndDo

@Prow()+1,000 PSAY __PrtThinLine()  
@Prow()+1, 001 psay "Total Geral: --> " 
@Prow()  , 070 psay _nTPrvGeral Picture("@e 9999999")
@Prow()  , 085 psay _nTEntGeral Picture("@e 9999999")
@Prow()  , 113 psay Transform((_nTEntGeral * 100)/_nTPrvGeral,"@e 99999%")


Return(nil)

//*****************************************************//
//													   //
// Funcao que traz a quantidade  de  pecas  que  foram //
// entregues E acumula o total de pecas entregues,     //
// usando a data da entrega como parametro             //
//													   //
//*****************************************************//

Static Function fEntr(_dData)
Local _dData
Local cQuery 
Local _nQuant := 0
	
	If Select("TMR") > 0 
		TMR->(DbCloseArea())
	EndIf
	
	//VERIFICA O QUE SAIU DE PRODUTO
	cQuery := " SELECT D2.D2_DOC, SUM(D2_QUANT) AS QUANT "
	cQuery += " FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SF2")+" F2 "
	cQuery += " WHERE F2.F2_DOC = D2.D2_DOC "
	cQuery += " AND F2.F2_SERIE = D2.D2_SERIE "
	cQuery += " AND F2.F2_CLIENTE = D2.D2_CLIENTE "
	cQuery += " AND F2.F2_LOJA = D2.D2_LOJA "
	cQuery += " AND D2.D2_CLIENTE = '"+ZAO->ZAO_CLIENT+"'"
	cQuery += " AND D2.D2_LOJA = '"+ZAO->ZAO_LOJA+"'"
	cQuery += " AND D2.D2_COD = '"+ZAP->ZAP_PROD+"'"

	If !Empty(ALLTRIM(ZAP->ZAP_PEDCLI))
		cQuery += " AND F2.F2_PCCLI = '"+ZAP->ZAP_PEDCLI+"'"
	EndIf
	
	cQuery += " AND D2.D2_EMISSAO = '"+DTOS(_dData)+"'"
	cQuery += " AND D2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND D2.D_E_L_E_T_ = ' '" 
	cQuery += " AND F2.D_E_L_E_T_ = ' '"	
	cQuery += "	GROUP BY D2.D2_DOC"

	TCQUERY cQuery NEW ALIAS "TMR"
	  
	TMR->(DBGOTOP())
	
	WHILE TMR->(!EOF())
		
		_nQuant += TMR->QUANT
                     
    	IF SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
    		
			IF !(ZAO->ZAO_CLIENT$"900004" .AND. ZAO->ZAO_LOJA$"02") .AND. ;
			   !(ZAO->ZAO_CLIENT$"900003" .AND. ZAO->ZAO_LOJA$"02") .AND. ;
			   !(ZAO->ZAO_CLIENT$"900025" .AND. ZAO->ZAO_LOJA$"02") .AND. ;
			   !(ZAO->ZAO_CLIENT$"900022" .AND. ZAO->ZAO_LOJA$"01") .AND. ;
			   !(ZAO->ZAO_CLIENT$"000012" .AND. (ZAO->ZAO_LOJA$"02" .OR. ZAO->ZAO_LOJA$"03"))

				IF Select("TMT") > 0
					TMT->(DbCloseArea("TMT"))
				ENDIF
				
				//VERIFICA O QUE HOUVE DE DEVOLUÇÃO DO PRODUTO
				cQuery2 := " SELECT SUM(D1_QUANT) AS QUANT FROM "+RetSqlName("SD1")+" D1 "
				cQuery2 += " WHERE D1.D1_TIPO = 'D' "//DEVOLUCAO
				cQuery2 += " AND D1.D1_FORMUL = 'S' "// ENTRADA COM A PRÓPRIA NOTA
				cQuery2 += " AND D1.D1_FORNECE = '"+ZAO->ZAO_CLIENT+"'"
				cQuery2 += " AND D1.D1_LOJA = '"+ZAO->ZAO_LOJA+"'"
				cQuery2 += " AND D1.D1_COD = '"+ZAP->ZAP_PROD+"'"
				cQuery2 += " AND D1.D1_NFORI = '"+TMR->D2_DOC+"'"
				cQuery2 += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
				cQuery2 += " AND D1.D_E_L_E_T_ = ' '"
			
				TCQUERY cQuery2 NEW ALIAS "TMT"
		
				If !Empty(TMT->QUANT)
					_nQuant -= TMT->QUANT
				EndIf	
			EndIf	
		EndIf	
		TMR->(DBSKIP())
	ENDDO


Return(_nQuant)

	
