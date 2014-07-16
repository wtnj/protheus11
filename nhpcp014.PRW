#INCLUDE "TOPCONN.CH"  
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHPCP014   ºAutor ³João Felipe         º Data ³  26/05/2008º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE OBSERVACOES DO RELEASE			              º±±
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

USER Function NHPCP014()

cString   := "ZAP"
cDesc1    := OemToAnsi("Este   relatorio   tem   como   objetivo  Imprimir ")
cDesc2    := OemToAnsi("as observações inseridas no release dentro  de  um ")
cDesc3    := OemToAnsi("período.")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "PCP014"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("OBSERVAÇÕES DO RELEASE X ENTREGAS")
cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHPCP014"
_cPerg    := "PCP014" 
 
Pergunte(_cPerg,.F.)
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

//Processa( {|| Gerando()     },"Gerando Dados para a Impressao") 
Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Return

Static Function RptDetail()
Local _aObs := {}
Local _aRlse := {}
Local _aEntr := {}
Local _cItem, cCAMPO
Local x := 1 

ZAP->(DbSetOrder(1)) //FILIAL + NUM + ITEM + PROD
ZAP->(DbSeek(xFilial("ZAP")+ZAO->ZAO_NUM) )    

cabec2    := OemToAnsi(" Dia         Release      Saida    Observacao")

While ZAP->(!EOF()) .AND. ZAP->ZAP_NUM == ZAO->ZAO_NUM

	_cItem := "Item: "+ZAP->ZAP_ITEM + " - " + RTRIM(ZAP->ZAP_PROD) + " - " + ZAP->ZAP_DESC
	
	cabec1    := OemToAnsi(" RI-WHB: ") + ZAO->ZAO_NUM +"   "+_cItem

	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		
	ZAR->(DbSetOrder(1)) //filial + num + prod + dia
	For x := 1 to 31
		ZAR->(DbSeek(xFilial("ZAR")+ZAP->ZAP_NUM+ZAP->ZAP_PROD+STRZERO(x,2)))
		If ZAR->(Found())
			aAdd(_aObs,ZAR->ZAR_OBSERV)
		Else
			aAdd(_aObs,"--------------S/ OBS.--------------")			
		EndIf
		aAdd(_aEntr,fEntr(CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(Date()),4))))

	Next
		
	DbSelectArea("ZAP")	
    For X := 7 To 37
	    cCAMPO := "ZAP->" + Fieldname(X)
        Aadd(_aRlse,"Dia "+Right(cCAMPO,2)+": "+Transform(&(cCAMPO),"@e 999999999"))
    Next

    x:= 1
				
	While x <= 31

	    //Verifica se se a data inicial é menor que o dia X do mes e ano do release, e a data final se é maior
		If mv_par01 > CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4));
		   .Or. mv_par02 < CtoD(StrZero(x,2)+"/"+StrZero(ZAO->ZAO_MES,2)+"/"+StrZero(Year(ZAO->ZAO_DTFIM),4)) 
		   x++
		   Loop
		EndIf

		@ Prow()+1 , 001 Psay _aRlse[x]
		@ Prow()   , 020 psay _aEntr[x] PICTURE("@E 9999999999")
		@ Prow()   , 035 Psay _aObs[x]
		x++

	EndDo

	_aRlse := {}
	_aEntr := {}
	_aObs  := {}
                                                                   
	ZAP->(DbSkip())

EndDo

@ Prow()+1,000 PSAY __PrtThinLine()

Return(nil)		

Return

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
	
	If Select("TMR") > 0 
		TMR->(DbCloseArea())
	EndIf
	
	cQuery := " SELECT SUM(D2_QUANT) AS QUANT FROM "+RetSqlName("SD2")+" D2 "
	cQuery += " WHERE D2.D2_CLIENTE = '"+ZAO->ZAO_CLIENT+"'"
	cQuery += " AND D2.D2_LOJA = '"+ZAO->ZAO_LOJA+"'"
	cQuery += " AND D2.D2_COD = '"+ZAP->ZAP_PROD+"'"
	cQuery += " AND D2.D2_EMISSAO = '"+DTOS(_dData)+"'"
	cQuery += " AND D2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND D2.D_E_L_E_T_ = ' '"
//	cQuery += "	GROUP BY D2.D2_DOC"

	TCQUERY cQuery NEW ALIAS "TMR"
	
	If !Empty(TMR->QUANT)
		_nQuant := TMR->QUANT
	Else
		_nQuant := 0
	EndIf	
	
Return(_nQuant)