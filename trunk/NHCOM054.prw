/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM054  ºAutor  ³João Felipe da Rosa º Data ³  10/02/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PEDIDOS DE COMPRAS PARA EXCEL                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   

#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch" 

User Function NHCOM054()
Local cQuery
Private _cFitro  

If !Pergunte("COM054",.T.)
	Return
EndIf
     
cQuery := " SELECT *, "


cQuery += " (SELECT SUM(C1.C1_QUANT-C1.C1_QUJE) FROM "+RetSqlName("SC1")+" C1"
cQuery += " WHERE C1.C1_PRODUTO = C7.C7_PRODUTO "
cQuery += " AND C1.D_E_L_E_T_ = '' AND C1.C1_FILIAL = '"+xFilial("SC1")+"'"
cQuery += " AND C1.C1_RESIDUO = ''"
cQuery += " AND C1.C1_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DTOS(mv_par04)+"') AS C1_QUANT"

cQuery += " FROM "+RetSqlName("SC7")+" C7"
cQuery += " WHERE C7.C7_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND C7.C7_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
cQuery += " AND C7.C7_SIGLA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

If mv_par07 == 2 //Aberto
	cQuery += " AND C7.C7_QUJE < C7.C7_QUANT "
	cQuery += " AND C7.C7_RESIDUO = '' "
ElseIf mv_par07 == 3 //Residuo
	cQuery += " AND C7.C7_RESIDUO = 'S' "
ElseIf mv_par07 == 4 //Atendido
	cQuery += " AND C7.C7_QUJE = C7.C7_QUANT "
	cQuery += " AND C7.C7_ENCER = 'E'"
ElseIf mv_par07 == 5 //Atendido + Parcial
	cQuery += " AND C7.C7_QUJE < C7.C7_QUANT "
	cQuery += " AND C7.C7_ENCER != 'E'"
EndIf

cQuery += " AND C7.C7_DATPRF BETWEEN '"+DtoS(mv_par17)+"' AND '"+DtoS(mv_par18)+"'"
cQuery += " AND C7.C7_NUM BETWEEN '"+mv_par08+"' AND '"+mv_par09+"'"
If !Empty(AllTrim(mv_par12))
	cQuery += " AND C7.C7_USER = '"+mv_par12+"'"
EndIf

If mv_par10 == 1 //Ped. Compra
	cQuery += " AND  C7.C7_TIPO = 1 "
ElseIf mv_par10 == 2 //Aut. Entrega
	cQuery += " AND  C7.C7_TIPO = 2 "
EndIf

If mv_par11 == 1 // liberados
	cQuery += " AND C7.C7_CONAPRO = 'L' "
ElseIf mv_par11 == 2 //bloqueados
	cQuery += " AND C7.C7_CONAPRO = 'B' "
EndIf

cQuery += " AND C7.C7_FORNECE BETWEEN '"+mv_par15+"' AND '"+mv_par16+"'"
cQuery += " AND C7.D_E_L_E_T_ = '' AND C7.C7_FILIAL = '"+xFilial("SC7")+"'"

cQuery += " ORDER BY C7.C7_PRODUTO"

TCQUERY cQuery NEW ALIAS "TRA1"

TcSetField("TRA1","C7_EMISSAO","D")  // Muda a data de string para date    
TcSetField("TRA1","C7_DATPRF","D")  // Muda a data de string para date    

Processa({|| GeraPedExl()},"Aguarde. Exportando p/ Microsoft Excel...")

TRA1->(dbCloseArea())

Return

Static Function GeraPedExl()
Local cExcel
Local _nOutFile
Local _cLocal := SPACE(100)
Local _cPed
Local nTxMoeda
//Local nItemIPI
//Local nSalIPI
Local nVal1
Local nQuant_a_Rec
Local nTotal 
Local _cDesconto
Local _cIpi
Local _cTtcImp
Local _lRet := .F. 
Local cProd
Local aSoma := {0,0,0,0,0,0,0,0}

	//define a tela
	oDlg2 := MSDialog():New(0,0,120,310,"Local do Arquivo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
	//contorno
	oGroup := tGroup():New(005,005,40,153,,oDlg2,,,.T.)
		
	oSay4 := TSay():New(20,10,{||"Local"},oDlg2,,,,,,.T.,,)
	
	oGet1 := tGet():New(18,30,{|u| if(Pcount() > 0, _cLocal:= u,_cLocal)},oDlg2,118,8,"@!",/*valid*/,;
		,,,,,.T.,,,/* when */,,,,,,,"_cLocal")
    
	//botoes
    oBt1 := tButton():New(45,88,"Ok",oDlg2,{||oDlg2:End()},30,10,,,,.T.)      
    oBt2 := tButton():New(45,123,"Cancelar",oDlg2,{||_lRet:=.T.,oDlg2:End()},30,10,,,,.T.)

	oDlg2:Activate(,,,.T.,{||,.T.},,{||})

	If _lRet 
		Return
	EndIf	
	
	_cLocal := Alltrim(_cLocal)
	
	If !Right(_cLocal,1)$"\"
		_cLocal += "\"
	EndIf

	_nOutFile := Fcreate(_cLocal+"NHCOM054.xls",0)

	If !File(_cLocal+"NHCOM054.xls")
		Alert("Arquivo não pode ser criado!")
		Return
	EndIf

cExcel := '<html>'
cExcel += '<head></head>'
cExcel += '<body>'

//CABECALHO DO PEDIDO
cExcel += '<table border="1" style="font-size:12px">'
	
cExcel += '<tr style="font-weight:bold;background:#efefef">'
cExcel += '<td>Pedido</td>'
cExcel += '<td>Ítem</td>'
cExcel += '<td>Código</td>'
cExcel += '<td>Descrição</td>'
cExcel += '<td>Almoxarifado</td>'  	
cExcel += '<td>C.Custo</td>'
cExcel += '<td>Conta Contabil</td>'
cExcel += '<td>Fornec./Loja</td>'
cExcel += '<td>Desc. Fornecedor</td>'
cExcel += '<td>Emissão</td>'		
cExcel += '<td>Entrega</td>'
cExcel += '<td>Quant</td>'
cExcel += '<td>UM</td>'
cExcel += '<td>Vlr.</td>'
cExcel += '<td>Saldo</td>'
cExcel += '<td>Saldo Total</td>'
cExcel += '<td>Desconto</td>'
cExcel += '<td>IPI</td>'
cExcel += '<td>Total c/ Impostos</td>'
cExcel += '<td>Qtd. Entregue</td>'
cExcel += '<td>Qtd. Receber</td>'
cExcel += '<td>Elim. Residuo</td>'
cExcel += '<td>Sigla</td>'
cExcel += '<td>Usuário</td>'
cExcel += '<td>Quant S.C.</td>'
cExcel += '<td>Tel. Fornecedor </td>'
cExcel += '</tr>'

DBSELECTAREA('SB1')
DBSETORDER(1) //FILIAL + COD

dbSelectArea("SB5")
dbSetOrder(1)

//DbSelectArea("SC7")
//DBGOTOP()
//SET FILTER TO &(_cFiltro)

procRegua(TRA1->(RECCOUNT()))

WHILE TRA1->(!EOF())

	INCPROC("Gerando arquivo .xls")

	cProd := TRA1->C7_PRODUTO
	
	cExcel += '<tr>'
	cExcel += '<td style=mso-number-format:"@">'+TRA1->C7_NUM+'</td>'        	//pedido
	cExcel += '<td style=mso-number-format:"@">'+TRA1->C7_ITEM+'</td>'   		//item
	
	cExcel += '<td style=mso-number-format:"@">'+TRA1->C7_PRODUTO+'</td>' 		//codigo do produto
        
    DO CASE    
    
  	CASE mv_par14 == 1//"B1_DESC"//³ Impressao da descricao generica do Produto.  
        If SB1->(DbSeek(xFilial("SB1")+TRA1->C7_PRODUTO))
	       cExcel += '<td>'+ALLTRIM(SB1->B1_DESC)+'</td>'
	    EndIf
  	CASE mv_par14 == 2//"B5_CEME"	//³ Impressao da descricao cientifica do Produto.      
        If SB5->(dbSeek(XFILIAL("SB5")+TRA1->C7_PRODUTO))
			cExcel += '<td>'+ALLTRIM(SB5->B5_CEME)+'</td>'
		EndIf   
    OTHERWISE   // Descrição Normal da C7
        cExcel += '<td>'+Alltrim(TRA1->C7_DESCRI)+'</td>'  
    ENDCASE
	
	/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao generica do Produto.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(mv_par14) == "B1_DESC"
		If SB1->(DbSeek(xFilial("SB1")+TRA1->C7_PRODUTO))
			cExcel += '<td>'+ALLTRIM(SB1->B1_DESC)+'</td>'
	    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao cientifica do Produto.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf AllTrim(mv_par14) == "B5_CEME"
		If SB5->(dbSeek(XFILIAL("SB5")+TRA1->C7_PRODUTO))
			cExcel += '<td>'+ALLTRIM(SB5->B5_CEME)+'</td>'
		EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao do pedido							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf AllTrim(mv_par14) == "C7_DESCRI"
		cExcel += '<td>'+Alltrim(TRA1->C7_DESCRI)+'</td>'
	Else
		cExcel += '<td> - </td>'
	EndIf
	*/
	
	cExcel += '<td>'+TRA1->C7_LOCAL+'</td>' // Local

	cExcel += '<td>'+TRA1->C7_CC+'</td>'    // Centro de Custo
	
    cExcel += '<td style=mso-number-format:"@">'+TRA1->C7_CONTA+'</td>'  // Conta Contabil

	cExcel += '<td>'+TRA1->C7_FORNECE+' - '+TRA1->C7_LOJA+'</td>'
	
	DbSelectArea('SA2')
	DbSetOrder(1)//filial + cod + loja
	IF DbSeek(xFilial('SA2')+TRA1->C7_FORNECE+TRA1->C7_LOJA)
		cExcel += '<td>'+SA2->A2_NOME+'</td>'
	ELSE
		cExcel += '<td> - </td>'
	ENDIF

	cExcel += '<td>'+DTOC(TRA1->C7_EMISSAO)+'</td>' 	//emissao
	cExcel += '<td>'+DTOC(TRA1->C7_DATPRF)+'</td>' 	//data previsao

	cExcel += '<td>'+PtVirg(STR(TRA1->C7_QUANT))+'</td>' 	//quantidade
	cExcel += '<td>'+TRA1->C7_UM+'</td>'         	//unidade
		
	nTxMoeda := IIF(TRA1->C7_TXMOEDA > 0,TRA1->C7_TXMOEDA,Nil)
		
	If !Empty(TRA1->C7_REAJUST)
		nVal1 := xMoeda(Formula(TRA1->C7_REAJUST),TRA1->C7_MOEDA,mv_par13,TRA1->C7_DATPRF,,nTxMoeda)
	Else
		nVal1 := xMoeda(TRA1->C7_PRECO,TRA1->C7_MOEDA,mv_par13,TRA1->C7_DATPRF,,nTxMoeda)
	Endif

	cExcel += '<td>'+PtVirg(STR(nVal1))+'</td>' //val unitario
		
	cExcel += '<td>'+PtVirg(STR(TRA1->C7_QUANT - TRA1->C7_QUJE))+'</td>' //Saldo

	cExcel += '<td>'+PtVirg(STR((TRA1->C7_QUANT - TRA1->C7_QUJE)*nVal1))+'</td>' //Saldo Total
		
	//nItemIPI := CalcIPI()[1] 
	//nSalIPI := CalcIPI()[2]
       
    _cDesconto := Str(xMoeda(TRA1->C7_VLDESC,TRA1->C7_MOEDA,mv_par13,TRA1->C7_DATPRF,,nTxMoeda))          
	cExcel += '<td>'+PtVirg(_cDesconto)+'</td>' //desconto 
	
	_cIpi := Str(xMoeda(TRA1->C7_IPI,TRA1->C7_MOEDA,mv_par13,TRA1->C7_DATPRF,,nTxMoeda))
	cExcel += '<td>'+PtVirg(_cIpi)+'</td>' //ipi
		
	nTotal := (nVal1 + xMoeda(TRA1->C7_IPI,TRA1->C7_MOEDA,mv_par13,TRA1->C7_DATPRF,,nTxMoeda)) * TRA1->C7_QUANT
		                                                 
	_cTtcImp := Str(nTotal)
	cExcel += '<td>'+PtVirg(_cTtcImp)+'</td>' //total c/ impostos

	cExcel += '<td>'+PtVirg(STR(TRA1->C7_QUJE))+'</td>' //quantidade entregue

	nQuant_a_Rec := If(Empty(TRA1->C7_RESIDUO),IIF(TRA1->C7_QUANT-TRA1->C7_QUJE<0,0,TRA1->C7_QUANT-TRA1->C7_QUJE),0)
	cExcel += '<td>'+PtVirg(STR(nQuant_a_Rec))+'</td>' //quantidade a receber

    cExcel += '<td>'+If(Empty(TRA1->C7_RESIDUO),'Nao','Sim')+'</td>' //residuo eliminado
	cExcel += '<td>'+TRA1->C7_SIGLA+'</td>' //SIGLA
	cExcel += '<td>'+TRA1->C7_USER+'</td>' //USUARIO
	cExcel += '<td>'+AllTrim(STR(TRA1->C1_QUANT))+'</td>' //QUANTIDADE SOMADA DA SC
	If SA2->(DbSeek(xFilial("SA2")+ TRA1->(C7_FORNECE + C7_LOJA) ))
 		cExcel += '<td style:mso-number-format:"@">' + Alltrim(SA2->A2_TEL) + '</td>' // Telefone do Fornecedor
 	EndIf
	cExcel += '</tr>'  

	aSoma[1] += TRA1->C7_QUANT
	aSoma[2] += (TRA1->C7_QUANT - TRA1->C7_QUJE)
	aSoma[3] += ((TRA1->C7_QUANT - TRA1->C7_QUJE)*nVal1)
	aSoma[4] += Val(_cDesconto)
	aSoma[5] += Val(_cIpi)
	aSoma[6] += Val(_cTtcImp)
	aSoma[7] += TRA1->C7_QUJE
	aSoma[8] += nQuant_a_Rec
	
	TRA1->(DBSKIP())	
	
	If TRA1->C7_PRODUTO != cProd
		cExcel += '<tr style="background:#666666;color:#ffffff">'
		cExcel += '<td>TOTAL:</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>'+cProd+'</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>'+Str(aSoma[1])+'</td>' //quantidade
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>'+PtVirg(Str(aSoma[2]))+'</td>' //saldo qtd
		cExcel += '<td>'+PtVirg(Str(aSoma[3]))+'</td>' //saldo total
		cExcel += '<td>'+PtVirg(Str(aSoma[4]))+'</td>' //desconto
		cExcel += '<td>'+PtVirg(Str(aSoma[5]))+'</td>' //ipi
		cExcel += '<td>'+PtVirg(Str(aSoma[6]))+'</td>' //total c imposto
		cExcel += '<td>'+PtVirg(Str(aSoma[7]))+'</td>' //qtd entregue
		cExcel += '<td>'+PtVirg(Str(aSoma[8]))+'</td>' //qtd a receber
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '<td>&nbsp;</td>'
		cExcel += '</tr>'
		
		aSoma := {0,0,0,0,0,0,0,0}
		
	EndIf
    
	Fwrite(_nOutFile,cExcel)
	
	cExcel := ''

ENDDO

cExcel += '</table>

Fclose(_nOutFile)
   
//ABRE O EXCEL 
ShellExecute( "open", "excel.exe",_cLocal+"NHCOM054.xls","",5 )  

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CALCIPI  ³ Autor ³ Marcos Bregantim      ³ Data ³ 30.08.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do IPI                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function CalcIPI()
Local nToTIPI	:= 0,nTotal,nSalIPI:= 0
Local nValor 	:= (TRA1->C7_QUANT) * IIf(Empty(TRA1->C7_REAJUST),TRA1->C7_PRECO,Formula(TRA1->C7_REAJUST))
Local nSaldo 	:= (TRA1->C7_QUANT-TRA1->C7_QUJE) * IIf(Empty(TRA1->C7_REAJUST),TRA1->C7_PRECO,Formula(TRA1->C7_REAJUST))
Local nTotDesc := TRA1->C7_VLDESC

If cPaisLoc <> "BRA"
	nSalIPI := (TRA1->C7_QUANT-TRA1->C7_QUJE) * nItemIVA / TRA1->C7_QUANT
Else
	If nTotDesc == 0
		nTotDesc := CalcDesc(nValor,TRA1->C7_DESC1,TRA1->C7_DESC2,TRA1->C7_DESC3)
	EndIF
	nTotal := nValor - nTotDesc
	nTotIPI := IIF(TRA1->C7_IPIBRUT == "L",nTotal, nValor) * ( TRA1->C7_IPI / 100 )
    If Empty(TRA1->C7_RESIDUO)
	   nTotal := nSaldo - nTotDesc
	   nSalIPI := IIF(TRA1->C7_IPIBRUT == "L",nTotal, nSaldo) * ( TRA1->C7_IPI / 100 )
    Endif
EndIf

Return {nTotIPI,nSalIPI} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ RETIRA O PONTO E POE A VIRGULA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Static Function PtVirg(_cStr)
             
	If AT(".",_cStr) > 0
		_cStr := Stuff(_cStr,AT(".",_cStr),1,",")
	EndIf
		
Return _cStr